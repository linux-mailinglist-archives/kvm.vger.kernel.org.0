Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D1A1F1CDB
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 18:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgFHQGJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 8 Jun 2020 12:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730387AbgFHQGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 12:06:09 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208091] vcpu1, guest rIP offset ignored wrmsr or rdmsr
Date:   Mon, 08 Jun 2020 16:06:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: commandline@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208091-28872-E7o1uJpQJG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208091-28872@https.bugzilla.kernel.org/>
References: <bug-208091-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208091

--- Comment #5 from Joris L. (commandline@protonmail.com) ---
(In reply to Sean Christopherson from comment #3)
> The "ignored {rd,wr}msr" output is expected when kvm.ignore_msrs=1, which is
> not the default.  Is that enabled for any particular reason?  Or maybe a
> better question is, what is it that you're trying to do and what, if any,
> errors are occurring?
> 
> E.g. in the first trace, it looks like you're advertising an Intel vCPU to
> the guest on top of AMD hardware.  That can be made to work, but it's not
> recommended.  Ignoring MSRs in that scenario is almost guaranteed to cause
> weirdness.

Thanks Sean. I am cleaning up this config. Will check.

This is indeed a Ryzen CPU with Qemu/Proxmox on top of it.
For GPU Passthrough to a VM the kvm.ignore_msrs=1 is often recommended.
I brief test shows the VM is not working properly without this parameter, even
when booting the VM with CPU:host.

br,

Joris

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
