Return-Path: <kvm+bounces-32912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 141C29E16CC
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C891528349E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A89E1DF736;
	Tue,  3 Dec 2024 09:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k8fQ7KNW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5771E1DEFC7;
	Tue,  3 Dec 2024 09:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733217008; cv=none; b=n79FdX3IiJoU38GhOU3NQa1WLGC8p/mekuWxBBLgksjidEJiiWW1mzUqvGo0rOJ25sYy8+MQB6wj104nvLXJsT5RrDF/IktQmTTzVuIWqJ6akAbOq0z8kLf49jNOQy6AmD6a6JbXhuHC82GqzZcy2hz9eNaa0666kjoYoz66KME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733217008; c=relaxed/simple;
	bh=UzE4vPo4BUY7d8LgQQ6hVOdG+ZDuviyLVjKjvrd0CLU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PXA99HvieixgNxzgqpim1UzDPcaI2vqc+uj9hso82LpPx/E41DHTpGic+DZoTNFuIQay0KAN+YiMydwOeNNog4NzJfryJh+Exxn3APn8Nyl2CcYCvBu2NDaSiML4uToUH7AsJ+6WfoT7dORjj4SW6EGk8Zwg+S/Daoyct4S35Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k8fQ7KNW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3671BC4CED6;
	Tue,  3 Dec 2024 09:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733217008;
	bh=UzE4vPo4BUY7d8LgQQ6hVOdG+ZDuviyLVjKjvrd0CLU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=k8fQ7KNWcYXjpzrr3rJsEPJeU/9VRghXulAnZrEfIgBsDiA9Roz0UhFM9D485pZfF
	 daqw4OnaPc8yZ+heugmFLOyHNQnVqZIvNH1vOeNZHsOv9jpxVKzzQZiQZURFGODYlZ
	 UcRckZsAgDFDGvRVzivxJccLb6QQoRNBdt1GIRtA1BeLgaqGrkLGnTSVHDaYXUoqKv
	 EyYnR2E+ghe9+03pc0hDjQ7yXlNZgoqf68KSGCtXw8nflOXy7kiNPbFtb0mGuGXulC
	 1D04aNEvAR08rLTNYQ6ZUhahY9bjt1Vs2ecWDHHBkesSWhFlY53ZaKt5hLKEJ8qfNl
	 TFUgHSoK/R8pg==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa53a971480so788231666b.1;
        Tue, 03 Dec 2024 01:10:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVYYhPtX/mq1Rlc3zOa3lEGVtm+5qP6hbOSWoHqn9w9so9kDKiSa6SFXX+xEbmh+Xmt8CfgDn/t@vger.kernel.org, AJvYcCX4QRNp2vuy2t95+AIDOGozQfeElzcdLI8t/IJIP7TKBt1SISHdz9jGe2KXZpb05PmYJMQ=@vger.kernel.org, AJvYcCXHAvhjLyMClafukovxoSO819ZamZ0szKFBM3eWckqPlU5uni+/aWfNCNJ1KBBrOuVdBzTMpXhWVnyUmVEI@vger.kernel.org
X-Gm-Message-State: AOJu0YykvRgO+Nb/hbcbMUBYWgig+B3f12NkWf0jEzxCSsEwGLFWmlqo
	sS/rLHxQBrauiQZAQWUwS/AsZZLDwwGCZSha7uiwdIis+aHeeSeK2bNTI/R/YvHW/tB0XIAOBB9
	KfW2w4J3bmMm9yugWGOOTsoXgF0k=
X-Google-Smtp-Source: AGHT+IFL8bKet6y3ANM013drJivZ4d5VcROR7rTZM7FjW9rJD/k7XCQdSsgqxfrhjaqQLvg3NxDPhywgeHlouzX6qTw=
X-Received: by 2002:a17:907:7815:b0:a9e:43d9:401a with SMTP id
 a640c23a62f3a-aa5f7d15961mr128812766b.14.1733217006734; Tue, 03 Dec 2024
 01:10:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203065058.4164631-1-chenhuacai@loongson.cn>
 <20241203065058.4164631-2-chenhuacai@loongson.cn> <99ccaf01-9176-20c3-2463-148cb5cafcea@loongson.cn>
In-Reply-To: <99ccaf01-9176-20c3-2463-148cb5cafcea@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 3 Dec 2024 17:09:55 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7eJ3FP4wnOb4XBv_FFCu3SkBu60URzWid2oXj-3bmXBA@mail.gmail.com>
Message-ID: <CAAhV-H7eJ3FP4wnOb4XBv_FFCu3SkBu60URzWid2oXj-3bmXBA@mail.gmail.com>
Subject: Re: [PATCH 2/2] LoongArch: KVM: Protect kvm_io_bus_{read,write}()
 with SRCU
