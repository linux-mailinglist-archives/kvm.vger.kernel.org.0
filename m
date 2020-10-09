Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B308288598
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 10:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732968AbgJIIxN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 9 Oct 2020 04:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732492AbgJIIxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 04:53:13 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209593] New: netdevice: eth0: failed to disable LRO
Date:   Fri, 09 Oct 2020 08:53:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pancakezwk@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-209593-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209593

            Bug ID: 209593
           Summary: netdevice: eth0: failed to disable LRO
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.4.54
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: pancakezwk@gmail.com
        Regression: No

Created attachment 292907
  --> https://bugzilla.kernel.org/attachment.cgi?id=292907&action=edit
dmesg log

When the 5.4.54 kernel is started on the cloud host, the lro feature of the
network card is enabled by default and cannot be disabled. 


When I run docker, I want to turn off the lro feature.


Is this a kernel bug?  


The feature is added to the patch of the main line

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/net/virtio_net.c?id=a02e8964eaf9271a8a5fcc0c55bd13f933bafc56

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
