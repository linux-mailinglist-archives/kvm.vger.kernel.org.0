Return-Path: <kvm+bounces-38653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6714DA3D33B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 09:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 383C1178B5A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 08:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411281E7C27;
	Thu, 20 Feb 2025 08:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="eUdNYUYT"
X-Original-To: kvm@vger.kernel.org
Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5625223
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 08:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740040282; cv=none; b=qdoOILe+OUtv01h3I/BuaioeGe0PJR3Qxg0lHCnqc5eClkzI66sViHfdDvSDzX80HcEvpjaRwVC2/MbAxmop7POHkJsMAm+Nyg2vUbj+f41tbu0eCm4sp9L7yPyVj23UZGxGnuJL98ARJcw8q5VSj5cwHAOxC4cxnGMM8Lq4MtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740040282; c=relaxed/simple;
	bh=pmGu7qlT9sN4uFBznTexCJJyE2/CEgvGdWTgk5+9oHI=;
	h=To:Mime-Version:In-Reply-To:Date:Message-Id:From:References:
	 Content-Type:Cc:Subject; b=Nxb+wrHnKwAwjQ4DlM2FJPTHgWYQIk0R0hh8PXhvG4FxabCXuxfWaJNZPIMCJtH0kKb2f/Wke6hpgqb6D10te48GzoMfHi7Ep8KH8fR0S2KlvS76ct/673YrNmuDIuIcOPr89Lh55uXOsKWobSDud2/tTsE+VdqvyV/j6IrvsAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=eUdNYUYT; arc=none smtp.client-ip=209.127.231.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1740039456;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=pmGu7qlT9sN4uFBznTexCJJyE2/CEgvGdWTgk5+9oHI=;
 b=eUdNYUYT66qLI47XM+Bp4foSDc1HjUmiaDUY4GHxey6tVOrjIDP2OsT3YpnJhE1PhoUL9u
 7P/oMwZ5gykMCDrkjhvfLodt04Q9kl4cDH/HwHbcKJSaaZfVfLWR3rBoV+vAbWrGZCKvTl
 Y9i/K3o9Ra3X+rGygkYkCzUnAfDsbwrjjWYKw3KXfZAZ/ChceIWIy0/N40PglscGqbWb2Z
 fwiC4aSmCn2wKGkidxwJKHnE7do1sM7SmnyiViohHX2LgVmWfSqwiMvAjy3TIECM52Wz60
 tLRZLc061LpGWuVIlgrQvpPEnFlsEebbcNboo1uygKIscWqKOK3+XKwhhxQYgA==
To: "Andrew Jones" <ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20250220-f9c4c4b3792a66999ea5b385@orel>
Date: Thu, 20 Feb 2025 16:17:33 +0800
Message-Id: <38cc241c40a8ef2775e304d366bcd07df733ecf0.818d94fe.c229.4f42.a074.e64851f0591b@feishu.cn>
From: "xiangwencheng" <xiangwencheng@lanxincomputing.com>
X-Lms-Return-Path: <lba+167b6e51e+f6566d+vger.kernel.org+xiangwencheng@lanxincomputing.com>
References: <20250219015426.1939-1-xiangwencheng@lanxincomputing.com> <D7WALEFMK28X.13HQ0UL1S3NM5@ventanamicro.com> <38cc241c40a8ef2775e304d366bcd07df733ecf0.f7f1d4c7.545f.42a8.90f5.c5d09b1d32ec@feishu.cn>
	<20250220-f9c4c4b3792a66999ea5b385@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>, 
	<anup@brainfault.org>, <kvm-riscv@lists.infradead.org>, 
	<kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>, <atishp@atishpatra.org>, 
	<paul.walmsley@sifive.com>, <palmer@dabbelt.com>, 
	<aou@eecs.berkeley.edu>, 
	"linux-riscv" <linux-riscv-bounces@lists.infradead.org>
