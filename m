Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598ED2DA48D
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 01:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgLOAMu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 14 Dec 2020 19:12:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729711AbgLOAMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 19:12:36 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 210695] New: error: kvm run failed Invalid argument
Date:   Tue, 15 Dec 2020 00:11:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rherbert@sympatico.ca
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-210695-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210695

            Bug ID: 210695
           Summary: error: kvm run failed Invalid argument
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.10.1
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: rherbert@sympatico.ca
        Regression: No

Created attachment 294133
  --> https://bugzilla.kernel.org/attachment.cgi?id=294133&action=edit
Error outputs

Hi.

Starting with kernel 5.10-rc1, I've been unable to start Qemu VM's.  The only
5.10-rc that worked was 5.10-rc4 (not sure about -rc5).  I've tried with both
qemu 4.1.0 and the latest 5.2.0.  The VM runs fine with kernel 5.9.13.

uname -a:

Linux starbug.dom 5.10.1 #1 SMP Mon Dec 14 18:24:40 EST 2020 x86_64 Intel(R)
Core(TM)2 Quad CPU    Q9650  @ 3.00GHz GenuineIntel GNU/Linux

Motherboard: Intel DG41RQ

Thanks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
