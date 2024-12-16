Return-Path: <kvm+bounces-33848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15E169F2D01
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 10:31:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B475A1882C41
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 09:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A849200BB9;
	Mon, 16 Dec 2024 09:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dryhh30X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22DE1BCA11
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 09:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734341451; cv=none; b=rMNmlCuoeeYyzhkjN3pZ2s44du8DRpv2UN+NjLzs3qluwQgJS1HvLddEmFyC5atKwi8/BPHxw9/oveZG2ol+FY2JZXUl5nrhgtuvJNo729uKhqwnZhc6nztwSH5QtzrWWRX1nz8sxjaD07qUNRI/6mfiZ95XDAQGEKo8EyOWulY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734341451; c=relaxed/simple;
	bh=r9cWm0ff5gSzy3Aos5SYaXALESO/NgigEoR8Mwic0RA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aCiUGAurNpZO+Bt/5GzbVUBr3J7inomc6kGvsiZd610755n2ev+p8duQp5brwkFAG+O+pIpWp30mwGTClFx/EYGLGkmXJj564ApCiI7UWWIg+dHlbxinURBDIgDYUTTJ4Lbkbt4RLm43XvbabSA3az7bYeOQzzImIEYxg3LR4/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dryhh30X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48C65C4CEDE
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 09:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734341451;
	bh=r9cWm0ff5gSzy3Aos5SYaXALESO/NgigEoR8Mwic0RA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Dryhh30XhZ289bbC84pTOr4kYJTeazTgSG1MmF2AJCiAmhA/dyw5HrDJm/07fcvN/
	 gq1gffZAZcTovH7TkWZZvbg9G69WjomQ9DzFutVM5hbwMTy7tqKze721FR9QKzTNKZ
	 emRvyWgaczeAERauApS1O9v1CSiqpoGSgSCyOKujmNSETp22IwfNwFxpwKoJGFx1sM
	 zRaIADG/26RblxfWXpuz5PTI4JTHdnOtZb1R47mZQZ2SG/w+ZHRU/l7tEG3SKFtqFD
	 xqupSh7Sdb54+vZwJtn3XuinxW4M/ON/sEqQ4yHcSdLsrCpzpU2ovUiEZZdsnI4oUX
	 YPFkN9Bd8zQ7g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 39666C41614; Mon, 16 Dec 2024 09:30:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219602] By default kvm.enable_virt_at_load breaks other
 virtualization solutions
Date: Mon, 16 Dec 2024 09:30:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: acmelab@proton.me
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-219602-28872-gUOWQ91iw5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219602-28872@https.bugzilla.kernel.org/>
References: <bug-219602-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219602

Pinky (acmelab@proton.me) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Default of                  |By default
                   |kvm.enable_virt_at_load     |kvm.enable_virt_at_load
                   |breaks other virtualization |breaks other virtualization
                   |solutions (by default)      |solutions

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

