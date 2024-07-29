Return-Path: <kvm+bounces-22501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF2793F50D
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 14:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCD7C1C21924
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 12:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF571147C79;
	Mon, 29 Jul 2024 12:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrrzemQ2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C081474D9
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 12:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722255601; cv=none; b=n1LvvJHGIs3UN2lsYmuTg2L5e35L7zzi/5PoCwyaZa+hPHFv1vp2xlmR34JMqlHDdLnl1bOox6YkcK9gcWp4hwAHwU5QKH0cu0ySgybBeVCZEclfiFGFyGtfKy9N0yNVGRLMVSJ1czzKhyJA46cEth/vtIz0/Cf9o8xWi/ok2zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722255601; c=relaxed/simple;
	bh=p36jU+OyHAyZSrOg3PdJvQW6vRS2cbXnoIQOb5+76H0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WkNL0s5V/bL/9SjKGcW3OK81E8+no/sNC5JFHdsA0BbyPF5WGi3kEzGCOo5avFdtraZH0WnCileEWsl1l+/ZCf9Ig8HCYWL3UyK2wEGwepw1tDRHmhzSXDaxu3WXGnzKyxn0puzIBXqN+jMzlDY12L+YM3gdDCKTl8Okd3E2dZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JrrzemQ2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0451C4AF07
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 12:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722255600;
	bh=p36jU+OyHAyZSrOg3PdJvQW6vRS2cbXnoIQOb5+76H0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JrrzemQ2zq5QXjL8wcc7ciWyhD0AdQgg67+hd7AFsGFo2Vp51jxEhymywmYOOt5xX
	 FmJW1woD/UGssCTisoUjiDsAi8PvQZlgbtLErc7HEF0iG7ZAWn5sHLQ9zPUGeTItnj
	 m1gAEuhnkkT7F0nOQ7+ECzzsMQ9N6S/cYhwrnw9DEuWYmfb99FjZXqRCsNnP18A1S5
	 ronftcYrKCoJI+KyGvk4EhlR0Bg5XEWCU+1CxhstYNJcyoifgWVjradAHSe+gCbwNn
	 i4p8B3Xpvl61g26eJ0NXjZG9nugn+bSqn6Le8HwyiCT6ElhGDwWifOM02s0QsoRBce
	 uNJzKtNH+AZlg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9B4EDC53BB8; Mon, 29 Jul 2024 12:20:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219104] A simple typo in kvm_main.c which will lead to
 erroneous memory access
Date: Mon, 29 Jul 2024 12:20:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: trivial
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zyr_ms@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: keywords
Message-ID: <bug-219104-28872-CXdgJnnaOS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219104-28872@https.bugzilla.kernel.org/>
References: <bug-219104-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219104

zyr_ms@outlook.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Keywords|                            |trivial

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

