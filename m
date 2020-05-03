Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37221C292E
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 02:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgECAOq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 2 May 2020 20:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbgECAOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 20:14:46 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207541] "BUG: stack guard page was hit" when starting a
 KVM-based VM
Date:   Sun, 03 May 2020 00:14:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: linux-kernel@polvanaubel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-207541-28872-aaX1kUdvG8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207541-28872@https.bugzilla.kernel.org/>
References: <bug-207541-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207541

Pol Van Aubel (linux-kernel@polvanaubel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linux-kernel@polvanaubel.co
                   |                            |m

--- Comment #1 from Pol Van Aubel (linux-kernel@polvanaubel.com) ---
Duplicate of https://bugzilla.kernel.org/show_bug.cgi?id=207489

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
