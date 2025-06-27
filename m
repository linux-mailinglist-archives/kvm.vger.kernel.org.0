Return-Path: <kvm+bounces-50961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79175AEB200
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 11:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F041D3B09BF
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 09:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C89293C71;
	Fri, 27 Jun 2025 09:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqoUKrlK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662E8293C5F;
	Fri, 27 Jun 2025 09:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751015102; cv=none; b=MKyi3qKmKjJxgfXXgyxFK0OKTsNsOA8YjhBdkXE7JFKcIyNmzFFSCWbgvyfDJ4mIb/jy7KQbIqjqL9JTLMT1lUp0nMyfRsX4ipjGikcGogRt2nq69E1QZuaqqbqvgrFm2CsDaBZ3lu1RW7IVXgAq9QTp1c5k4eaypwrK6SEGMKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751015102; c=relaxed/simple;
	bh=HyUpfkwo3OLd9F0gZisf9Z3XogUbFl8HwK9Z7M+FwCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QNSCJ1+EaTmVyVLABeUCCbniDZ4emnmIphj4ifbgoEQN7v5ioxwwaX7bFoCbXGwDUusv+QH1cANhIKXPtnhvHfRXM154ax5xuC9wnunUdgo3RFNsT72r/ZYVJHgyK1GP4lKdmcs0z4G2r1QnjjGLa/oe33x2RruSRVaH94QY/5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqoUKrlK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1CEC4CEEB;
	Fri, 27 Jun 2025 09:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751015102;
	bh=HyUpfkwo3OLd9F0gZisf9Z3XogUbFl8HwK9Z7M+FwCo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HqoUKrlKjcfaJqFAofZK786sma14dwU5R04TptjlEqpZ/4e3ExMBYXB6YhycGvRpx
	 Pyh7DGH+4ar+rr+pprsEn3EudrSVJjMFFLgQgdsDYQtZN7TwdaEUHWIlak1FcHygod
	 6l1WOtlXRnFg7J+O0QDMAC+83Wgl4xM/R148Nk/X7RIoTowU5NiWqh00GuMsQOxyZo
	 PQeuN2XQndJZIQrYJ4yFwSRg5zTM01+gRZm+lPFyJ6WybcoHO6lHa70Cw2He+4zrRA
	 VHFoRT8vNmBUq69/86BFb59sxucw6M08V2aNQf2a1giVHLa9P9F3KjeQihszaWiFXl
	 Kize/olNRWPAA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ade76b8356cso379478766b.2;
        Fri, 27 Jun 2025 02:05:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVhciAB7y0bkemxs9zZ4XFZHrEzGQMQK2/GFvp594uG9KyY+it5Z5/fRJimwn0EkbZqBAo=@vger.kernel.org, AJvYcCVyOj53Zlu4rzhTCI0y5c2cxYB7+92qzLUfBHp5l2OaqBhTxJjcOJnSjTrv0DD7tRCYjKRcg1zVTwedvwKs@vger.kernel.org, AJvYcCXSkSj3RYip9anINt2ZlAhM8ji9avaV6HWnC9u+GECysls60azTsdvScZamZ0vJcUFSC/Y1+9lL@vger.kernel.org
X-Gm-Message-State: AOJu0YzjKkB3Al7lgNFVDVK0rzEguiTzJGmscmt54HqdpZTVITU+++TA
	mPGxg7fe2+O/5s2F7ViuU5nfIp5pvpfg9vatKNEJso0WbPbWni6ctl+RPihyZqyciyMPHGE7wqF
	0Repb5DTG+NcEHQGAdmB6KsV9zjus8/g=
X-Google-Smtp-Source: AGHT+IEvosZjZ8qlQI1TWdzY2BFBdYwwyYkTxohXHwdPQMGg4r1HAszF45OOoljF6JDYZKXjqfGGh3254k6sM/7UHS4=
X-Received: by 2002:a17:907:7f14:b0:ae0:c561:b806 with SMTP id
 a640c23a62f3a-ae3500f276fmr205995466b.37.1751015100598; Fri, 27 Jun 2025
 02:05:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611014651.3042734-1-maobibo@loongson.cn> <20250611014651.3042734-5-maobibo@loongson.cn>
 <CAAhV-H7ehdkKwzsFNAaX+r5eXLknvskyXLPDKei2A55LoSiJMA@mail.gmail.com>
 <5f1b9068-2d3d-2f89-4f72-85b021537f58@loongson.cn> <CAAhV-H4PKb=BKRQpaqAN7QDu+2PWTinipCAfu13YkaQ0UExuig@mail.gmail.com>
 <d197255b-9165-adc5-8ba1-a6d96579fc38@loongson.cn>
