Return-Path: <kvm+bounces-54791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B07B28195
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 16:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20664175BC8
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 14:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F9E2222AC;
	Fri, 15 Aug 2025 14:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMV4PE9v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B96D22173A
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 14:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755267886; cv=none; b=FjI+E4qyLkV8PBheSxK7iKiIhS6SOkSp4/a7mlv/bGDuVXPzSmbzOFVLi8e+Sd0jQg+vIdUQ1A1Oa3QjzgMvYko8qUXTTxPbvybvTDAur/xDyLYCNhWUvgLiesUI6rNXuXeopfeCoaNxlcivBpiw4CWfsOoMQsOT51Iido3rD4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755267886; c=relaxed/simple;
	bh=ReJmQOH11tX1pIY/1b1bcgNA8YUsuy8s7rBCJLMIgXE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EIC0bys12/ScCkjVW4+oOfnuMGSEHvkyxW3uJahZ91hELsNCM3Y9CWe3DFpXBWB0PLnE125gqpRUPyvQkNOLp2CJKI3+lVvBnAMkKF/k55Nr/kqOutdRpTjZFtwNGlwy2xO+NXbz/diiYLL8eaGwYebZL14K2SofXeV4Pgfoo18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMV4PE9v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3EF5C4CEF5
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755267885;
	bh=ReJmQOH11tX1pIY/1b1bcgNA8YUsuy8s7rBCJLMIgXE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JMV4PE9vyd6jy5oOltsqSwpgmBzh9rIb+TByxHj6/ztDXbEZ0NftvcBfcbX4uj9om
	 apOn+/vUk/LbJtLFVEw7WuAooFWsi+o4CoGH5zQLT4jNZnBL8HlMmZbMT4ekB42KYi
	 JNRnMV44NOjoFS3k8r4V77IhErogvCUvMSsSWWB7u4FRLl60PrTACNkarq1USrU8nc
	 wvNLtToEuYsuqyBY/Ez12xm1q4J2ejuU+oy60nyk/jIxzdSsvP4GbUL1KT+1oc3bnu
	 lDVhHXJcGlm5uW2GdF0tCrJ3p5z8SeLdZWwSiVyBjbyEOv9v7+PCNEw0vjAVPcrYpy
	 AyG+/VL3S6pog==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B84B2C53BC7; Fri, 15 Aug 2025 14:24:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220453] kvm/arm64: nv - guest with hypervisor hangs
Date: Fri, 15 Aug 2025 14:24:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: amy.fong.3142@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_bisect_commit cc cf_kernel_version
 cf_regression
Message-ID: <bug-220453-28872-CpzXbR8cGf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220453-28872@https.bugzilla.kernel.org/>
References: <bug-220453-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220453

Amy Fong (amy.fong.3142@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Bisected commit-id|                            |b5fa1f91e11fdf74ad4e2ac6dae
                   |                            |246a57cbd2d95
                 CC|                            |amy.fong.3142@gmail.com
     Kernel Version|                            |6.16 6.17-rc1
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

