Return-Path: <kvm+bounces-69333-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2EDXChG9eWnoygEAu9opvQ
	(envelope-from <kvm+bounces-69333-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 08:38:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C79D9DCDF
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 08:38:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 506F93008449
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 07:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F47E2FFDFA;
	Wed, 28 Jan 2026 07:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXPqWOiV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525FE2E9759
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 07:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769585919; cv=none; b=Rw4uIF3kwXpWw8KWsYJW4faurMZawxZ4hDJec2urJzwPzQHjvo6uITFVpTlsf/hFgyYKOqM3Y0y03qukeR4WiW2INzluD+Ux0bHXet+5s6Z4OZVro7F0EER1zEE6Nmtof1IjNhK6ydzbV151UD9uLjsK1yj9sFgAc3hf6/51seo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769585919; c=relaxed/simple;
	bh=Mzp9wMskEJoYx+SCw1f62NEMWhMKWaBnd1C+k1e26gg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pLqYbIebl6TaaxO1G96FZIq5wmRXghJ5rXnGm425n2RFInWtJaDM6nSkWTbi3hZ/m8Del7lnfPASU4ywpcr/PVpwRq5RXsLsoC7kiZSeLBj8rMeV8uS3JaWj7AZVq8bZgQYlRjfBBcFVxIKwbOBubIjO3BuGN8G4WVQ4+3QvJ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXPqWOiV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368A4C16AAE
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 07:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769585919;
	bh=Mzp9wMskEJoYx+SCw1f62NEMWhMKWaBnd1C+k1e26gg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GXPqWOiVRU25Bg9mnHI7uVSFxNBa/HtSnFROzhl0unyL8mwoAsVfL1IbWdNOcib7x
	 31j7sLXr9efkdZ4Smd5LsK+Wp1df9pAdm6pc6I8YZ5YYS85ltuNlQXvTOIlgC78gEi
	 rKD8Gzj04G0tMZtHHcuZFMtyVzER9li/5rPT9gf1rCKbedFzeVR8US3gjzsRXMXyNn
	 bd2ABDBoyYOf+6GqHGQPKjKIujwVvPYPH32MTUT78ghWKIwlMymF/LQEGy0qP5tAjL
	 d1sEjXZk9fED3A5pNrp2MvDHJyoj3NJQ8cceHs8qoiDnu03sjchH0rO6ujoq7aRYXL
	 4PTw92C7KNkfA==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b8838339fc6so131224966b.0
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 23:38:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXQThLOMiLXUFcQO6Xs/c4vK4r8uQsDIKuVrhvugcGimLME8ReWBTLjb8yfRiox49yGnQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGVsLUy5Qycdzn+XCP2RI1AA1KswT9My6gvb8eFNH07aNxD8ns
	ZV4qo2w7575F33EIQGQt67Gq1iAjjPeiZoYNKtI2Gz8OYH5cZHN8RymoYvc8P9Q+BUQ20b4180m
	9AQtx9jGEWroiQQuXuW78M3n54yBhZ4g=
X-Received: by 2002:a17:907:3f8c:b0:b88:4f25:81da with SMTP id
 a640c23a62f3a-b8dac636e70mr368718566b.0.1769585917717; Tue, 27 Jan 2026
 23:38:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260127125124.3234252-1-maobibo@loongson.cn> <20260127125124.3234252-4-maobibo@loongson.cn>
 <CAAhV-H69F2T-PbewFqch5Sp+xhBP9Lsy74C6yVhp90r4GSYEsQ@mail.gmail.com> <67db8a93-eb62-7278-ae3f-a46a62365b20@loongson.cn>
In-Reply-To: <67db8a93-eb62-7278-ae3f-a46a62365b20@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 28 Jan 2026 15:38:26 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5T6kHyYigy3P92Az1mum_vKf8Kd3e-hNGT5k_VZ+pF_Q@mail.gmail.com>
X-Gm-Features: AZwV_QgVLaf7Ini1fLCztktYs0KCBuhslxP7X0Vu-NPNGyhsCI4qpN0GfPcNLTQ
Message-ID: <CAAhV-H5T6kHyYigy3P92Az1mum_vKf8Kd3e-hNGT5k_VZ+pF_Q@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69333-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4C79D9DCDF
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 2:35=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2026/1/28 =E4=B8=8B=E5=8D=8812:05, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Tue, Jan 27, 2026 at 8:51=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> FPU is lazy enabled with KVM hypervisor. After FPU is enabled and
> >> loaded, vCPU can be preempted and FPU will be lost again. Here FPU
> >> is delay load until guest enter entry.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/kvm_host.h |  2 ++
> >>   arch/loongarch/kvm/exit.c             | 15 ++++++++----
> >>   arch/loongarch/kvm/vcpu.c             | 33 +++++++++++++++++--------=
--
> >>   3 files changed, 33 insertions(+), 17 deletions(-)
> >>
> >> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/in=
clude/asm/kvm_host.h
> >> index e4fe5b8e8149..902ff7bc0e35 100644
> >> --- a/arch/loongarch/include/asm/kvm_host.h
> >> +++ b/arch/loongarch/include/asm/kvm_host.h
> >> @@ -37,6 +37,7 @@
> >>   #define KVM_REQ_TLB_FLUSH_GPA          KVM_ARCH_REQ(0)
> >>   #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(1)
> >>   #define KVM_REQ_PMU                    KVM_ARCH_REQ(2)
> >> +#define KVM_REQ_FPU_LOAD               KVM_ARCH_REQ(3)
> >>
> >>   #define KVM_GUESTDBG_SW_BP_MASK                \
> >>          (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
> >> @@ -234,6 +235,7 @@ struct kvm_vcpu_arch {
> >>          u64 vpid;
> >>          gpa_t flush_gpa;
> >>
> >> +       int fpu_load_type;
> > I think the logic of V1 is better, it doesn't increase the size of
> > kvm_vcpu_arch, and the constant checking is a little faster than
> > variable checking.
> The main reason is that FPU_LOAD request is not so frequent, there is
> atomic instruction in kvm_check_request() and the unconditional
> kvm_check_request() may be unnecessary, also there will LBT LOAD check
> in later version.
>
> So I think one unconditional atomic test_and_clear may be better than
> three/four atomic test_and_clear.
>      kvm_check_request(KVM_REQ_FPU_LOAD,vcpu)
>      kvm_check_request(KVM_REQ_FPU_LSX, vcpu)
>      kvm_check_request(KVM_REQ_FPU_LASX, vcpu)
>
> Actually different people have different view about this :)
Depends on how complex kvm_check_request() is. If it is very complex,
checking once and following a switch-case is better.

Huacai

>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >>          /* Frequency of stable timer in Hz */
> >>          u64 timer_mhz;
> >>          ktime_t expire;
> >> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> >> index 74b427287e96..b6f08df8fedb 100644
> >> --- a/arch/loongarch/kvm/exit.c
> >> +++ b/arch/loongarch/kvm/exit.c
> >> @@ -754,7 +754,8 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu=
 *vcpu, int ecode)
> >>                  return RESUME_HOST;
> >>          }
> >>
> >> -       kvm_own_fpu(vcpu);
> >> +       vcpu->arch.fpu_load_type =3D KVM_LARCH_FPU;
> >> +       kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >>
> >>          return RESUME_GUEST;
> >>   }
> >> @@ -794,8 +795,10 @@ static int kvm_handle_lsx_disabled(struct kvm_vcp=
u *vcpu, int ecode)
> >>   {
> >>          if (!kvm_guest_has_lsx(&vcpu->arch))
> >>                  kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >> -       else
> >> -               kvm_own_lsx(vcpu);
> >> +       else {
> >> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LSX;
> >> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >> +       }
> >>
> >>          return RESUME_GUEST;
> >>   }
> >> @@ -812,8 +815,10 @@ static int kvm_handle_lasx_disabled(struct kvm_vc=
pu *vcpu, int ecode)
> >>   {
> >>          if (!kvm_guest_has_lasx(&vcpu->arch))
> >>                  kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >> -       else
> >> -               kvm_own_lasx(vcpu);
> >> +       else {
> >> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LASX;
> >> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >> +       }
> >>
> >>          return RESUME_GUEST;
> >>   }
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index d91a1160a309..3e749e9738b2 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -232,6 +232,27 @@ static void kvm_late_check_requests(struct kvm_vc=
pu *vcpu)
> >>                          kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa)=
;
> >>                          vcpu->arch.flush_gpa =3D INVALID_GPA;
> >>                  }
> >> +
> >> +       if (kvm_check_request(KVM_REQ_FPU_LOAD, vcpu)) {
> >> +               switch (vcpu->arch.fpu_load_type) {
> >> +               case KVM_LARCH_FPU:
> >> +                       kvm_own_fpu(vcpu);
> >> +                       break;
> >> +
> >> +               case KVM_LARCH_LSX:
> >> +                       kvm_own_lsx(vcpu);
> >> +                       break;
> >> +
> >> +               case KVM_LARCH_LASX:
> >> +                       kvm_own_lasx(vcpu);
> >> +                       break;
> >> +
> >> +               default:
> >> +                       break;
> >> +               }
> >> +
> >> +               vcpu->arch.fpu_load_type =3D 0;
> >> +       }
> >>   }
> >>
> >>   /*
> >> @@ -1338,8 +1359,6 @@ static inline void kvm_check_fcsr_alive(struct k=
vm_vcpu *vcpu) { }
> >>   /* Enable FPU and restore context */
> >>   void kvm_own_fpu(struct kvm_vcpu *vcpu)
> >>   {
> >> -       preempt_disable();
> >> -
> >>          /*
> >>           * Enable FPU for guest
> >>           * Set FR and FRE according to guest context
> >> @@ -1350,16 +1369,12 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
> >>          kvm_restore_fpu(&vcpu->arch.fpu);
> >>          vcpu->arch.aux_inuse |=3D KVM_LARCH_FPU;
> >>          trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_FPU)=
;
> >> -
> >> -       preempt_enable();
> >>   }
> >>
> >>   #ifdef CONFIG_CPU_HAS_LSX
> >>   /* Enable LSX and restore context */
> >>   int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>   {
> >> -       preempt_disable();
> >> -
> >>          /* Enable LSX for guest */
> >>          kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
> >>          set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
> >> @@ -1381,8 +1396,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>
> >>          trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX)=
;
> >>          vcpu->arch.aux_inuse |=3D KVM_LARCH_LSX | KVM_LARCH_FPU;
> >> -       preempt_enable();
> >> -
> >>          return 0;
> >>   }
> >>   #endif
> >> @@ -1391,8 +1404,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>   /* Enable LASX and restore context */
> >>   int kvm_own_lasx(struct kvm_vcpu *vcpu)
> >>   {
> >> -       preempt_disable();
> >> -
> >>          kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
> >>          set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN=
);
> >>          switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX=
)) {
> >> @@ -1414,8 +1425,6 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
> >>
> >>          trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LASX=
);
> >>          vcpu->arch.aux_inuse |=3D KVM_LARCH_LASX | KVM_LARCH_LSX | KV=
M_LARCH_FPU;
> >> -       preempt_enable();
> >> -
> >>          return 0;
> >>   }
> >>   #endif
> >> --
> >> 2.39.3
> >>
> >>
>

