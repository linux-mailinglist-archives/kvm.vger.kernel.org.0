Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E51271BFA
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 09:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIUHcy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 21 Sep 2020 03:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbgIUHcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:53 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209285] compilation fails
Date:   Mon, 21 Sep 2020 07:32:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209285-28872-2S0lXGUJKA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209285-28872@https.bugzilla.kernel.org/>
References: <bug-209285-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209285

--- Comment #2 from Attila Jecs (attila.jecs@gmail.com) ---
same with rc6:

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
