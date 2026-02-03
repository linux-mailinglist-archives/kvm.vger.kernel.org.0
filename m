Return-Path: <kvm+bounces-69972-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QNgLO6h2gWkYGgMAu9opvQ
	(envelope-from <kvm+bounces-69972-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 05:16:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 527D5D45E1
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 05:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70B96303C29F
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 04:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE5C2580F3;
	Tue,  3 Feb 2026 04:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qeCtC6vr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1A118AFD
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 04:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770092125; cv=none; b=LhR5P8wbhc7TOP3mmz4k2wTZ1Fmg3pnp7ijtsrtwiRAIwDbHDgrOIqwi8BvoIwWzwhkGeqH8uzkA7z8ydu8rBbzmHCUa5Firw4xdY2hzIaho2gugG5zjYb/LlqcgXRPHFnwSnno5x3mr4c1iLGh8P9dWv3Pbj+oapreJghzQ3xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770092125; c=relaxed/simple;
	bh=guvltzg1l3zjJVBgKvT/Kx33A5vXt4tjb4uuEuMzpVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tnwH6tuTHgDc8iI9KHctgZ0SsBhsyKnRYK6L/KqSpZ6R57qarkvSn4py+AsZ2Oz85YETIG7QHC9T4CkbFvpwiFvUIGsNzRWPEkVVRK9Y0Ai27hBRxl8Nz2H2y2syeyDOrXamzQzhE38H8PI7KvrBrsNhahLExWuM50+No+4tmQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qeCtC6vr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07204C19425
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 04:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770092125;
	bh=guvltzg1l3zjJVBgKvT/Kx33A5vXt4tjb4uuEuMzpVU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qeCtC6vrqPG8zuHenUZX+BSSqg5QAcXQMyjml0DEVcvZUOxJ3YTymDVohBoDz4M86
	 5NqCn8vVaCzwZ+vhB1L/f7wNHx/FJOuS4bkXoXlA7puW2BYxcfJEVqt5KbuHhxQSnb
	 FLCCnrfLV1+bgbpQos78pLMwAACZVSgxYOIRZyWzRugVy2UnurcGV6Hrl4UhZCv9I0
	 qQdKhtXknqKKq5tydQ1Fz/Gi1mLQriKfeCtsiPQszFZNYz2e4TIYnKohDBEWfnApC2
	 1vpDYjf1KQS8IZMHK2iZ3VhHBAOkmpCCMryy+4sfF2ajsTUIsrPSC+bDGIPy3IOm6S
	 NVu95l1fUPshA==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8863db032dso876170566b.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 20:15:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWknT8LyCtjnNllP54eB5+LU29d3d1Q8k/PWuLtVF94eZKpwEl3zTYE4fSseAES/zTBvLo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrbnvtRF7hs6Qqzi1SB0gMsc7hEwimHwnxMJ6TfbcJ+NOHBo6V
	xy3I901D1AiGeVhxsZ6lIbLK9mwL1duM9CZNvfNWX2nT9c+CNJnoImzGBJ3D/B/pmTOnUVqx21R
	WIOsgOeMX+2WyBEPHYT36QxU6FUv/mgw=
X-Received: by 2002:a17:906:99c2:b0:b87:711f:97b9 with SMTP id
 a640c23a62f3a-b8dff739531mr940441766b.31.1770092123521; Mon, 02 Feb 2026
 20:15:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203033131.3372834-1-maobibo@loongson.cn> <20260203033131.3372834-5-maobibo@loongson.cn>
In-Reply-To: <20260203033131.3372834-5-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 3 Feb 2026 12:15:14 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7Y-m2wfV2YZ7J_nU0Zc198jroP6o8m0C+qSZ-8S79kwg@mail.gmail.com>
X-Gm-Features: AZwV_QhV5SagLyS2un7s1aDpWm1Us8Ees-sCmL2sDtlxMuYxz0hRr4KpVhp0xvg
Message-ID: <CAAhV-H7Y-m2wfV2YZ7J_nU0Zc198jroP6o8m0C+qSZ-8S79kwg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] LoongArch: KVM: Add FPU delay load support
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-69972-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 527D5D45E1
X-Rspamd-Action: no action

