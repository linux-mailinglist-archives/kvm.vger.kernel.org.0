Return-Path: <kvm+bounces-6124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4AC82BAE0
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 06:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A7191C24AFD
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 05:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A62DB5B5CF;
	Fri, 12 Jan 2024 05:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeGOdA5x"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71115B5B1
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 05:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48743C43394
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 05:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705037593;
	bh=LlLhZvZZROWm+Z2/iV3fJC68Z2AkInVQ5vAotIJGHGk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AeGOdA5xfD82GAUBoyX+q5nvzgShMvYQNG4RXkkGR6I1BgDfeMcIXdsZ/flLTgq5A
	 XTchVhR6TTwNNPYMQZdE9d4jWrSFxJczfAalDhIRPjq3lEirV3ssEaRtM/+pabk6yc
	 JZVJFoEeqLCT2/s+rRAwHcjmE1jpad4+aik8MHRJawDU6EAhZzaiGvLqe1xzwt7/tK
	 axcUO4cYrFYl9tsZVQQKVIvjA6iiq/nxLrJX/43MWam1qso8Qhx+ibtVF6GfK09uqy
	 dgIKwCtrMsrfAwGCpZKoxPMGr2spwvV3U4pvZxtQTjKrtoLF5tBpbTWxlpYF3oYWld
	 RpS36ABlg2eFw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 30EE4C53BD2; Fri, 12 Jan 2024 05:33:13 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218297] Kernel Panic and crash
Date: Fri, 12 Jan 2024 05:33:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rgoel.bangalore@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218297-28872-qMmZRa2FV4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218297-28872@https.bugzilla.kernel.org/>
References: <bug-218297-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218297

Rajesh Goel (rgoel.bangalore@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rgoel.bangalore@gmail.com

--- Comment #3 from Rajesh Goel (rgoel.bangalore@gmail.com) ---
(In reply to Artem S. Tashkinov from comment #2)
> Please try to repro it in vanilla kernel 5.4.265.
>=20
> If earlier kernels aren't affected, please do regression testing:
>=20
> https://docs.kernel.org/admin-guide/bug-bisect.html

We are actually using the same kernel, with very few minute changes which a=
re
not going to affect the working the way vanilla kernel is being used.
In our setups we cannot use the vanilla kernel directly.
The main reason for this bug report is to understand if similar issues were
seen in the past and any possible fixes has been suggested.
We see similar forum where same issue was reported, but patch suggest here =
is
already integrated in our builds.
Is there more information you can share, which can help us understand this
problem in more depth.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

