Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0624A42FAA5
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 19:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242341AbhJOSBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 14:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242221AbhJOSBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 14:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CB33761245
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634320763;
        bh=rqJwjStj3Llv3b1CVZ50i28VkN69PORzKd8jXr84l2I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mfNAinZbnZ2A3mjyzi5tgR7XR3LeM1SlFZ717MY5PdRjf5Ch8f4mtnmWS5qT07tPb
         uTSJkpv8dUVnQtDdSCeaTuYZVsj1aO6b/+tjRPZGb2Tag1uI8X2YN/5mB3muzxr1gF
         Nd/Sk5PoiKeiD9IMX5oUse4kcYT1mzvVBkwKlJ8XheecseXkny9xJJt6TzIwAgvLZR
         jZ2fd6NkS2C+flx03Q36ZC//ALHD2Bdjbup1ZQCzcaV5JFHeeLcQcuRpyAAPgG93jA
         34SvT9GiO53+AlpkTVSezLHt9ct7ZPrwFpFNcxwHDo6f51Uv3yy0HXukhk9dWyWVsl
         jwF12sJFBYxfA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id C85A460EE6; Fri, 15 Oct 2021 17:59:23 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 110441] KVM guests randomly get I/O errors on VirtIO based
 devices
Date:   Fri, 15 Oct 2021 17:59:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ucelsanicin@yahoo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-110441-28872-ISMFAFhvKH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-110441-28872@https.bugzilla.kernel.org/>
References: <bug-110441-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D110441

Ahmed Sayeed (ucelsanicin@yahoo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ucelsanicin@yahoo.com

--- Comment #3 from Ahmed Sayeed (ucelsanicin@yahoo.com) ---
ake: Entering directory '/home/Christian/binutils-gdb/cygwin-obj/gdb'
  CXXLD  gdb.exe  http://www.compilatori.com/computers/smartphones/
cp-support.o: in function `gdb_demangle(char const*, int)':
http://www.acpirateradio.co.uk/services/ios15/
/home/Christian/binutils-gdb/cygwin-obj/gdb/../../gdb/cp-support.c:1619:(.t=
ext+0x5502):
http://www.logoarts.co.uk/property/lidar-sensor/ relocation truncated to fi=
t:
R_X86_64_PC32 against undefined symbol
http://www.slipstone.co.uk/property/hp-of-cars/ `TLS init function for
thread_local_segv_handler'
/home/Christian/binutils-gdb/cygwin-obj/gdb/../../gdb/cp-support.c:1619:(.t=
ext+0x551b):
http://embermanchester.uk/property/chat-themes/  relocation truncated to fi=
t:
R_X86_64_PC32 against undefined symbol `TLS init function for
thread_local_segv_handler'
collect2: error: ld returned 1 exit status
http://connstr.net/property/mars-researches/
make: *** [Makefile:1881: gdb.exe] Error 1
make: Leaving directory '/home/Christian/binutils-gdb/cygwin-obj/gdb'
http://joerg.li/services/kia-rio-price/

$ g++ -v
Using built-in specs. http://www.jopspeech.com/technology/thunderbolt-4/
COLLECT_GCC=3Dg++
COLLECT_LTO_WRAPPER=3D/usr/lib/gcc/x86_64-pc-cygwin/10/lto-wrapper.exe
Target: x86_64-pc-cygwin http://www.wearelondonmade.com/tech/driving-assist=
ant/=20
Configured with: /mnt/share/cygpkgs/gcc/gcc.x86_64/src/gcc-10.2.0/configure
--srcdir=3D/mnt/share/cygpkgs/gcc/gcc.x86_64/src/gcc-10.2.0 --prefix=3D/usr
--exec-prefix=3D/usr --localstatedir=3D/var --sysconfdir=3D/etc
--docdir=3D/usr/share/doc/gcc --
https://waytowhatsnext.com/computers/discord-and-steam/
htmldir=3D/usr/share/doc/gcc/html -C --build=3Dx86_64-pc-cygwin
--host=3Dx86_64-pc-cygwin --target=3Dx86_64-pc-cygwin --without-libiconv-pr=
efix
--without-libintl-prefix --
http://www.iu-bloomington.com/property/properties-in-turkey/
libexecdir=3D/usr/lib --with-gcc-major-version-only --enable-shared
--enable-shared-libgcc --enable-static --enable-version-specific-runtime-li=
bs
--enable-bootstrap --enable-__cxa_atexit --with-dwarf2
https://komiya-dental.com/sports/telegram/ --with-tune=3Dgeneric
--enable-languages=3Dc,c++,fortran,lto,objc,obj-c++ --enable-graphite
--enable-threads=3Dposix --enable-libatomic --enable-libgomp --enable-libqu=
admath
http://www-look-4.com/health/winter-sickness/ --enable-libquadmath-support
--disable-libssp --enable-libada --disable-symvers --with-gnu-ld --with-gnu=
-as
--with-cloog-include=3D/usr/include/cloog-isl --without-libiconv-prefix
--without-libintl-prefix --with-system-zlib
https://www.webb-dev.co.uk/sports/gym-during-covid/ --enable-linker-build-id
--with-default-libstdcxx-abi=3Dgcc4-compatible --enable-libstdcxx-filesyste=
m-ts
Thread model: posix
Supported LTO compression algorithms: zlib zstd
gcc version 10.2.0 (GCC)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
