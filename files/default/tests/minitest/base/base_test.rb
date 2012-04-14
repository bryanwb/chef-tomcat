class TestTomcatBase < MiniTest::Chef::TestCase

  def path
    "/usr/local/tomcat7-7.0.26"
  end
  
  def home_dir
    "/usr/local/tomcat/default"
  end

  def test_tomcat_home_dir
    assert File.readlink(home_dir) == path
  end

  def test_tomcat_base_path
    assert File.exists? path
    assert File.stat(path).nlink != 2
  end

  def test_tomcat_unpacked
    %w{ bin conf logs webapps work }.each do |dir|
      full_path = "#{path}/#{dir}"
      assert File.exists? full_path
    end
  end
end
