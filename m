Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA12160DE6
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 10:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgBQJAl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 17 Feb 2020 04:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgBQJAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 04:00:40 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206559] dkms nvidia module install failed
Date:   Mon, 17 Feb 2020 09:00:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: 1@locman.su
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206559-28872-VGMEyuoXYe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206559-28872@https.bugzilla.kernel.org/>
References: <bug-206559-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206559

--- Comment #1 from sad86 (1@locman.su) ---
nvidia-installer log file '/var/log/nvidia-installer.log'
creation time: Mon Feb 17 11:56:28 2020
installer version: 390.87

PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

nvidia-installer command line:
    ./nvidia-installer

Using: nvidia-installer ncurses v6 user interface
-> Detected 4 CPUs online; setting concurrency level to 4.
-> Installing NVIDIA driver version 390.87.
-> An alternate method of installing the NVIDIA driver was detected. (This is
usually a package provided by your distributor.) A driver installed via that
method may integrate better with your system than a driver installed by
nvidia-in>

Please review the message provided by the maintainer of this alternate
installation method and decide how to proceed:

The NVIDIA driver provided by Ubuntu can be installed by launching the
"Software & Updates" application, and by selecting the NVIDIA driver from the
"Additional Drivers" tab.


(Answer: Continue installation)
-> Would you like to register the kernel module sources with DKMS? This will
allow DKMS to automatically build a new module, if you install a different
kernel later. (Answer: Yes)
-> Installing both new and classic TLS OpenGL libraries.
-> Installing both new and classic TLS 32bit OpenGL libraries.
-> Install NVIDIA's 32-bit compatibility libraries? (Answer: Yes)
-> Will install GLVND GLX client libraries.
-> Will install GLVND EGL client libraries.
-> Skipping GLX non-GLVND file: "libGL.so.390.87"
-> Skipping GLX non-GLVND file: "libGL.so.1"
-> Skipping GLX non-GLVND file: "libGL.so"
-> Skipping EGL non-GLVND file: "libEGL.so.390.87"
-> Skipping EGL non-GLVND file: "libEGL.so"
-> Skipping EGL non-GLVND file: "libEGL.so.1"
-> Skipping GLX non-GLVND file: "./32/libGL.so.390.87"
-> Skipping GLX non-GLVND file: "libGL.so.1"
-> Skipping GLX non-GLVND file: "libGL.so"
-> Skipping EGL non-GLVND file: "./32/libEGL.so.390.87"
-> Skipping EGL non-GLVND file: "libEGL.so"
-> Skipping EGL non-GLVND file: "libEGL.so.1"
Looking for install checker script at
./libglvnd_install_checker/check-libglvnd-install.sh
   executing: '/bin/sh ./libglvnd_install_checker/check-libglvnd-install.sh'...
   Checking for libglvnd installation.
   Checking libGLdispatch...
   Checking libGLdispatch dispatch table
   Checking call through libGLdispatch
   All OK
   libGLdispatch is OK
   Checking for libGLX
   libGLX is OK
   Checking for libEGL
   Can't load libEGL from libEGL.so.1: libnvidia-glsi.so.340.107: cannot open
shared object file: No such file or directory
-> An incomplete installation of libglvnd was found. Do you want to install a
full copy of libglvnd? This will overwrite any existing libglvnd libraries.
(Answer: Install and overwrite existing files)
Will install libglvnd libraries.
Will install libEGL vendor library config file to /usr/share/glvnd/egl_vendor.d
-> Searching for conflicting files:
-> done.
-> Installing 'NVIDIA Accelerated Graphics Driver for Linux-x86_64' (390.87):
   executing: '/sbin/ldconfig'...
-> done.
-> Driver file installation is complete.
-> Installing DKMS kernel module:
ERROR: Failed to run `/usr/sbin/dkms build -m nvidia -v 390.87 -k
5.6.0-050600rc2-generic`:
Kernel preparation unnecessary for this kernel.  Skipping...

Building module:
cleaning build area.....
'make' -j4 NV_EXCLUDE_BUILD_MODULES='' KERNEL_UNAME=5.6.0-050600rc2-generic
modules.............(bad exit status: 2)
Error! Bad return status for module build on kernel: 5.6.0-050600rc2-generic
(x86_64)
Consult /var/lib/dkms/nvidia/390.87/build/make.log for more information.
-> error.
ERROR: Failed to install the kernel module through DKMS. No kernel module was
installed; please try installing again without DKMS, or check the DKMS logs for
more information.
ERROR: Installation has failed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
