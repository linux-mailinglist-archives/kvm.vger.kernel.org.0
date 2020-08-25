Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E43251D3D
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 18:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgHYQbz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Aug 2020 12:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHYQby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 12:31:54 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209025] The "VFIO_MAP_DMA failed: Cannot allocate memory" bug
 is back
Date:   Tue, 25 Aug 2020 16:31:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209025-28872-Lqtk8cYNRl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209025-28872@https.bugzilla.kernel.org/>
References: <bug-209025-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209025

--- Comment #8 from Robert M. Muncrief (rmuncrief@humanavance.com) ---
(In reply to Jens Axboe from comment #6)
> (In reply to muncrief from comment #4)
> 
> I'm attaching the patch that should fix this. muncrief, I like to provide
> proper attribution in patches, would you be willing to share your name and
> email so I can add it to the patch? If you prefer not to that's totally fine
> as well, just wanted to give you the option.
> 
> Attaching the patch after this comment.

Awesome Jens! Thank you for figuring this thing out. I'll try the patch as soon
as I'm done with breakfast. And sharing my name and email is fine. I changed my
account to my full name (Robert M. Muncrief).

By the way, for future reference was my assumption that I have to compile the
exact initial kernel version before starting the bisect correct? I switched to
Manjaro three or four years ago, and then Arch about two years ago, but I don't
recall having to do it that way before. But then again I'm not sure if I've
ever bisected the kernel on Arch, it may just have been on Manjaro and Xubuntu.

And hey, don't laugh! I'm old! And my memory sure isn't what it used to be ...
:)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
