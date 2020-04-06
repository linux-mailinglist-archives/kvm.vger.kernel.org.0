Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB0119EF5F
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 04:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDFCu6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 5 Apr 2020 22:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgDFCu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Apr 2020 22:50:58 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Mon, 06 Apr 2020 02:50:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-YuJEp6yHAD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206579-28872@https.bugzilla.kernel.org/>
References: <bug-206579-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206579

--- Comment #53 from muncrief (rmuncrief@humanavance.com) ---
(In reply to Anthony from comment #52)
> ...
> Good news I finally managed to reproduce the same errors both in a test VM
> and my current config.
> ...

Whew! I'm glad someone else is able to see it as well. I was beginning to
wonder if I was just doing something wrong.

Just to be clear though, this error occurs every time I start my VM. It doesn't
even matter if I login to the VM, the warnings have already appeared by the
time the login screen appears.

Anyway, as you said, hopefully your discovery that CPU pinning and -overcommit
cpu-pm get rid of the warnings will help guide the devs to a solution.

Also, I'm feeling a bit under the weather so if I don't respond to requests for
more info for a few days it's because I need to get some rest and get well. But
if anyone needs anything else just let me know and I'll get on it as soon as
possible.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
