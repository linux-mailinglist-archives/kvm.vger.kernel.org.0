Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA691F1F96
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 21:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgFHTPU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 8 Jun 2020 15:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgFHTPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 15:15:20 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208091] vcpu1, guest rIP offset ignored wrmsr or rdmsr
Date:   Mon, 08 Jun 2020 19:15:19 +0000
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
Message-ID: <bug-208091-28872-2OGqtiTfid@https.bugzilla.kernel.org/>
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

--- Comment #7 from Joris L. (commandline@protonmail.com) ---
With the kvm ignor.msrs parameter removed i do indeed see different results.
Now i am back at these messages. Sorry for the ignorance, learning as i read
the feedback.

[10427.220982] vfio-pci 0000:17:00.0: timed out waiting for pending
transaction; performing function level reset anyway
[10428.469006] vfio-pci 0000:17:00.0: not ready 1023ms after FLR; waiting
[10429.524940] vfio-pci 0000:17:00.0: not ready 2047ms after FLR; waiting
[10431.668982] vfio-pci 0000:17:00.0: not ready 4095ms after FLR; waiting
[10436.020672] vfio-pci 0000:17:00.0: not ready 8191ms after FLR; waiting
[10444.469003] vfio-pci 0000:17:00.0: not ready 16383ms after FLR; waiting
[10462.133026] vfio-pci 0000:17:00.0: not ready 32767ms after FLR; waiting
[10496.948661] vfio-pci 0000:17:00.0: not ready 65535ms after FLR; giving up

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
