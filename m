Return-Path: <kvm+bounces-69544-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4IddMMRYe2mvEAIAu9opvQ
	(envelope-from <kvm+bounces-69544-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 13:55:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E0ED3B02E8
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 13:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 93F853002F70
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133DD388871;
	Thu, 29 Jan 2026 12:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HfDV6/fD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DE638759E
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 12:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769691326; cv=none; b=QeKGjxHNvdZWPAHmq0x0z2NIxkmbolWhNzcFamc5iol8eE8ZrMtd9vDQx6+uKl/PHPO9sSP0u+gVPLjkumbV+mVVt5TXEt7TLtAutN6UeLq3s6afGuS68CEOsxeAqfrY/nxr5dCW5OWQot+WdPDfBXhwwXYoXoO9pkMO27EDUfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769691326; c=relaxed/simple;
	bh=NqTaDHaD+pJvVAfH6kvcQ5hBCxxGl7SIeyGDhu1Vm3g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EAAQKnyQSFA7QToLTsH9dH3sdG+Pgf+6EkBC3kMeVTP7pcq556l1lxYf/BrfglKUa/4OsRMrOfn5U5tMq8bG8+hpd/gH6lwZwlqju6bspVBk7cUfMkLeER443ZofEdLUi8CTFdPg3xgFxzdUvnbw3kqpRuhcFfxRZVC+U/7H+UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HfDV6/fD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F6EC19421
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 12:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769691326;
	bh=NqTaDHaD+pJvVAfH6kvcQ5hBCxxGl7SIeyGDhu1Vm3g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HfDV6/fDtxee90qgtUI6N/2IDdeS4qHKj6HO/gyb226nZczlcj/6KOkexToeDyxXi
	 6lYW+VtnVzjGgFbp8SyMAy/coYX1/U5IEvOu+70MnqnNCJupJpOqfMRXKuSTqLL4/2
	 VseSwZyZgti7OqaG1/7bl9O92rUMh/H2FoukLPQ2gcbN0wpA6FV9IGVie2U3gN3Qp1
	 pPWf05o+kcyYUrDPBK6ehyqmrRT3BkTjlqo1rVGoBaOl7u/rAIcMwQIUVCRv1619s8
	 ucQ96n4ZEJOQtW8i5whGJiW68kteWYs2MXEQbQvHzfejTFfXEWeQY6n1jtDsaVE2Lv
	 F0YuBDuX2Y2LA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64d1ef53cf3so1211170a12.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 04:55:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUWYrSZdIDrmGCX4Z5uHno1tuO391mzMq44AIJFuQtghs3VN1qk7sVyDPXu3imWxgBi3Xs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWgZgNtKRw5CRj2EYq20zGvOywtTSryGrNTZ2zlx5zHEmhdX7h
	DPOwzsyrvMIU+p37ya4bhqicXFqmphnIqXPLBwZUHecpV3l7hnIwxgskVEyTi5jpiJG2aoddpVR
	fM/7Q+vMF3j1WF0zcKmvUaXK9DI11rKg=
X-Received: by 2002:a17:907:dab:b0:b87:33f3:6042 with SMTP id
 a640c23a62f3a-b8dab189e43mr533514266b.9.1769691324511; Thu, 29 Jan 2026
 04:55:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219063021.1778659-1-maobibo@loongson.cn> <20251219063021.1778659-3-maobibo@loongson.cn>
In-Reply-To: <20251219063021.1778659-3-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 29 Jan 2026 20:55:13 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7N1uXzK6Fu4x4Mrq4j1P95119HP87_spxU_E6WLxN6TQ@mail.gmail.com>
X-Gm-Features: AZwV_QglXnv0WaO0Gz68kxYYRi7EETfoxRPoCUkAA_CB9VyzX_vP5ZvRjFhDTTM
Message-ID: <CAAhV-H7N1uXzK6Fu4x4Mrq4j1P95119HP87_spxU_E6WLxN6TQ@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69544-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:email,mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Queue-Id: E0ED3B02E8
X-Rspamd-Action: no action

Hi, Bibo,

On Fri, Dec 19, 2025 at 2:30=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Function vcpu_is_preempted() is used to check whether vCPU is preempted
> or not. Here add implementation with vcpu_is_preempted() when option
> CONFIG_PARAVIRT is enabled.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> Acked-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/loongarch/include/asm/qspinlock.h |  3 +++
>  arch/loongarch/kernel/paravirt.c       | 21 ++++++++++++++++++++-
>  2 files changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/incl=
ude/asm/qspinlock.h
> index e76d3aa1e1eb..fa3eaf7e48f2 100644
> --- a/arch/loongarch/include/asm/qspinlock.h
> +++ b/arch/loongarch/include/asm/qspinlock.h
> @@ -34,6 +34,9 @@ static inline bool virt_spin_lock(struct qspinlock *loc=
k)
>         return true;
>  }
>
> +#define vcpu_is_preempted      vcpu_is_preempted
> +bool vcpu_is_preempted(int cpu);
> +
>  #endif /* CONFIG_PARAVIRT */
>
>  #include <asm-generic/qspinlock.h>
> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/par=
avirt.c
> index b1b51f920b23..a81a3e871dd1 100644
> --- a/arch/loongarch/kernel/paravirt.c
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -12,6 +12,7 @@ static int has_steal_clock;
>  struct static_key paravirt_steal_enabled;
>  struct static_key paravirt_steal_rq_enabled;
>  static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
> +static DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
>  DEFINE_STATIC_KEY_FALSE(virt_spin_lock_key);
>
>  static u64 native_steal_clock(int cpu)
> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned int cpu=
)
>
>         return 0;
>  }
> +
> +bool notrace vcpu_is_preempted(int cpu)
Is "notrace" really needed? Only S390 do this.

Huacai

> +{
> +       struct kvm_steal_time *src;
> +
> +       if (!static_branch_unlikely(&virt_preempt_key))
> +               return false;
> +
> +       src =3D &per_cpu(steal_time, cpu);
> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
> +}
> +EXPORT_SYMBOL(vcpu_is_preempted);
>  #endif
>
>  static void pv_cpu_reboot(void *unused)
> @@ -308,6 +321,9 @@ int __init pv_time_init(void)
>                 pr_err("Failed to install cpu hotplug callbacks\n");
>                 return r;
>         }
> +
> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
> +               static_branch_enable(&virt_preempt_key);
>  #endif
>
>         static_call_update(pv_steal_clock, paravt_steal_clock);
> @@ -318,7 +334,10 @@ int __init pv_time_init(void)
>                 static_key_slow_inc(&paravirt_steal_rq_enabled);
>  #endif
>
> -       pr_info("Using paravirt steal-time\n");
> +       if (static_key_enabled(&virt_preempt_key))
> +               pr_info("Using paravirt steal-time with preempt enabled\n=
");
> +       else
> +               pr_info("Using paravirt steal-time with preempt disabled\=
n");
>
>         return 0;
>  }
> --
> 2.39.3
>

