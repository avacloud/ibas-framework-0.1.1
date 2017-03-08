@echo off
setlocal EnableDelayedExpansion
echo ***************************************************************************
echo      compile_and_package.bat
echo                     by niuren.zhu
echo                           2016.06.19
echo  ˵����
echo     1. ��װapache-maven�����ص�ַhttp://maven.apache.org/download.cgi��
echo     2. ��ѹapache-maven��������ϵͳ����MAVEN_HOMEΪ��ѹ�ĳ���Ŀ¼��
echo     3. ����PATH������%%MAVEN_HOME%%\bin�������JAVA_HOME�����Ƿ���ȷ��
echo     4. ������ʾ������mvn -v ��鰲װ�Ƿ�ɹ���
echo     5. �˽ű��������ǰĿ¼����Ŀ¼������pom.xml������jar����releaseĿ¼��
echo     6. ����compile_order.txt�ļ��е�������˳��
echo ****************************************************************************
REM ���ò�������
SET WORK_FOLDER=%~dp0
SET h=%time:~0,2%
SET hh=%h: =0%
SET OPNAME=%date:~0,4%%date:~5,2%%date:~8,2%_%hh%%time:~3,2%%time:~6,2%
SET LOGFILE=%WORK_FOLDER%compile_and_package_log_%OPNAME%.txt

echo --��ǰ������Ŀ¼��[%WORK_FOLDER%]
echo --������˳���ļ�[compile_order.txt]
if not exist %WORKFOLDER%compile_order.txt dir /a:d /b %WORKFOLDER% >%WORKFOLDER%compile_order.txt

echo --�����Ŀ��maven����
if not exist %WORK_FOLDER%release md %WORK_FOLDER%release
if exist %WORK_FOLDER%release\*.* del /f /s /q %WORK_FOLDER%release\*.*
call "%MAVEN_HOME%\bin\mvn" clean install >>%LOGFILE%

echo --��ʼ����[compile_order.txt]����
for /f %%m in (%WORKFOLDER%compile_order.txt) do (
  if exist %WORK_FOLDER%%%m\pom.xml (
    REM �ı䵱ǰ����Ŀ¼
    cd /d %WORK_FOLDER%%%m >>%LOGFILE%
    SET MY_PACKAGES_FOLDER=%%m
    if !MY_PACKAGES_FOLDER:~-8!==.service (
      REM ��վ������war��������jar������װ������
      echo --��ʼ����[%%m]
      call "%MAVEN_HOME%\bin\mvn" clean package -Dmaven.test.skip=true >>%LOGFILE%
      if exist %WORK_FOLDER%%%m\target\%%m*.war copy /y %WORK_FOLDER%%%m\target\%%m*.war %WORK_FOLDER%release >>%LOGFILE%
      REM ����jar������װ������
      for /f %%l in ('dir /s /a /b %WORK_FOLDER%%%m\target\%%m*.jar' ) do (
        copy /y %%l %WORK_FOLDER%release >>%LOGFILE%
      )
    ) else (
      REM ����վ������jar������װ������
      echo --��ʼ����[%%m]+��װ
      call "%MAVEN_HOME%\bin\mvn" clean package install -Dmaven.test.skip=true >>%LOGFILE%
      if exist %WORK_FOLDER%%%m\target\%%m*.jar copy /y %WORK_FOLDER%%%m\target\%%m*.jar %WORK_FOLDER%release >>%LOGFILE%
    )
    REM ��鲢���Ʊ�����
    
    if exist %WORK_FOLDER%release\%%m*.* (
      echo --����[%%m]�ɹ�
    ) else (
      echo --����[%%m]ʧ��
    )
  )
    
  REM ���õ�ǰ����Ŀ¼
  cd /d %WORK_FOLDER%
)

echo --������ɣ�������Ϣ��鿴[compile_and_package_log_%OPNAME%.txt]