Return-Path: <kvm+bounces-44790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78DFFAA0FD2
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3370847BC4
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 14:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E97821ABD2;
	Tue, 29 Apr 2025 14:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EPbu1zoI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9748821ABA6
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745938738; cv=none; b=fBeCGda/QY2Phcs++uRvVnzWqgTzN2sNNgHknVI/7Lq/JIshNYVpQcVljga7knSpMM+ld+Jf0JxfOW+L+n3cf2pz/M0qLA5byFjtCjQH9qIq2W4m6WHEvf5ldXbfRrbKQFRbYZZwqBsIRh2eUTD9WhIKVB6MTpv6PzHjRNpMEbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745938738; c=relaxed/simple;
	bh=h0CW+peBPB/UdlYoejSuZEtsk4tTo/l08P0R/W4QUG4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RUM/LYDfxfyOiQh/KPD+9HR46r4UAz9WMAwd1+SOw0nUxVD11EArGoaQRBYuUKrSOCwQGIBqVzLXy59xdI+tFVJrtQP3Kp9AhlA7STXXeKzz311fOceryoYMXAJyE9+wbXWEY6DhZSCjHjD/sxx5oAuY/7ZIG/fNjjR09WA8Dvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EPbu1zoI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B6B1C4CEE9
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745938738;
	bh=h0CW+peBPB/UdlYoejSuZEtsk4tTo/l08P0R/W4QUG4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=EPbu1zoILAy4vjoeMKP4aEv2+xq0ZML2goVFS4UlfTUuhAtnw2rh76itsE48kL/SG
	 RGdaVndTV7ptRNSoa10B3gIqwD9Nh7C/BTqVRGFucwNayhVUC2eFBgjGqMphnQMzb5
	 nn1ZN4edjJ4Ys0UewU1qz2nq1S0N3TNAeXYxCOZLFK+sGtz+Ucqa79IwvSzZtseWCe
	 rf8GhO35ZU8ibCKwlfNQ15zuu4w3OXOW2oG2i5H4gYCjZCxrbIDrMCzbICXD2+3wHU
	 FuGw+JKuF/UD1upl///AG5cRo28ma6Se/kI4O+wXwAuNfIzcw+mh8AWw7M8Pwil2Mz
	 ePeYeaidGu6ow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E1CA6C41612; Tue, 29 Apr 2025 14:58:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 14:58:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: clg@kaod.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-220057-28872-iKq0pkdVor@https.bugzilla.kernel.org/>
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

C=C3=A9dric Le Goater (clg@kaod.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |clg@kaod.org

--- Comment #25 from C=C3=A9dric Le Goater (clg@kaod.org) ---
"-cpu host,guest-phys-bits=3D39" should help to define compatible address s=
paces.
Could you try please ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