Hi, Bibo,

On Tue, Feb 3, 2026 at 11:31=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> FPU is lazy enabled with KVM hypervisor. After FPU is enabled and
> loaded, vCPU can be preempted and FPU will be lost again, there will
> be unnecessary FPU exception, load and store process. Here FPU is
> delay load until guest enter entry.
Calling LSX/LASX as FPU is a little strange, but somewhat reasonable.
Calling LBT as FPU is very strange. So I still like the V1 logic.

If you insist on this version, please rename KVM_REQ_FPU_LOAD to
KVM_REQ_AUX_LOAD and rename fpu_load_type to aux_type, which is
similar to aux_inuse.

Huacai

>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h |  2 ++
>  arch/loongarch/kvm/exit.c             | 21 ++++++++++-----
>  arch/loongarch/kvm/vcpu.c             | 37 ++++++++++++++++++---------
>  3 files changed, 41 insertions(+), 19 deletions(-)
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
>         /* Frequency of stable timer in Hz */
>         u64 timer_mhz;
>         ktime_t expire;
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 65ec10a7245a..62403c7c6f9a 100644
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
> @@ -822,8 +827,10 @@ static int kvm_handle_lbt_disabled(struct kvm_vcpu *=
vcpu, int ecode)
>  {
>         if (!kvm_guest_has_lbt(&vcpu->arch))
>                 kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> -       else
> -               kvm_own_lbt(vcpu);
> +       else {
> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LBT;
> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> +       }
>
>         return RESUME_GUEST;
>  }
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 995461d724b5..d05fe6c8f456 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -232,6 +232,31 @@ static void kvm_late_check_requests(struct kvm_vcpu =
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
> +               case KVM_LARCH_LBT:
> +                       kvm_own_lbt(vcpu);
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
> @@ -1286,13 +1311,11 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *=
vcpu, struct kvm_fpu *fpu)
>  #ifdef CONFIG_CPU_HAS_LBT
>  int kvm_own_lbt(struct kvm_vcpu *vcpu)
>  {
> -       preempt_disable();
>         if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
>                 set_csr_euen(CSR_EUEN_LBTEN);
>                 _restore_lbt(&vcpu->arch.lbt);
>                 vcpu->arch.aux_inuse |=3D KVM_LARCH_LBT;
>         }
> -       preempt_enable();
>
>         return 0;
>  }
> @@ -1335,8 +1358,6 @@ static inline void kvm_check_fcsr_alive(struct kvm_=
vcpu *vcpu) { }
>  /* Enable FPU and restore context */
>  void kvm_own_fpu(struct kvm_vcpu *vcpu)
>  {
> -       preempt_disable();
> -
>         /*
>          * Enable FPU for guest
>          * Set FR and FRE according to guest context
> @@ -1347,16 +1368,12 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
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
> @@ -1378,7 +1395,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
>
>         trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX);
>         vcpu->arch.aux_inuse |=3D KVM_LARCH_LSX | KVM_LARCH_FPU;
> -       preempt_enable();
>
>         return 0;
>  }
> @@ -1388,8 +1404,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
>  /* Enable LASX and restore context */
>  int kvm_own_lasx(struct kvm_vcpu *vcpu)
>  {
> -       preempt_disable();
> -
>         kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
>         set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
>         switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
> @@ -1411,7 +1425,6 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
>
>         trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LASX);
>         vcpu->arch.aux_inuse |=3D KVM_LARCH_LASX | KVM_LARCH_LSX | KVM_LA=
RCH_FPU;
> -       preempt_enable();
>
>         return 0;
>  }
> --
> 2.39.3
>
>

