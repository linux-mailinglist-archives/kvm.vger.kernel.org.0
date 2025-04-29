Return-Path: <kvm+bounces-44821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B728AA1ABF
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 20:36:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 739E97B44E4
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 18:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA503253327;
	Tue, 29 Apr 2025 18:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="axiPn8cr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3276244664
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 18:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745951771; cv=none; b=oiGWCdOFlL+3IFolGaA6JBObHBlrjzTx2Ok7JEOmHmYBSzqz9Om4u5GBQIMEYi5lSCR8GzNXOUmWoxm2jFxBgcb1MPIFNTPmgCbv4s9zzs8NiNt+RkltHx6Vwakxa5LHGVS+Th9tNeZ8+aKG1OJNcj+FLFqKPo8F6r223s6KVKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745951771; c=relaxed/simple;
	bh=hWD5dHVdXpoamYD6fl/eMylRYcI/E2AVgc79s03qWwk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VbXTWGV6cyXMLXJr2jd78Q1YuRtYoiX4r20C/7LWN4Zd4NHnfObVZmT/Jw3VR3lMdL2nmTIHTREzvmVfmouOWU1TdJpIpghyxW96NAnDWqeI52HadILSlI6N9HUTQCrST/w/Edhz4wvA5MjWPnOolrCLrU6NKwNTVhDoloKtbyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=axiPn8cr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69967C4CEEE
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 18:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745951770;
	bh=hWD5dHVdXpoamYD6fl/eMylRYcI/E2AVgc79s03qWwk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=axiPn8crLmWU9hahK1RdlTxWoEdItzApP5z0qwsxSPnOIGapsf5oGzgnm3125OVk1
	 YJHXyzLGuGzeUZ/SXqWsVTE2chZiqa0ObG1vUIr3bCyTMS7U3FvMIHQCAVh3gVYSxf
	 4tLA2kp9LLqZ0bvv4h7Y98rEbu5hj7tMipTbm8PPOuJyDygJ091NYsUWAWz2nOyeAK
	 AxDDGjk4d/+XaTuUwpFKdWaHEK55LmMu1KCYgh+eDbLTQN8zPoch+Sn76PY1PMcs/A
	 uD3/+sAdhG4QSxH7tP5fICAw/7S9eV2bHDxxcUDTjYcCWiPJ2F785QXq6EOswLgTAT
	 Jt98eMpcG6F/A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 609D2C433E1; Tue, 29 Apr 2025 18:36:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 18:36:09 +0000
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
Message-ID: <bug-220057-28872-ilNV97OMMQ@https.bugzilla.kernel.org/>
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

--- Comment #33 from Adolfo (adolfotregosa@gmail.com) ---
these VFIO_MAP_DMA failed are not that uncommon if you do a quick google
search. My gut tells me they are not related to what I'm reporting here.

https://forum.proxmox.com/threads/vga-pass-issues-with-radeon-rx-7900-xtx-k=
vm-vfio_map_dma-failed-invalid-argument.156795/

https://forum.proxmox.com/threads/vfio_map_dma-failed-invalid-argument.1258=
88/

https://bbs.archlinux.org/viewtopic.php?id=3D299106

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

