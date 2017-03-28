<?php
use Drupal\Core\Form\FormStateInterface;

/**
 * @file
 * Enables modules and site configuration for the Lightning Extender profile.
 */

// Add any custom code here, like hook implementations.
function lightning_umn_form_install_configure_form_alter(&$form, FormStateInterface $form_state) {
  // Account information defaults
  $form['admin_account']['account']['name']['#default_value'] = 'oitadmin';
  $form['admin_account']['account']['mail']['#default_value'] = 'ucm@umn.edu';

  // Date/time settings
  $form['regional_settings']['site_default_country']['#default_value'] = 'US';
  $form['regional_settings']['date_default_timezone']['#default_value'] = 'America/Chicago';
}