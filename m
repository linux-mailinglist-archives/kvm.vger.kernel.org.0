Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878561552A4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 07:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgBGG6n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 7 Feb 2020 01:58:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgBGG6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 01:58:43 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206447] New: __skb_get_hash_symmetric makes tun queue not
 balance
Date:   Fri, 07 Feb 2020 06:58:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: glovejmm@163.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-206447-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206447

            Bug ID: 206447
           Summary: __skb_get_hash_symmetric makes tun queue not balance
           Product: Virtualization
           Version: unspecified
    Kernel Version: 3.10.0-862.14 and later
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: glovejmm@163.com
        Regression: No

We use tun ko to creaste a vm with ovs,  We found thst tun_select_queue changed
the hash method from  skb_get_hash to __skb_get_hash_symmetric, in higher
kernel version.

What refuse us is it is quite balance in tun queue select in old version, while
it is often focus on 1-2 queues in new version with above change.

When we rollback the hash methd  to skb_get_hash with kernel recompile , 
balance recover normal again .


Is there any config or patch relation with this hash not balance problem?


here is the change patch

https://patchwork.ozlabs.org/patch/643209

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
