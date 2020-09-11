Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCD326638E
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgIKQT6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 11 Sep 2020 12:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbgIKQTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 12:19:10 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209079] CPU 0/KVM: page allocation failure on 5.8 kernel
Date:   Fri, 11 Sep 2020 16:19:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sean.j.christopherson@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: OBSOLETE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209079-28872-701Ox8OKd2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209079-28872@https.bugzilla.kernel.org/>
References: <bug-209079-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209079

--- Comment #6 from Sean Christopherson (sean.j.christopherson@intel.com) ---
Nope, the failure path is common so we can't even glean anything from the
offsets in the stack trace.

In your data dump, both nodes show 10gb+ of free memory so there's plenty of
space for the measly 4kb that KVM is trying to allocate.  My best guess is that
the combination of nodemask/cpuset stuff resulted in a set of constraints that
were impossible to satisfy.

At this point, I'd say just chalk it up to a bad configuration unless you want
to pursue this further.  If there's a kernel bug lurking then odds are someone
will run into again.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
