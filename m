Return-Path: <kvm+bounces-65465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 01256CAA6A0
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 14:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C2E0319F943
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 13:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7AB2FAC0D;
	Sat,  6 Dec 2025 13:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkNFAMmA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AE62F3C27
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 13:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765026272; cv=none; b=Ea6aCk6CDWxMtVMj34iSL7Uw7zU9bEgWeLmhb8BeVURdX4ZsC3tjI5nT9jxtrWW6rrYydKbFgIwUQ/66gv2eMBOmRZ1Epd0b+rVkS6czPdjPwc31/Dij5cLRHfhc/11+CuCKxmJjNJ3h4o/+XfnnYyHJaolYgDfhKSNMuUZV/RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765026272; c=relaxed/simple;
	bh=f6w8GKLcyTB6JF9QFKvKWcWC3d4Y9g8k1COMmzuxYcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RrnFvXI+DPM5AytFsrlFENti/DeAxj04YF+WV0UdyNnct4Xh10otkAimpkCeIegQJ0lkws67p5yvgmnUy2TniNJ6ZTR6wxUI3jb3i0yF7PZFtJdXDsZ7Xm7xdga5EVALcKxQaaC8J45ryhHBnAKmPBV+JVYMnlMS+L0NUfm7GzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkNFAMmA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD41C2BC86
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 13:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765026271;
	bh=f6w8GKLcyTB6JF9QFKvKWcWC3d4Y9g8k1COMmzuxYcc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GkNFAMmAmDFQkYgcmRawvdZhNyjL9DnkCuwADtfZF77i+K7vCmI4lvi5mujvsWZv0
	 RTTMF5zPeUqNyhPq9WAjkAriUqjlGDXylVhzTqFXENceIMCU+zchUptSKJG/3c3sEA
	 aCpnx+fjcjpi0eJmjm2Ie9SYUJNrAUuPGcZLsvvMqNzulWGN4/1/CVsj9yt186PZCo
	 yiuQCD53KqjqYkHtXJagm6uBH2p98NWsDT/VKmrv85c30SLZD/zDZpOGx2FbWOnfkQ
	 Um2Gu7fNwgAzYPVAGlmurBmv3kU4dlimbjyEz9uuz7/YM1dEdzz9x8cgsRyVtKsr3q
	 VWvs9nwWRIQCw==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso6103501a12.0
        for <kvm@vger.kernel.org>; Sat, 06 Dec 2025 05:04:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWKKXV6tK5cRgZu/AO+DYmEGQALcCgCw7Vbe3dMadxlcnqWmVV8gfNHFpNs/zyX34R3YDU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZNWtQ+IvSb1B+wRHvIU76dLetWwRX0HpJrlsTTT83bFYJE3dq
	TF2jEHa73TewZHhkPbDlsi2fr6WCMH0v6tVMZ8kjTIa9uz45K+nxE/DhK9AV2chd3v3Qobr9qRU
	+dVfDTWmo2FKf+T6YfgUZOPuvqE1dbNU=
X-Google-Smtp-Source: AGHT+IEQmCCsR3G0nnHiXY3DaEBGBB7kS5YwzeI79lE6X/JIXgz+7IpcckU2qmbjqcUkWUBOjlx647jMBDEp5U1XgpI=
X-Received: by 2002:a05:6402:7c5:b0:643:130b:c615 with SMTP id
 4fb4d7f45d1cf-647a69f7c28mr6965230a12.6.1765026270188; Sat, 06 Dec 2025
 05:04:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251202024833.1714363-1-maobibo@loongson.cn> <20251202024833.1714363-3-maobibo@loongson.cn>
In-Reply-To: <20251202024833.1714363-3-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 6 Dec 2025 21:04:28 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6D_XxGTgWjzO26JtBcNeaouqrzH1wTaCn7xK3HGtZ55w@mail.gmail.com>
X-Gm-Features: AQt7F2p9K_N94AlOPCX3W_nmLtf-HTSyeJvn6fd8y1gDiTD0xesIvfAukaTi9wA
Message-ID: <CAAhV-H6D_XxGTgWjzO26JtBcNeaouqrzH1wTaCn7xK3HGtZ55w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] LoongArch: Add paravirt support with
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

Hi, Bibo,

On Tue, Dec 2, 2025 at 10:48=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Function vcpu_is_preempted() is used to check whether vCPU is preempted
> or not. Here add implementation with vcpu_is_preempted() when option
> CONFIG_PARAVIRT is enabled.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/qspinlock.h |  3 +++
>  arch/loongarch/kernel/paravirt.c       | 23 ++++++++++++++++++++++-
>  2 files changed, 25 insertions(+), 1 deletion(-)
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
> index b1b51f920b23..b61a93c6aec8 100644
> --- a/arch/loongarch/kernel/paravirt.c
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
>  }
>
>  #ifdef CONFIG_SMP
> +static DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
>  static int pv_time_cpu_online(unsigned int cpu)
>  {
>         unsigned long flags;
> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned int cpu=
)
>
>         return 0;
>  }
> +
> +bool notrace vcpu_is_preempted(int cpu)
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
> @@ -318,7 +334,12 @@ int __init pv_time_init(void)
>                 static_key_slow_inc(&paravirt_steal_rq_enabled);
>  #endif
>
> -       pr_info("Using paravirt steal-time\n");
> +#ifdef CONFIG_SMP

Linux kernel is removing non-SMP step by step [1].
https://kernelnewbies.org/Linux_6.17#Unconditionally_compile_task_scheduler=
_with_SMP_support

Though we cannot remove all "#ifdef CONFIG_SMP" at present, we can at
least stop adding more.

So I prefer to make this whole patch out of CONFIG_SMP. But if you
don't like this, you can at least move the virt_preempt_key
declaration out of "#ifdef CONFIG_SMP", then the #ifdefs here can be
removed.

Huacai

> +       if (static_key_enabled(&virt_preempt_key))
> +               pr_info("Using paravirt steal-time with preempt enabled\n=
");
> +       else
> +#endif
> +               pr_info("Using paravirt steal-time with preempt disabled\=
n");
>
>         return 0;
>  }
> --
> 2.39.3
>
>

