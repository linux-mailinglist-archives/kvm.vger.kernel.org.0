Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF65172BCC
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 00:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgB0XBJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 27 Feb 2020 18:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgB0XBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 18:01:08 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Thu, 27 Feb 2020 23:00:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: anthonysanwo@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-206579-28872-hgh3r9UIhX@https.bugzilla.kernel.org/>
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

Anthony (anthonysanwo@googlemail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |anthonysanwo@googlemail.com

--- Comment #28 from Anthony (anthonysanwo@googlemail.com) ---
Created attachment 287685
  --> https://bugzilla.kernel.org/attachment.cgi?id=287685&action=edit
avic_inhibit_reasons-anthony

Hi I also just wanted to give my observations I have found when testing the
patches.

I confirm I also don't have don't have crashes relating to the original report. 

I have been trying out the SVM AVIC patches since around the first patch that
was submitted but never got round to documentation my testing until recently.

I can't remember the specific patch set/kernel version I tried but I remember
having avic apparently working with when synic + stimer where enabled but not
without. If my understanding is correctly this shouldn't be the case as synic
is meant to be a case when avic is permanently disabled.

This is still the case with current patchset. 

In summary I can get avic reporting it's working according to perf stat and
trace logs when synic is on but not working when synic is off. Using EPYC-IBPB
or passthrough doesn't change the avic_inhibit_reasons.

With Synic I get avic_inhibit_reasons - 10
With Synic+Stimer off I get - 0


To note I am using arch linux + qemu 4.2 + linux-mainline-5.6.0-rc2.

Please see a small trace log of synic on vs off, domain capabilities, perf stat
and patches used.

These were recording once the VM was launched and sitting at the login screen.

Please let me know if there is any other info I get provide to help.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
