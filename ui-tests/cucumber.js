// Exportado direto (sem aninhar sob uma chave "default"): para arquivos de config ESM,
// o cucumber-js trata o proprio "export default" como o profile "default".
export default {
  import: ['src/support/**/*.js', 'src/steps/**/*.js'],
  paths: ['src/features/**/*.feature'],
  format: [
    'progress-bar',
    'html:reports/cucumber-report.html',
    'junit:reports/junit-report.xml',
  ],
};
