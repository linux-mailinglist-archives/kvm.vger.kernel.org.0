Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F099B1741CF
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 23:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgB1WIG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 28 Feb 2020 17:08:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgB1WIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 17:08:06 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206707] Irregular behavior debugging userspace program on SMP
 guest
Date:   Fri, 28 Feb 2020 22:08:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dustin@virtualroadside.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-206707-28872-2BpMOpsGS5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206707-28872@https.bugzilla.kernel.org/>
References: <bug-206707-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206707

--- Comment #1 from Dustin Spicuzza (dustin@virtualroadside.com) ---
Created attachment 287705
  --> https://bugzilla.kernel.org/attachment.cgi?id=287705&action=edit
GDB control script

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
