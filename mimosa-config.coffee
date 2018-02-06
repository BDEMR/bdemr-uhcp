exports.config = 
  modules: [
    'import-source'
    'copy'
    'coffeescript'
    'rename'
    'server'
  ]
  watch: 
    sourceDir: 'src'
    exclude: ['bower-assets']
    javascriptDir: null
    compiledDir: 'build-debug'
  server:
    port: 8005
    defaultServer:
      enabled: true
      onePage: true
    views:
      path: 'build-debug'
      compileWith: 'html',
      extension: '.html',
      
  rename:
    map: [
      [/(build-debug\\behaviors\\.*).js/g, '$1.coffee-compiled.js']
      [/(build-debug\\elements\\.*\\.*).js/g, '$1.coffee-compiled.js']
      [/(build-debug\\assets\\.*).js/g, '$1.coffee-compiled.js']
      [/(build-debug\\vendor-assets\\date-format-library).js/, '$1.coffee-compiled.js']
      [/(build-debug\\vendor-assets\\database-engine).js/, '$1.coffee-compiled.js']
    ]
  importSource:
    usePolling: false
    copy: [
      {
        from: 'src/bower-assets'
        to: 'build-debug/bower-assets'
      }
    ]
  
