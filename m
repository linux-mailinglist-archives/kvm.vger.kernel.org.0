Return-Path: <kvm+bounces-34276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D309F9F63
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 09:58:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96DA0168F60
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 08:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A071EE7AB;
	Sat, 21 Dec 2024 08:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uLv5h40Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D982AF16
	for <kvm@vger.kernel.org>; Sat, 21 Dec 2024 08:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734771472; cv=none; b=EyMch2sNtpuWITpNse8t0/oIP+ymaN4QcP8VPU9XrUJYjzAmci3TwjXYodjoOlrJU1udGGyy9VOWM1K8/3l3AMPkSsvS0/KP7swO71s5SMnz35bc5Mkskwk4nBG+BVOVyWSbeSOuHCDgkVISdss4O9XGaHthF8dup235oh8ZALY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734771472; c=relaxed/simple;
	bh=U7sEtLeaLYXtsXDtauqOPJlYkg3Uv/Io6ITNqkTkOJo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sMdUe7mZW/1iqr4EBBdYjf4pa2+ejjmBbU4silEYWALTOQIX0FXPOqTHQIFG8Inz0PUd+0XCJ9lfhF02fJNYyVzi4kDrj6NI2Lc4woNKBqlpStdi+OFoW/1wTNSipAo1znDFEU9kFSckiUr6JoPjHMJ3Fg+KaPEc4XvtbGkTAw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uLv5h40Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5289BC4CED7
	for <kvm@vger.kernel.org>; Sat, 21 Dec 2024 08:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734771472;
	bh=U7sEtLeaLYXtsXDtauqOPJlYkg3Uv/Io6ITNqkTkOJo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uLv5h40YdxCvn4Y7x0pB590Fm7QiwoKj6IcF9fH8okRRbrsUko5pB6p8rgDu6gk6q
	 mjFwvjfM+oIBUloD2ScKkhMDfCYJR2lwqikxhOIvH4PgyI/NE+TcTBcRvts1tbOBRO
	 YDXnGOzMIzwdpfWvCHwKN7bee0mio5o/ZerK1EqrGqH6YSC6e2B/r+Sn0/Ho1ZHfqk
	 oobzWVqCwmAS0sTquzlsau9sIxs2a/LFI9MBlUEXrxdGpN5p/QXJHHVgjjSSm/aw/U
	 r61YMZ3/87bT0hs0mqt+5urNNKMojElwzIflYggOVsmQX0X00JZWVQbz2rNItTCGYw
	 vjiGbrEmnraiQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4854DC41614; Sat, 21 Dec 2024 08:57:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219618] qemu cannot not start with -cpu hypervisor=off
 parameter
Date: Sat, 21 Dec 2024 08:57:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: athul.krishna.kr@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_bisect_commit cf_kernel_version cf_regression
Message-ID: <bug-219618-28872-qJdKmEwfRd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219618-28872@https.bugzilla.kernel.org/>
References: <bug-219618-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219618

Athul Krishna K R (athul.krishna.kr@protonmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Bisected commit-id|                            |74a0e79df68a8042fb84fd7207e
                   |                            |57b70722cf825
     Kernel Version|                            |6.12
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

