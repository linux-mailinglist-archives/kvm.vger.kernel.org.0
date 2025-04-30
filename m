Return-Path: <kvm+bounces-45002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A755AA57F8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 00:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFE231C0847C
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 22:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7CD2248BE;
	Wed, 30 Apr 2025 22:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sLAWRSgJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDE522424E
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 22:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746052438; cv=none; b=qOklsVs3mTzakmkF/6h92UKecYLpa6GvldRy6y5dVxbbhYdgehbidI5cLsbT6xf95SozM/ulBW0y3zlnk2z1qgoGstqYZhSIw1Q8tskiaK19bkxhfEdGST8Gt9Y8vizXNM84zvZNZLeEhVWMQdJwjD/Jdaai3ZUj3dO38ym/kTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746052438; c=relaxed/simple;
	bh=6Oe5UeAHzAo1GOMo9/7OwkqVS9wsETXeKZrSsL/Jsdo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UFL3KrA/tcwcAWx7Lsw55kynr6kzQra/7sltlrdn+gPq1eMxXHSSiK9D3Ugq4qbkkQrKoNmEFYLdXGXrllfFSHVPdMcyuI2gfcDddkOXUe4b8LZBPMnrHIEfVkYhizMtUjGtmULl8KKpDeZZlT+pWYk/uX3eDSMCvHUFv0qqneM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sLAWRSgJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48112C4CEF1
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 22:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746052437;
	bh=6Oe5UeAHzAo1GOMo9/7OwkqVS9wsETXeKZrSsL/Jsdo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sLAWRSgJ7+8KOJhiB0vjE9yesI5G9KaNpSyE41tprOHcaNQYauRJf4qg2B7wnbpJ/
	 Ke39NU0GtzvfdkkSvnNMLPC+pct0jY9RvgnaulzwfK9152+TceeRWOh9qP5jseNEHe
	 dk/MBycLazD1RJOR3NbCl7sSuS/pKWlqT/j2wohQ8OJ2eeABFBpmbm5O/FuhGB18+9
	 ciHN1KnKRKrvy43/IbZW1QDXyZ+VBeYpUFTK/rUVpaFlhW8wE+qwK8V4QHcsTDtiFc
	 4p+6+DVBcrG6T0j8viXiQbm4ZZ0BpBjRZIzxsY200rgixOQBqyPqerBO4t4APxvSnJ
	 hg0a3OiyBl0RQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 40D1FC433E1; Wed, 30 Apr 2025 22:33:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Wed, 30 Apr 2025 22:33:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220057-28872-a8Yzo6byQF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #38 from Alex Williamson (alex.williamson@redhat.com) ---
Created attachment 308062
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308062&action=3Dedit
patch - log errors from huge fault handler

I'm still not seeing any leads for what might be the problem.  The QEMU dum=
ps
suggest a problem handling a page fault and the original report implicates =
the
new huge_fault handler.  So let's log anything from the huge_fault handler =
that
doesn't install the pte.  Please apply this patch to your stock v6.14.4 ker=
nel
and report the resulting dmesg after the VM crash.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

