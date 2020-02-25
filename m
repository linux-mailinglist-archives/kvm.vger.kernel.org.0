Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34A016BB3B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 08:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgBYHuZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Feb 2020 02:50:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgBYHuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 02:50:25 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Tue, 25 Feb 2020 07:50:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bonzini@gnu.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-jFN4nxYmHe@https.bugzilla.kernel.org/>
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

--- Comment #20 from Paolo Bonzini (bonzini@gnu.org) ---
> I looked at the other code and it seemed to me that the condition should be
> an "or" instead of an "and"

Uff, my bad, I used an OR here for testing and wrote an AND in the comment. 
Age seems not to matter at all. :)  Regarding the performance, let's compare
your current score with these two cases:

1) adding to the libvirt XML

  <ioapic driver='qemu'/>

right below

  <apic/>

2) loading kvm_amd with avic=0 which will surely disable the AVIC.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
