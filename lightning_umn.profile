<?php

/**
 * @file
 * Enables modules and site configuration for the Lightning Extender profile.
 */

use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Routing\RouteMatchInterface;

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
 * Implements hook_form_FORM_ID_alter().
 */
function lightning_umn_form_node_layout_builder_form_alter(&$form, FormStateInterface $form_state, $form_id) {
  $form['actions']['preview_toggle']['toggle_content_preview']['#default_value'] = FALSE;
  $form['actions']['preview_toggle']['toggle_content_preview']['#value'] = FALSE;
}
