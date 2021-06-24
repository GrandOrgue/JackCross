#
# spec file for package mingw64-jack
#
# Copyright (c) 2014 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

%define versid 1.9.10-24-g042b6aa

Name:           mingw64-jack
Version:        1.9.10.24.g042b6aa
Release:        2.925
Summary:        Jack Audio Connection Kit
License:        GPL-2.0+
Group:          System/Sound Daemons
Url:            http://jackaudio.org/
Source:         jack-%{versid}.tar.xz
Patch1:         0001-Fix-build-without-portaudio.patch
Patch2:         0002-Use-dll-names-corresponding-to-the-code-on-Windows.patch
#!BuildIgnore: post-build-checks
BuildRequires:  mingw64-cross-binutils
BuildRequires:  mingw64-cross-gcc
BuildRequires:  mingw64-cross-gcc-c++
BuildRequires:  mingw64-cross-pkg-config
BuildRequires:  mingw64-filesystem >= 23
BuildRequires:  mingw64-libgnurx-devel
BuildRequires:  mingw64-libsamplerate-devel
BuildRequires:  mingw64-portaudio-devel
BuildRequires:  mingw64-libsndfile-devel
BuildRequires:  python
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
%_mingw64_package_header_debug
BuildArch:      noarch

%description
JACK is a low-latency audio server written primarily for the Linux
operating system. It can connect a number of different applications to
an audio device, as well as allow them to share audio between
themselves. Its clients can run in their own processes (as a normal
application), or they can run within a JACK server (as a plug-in).

%package -n mingw64-libjack
Summary:        Jack Audio Connection Kit Library
Group:          System/Libraries

%description -n mingw64-libjack
This package contains the library to access JACK
(Jack Audio ConnectionKit).

%package devel
Summary:        Development package for jack
License:        LGPL-2.1+
Group:          Development/Libraries/C and C++

%description devel
This package contains the files needed to compile programs that
communicates jack clients/servers.

%_mingw64_debug_package

%prep
%setup -q -n jack-%{versid}
%patch1 -p1
%patch2 -p1
rm windows/portaudio/portaudio.h windows/samplerate.h ./windows/JackRouter/Psapi.Lib ./windows/JackRouter/psapi.* ./windows/Psapi.Lib
rm windows/Release/bin/*.a windows/Release64/bin/*.a ./windows/Setup/src/*/*.dll ./macosx/*.a

%build
PKGCONFIG=%{_mingw64_target}-pkg-config CC=%{_mingw64_cc} CXX=%{_mingw64_cxx} CFLAGS="-I%{_mingw64_includedir}/tre/" CXXFLAGS="-I%{_mingw64_includedir}/tre/"  ./waf configure  --dist-target=mingw  --winmme --portaudio --prefix=/
./waf build

(echo prefix=%{_mingw64_prefix}
 echo 'exec_prefix=${prefix}'
 echo 'libdir=${prefix}/lib'
 echo 'includedir=${prefix}/include'
 echo 'server_libs=-L${libdir} -ljackserver'
 echo
 echo Name: jack
 echo Description: the Jack Audio Connection Kit: a low-latency synchronous callback-based media server
 echo Version: %{version}
 echo 'Libs: -L${libdir} -ljack'
 echo 'Cflags: -I${includedir}'
) > build/jack.pc
return -1

%install
DESTDIR=$RPM_BUILD_ROOT/%_mingw64_prefix ./waf install
mkdir -p $RPM_BUILD_ROOT/%{_mingw64_libdir}/jack
mv $RPM_BUILD_ROOT/%{_mingw64_libdir}/*.a $RPM_BUILD_ROOT/%{_mingw64_libdir}/jack
mv $RPM_BUILD_ROOT/%{_mingw64_libdir}/jack/libj* $RPM_BUILD_ROOT/%{_mingw64_libdir}

%clean
test "$RPM_BUILD_ROOT" != "/" -a -d "$RPM_BUILD_ROOT" && rm -rf $RPM_BUILD_ROOT

%files
%defattr(-, root, root)
%{_mingw64_bindir}/*.exe
%{_mingw64_bindir}/jack/*.dll

%files -n mingw64-libjack
%defattr(-,root,root)
%{_mingw64_bindir}/*.dll

%files devel
%defattr(-, root, root)
%{_mingw64_libdir}/libj*.dll.a
%dir %{_mingw64_libdir}/jack
%{_mingw64_libdir}/jack/*.dll.a
%{_mingw64_libdir}/pkgconfig/*
%{_mingw64_includedir}/jack/*

%changelog
