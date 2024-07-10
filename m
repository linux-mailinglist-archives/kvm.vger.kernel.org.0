Return-Path: <kvm+bounces-21321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64AC692D547
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CEE42876FB
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 493E6194135;
	Wed, 10 Jul 2024 15:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gLIH5aCP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77215257D
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 15:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720626448; cv=none; b=OJgLg2ATOs3FSCbUzYSMozshzUiVPMvNAaM3GIVixhjhaE/uv6VRfZZUvZLKmhsafY2Orri/YDEZ3eDSxDvGLTTKfjVu8zo7zLFQh1nWYYtzrbF/+tBN5xnHkl/0pI3NR4w/vnOCZgBhG+dg5ghVUkyKXGgsOdQm0YUq3Yi2rYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720626448; c=relaxed/simple;
	bh=/7L0yga8iTcAvpTaRwGNimO2zzC0T73ndtzQkymKCts=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TjPpj+Lc7Ez9p4E16CvrLcz88L5YpYHfZUlIEU93EIdoFoOC+Sst4imDqmIVGXmh3Mma1NfjJheRvGMPGzveJbonXoaoLoum5CHwFJ7dce+kZYnH8nh5QYGAqa/8bdCe9VYHRsXHGETq0VHqvd2V3EaFfp4W0+UEftTAhjJG9jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gLIH5aCP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55B3EC4AF0F
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 15:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720626448;
	bh=/7L0yga8iTcAvpTaRwGNimO2zzC0T73ndtzQkymKCts=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gLIH5aCPBj0vdWzkSfDXY1LvtIa0G7MZ0TGfBEpeY/lU8X3PCm2ArtOpMoMo5vnN5
	 fkVFyohVc9A724GHM/VCfkpxD9ypIv/7iZ4s99/1mjil1DwyTOaL7UfVaYgFXMxYYS
	 aHBNPQK5ACGynDuTMJcXiocaIVGE1pb/6YjWJxtpxtohDWbO9zl7Q5oF1cx7u2aIu/
	 IYTE8cnelLE0l636aWS7Qm/nC5V0kTo7zQQPbXZ9LS/J0BcrB+kDdjK+PRPcOaZRu8
	 lqdZOPFoPeHD/gzPpHTtrYjhnZfb2bRSykUd9tTNq7sUO0Ddfp4A00XL/RhKmlvZv/
	 t2DIpJPf/wiNA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4D0D5C53BB7; Wed, 10 Jul 2024 15:47:28 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
Date: Wed, 10 Jul 2024 15:47:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zaltys@natrix.lt
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219010-28872-1QVMksG2cF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219010-28872@https.bugzilla.kernel.org/>
References: <bug-219010-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219010

--- Comment #8 from =C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) ---
(In reply to Liu, Yi L from comment #6)

> patch submitted to mailing list. Thanks, and feel free to let me know if
> it is proper to add your reported-by, and add your tested-by.

It is ok to add me.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

