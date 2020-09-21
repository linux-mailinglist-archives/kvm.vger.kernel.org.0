Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F277271F87
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 12:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgIUKAj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 21 Sep 2020 06:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgIUKAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 06:00:38 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209333] VM not starting anymore with 5.8.8 - lots of page
 faults
Date:   Mon, 21 Sep 2020 10:00:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Drivers
X-Bugzilla-Component: IOMMU
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: maximlevitsky@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209333-28872-Ic4ko9ZhC1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209333-28872@https.bugzilla.kernel.org/>
References: <bug-209333-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209333

Maxim Levitsky (maximlevitsky@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |maximlevitsky@gmail.com

--- Comment #1 from Maxim Levitsky (maximlevitsky@gmail.com) ---
I bisected and reported this regression few days ago. The fix is upstream and
probably will land to the stable trees as well.

https://lkml.org/lkml/2020/9/13/94

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2312235.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
