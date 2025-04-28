Return-Path: <kvm+bounces-44608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D78A9FC52
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 23:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C8FC188A991
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9E0204C07;
	Mon, 28 Apr 2025 21:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJJ3pf2t"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC5A6F073
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745876372; cv=none; b=XXd+zRbpZZTwSfbMYnyOdwPhSkG6HosLuW2tNsq+RGz9jVIohVoRl0pMMYJD6+7JUMiuiMKEc126Iz/eeYOXEuSKQyfbYWfwukpAbZbblxXxlPYYj+BoVSJgWvaEcgplOJFYGcoG4yhWHYAgxV1aX/nTFv/s7VatO9wbg7pVrlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745876372; c=relaxed/simple;
	bh=7xijXXL1mGljWMtIhYqO6FRwg0FD2oZLnq+ia1wC5zY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EYOoEJPXEwRSD1AHTWPbTM3lUsmd0T8T/EH9kWbIB7fyRnuDwgdUe/BpnjbxCwF93zL3j8Hoy5n2eO4tmNu7KT1PSfznTMoHx4HzmV1LNo0sWkhwkd8tkoOKx4W/iLsWm/H0lSU3a/IdTMyUXQ1EZagT9AnQmS9r2eNScszAogQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJJ3pf2t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCF38C4CEEF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745876370;
	bh=7xijXXL1mGljWMtIhYqO6FRwg0FD2oZLnq+ia1wC5zY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RJJ3pf2t0HslSwB8/CK4YMNnrrMmSHMNOe7uW90dXdeoC+bRjLgfSrkoQJQhSM1s2
	 aAQRr/Iiow63HGr70ry08WNzOxkPi3tAIq8h8hNAdp/TACmtxXIHgqZZ8vBSHuwY7/
	 h/sA6XtWtl32sCRi/QDl1VUIACERYZUMUE0ebcFTvnPoggjWUNNDrYXutuUsjsdsna
	 oACUx5vLfiK51uwjU4lCak8F40kjXPX/gaWZ7mrE4SWktqBqlaOyj/EWc/fvHIqnHl
	 RoJhd7FHiawyadtGQk4XDlRXjM1IZcxvN2uDekqXI3zjkW0ezoojJwV/nKJlqiZ0ey
	 bp7Xy8pTDiGsw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D1B1AC53BC5; Mon, 28 Apr 2025 21:39:30 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 21:39:30 +0000
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
Message-ID: <bug-220057-28872-uIZfRqPTVp@https.bugzilla.kernel.org/>
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

--- Comment #12 from Adolfo (adolfotregosa@gmail.com) ---
I tested both NVIDIA driver versions 570.144 and the beta 575.51.02.
Assuming my machine is fine =E2=80=94 since reverting that commit resolved =
the issue =E2=80=94
I believe the reason there are so few reports is that Proxmox still ships w=
ith
kernel 6.8. We had an opt-in for 6.11.11, and it also works fine.
Recently, 6.14 was offered as an opt-in, and that's what led me down the ra=
bbit
hole. I started compiling vanilla kernels: 6.12.25 LTS crashed, and 6.12-rc1
crashed as well. This indicated that the problem was introduced between 6.1=
1.11
and 6.12-rc1.
I performed a bisect, which led me to the problematic commit. After reverti=
ng
that commit, I can now run 6.14.4 without issues, just like 6.11.11.

Regarding Proxmox VM guest configuration. Proxmox does not use libvirt but I
leave the VM configuration file bellow.

GNU nano 7.2 /etc/pve/qemu-server/200.conf=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
-------------
affinity: 0-7
agent: 0
args: -machine hpet=3Doff
balloon: 0
bios: ovmf
boot: order=3Dhostpci2
cores: 8
cpu: host,flags=3D+pdpe1gb
cpuunits: 200
efidisk0: local-lvm:vm-200-disk-0,efitype=3D4m,pre-enrolled-keys=3D1,size=
=3D4M
hookscript: local:snippets/200.pl
hostpci0: 0000:01:00,pcie=3D1,rombar=3D0
hostpci1: 0000:00:14.0,rombar=3D0
hostpci2: 0000:06:00.0,rombar=3D0
hostpci4: 0000:03:0a.2,rombar=3D0
hotplug: usb
hugepages: 1024
kvm: 1
machine: q35
memory: 32768
meta: creation-qemu=3D9.0.2,ctime=3D1737473987
name: cachyOS
numa: 1
onboot: 0
ostype: l26
scsihw: virtio-scsi-single
smbios1: uuid=3Df75921fc-d45e-4463-8590-8a4aab19e6e8
sockets: 1
startup: order=3D3,up=3D300,down=3D20
tablet: 0
vga: none
vmgenid: 2cd9b643-58a2-4ac4-a01c-f6a131e65c6d

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

