Return-Path: <kvm+bounces-44620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF4F1A9FD7F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 01:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B1EF1886870
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 23:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2867721423F;
	Mon, 28 Apr 2025 23:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lu9G60Gx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515EC21420F
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 23:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745881550; cv=none; b=hp6mEwAzfcYfC/ms+lIHgMXgtRjbQr2Ig1aJs+8+KGiTgIvUEoZ/RiE8U8pqs51Vu7YI+orBE0bJyWAvD3J3Iqmu2bZmpraK7irhZCIsVSD9+XglvUdx7jav6M5bgmvck2UPWxnXWembqu6c/tRdp4XOkPhDzTfTLijT/Pqx5PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745881550; c=relaxed/simple;
	bh=rHhOC+oY82bPAsFpHkSo46vZV2zeAFf6K9wEE+yR+mU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k+fGGKy/Zw/pJF+T+BcAkgCDFAVuBpr8sL3noUYTVQP6dcJqy6byjJMHu8/bR02p3ZRSUg//ep4v0KUAm1Ypg8Vpd7OufkDs24cuxR7hCwtOzQExGiKwutWTW5W19SiYaaq/icz9nx234srI6O+870FkuQKnwNB/JTMpoRsh8mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lu9G60Gx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF14EC4CEF1
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 23:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745881549;
	bh=rHhOC+oY82bPAsFpHkSo46vZV2zeAFf6K9wEE+yR+mU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Lu9G60GxO2l8qBvu98am0/e20aaPctKF1GD6Va/TwTg4ClLnNFasIl1Pw6s0izpgR
	 miCnibFvHCW6JiywUYbvCJQXX/joFPkPds9Dm/1TjRONZ0kRUSODWySv6z5/KCGlaP
	 r0YrO7/ulr/VgD49+bG+lCvnCS8bMzfjBURGC5VC2Hs2zHn9denEcR27zB0b+HgctX
	 odh6U9fyAnp62zF8B0cQgD1dGh7SXcKvyLoUnuowAMCw8/gnWaXC9gM9gBbjiL9AKO
	 n9cqtuf72ViWk6cceecw94VwSBvPYlTtCuyDNm+ISk+r1imXgPitMjvO2b7w4vS1Vh
	 3hZJ/3yaFNcJg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C4AAFC41612; Mon, 28 Apr 2025 23:05:49 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 23:05:49 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220057-28872-J20De1ktqJ@https.bugzilla.kernel.org/>
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

--- Comment #20 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308048
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308048&action=3Dedit
log_vm_start_up_to_crash

as far I can tell, it changes nothing. I loaded up unpatched kernel and
attached complete VM startup up to crash.=20

ps aux | grep qemu

at file startup.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

