Return-Path: <kvm+bounces-3433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88352804495
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F6ACB20B04
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A104A3E;
	Tue,  5 Dec 2023 02:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TLKHfmQb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D82A3C2F
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5FAC433CA;
	Tue,  5 Dec 2023 02:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701742831;
	bh=yGVYTaY5WjmVroBLRmh/zaOtHpLdW1ToCiNR1/hpasM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TLKHfmQbCfpFnLjP1wbNoTuPQpWJKEO+Rv/acUOB1lJ0/tZ75jS9wif7367i41Bg/
	 odG9uQvrD8UIw+QJFe6SnxEDv2Y+bHaZ+8hJWp6xo9XAPaBU2HTXBSpGA9AQrd783i
	 KmcFzNtT/YBvFYWAdVKa9oOd7XMBeOtaKhkCspMmS6a8i/0wJ4hZJYRJcaqpmX+gqu
	 jl/UssF04+26mnA8UgIzB/B7P3YvBhn6Tu7Lek8Wq85Yy9Eaqd8SoPrQ2IbSFFPSRQ
	 7vxbffTpwkbtNCJ8slxlyGkAQ4Mc9Nvg0d0RIkFrvyYP/4GNpRBZVZwayM+BoW7SJC
	 mPvIA9fY8eLxA==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-548ce39b101so6400866a12.2;
        Mon, 04 Dec 2023 18:20:30 -0800 (PST)
X-Gm-Message-State: AOJu0YzvZYO/Cm4r8Q1ZooGiYo/w92pfTbbficQK8rt7YcyjgB9ieh2Q
	x3oH1FfgWEX684rr8rTOdsHZzrcAI9Obd+Q3erM=
X-Google-Smtp-Source: AGHT+IFZlQzjG1R+WCnQ0APvSI1FWHVxxlzrjPGayh4LKHdoF0kRjHnoDZhwhp2SZCjcparsiyJYD0pU2Ui4NlFVo3w=
X-Received: by 2002:a50:d787:0:b0:54c:4837:7d3b with SMTP id
 w7-20020a50d787000000b0054c48377d3bmr2455887edi.122.1701742829397; Mon, 04
 Dec 2023 18:20:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231116023036.2324371-1-maobibo@loongson.cn> <20231116023036.2324371-2-maobibo@loongson.cn>
 <564a2fd3-ffba-3bc5-70b9-8a9fa9a0f1c6@loongson.cn>
In-Reply-To: <564a2fd3-ffba-3bc5-70b9-8a9fa9a0f1c6@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 5 Dec 2023 10:20:17 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4P_JUewDM7R1ByNR4PZa97=xM_rAJ239J-wFSd6_+0GA@mail.gmail.com>
Message-ID: <CAAhV-H4P_JUewDM7R1ByNR4PZa97=xM_rAJ239J-wFSd6_+0GA@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] LoongArch: KVM: Remove SW timer switch when vcpu
 is halt polling
To: zhaotianrui <zhaotianrui@loongson.cn>
Cc: Bibo Mao <maobibo@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This series looks good to me, If Paolo agrees, I will apply to
loongarch-next after [1] is taken into the kvm tree (otherwise there
will be build errors).

[1] https://lore.kernel.org/loongarch/CAAhV-H63QkfSw+Esn8oW2PDEsCnTRPFqkj8X=
-x8i9cH3AS0k9w@mail.gmail.com/T/#t

