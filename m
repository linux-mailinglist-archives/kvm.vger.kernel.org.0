Return-Path: <kvm+bounces-50100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13421AE1DC3
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32E851C23AD1
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 14:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A290529617F;
	Fri, 20 Jun 2025 14:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NSx+zimo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF2729290F;
	Fri, 20 Jun 2025 14:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750430650; cv=none; b=mFWxPIix5eo7CKUL0C/nv4uL7EuDIzppkviSG02Lk7pe0jeufwFaqhwrALoKISPIobWa6Qfv+mtxuWYrMW87ckTeV+TC1yVlP9qjAR2Apgl7P8yg10ShOY6kE4SaCvkpfNdfM+AET0gBkMdxd/5DQLMFjJxoHJ5NbNRnYtR+sBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750430650; c=relaxed/simple;
	bh=nEo1ZRZvkkP/cM6rUNrU1aJJ77SioFkxCfmnwoP1kdM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hF6JzN9dmdIDL5MKnml5QRrzJQQEMMTGVhR5FCvXA0rMwYXl0eS8S9OTVHRbaZ+4rdtHNjbhSzYv5pGaZ4zDjPWXC7HRcX5r41wmVmVJaPJJVM7K2+r3NtPQiku8v12/TIaO2Trpm+Zifuk8Txo7zKJDOae8P1vF1VVS/wcY+YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NSx+zimo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47281C4CEE3;
	Fri, 20 Jun 2025 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750430650;
	bh=nEo1ZRZvkkP/cM6rUNrU1aJJ77SioFkxCfmnwoP1kdM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NSx+zimoZCyFNyZu6KW/IjxfIKgaSadsrDdpcD5qVsKEqej2xGbaLKF229jT6iYi/
	 N/jy0QF87sSa7SXwI4C2PNVSSGy4Rl/OqF7+PnjhLlv3mLIgnf9cCbu63KHXXki/Mf
	 kAFCTNlbulB+UA7LLuyU9rkmMm3CVOUsquOQ4Dz3Ywtz/8Pn2Wjb1wnH+w2XQTpYDK
	 Do/EI80QF9fFiHjEHQaSHvbyF6tDnh1/qbn6zMjAq0/7fDX2j1X7q/cwo0NPop51lh
	 zZR3aQ5PSBoewuVUhyTttorHKQqXwkqsQ9FF1qyZdfNeGGVnySIDIiQKi6Fi5aKMzx
	 TTgnnNIxge8KA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6077d0b9bbeso3170255a12.3;
        Fri, 20 Jun 2025 07:44:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWKN+pZgc7Vb74lxvUz2MrEVwgujfNClezidHXS00rDkzeYSEbDhedTlMLL94wmfCVq0eI=@vger.kernel.org, AJvYcCWznR/MJPATZIc1aqPBMRx/5IcLBXBQxiqZpQibieFWq2W8XEU9ebD0hebUJtULWs3PhCTaFgqByyQh1cg1@vger.kernel.org, AJvYcCXqIn15Xlqu0c0UdVRyavSiV05phQy0w+DliQ9JlK5rdUiNvtyaulBouH/oyTwtaYNG0W0nsLND@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1+eMjUPew9AGjv0kGlc1hW7gduo2lu1P99hTdUxJJ82SMDzgs
	yzndMRLbxRmXHro9LoiusVmdFF6aZGDbuwE+JgNaetnFfaUK92yQFEiCT1Ktz6lEZ3P2NkoqvQp
	Rx+ANJjK6v4ahTloPrFYiEL4oXJqu94o=
X-Google-Smtp-Source: AGHT+IHHbZjicZ3sFbJ4BxVo2WPXbTi7fbOErNmBPLm9Uddaz/xQuR0VLEpYetIBm7OsIaMZnqsSlAyT7lePeGLz64k=
X-Received: by 2002:a05:6402:42c8:b0:604:bf4e:852d with SMTP id
 4fb4d7f45d1cf-60a1cd2fac7mr2686937a12.12.1750430648800; Fri, 20 Jun 2025
 07:44:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611014651.3042734-1-maobibo@loongson.cn> <20250611014651.3042734-5-maobibo@loongson.cn>
 <CAAhV-H7ehdkKwzsFNAaX+r5eXLknvskyXLPDKei2A55LoSiJMA@mail.gmail.com> <5f1b9068-2d3d-2f89-4f72-85b021537f58@loongson.cn>
