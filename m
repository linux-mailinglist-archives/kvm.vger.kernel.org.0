Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB98F271C5C
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 09:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgIUHyl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 21 Sep 2020 03:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgIUHyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 03:54:41 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209285] compilation fails
Date:   Mon, 21 Sep 2020 07:54:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: haiwei-li@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209285-28872-wnI1gydkKd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209285-28872@https.bugzilla.kernel.org/>
References: <bug-209285-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209285

Haiwei Li (haiwei-li@outlook.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |haiwei-li@outlook.com

--- Comment #3 from Haiwei Li (haiwei-li@outlook.com) ---
Resolved by Vitaly, 

https://lore.kernel.org/kvm/CAB5KdObJ4_0oJf+rwGXWNk6MsKm1j0dqrcGQkzQ63ek1LY=zMQ@mail.gmail.com/T/#m613f333dc9d01c463d1037c82a1b99687ffeb789

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
