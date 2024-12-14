Return-Path: <kvm+bounces-33814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 966AC9F1D0A
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 07:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AB3C7A07F2
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 06:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EFA1531DC;
	Sat, 14 Dec 2024 06:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ranguvar.io header.i=@ranguvar.io header.b="Lo1AA0qS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC015914C
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 06:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734157992; cv=none; b=loKEJ3/BJafOQnsZapNkVkq67U7o+78slBv5M6f0833JFYOJ+MYOIbzWQuCywqDEzxU0GTzGnVYBZhwvCH+zkZLWyBgfYfkO3bOPpNBVeAcBVyEXHJ53RWiBMALUym7YiA+wv2SZ5i6RrVUkkLxp6aB3FfFA2U3RSVAcg69YMKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734157992; c=relaxed/simple;
	bh=ievqeHVfDN1p5eeUqf09eDC9oeLJXp2DUIrALupbiTc=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ucO69cLBP4bN8QqwKEhrH6s+STzKBUmKbofSwNI5qGTJ+wH6ksFl5IvpMM8NKMEDsoXz0qtqSyBwygUCa+Qjw2zfz+TCfhmEZd4+Thbos3DNv4GYogj7e5JOn98h1I+bd4+oSSY7I+mTmB+a0jPohcrsI/nm71fX3tU3Inxdl60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ranguvar.io; spf=pass smtp.mailfrom=ranguvar.io; dkim=pass (2048-bit key) header.d=ranguvar.io header.i=@ranguvar.io header.b=Lo1AA0qS; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ranguvar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ranguvar.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ranguvar.io;
	s=protonmail3; t=1734157981; x=1734417181;
	bh=ievqeHVfDN1p5eeUqf09eDC9oeLJXp2DUIrALupbiTc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=Lo1AA0qSzQJTJKMajvxYqwDGjWAbrWc0jLytj2YyxV9CyuAjjscbPD/WXCJyuYRqP
	 mDGxnd5Onj24epykQ/I2WKMDi8NjHsw2cYKduHqQAY6drz9gUgRQ/1pTPSY+W2AWVW
	 Gy3KlKEC0sNvKN+QoFwvVSkcQ+zjzmusiEKEJSjD1ioUCNVWHa5gqJ3wh0hunpCE18
	 sLFnTl8iXRKwAAQSBZgFRz1JAkI0ycaR42OLh9hyFVEdWvhMEVOwXFkrSgLilT4mGP
	 P1/2BKEikVb4Cs0wX8V0QTKr2D3IRrATySNP5UHQ+492YNQOjbMfH1pySa0rLKJ0pT
	 mOwpiZhxyD1Ww==
Date: Sat, 14 Dec 2024 06:32:57 +0000
To: Peter Zijlstra <peterz@infradead.org>, "regressions@lists.linux.dev" <regressions@lists.linux.dev>
From: Ranguvar <ranguvar@ranguvar.io>
Cc: "regressions@leemhuis.info" <regressions@leemhuis.info>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [REGRESSION][BISECTED] from bd9bbc96e835: cannot boot Win11 KVM guest
Message-ID: <jGQc86Npv2BVcA61A7EPFQYcclIuxb07m-UqU0w22FA8_o3-0_xc6OQPp_CHDBZhId9acH4hyiOqki9w7Q0-WmuoVqsCoQfefaHNdfcV2ww=@ranguvar.io>
Feedback-ID: 7618196:user:proton
X-Pm-Message-ID: 17d298ae81f0994ea02c3104009042b0d1197e8b
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello, all,

Any assistance with proper format and process is appreciated as I am new to=
 these lists.
After the commit bd9bbc96e835 "sched: Rework dl_server" I am no longer able=
 to boot my Windows 11 23H2 guest using pinned/exclusive CPU cores and pass=
ing a PCIe graphics card.
This setup worked for me since at least 5.10, likely earlier, with minimal =
changes.

Most or all cores assigned to guest VM report 100% usage, and many tasks on=
 the host hang indefinitely (10min+) until the guest is forcibly stopped.
This happens only once the Windows kernel begins loading - its spinner appe=
ars and freezes.

Still broken on 6.13-rc2, as well as 6.12.4 from Arch's repository.
When testing these, the failure is similar, but tasks on the host are slow =
to execute instead of stalling indefinitely, and hung tasks are not reporte=
d in dmesg. Only one guest core may show 100% utilization instead of many o=
r all of them. This seems to be due to a separate regression which also imp=
acts my usecase [0].
After patching it [1], I then find the same behavior as bd9bbc96e835, with =
hung tasks on host.

git bisect log: [2]
dmesg from 6.11.0-rc1-1-git-00057-gbd9bbc96e835, with decoded hung task bac=
ktraces: [3]
dmesg from arch 6.12.4: [4]
dmesg from arch 6.12.4 patched for svm.c regression, has hung tasks, backtr=
aces could not be decoded: [5]
config for 6.11.0-rc1-1-git-00057-gbd9bbc96e835: [6]
config for arch 6.12.4: [7]

If it helps, my host uses an AMD Ryzen 5950X CPU with latest UEFI and AMD W=
X 5100 (Polaris, GCN 4.0) PCIe graphics.
I use libvirt 10.10 and qemu 9.1.2, and I am passing three PCIe devices eac=
h from dedicated IOMMU groups: NVIDIA RTX 3090 graphics, a Renesas uPD72020=
1 USB controller, and a Samsung 970 EVO NVMe disk.

I have in kernel cmdline `iommu=3Dpt isolcpus=3D1-7,17-23 rcu_nocbs=3D1-7,1=
7-23 nohz_full=3D1-7,17-23`.
Removing iommu=3Dpt does not produce a change, and dropping the core isolat=
ion freezes the host on VM startup.
Enabling/disabling kvm_amd.nested or kvm.enable_virt_at_load did not produc=
e a change.

Thank you for your attention.
- Devin

#regzbot introduced: bd9bbc96e8356886971317f57994247ca491dbf1

[0]: https://lore.kernel.org/regressions/52914da7-a97b-45ad-86a0-affdf8266c=
61@mailbox.org/
[1]: https://lore.kernel.org/regressions/376c445a-9437-4bdd-9b67-e7ce786ae2=
c4@mailbox.org/
[2]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/bisect.log
[3]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/dmesg-6.11.0-rc=
1-1-git-00057-gbd9bbc96e835-decoded.log
[4]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/dmesg-6.12.4-ar=
ch1-1.log
[5]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/dmesg-6.12.4-ar=
ch1-1-patched.log
[6]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/config-6.11.0-r=
c1-1-git-00057-gbd9bbc96e835
[7]: https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/raw/=
6.12.4.arch1-1/config

