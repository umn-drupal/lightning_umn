<?php
use Drupal\Core\Form\FormStateInterface;

/**
 * @file
 * Enables modules and site configuration for the Lightning Extender profile.
 */

// Add any custom code here, like hook implementations.
function lightning_umn_form_install_configure_form_alter(&$form, FormStateInterface $form_state)
{
    // Account information defaults
    $form['admin_account']['account']['name']['#default_value'] = 'oitadmin';
    $form['admin_account']['account']['mail']['#default_value'] = 'ucm@umn.edu';

    // Date/time settings
    $form['regional_settings']['site_default_country']['#default_value'] = 'US';
    $form['regional_settings']['date_default_timezone']['#default_value'] = 'America/Chicago';

    // Turn off automatic update
    $form['update_notifications']['enable_update_status_module']['#default_value'] = [0];

    // Hide admin password field
    $form['admin_account']['account']['pass']['#type'] = 'hidden';
    $form['admin_account']['account']['pass']['#default_value'] = user_password(25);
}

function lightning_umn_form_user_login_form_alter(&$form, FormStateInterface $form_state, $form_id)
{
    if (!empty($form['simplesamlphp_auth_login_link'])) {
        $allowed_users = \Drupal::config('simplesamlphp_auth.settings')->get('allow');
        if (!$allowed_users['default_login'] || $allowed_users['default_login_users'] === '1') {
            $form['name']['#attributes']['disabled'] = 'true';
            $form['pass']['#attributes']['disabled'] = 'true';
            $form['actions']['submit']['#attributes'] = ['disabled' => 'true'];
        }
    }
}