To: bibo mao <maobibo@loongson.cn>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 4:51=E2=80=AFPM bibo mao <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/12/3 =E4=B8=8B=E5=8D=882:50, Huacai Chen wrote:
> > When we enable lockdep we get such a warning:
> >
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> >   WARNING: suspicious RCU usage
> >   6.12.0-rc7+ #1891 Tainted: G        W
> >   -----------------------------
> >   arch/loongarch/kvm/../../../virt/kvm/kvm_main.c:5945 suspicious rcu_d=
ereference_check() usage!
> >   other info that might help us debug this:
> >   rcu_scheduler_active =3D 2, debug_locks =3D 1
> >   1 lock held by qemu-system-loo/948:
> >    #0: 90000001184a00a8 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+=
0xf4/0xe20 [kvm]
> >   stack backtrace:
> >   CPU: 2 UID: 0 PID: 948 Comm: qemu-system-loo Tainted: G        W     =
     6.12.0-rc7+ #1891
> >   Tainted: [W]=3DWARN
> >   Hardware name: Loongson Loongson-3A5000-7A1000-1w-CRB/Loongson-LS3A50=
00-7A1000-1w-CRB, BIOS vUDK2018-LoongArch-V2.0.0-prebeta9 10/21/2022
> >   Stack : 0000000000000089 9000000005a0db9c 90000000071519c8 900000012c=
578000
> >           900000012c57b940 0000000000000000 900000012c57b948 9000000007=
e53788
> >           900000000815bcc8 900000000815bcc0 900000012c57b7b0 0000000000=
000001
> >           0000000000000001 4b031894b9d6b725 0000000005dec000 9000000100=
427b00
> >           00000000000003d2 0000000000000001 000000000000002d 0000000000=
000003
> >           0000000000000030 00000000000003b4 0000000005dec000 0000000000=
000000
> >           900000000806d000 9000000007e53788 00000000000000b4 0000000000=
000004
> >           0000000000000004 0000000000000000 0000000000000000 9000000107=
baf600
> >           9000000008916000 9000000007e53788 9000000005924778 000000001f=
e001e5
> >           00000000000000b0 0000000000000007 0000000000000000 0000000000=
071c1d
> >           ...
> >   Call Trace:
> >   [<9000000005924778>] show_stack+0x38/0x180
> >   [<90000000071519c4>] dump_stack_lvl+0x94/0xe4
> >   [<90000000059eb754>] lockdep_rcu_suspicious+0x194/0x240
> >   [<ffff80000221f47c>] kvm_io_bus_read+0x19c/0x1e0 [kvm]
> >   [<ffff800002225118>] kvm_emu_mmio_read+0xd8/0x440 [kvm]
> >   [<ffff8000022254bc>] kvm_handle_read_fault+0x3c/0xe0 [kvm]
> >   [<ffff80000222b3c8>] kvm_handle_exit+0x228/0x480 [kvm]
> >
> > Fix it by protecting kvm_io_bus_{read,write}() with SRCU.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> >   arch/loongarch/kvm/exit.c     | 31 +++++++++++++++++++++----------
> >   arch/loongarch/kvm/intc/ipi.c |  6 +++++-
> >   2 files changed, 26 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> > index 69f3e3782cc9..a7893bd01e73 100644
> > --- a/arch/loongarch/kvm/exit.c
> > +++ b/arch/loongarch/kvm/exit.c
> > @@ -156,7 +156,7 @@ static int kvm_handle_csr(struct kvm_vcpu *vcpu, la=
rch_inst inst)
> >
> >   int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vc=
pu *vcpu)
> >   {
> > -     int ret;
> > +     int idx, ret;
> >       unsigned long *val;
> >       u32 addr, rd, rj, opcode;
> >
> > @@ -167,7 +167,6 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *=
run, struct kvm_vcpu *vcpu)
> >       rj =3D inst.reg2_format.rj;
> >       opcode =3D inst.reg2_format.opcode;
> >       addr =3D vcpu->arch.gprs[rj];
> > -     ret =3D EMULATE_DO_IOCSR;
> >       run->iocsr_io.phys_addr =3D addr;
> >       run->iocsr_io.is_write =3D 0;
> >       val =3D &vcpu->arch.gprs[rd];
> > @@ -207,20 +206,28 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run=
 *run, struct kvm_vcpu *vcpu)
> >       }
> >
> >       if (run->iocsr_io.is_write) {
> > -             if (!kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, run->ioc=
sr_io.len, val))
> > +             idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> > +             ret =3D kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, run->=
iocsr_io.len, val);
> > +             srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +             if (ret =3D=3D 0)
> >                       ret =3D EMULATE_DONE;
> > -             else
> > +             else {
> > +                     ret =3D EMULATE_DO_IOCSR;
> >                       /* Save data and let user space to write it */
> >                       memcpy(run->iocsr_io.data, val, run->iocsr_io.len=
);
> > -
> > +             }
> >               trace_kvm_iocsr(KVM_TRACE_IOCSR_WRITE, run->iocsr_io.len,=
 addr, val);
