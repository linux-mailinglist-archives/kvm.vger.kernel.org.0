Return-Path: <kvm+bounces-38825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7E0A3EA11
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 02:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC5DF7A6183
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C541838F80;
	Fri, 21 Feb 2025 01:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYh111H5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8078821
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 01:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740101543; cv=none; b=GQ54L/rCuphBV2Nn/LH8mQaS/aFDDBRIt+29NLE31+fVoxNQKf094FagiLd0wsUjEK9+FK/pG5tdPNEtnOCNCZ/EIotdUH2i3EYlD3861BRZNBYRPNgl3WyzbKauh/+5dBya5/FwKSZpT2TmjHgiihcLy/8ZReeIwRPCFSig0Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740101543; c=relaxed/simple;
	bh=756RzFQZtzS4DCv9av5iw4wVT7jbXJWYzNmX4VwaN7E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fMN9QKmKpZgchfG2+bHFHrt4QuM+u/11SnT1yVliWmcL1M2ltEdGPx8b0iOoR+R2LQgxkJoqJ6LIu+i3AkkJ5Uke7NQnuNjG2TPUHbbZnCtFFyaH9DbP3csypnDsdHCulmcuwGeAxbCvtqhns17uLwP6HBa42QBWEKsKAQCIdcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYh111H5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0174C4CEE6
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 01:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740101542;
	bh=756RzFQZtzS4DCv9av5iw4wVT7jbXJWYzNmX4VwaN7E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oYh111H5zWgoZ+TEWbnXlVP+nTgirwj3HIYPvRmaEDhp6mYJLdQ82C8skFEzQghQT
	 9PJ2IDl8hB17Yvfdo+1qYZ3NFJBV0lHgOohcXGtiM1OqmTJAhvKSOq50aJC3iFIZJr
	 Xi7M5Oal2MpAxgjjSe34cAHnTu9LrMzBRcaFu48MhWcaUi3OuoF1FJ12rGcnr2rHun
	 uT8gr5KYZxqq7SYglDMBACaKOAfU5cx5YRKYzRHUSuiTejzNI5+aQgR3TniWTbopo9
	 UW5Qhqge3LwW5Gr3SYzYdNSBGDD6rv1OTZAa3dlqjYtZODu7pDXlkcbK16kRRWrMtY
	 5NBrS/bm/RY+Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C8E46C41606; Fri, 21 Feb 2025 01:32:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Fri, 21 Feb 2025 01:32:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rangemachine@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219787-28872-aDsI6bzjsW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219787-28872@https.bugzilla.kernel.org/>
References: <bug-219787-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219787

--- Comment #11 from rangemachine@gmail.com ---
Here we go:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D408eb7417a92c5354c7be34f7425b305dfe30ad9

Double-checked both reverting commit or unsetting X86_BUS_LOCK_DETECT fixes=
 the
problem.

Added bisection log and config to attachments.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

