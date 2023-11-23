Return-Path: <kvm+bounces-2349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB827F5713
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 04:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2453BB21203
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 03:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F438F5F;
	Thu, 23 Nov 2023 03:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRwjDyq3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155808BEB
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 03:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BD72C433CA
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 03:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700710729;
	bh=V+t4V5gPAnmHstVfELWD/++CnHWz0gtlThk9afW9pRQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mRwjDyq3DRTYjWixPj2szrc6+U+/7DjL821SMvHi/P7wELIJjBc+uo6569d8Vr0pS
	 8ZTcjwWZuAbo83+Li2ze9sGkWFHa/OKRu6AOPKQsygazv9F1hF1xhSrZdsjinJ4gRL
	 Vf8Ez8mHyoFBLIjKzo2Z+elCXdtUC1wjRwLLaTC8LE+6UHKllCIyqikT0N6RNREH0c
	 rl7Jw6RRZbSTT0CgHeWgQn5VuKoKpgDVfoOFShEHCtjyuHDUOqBVm0KpN3fvJ6G1hQ
	 EioUDRLls+R0xmRW6YwFQ+sOg3ltgqle5SjScmI7ZPjWPbHpz1R1tAnXQ6WrBJ5Rws
	 ufxeXbQSj3EOg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 76356C53BD1; Thu, 23 Nov 2023 03:38:49 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218177] qemu got sigabrt when using vpp in guest and dpdk for
 qemu
Date: Thu, 23 Nov 2023 03:38:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zhang.lei.fly@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218177-28872-BGMpH6HmKe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218177-28872@https.bugzilla.kernel.org/>
References: <bug-218177-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218177

--- Comment #4 from Jeffrey zhang (zhang.lei.fly@gmail.com) ---
Guest os version:

OS: Ubuntu 22.04.3 LTS
Kernel: 5.15.0-86-generic
vpp: 22.06.0-6~g1513b381d~b23

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

