Return-Path: <kvm+bounces-64332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD74EC7FA7C
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1FCF3A46C1
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 09:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E961C2F60CF;
	Mon, 24 Nov 2025 09:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7Ibu4ZG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108502F5465
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 09:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763976818; cv=none; b=c2sI8cuwZZ/mOaj988XPiuvtXdiWXq2yJWTkXdECiljoOjvThF+UcyhZQMv6IrhiD+lf2GnpXpmVYGmbyCwh6IMMmlWmIpnP0106rlyY84z7+fQNs3S1EH8cAxzTKZ8mjo0+Qv6rdJ5vZq/4IPQaVj/zIImP450doh9yr4Ea3FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763976818; c=relaxed/simple;
	bh=l/aFKl/vq8XFeE3Ve8NjX3lmAHR9nkzPqCFhW8Ub5tw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EjEQCyboZUIX1e+FoB0XVGeCeG40oBRxlxk4qzwjgOFkjuYMCtgypd0hJiVMcnTYrzOVwp17KrLk78IZ13IFkr3Mzy1PEciVRSKKMvrjeQ3YpTR1fLZsrNzRrnr1SnjUHGc+kzhaJUHbWKbKEx38NYqGit9niy7gQNeyrMinYEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7Ibu4ZG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4456C2BC9E
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 09:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763976817;
	bh=l/aFKl/vq8XFeE3Ve8NjX3lmAHR9nkzPqCFhW8Ub5tw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=B7Ibu4ZGkDHw+50xVBX1YZUri/g82O2+V5QmQJ9tlVT8abCxGBbkyTyZOaqJ7kEGd
	 V6/iC4Q4JRauNVwMEkJKtUxRHTQ4HfOfvT468+d0ZvoxF1b/UD4vXKpW5dZ8kCaqdL
	 TqJrpyCUR+fd3YJtjnXlZaGiaz8GuybC/86dFn6C/n1fJu/vUl/aci73F1ku7rFUrS
	 r47huOOyUxbR08wA379TWu7gZQxFaNIYhH+RE3TzOdlX1hxPLpuDN0J87KPuh6lppB
	 XLSDnEF/PO+yi5cF/dpxm6yenHLQkm12dqBBO8EmVfUL5y94yMXTb8VDgaK5Mpm7Ob
	 jAhMCuW9oFDBQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b73875aa527so634776166b.3
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 01:33:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVuk1OWermGr3NtyxefWwwvl9WWjw7ynRBkq8VcNc+XRR0u5JAovhnDvauxEEDk6PDvRCc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMyhagLg7Sp2DpKwHMXqOVfrzTBbceAwdxi1jjsNA3i9bqponr
	f5CtnE3wiCSv3eu0o9QQVg1n2i4Xy9LZRyI+O0E8CTeaxHb+DcJBsq5q5bY7N6K2Hlheh6FnaSS
	wWwAM4fXXNIR0qr3zvIbYGBjqCP4c+0s=
X-Google-Smtp-Source: AGHT+IGhq7B3+q6MUxZOfB4I/Jc80kE/87H06uje+HhN+0UrWoZ5nZJIaCFJWY/XIx6S5+6bMxo754j3sOmC6jjnYPM=
X-Received: by 2002:a17:907:c1a:b0:b73:544d:ba2e with SMTP id
 a640c23a62f3a-b76715e604bmr1229957166b.25.1763976816331; Mon, 24 Nov 2025
 01:33:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124035402.3817179-1-maobibo@loongson.cn> <20251124035402.3817179-3-maobibo@loongson.cn>
 <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>
 <5d80c452-bbc3-539a-fb8d-14dbe353f8cb@loongson.cn> <CAAhV-H66M+GZ2kB8BKR82BUeQcNZ8ACeXLxwjh-bsVZcca1cqQ@mail.gmail.com>
 <718b5b5d-2bb1-5d59-409e-54f54516a6b7@loongson.cn> <CAAhV-H4X5EAgDTnSGG+1pMWywoLAis5TH_jEWkvaY8p1m8hQMg@mail.gmail.com>
 <611840bb-7f7d-3b13-dc89-b760d8eeda79@loongson.cn> <CAAhV-H6TWCs-tFf5HCOt9cAY01J-nirzVmu1GEAYpP=1LWznPA@mail.gmail.com>
 <393b2f18-c860-9d71-6d86-5a496983c3fd@loongson.cn>
