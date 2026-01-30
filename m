Return-Path: <kvm+bounces-69693-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gIMHMWiAfGlVNgIAu9opvQ
	(envelope-from <kvm+bounces-69693-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:56:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 256B4B919F
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:56:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0D5C3012E8F
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68879354AC0;
	Fri, 30 Jan 2026 09:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fr6APXSf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F87B2E9ED6
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 09:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769766988; cv=none; b=D0ll6EEJanBClFC/Fxm8x4NFXRmYdG0X2R1VhPjUd7HDnAY667S4zv6UMItirZ9Obvx9PuSKAQvnetKywCXkQRfkyuEu86SBQH3QgTDgu8MIuFtNhaTHV9mflu33rIvohIzmQXQLWClUwsD6CQfF/AyiyP1p4GBs0YqakQuYNPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769766988; c=relaxed/simple;
	bh=q1MGHcKNLKWY6WX1PfR4cD0oAkIYyEboz713lGUVThQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZCnSL06v4ft76378ApDePfiW9ZzR8ochSy3ggfzgkS3rqLFLt7bhHVYtw4/EVn9DG3M82zzw4ez3yDqYetOW02/J2xTvibrWXHNd6Oa09v5dVthe6MKcdrqbEGZqc/0ijdJfTyFtVSX96Yhf9Vp5U+fHAMpxC7osJIj645d+htw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fr6APXSf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77046C2BC86
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 09:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769766988;
	bh=q1MGHcKNLKWY6WX1PfR4cD0oAkIYyEboz713lGUVThQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fr6APXSfOB2dciWo76uVFKphtqqg6ZuZRJdh5pFM/xv2huEQDR+wCF27/B/Z9ii0q
	 aFO6cZQDDsBaVk9+izUW7pu4xkEV9MppZL0tC89ymrd1DM5clIuEDhkKqjqn4EPpH1
	 k2owqn1hLbJTvVFhOG03JYh57BRZ0AjU6cL0kZfBdhMq/h1Ags2JcGBXbpRfbCwPvN
	 xA6hv4aaj6ZaBcmWoWOrKT0eDb5I4sdCuYKe273w2r5eJUlZGsNoCGlYaWaxaOvhea
	 uUR7kz0dia/gouD64Fbtlfs1q2O1lSXV87kK0Xj3xtPOMqKFgCRDqVqQh2z9sj4CXs
	 pwlnzd1AZGnFQ==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-658078d6655so3962562a12.3
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 01:56:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU39yhGVLJ+RJUkt7SukfsFwu7OIHLABPGvADjrjczwo19MrkudwYHW0qgtzpwXO19J3Y8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yza1msM0aj9TkJeKfIQ2BPoVWruxZN3bQ66+1tjFwXCcpx4oMsA
	p/eYMe9kgEf9jJsdhlMh9X6T6+TdOLU8nFe40iC6lx0ilYgjXkVUypTfopbJdjwuuB5WZAM++Ei
	6H5eCSWWvrVDgoACnSPolnUh/oeww76Y=
X-Received: by 2002:a17:907:e989:b0:b87:12d2:fa1a with SMTP id
 a640c23a62f3a-b8dff528aaemr130589766b.12.1769766987032; Fri, 30 Jan 2026
 01:56:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219063021.1778659-1-maobibo@loongson.cn> <20251219063021.1778659-3-maobibo@loongson.cn>
 <CAAhV-H7N1uXzK6Fu4x4Mrq4j1P95119HP87_spxU_E6WLxN6TQ@mail.gmail.com> <f0d2671a-1ce7-d499-47cf-8dc9163f1e17@loongson.cn>
In-Reply-To: <f0d2671a-1ce7-d499-47cf-8dc9163f1e17@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 30 Jan 2026 17:56:16 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6mD1OxeVDaAXw_y6+1mHBwgGzS4OpsX4aezxV0SP8KLw@mail.gmail.com>
X-Gm-Features: AZwV_Qi-uT5-JW7WztFAIBiANsWfzC-6b6HYQshyEGcQjdI1rIYP6iNqEXV5ZgE
Message-ID: <CAAhV-H6mD1OxeVDaAXw_y6+1mHBwgGzS4OpsX4aezxV0SP8KLw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] LoongArch: Add paravirt support with
 vcpu_is_preempted() in guest side
