Return-Path: <kvm+bounces-64325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39619C7F510
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 09:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDFF23A3EE7
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 08:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF182EB5D4;
	Mon, 24 Nov 2025 08:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TChvw1lK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21EB1ACEAF
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 08:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971383; cv=none; b=InwB1Cm3q++/kDcZDXJlXgTvJi1THMyxvqjV7Xxyt0a8JFKraqxIdqHmWJr8aBsCLFotXSh2A868RjwfkceWvd0csn7Sj1JoLOR1CIn9rW9eiwAywOuPPkwZ16NenMalFKS8bvykk401ddR0V/PMC+dODishcMkZr160rTD7o8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971383; c=relaxed/simple;
	bh=7qqSCskKT1/j59SPPOeGeethp3d6D5wFNlQiF1XMee4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qr5OEHmEtWO2rXMS+SCOKg7SL9zsjaV6wtu9g47q+nYzWluyEBL1Wn6v862MDrtJ43/80cGJoj/KwrJj0LCX8ORdOW8vm6iGdVRPIXtAUBrZ0k5mOKVs/vuiybSiNiyCiia8mamo/GZ59gdNYpN6g4+CN8dZM2cRm8BbVo6jMFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TChvw1lK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2345C19422
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 08:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971383;
	bh=7qqSCskKT1/j59SPPOeGeethp3d6D5wFNlQiF1XMee4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TChvw1lKF6wgupvOE/tGiCguoVlIfcDl22v/sqL/WsYrFh5HF7/lLoBZ6x78o+TAb
	 xsnA0sXUEmWvArqlgliSHNN0DyWiGTcGzSCTDsQueTXIKQTeQ4KBX2gqOz2RdkCB4n
	 +4VSTFYYJGaETaJ+ZuyIIhz0I5bX2KEsJdsMIDlw4P6upa23Nee3kbaxjRwU+E4qyO
	 DwdP2Yfpew9TkKDkpDr69MkRe02cxtSmNjDo2vPwPKjQFj0nNxEV/BLz6vAKmnypuM
	 UBF4xWOXsY8PgdYogeIE6VcoPeO0j3uqgE7SFOBcDzjhSSsaCwK5SHrPtwuRvNJXsE
	 qQJzofYvif9wg==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b7277324054so585579766b.0
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 00:03:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXTznixHQpU6rhXrxvrjViZ3XSQk3Fyi7ZAyYSS2tnMfXgygl7lmkp3nkaaqkHd1KezzFE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEsc7r76yVGF4Bxi5cbLfwx8dXGKXX65ehj6jdsFmLP4cET7hp
	9tQsUukTiKmh5/4UKiwkaTR7fTOhodGNbZTZArxRGj4YctEgSd/4hWYalWJiqXFjB9dKuvm6MPw
	J7I6Mpx3VcE2ZxNoZa6k+22jaUe5bDWo=
X-Google-Smtp-Source: AGHT+IHfhqsEg0xHKxKMhbLZ90QQ/0ce5RQOf5bJqJyKHI1FhetfndKF/FPGsCP85/nXhrhJ2brZxQz6+gPTvugNBbo=
X-Received: by 2002:a17:907:3e10:b0:b72:b710:cbfd with SMTP id
 a640c23a62f3a-b767170f7e7mr1118834366b.36.1763971382163; Mon, 24 Nov 2025
 00:03:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124035402.3817179-1-maobibo@loongson.cn> <20251124035402.3817179-3-maobibo@loongson.cn>
 <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>
 <5d80c452-bbc3-539a-fb8d-14dbe353f8cb@loongson.cn> <CAAhV-H66M+GZ2kB8BKR82BUeQcNZ8ACeXLxwjh-bsVZcca1cqQ@mail.gmail.com>
 <718b5b5d-2bb1-5d59-409e-54f54516a6b7@loongson.cn>
In-Reply-To: <718b5b5d-2bb1-5d59-409e-54f54516a6b7@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 24 Nov 2025 16:03:06 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4X5EAgDTnSGG+1pMWywoLAis5TH_jEWkvaY8p1m8hQMg@mail.gmail.com>
X-Gm-Features: AWmQ_bmScDniJuPmdChN15kPKiUNTiD9QrRs4nZ9s6L-p8Y1Hn1fMk60jZjpnDM
Message-ID: <CAAhV-H4X5EAgDTnSGG+1pMWywoLAis5TH_jEWkvaY8p1m8hQMg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] LoongArch: Add paravirt support with
 vcpu_is_preempted() in guest side
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>, 
	Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 3:50=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/11/24 =E4=B8=8B=E5=8D=883:13, Huacai Chen wrote:
