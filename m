Return-Path: <kvm+bounces-44529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B83CA9EAB3
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 10:26:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0143C3A2C83
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 08:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E923F25E81F;
	Mon, 28 Apr 2025 08:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ME/YVVIk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C9C2222C1
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 08:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745828746; cv=none; b=GkoZ74R+5kTGxMPYYA/7fxYjfwX5O3BqIVhMSBvAphL8b8kJzpabIUcXuUx883LkpfV1X51+8FUns2LfNQI2URl2HLlojSxdQLEqaOBFyskx+amr/DtIm/ICu9o+VndegGi98zsxXVS1N6diWTggNNfRuFnEOf6tkjYStw5LGlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745828746; c=relaxed/simple;
	bh=H/Yw5W9avHIx9HMe2GTP9NJ4ZFHMpWhfnCYmM5wnW64=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KnD2di0qwqlEM+cGd3tI0BhXh9KO+wN0v5nDDrkb3vWkFup9FVaeX2wiWXyXPKpUE/HRslGY64soBTH4UhCuAGXCSoYHdi9Oy/7xuraXgd8vgKqMM/ACj1zKNaW5bviT2urWocHJKE+FnSwCyQdimDNZMg8lC2FuyhJYpQakZOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ME/YVVIk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E212EC4CEEF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 08:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745828745;
	bh=H/Yw5W9avHIx9HMe2GTP9NJ4ZFHMpWhfnCYmM5wnW64=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ME/YVVIk3AL9SgmUAxcNIsCMF7tD+nkZvqkCpeBa0G2CgCgV45Xtp2bDR+ZTY7mEk
	 RIpG+Juq9T2wKrKyRaKeATxZU2oW7iHJ7d0nSvqE+gNPyBnqOjkFnDHDc+7HrIT6VA
	 BmFdbW8WN1xm6virni+kwzUq58Ap1SoQFTOh+aAgb0TeNNx/ibw59Vwrr/24GjMzqL
	 sxba/gaW44EbF4DuZVwYbruQY44oh/0uK30AHf+kCFZ4PIYGCEjPJZjSaTz7pRST6o
	 DPu2L6ykG//Un3sjdRUlR0rUSqR6vJZDYtC4HTqD0RGs5YIQR0tS3zN9p+bLvW/QXo
	 60XdQ4ZJjYVZw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D3A75C53BBF; Mon, 28 Apr 2025 08:25:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 08:25:45 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-SEuqJikZ62@https.bugzilla.kernel.org/>
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

--- Comment #5 from Adolfo (adolfotregosa@gmail.com) ---
(In reply to Alex Williamson from comment #3)
> https://github.com/torvalds/linux/commit/
> 09dfc8a5f2ce897005a94bf66cca4f91e4e03700

I checked. That commit isn't a fix for the crashes in my case, since I test=
ed
vanilla 6.14.4 and that commit is already present. How can I help if needed?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

