Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A009B20C01E
	for <lists+kvm@lfdr.de>; Sat, 27 Jun 2020 10:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgF0IVe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 27 Jun 2020 04:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgF0IVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jun 2020 04:21:34 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 200101] random freeze under load
Date:   Sat, 27 Jun 2020 08:21:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: filakhtov@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-200101-28872-82n499iHoL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200101-28872@https.bugzilla.kernel.org/>
References: <bug-200101-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200101

--- Comment #4 from Garry Filakhtov (filakhtov@gmail.com) ---
Okay, have played a bit further with all of this. I have managed to get freezes
on linux-4.19.120-gentoo as well, after using CPU pinning together with RR
scheduling policy and priority to 1 for all vCPU threads.

After removing the commit 47c61b3955cf712cadfc25635bf9bc174af030ea it seems
like the system is indeed working without freezing. I will continue testing and
updating as I get more information.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
