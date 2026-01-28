Return-Path: <kvm+bounces-69323-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IE94J0OLeWlAxgEAu9opvQ
	(envelope-from <kvm+bounces-69323-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 05:06:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 279DB9CEBD
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 05:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 215D6301497B
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE67932ED34;
	Wed, 28 Jan 2026 04:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLqD+ONX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC522C11D3
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 04:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769573172; cv=none; b=ZbudS3uyG+wkjJuDr93qfv1KCQCM3aSjKiVYI3mw4+LbAD2ukkaj1BgcVghWAyRqOrxGMV6ZfsC+box6rjRJ1uXe5wn4vUtDdZ5x3mI2UR+oBkylI1QwwMN6VwElrG7F/4mDER3VmS2ExXwGM+07I5gxuDt4PGS17y6CDAuxbzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769573172; c=relaxed/simple;
	bh=Jee2D9iCBvosbR1f21JYZNDPCdYk9DoB0G+PsszVHRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QgyccAKUha9zNuJv3D8lG/ww1XRRatpS+7kqi7z/qkA0rQj5gqOHvkBaKByaLXI0FgxmBkVdE9bSZItktpK2i5iYwc3IPZ6PTXPXLrfdYuOPT2CTXBcRT6YoIfymV2EGIb8uy5fhe0tzDTcv6U5JW7X6pos0pYMoKV8AkB1UmlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLqD+ONX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBDBC4AF0B
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 04:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769573171;
	bh=Jee2D9iCBvosbR1f21JYZNDPCdYk9DoB0G+PsszVHRA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WLqD+ONXgvQ1P6zjfVTKUGyllGKuBEgT/rqqoXBUOmFyhZsv2jCtNhCV5I63HWvdU
	 R2o4X1RJ86Y+n8p/6NtcpGaIXIn+mDIcFYR0eA6ivYb/oF64XUB8FTWyxbEEOmv5JJ
	 NF1zf4qj3qFwJELDzKsxML/pNIwz/mMR4elX6cB/1QdxRBAPySeTdsmWWrcXSJXaC/
	 MFeOg2z3y8ytxprDNv9saZktoDWg+1nfHDm1w3z7Vb0ACnMURrKDRbZNEksHYjLY5h
	 EZ8X9LxcSEFqAXOyErU9aSzHY0wWpEL5qge9j1uRCPeHianT6h7tsXKO11cgPWh16C
	 UhEAkrMGzIZKQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b883787268fso997349366b.3
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 20:06:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV/wAOEpzCqTMAe+sYxgP4UG/Nsa1pvuuFZDkFNUhQEVxVGkuMmBAI7P3qh0lawOKmQyHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIOwbzYkOSwqMDBa3qCW0+ZgW8F06OmeZnTN+q1/nZd8ppO/1J
	zbfKNcxKdq6W/O5uyy9wviX8t/WnpUatE6benKfuf5iji+SbNfqqFLcZsLXRxdBoVyRxccAVIhE
	oS/0DhLC62PAqJfLoH61FeEQtZZRiQWk=
X-Received: by 2002:a17:907:3f8e:b0:b73:758c:c96f with SMTP id
 a640c23a62f3a-b8dab3a41e3mr288701866b.52.1769573170214; Tue, 27 Jan 2026
 20:06:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260127125124.3234252-1-maobibo@loongson.cn> <20260127125124.3234252-4-maobibo@loongson.cn>
In-Reply-To: <20260127125124.3234252-4-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 28 Jan 2026 12:05:58 +0800
X-Gmail-Original-Message-ID: <CAAhV-H69F2T-PbewFqch5Sp+xhBP9Lsy74C6yVhp90r4GSYEsQ@mail.gmail.com>
X-Gm-Features: AZwV_QiLxJOZ4sRU83JklmMPkehSxgGEm32B2FV1RXJ0mGkr_jbeql4K36rKgqU
Message-ID: <CAAhV-H69F2T-PbewFqch5Sp+xhBP9Lsy74C6yVhp90r4GSYEsQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] LoongArch: KVM: Add FPU delay load support
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69323-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 279DB9CEBD
X-Rspamd-Action: no action

Hi, Bibo,