In-Reply-To: <d197255b-9165-adc5-8ba1-a6d96579fc38@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 27 Jun 2025 17:04:48 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6bqQHQfVn7xiiMU5mxWSpMjPzs2JiJcgkuzFdEPEqUtw@mail.gmail.com>
X-Gm-Features: Ac12FXwovi1RrlIs6G8wabZYte5B612Jb13CsPcMfGkALjhwcNHkppZDmFR3oDs
Message-ID: <CAAhV-H6bqQHQfVn7xiiMU5mxWSpMjPzs2JiJcgkuzFdEPEqUtw@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] LoongArch: KVM: INTC: Check validation of num_cpu
 from user space
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2025 at 3:44=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/6/20 =E4=B8=8B=E5=8D=8810:43, Huacai Chen wrote:
> > On Fri, Jun 20, 2025 at 9:43=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >>
> >>
> >> On 2025/6/19 =E4=B8=8B=E5=8D=884:46, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Wed, Jun 11, 2025 at 9:47=E2=80=AFAM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> The maximum supported cpu number is EIOINTC_ROUTE_MAX_VCPUS about
> >>>> irqchip eiointc, here add validation about cpu number to avoid array
> >>>> pointer overflow.
> >>>>
> >>>> Cc: stable@vger.kernel.org
> >>>> Fixes: 1ad7efa552fd ("LoongArch: KVM: Add EIOINTC user mode read and=
 write functions")
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/kvm/intc/eiointc.c | 18 +++++++++++++-----
> >>>>    1 file changed, 13 insertions(+), 5 deletions(-)
> >>>>
> >>>> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/=
intc/eiointc.c
> >>>> index b48511f903b5..ed80bf290755 100644
> >>>> --- a/arch/loongarch/kvm/intc/eiointc.c
> >>>> +++ b/arch/loongarch/kvm/intc/eiointc.c
> >>>> @@ -798,7 +798,7 @@ static int kvm_eiointc_ctrl_access(struct kvm_de=
vice *dev,
> >>>>           int ret =3D 0;
> >>>>           unsigned long flags;
> >>>>           unsigned long type =3D (unsigned long)attr->attr;
> >>>> -       u32 i, start_irq;
> >>>> +       u32 i, start_irq, val;
> >>>>           void __user *data;
> >>>>           struct loongarch_eiointc *s =3D dev->kvm->arch.eiointc;
> >>>>
> >>>> @@ -806,7 +806,12 @@ static int kvm_eiointc_ctrl_access(struct kvm_d=
evice *dev,
> >>>>           spin_lock_irqsave(&s->lock, flags);
> >>>>           switch (type) {
> >>>>           case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
> >>>> -               if (copy_from_user(&s->num_cpu, data, 4))
> >>>> +               if (copy_from_user(&val, data, 4) =3D=3D 0) {
> >>>> +                       if (val < EIOINTC_ROUTE_MAX_VCPUS)
> >>>> +                               s->num_cpu =3D val;
> >>>> +                       else
> >>>> +                               ret =3D -EINVAL;
> >>> Maybe it is better to set s->num_cpu to EIOINTC_ROUTE_MAX_VCPUS (or
> >>> other value) rather than keep it uninitialized. Because in other
> >>> places we need to check s->num_cpu and an uninitialized value may
> >>> cause undefined behavior.
> >> There is error return value -EINVAL, VMM should stop running and exit
> >> immediately if there is error return value with the ioctl command.
> >>
> >> num_cpu is not uninitialized and it is zero by default. If VMM does no=
t
> >> care about the return value, VMM will fail to get coreisr information =
in
> >> future.
> > If you are sure you can keep it as is. Then please resend patch
> > 1,2,3,4,5,9 as a series because they are all bug fixes that should be
> > merged as soon as possible. And in my own opinion, "INTC" can be
> > dropped in the title.
> Ok, will do in this way.
Not needed now, patches have been applied.


Huacai

>
> Regards
> Bibo Mao
> >
> >
> > Huacai
> >
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>>
> >>> Huacai
> >>>> +               } else
> >>>>                           ret =3D -EFAULT;
> >>>>                   break;
> >>>>           case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE:
> >>>> @@ -835,7 +840,7 @@ static int kvm_eiointc_regs_access(struct kvm_de=
vice *dev,
> >>>>                                           struct kvm_device_attr *at=
tr,
> >>>>                                           bool is_write)
> >>>>    {
> >>>> -       int addr, cpuid, offset, ret =3D 0;
> >>>> +       int addr, cpu, offset, ret =3D 0;
> >>>>           unsigned long flags;
> >>>>           void *p =3D NULL;
> >>>>           void __user *data;
> >>>> @@ -843,7 +848,7 @@ static int kvm_eiointc_regs_access(struct kvm_de=
vice *dev,
> >>>>
> >>>>           s =3D dev->kvm->arch.eiointc;
> >>>>           addr =3D attr->attr;
> >>>> -       cpuid =3D addr >> 16;
> >>>> +       cpu =3D addr >> 16;
> >>>>           addr &=3D 0xffff;
> >>>>           data =3D (void __user *)attr->addr;
> >>>>           switch (addr) {
> >>>> @@ -868,8 +873,11 @@ static int kvm_eiointc_regs_access(struct kvm_d=
evice *dev,
> >>>>                   p =3D &s->isr.reg_u32[offset];
> >>>>                   break;
> >>>>           case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
> >>>> +               if (cpu >=3D s->num_cpu)
> >>>> +                       return -EINVAL;
> >>>> +
> >>>>                   offset =3D (addr - EIOINTC_COREISR_START) / 4;
> >>>> -               p =3D &s->coreisr.reg_u32[cpuid][offset];
> >>>> +               p =3D &s->coreisr.reg_u32[cpu][offset];
> >>>>                   break;
> >>>>           case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
> >>>>                   offset =3D (addr - EIOINTC_COREMAP_START) / 4;
> >>>> --
> >>>> 2.39.3
> >>>>
> >>
>
>

