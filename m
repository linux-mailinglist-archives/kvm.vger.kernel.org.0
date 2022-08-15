Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB00592997
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 08:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiHOG3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 02:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiHOG3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 02:29:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A8F1A81F
        for <kvm@vger.kernel.org>; Sun, 14 Aug 2022 23:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00CB4603F7
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 06:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67C1AC43140
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 06:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660544951;
        bh=qO7La3T3jrIgewtvzTAzoU4PBIMjzyzSM1udeROFts4=;
        h=From:To:Subject:Date:From;
        b=PYTN6ynmYFmJGn2TpdPh4802Ps/4rxAHAkwlzlZRKoNfOr1ujXt5iThhfIYFm0DOv
         VW3SolPElSqpGSUlaeetSgx3X8prSUU1rD9jR00gepTOtCbMbOUP4vuAZTHWc8f6aD
         3Ja5CpN6pcpS+jjLh//9MxgmZoBoCXDyWWLoR+k86ACwwbzZN/j9vJ3hbKd3nuNqF+
         +lp/wMfvSs0W+wBoaKK3J3otH56Cpob9KymlyTMJBIeC0d1JJfkN2q7Q3K3c/Yd9zO
         7KzMGBPTzSBGOCMsPUxKz7rXTAYMABLInTmGdg/4L329ISqgUf6EC2VNy85/UT14FI
         K1xP+/ts1pe4w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4D2C8C433E6; Mon, 15 Aug 2022 06:29:11 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216365] New: kvm selftests build fail
Date:   Mon, 15 Aug 2022 06:29:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216365-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216365

            Bug ID: 216365
           Summary: kvm selftests build fail
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.20
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: lixiao.yang@intel.com
        Regression: No

Environment:

Host kernel: 5.19.0-rc8

Host OS: rhel8.3

upstream kvm repo: https://git.kernel.org/pub/scm/virt/kvm/kvm.git

branch: next

commit: 19a7cc817a380f7a412d7d76e145e9e2bc47e52f

GCC version: gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5)

Bug Detailed Description:

Error happens when trying to compile upstream kvm selftests.

git clone https://git.kernel.org/pub/scm/virt/kvm/kvm.git
git checkout -b next origin/next
cd kvm/tools/testing/selftests/kvm
make

Expected results:
Successfully build

Actual results:
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99
-fno-stack-protector -fno-PIE -I../../../../tools/include
-I../../../../tools/arch/x86/include -I../../../../usr/include/ -Iinclude -=
Ilib
-Iinclude/x86_64 -I ../rseq -I..     -c lib/assert.c -o
/home/lxy/kvm/tools/testing/selftests/kvm/lib/assert.o
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99
-fno-stack-protector -fno-PIE -I../../../../tools/include
-I../../../../tools/arch/x86/include -I../../../../usr/include/ -Iinclude -=
Ilib
-Iinclude/x86_64 -I ../rseq -I..     -c lib/elf.c -o
/home/lxy/kvm/tools/testing/selftests/kvm/lib/elf.o
In file included from include/kvm_util.h:10,
                 from lib/elf.c:13:
include/kvm_util_base.h:93:26: error: field =E2=80=98stats_header=E2=80=99 =
has incomplete type
  struct kvm_stats_header stats_header;
                          ^~~~~~~~~~~~
In file included from ../../../../tools/include/linux/kernel.h:8,
                 from ../../../../tools/include/linux/list.h:7,
                 from ../../../../tools/include/linux/hashtable.h:10,
                 from include/kvm_util_base.h:13,
                 from include/kvm_util.h:10,
                 from lib/elf.c:13:
include/kvm_util_base.h: In function =E2=80=98kvm_vm_reset_dirty_ring=E2=80=
=99:
include/kvm_util_base.h:308:24: error: =E2=80=98KVM_RESET_DIRTY_RINGS=E2=80=
=99 undeclared
(first use in this function); did you mean =E2=80=98KVM_GET_DIRTY_LOG=E2=80=
=99?
  return __vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
                        ^~~~~~~~~~~~~~~~~~~~~
../../../../tools/include/linux/build_bug.h:79:56: note: in definition of m=
acro
=E2=80=98__static_assert=E2=80=99
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                                        ^~~~
include/kvm_util_base.h:193:2: note: in expansion of macro =E2=80=98static_=
assert=E2=80=99
  static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
 \
  ^~~~~~~~~~~~~
