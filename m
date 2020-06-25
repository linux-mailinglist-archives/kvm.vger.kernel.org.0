Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4442209DA0
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 13:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404309AbgFYLic convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 25 Jun 2020 07:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404253AbgFYLic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 07:38:32 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 190131] VirtIO Windows Drivers doesn't support SecureBoot.
Date:   Thu, 25 Jun 2020 11:38:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: heri16@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-190131-28872-Hcpwgjyvck@https.bugzilla.kernel.org/>
In-Reply-To: <bug-190131-28872@https.bugzilla.kernel.org/>
References: <bug-190131-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=190131

heri16@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |heri16@gmail.com

--- Comment #1 from heri16@gmail.com ---
Any updates on this? I am also seeing the error during boot if SecureBoot via
OVMF is enabled.

According to MS new driver signing policy, Windows 10 1607 and newer versions
require the drivers to be signed via their Dev Portal. Cross-signed drivers,
will not load when Secure Boot is enabled in the BIOS. Fedora's virtio drivers
are cross-signed and therefore were not being loaded.

https://docs.microsoft.com/en-us/windows-hardware/drivers/install/kernel-mode-code-signing-policy--windows-vista-and-later-

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
