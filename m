Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855DC17E2B2
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 15:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgCIOtS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 9 Mar 2020 10:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgCIOtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 10:49:18 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206799] New: Strange help text for KVM_WERROR ("i915")
Date:   Mon, 09 Mar 2020 14:49:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: bugzilla.kernel.bpeb@manchmal.in-ulm.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-206799-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206799

            Bug ID: 206799
           Summary: Strange help text for KVM_WERROR ("i915")
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.6-rc5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: bugzilla.kernel.bpeb@manchmal.in-ulm.de
        Regression: No

Commit 4f337faf ("KVM: allow disabling -Werror") introduced the KVM_WERROR
configuration variable, and a help text in Kconfig "Add -Werror to the build
flags for (and only for) i915.ko.". Now I fail to see how this is related to
the i915 video driver, and there is no other mentioning of "915" in that
subtree either - care to check?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