In-Reply-To: <5f1b9068-2d3d-2f89-4f72-85b021537f58@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 20 Jun 2025 22:43:57 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4PKb=BKRQpaqAN7QDu+2PWTinipCAfu13YkaQ0UExuig@mail.gmail.com>
X-Gm-Features: Ac12FXw2U2SLyEPOk2oakF_Oj26FqKRq_batQU44_B8SUUMV9IcbFMjQDv_X0M4
Message-ID: <CAAhV-H4PKb=BKRQpaqAN7QDu+2PWTinipCAfu13YkaQ0UExuig@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] LoongArch: KVM: INTC: Check validation of num_cpu
 from user space
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2025 at 9:43=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/6/19 =E4=B8=8B=E5=8D=884:46, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Wed, Jun 11, 2025 at 9:47=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> The maximum supported cpu number is EIOINTC_ROUTE_MAX_VCPUS about
> >> irqchip eiointc, here add validation about cpu number to avoid array
> >> pointer overflow.
> >>
> >> Cc: stable@vger.kernel.org
> >> Fixes: 1ad7efa552fd ("LoongArch: KVM: Add EIOINTC user mode read and w=
rite functions")
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/kvm/intc/eiointc.c | 18 +++++++++++++-----
> >>   1 file changed, 13 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/in=
tc/eiointc.c
> >> index b48511f903b5..ed80bf290755 100644
> >> --- a/arch/loongarch/kvm/intc/eiointc.c
> >> +++ b/arch/loongarch/kvm/intc/eiointc.c
> >> @@ -798,7 +798,7 @@ static int kvm_eiointc_ctrl_access(struct kvm_devi=
ce *dev,
> >>          int ret =3D 0;
> >>          unsigned long flags;
> >>          unsigned long type =3D (unsigned long)attr->attr;
> >> -       u32 i, start_irq;
> >> +       u32 i, start_irq, val;
> >>          void __user *data;
> >>          struct loongarch_eiointc *s =3D dev->kvm->arch.eiointc;
> >>
> >> @@ -806,7 +806,12 @@ static int kvm_eiointc_ctrl_access(struct kvm_dev=
ice *dev,
> >>          spin_lock_irqsave(&s->lock, flags);
> >>          switch (type) {
> >>          case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
> >> -               if (copy_from_user(&s->num_cpu, data, 4))
> >> +               if (copy_from_user(&val, data, 4) =3D=3D 0) {
> >> +                       if (val < EIOINTC_ROUTE_MAX_VCPUS)
> >> +                               s->num_cpu =3D val;
> >> +                       else
> >> +                               ret =3D -EINVAL;
> > Maybe it is better to set s->num_cpu to EIOINTC_ROUTE_MAX_VCPUS (or
> > other value) rather than keep it uninitialized. Because in other
> > places we need to check s->num_cpu and an uninitialized value may
> > cause undefined behavior.
> There is error return value -EINVAL, VMM should stop running and exit
> immediately if there is error return value with the ioctl command.
>
> num_cpu is not uninitialized and it is zero by default. If VMM does not
> care about the return value, VMM will fail to get coreisr information in
> future.
If you are sure you can keep it as is. Then please resend patch
1,2,3,4,5,9 as a series because they are all bug fixes that should be
merged as soon as possible. And in my own opinion, "INTC" can be
dropped in the title.


Huacai

>
> Regards
> Bibo Mao
> >
> >
> > Huacai
> >> +               } else
> >>                          ret =3D -EFAULT;
> >>                  break;
> >>          case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE:
> >> @@ -835,7 +840,7 @@ static int kvm_eiointc_regs_access(struct kvm_devi=
ce *dev,
> >>                                          struct kvm_device_attr *attr,
> >>                                          bool is_write)
> >>   {
> >> -       int addr, cpuid, offset, ret =3D 0;
> >> +       int addr, cpu, offset, ret =3D 0;
> >>          unsigned long flags;
> >>          void *p =3D NULL;
> >>          void __user *data;
> >> @@ -843,7 +848,7 @@ static int kvm_eiointc_regs_access(struct kvm_devi=
ce *dev,
> >>
> >>          s =3D dev->kvm->arch.eiointc;
> >>          addr =3D attr->attr;
> >> -       cpuid =3D addr >> 16;
> >> +       cpu =3D addr >> 16;
> >>          addr &=3D 0xffff;
> >>          data =3D (void __user *)attr->addr;
> >>          switch (addr) {
> >> @@ -868,8 +873,11 @@ static int kvm_eiointc_regs_access(struct kvm_dev=
ice *dev,
> >>                  p =3D &s->isr.reg_u32[offset];
> >>                  break;
> >>          case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
> >> +               if (cpu >=3D s->num_cpu)
> >> +                       return -EINVAL;
> >> +
> >>                  offset =3D (addr - EIOINTC_COREISR_START) / 4;
> >> -               p =3D &s->coreisr.reg_u32[cpuid][offset];
> >> +               p =3D &s->coreisr.reg_u32[cpu][offset];
> >>                  break;
> >>          case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
> >>                  offset =3D (addr - EIOINTC_COREMAP_START) / 4;
> >> --
> >> 2.39.3
> >>
>