include/kvm_util_base.h:216:2: note: in expansion of macro =E2=80=98kvm_do_=
ioctl=E2=80=99
  kvm_do_ioctl((vm)->fd, cmd, arg);   \
  ^~~~~~~~~~~~
include/kvm_util_base.h:308:9: note: in expansion of macro =E2=80=98__vm_io=
ctl=E2=80=99
  return __vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
         ^~~~~~~~~~
include/kvm_util_base.h:308:24: note: each undeclared identifier is reported
only once for each function it appears in
  return __vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
                        ^~~~~~~~~~~~~~~~~~~~~
../../../../tools/include/linux/build_bug.h:79:56: note: in definition of m=
acro
=E2=80=98__static_assert=E2=80=99
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                                        ^~~~
include/kvm_util_base.h:193:2: note: in expansion of macro =E2=80=98static_=
assert=E2=80=99
  static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
 \
  ^~~~~~~~~~~~~
include/kvm_util_base.h:216:2: note: in expansion of macro =E2=80=98kvm_do_=
ioctl=E2=80=99
  kvm_do_ioctl((vm)->fd, cmd, arg);   \
  ^~~~~~~~~~~~
include/kvm_util_base.h:308:9: note: in expansion of macro =E2=80=98__vm_io=
ctl=E2=80=99
  return __vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
         ^~~~~~~~~~
include/kvm_util_base.h:193:16: error: expression in static assertion is no=
t an
integer
  static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
 \
                ^
../../../../tools/include/linux/build_bug.h:79:56: note: in definition of m=
acro
=E2=80=98__static_assert=E2=80=99
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                                        ^~~~
include/kvm_util_base.h:193:2: note: in expansion of macro =E2=80=98static_=
assert=E2=80=99
  static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
 \
  ^~~~~~~~~~~~~
include/kvm_util_base.h:216:2: note: in expansion of macro =E2=80=98kvm_do_=
ioctl=E2=80=99
  kvm_do_ioctl((vm)->fd, cmd, arg);   \
  ^~~~~~~~~~~~
include/kvm_util_base.h:308:9: note: in expansion of macro =E2=80=98__vm_io=
ctl=E2=80=99
  return __vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
         ^~~~~~~~~~
include/kvm_util_base.h: In function =E2=80=98vm_get_stats_fd=E2=80=99:
include/kvm_util_base.h:313:26: error: =E2=80=98KVM_GET_STATS_FD=E2=80=99 u=
ndeclared (first use
in this function); did you mean =E2=80=98KVM_GET_SREGS=E2=80=99?
  int fd =3D __vm_ioctl(vm, KVM_GET_STATS_FD, NULL);
                          ^~~~~~~~~~~~~~~~
../../../../tools/include/linux/build_bug.h:79:56: note: in definition of m=
acro
=E2=80=98__static_assert=E2=80=99
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                                        ^~~~
include/kvm_util_base.h:193:2: note: in expansion of macro =E2=80=98static_=
assert=E2=80=99
  static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
 \
  ^~~~~~~~~~~~~
include/kvm_util_base.h:216:2: note: in expansion of macro =E2=80=98kvm_do_=
ioctl=E2=80=99
  kvm_do_ioctl((vm)->fd, cmd, arg);   \
  ^~~~~~~~~~~~
include/kvm_util_base.h:313:11: note: in expansion of macro =E2=80=98__vm_i=
octl=E2=80=99
  int fd =3D __vm_ioctl(vm, KVM_GET_STATS_FD, NULL);
           ^~~~~~~~~~
include/kvm_util_base.h:193:16: error: expression in static assertion is no=
t an
integer
  static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
 \
                ^
../../../../tools/include/linux/build_bug.h:79:56: note: in definition of m=
acro
=E2=80=98__static_assert=E2=80=99
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                                        ^~~~
include/kvm_util_base.h:193:2: note: in expansion of macro =E2=80=98static_=
assert=E2=80=99
  static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
 \
  ^~~~~~~~~~~~~
include/kvm_util_base.h:216:2: note: in expansion of macro =E2=80=98kvm_do_=
ioctl=E2=80=99
  kvm_do_ioctl((vm)->fd, cmd, arg);   \
  ^~~~~~~~~~~~
