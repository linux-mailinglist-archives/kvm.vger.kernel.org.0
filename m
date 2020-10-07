Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24159286B02
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 00:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgJGWpu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 7 Oct 2020 18:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbgJGWpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 18:45:50 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208767] kernel stack overflow due to Lazy update IOAPIC on an
 x86_64 *host*, when gpu is passthrough to macos guest vm
Date:   Wed, 07 Oct 2020 22:45:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-208767-28872-znY1iqrlt9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208767-28872@https.bugzilla.kernel.org/>
References: <bug-208767-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208767

Alex Williamson (alex.williamson@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alex.williamson@redhat.com

--- Comment #7 from Alex Williamson (alex.williamson@redhat.com) ---
(In reply to Paolo Bonzini from comment #1)
> This should have been fixed by commit
> 8be8f932e3db5fe4ed178b8892eeffeab530273a in Linux 5.7.

This is not fixed and it's not unique to a macos VM, a Linux guest can also
reproduce this.  I've seen this both during PXE boot and during shutdown with
certain NIC combinations (see rhbz1867373).  The only workaround is to disable
acpiv (kvm_intel.enable_apicv=0).  Any suggestions, Paolo?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
