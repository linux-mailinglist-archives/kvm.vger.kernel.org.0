Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35E82A2FAF
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 17:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgKBQYE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 2 Nov 2020 11:24:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgKBQYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 11:24:04 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209867] CPU soft lockup/stall with nested KVM and SMP
Date:   Mon, 02 Nov 2020 16:24:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: frantisek@sumsal.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209867-28872-t0QfY77sek@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209867-28872@https.bugzilla.kernel.org/>
References: <bug-209867-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209867

--- Comment #3 from Frantisek Sumsal (frantisek@sumsal.cz) ---
Clarification: the issue seems to appear only on AMD CPUs. I went through
several runs and tests in the "AMD[0] rack" suffer from the soft lockup above,
but the same workload passes on machines from the "Intel[1] rack"

[0] AMD Opteron 63xx class CPU (family: 0x15, model: 0x2, stepping: 0x0)
[1] Intel(R) Xeon(R) CPU E3-1265L V2 @ 2.50GHz (family: 0x6, model: 0x3a,
stepping: 0x9)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
