Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD9D1F1C75
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgFHPzB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 8 Jun 2020 11:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730267AbgFHPzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 11:55:01 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208091] vcpu1, guest rIP offset ignored wrmsr or rdmsr
Date:   Mon, 08 Jun 2020 15:55:00 +0000
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
Message-ID: <bug-208091-28872-WC6pn8HOnY@https.bugzilla.kernel.org/>
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

--- Comment #4 from Joris L. (commandline@protonmail.com) ---
These message are observed when starting a Proxmox VE 6.2 VM guest with GPU
passthrough.  Current configuration is at the point there are not other error
messages visible related to VM activity.

Available to respond to and provide for actions to improve documenting these
messages etc.

The vcpu0, guest rIP messages persist while a vm is running. Stopping and
staring a VM results in no screen. messages however now show (repeat kvm ...
msr messages, repeeat block of kvm, vcpu... rIP messages) followed by ecap
messages.

[ 2762.744734] kvm_get_msr_common: 275 callbacks suppressed
[ 2762.744738] kvm [19941]: vcpu2, guest rIP: 0xfffff8001123174b ignored rdmsr:
0xc0010064
[ 2762.744775] kvm [19941]: vcpu2, guest rIP: 0xfffff8001123174b ignored rdmsr:
0xc0010065
[ 2762.744853] kvm [19941]: vcpu2, guest rIP: 0xfffff8001123174b ignored rdmsr:
0xc0010066
[ 2762.744885] kvm [19941]: vcpu2, guest rIP: 0xfffff8001123174b ignored rdmsr:
0xc0010067
[ 2762.744917] kvm [19941]: vcpu2, guest rIP: 0xfffff8001123174b ignored rdmsr:
0xc0010068
[ 2762.744948] kvm [19941]: vcpu2, guest rIP: 0xfffff8001123174b ignored rdmsr:
0xc0010069
[ 2762.744983] kvm [19941]: vcpu2, guest rIP: 0xfffff8001123174b ignored rdmsr:
0xc001006a
[ 2762.745014] kvm [19941]: vcpu2, guest rIP: 0xfffff8001123174b ignored rdmsr:
0xc001006b
[ 2762.745044] kvm [19941]: vcpu2, guest rIP: 0xfffff8001123174b ignored rdmsr:
0xc0010293
[ 2762.750132] kvm [19941]: vcpu2, guest rIP: 0xfffff8001123174b ignored rdmsr:
0xe8
[ 2844.034627] vfio-pci 0000:17:00.0: vfio_ecap_init: hiding ecap 0x19@0x270
[ 2844.034641] vfio-pci 0000:17:00.0: vfio_ecap_init: hiding ecap 0x1b@0x2d0
[ 2845.308346] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.324311] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.566461] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.569777] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.599693] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.602566] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.625243] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.627436] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.659282] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.665352] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.673673] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.673924] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.673948] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.674104] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.674870] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.675040] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.675063] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.675210] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.708785] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.710674] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.727404] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.727598] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.728296] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.728484] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.764636] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.765256] vfio-pci 0000:17:00.1: vfio_bar_restore: reset recovery -
restoring BARs
[ 2845.933638] vfio-pci 0000:17:00.0: vfio_bar_restore: reset recovery -
restoring BARs

now the VM no longer displays the desktop.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
