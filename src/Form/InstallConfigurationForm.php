<?php
namespace Drupal\lightning_umn\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;

class InstallConfigurationForm extends FormBase {

  public function getFormId() {
    return 'lightning_umn_install_form';
  }

  public function buildForm(array $form, FormStateInterface $form_state) {
    $form['#title'] = $this->t('Select components to install on this site.');
    $form['acquia'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Install site with Acquia settings'),
      '#default_value' => TRUE
    ];
    $form['drupal_lite'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Install as a Drupal Lite Site'),
    ];
    $form['workflow'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Install Lightning Workflow Components'),
    ];
    $form['folwell'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Install Folwell Components Modules'),
      '#default_value' => TRUE,
    ];
    $form['actions'] = [
      'submit' => [
        '#type' => 'submit',
        '#value' => $this->t('Submit'),
      ]
    ];

    return $form;
  }

  public function submitForm(array &$form, FormStateInterface $form_state) {
    $form_values = $form_state->getValues();
    $modules_to_install = [];
    $module_handler = \Drupal::service('module_handler');
    $module_installer = \Drupal::service('module_installer');
    if ($form_values['acquia']) {
      $modules_to_install[] = 'lightning_umn_acquia';
    }
    if ($form_values['folwell']) {
      $modules_to_install[] = 'folwell_paragraphs';
      $modules_to_install[] = 'folwell_blocks';
      $modules_to_install[] = 'folwell_wysiwyg';
    }
    if ($form_values['drupal_lite']) {
      $modules_to_install[] = 'lightning_umn_dlite';
    }
    if ($form_values['workflow']) {
      $modules_to_install[] = 'lightning_workflow';
    }
    foreach ($modules_to_install as $module) {
      if (!$module_handler->moduleExists($module)) {
        $module_installer->install([$module], TRUE);
      }
    }
     drupal_set_message('this came from the submit handler!!!');
  }

}
