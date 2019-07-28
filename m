Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F9877F5C
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2019 14:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfG1MDz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 28 Jul 2019 08:03:55 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37292 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbfG1MDz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 28 Jul 2019 08:03:55 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8B9A328834
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2019 12:03:54 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 7F95928869; Sun, 28 Jul 2019 12:03:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 204209] kernel 5.2.1: "floating point exception" in qemu with
 kvm enabled
Date:   Sun, 28 Jul 2019 12:03:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: antdev66@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-204209-28872-4WZEoEeYbQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204209-28872@https.bugzilla.kernel.org/>
References: <bug-204209-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204209

--- Comment #3 from anthony (antdev66@gmail.com) ---
Today I saw the following commit:

>Revert "kvm: x86: Use task structs fpu field for user"
>commit ec269475cba7bcdd1eb8fdf8e87f4c6c81a376fe upstream.
>
>This reverts commit 240c35a3783ab9b3a0afaba0dde7291295680a6b
>("kvm: x86: Use task structs fpu field for user", 2018-11-06).
>The commit is broken and causes QEMU's FPU state to be destroyed
>when KVM_RUN is preempted.
>
>Fixes: 240c35a3783a ("kvm: x86: Use task structs fpu field for user")

applied to the 5.2.4 kernel and I thought it could relate to the reported bug,
but recompiling the kernel without previous indicated patch, the guest report
"fpu exception" error again: it was necessary to re-include the patch and
recompile the kernel for it to work.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
