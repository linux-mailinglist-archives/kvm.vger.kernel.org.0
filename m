Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E201709B8
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 21:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBZUeE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 26 Feb 2020 15:34:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbgBZUeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 15:34:04 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Wed, 26 Feb 2020 20:34:03 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-206579-28872-xLY6iY9rqb@https.bugzilla.kernel.org/>
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

--- Comment #25 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 287639
  --> https://bugzilla.kernel.org/attachment.cgi?id=287639&action=edit
qemu-vkm setup info resulting in nonfunctional avic

It occurred to me that the original bug may be solved, and that my problems
getting avic to function may need to be addressed by creating a separate bug
report. I'm not sure though, so I created an attachment with my current grub
command line, qemu-kvm command line, and VM XML to this comment. And you can
look at Comment 22 to see my resulting system configuration.

And by the way, I've tried a myriad of other options in the command lines and
XML as well, but they all resulted in avic not functioning so there's no point
in detailing them all.

So if someone could review this information to verify that everything is setup
correctly, and let me know if it's time to file a different bug report, I'd
appreciate it. I know you're all very busy and don't want to bother you with
inquiries outside the scope of the initial bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
