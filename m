Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73262648D7
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 17:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbgIJPf3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Sep 2020 11:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731294AbgIJPdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 11:33:49 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209079] CPU 0/KVM: page allocation failure on 5.8 kernel
Date:   Thu, 10 Sep 2020 15:33:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel@martin.schrodt.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: OBSOLETE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-209079-28872-cxUtvigYDo@https.bugzilla.kernel.org/>
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

Martin Schrodt (kernel@martin.schrodt.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |OBSOLETE

--- Comment #3 from Martin Schrodt (kernel@martin.schrodt.org) ---
Damn. 

I did some changes to the VM in the last few days, to make it support AVIC and
that made me change the kvm module parameters, without remembering what they
were before. They are now

> options kvm ignore_msrs=1 report_ignored_msrs=0
> options kvm_amd nested=0 avic=1 npt=1

and Seans post mentioning NPT having to be disabled for the bug to occur, I
updated the kernel again (to 5.8.7), and voilà, the VM works.

So I have to concur that it really was disabled before, but I can't remember
why I did so, maybe because of some bug that only existed when I setup the VM
somewhen in 2018.

Regarding GFP_DMA32, I don't know what it really means. Might be related to me
passing through a GPU, an NVME drive and a USB controller to the VM.

So I guess I'll leave learning how to bisect to my next future incident...

Thank you guys for all the work you do - Linux forever!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
