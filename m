Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19F226BD5D
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 08:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgIPGif convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 16 Sep 2020 02:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgIPGid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 02:38:33 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209285] New: compilation fails
Date:   Wed, 16 Sep 2020 06:38:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: attila.jecs@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-209285-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209285

            Bug ID: 209285
           Summary: compilation fails
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.9-rc5
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: attila.jecs@gmail.com
        Regression: No

Created attachment 292515
  --> https://bugzilla.kernel.org/attachment.cgi?id=292515&action=edit
.config made by make oldconfig

CC      arch/x86/kernel/kvm.o
arch/x86/kernel/kvm.c: In function ‘kvm_alloc_cpumask’:
arch/x86/kernel/kvm.c:800:35: error: ‘kvm_send_ipi_mask_allbutself’ undeclared
(first use in this function)
  800 |  apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/kernel/kvm.c:800:35: note: each undeclared identifier is reported only
once for each function it appears in
make[5]: *** [scripts/Makefile.build:283: arch/x86/kernel/kvm.o] Error 1
make[4]: *** [scripts/Makefile.build:500: arch/x86/kernel] Error 2
make[3]: *** [Makefile:1784: arch/x86] Error 2
make[2]: *** [debian/rules:6: build] Error 2
dpkg-buildpackage: error: debian/rules build subprocess returned exit status 2
make[1]: *** [scripts/Makefile.package:83: bindeb-pkg] Error 2
make: *** [Makefile:1523: bindeb-pkg] Error 2

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
