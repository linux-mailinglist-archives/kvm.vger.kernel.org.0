Return-Path: <kvm+bounces-4981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E11F581AF62
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 08:27:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66A2EB22E5D
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 07:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C07F154B7;
	Thu, 21 Dec 2023 07:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpv3wghP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AD814F8B
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 07:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB7C1C433C7
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 07:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703143663;
	bh=1E15b/TP4yLtdtzyvX1hiij2hUoMjJY136Aosn+Nu9I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dpv3wghPiHjNmVkFFSOnp4kPt1+F+SLoqoeTDKrTsqEmnVl3oFefyKU+Z05AV9ElA
	 CsuCzAjUFj04ThkO4rrUAVDc5e5KXrg6F0OqB7lZ4trDXwZYXQvbMRQCf5IsV03eux
	 KkVu+18X0RcFk5GHnKg89S2sK870BVjNiTisRQVOM11ffXhl1+caYiuG2Z3yEg2tad
	 P9mntKsg2QcwI8TgHFbUcUo9SREzXDzJ1lp0wx1IolIpn1vm0UvFUyv7NAhXhrYyGf
	 caxBXqVsntm4Z1doEduGzOoWgErcAxh4dwBvMAu+Px1mx4ozYW2Ik7Cv/s/j6SjmgA
	 NH0vs/fBgZ+qQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D9620C53BCD; Thu, 21 Dec 2023 07:27:42 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218297] Kernel Panic and crash
Date: Thu, 21 Dec 2023 07:27:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-218297-28872-eeP9G4725j@https.bugzilla.kernel.org/>
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

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |5.4.244-staros-v3-scale-64

--- Comment #2 from Artem S. Tashkinov (aros@gmx.com) ---
Please try to repro it in vanilla kernel 5.4.265.

If earlier kernels aren't affected, please do regression testing:

https://docs.kernel.org/admin-guide/bug-bisect.html

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

