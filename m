Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF77298D8B
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 14:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1738074AbgJZNMy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 26 Oct 2020 09:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731566AbgJZNKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 09:10:48 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209867] CPU soft lockup/stall with nested KVM and SMP
Date:   Mon, 26 Oct 2020 13:10:47 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-209867-28872-cWZD1N85h5@https.bugzilla.kernel.org/>
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

--- Comment #2 from Frantisek Sumsal (frantisek@sumsal.cz) ---
Created attachment 293199
  --> https://bugzilla.kernel.org/attachment.cgi?id=293199&action=edit
Fedora 32 host (AMD) - full log

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