> > On Mon, Nov 24, 2025 at 3:03=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >>
> >>
> >> On 2025/11/24 =E4=B8=8B=E5=8D=882:33, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Mon, Nov 24, 2025 at 11:54=E2=80=AFAM Bibo Mao <maobibo@loongson.c=
n> wrote:
> >>>>
> >>>> Function vcpu_is_preempted() is used to check whether vCPU is preemp=
ted
> >>>> or not. Here add implementation with vcpu_is_preempted() when option
> >>>> CONFIG_PARAVIRT is enabled.
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/include/asm/qspinlock.h |  5 +++++
> >>>>    arch/loongarch/kernel/paravirt.c       | 16 ++++++++++++++++
> >>>>    2 files changed, 21 insertions(+)
> >>>>
> >>>> diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch=
/include/asm/qspinlock.h
> >>>> index e76d3aa1e1eb..9a5b7ba1f4cb 100644
> >>>> --- a/arch/loongarch/include/asm/qspinlock.h
> >>>> +++ b/arch/loongarch/include/asm/qspinlock.h
> >>>> @@ -34,6 +34,11 @@ static inline bool virt_spin_lock(struct qspinloc=
k *lock)
> >>>>           return true;
> >>>>    }
> >>>>
> >>>> +#ifdef CONFIG_SMP
> >>>> +#define vcpu_is_preempted      vcpu_is_preempted
> >>>> +bool vcpu_is_preempted(int cpu);
> >>> In V1 there is a build error because you reference mp_ops, so in V2
> >>> you needn't put it in CONFIG_SMP.
> >> The compile failure problem is that vcpu_is_preempted() is redefined i=
n
> >> both arch/loongarch/kernel/paravirt.c and include/linux/sched.h
> > But other archs don't define vcpu_is_preempted() under CONFIG_SMP, and
> so what is advantage to implement this function if CONFIG_SMP is disabled=
?
1. Keep consistency with other architectures.
2. Keep it simple to reduce #ifdefs (and !SMP is just for build, not
very useful in practice).

>
> > you can consider to inline the whole vcpu_is_preempted() here.
> Defining the function vcpu_is_preempted() as inlined is not so easy for
> me, it beyond my ability now :(
>
> With static key method, the static key need be exported, all modules
> need apply the jump label, that is dangerous and I doubt whether it is
> deserved.
No, you have already done similar things in virt_spin_lock(), it is an
inline function and uses virt_spin_lock_key.

Huacai

>
> Regards
> Bibo Mao
> >
> >>
> >> The problem is that <asm/spinlock.h> is not included by sched.h, if
> >> CONFIG_SMP is disabled. Here is part of file include/linux/spinlock.h
> >> #ifdef CONFIG_SMP
> >> # include <asm/spinlock.h>
> >> #else
> >> # include <linux/spinlock_up.h>
> >> #endif
> >>
> >>> On the other hand, even if you really build a UP guest kernel, when
> >>> multiple guests run together, you probably need vcpu_is_preemtped.
> >> It is not relative with multiple VMs. When vcpu_is_preempted() is
> >> called, it is to detect whether dest CPU is preempted or not, the cpu
> >> from smp_processor_id() should not be preempted. So in generic
> >> vcpu_is_preempted() works on multiple vCPUs.
> > OK, I'm wrong here.
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
> >>>
> >>>> +#endif
> >>>> +
> >>>>    #endif /* CONFIG_PARAVIRT */
> >>>>
> >>>>    #include <asm-generic/qspinlock.h>
> >>>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kerne=
l/paravirt.c
> >>>> index b1b51f920b23..d4163679adc4 100644
> >>>> --- a/arch/loongarch/kernel/paravirt.c
> >>>> +++ b/arch/loongarch/kernel/paravirt.c
> >>>> @@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
> >>>>    }
> >>>>
> >>>>    #ifdef CONFIG_SMP
> >>>> +DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
> >>>>    static int pv_time_cpu_online(unsigned int cpu)
> >>>>    {
> >>>>           unsigned long flags;
> >>>> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned in=
t cpu)
> >>>>
> >>>>           return 0;
> >>>>    }
> >>>> +
> >>>> +bool notrace vcpu_is_preempted(int cpu)
> >>>> +{
> >>>> +       struct kvm_steal_time *src;
> >>>> +
> >>>> +       if (!static_branch_unlikely(&virt_preempt_key))
> >>>> +               return false;
> >>>> +
> >>>> +       src =3D &per_cpu(steal_time, cpu);
> >>>> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
> >>>> +}
> >>>> +EXPORT_SYMBOL(vcpu_is_preempted);
> >>>>    #endif
> >>>>
> >>>>    static void pv_cpu_reboot(void *unused)
> >>>> @@ -308,6 +321,9 @@ int __init pv_time_init(void)
> >>>>                   pr_err("Failed to install cpu hotplug callbacks\n"=
);
> >>>>                   return r;
> >>>>           }
> >>>> +
> >>>> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
> >>>> +               static_branch_enable(&virt_preempt_key);
> >>>>    #endif
> >>>>
> >>>>           static_call_update(pv_steal_clock, paravt_steal_clock);
> >>>> --
> >>>> 2.39.3
> >>>>
> >>
> >>
>
>

