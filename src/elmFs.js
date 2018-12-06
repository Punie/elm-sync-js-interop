import * as BrowserFS from 'browserfs'
export default (cb) =>
  BrowserFS.configure({ fs: "LocalStorage", options: {} }, function (err) {
    window.fs = BrowserFS.BFSRequire("fs");
    fs.writeFileSync('/test.txt', 'Cool, I wrote this in browser and elm will read it!')
    const res = fs.readFileSync('/test.txt')

    const read = new Proxy({}, {
      get(target,name) {
        try {
          return fs.readFileSync(name).toString()
        } catch (err) {
          return err
        }
      },
      has(target,name) {
        return true
      }
    })

    const file = path => new Proxy({}, {
      get(target,content) {
        console.log('write', content, path)
        try {
          fs.writeFileSync(path, content)
          return true
        } catch (err) {
          return false
        }
      },
      has(target,name) {
        return true
      }
    })

    const write = new Proxy({}, {
      get(target,path) {
        return file(path)
      },
      has(target,name) {
        return true
      }
    })
    const elmFs = {read, write}

    cb(elmFs)
  });
