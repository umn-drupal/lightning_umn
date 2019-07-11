<?php

/**
 * @file
 * Enables modules and site configuration for the Lightning Extender profile.
 */

use Drupal\Core\Config\FileStorage;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Routing\RouteMatchInterface;
use Symfony\Component\Yaml\Yaml;
use Drupal\user\Entity\Role;

/**
 * Implements hook_form_FORM_ID_alter().
 */
function lightning_umn_form_install_configure_form_alter(&$form, FormStateInterface $form_state) {
  // Account information defaults.
  $form['admin_account']['account']['name']['#default_value'] = 'oitadmin';
  $form['admin_account']['account']['mail']['#default_value'] = 'ucm@umn.edu';

  // Date/time settings.
  $form['regional_settings']['site_default_country']['#default_value'] = 'US';
  $form['regional_settings']['date_default_timezone']['#default_value'] = 'America/Chicago';

  // Turn off automatic update.
  $form['update_notifications']['enable_update_status_module']['#default_value'] = 0;

  // Hide admin password field.
  $form['admin_account']['account']['pass']['#type'] = 'hidden';
  $form['admin_account']['account']['pass']['#default_value'] = user_password(25);
}

/**
 * Implements hook_form_FORM_ID_alter().
 */
function lightning_umn_form_user_login_form_alter(&$form, FormStateInterface $form_state, $form_id) {
  if (!empty($form['simplesamlphp_auth_login_link'])) {
    $allowed_users = \Drupal::config('simplesamlphp_auth.settings')->get('allow');
    if (!$allowed_users['default_login'] || $allowed_users['default_login_users'] === '1') {
      $form['#prefix'] = t('<div class="status-messages"><div class="warning">Drupal username/password login is disabled. Please use the button below to log in with your University of Minnesota account.</div></div>');
      $form['simplesamlphp_auth_login_link']['#weight'] = -1;
      $form['name']['#attributes']['disabled'] = 'true';
      $form['pass']['#attributes']['disabled'] = 'true';
      $form['actions']['submit']['#attributes'] = ['disabled' => 'true'];
    }
  }
}

/**
 * Implements hook_help().
 *
 * Add some clarifying text to Layout Builder help.
 */
function lightning_umn_help($route_name, RouteMatchInterface $route_match) {
  if ($route_match->getRouteObject()->getOption('_layout_builder')) {
    $output = <<<HTML
      <p>Click "Add Section" to change your page layout.</p>
      <p>You can use the "Show content preview" checkbox below to show your content or a placeholder to make dragging content easier.</p>
HTML;

    return $output;
  }
}

/**
 * Reads in new configuration.
 *
 * Shamelessly stolen from Bootstrap Paragraphs
 * (http://drupal.org/project/bootstrap_paragraphs)
 *
 * @param string $config_name
 *   Configuration name.
 * @param string $module_path
 *   Base path.
 */
function lightning_umn_read_in_new_config($config_name, $module_path, $config_location = 'install') {
  /** @var \Drupal\Core\Config\StorageInterface $active_storage */
  $active_storage = \Drupal::service('config.storage');
  $active_storage->write($config_name, Yaml::parse(
    file_get_contents($module_path . '/config/' . $config_location . '/' . $config_name . '.yml')
  ));
}

/**
 * Helper function for saving field storage and field instance configs.
 *
 * @param array $config_list
 *   List of configurations to be saved.
 * @param string $module_path
 *   Base path.
 */
function lightning_umn_add_field_configs(array $config_list, $module_path, $config_location = 'install') {
  if (count($config_list) === 0) { return; }
  $config_storage = new FileStorage($module_path . '/config/' . $config_location);
  foreach ($config_list as $config) {
    $config_record = $config_storage->read($config);
    $entity_type = \Drupal::service('config.manager')->getEntityTypeIdByName(
      $config
    );
    /** @var \Drupal\Core\Config\Entity\ConfigEntityStorageInterface $storage */
    $storage = \Drupal::entityTypeManager()->getStorage($entity_type);
    $entity = $storage->createFromStorageRecord($config_record);
    $entity->save();
  }
}

/**
 * Helper function for changing editable configs.
 *
 * @param array $config_list
 *   List of configurations to be saved.
 * @param string $module_path
 *   Base path.
 */
function lightning_umn_edit_configs(array $config_list, $module_path, $config_location = 'install') {
  if (count($config_list) === 0) { return; }
  $config_factory = \Drupal::configFactory();
  $config_storage = new FileStorage($module_path . '/config/' . $config_location);
  foreach ($config_list as $config) {
    $editable = $config_factory->getEditable($config);
    $new_config = $config_storage->read($config);
    $editable->setData($new_config);
    $editable->save();
  }
}

function lightning_umn_perm_update($role, array $permissions) {
  $role = Role::load($role);
  foreach ($permissions as $permission) {
    $role->grantPermission($permission);
  }
  $role->save();
}
