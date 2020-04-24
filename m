Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA21C1B8260
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 01:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgDXXOa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 24 Apr 2020 19:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgDXXOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 19:14:30 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205243] CPU model name is not passed to Guest VM
Date:   Fri, 24 Apr 2020 23:14:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jorhand@linux.microsoft.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-205243-28872-hFIDCgUWj7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205243-28872@https.bugzilla.kernel.org/>
References: <bug-205243-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205243

Jordan (jorhand@linux.microsoft.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jorhand@linux.microsoft.com

--- Comment #1 from Jordan (jorhand@linux.microsoft.com) ---
This isn't really an issue with KVM, but instead just a matter of how the VM
was launched.

For example if you are launching the VM with qemu-kvm, passing "-cpu host" will
allow the guest full access to CPU details.

Similarly if you're using the virt-manager UI, in hardware details -> CPUs
there is a checkbox for "Copy host CPU configuration". This will pass full CPU
details through to the host.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
