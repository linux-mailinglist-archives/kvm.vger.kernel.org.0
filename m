Return-Path: <kvm+bounces-34035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DD329F5E8E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 07:22:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98FDB188FBCC
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 06:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5688316A92E;
	Wed, 18 Dec 2024 06:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ranguvar.io header.i=@ranguvar.io header.b="ienVjLSt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-10624.protonmail.ch (mail-10624.protonmail.ch [79.135.106.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B915DBAB
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 06:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734502887; cv=none; b=I6s94+faMhkk2a+Y+kFg3DGgntqZAwmUDJHNAsCJvopoA0h7nCjQoBTDWaBnUiaw2J4rLmdIfe0whL4HYigW6tS1U0eqFMG8q4+fQpHJNzFbSRLrWIpkVhjlqxWWl6ddxqvnTAOF45zPN2GqN/NO5rSobXHVumM5Vmnr65gGQfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734502887; c=relaxed/simple;
	bh=P/NUSBKCiSbjFDZH9M6o3quQcZVDMs9PSO0zpu8NIBE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isGHIN9qUyIIw0b0D0LPlvWudDnM/YM65BEpeTuQ2XDvj+R3oislGdzFG9uuNlF9A1rqeLzdD3SVn0arwXcLVLysGblPQByRnJ308ambcxM+gdScTYJgw3TzFiPIMVJTMpju1o8Ci5e5ZN30oGBmPvcvw/hRUpv+YO/TEmwmJVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ranguvar.io; spf=pass smtp.mailfrom=ranguvar.io; dkim=pass (2048-bit key) header.d=ranguvar.io header.i=@ranguvar.io header.b=ienVjLSt; arc=none smtp.client-ip=79.135.106.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ranguvar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ranguvar.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ranguvar.io;
	s=protonmail3; t=1734502877; x=1734762077;
	bh=P/NUSBKCiSbjFDZH9M6o3quQcZVDMs9PSO0zpu8NIBE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=ienVjLStZDwaJN3QOFXfiZ3Hf/Lr7NVfqOCD2Ji/V8VUVMo858uiwZrY2egBxLVbA
	 XadMqAVFdlcB3Oty8evGkwOGgRweaD8YYqSfgYEgsjZB/ULjfG9ckJjmJ9kEZHlU91
	 DKLVqykzRsdUuCn87UwzD/Gk3NEGllV+4oLIExWOWogLHOLXZW/2H4SSw0R9oZBtwQ
	 LEks5vBzcbgYO2G0LfA3sr44te0jNQUo070hq5u9fUGlbouN6aK8JZA1eZo8qzoROC
	 mr373pg6lfBLS91kA8lNs4dARSltVgs966uTKQT6pG1bg+7AF+DF5Z7Ynf34R/R9xl
	 YncbWZh8m/Ifw==
Date: Wed, 18 Dec 2024 06:21:10 +0000
To: Juri Lelli <juri.lelli@redhat.com>, Sean Christopherson <seanjc@google.com>
From: Ranguvar <ranguvar@ranguvar.io>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@gmail.com>, "regressions@lists.linux.dev" <regressions@lists.linux.dev>, "regressions@leemhuis.info" <regressions@leemhuis.info>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [REGRESSION][BISECTED] from bd9bbc96e835: cannot boot Win11 KVM guest
Message-ID: <stYazPax2Mcu7VeTPJu8XXGkOiaVyF8LaZzfHDEG4izEwt4-Ztoo-cmNAv19O9nryHkybONeruyS8yNKOcV0CSicHcd6q_ptGOmADHgut2U=@ranguvar.io>
In-Reply-To: <Z2E858-8jA6_xWFd@jlelli-thinkpadt14gen4.remote.csb>
References: <jGQc86Npv2BVcA61A7EPFQYcclIuxb07m-UqU0w22FA8_o3-0_xc6OQPp_CHDBZhId9acH4hyiOqki9w7Q0-WmuoVqsCoQfefaHNdfcV2ww=@ranguvar.io> <20241214185248.GE10560@noisy.programming.kicks-ass.net> <gvam6amt25mlvpxlpcra2caesdfpr5a75cba3e4n373tzqld3k@ciutribtvmjj> <Z2BaZSKtaAPGSCqb@google.com> <b6d8WzC2p_tpdLs36QeL_oqtEKy_pRy-PdeOxa08JtTcPhHNNOCjN73b799C0gv8NnmIJKH9gD6J4W-Dv5JKEVdrbMoVUp3wSOrqEY_LrDg=@ranguvar.io> <Z2E858-8jA6_xWFd@jlelli-thinkpadt14gen4.remote.csb>
Feedback-ID: 7618196:user:proton
X-Pm-Message-ID: 17fcd3b8fe3df59a24ded1b614f05a19f3022687
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The bug is caused by Windows kernel as a KVM guest.
Cannot reproduce with Ubuntu 24.10 install iso and nouveau driver.
Windows 11 23H2 install iso reproduces reliably.

