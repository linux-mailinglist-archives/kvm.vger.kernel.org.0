Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0641D2CD0
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 12:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgENK3j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 14 May 2020 06:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgENK3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 06:29:39 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207551] unable to handle kernel paging request for VMX
Date:   Thu, 14 May 2020 10:29:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tobias.urdin@binero.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-207551-28872-csgDEB6VjC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207551-28872@https.bugzilla.kernel.org/>
References: <bug-207551-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207551

Tobias Urdin (tobias.urdin@binero.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #4 from Tobias Urdin (tobias.urdin@binero.com) ---
Confirmed this is resolved in 4.19.123
Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