> >       } else {
> > -             if (!kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, run->iocs=
r_io.len, val))
> > +             idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> > +             ret =3D kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, run->i=
ocsr_io.len, val);
> > +             srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +             if (ret =3D=3D 0)
> >                       ret =3D EMULATE_DONE;
> > -             else
> > +             else {
> > +                     ret =3D EMULATE_DO_IOCSR;
> >                       /* Save register id for iocsr read completion */
> >                       vcpu->arch.io_gpr =3D rd;
> > -
> > +             }
> >               trace_kvm_iocsr(KVM_TRACE_IOCSR_READ, run->iocsr_io.len, =
addr, NULL);
> >       }
> >
> > @@ -359,7 +366,7 @@ static int kvm_handle_gspr(struct kvm_vcpu *vcpu)
> >
> >   int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
> >   {
> > -     int ret;
> > +     int idx, ret;
> >       unsigned int op8, opcode, rd;
> >       struct kvm_run *run =3D vcpu->run;
> >
> > @@ -464,8 +471,10 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch=
_inst inst)
> >                * it need not return to user space to handle the mmio
> >                * exception.
> >                */
> > +             idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> >               ret =3D kvm_io_bus_read(vcpu, KVM_MMIO_BUS, vcpu->arch.ba=
dv,
> >                                     run->mmio.len, &vcpu->arch.gprs[rd]=
);
> > +             srcu_read_unlock(&vcpu->kvm->srcu, idx);
> >               if (!ret) {
> >                       update_pc(&vcpu->arch);
> >                       vcpu->mmio_needed =3D 0;
> > @@ -531,7 +540,7 @@ int kvm_complete_mmio_read(struct kvm_vcpu *vcpu, s=
truct kvm_run *run)
> >
> >   int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
> >   {
> > -     int ret;
> > +     int idx, ret;
> >       unsigned int rd, op8, opcode;
> >       unsigned long curr_pc, rd_val =3D 0;
> >       struct kvm_run *run =3D vcpu->run;
> > @@ -631,7 +640,9 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch=
_inst inst)
> >                * it need not return to user space to handle the mmio
> >                * exception.
> >                */
> > +             idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> >               ret =3D kvm_io_bus_write(vcpu, KVM_MMIO_BUS, vcpu->arch.b=
adv, run->mmio.len, data);
> > +             srcu_read_unlock(&vcpu->kvm->srcu, idx);
> >               if (!ret)
> >                       return EMULATE_DONE;
> >
> > diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ip=
i.c
> > index a233a323e295..4b7ff20ed438 100644
> > --- a/arch/loongarch/kvm/intc/ipi.c
> > +++ b/arch/loongarch/kvm/intc/ipi.c
> > @@ -98,7 +98,7 @@ static void write_mailbox(struct kvm_vcpu *vcpu, int =
offset, uint64_t data, int
> >
> >   static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t =
data)
> >   {
> > -     int i, ret;
> > +     int i, idx, ret;
> >       uint32_t val =3D 0, mask =3D 0;
> >
> >       /*
> > @@ -107,7 +107,9 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa=
_t addr, uint64_t data)
> >        */
> >       if ((data >> 27) & 0xf) {
> >               /* Read the old val */
> > +             srcu_read_unlock(&vcpu->kvm->srcu, idx);
> here should be idx =3D srcu_read_lock(&vcpu->kvm->srcu) ?
>
> >               ret =3D kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof=
(val), &val);
> > +             srcu_read_unlock(&vcpu->kvm->srcu, idx);
> >               if (unlikely(ret)) {
> >                       kvm_err("%s: : read date from addr %llx failed\n"=
, __func__, addr);
> >                       return ret;
> > @@ -121,7 +123,9 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa=
_t addr, uint64_t data)
> >               val &=3D mask;
> >       }
> >       val |=3D ((uint32_t)(data >> 32) & ~mask);
> > +     srcu_read_unlock(&vcpu->kvm->srcu, idx);
> here should be idx =3D srcu_read_lock(&vcpu->kvm->srcu)
Yes, this is my mistake, thank you.

Huacai

>
> >       ret =3D kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), =
&val);
> > +     srcu_read_unlock(&vcpu->kvm->srcu, idx);
> >       if (unlikely(ret))
> >               kvm_err("%s: : write date to addr %llx failed\n", __func_=
_, addr);
> >
> >
> otherwise looks good to me.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>
>

