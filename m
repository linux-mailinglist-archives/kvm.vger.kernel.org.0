Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061F320B352
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 16:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgFZOP1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 26 Jun 2020 10:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgFZOP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 10:15:27 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 190131] VirtIO Windows Drivers doesn't support SecureBoot.
Date:   Fri, 26 Jun 2020 14:15:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vkuznets@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-190131-28872-PfBGWOdRPO@https.bugzilla.kernel.org/>
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

vkuznets@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |vkuznets@redhat.com

--- Comment #2 from vkuznets@redhat.com ---
The drivers need to be WHQL or attestation signed to work with UEFI/Secure
Boot. If you're using upstream drivers available through e.g. fedoraproject.org
it definitely will not work. Please see
https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
