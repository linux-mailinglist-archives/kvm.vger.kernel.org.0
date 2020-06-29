Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5918120DD51
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 23:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgF2SlZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 29 Jun 2020 14:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgF2SlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:23 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207389] Regression in nested SVM from 5.7-rc1, starting L2
 guest locks up L1
Date:   Mon, 29 Jun 2020 06:17:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mitch@0bits.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207389-28872-mkehiKh9rM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207389-28872@https.bugzilla.kernel.org/>
References: <bug-207389-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207389

--- Comment #2 from Mitch (mitch@0bits.com) ---
Ok, just re-read this bug and i'm seeing slightly different behavior. My L2
locks up with the same message "BUG: soft lockup - CPU#x stuck for xxs". L1 and
L0 sees no errors at all.

If i move L0 to 5.6.19 then i see no lockups on L1 or L2. 

If i move L0 to 5.7.x (tested even latest 5.7.6) then L2 locks up with the same
message.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
