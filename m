Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C51D7AD2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfJOQHi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 15 Oct 2019 12:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfJOQHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:07:38 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205171] kernel panic during windows 10pro start
Date:   Tue, 15 Oct 2019 16:07:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dront78@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205171-28872-dtUyxyy5QB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205171-28872@https.bugzilla.kernel.org/>
References: <bug-205171-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205171

--- Comment #5 from Ivan (dront78@gmail.com) ---
I can confirm the issue is gone after upgrading to the latest kernel in
ArchLinux.
Linux 4.19.79-2-lts #1 SMP Fri Oct 11 20:04:02 UTC 2019 x86_64 GNU/Linux

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
