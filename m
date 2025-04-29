Return-Path: <kvm+bounces-44717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EC4DAA053D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 10:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BBE31A8803B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE1A27CCD7;
	Tue, 29 Apr 2025 08:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgoAQubJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3510E21CC43
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 08:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745914460; cv=none; b=cBtitEbhYCIk6/Ml40etHaaCCZPBnYPFwSGkZBLzPn9edSE2iNJhl1rUHU52vxTzZdmyEEQoAMQ9uuQfZQbpnG5JM+8cSp0d5cmPAQ6YgmtxbFd8LGOoxjgDWnWgieA4acZvZIPtC22GoTN9Cp/IaDcOp2+rxfJ7eEBlmp4zY10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745914460; c=relaxed/simple;
	bh=/lz64oPH3S1EVS6cJ1UDKTF25FRlERVCxHrdTcsb43Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=riq5pNsh/zwXd5eTelKXo41gdLPVakkoHc4xsXZUBlD7qWRHrnE14yUd/PIiZlbF9lTGq4kxSUOhlQmUmUjn7Zmo40ZGGTERU/b6NgsRJDoEEydhkiV7K1/NA+IqoAjkpsbj4ZqCs5Ivmwy6aHQF07JZanyiPCWUmK4ztZabQsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgoAQubJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB181C4CEF0
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 08:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745914459;
	bh=/lz64oPH3S1EVS6cJ1UDKTF25FRlERVCxHrdTcsb43Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kgoAQubJPkRwJ9vQmEfJ7PoEtlzqs5IB7VrTCGyHKtGuxACxuK0OATEDWoO9Qo4/Y
	 B38fclKAX8A3kCH6hOxBcLlKe6umhdjtpWV9xpujkF7r9fSODp77AJBKg571eO546O
	 SWl5qicPEEBDOeCXwqET5Vriwcltv3Zap0QOyor/2cQfPKxdNNZXUhMJ+q1IV41+eD
	 cxMR8yWvGKZGobCg8itGTd1bRrZivR3Uj/UQ6FROwsADYrmQpmigOvD5X89bYWGNBb
	 vJmoTmBVDEjdkKs8xJMHiiIR0qmHIEcSzGXsSQBjVj/2aavwyqllMHX9V3zSS4X5DE
	 i17dwuvjv8aWQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A29FFC53BBF; Tue, 29 Apr 2025 08:14:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 08:14:19 +0000
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
Message-ID: <bug-220057-28872-zVb2SQ1X8t@https.bugzilla.kernel.org/>
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

--- Comment #24 from Adolfo (adolfotregosa@gmail.com) ---
or maybe not.. The address probably changed because I played with rebar set=
ting
in the bios!? I don't have the knowledge to answer this. This VM does not h=
ave
phys-bits=3Dhost in the conf file.

Apr 29 09:12:09 pve QEMU[11923]: kvm: VFIO_MAP_DMA failed: Invalid argument
Apr 29 09:12:09 pve QEMU[11923]: kvm: vfio_container_dma_map(0x5c9222494280,
0x380000000000, 0x10000, 0x78075ee70000) =3D -22 (Invalid argument)
Apr 29 09:12:09 pve QEMU[11923]: kvm: VFIO_MAP_DMA failed: Invalid argument
Apr 29 09:12:09 pve QEMU[11923]: kvm: vfio_container_dma_map(0x5c9222494280,
0x380000011000, 0x3000, 0x78075ee69000) =3D -22 (Invalid argument)
Apr 29 09:12:09 pve QEMU[11923]: kvm: VFIO_MAP_DMA failed: Invalid argument
Apr 29 09:12:09 pve QEMU[11923]: kvm: vfio_container_dma_map(0x5c9222494280,
0x380000000000, 0x10000, 0x78075ee70000) =3D -22 (Invalid argument)
Apr 29 09:12:09 pve QEMU[11923]: kvm: VFIO_MAP_DMA failed: Invalid argument
Apr 29 09:12:09 pve QEMU[11923]: kvm: vfio_container_dma_map(0x5c9222494280,
0x380000011000, 0x3000, 0x78075ee69000) =3D -22 (Invalid argument)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

