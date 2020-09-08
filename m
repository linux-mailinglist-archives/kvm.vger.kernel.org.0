Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9CE26078F
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 02:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgIHAbp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 7 Sep 2020 20:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbgIHAbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 20:31:44 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209155] KVM Linux guest with more than 1 CPU panics after
 commit 404d5d7bff0d419fe11c7eaebca9ec8f25258f95 on old CPU (Phenom x4)
Date:   Tue, 08 Sep 2020 00:31:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wanpeng.li@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209155-28872-CrlR7NwD3K@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209155-28872@https.bugzilla.kernel.org/>
References: <bug-209155-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209155

Wanpeng Li (wanpeng.li@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wanpeng.li@hotmail.com

--- Comment #4 from Wanpeng Li (wanpeng.li@hotmail.com) ---
Could you dump the lscpu results in both the guest and the host? In addition,
could you dump the result from grep . /sys/module/kvm_amd/parameters/* ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
