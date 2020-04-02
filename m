Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3CFB19C02C
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 13:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbgDBL3V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 2 Apr 2020 07:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388048AbgDBL3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 07:29:21 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 204975] AMD-Vi: Command buffer timeout
Date:   Thu, 02 Apr 2020 11:29:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: masato@yoshi.dnsalias.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-204975-28872-8gX2Llgmo3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204975-28872@https.bugzilla.kernel.org/>
References: <bug-204975-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204975

Masato Yoshida (masato@yoshi.dnsalias.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |masato@yoshi.dnsalias.com

--- Comment #11 from Masato Yoshida (masato@yoshi.dnsalias.com) ---
BioStar's X570GT8 motherboard AGESA 1.0.0.4 patch B has the same error.
OS ubuntu 19.10
kernel 5.4.21

By setting the PCI-E speed to Gen2 in UEFI BIOS, no error occurs and
pass-through can be performed without any problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
