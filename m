Return-Path: <kvm+bounces-37-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E28947DB304
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99B97281407
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 05:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B53F17F1;
	Mon, 30 Oct 2023 05:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDcj0vAM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597801370
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 05:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC00AC433D9
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 05:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698645337;
	bh=jGbHqbK6VmuralsSdIEcxWbOyVNDd2uXDnZk9Rzft54=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NDcj0vAMz+La53rm3/X9fPDSRUugLxg0tUTvWpRbpwRYkTxw5zdn2wzoIkhdcHp0U
	 J5osXj90OW/CCPlzLj1uii2aUU5+ZEdsFJumdiDCGTQ65CJ2rs674xdNWr+1PYV6js
	 KuvHbZfiPy7CUqzRjIkRGIfzePSkMs2FzYYsoWrKPuXART9iFiBiYtRiUXADg1EI4/
	 lbDmo5HYEwa48thb0m4elISwcfsJfgngKOAlp5lMzSESkBS4ahib97iqcOuRYOVP1E
	 xb/vtG4WgHa8nIzDtWvbLrjaIG2GTOjGsR7qC1yS6WS1yYL8IwwZMgnmcB5JWQkjfz
	 beW3DIQc/4Vfw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AAC9AC53BD2; Mon, 30 Oct 2023 05:55:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date: Mon, 30 Oct 2023 05:55:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Drivers
X-Bugzilla-Component: Network
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217558-28872-PrJKlnKYpY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

--- Comment #16 from Chen, Fan (farrah.chen@intel.com) ---
Fixed with
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dc8de44b577eb540e8bfea55afe1d0904bb571b7a

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

