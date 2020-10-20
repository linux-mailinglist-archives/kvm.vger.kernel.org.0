Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38774293EAD
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 16:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408082AbgJTO2W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 20 Oct 2020 10:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408057AbgJTO2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 10:28:20 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209253] Loss of connectivity on guest after important host <->
 guest traffic
Date:   Tue, 20 Oct 2020 14:28:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: arequipeno@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209253-28872-t4GxcdPlLx@https.bugzilla.kernel.org/>
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

--- Comment #3 from Ian Pilcher (arequipeno@gmail.com) ---
Thanks for the note about 5.7.15.  I've built it for F32, and my GPU *seems*
stable so far (been running a video upscaling job for almost 24 hours).

(I did have an issue where the hypervisor (libvirtd?) seems to lock up if I try
to start the guest wit virt-manager over SSH; had to start it with 'virsh
start' locally.)

This indicates that it *may* be possible to bisect this issue, although the
lack of a time-bound reproducer means that it will take a long time.

@Clément - Can you test 5.7.15?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
