Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B9623564D
	for <lists+kvm@lfdr.de>; Sun,  2 Aug 2020 12:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHBKgU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 2 Aug 2020 06:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbgHBKgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 06:36:20 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208767] kernel stack overflow due to Lazy update IOAPIC on an
 x86_64 *host*, when gpu is passthrough to macos guest vm
Date:   Sun, 02 Aug 2020 10:36:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yaweb@mail.bg
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208767-28872-hGDRkevsBv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208767-28872@https.bugzilla.kernel.org/>
References: <bug-208767-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208767

--- Comment #2 from Yani Stoyanov (yaweb@mail.bg) ---
I was thinking the same thing when I saw:
https://bugzilla.kernel.org/show_bug.cgi?id=207489 

I write a comment there but start realizing that the reason for my issue may be
something different since it happens only with my macos vm-s. Currently I am
using kernel-5.7.10-201.fc32.x86_64 which should include the patch. 

And I mentioned bug people are complaining about windows guests. I have 2
windows 10 machines and they are working fine no issues there the problem
appear only on my macos vm.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
