Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461B223209C
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 16:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgG2Oej convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 29 Jul 2020 10:34:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbgG2Oeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 10:34:37 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 202055] Failed to PCI passthrough SSD with SMI SM2262
 controller.
Date:   Wed, 29 Jul 2020 14:34:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: Felix.leclair123@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-202055-28872-Pg0fhycQNR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202055-28872@https.bugzilla.kernel.org/>
References: <bug-202055-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202055

--- Comment #47 from FCL (Felix.leclair123@hotmail.com) ---
(In reply to FCL from comment #46)
> Hey gents! 
> 
> Trying to apply this to a proxmox VM, any advice on how to do so? I'm
> running on top of the 5.4.x linux kernel. I'm experiencing the same bug as
> in topic name, using the SMI 2263 controller. (Adata as above)
> 
> Anything I can provide in terms of debugging data? Otherwise, any advice on
> how to use the above non kernel patch? also comfortable doing a kernel
> recompile if thats the better solution. Will be going to a FreeBSD (FreeNAS
> 11.3) VM with 4 threads and 72GB of ram alongside an LSI SAS controller. 
> 
> Platform is a Dual Xeon 5670 on a HP ml350 G6 mother board. 
> 
> Also attached but on a different VM is a Radeon 5600XT, an intel USB
> controller and an intel Nic to a windows VM

Found the solution without the need for a kernel recompile. in my Qemu conf
file added:
args: -set device.hostpci1.x-msix-relocation=bar2

Where hostpci1 is 
hostpci1: 08:00.0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
