Return-Path: <kvm+bounces-44469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D28A9DE16
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 02:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4601C4653D3
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 00:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D114227E98;
	Sun, 27 Apr 2025 00:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rU4fr5qt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCCF1367
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 00:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745715011; cv=none; b=LzuOwkI5DEKhGjiX3CHKq4Wx3Xw4XGZpBLMe2/AVTRlaq6o/ip/rRd8K7CEFZPxNVOcDX3zQmj8Pw0Z6vUD+VFRcvU9QVOkUdwVURxxeabMfNG6kZk48Z+U9WWa60FXtHyfmeQABra/ivPY+VykgjxifDUC03Tpz2RtmhVIP2CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745715011; c=relaxed/simple;
	bh=XsCTmsPaDEFGFvl6SmXaPXAQgLQLkhqWD3leyJThnrM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K9h0Hwq97xiQ3Z2u7UksJIx6Dzc9VMczdT7wMeB71h3YiwMvPCXDr7rseQ+HndrrFWt1CCMlNkQSSYpMTV0cdFauKHqwr0adf4SiOb1i7YF4au+OR9xiHeLOaS7ZgMmTZ7yLknMhNk83ruJ3ywWRB4Wd0bCLbWpkfTRxod+P88M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rU4fr5qt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E6E8C4CEED
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745715011;
	bh=XsCTmsPaDEFGFvl6SmXaPXAQgLQLkhqWD3leyJThnrM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rU4fr5qtiMfpWVagYN2ebUrs59q/UkOuphjub7tGm49R9312DcD3yxJQBrHuliEj1
	 yfNifh81FMjJ8z0TSKQGXvY9Ll8AcdSJkhxUP8p+YlIt6novemgZeAJShtCMgqk/yv
	 Od+OLeGcSOceFHBfkN/RtFAVFj0l48HzhnRLw4lIZa8E85yITWiRpAHlLWs24emWsx
	 whtEsg5Clzd6rrRoq8aS1Q2jYUvfYF0OUoJJu/kCCp8UPkhDfmQkws+UZ9Dn4frTqH
	 D7WC9V0DgfM4h37sZz4eXzczHha+qdzVo+36GkNcHrsIM8jWJtoIU0EOBA/9F7DIb4
	 laTCauDBts35g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 19EE9C53BC7; Sun, 27 Apr 2025 00:50:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Sun, 27 Apr 2025 00:50:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: adolfotregosa@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_bisect_commit cf_regression
Message-ID: <bug-220057-28872-2SrgVdPhMs@https.bugzilla.kernel.org/>
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

Adolfo (adolfotregosa@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Bisected commit-id|                            |f9e54c3a2f5b79ecc57c7bc7d0d
                   |                            |3521e461a2101
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