Two [0] more [1] kernel logs below.
Decode worked only on the first - spent too long trying to fix it.

On Tuesday, December 17th, 2024 at 08:57, Juri Lelli <juri.lelli@redhat.com=
> wrote:
>
> On 16/12/24 20:40, Ranguvar wrote:
>
> > On Monday, December 16th, 2024 at 16:50, Sean Christopherson seanjc@goo=
gle.com wrote:
> >
> > > On Mon, Dec 16, 2024, Juri Lelli wrote:
> > >
> > > > On 14/12/24 19:52, Peter Zijlstra wrote:
> > > >
> > > > > On Sat, Dec 14, 2024 at 06:32:57AM +0000, Ranguvar wrote:
> > > > >
> > > > > > I have in kernel cmdline `iommu=3Dpt isolcpus=3D1-7,17-23 rcu_n=
ocbs=3D1-7,17-23 nohz_full=3D1-7,17-23`. Removing iommu=3Dpt does not produ=
ce a change, and
> > > > > > dropping the core isolation freezes the host on VM startup.
> > >
> > > As in, dropping all of isolcpus, rcu_nocbs, and nohz_full? Or just dr=
opping
> > > isolcpus?
> >
> > Thanks for looking.
> > I had dropped all three, but not altered the VM guest config, which is:
> >
> > <cputune>
> > <vcpupin vcpu=3D'0' cpuset=3D'2'/>
> > <vcpupin vcpu=3D'1' cpuset=3D'18'/>
> > ...
> > <vcpupin vcpu=3D'11' cpuset=3D'23'/>
> > <emulatorpin cpuset=3D'1,17'/>
> > <iothreadpin iothread=3D'1' cpuset=3D'1,17'/>
> > <vcpusched vcpus=3D'0' scheduler=3D'fifo' priority=3D'95'/>
> > ...
> > <iothreadsched iothreads=3D'1' scheduler=3D'fifo' priority=3D'50'/>
>
>
> Are you disabling/enabling/configuring RT throttling (sched_rt_{runtime,
> period}_us) in your configuration?
>

I don't touch these.

[ranguvar@khufu ~]$ cat /proc/sys/kernel/sched_rt_period_us
1000000
[ranguvar@khufu ~]$ cat /proc/sys/kernel/sched_rt_runtime_us
950000

I removed myself from realtime group also (used by PipeWire) but still the =
same breakage.

> > </cputune>
> >
> > CPU mode is host-passthrough, cache mode is passthrough.
> >
> > The 24GB VRAM did cause trouble when setting up resizeable BAR months a=
go as well. It necessitated a special qemu config:
> > qemu:commandline
> > <qemu:arg value=3D'-fw_cfg'/>
> > <qemu:arg value=3D'opt/ovmf/PciMmio64Mb,string=3D65536'/>
> > </qemu:commandline>

I removed this config block as it appears unnecessary now.
No impact on this issue.

I tried also changed the size of the BAR from 32GB to 256MB manually before=
 running the guest.

lspci:
Region 1: Memory at 7000000000 (64-bit, prefetchable) [size=3D32G]
Region 3: Memory at 7800000000 (64-bit, prefetchable) [size=3D32M]

after unbinding vfio_pci, writing '8' to to resource1_resize, and rebinding=
:
Region 1: Memory at 1040000000 (64-bit, prefetchable) [size=3D256M]
Region 3: Memory at 1050000000 (64-bit, prefetchable) [size=3D32M]

No impact.

[0]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/dmesg-6.11.0-rc=
1-1-git-00057-gbd9bbc96e835-20241216-decoded.log
[1]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/dmesg-6.11.0-rc=
1-1-git-00057-gbd9bbc96e835-20241217.log

