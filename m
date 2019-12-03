Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D7410FA74
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 10:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfLCJIc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 3 Dec 2019 04:08:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:38362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbfLCJIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 04:08:32 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205655] kvm with cache=none and btrfs -> corrupted file system
Date:   Tue, 03 Dec 2019 09:08:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: stefanha@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205655-28872-tMNdxtLd4J@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205655-28872@https.bugzilla.kernel.org/>
References: <bug-205655-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205655

--- Comment #2 from Stefan Hajnoczi (stefanha@gmail.com) ---
On Tue, Nov 26, 2019 at 09:24:48AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=205655
> 
>             Bug ID: 205655
>            Summary: kvm with cache=none and btrfs -> corrupted file system
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 4.9   4.19    5.3.12
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: denis.ovsyannikov@gmail.com
>         Regression: No
> 
> hello
> we use kvm with disks formatted in btrfs
> when we turned on the mode "cache=none"
> got data corruption
> other modes work well
> 
> we tested it on three servers and the result is always repeated
> we tested on three operating systems(debian 9, debian 10, manjaro with kernel
> 5.3.12)
> 
> fstab
> UUID=a49494f2-35a4-4a9c-aab0-1afc905c02c2 /mnt/test      btrfs   defaults 0 2
> 
> dmesg
> [675174.887900] BTRFS error (device sde1): bdev /dev/sde1 errs: wr 0, rd 0,
> flush 0, corrupt 2137, gen 0
> 
> [102857.086874] BTRFS warning (device sdc1): csum failed root 256 ino 260 off
> 1735843840 csum 0xf69f8dd2 expected csum 0x96e71981 mirror 1

Please post your QEMU command-line.

What is the storage configuration on the host?  Which host file system
are you using?  Which image file format?

What test is being run inside the guest?

Is this a regression?  Which host and guest kernel versions worked fine
before?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
