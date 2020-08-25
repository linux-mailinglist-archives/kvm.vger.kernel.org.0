Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D492251AD6
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 16:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgHYOcF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Aug 2020 10:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHYOcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 10:32:05 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209025] The "VFIO_MAP_DMA failed: Cannot allocate memory" bug
 is back
Date:   Tue, 25 Aug 2020 14:32:04 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209025-28872-RZ2XLbrezk@https.bugzilla.kernel.org/>
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

--- Comment #6 from Jens Axboe (axboe@kernel.dk) ---
(In reply to muncrief from comment #4)

I'm attaching the patch that should fix this. muncrief, I like to provide
proper attribution in patches, would you be willing to share your name and
email so I can add it to the patch? If you prefer not to that's totally fine as
well, just wanted to give you the option.

Attaching the patch after this comment.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
