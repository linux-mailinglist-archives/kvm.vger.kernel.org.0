Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A4C1A832B
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbgDNPhg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 14 Apr 2020 11:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440493AbgDNPh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 11:37:29 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMDcxNzNdIGt2bSBjb21waWxpbmcgcHJvYmxlbSA1LjYu?=
 =?UTF-8?B?eCBrdm1fbWFpbi5jOjIyMzY6NDI6IGVycm9yOiDigJhucl9wYWdlc19hdmFp?=
 =?UTF-8?B?bOKAmSBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rp?=
 =?UTF-8?B?b24=?=
Date:   Tue, 14 Apr 2020 15:37:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: sean.j.christopherson@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207173-28872-0Fjx0VOnlE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207173-28872@https.bugzilla.kernel.org/>
References: <bug-207173-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207173

--- Comment #4 from Sean Christopherson (sean.j.christopherson@intel.com) ---
Hrm, still can't reproduce this even with your config and gcc 9.2.  Can you
paste the build command for kvm_main.o?  It should be the first line in
virt/kvm/.kvm_main.o.cmd in your build directory, e.g.

cmd_arch/x86/kvm/../../../virt/kvm/kvm_main.o := /usr/bin/gcc-9
-Wp,-MD,arch/x86/kvm/../../../virt/kvm/.kvm_main.o.d  -nostdinc -isystem
/usr/lib/gcc/x86_64-linux-gnu/9/include -I./arch/x86/include
-I./arch/x86/include/generated -I./include -I./include
-I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi
-I./include/generated/uapi -include ./include/linux/kconfig.h -include
./include/linux/compiler_types.h -D__KERNEL__ -Wall -Wundef
-Werror=strict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
-fshort-wchar -fno-PIE -Werror=implicit-function-declaration
-Werror=implicit-int -Wno-format-security -std=gnu89 -mno-sse -mno-mmx
-mno-sse2 -mno-3dnow -mno-avx -m64 -falign-jumps=1 -falign-loops=1 -mno-80387
-mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -march=core2
-mno-red-zone -mcmodel=kernel -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1
-DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_SSSE3=1 -DCONFIG_AS_AVX=1
-DCONFIG_AS_AVX2=1 -DCONFIG_AS_AVX512=1 -DCONFIG_AS_SHA1_NI=1
-DCONFIG_AS_SHA256_NI=1 -DCONFIG_AS_ADX=1 -Wno-sign-compare
-fno-asynchronous-unwind-tables -mindirect-branch=thunk-extern
-mindirect-branch-register -fno-jump-tables -fno-delete-null-pointer-checks
-Wno-frame-address -Wno-format-truncation -Wno-format-overflow
-Wno-address-of-packed-member -O2 --param=allow-store-data-races=0
-fstack-protector-strong -Wno-unused-but-set-variable -Wimplicit-fallthrough
-Wno-unused-const-variable -fomit-frame-pointer -fno-var-tracking-assignments
-Wdeclaration-after-statement -Wvla -Wno-pointer-sign -Wno-stringop-truncation
-fno-strict-overflow -fno-merge-all-constants -fmerge-constants
-fno-stack-check -fconserve-stack -Werror=date-time
-Werror=incompatible-pointer-types -Werror=designated-init
-fmacro-prefix-map=./= -fcf-protection=none -Wno-packed-not-aligned
-Iarch/x86/kvm -Werror -I ./arch/x86/kvm -I ./arch/x86/kvm   
-DKBUILD_MODFILE='"arch/x86/kvm/kvm"' -DKBUILD_BASENAME='"kvm_main"'
-DKBUILD_MODNAME='"kvm"' -c -o arch/x86/kvm/../../../virt/kvm/kvm_main.o
./arch/x86/kvm/../../../virt/kvm/kvm_main.c

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
