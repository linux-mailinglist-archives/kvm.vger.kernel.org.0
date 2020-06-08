Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45141F1D07
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 18:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgFHQPE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 8 Jun 2020 12:15:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730333AbgFHQPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 12:15:04 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208091] vcpu1, guest rIP offset ignored wrmsr or rdmsr
Date:   Mon, 08 Jun 2020 16:15:03 +0000
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
Message-ID: <bug-208091-28872-NiXSXfAYRj@https.bugzilla.kernel.org/>
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

--- Comment #6 from Joris L. (commandline@protonmail.com) ---
These i get with kvm ignore.msrs=1 enabled and CPU=host

[   46.512153] kvm [7509]: vcpu0, guest rIP: 0xfffff8039588c0aa ignored rdmsr:
0xc0011023
[   46.512161] kvm [7509]: vcpu0, guest rIP: 0xfffff8039588c0bf ignored wrmsr:
0xc0011023 data 0x100
[   46.555401] kvm [7509]: vcpu1, guest rIP: 0xfffff8039588c0aa ignored rdmsr:
0xc0011023
[   46.555406] kvm [7509]: vcpu1, guest rIP: 0xfffff8039588c0bf ignored wrmsr:
0xc0011023 data 0x100
[   46.556809] kvm [7509]: vcpu2, guest rIP: 0xfffff8039588c0aa ignored rdmsr:
0xc0011023
[   46.556823] kvm [7509]: vcpu2, guest rIP: 0xfffff8039588c0bf ignored wrmsr:
0xc0011023 data 0x100
[   46.558065] kvm [7509]: vcpu3, guest rIP: 0xfffff8039588c0aa ignored rdmsr:
0xc0011023
[   46.558078] kvm [7509]: vcpu3, guest rIP: 0xfffff8039588c0bf ignored wrmsr:
0xc0011023 data 0x100

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