On Mon, Dec 4, 2023 at 4:45=E2=80=AFPM zhaotianrui <zhaotianrui@loongson.cn=
> wrote:
>
> Reviewed-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>
> =E5=9C=A8 2023/11/16 =E4=B8=8A=E5=8D=8810:30, Bibo Mao =E5=86=99=E9=81=93=
:
> > With halt-polling supported, there is checking for pending events
> > or interrupts when vcpu executes idle instruction. Pending interrupts
> > include injected SW interrupts and passthrough HW interrupts, such as
> > HW timer interrupts, since HW timer works still even if vcpu exists
> > from VM mode.
> >
> > Since HW timer pending interrupt can be set directly with CSR status
> > register, and pending HW timer interrupt checking is used in vcpu block
> > checking function, it is not necessary to switch to sw timer during
> > halt-polling. This patch adds preemption disabling in function
> > kvm_cpu_has_pending_timer, and removes SW timer switching in idle
> > instruction emulation function.
> >
> > Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> > ---
> >   arch/loongarch/kvm/exit.c  | 13 ++-----------
> >   arch/loongarch/kvm/timer.c | 13 ++++++++++---
> >   arch/loongarch/kvm/vcpu.c  |  9 ++++++++-
> >   3 files changed, 20 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> > index ce8de3fa472c..e708a1786d6b 100644
> > --- a/arch/loongarch/kvm/exit.c
> > +++ b/arch/loongarch/kvm/exit.c
> > @@ -200,17 +200,8 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
> >       ++vcpu->stat.idle_exits;
> >       trace_kvm_exit_idle(vcpu, KVM_TRACE_EXIT_IDLE);
> >
> > -     if (!kvm_arch_vcpu_runnable(vcpu)) {
> > -             /*
> > -              * Switch to the software timer before halt-polling/block=
ing as
> > -              * the guest's timer may be a break event for the vCPU, a=
nd the
> > -              * hypervisor timer runs only when the CPU is in guest mo=
de.
> > -              * Switch before halt-polling so that KVM recognizes an e=
xpired
> > -              * timer before blocking.
> > -              */
> > -             kvm_save_timer(vcpu);
> > -             kvm_vcpu_block(vcpu);
> > -     }
> > +     if (!kvm_arch_vcpu_runnable(vcpu))
> > +             kvm_vcpu_halt(vcpu);
> >
> >       return EMULATE_DONE;
> >   }
> > diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
> > index 284bf553fefe..437e960d8fdb 100644
> > --- a/arch/loongarch/kvm/timer.c
> > +++ b/arch/loongarch/kvm/timer.c
> > @@ -155,11 +155,18 @@ static void _kvm_save_timer(struct kvm_vcpu *vcpu=
)
> >                */
> >               hrtimer_cancel(&vcpu->arch.swtimer);
> >               hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_A=
BS_PINNED);
> > -     } else
> > +     } else if (vcpu->stat.generic.blocking) {
> >               /*
> > -              * Inject timer interrupt so that hall polling can dectec=
t and exit
> > +              * Inject timer interrupt so that hall polling can dectec=
t and
> > +              * exit.
> > +              * VCPU is scheduled out already and sleeps in rcuwait qu=
eue and
> > +              * will not poll pending events again. kvm_queue_irq is n=
ot
> > +              * enough, hrtimer swtimer should be used here.
> >                */
> > -             kvm_queue_irq(vcpu, INT_TI);
> > +             expire =3D ktime_add_ns(ktime_get(), 10);  // 10ns is eno=
ugh here?
> > +             vcpu->arch.expire =3D expire;
> > +             hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_A=
BS_PINNED);
> > +     }
> >   }
> >
> >   /*
> > diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> > index 73d0c2b9c1a5..42663a345bd1 100644
> > --- a/arch/loongarch/kvm/vcpu.c
> > +++ b/arch/loongarch/kvm/vcpu.c
> > @@ -187,8 +187,15 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu =
*vcpu,
> >
> >   int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> >   {
> > -     return kvm_pending_timer(vcpu) ||
> > +     int ret;
> > +
> > +     /* protect from TOD sync and vcpu_load/put */
> > +     preempt_disable();
> > +     ret =3D kvm_pending_timer(vcpu) ||
> >               kvm_read_hw_gcsr(LOONGARCH_CSR_ESTAT) & (1 << INT_TI);
> > +     preempt_enable();
> > +
> > +     return ret;
> >   }
> >
> >   int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
>
>

