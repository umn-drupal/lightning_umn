<?php
namespace Drupal\lightning_umn\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;

class InstallConfigurationForm extends FormBase {

  public function getFormId() {
    return 'lightning_umn_install_form';
  }

  public function buildForm(array $form, FormStateInterface $form_state) {
    $form['package'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Install Workflow Component'),
      '#description' => $this->t('This will install the Lightning Workflow module'),
    ];
    $form['actions'] = [
      'submit' => [
        '#type' => 'submit'
      ]
    ];

    return $form;
  }

  public function submitForm(array &$form, FormStateInterface $form_state) {
    // Do install of module
    drupal_set_message('this came from the submit handler!!!');
  }

}
