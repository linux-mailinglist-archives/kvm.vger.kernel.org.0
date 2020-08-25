Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B99251ADB
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 16:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgHYOcu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Aug 2020 10:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgHYOct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 10:32:49 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209025] The "VFIO_MAP_DMA failed: Cannot allocate memory" bug
 is back
Date:   Tue, 25 Aug 2020 14:32:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: axboe@kernel.dk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-209025-28872-0Hs4lonblW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209025-28872@https.bugzilla.kernel.org/>
References: <bug-209025-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209025

--- Comment #7 from Jens Axboe (axboe@kernel.dk) ---
Created attachment 292167
  --> https://bugzilla.kernel.org/attachment.cgi?id=292167&action=edit
Fix sqo_mm accounting

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
