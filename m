Return-Path: <kvm+bounces-59524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A010FBBDF49
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 14:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B28BD3A8960
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 12:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EA8223DED;
	Mon,  6 Oct 2025 12:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+USeFJh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CD72797A5
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 12:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759752330; cv=none; b=dVHnFsvZXEJIPoL6HG3NH/mwtpnr8daxusToGCF70Ckv8WdGwoLUGljOuvxKeXP6A5vxLVO9uz67qxw0+k5s+bD9GFxFfi8RvnhmhaiYjKItRrqtdWHAdB0BcF5YzPHAhRMWxOwMhkEj9pkDI+ZT30k5o4GTDdwzuwZHIoyndyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759752330; c=relaxed/simple;
	bh=xfLV3nhmuMkEjP6VLIxjppn3X4EqGLbdYwurqWGLfAY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B48fnlkWKnVd2X5OSkBgnBIKuY5uOf2eGMra31RUGqd6ObvBy/vFvY35kwbjLy5dJRS0AFKmDgUK2aF2HXiTbm2VHQt2T8dQhcDa4NrMw16PacX1HyZ7e/tmngfFekxM5uIp2ZODUAUQqYkjGdYtsxfFW0z6LkOvL7mAwt8E9B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+USeFJh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F1E7C4CEFF
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 12:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759752329;
	bh=xfLV3nhmuMkEjP6VLIxjppn3X4EqGLbdYwurqWGLfAY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=V+USeFJh2Pi1E3QZf8rArTqALE0WSdlfOw4OBoez7Or0DNK5w+TezHSl9enti1KY6
	 8UDNiWCYmQh86jYPgWoOLsUE9WyuzbdQwdgqSMxaRRPSQOJLwrIRJZo9M25UAygTGo
	 GQJ1xeE7dZak10bfupgNHzgtmRi6pctmPy0sTCvcfkTT6Gzplk+x9RtymxPB2/Cbxk
	 UKtuwnqaU/k15CycGc9EIneh9J/bhP4zz56ajOdN2FBBQEOKAt+E2KnimZoDfgWm25
	 CNRjJmU1QHUX8xZdF2ofDYpDtADnT7bgio1fvZnpYs5VCJ9AEaJYQxaq+MvqBf6TW5
	 ZGq3DdwjfdJiA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 63335C53BC5; Mon,  6 Oct 2025 12:05:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220631] kernel crash in kvm_intel module on Xeon Silver 4314s
Date: Mon, 06 Oct 2025 12:05:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: f.gruenbichler@proxmox.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220631-28872-RGJcP3q4DF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220631-28872@https.bugzilla.kernel.org/>
References: <bug-220631-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220631

--- Comment #3 from Fabian Gr=C3=BCnbichler (f.gruenbichler@proxmox.com) ---
I asked the original reporter to register here, hopefully they can attempt =
to
reproduce using a newer kernel, e.g. using

https://kernel.ubuntu.com/mainline/v6.17.1/ once that one has built, or
https://kernel.ubuntu.com/mainline/v6.17/amd64/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

