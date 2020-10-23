Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55853296B57
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 10:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460732AbgJWIkx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 23 Oct 2020 04:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460690AbgJWIkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 04:40:52 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209253] Loss of connectivity on guest after important host <->
 guest traffic
Date:   Fri, 23 Oct 2020 08:40:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: justin.gatzen@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209253-28872-Qehx8qD6rd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209253-28872@https.bugzilla.kernel.org/>
References: <bug-209253-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209253

--- Comment #6 from Justin Gatzen (justin.gatzen@gmail.com) ---
Thanks, I will revert that commit and report back. This commit was backported
to kernel 5.8.4, which would jive with my (unproven) suspicion that 5.8.2 was
unaffected.

Also, to clarify, the second stack trace on my previous post (Comment #4) could
have infact been a VFIO VM. There were several VMs running with vhost/virtio
net communicating with each other and it was not clear which VM triggered it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
