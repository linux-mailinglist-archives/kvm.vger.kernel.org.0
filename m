Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEF5107C45
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 02:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKWBW2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 22 Nov 2019 20:22:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfKWBW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 20:22:28 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205631] kvm: Unknown symbol
Date:   Sat, 23 Nov 2019 01:22:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: riesebie@lxtec.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.isobsolete cc attachments.created
Message-ID: <bug-205631-28872-MwkAjf3roz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205631-28872@https.bugzilla.kernel.org/>
References: <bug-205631-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205631

Elimar Riesebieter (riesebie@lxtec.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #286021|0                           |1
        is obsolete|                            |
                 CC|                            |riesebie@lxtec.de

--- Comment #2 from Elimar Riesebieter (riesebie@lxtec.de) ---
Created attachment 286027
  --> https://bugzilla.kernel.org/attachment.cgi?id=286027&action=edit
Kernelconfig with VIRT, KVM and USER_RETURN_NOTIFIER.

Ups, attached wrong config. Please notice the new one. Unknown symbols are as
shown inmy first post

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