On Tue, Jan 27, 2026 at 8:51=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> FPU is lazy enabled with KVM hypervisor. After FPU is enabled and
> loaded, vCPU can be preempted and FPU will be lost again. Here FPU
> is delay load until guest enter entry.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h |  2 ++
>  arch/loongarch/kvm/exit.c             | 15 ++++++++----
>  arch/loongarch/kvm/vcpu.c             | 33 +++++++++++++++++----------
>  3 files changed, 33 insertions(+), 17 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index e4fe5b8e8149..902ff7bc0e35 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -37,6 +37,7 @@
>  #define KVM_REQ_TLB_FLUSH_GPA          KVM_ARCH_REQ(0)
>  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(1)
>  #define KVM_REQ_PMU                    KVM_ARCH_REQ(2)
> +#define KVM_REQ_FPU_LOAD               KVM_ARCH_REQ(3)
>
>  #define KVM_GUESTDBG_SW_BP_MASK                \
>         (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
> @@ -234,6 +235,7 @@ struct kvm_vcpu_arch {
>         u64 vpid;
>         gpa_t flush_gpa;
>
> +       int fpu_load_type;
I think the logic of V1 is better, it doesn't increase the size of
kvm_vcpu_arch, and the constant checking is a little faster than
variable checking.

Huacai

>         /* Frequency of stable timer in Hz */
>         u64 timer_mhz;
>         ktime_t expire;
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 74b427287e96..b6f08df8fedb 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -754,7 +754,8 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *v=
cpu, int ecode)
>                 return RESUME_HOST;
>         }
>
> -       kvm_own_fpu(vcpu);
> +       vcpu->arch.fpu_load_type =3D KVM_LARCH_FPU;
> +       kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
>
>         return RESUME_GUEST;
>  }
> @@ -794,8 +795,10 @@ static int kvm_handle_lsx_disabled(struct kvm_vcpu *=
vcpu, int ecode)
>  {
>         if (!kvm_guest_has_lsx(&vcpu->arch))
>                 kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> -       else
> -               kvm_own_lsx(vcpu);
> +       else {
> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LSX;
> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> +       }
>
>         return RESUME_GUEST;
>  }
> @@ -812,8 +815,10 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu =
*vcpu, int ecode)
>  {
>         if (!kvm_guest_has_lasx(&vcpu->arch))
>                 kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> -       else
> -               kvm_own_lasx(vcpu);
> +       else {
> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LASX;
> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> +       }
>
>         return RESUME_GUEST;
>  }
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index d91a1160a309..3e749e9738b2 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -232,6 +232,27 @@ static void kvm_late_check_requests(struct kvm_vcpu =
*vcpu)
>                         kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa);
>                         vcpu->arch.flush_gpa =3D INVALID_GPA;
>                 }
> +
> +       if (kvm_check_request(KVM_REQ_FPU_LOAD, vcpu)) {
> +               switch (vcpu->arch.fpu_load_type) {
> +               case KVM_LARCH_FPU:
> +                       kvm_own_fpu(vcpu);
> +                       break;
> +
> +               case KVM_LARCH_LSX:
> +                       kvm_own_lsx(vcpu);
> +                       break;
> +
> +               case KVM_LARCH_LASX:
> +                       kvm_own_lasx(vcpu);
> +                       break;
> +
> +               default:
> +                       break;
> +               }
> +
> +               vcpu->arch.fpu_load_type =3D 0;
> +       }
>  }
>
>  /*
> @@ -1338,8 +1359,6 @@ static inline void kvm_check_fcsr_alive(struct kvm_=
vcpu *vcpu) { }
>  /* Enable FPU and restore context */
>  void kvm_own_fpu(struct kvm_vcpu *vcpu)
>  {
> -       preempt_disable();
> -
>         /*
>          * Enable FPU for guest
>          * Set FR and FRE according to guest context
> @@ -1350,16 +1369,12 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
>         kvm_restore_fpu(&vcpu->arch.fpu);
>         vcpu->arch.aux_inuse |=3D KVM_LARCH_FPU;
>         trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_FPU);
> -
> -       preempt_enable();
>  }
>
>  #ifdef CONFIG_CPU_HAS_LSX
>  /* Enable LSX and restore context */
>  int kvm_own_lsx(struct kvm_vcpu *vcpu)
>  {
> -       preempt_disable();
> -
>         /* Enable LSX for guest */
>         kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
>         set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
> @@ -1381,8 +1396,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
>
>         trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX);
>         vcpu->arch.aux_inuse |=3D KVM_LARCH_LSX | KVM_LARCH_FPU;
> -       preempt_enable();
> -
>         return 0;
>  }
>  #endif
> @@ -1391,8 +1404,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
>  /* Enable LASX and restore context */
>  int kvm_own_lasx(struct kvm_vcpu *vcpu)
>  {
> -       preempt_disable();
> -
>         kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
>         set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
>         switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
> @@ -1414,8 +1425,6 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
>
>         trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LASX);
>         vcpu->arch.aux_inuse |=3D KVM_LARCH_LASX | KVM_LARCH_LSX | KVM_LA=
RCH_FPU;
> -       preempt_enable();
> -
>         return 0;
>  }
>  #endif
> --
> 2.39.3
>
>

