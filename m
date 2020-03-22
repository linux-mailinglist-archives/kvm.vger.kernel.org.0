Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6FF18E931
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 14:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCVNnD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 22 Mar 2020 09:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgCVNnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 09:43:03 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sun, 22 Mar 2020 13:43:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: anthonysanwo@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-ujGkxTHU0b@https.bugzilla.kernel.org/>
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

--- Comment #46 from Anthony (anthonysanwo@googlemail.com) ---
Suravee Suthikulpanit 

Just wanted to say thanks a lot for the latest patches - 

iommu/amd: Fix IOMMU AVIC not properly update the is_run bit in IRTE -
https://lore.kernel.org/patchwork/patch/1208762/

This patch fixes the performance differences I saw when I was testing AVIC with
your earlier patchsets. I believe this was what caused my confusion as because
I found when AVIC was enabled I had worse performance at times so I thought it
was due to me misunderstanding how things should be setup.  

kvm: svm: Introduce GA Log tracepoint for AVIC -
https://lore.kernel.org/patchwork/patch/1208775/

This is perfect for people like me with limited understanding on things as it
more easily tells you whether or not avic is working.

On that point with the IOMMU AVIC fix i have had great results with my setup -
which now as a total of 7 PCIe devices that are pass through to my Windows
guest.

Thanks again to everyone for all the hard work.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
