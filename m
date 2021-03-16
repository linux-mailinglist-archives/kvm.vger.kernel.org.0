Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF73433D281
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 12:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhCPLOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 07:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231918AbhCPLO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 07:14:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E6EF6502F
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 11:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615893267;
        bh=HMwO3aJAmH7+84HKNhkA5yBipRE4XP4cd1D0gqn36UI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HsXIEwC8s4lFZJQrwpYBHfUkDx7zEIWAjC/oJl5Kz5p16mkwLiQqoXq9Sr5nXoU0S
         NbqRfcAdUFiwcItB+cvxUhU0dcueLXsmuIudzelTXyXPYJ4IB6QA8Ny8CFxQTBm+9N
         E3UlzoZ3ZIJTRbNxOLidK24asjBTrcN/HbexVA5K0IlBy6P+nHTS3ZSLwqewelkC+e
         n+dBNOOIKKHWzX1OnFkROnYnX22GmwSQKYY2Iy6hSCGKRJdNUiJsxV7XT489yJClsd
         /Jaop//OwBL3FfO8X5sHLvvmShj622QbpmZGV5HoAWtYJPUz9TMyGH4eCVo/W/BQKg
         qCKF65LX4cSOg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 3BC206536D; Tue, 16 Mar 2021 11:14:27 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Tue, 16 Mar 2021 11:14:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david.coe@live.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-RyHSaT6OKM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201753-28872@https.bugzilla.kernel.org/>
References: <bug-201753-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201753

--- Comment #23 from David Coe (david.coe@live.co.uk) ---
I would guess that the difference between warm and cold boot is due to your
Ryzen 2500U (like my 2440G) hovering between needing 5 and 6 tries of 20 ms=
ecs.
Without adding Paul's logging you can't tell!

If it would help anyone (and you trust a non-official kernel recompile) I h=
ave
placed 4 variants on my Box account. Both Suravee's original patch with 25 =
x 20
msec tries maximum and logged and Alex's very simple patch are applied to
Ubuntu's 5.8.0-44 (20.10) and 5.10.0-14 (21.04) kernels.

The version numbers are identical so that Ubuntu's own DEB's for linux-tool=
s,
linux-headers and linux-libc-dev are compatible. My linux-image replaces th=
eir
own linux-image and linux-modules so take care that you can still boot from=
 a
'known' kernel.

They all work for me with quite heavy use on KVM but YMMV :-). Mail me if y=
ou
need access.

Best regards to all and my thanks to Suravee, Alex and Paul!

David

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
