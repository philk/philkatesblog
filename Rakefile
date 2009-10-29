def hekyll(opts = "")
  sh "rm -rf _site"
  sh "hekyll " + opts
end

desc "Build site using Hekyll"
task :build do
  hekyll
end

desc "Start up Hekyll server"
task :server do
  hekyll("--server --auto")
end

desc "Build and deploy"
task :deploy => :build do
  sh "rsync -rtzh --progress --delete _site/ hawk684@philkates.com:~/hekylltest"
end