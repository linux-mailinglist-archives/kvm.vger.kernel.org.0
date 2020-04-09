Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D98E21A35D3
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 16:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgDIOZp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 9 Apr 2020 10:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbgDIOZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 10:25:44 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMDcxNzNdIE5ldzoga3ZtIGNvbXBpbGluZyBwcm9ibGVt?=
 =?UTF-8?B?IDUuNi54IGt2bV9tYWluLmM6MjIzNjo0MjogZXJyb3I6IOKAmG5yX3BhZ2Vz?=
 =?UTF-8?B?X2F2YWls4oCZIG1heSBiZSB1c2VkIHVuaW5pdGlhbGl6ZWQgaW4gdGhpcyBm?=
 =?UTF-8?B?dW5jdGlvbg==?=
Date:   Thu, 09 Apr 2020 14:25:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: zoran.davidovac@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-207173-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 207173
           Summary: kvm compiling problem 5.6.x kvm_main.c:2236:42: error:
                    ‘nr_pages_avail’ may be used uninitialized in this
                    function
           Product: Virtualization
           Version: unspecified
    Kernel Version: linux-5.6.-linux-5.6.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zoran.davidovac@gmail.com
        Regression: No

happens with stock kernel 5.6.x gcc version 9.3.0 (GCC) 


  CC      arch/x86/kvm/../../../virt/kvm/kvm_main.o
arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function
‘__kvm_gfn_to_hva_cache_init’:
arch/x86/kvm/../../../virt/kvm/kvm_main.c:2236:42: error: ‘nr_pages_avail’ may
be used uninitialized in this function [-Werror=maybe-uninitialized]
 2236 |  for ( ; start_gfn <= end_gfn; start_gfn += nr_pages_avail) {
      |                                ~~~~~~~~~~^~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[2]: *** [scripts/Makefile.build:268:
arch/x86/kvm/../../../virt/kvm/kvm_main.o] Error 1
make[1]: *** [scripts/Makefile.build:505: arch/x86/kvm] Error 2
make: *** [Makefile:1683: arch/x86] Error 2

Waited till .3 and I am still surprised that nobody noticed :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
