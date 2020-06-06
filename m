Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857401F0809
	for <lists+kvm@lfdr.de>; Sat,  6 Jun 2020 19:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgFFRhI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 6 Jun 2020 13:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbgFFRhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jun 2020 13:37:07 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208091] vcpu1, guest rIP offset ignored wrmsr or rdmsr
Date:   Sat, 06 Jun 2020 17:37:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: commandline@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208091-28872-lPWtjocG2H@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208091-28872@https.bugzilla.kernel.org/>
References: <bug-208091-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208091

--- Comment #1 from Joris L. (commandline@protonmail.com) ---
iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=DD:00.0
address=0x7fb99eeb0]
iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=DD:00.0
address=0x7fb99ef10]
iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=DD:00.0
address=0x7fb99ef50]
iommu ivhd0: AMD-Vi: Event logged [IOTLB_INV_TIMEOUT device=DD:00.0
address=0x7fb99ef70]
vfio-pci 0000:28:00.0: timed out waiting for pending transaction; performing
function level reset anyway

device=DD < anonimised

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
