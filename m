Return-Path: <kvm+bounces-27279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE47F97E28C
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 18:53:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CFAF1F2125A
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 16:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166BA26AED;
	Sun, 22 Sep 2024 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="KxUMc4t5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A965227
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727024015; cv=none; b=IKU2g/PUJmUNr6FJYHnA+o7pCzcy7C6NZ6J4NTuNo7aES1YEFh9W1y5mFBmh36mNjYDlhje29C2vVEQiU4gQiF2M3yYE9PzJ7Xms7+EFwqFXVABNd63UnI8IJx0IiIoly+3keawhJqnVyC4lb/29sN/9a57q6wwlXTuxG8cQckU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727024015; c=relaxed/simple;
	bh=NHQ5JnTmK/JiAHEnkejzYNkhL5AM/G/shVHk37f5fvQ=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=QKhip/P3u4GUgwGHwcp/vMa1hhTZlDBhJG7eewg85U/voS4jBIcSc6rtZzODCOaKt2VrCHDUzA6of/xrd72GPGD9mTzrYX+GFBoR7mkQWghwc/H9sYLnlm58Qa0Xxys0Gz4wQrp2RhZgyCqGlRc1iuxJDwgsrgvPTSuCW5Tm5i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=KxUMc4t5; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1727024003; x=1727283203;
	bh=aXm1E1u0U8HrbeG0AtbmpL3G4+iJd7guOaJ3fmmE4aw=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=KxUMc4t5GvrVc+PvxcuALnqMHojKMR72Y6Isb9TxwONDp5squYb65Gf4kXJVpqaaI
	 42qOOMNpMpshLehcs0R7GZVOOBMoE/39BI0ZyTYFNBcDqt+Nw01zNEQ2CPiAmTzcpJ
	 1Q94fMHV5aTqxOQJKrfEy0mDzjl1yNiJijxgQzaro3+AJnkptsRfaM/TzSMwx8Yi5y
	 2mq/C+UGq+2bmnHJt08Bk4/MDYNE/FyuvIpALYMw8V5Qi2jouTAwW8nIiYwNn5u7vL
	 T9EK9m0AG8EqeKPZz2YgSLhayspMMBBHxA9RiK406J90i/9P8ody/3UtaubdmAhAF0
	 aNALpxP16NGWA==
Date: Sun, 22 Sep 2024 16:53:19 +0000
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From: shadowbladeee <shadowbladeee@proton.me>
Subject: Proper Online VM Backup
Message-ID: <D59ssnpunq60gA6lEmbgpSHb5-BYRZ8cw4oquCTtxmV276-oB7KDNPD59i1n2eqHh1kRu7r55V_tvEVrvHvmCFtugMigbqDdXQaqtfLKKlc=@proton.me>
Feedback-ID: 92900563:user:proton
X-Pm-Message-ID: 7dc45d23354419d8d38d20dbaad6fb68a933ce05
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello List,

I have a KVM server running about 40 VMs these are a large variety of OSes =
ranging from different Linux version, Windows 7s, OpenBSD, NetBSD, FreeBSD =
machines.
I looking for a proper way to back these up, I don't expect features like V=
mware's Vmotion to move them live to another server however I would like to=
 move them offline to another server and in case the sever explodes all I w=
ould have to do is spin up the same VMs with a script.=20

Sounds easy but none of the solutions what I found so far are perfect. Firs=
t I was just doing rsync based backup of the .qcows images to the other ser=
ver, this "mostly" works with Linux and Windows however the BSDs don't like=
 it they go from file system corruptions at boot time (which is still fixab=
le manually) to the point the KVM doesn't even boot.=20

Shutting down the VMs to do the backup is not an option.

I have tried these 2 methods:

https://libvirt.org/kbase/live_full_disk_backup.html

https://github.com/abbbi/virtnbdbackup?tab=3Dreadme-ov-file#complete-restor=
e

Makes absolutely no difference, the same issues come out with the VMs then =
if I would just rsync them. I got these versions on both servers:

ii  ipxe-qemu                            1.0.0+git-20190125.36a4c85-5.1    =
      all          PXE boot firmware - ROM images for qemu
ii  libvirt-daemon-driver-qemu           9.0.0-4devuan1                    =
      amd64        Virtualization daemon QEMU connection driver
ii  qemu-block-extra                     1:7.2+dfsg-7+deb12u6              =
      amd64        extra block backend modules for qemu-system and qemu-uti=
ls
ii  qemu-system-common                   1:7.2+dfsg-7+deb12u6              =
      amd64        QEMU full system emulation binaries (common files)
ii  qemu-system-data                     1:7.2+dfsg-7+deb12u6              =
      all          QEMU full system emulation (data files)
ii  qemu-system-gui                      1:7.2+dfsg-7+deb12u6              =
      amd64        QEMU full system emulation binaries (user interface and =
audio support)
ii  qemu-system-x86                      1:7.2+dfsg-7+deb12u6              =
      amd64        QEMU full system emulation binaries (x86)
ii  qemu-utils                           1:7.2+dfsg-7+deb12u6              =
      amd64        QEMU utilities
ii  libvirt-clients                      9.0.0-4devuan1                    =
      amd64        Programs for the libvirt library
ii  libvirt-daemon                       9.0.0-4devuan1                    =
      amd64        Virtualization daemon
ii  libvirt-daemon-config-network        9.0.0-4devuan1                    =
      all          Libvirt daemon configuration files (default network)
ii  libvirt-daemon-config-nwfilter       9.0.0-4devuan1                    =
      all          Libvirt daemon configuration files (default network filt=
ers)
ii  libvirt-daemon-driver-lxc            9.0.0-4devuan1                    =
      amd64        Virtualization daemon LXC connection driver
ii  libvirt-daemon-driver-qemu           9.0.0-4devuan1                    =
      amd64        Virtualization daemon QEMU connection driver
ii  libvirt-daemon-driver-vbox           9.0.0-4devuan1                    =
      amd64        Virtualization daemon VirtualBox connection driver
ii  libvirt-daemon-driver-xen            9.0.0-4devuan1                    =
      amd64        Virtualization daemon Xen connection driver
ii  libvirt-daemon-system                9.0.0-4devuan1                    =
      amd64        Libvirt daemon configuration files
ii  libvirt-daemon-system-sysv           9.0.0-4devuan1                    =
      all          Libvirt daemon configuration files (sysv)
ii  libvirt-glib-1.0-0:amd64             4.0.0-2                           =
      amd64        libvirt GLib and GObject mapping library
ii  libvirt-glib-1.0-data                4.0.0-2                           =
      all          Common files for libvirt GLib library
ii  libvirt-l10n                         9.0.0-4devuan1                    =
      all          localization for the libvirt library
ii  libvirt0:amd64                       9.0.0-4devuan1                    =
      amd64        library for interfacing with different virtualization sy=
stems
ii  python3-libvirt                      9.0.0-1                           =
      amd64        libvirt Python 3 bindings
ii  virtnbdbackup                        1.9.15-1                          =
      all          Backup utility for libvirt

Any other ideas how to back up running VMs properly?

Thanks



