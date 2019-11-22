Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD6E107321
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 14:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfKVN3v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 22 Nov 2019 08:29:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfKVN3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 08:29:51 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205631] New: kvm: Unknown symbol
Date:   Fri, 22 Nov 2019 13:29:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: riesebie@lxtec.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-205631-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205631

            Bug ID: 205631
           Summary: kvm: Unknown symbol
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.4-rc8
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: riesebie@lxtec.de
        Regression: No

Created attachment 286021
  --> https://bugzilla.kernel.org/attachment.cgi?id=286021&action=edit
Kernel config

running depmod on 5.4-rc8 gives:

kvm: Unknown symbol user_return_notifier_unregister (err -2)
kvm: Unknown symbol preempt_notifier_inc (err -2)
kvm: Unknown symbol preempt_notifier_register (err -2)
kvm: Unknown symbol user_return_notifier_register (err -2)
kvm: Unknown symbol preempt_notifier_dec (err -2)
kvm: Unknown symbol preempt_notifier_unregister (err -2)

Same config on 5.3.12 runs fine.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