Subject: Re: [PATCH] riscv: KVM: Remove unnecessary vcpu kick


> From: "Andrew Jones"<ajones@ventanamicro.com>
> Date:=C2=A0 Thu, Feb 20, 2025, 16:01
> Subject:=C2=A0 Re: [PATCH] riscv: KVM: Remove unnecessary vcpu kick
> To: "xiangwencheng"<xiangwencheng@lanxincomputing.com>
> Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99"<rkrcmar@ventanamicro.com>, <anup@brainf=
ault.org>, <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>, <linux-r=
iscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <atishp@atishpat=
ra.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <aou@eecs.berkel=
ey.edu>, "linux-riscv"<linux-riscv-bounces@lists.infradead.org>
> On Thu, Feb 20, 2025 at 03:12:58PM +0800, xiangwencheng wrote:

> ...

> > As "KVM:=C2=A0 WFI wake-up using IMSIC VS-files" that described in [1],=
 writing to=C2=A0

> > VS-FILE will wake up vCPU.

> >=C2=A0

> > KVM has also handled the situation of WFI. Here is the WFI emulation pr=
ocess:

> > kvm_riscv_vcpu_exit=C2=A0

> > =C2=A0=C2=A0=C2=A0 -> kvm_riscv_vcpu_virtual_insn=C2=A0

> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 -> system_opcode_insn=C2=A0

> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 -> wfi_insn=C2=A0

> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> kvm_ri=
scv_vcpu_wfi

> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 -> kvm_vcpu_halt

> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 -> kvm_vcpu_block

> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> kvm_arch_vcpu_blocking

> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> kvm_riscv_aia_wa=
keon_hgei

> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -> csr_set(CSR_HGEIE, BIT(hgei));

> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> set_current_state(TASK_INTERRUPTIBLE)=
;

> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> schedule

> >=C2=A0

> > In kvm_arch_vcpu_blocking it will enable guest external interrupt, whic=
h

> > means wirting to VS_FILE will cause an interrupt. And the interrupt han=
dler

> > hgei_interrupt which is setted in aia_hgei_init will finally call kvm_v=
cpu_kick

> > to wake up vCPU.

> >=C2=A0

> > So I still think is not necessary to call another kvm_vcpu_kick after w=
riting to

> > VS_FILE.

> >=C2=A0

> > Waiting for more info. Thanks.

> >=C2=A0

> > [1]=C2=A0 https://kvm-forum.qemu.org/2022/AIA_Virtualization_in_KVM_RIS=
CV_final.pdf

> >

>=C2=A0
> Right, we don't need anything since hgei_interrupt() kicks for us, but if

> we do

>=C2=A0
> @@ -973,8 +973,8 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *=
vcpu,

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 read_lock_irqsave(&imsic->vsfile_lock, flags)=
;

>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (imsic->vsfile_cpu >=3D 0) {

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_vcpu_wake_up(vcpu)=
;

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(iid, imsic=
->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);

> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_vcpu_kick(vcpu);

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 eix =3D &imsic->s=
wfile->eix[iid / BITS_PER_TYPE(u64)];

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 set_bit(iid & (BI=
TS_PER_TYPE(u64) - 1), eix->eip);

>=C2=A0
> then we should be able to avoid taking a host interrupt.

But it may schedule again in the for(;;) loop of kvm_vcpu_block after kvm_v=
cpu_wake_up but=C2=A0
before the write of vsfile, and we will still get a host interrupt.
@@ -3573,6 +3573,8 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
=C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0 for (;;) {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 set_current_st=
ate(TASK_INTERRUPTIBLE);

+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 // Here will not break b=
efore the write of vsfile,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 // and then we will sche=
dule again.
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 if (kvm_vcpu_c=
heck_block(vcpu) < 0)
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0=C2=A0 break;

=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 waited =3D tru=
e;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 schedule();
=C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0 }

Thanks=C2=A0

>=C2=A0
> Thanks,

> drew
>=C2=A0

