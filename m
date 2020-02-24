Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593CF16AC26
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 17:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgBXQub convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Feb 2020 11:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbgBXQua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 11:50:30 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Mon, 24 Feb 2020 16:50:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-206579-28872-5XfHTPITXQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206579-28872@https.bugzilla.kernel.org/>
References: <bug-206579-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206579

--- Comment #11 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 287579
  --> https://bugzilla.kernel.org/attachment.cgi?id=287579&action=edit
Patched rc3 dmesg crash output

Since rc3 just came out and Suravee successfully tested the patches I went
ahead and did a clean build of rc3 with the two patches again and unfortunately
my results were the same, kvm crashes at boot. I've attached the dmesg output.

By the way, I'm a retired hardware/firmware/software designer from the olden
days (1980s through early 2000s), specializing in embedded systems. So I've
done everything from designing simple CPUs and microcontrollers, to firmware
and simple RTOSs, to assemblers and high level software, including Linux. Heck
I was working before things like Linux and GDB even existed! :) So if you need
me to do something more complex I'd be happy to try. I'm pretty rusty though,
so I don't know if trying to instruct me would help or hurt :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