To: Bibo Mao <maobibo@loongson.cn>
Cc: Juergen Gross <jgross@suse.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69693-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 256B4B919F
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 9:24=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2026/1/29 =E4=B8=8B=E5=8D=888:55, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Fri, Dec 19, 2025 at 2:30=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> Function vcpu_is_preempted() is used to check whether vCPU is preempte=
d
> >> or not. Here add implementation with vcpu_is_preempted() when option
> >> CONFIG_PARAVIRT is enabled.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> Acked-by: Juergen Gross <jgross@suse.com>
> >> ---
> >>   arch/loongarch/include/asm/qspinlock.h |  3 +++
> >>   arch/loongarch/kernel/paravirt.c       | 21 ++++++++++++++++++++-
> >>   2 files changed, 23 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/i=
nclude/asm/qspinlock.h
> >> index e76d3aa1e1eb..fa3eaf7e48f2 100644
> >> --- a/arch/loongarch/include/asm/qspinlock.h
> >> +++ b/arch/loongarch/include/asm/qspinlock.h
> >> @@ -34,6 +34,9 @@ static inline bool virt_spin_lock(struct qspinlock *=
lock)
> >>          return true;
> >>   }
> >>
> >> +#define vcpu_is_preempted      vcpu_is_preempted
> >> +bool vcpu_is_preempted(int cpu);
> >> +
> >>   #endif /* CONFIG_PARAVIRT */
> >>
> >>   #include <asm-generic/qspinlock.h>
> >> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/=
paravirt.c
> >> index b1b51f920b23..a81a3e871dd1 100644
> >> --- a/arch/loongarch/kernel/paravirt.c
> >> +++ b/arch/loongarch/kernel/paravirt.c
> >> @@ -12,6 +12,7 @@ static int has_steal_clock;
> >>   struct static_key paravirt_steal_enabled;
> >>   struct static_key paravirt_steal_rq_enabled;
> >>   static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(6=
4);
> >> +static DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
> >>   DEFINE_STATIC_KEY_FALSE(virt_spin_lock_key);
> >>
> >>   static u64 native_steal_clock(int cpu)
> >> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned int =
cpu)
> >>
> >>          return 0;
> >>   }
> >> +
> >> +bool notrace vcpu_is_preempted(int cpu)
> > Is "notrace" really needed? Only S390 do this.
>
> The prefix "notrace" is copied from S390, it is inline function on x86.
>
> Here is git log information with arch/s390/kernel/smp.c
> commit 8ebf6da9db1b2a20bb86cc1bee2552e894d03308
> Author: Philipp Rudo <prudo@linux.ibm.com>
> Date:   Mon Apr 6 20:47:48 2020
>
>      s390/ftrace: fix potential crashes when switching tracers
>
>      Switching tracers include instruction patching. To prevent that a
>      instruction is patched while it's read the instruction patching is d=
one
>      in stop_machine 'context'. This also means that any function called
>      during stop_machine must not be traced. Thus add 'notrace' to all
>      functions called within stop_machine.
>
>      Fixes: 1ec2772e0c3c ("s390/diag: add a statistic for diagnose calls"=
)
>      Fixes: 38f2c691a4b3 ("s390: improve wait logic of stop_machine")
>      Fixes: 4ecf0a43e729 ("processor: get rid of cpu_relax_yield")
>      Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
>      Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
>
> However I am not familiar with tracer and have no idea about this, that
> is both OK to me. You are Linux kernel expert, what is your opinion
> about notrace prefix?
It seems only S390 calls vcpu_is_preempted() in stop_machine(), and on
X86 both __kvm_vcpu_is_preempted() and __native_vcpu_is_preempted()
have no "notrace", so I applied this patch and drop "notrace".

Huacai

>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >> +{
> >> +       struct kvm_steal_time *src;
> >> +
> >> +       if (!static_branch_unlikely(&virt_preempt_key))
> >> +               return false;
> >> +
> >> +       src =3D &per_cpu(steal_time, cpu);
> >> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
> >> +}
> >> +EXPORT_SYMBOL(vcpu_is_preempted);
> >>   #endif
> >>
> >>   static void pv_cpu_reboot(void *unused)
> >> @@ -308,6 +321,9 @@ int __init pv_time_init(void)
> >>                  pr_err("Failed to install cpu hotplug callbacks\n");
> >>                  return r;
> >>          }
> >> +
> >> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
> >> +               static_branch_enable(&virt_preempt_key);
> >>   #endif
> >>
> >>          static_call_update(pv_steal_clock, paravt_steal_clock);
> >> @@ -318,7 +334,10 @@ int __init pv_time_init(void)
> >>                  static_key_slow_inc(&paravirt_steal_rq_enabled);
> >>   #endif
> >>
> >> -       pr_info("Using paravirt steal-time\n");
> >> +       if (static_key_enabled(&virt_preempt_key))
> >> +               pr_info("Using paravirt steal-time with preempt enable=
d\n");
> >> +       else
> >> +               pr_info("Using paravirt steal-time with preempt disabl=
ed\n");
> >>
> >>          return 0;
> >>   }
> >> --
> >> 2.39.3
> >>
>
>