In-Reply-To: <393b2f18-c860-9d71-6d86-5a496983c3fd@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 24 Nov 2025 17:33:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5iUqfBKS2ONv1VN8FrUUMwPc_ZNP6Ms5ufGKW2gD0twA@mail.gmail.com>
X-Gm-Features: AWmQ_bk98W3NAi7B5ifunuyoc9CyIGj0PzDrFTosb-RIOcwJkWbtGIrHXEgG6zE
Message-ID: <CAAhV-H5iUqfBKS2ONv1VN8FrUUMwPc_ZNP6Ms5ufGKW2gD0twA@mail.gmail.com>
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

On Mon, Nov 24, 2025 at 5:08=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/11/24 =E4=B8=8B=E5=8D=885:03, Huacai Chen wrote:
> > On Mon, Nov 24, 2025 at 4:35=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >>
> >>
> >> On 2025/11/24 =E4=B8=8B=E5=8D=884:03, Huacai Chen wrote:
> >>> On Mon, Nov 24, 2025 at 3:50=E2=80=AFPM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2025/11/24 =E4=B8=8B=E5=8D=883:13, Huacai Chen wrote:
> >>>>> On Mon, Nov 24, 2025 at 3:03=E2=80=AFPM Bibo Mao <maobibo@loongson.=
cn> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 2025/11/24 =E4=B8=8B=E5=8D=882:33, Huacai Chen wrote:
> >>>>>>> Hi, Bibo,
> >>>>>>>
> >>>>>>> On Mon, Nov 24, 2025 at 11:54=E2=80=AFAM Bibo Mao <maobibo@loongs=
on.cn> wrote:
> >>>>>>>>
> >>>>>>>> Function vcpu_is_preempted() is used to check whether vCPU is pr=
eempted
> >>>>>>>> or not. Here add implementation with vcpu_is_preempted() when op=
tion
> >>>>>>>> CONFIG_PARAVIRT is enabled.
> >>>>>>>>
> >>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>steal_time
> >>>>>>>> ---
> >>>>>>>>      arch/loongarch/include/asm/qspinlock.h |  5 +++++
> >>>>>>>>      arch/loongarch/kernel/paravirt.c       | 16 +++++++++++++++=
+
> >>>>>>>>      2 files changed, 21 insertions(+)
> >>>>>>>>
> >>>>>>>> diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loong=
arch/include/asm/qspinlock.h
> >>>>>>>> index e76d3aa1e1eb..9a5b7ba1f4cb 100644
> >>>>>>>> --- a/arch/loongarch/include/asm/qspinlock.h
> >>>>>>>> +++ b/arch/loongarch/include/asm/qspinlock.h
> >>>>>>>> @@ -34,6 +34,11 @@ static inline bool virt_spin_lock(struct qspi=
nlock *lock)
> >>>>>>>>             return true;
> >>>>>>>>      }
> >>>>>>>>
> >>>>>>>> +#ifdef CONFIG_SMP
> >>>>>>>> +#define vcpu_is_preempted      vcpu_is_preempted
> >>>>>>>> +bool vcpu_is_preempted(int cpu);
> >>>>>>> In V1 there is a build error because you reference mp_ops, so in =
V2
> >>>>>>> you needn't put it in CONFIG_SMP.
> >>>>>> The compile failure problem is that vcpu_is_preempted() is redefin=
ed in
> >>>>>> both arch/loongarch/kernel/paravirt.c and include/linux/sched.h
> >>>>> But other archs don't define vcpu_is_preempted() under CONFIG_SMP, =
and
> >>>> so what is advantage to implement this function if CONFIG_SMP is dis=
abled?
> >>> 1. Keep consistency with other architectures.
> >>> 2. Keep it simple to reduce #ifdefs (and !SMP is just for build, not
> >>> very useful in practice).
> >> It seems that CONFIG_SMP can be removed in header file
> >> include/asm/qspinlock.h, since asm/spinlock.h and asm/qspinlock.h is
> >> only included when CONFIG_SMP is set, otherwise only linux/spinlock_up=
.h
> >> is included.
> >>
> >>>
> >>>>
> >>>>> you can consider to inline the whole vcpu_is_preempted() here.
> >>>> Defining the function vcpu_is_preempted() as inlined is not so easy =
for
> >>>> me, it beyond my ability now :(
> >>>>
> >>>> With static key method, the static key need be exported, all modules
> >>>> need apply the jump label, that is dangerous and I doubt whether it =
is
> >>>> deserved.
> >>> No, you have already done similar things in virt_spin_lock(), it is a=
n
> >>> inline function and uses virt_spin_lock_key.
> >> virt_spin_lock is only called qspinlock in function
> >> queued_spin_lock_slowpath(). Function vcpu_is_preempted() is defined
> >> header file linux/sched.h, kernel module may use it.
> > Yes, if modules want to use it we need to EXPORT_SYMBOL. But don't
> > worry, static key infrastructure can handle this. Please see
> > cpu_feature_keys defined and used in
> > arch/powerpc/include/asm/cpu_has_feature.h, which is exported in
> > arch/powerpc/kernel/cputable.c.
> No, I do not want to do so. export static key and percpu steal_time> stru=
cture, just in order to implement one inline function.
In V1 you care about the performance of vcpu_is_preempted(), so inline
can satisfy your own requirement.

But this is your own choice, I don't insist on that. I only want to
remove CONFIG_SMP for vcpu_is_preempted().


Huacai
>
> >
> > Huacai
> >
> >>
> >>
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>> Regards
> >>>> Bibo Mao
> >>>>>
> >>>>>>
> >>>>>> The problem is that <asm/spinlock.h> is not included by sched.h, i=
f
> >>>>>> CONFIG_SMP is disabled. Here is part of file include/linux/spinloc=
k.h
> >>>>>> #ifdef CONFIG_SMP
> >>>>>> # include <asm/spinlock.h>
> >>>>>> #else
> >>>>>> # include <linux/spinlock_up.h>
> >>>>>> #endif
> >>>>>>
> >>>>>>> On the other hand, even if you really build a UP guest kernel, wh=
en
> >>>>>>> multiple guests run together, you probably need vcpu_is_preemtped=
.
> >>>>>> It is not relative with multiple VMs. When vcpu_is_preempted() is
> >>>>>> called, it is to detect whether dest CPU is preempted or not, the =
cpu
> >>>>>> from smp_processor_id() should not be preempted. So in generic
> >>>>>> vcpu_is_preempted() works on multiple vCPUs.
> >>>>> OK, I'm wrong here.
> >>>>>
> >>>>>
> >>>>> Huacai
> >>>>>
> >>>>>>
> >>>>>> Regards
> >>>>>> Bibo Mao
> >>>>>>>
> >>>>>>>
> >>>>>>> Huacai
> >>>>>>>
> >>>>>>>> +#endif
> >>>>>>>> +
> >>>>>>>>      #endif /* CONFIG_PARAVIRT */
> >>>>>>>>
> >>>>>>>>      #include <asm-generic/qspinlock.h>
> >>>>>>>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/k=
ernel/paravirt.c
> >>>>>>>> index b1b51f920b23..d4163679adc4 100644
> >>>>>>>> --- a/arch/loongarch/kernel/paravirt.c
> >>>>>>>> +++ b/arch/loongarch/kernel/paravirt.c
> >>>>>>>> @@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
> >>>>>>>>      }
> >>>>>>>>
> >>>>>>>>      #ifdef CONFIG_SMP
> >>>>>>>> +DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
> >>>>>>>>      static int pv_time_cpu_online(unsigned int cpu)
> >>>>>>>>      {
> >>>>>>>>             unsigned long flags;
> >>>>>>>> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigne=
d int cpu)
> >>>>>>>>
> >>>>>>>>             return 0;
> >>>>>>>>      }
> >>>>>>>> +
> >>>>>>>> +bool notrace vcpu_is_preempted(int cpu)
> >>>>>>>> +{
> >>>>>>>> +       struct kvm_steal_time *src;
> >>>>>>>> +
> >>>>>>>> +       if (!static_branch_unlikely(&virt_preempt_key))
> >>>>>>>> +               return false;
> >>>>>>>> +
> >>>>>>>> +       src =3D &per_cpu(steal_time, cpu);
> >>>>>>>> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
> >>>>>>>> +}
> >>>>>>>> +EXPORT_SYMBOL(vcpu_is_preempted);
> >>>>>>>>      #endif
> >>>>>>>>
> >>>>>>>>      static void pv_cpu_reboot(void *unused)
> >>>>>>>> @@ -308,6 +321,9 @@ int __init pv_time_init(void)
> >>>>>>>>                     pr_err("Failed to install cpu hotplug callba=
cks\n");
> >>>>>>>>                     return r;
> >>>>>>>>             }
> >>>>>>>> +
> >>>>>>>> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
> >>>>>>>> +               static_branch_enable(&virt_preempt_key);
> >>>>>>>>      #endif
> >>>>>>>>
> >>>>>>>>             static_call_update(pv_steal_clock, paravt_steal_cloc=
k);
> >>>>>>>> --
> >>>>>>>> 2.39.3
> >>>>>>>>
> >>>>>>
> >>>>>>
> >>>>
> >>>>
> >>
> >>
>
>

