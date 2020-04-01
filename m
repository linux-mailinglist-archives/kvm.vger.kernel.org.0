Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232FC19B48A
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 19:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbgDARJl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 1 Apr 2020 13:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbgDARJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 13:09:41 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 203923] Running a nested freedos on AMD Athlon i686-pae results
 in NULL pointer dereference in L0 (kvm_mmu_load)
Date:   Wed, 01 Apr 2020 17:09:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jpalecek@web.de
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203923-28872-IwN1VvtyyK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203923-28872@https.bugzilla.kernel.org/>
References: <bug-203923-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203923

--- Comment #9 from Jiri Palecek (jpalecek@web.de) ---
(In reply to Anders Kaseorg from comment #8)
> The second patch was committed as v5.4-rc1~138^2~6.
> 
> I found this while staring at a similar-looking kvm_mmu_load NULL
> dereference on the hardware kernel while starting a nested VM on an AMD
> Ryzen 7 1800X, kernel 5.4.28.  Should I try to expand this into a full
> report, or does your original recipe still reproduce?

Hi. I was going to say your problem was likely to be something else, because
that original problem got fixed, and anyway all of my problems with kvm were
specifically related to 32bit. However then I tried it for myself and it's
still broken, albeit with a different error message. Oh well...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
