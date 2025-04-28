Return-Path: <kvm+bounces-44609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 614ABA9FC60
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 23:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0228189583F
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C939820D4F9;
	Mon, 28 Apr 2025 21:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KT9bQT5q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBCCA94A
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745876523; cv=none; b=f9yemOVjAF3nPs8/2RWVMcYGC5Vlb+0BZEuOqXkjwgkBblD8vo8TDIsWsgzTUtOZmOIU+ULl+q8MpW9UdppaG5NikNygH8ZooCat7I/7Dl2De7ETXUGhQovACcGBZnJVn3Gekp/QT+hxSbGPd7W3Y2DYdJLaH9UFHx93Y92GD4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745876523; c=relaxed/simple;
	bh=hRAeWm+BieVJGZRP66cK7h8gDi1S4thYqUm9M23EJ1M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kosY1rSMOjuArRc1hObBSsqlQZptSLfXiMq8EwPW9IrhVgta25o9/hNg76+TYWiNBGMe0ldfl2cgepcDOkN4s26tsmvSoMJP4BgMXbseVQ4hRzZ+o8TELoFsu/ynnRIzhq/gZi/g6AtNFKK7/WH/+0+fN71/G/I00IT1bSrxqwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KT9bQT5q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C455C4CEED
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745876522;
	bh=hRAeWm+BieVJGZRP66cK7h8gDi1S4thYqUm9M23EJ1M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KT9bQT5qYE8JOp5/VizSk2SF6nyey+fvvOETeU8+PF5660jruuqJtGImf03RtJpch
	 Mj5G17H5hqhK2zBzPgoO8OK8MMdEGZBK7AIpzV69WsH/FonpZNHrrKbvHT2JRYD9Qz
	 ujgOQOqGAb8WhLdRrku7ikAHJHDi6PE3QHf00Y6wJ95hewojyvrkYGJw2o1NdcW4TE
	 0G5vrl3Y6tRV+oBI5Ggje4uB9qVdwF9QCXOe4Qxp2SxHb2/ktrKJCStU/14ainXcvO
	 1uw34LaTcLkEFSd/Ehhi0hiPxcAP+vTLfM9D6v9DsMATtr9HLOx+2FXJsum0uPaTv6
	 Tgqv2d6yrbcfQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 647E6C4160E; Mon, 28 Apr 2025 21:42:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 21:42:02 +0000
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
Message-ID: <bug-220057-28872-AzaOGIuQkr@https.bugzilla.kernel.org/>
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

--- Comment #13 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308044
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308044&action=3Dedit
proxmox_VM

Proxmox VM Hardware config and qemu version screenshot

Hopefully, I provided all the information you asked for.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

