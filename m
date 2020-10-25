Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B177298176
	for <lists+kvm@lfdr.de>; Sun, 25 Oct 2020 12:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415416AbgJYL2W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 25 Oct 2020 07:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1415382AbgJYL2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Oct 2020 07:28:22 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209845] New: ignore_msrs kernel NULL pointer dereference since
 12bc2132b15e0a969b3f455d90a5f215ef239eff
Date:   Sun, 25 Oct 2020 11:28:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel-bugs@steffen.cc
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-209845-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209845

            Bug ID: 209845
           Summary: ignore_msrs kernel NULL pointer dereference since
                    12bc2132b15e0a969b3f455d90a5f215ef239eff
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.9
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: kernel-bugs@steffen.cc
        Regression: No

Created attachment 293183
  --> https://bugzilla.kernel.org/attachment.cgi?id=293183&action=edit
dmesg section

Since commit 12bc2132b15e0a969b3f455d90a5f215ef239eff kvm crashes with a null
pointer dereference when ignore_msrs is set (log in attachement) 

Hardware: AMD Ryzen 3700x


other reports:
-
https://www.reddit.com/r/VFIO/comments/jdh9pp/so_i_just_updated_to_kernel_591_and/ 


- https://forum.manjaro.org/t/kernel-5-9-no-virtualization/31562

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
