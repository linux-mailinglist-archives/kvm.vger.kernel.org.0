Return-Path: <kvm+bounces-38645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8218FA3D239
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 08:28:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7CD57A5AB4
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 07:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42AB1E7640;
	Thu, 20 Feb 2025 07:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="TXWMQaL4"
X-Original-To: kvm@vger.kernel.org
Received: from lf-2-14.ptr.blmpb.com (lf-2-14.ptr.blmpb.com [101.36.218.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DB71E0B8A
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 07:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740036503; cv=none; b=PSAoHfdcy3V3tlp8AzmUnQoTZz34ChUhTFk8DgYhA+mbqxHhmyobGCqXsJkBSIubPKJDT5ED3qSJ0gP5hus1lyuzYQ5q/w9+oEX7EAVOMto8D1dFsgSeqicg3JXqCfgvPwIxCpx203Zig020Y+APOZr/HVyVcnLfQAoEB620GZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740036503; c=relaxed/simple;
	bh=EQlwESW28jy8H3w3MMdhsY3PYvVTowSGooaNS8KU2J0=;
	h=To:From:Mime-Version:In-Reply-To:References:Date:Message-Id:Cc:
	 Subject:Content-Type; b=t94eshbJbSrxpo5w82JXOPm5sW/abP1mbSifheodLpHBbfVeIlvPbsAc63p7tLAzZHJ+mP4Wd7v0wX5cLP6yrgXZWw+4fzpyhOW6ZGw7J6YHK0iZklnV12jup8qVI3BY52e4LNCjcDlakIP44ESRvK4Jt1LhwD0rak1oertUgyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=TXWMQaL4; arc=none smtp.client-ip=101.36.218.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1740035581;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=EQlwESW28jy8H3w3MMdhsY3PYvVTowSGooaNS8KU2J0=;
 b=TXWMQaL4r92kd/4/msL40bUej1du5Q2f6Wi6H+qgWGT3SsAr8qCZS/f33LbaNkfBC+zaJ8
 WQxji9HJsd/OF8eonzba5eCrrGcAln4nuzkNo06NfSeug4BR42x+vunmgmrvrZavpdqRe+
 YZAb8eBv6BxYHW0m3hBuTy88C0k+N+XmIkI4+vkr5vELr1q+D5ilwxVR4d/gn3kzQgRDsl
 2sBVToqvLBlB1/o7W6S5UlzoFv3XhAjVeY7X7GEZhwc3R3HnY5XUhYJ9VrcY8FkBcX03aT
 a2A3Bb885FtZnqjpgOx6WmbKKJUO645ln1Bsek9TntpnGGL7Zcgy0rk4M/q8TA==
To: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
From: "xiangwencheng" <xiangwencheng@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <D7WALEFMK28X.13HQ0UL1S3NM5@ventanamicro.com>
References: <20250219015426.1939-1-xiangwencheng@lanxincomputing.com>
	<D7WALEFMK28X.13HQ0UL1S3NM5@ventanamicro.com>
X-Lms-Return-Path: <lba+167b6d5fb+5aa47e+vger.kernel.org+xiangwencheng@lanxincomputing.com>
Date: Thu, 20 Feb 2025 15:12:58 +0800
Message-Id: <38cc241c40a8ef2775e304d366bcd07df733ecf0.f7f1d4c7.545f.42a8.90f5.c5d09b1d32ec@feishu.cn>
Cc: <anup@brainfault.org>, <ajones@ventanamicro.com>, 
	<kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>, 
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, 
	<atishp@atishpatra.org>, <paul.walmsley@sifive.com>, 
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, 
	"linux-riscv" <linux-riscv-bounces@lists.infradead.org>
Subject: Re: [PATCH] riscv: KVM: Remove unnecessary vcpu kick
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> From: "Radim Kr=C4=8Dm=C3=A1=C5=99"<rkrcmar@ventanamicro.com>
> Date:=C2=A0 Wed, Feb 19, 2025, 16:51
> Subject:=C2=A0 Re: [PATCH] riscv: KVM: Remove unnecessary vcpu kick
> To: "BillXiang"<xiangwencheng@lanxincomputing.com>, <anup@brainfault.org>
> Cc: <ajones@ventanamicro.com>, <kvm-riscv@lists.infradead.org>, <kvm@vger=
.kernel.org>, <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.=
org>, <atishp@atishpatra.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.=
com>, <aou@eecs.berkeley.edu>, "linux-riscv"<linux-riscv-bounces@lists.infr=
adead.org>
> 2025-02-19T09:54:26+08:00, BillXiang <xiangwencheng@lanxincomputing.com>:

> > Thank you Andrew Jones, forgive my errors in the last email.

> > I'm wondering whether it's necessary to kick the virtual hart

> > after writing to the vsfile of IMSIC.

> > From my understanding, writing to the vsfile should directly

> > forward the interrupt as MSI to the virtual hart. This means that

> > an additional kick should not be necessary, as it would cause the

> > vCPU to exit unnecessarily and potentially degrade performance.

>=C2=A0
> Andrew proposed to avoid the exit overhead, but do a wakeup if the VCPU

> is "sleeping". =C2=A0I talked with Andrew and thought so as well, but now=
 I

> agree with you that we shouldn't have anything extra here.

>=C2=A0
> Direct MSIs from IOMMU or other harts won't perform anything afterwards,

> so what you want to do correct and KVM has to properly handle the memory

> write alone.

>=C2=A0
> > I've tested this behavior in QEMU, and it seems to work perfectly

> > fine without the extra kick.

>=C2=A0
> If the rest of KVM behaves correctly is a different question.

> A mistake might result in a very rare race condition, so it's better to

> do verification rather than generic testing.

>=C2=A0
> For example, is `vsfile_cpu >=3D 0` the right condition for using direct

> interrupts?

>=C2=A0
> I don't see KVM setting vsfile_cpu to -1 before descheduling after

It's not necessary to set vsfile_cpu to -1 as it doesn't release it, and
the vsfile still belongs to the vCPU after WFI.

> emulating WFI, which could cause a bug as a MSI would never cause a wake

> up. =C2=A0It might still look like it works, because something else could=
 be

> waking the VCPU up and then the VCPU would notice this MSI as well.

>=C2=A0
> Please note that I didn't actualy verify the KVM code, so it can be

> correct, I just used this to give you an example of what can go wrong

> without being able to see it in testing.

>=C2=A0
> I would like to know if KVM needs fixing before this change is accepted.

> (It could make bad things worse.)

As "KVM:=C2=A0 WFI wake-up using IMSIC VS-files" that described in [1], wri=
ting to=C2=A0
VS-FILE will wake up vCPU.

KVM has also handled the situation of WFI. Here is the WFI emulation proces=
s:
kvm_riscv_vcpu_exit=C2=A0
=C2=A0=C2=A0=C2=A0 -> kvm_riscv_vcpu_virtual_insn=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 -> system_opcode_insn=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 -> wfi_insn=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> kvm_riscv_=
vcpu_wfi
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -> kvm_vcpu_halt
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 -> kvm_vcpu_block
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> kvm_arch_vcpu_blocking
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> kvm_riscv_aia_wakeon_h=
gei
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> c=
sr_set(CSR_HGEIE, BIT(hgei));
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> set_current_state(TASK_INTERRUPTIBLE);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> schedule

In kvm_arch_vcpu_blocking it will enable guest external interrupt, which
means wirting to VS_FILE will cause an interrupt. And the interrupt handler
hgei_interrupt which is setted in aia_hgei_init will finally call kvm_vcpu_=
kick
to wake up vCPU.

So I still think is not necessary to call another kvm_vcpu_kick after writi=
ng to
VS_FILE.

Waiting for more info. Thanks.

[1]=C2=A0 https://kvm-forum.qemu.org/2022/AIA_Virtualization_in_KVM_RISCV_f=
inal.pdf

>=C2=A0
> > Would appreciate any insights or confirmation on this!

>=C2=A0
> Your patch is not acceptable because of its commit message, though.

> Please look again at the document that Andrew posted and always reply

> the previous thread if you do not send a new patch version.

>=C2=A0
> The commit message should be on point.

> Please avoid extraneous information that won't help anyone reading the

> commit. =C2=A0Greeting and commentary can go below the "---" line.

> (And possibly above a "---8<---" line, although that is not official and

> =C2=A0may cause issues with some maintainers.)

>=C2=A0
> Thanks.
>=C2=A0