include/kvm_util_base.h:313:11: note: in expansion of macro =E2=80=98__vm_i=
octl=E2=80=99
  int fd =3D __vm_ioctl(vm, KVM_GET_STATS_FD, NULL);
           ^~~~~~~~~~
In file included from include/kvm_util.h:10,
                 from lib/elf.c:13:
include/kvm_util_base.h: In function =E2=80=98read_stats_header=E2=80=99:
include/kvm_util_base.h:323:38: error: dereferencing pointer to incomplete =
type
=E2=80=98struct kvm_stats_header=E2=80=99
  ret =3D read(stats_fd, header, sizeof(*header));
                                      ^~~~~~~
include/kvm_util_base.h: In function =E2=80=98get_stats_descriptor_size=E2=
=80=99:
include/kvm_util_base.h:338:16: error: invalid application of =E2=80=98size=
of=E2=80=99 to
incomplete type =E2=80=98struct kvm_stats_desc=E2=80=99
  return sizeof(struct kvm_stats_desc) + header->name_size;
                ^~~~~~
In file included from ../../../../tools/include/linux/kernel.h:8,
                 from ../../../../tools/include/linux/list.h:7,
                 from ../../../../tools/include/linux/hashtable.h:10,
                 from include/kvm_util_base.h:13,
                 from include/kvm_util.h:10,
                 from lib/elf.c:13:
include/kvm_util_base.h: In function =E2=80=98vcpu_get_stats_fd=E2=80=99:
include/kvm_util_base.h:517:30: error: =E2=80=98KVM_GET_STATS_FD=E2=80=99 u=
ndeclared (first use
in this function); did you mean =E2=80=98KVM_GET_SREGS=E2=80=99?
  int fd =3D __vcpu_ioctl(vcpu, KVM_GET_STATS_FD, NULL);
                              ^~~~~~~~~~~~~~~~
../../../../tools/include/linux/build_bug.h:79:56: note: in definition of m=
acro
=E2=80=98__static_assert=E2=80=99
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                                        ^~~~
include/kvm_util_base.h:193:2: note: in expansion of macro =E2=80=98static_=
assert=E2=80=99
  static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
 \
  ^~~~~~~~~~~~~
include/kvm_util_base.h:235:2: note: in expansion of macro =E2=80=98kvm_do_=
ioctl=E2=80=99
  kvm_do_ioctl((vcpu)->fd, cmd, arg);   \
  ^~~~~~~~~~~~
include/kvm_util_base.h:517:11: note: in expansion of macro =E2=80=98__vcpu=
_ioctl=E2=80=99
  int fd =3D __vcpu_ioctl(vcpu, KVM_GET_STATS_FD, NULL);
           ^~~~~~~~~~~~
include/kvm_util_base.h:193:16: error: expression in static assertion is no=
t an
integer
  static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
 \
                ^
../../../../tools/include/linux/build_bug.h:79:56: note: in definition of m=
acro
=E2=80=98__static_assert=E2=80=99
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                                        ^~~~
include/kvm_util_base.h:193:2: note: in expansion of macro =E2=80=98static_=
assert=E2=80=99
  static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) =3D=3D _IOC_SIZE(cmd), "");=
 \
  ^~~~~~~~~~~~~
include/kvm_util_base.h:235:2: note: in expansion of macro =E2=80=98kvm_do_=
ioctl=E2=80=99
  kvm_do_ioctl((vcpu)->fd, cmd, arg);   \
  ^~~~~~~~~~~~
include/kvm_util_base.h:517:11: note: in expansion of macro =E2=80=98__vcpu=
_ioctl=E2=80=99
  int fd =3D __vcpu_ioctl(vcpu, KVM_GET_STATS_FD, NULL);
           ^~~~~~~~~~~~
In file included from include/kvm_util.h:10,
                 from lib/elf.c:13:
include/kvm_util_base.h: In function =E2=80=98__vm_disable_nx_huge_pages=E2=
=80=99:
include/kvm_util_base.h:834:29: error: =E2=80=98KVM_CAP_VM_DISABLE_NX_HUGE_=
PAGES=E2=80=99
undeclared (first use in this function); did you mean
=E2=80=98KVM_CAP_X86_DISABLE_EXITS=E2=80=99?
  return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                             KVM_CAP_X86_DISABLE_EXITS
make: *** [Makefile:229: /home/lxy/kvm/tools/testing/selftests/kvm/lib/elf.=
o]
Error 1

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
