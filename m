Return-Path: <kvm+bounces-44606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A4FA9FC2B
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 23:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80DF4463E39
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48BE1FF1C9;
	Mon, 28 Apr 2025 21:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdqJKH9J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DD913AC1
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745875485; cv=none; b=tx0546JDvu9O+jcpY8FJOHSD54LYJcd/cH+Odq1LTil4fZmbqQxmfLaKe/qLmfUrpL+r4ntQOOKl1mm8VEDQye1KqR72aWEXFKuGyJtRABExA6dhM7Ilh9lTi2J0UW8VonP668EsLl5yHYnj6JAKGfo1vpXb/mXfVJAUzMbD+Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745875485; c=relaxed/simple;
	bh=+IHYhXbhi4zIwvumyTwSkvBU/S98LoshEwksKJfGti0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uc9AB5CK59nSWYERCskvf6fBgY5aWXAQZkg9wDpRT/HNiwtQyFjQ2qhUSOe/ae23zQvkv5udDBmFOjdlL6UeEAfFAoL29sH43x9tpI/ChxXuA3HPA9iKQYFurh4xH0f8MRkf1+Acb5CbYwH1uG6chObWi2LZuT8VKVfgXiVcDGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdqJKH9J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EF5BC4CEEE
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745875483;
	bh=+IHYhXbhi4zIwvumyTwSkvBU/S98LoshEwksKJfGti0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KdqJKH9JAKy7DbWIVBVPChWUoL638ssnT3UUMPEjfpoWF+0sciEyeAh1IfUVKI0TE
	 wmr9nfq6NyxyuNzF/r1YXfKq1c+QUzmufGnSrS5BFxlKpSOEyGEeYYPH4LhV5uytdt
	 EpLxpUeeQfzgl3ITQunsZ2Oq+M1bcMbD42owpedUnj5BCqcLQYEw88JcJIdK2Ydpi8
	 WjZx6w+RzmRXkS2wOyuvyfVA2CUGdpR0rYdR69xhfb0JaTXhdt/KBhrxsLmNe/7gPk
	 bsA0o+xSXAWDy4LS4r6iNjIU7ytwtYD6XrGIIwZwZUtkiNjbzv3om8VMgTaCHwLxnx
	 a064+S8hzhWDA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 71F42C4160E; Mon, 28 Apr 2025 21:24:43 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 21:24:42 +0000
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
Message-ID: <bug-220057-28872-nVYXoADFwN@https.bugzilla.kernel.org/>
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

--- Comment #10 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308042
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308042&action=3Dedit
dmesg output

dmesg output.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

