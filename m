Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CDD23DFFD
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbgHFR4a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 6 Aug 2020 13:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbgHFQRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 12:17:23 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208767] kernel stack overflow due to Lazy update IOAPIC on an
 x86_64 *host*, when gpu is passthrough to macos guest vm
Date:   Thu, 06 Aug 2020 09:09:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yaweb@mail.bg
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208767-28872-a9ZOJEmpTj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208767-28872@https.bugzilla.kernel.org/>
References: <bug-208767-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208767

--- Comment #6 from Yani Stoyanov (yaweb@mail.bg) ---
I am not sure if this is relevant but there was old bug which explains how osx
configure IOAPIC with the wrong polarity bit values. I may be interesting to
take a look (I know it is from 6 years ago).

https://www.contrib.andrew.cmu.edu/~somlo/OSXKVM/index_old.html

the part: 

ACPI-compliant operating systems are expected to query the firmware for an
indication of which polarity type (ActiveLow or ActiveHigh) to use for any
devices with level-triggered interrupts, and to configure the IOAPIC registers
accordingly. Both QEMU and KVM have accumulated a significant number of
optimizations based on the assumption that guest operating systems use
ActiveHigh polarity, and are coded to assume that "physical" and "logical" IRQ
line states are in sync. Even when a misbehaving guest OS (you guessed it, OS X
does this) ignores the ACPI polarity hint (which in QEMU/KVM is ActiveLow, i.e.
"physical"=="logical") and configures the virtual IOAPIC with the wrong
polarity bit values, both QEMU and KVM will mostly use "logical" IRQ line
levels.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
