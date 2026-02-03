Return-Path: <kvm+bounces-69977-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UG0OBzm3gWkrJAMAu9opvQ
	(envelope-from <kvm+bounces-69977-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 09:52:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52CA1D6694
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 09:52:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E516930815AE
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 08:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1EB9396B6B;
	Tue,  3 Feb 2026 08:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQqG3Hhy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BAD395D8C
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 08:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770108648; cv=none; b=ucZLRrb9n/GAAbnpj9eIUVM3Xou3wP2hBmeorgYVKdOtd/ujGR+ELUC2jJCQLcRxmur3irQdpL4VYm0R7xs1UddqIESWvrXCf1rLpE82oOGdMQXWvqKjuKeSAdHPhJGRetVKtmY30+F24d+MZtrWXmAWc8lpHBv615NeK1t5Xso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770108648; c=relaxed/simple;
	bh=QZOy23QxYIEekc91dFMiNCLwuM//oDcy+DnGD1+RnnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NDiQN5qOMvvabeHmma2HlJq69TBBjEtJp4+DN3LcyMzoVNpTY3WFj568i6v/jLHsG4lXq8RAaovoK8Qpv5eTwvqMKrLCVVzxSOuSxjcBMfw/pwcFkV74vxCDfaH1fD6nKMx6KHo30h7zqgVS3y+BIr2hfZ/+z9M0hzUvNmcJks8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQqG3Hhy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C26C19425
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 08:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770108647;
	bh=QZOy23QxYIEekc91dFMiNCLwuM//oDcy+DnGD1+RnnU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XQqG3HhyQTbXJr6mjtlzesPqrZOw3aAGpgIdSESat3wxQvnFyh4cq+YKzt0qgcnTV
	 4sPd9TCGofy1bCcHax7t7eNThACoJho3XWCjGBa1ihwAHiEFfk0HnapoROP2+oKsFb
	 A8fUh3ae3dmuhxSlHvIbl24uX9BDRE4K1f39do21qiUhDqHTl0AaxVryMsrJtmhcOh
	 op95R6PR1rCfHQb5mMVsNZj+BodIck/cnJUUzfmHGOJsw5ExaBJ9i8QJBGStwqKAhH
	 QMHdBLFJQLV5I+svs0LbQqOEdhhKx6U4yXtUhb9/jL0IB+9VFw+aqLaQ1gFHSzK+yQ
	 TZyCOioQ5gYHA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b8715a4d9fdso621205666b.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 00:50:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVPvkY8aC1b4sFe4SfvqBRjN8f/ljuma+yiYNMLbaFMeXnf7TIykHaM8Kj0NcASFdgCKUQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxACG9+g1tpPeJ4MGrrlkhzvTkgyez1qeL/r+XwG+ZY7b7mqOyg
	LtYq80eknAhNYzxens9UALVYsiWuKQdJeVfR4jKekdXSIarGZu+emrs3fkEvxfAk9jN5P4I1DuP
	JPs52Il/bVV8GbqxzbM1pgOFkk9Tf4f0=
X-Received: by 2002:a17:907:96a8:b0:b76:b632:1123 with SMTP id
 a640c23a62f3a-b8dff7a3456mr990246866b.42.1770108646135; Tue, 03 Feb 2026
 00:50:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203033131.3372834-1-maobibo@loongson.cn> <20260203033131.3372834-5-maobibo@loongson.cn>
 <CAAhV-H7Y-m2wfV2YZ7J_nU0Zc198jroP6o8m0C+qSZ-8S79kwg@mail.gmail.com>
 <b9f311be-88f6-ffca-fc8e-70bec2cf7a75@loongson.cn> <CAAhV-H6v2oVe38HX7k_wvysUx4nyz6pbfUOU7wiaJO+1A3ASJw@mail.gmail.com>
 <03d39cc0-ed99-b32b-8678-575c646b6428@loongson.cn>
In-Reply-To: <03d39cc0-ed99-b32b-8678-575c646b6428@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 3 Feb 2026 16:50:36 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5bz2dCGJbhGKMmgmmY8sgq4Ofex33+vRuQraKQRYC9mw@mail.gmail.com>
X-Gm-Features: AZwV_Qj-VRo-usy8mFR5KRgiKiwHXZNmvzW3-rBVYotmZmudutwDg-LNV5qYfHw
Message-ID: <CAAhV-H5bz2dCGJbhGKMmgmmY8sgq4Ofex33+vRuQraKQRYC9mw@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69977-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 52CA1D6694
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 3:51=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2026/2/3 =E4=B8=8B=E5=8D=883:34, Huacai Chen wrote:
> > On Tue, Feb 3, 2026 at 2:48=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> w=
rote:
> >>
> >>
> >>
> >> On 2026/2/3 =E4=B8=8B=E5=8D=8812:15, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Tue, Feb 3, 2026 at 11:31=E2=80=AFAM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> FPU is lazy enabled with KVM hypervisor. After FPU is enabled and
> >>>> loaded, vCPU can be preempted and FPU will be lost again, there will
> >>>> be unnecessary FPU exception, load and store process. Here FPU is
> >>>> delay load until guest enter entry.
> >>> Calling LSX/LASX as FPU is a little strange, but somewhat reasonable.
> >>> Calling LBT as FPU is very strange. So I still like the V1 logic.
> >> yeap, LBT can use another different BIT and separate with FPU. It is
> >> actually normal use one bit + fpu type variant to represent different
> >> different FPU load requirement, such as
> >> TIF_FOREIGN_FPSTATE/TIF_NEED_FPU_LOAD on other architectures.
> >>
> >> I think it is better to put int fpu_load_type in structure loongarch_f=
pu.
> >>
> >> And there will be another optimization to avoid load FPU again if FPU =
HW
> >> is owned by current thread/vCPU, that will add last_cpu int type in
> >> structure loongarch_fpu also.
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>> If you insist on this version, please rename KVM_REQ_FPU_LOAD to
> >>> KVM_REQ_AUX_LOAD and rename fpu_load_type to aux_type, which is
> >>> similar to aux_inuse.
> > Then why not consider this?
> this can work now. However there is two different structure struct
> loongarch_fpu and struct loongarch_lbt.
Yes, but two structures don't block us from using KVM_REQ_AUX_LOAD and
aux_type to abstract both FPU and LBT, which is similar to aux_inuse.
>
> 1. If kernel wants to use late FPU load, new element fpu_load_type can
> be added in struct loongarch_fpu for both user app/KVM.
>
> 2. With further optimization, FPU HW can own by user app/kernel/KVM,
> there will be another last_cpu int type added in struct loongarch_fpu.
Both loongarch_fpu and loongarch_lbt are register copies, so adding
fpu_load_type/last_cpu is not a good idea.


Huacai
>
> Regards
> Bibo Mao
>
> Regards
> Bibo Mao
>
> >
> > Huacai
> >
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/include/asm/kvm_host.h |  2 ++
> >>>>    arch/loongarch/kvm/exit.c             | 21 ++++++++++-----
> >>>>    arch/loongarch/kvm/vcpu.c             | 37 ++++++++++++++++++----=
-----
> >>>>    3 files changed, 41 insertions(+), 19 deletions(-)
> >>>>
> >>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/=
include/asm/kvm_host.h
> >>>> index e4fe5b8e8149..902ff7bc0e35 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_host.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_host.h
> >>>> @@ -37,6 +37,7 @@
> >>>>    #define KVM_REQ_TLB_FLUSH_GPA          KVM_ARCH_REQ(0)
> >>>>    #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(1)
> >>>>    #define KVM_REQ_PMU                    KVM_ARCH_REQ(2)
> >>>> +#define KVM_REQ_FPU_LOAD               KVM_ARCH_REQ(3)
> >>>>
> >>>>    #define KVM_GUESTDBG_SW_BP_MASK                \
> >>>>           (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
> >>>> @@ -234,6 +235,7 @@ struct kvm_vcpu_arch {
> >>>>           u64 vpid;
> >>>>           gpa_t flush_gpa;
> >>>>
> >>>> +       int fpu_load_type;
> >>>>           /* Frequency of stable timer in Hz */
> >>>>           u64 timer_mhz;
> >>>>           ktime_t expire;
> >>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> >>>> index 65ec10a7245a..62403c7c6f9a 100644
> >>>> --- a/arch/loongarch/kvm/exit.c
> >>>> +++ b/arch/loongarch/kvm/exit.c
> >>>> @@ -754,7 +754,8 @@ static int kvm_handle_fpu_disabled(struct kvm_vc=
pu *vcpu, int ecode)
> >>>>                   return RESUME_HOST;
> >>>>           }
> >>>>
> >>>> -       kvm_own_fpu(vcpu);
> >>>> +       vcpu->arch.fpu_load_type =3D KVM_LARCH_FPU;
> >>>> +       kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >>>>
> >>>>           return RESUME_GUEST;
> >>>>    }
> >>>> @@ -794,8 +795,10 @@ static int kvm_handle_lsx_disabled(struct kvm_v=
cpu *vcpu, int ecode)
> >>>>    {
> >>>>           if (!kvm_guest_has_lsx(&vcpu->arch))
> >>>>                   kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >>>> -       else
> >>>> -               kvm_own_lsx(vcpu);
> >>>> +       else {
> >>>> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LSX;
> >>>> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >>>> +       }
> >>>>
> >>>>           return RESUME_GUEST;
> >>>>    }
> >>>> @@ -812,8 +815,10 @@ static int kvm_handle_lasx_disabled(struct kvm_=
vcpu *vcpu, int ecode)
> >>>>    {
> >>>>           if (!kvm_guest_has_lasx(&vcpu->arch))
> >>>>                   kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >>>> -       else
> >>>> -               kvm_own_lasx(vcpu);
> >>>> +       else {
> >>>> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LASX;
> >>>> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >>>> +       }
> >>>>
> >>>>           return RESUME_GUEST;
> >>>>    }
> >>>> @@ -822,8 +827,10 @@ static int kvm_handle_lbt_disabled(struct kvm_v=
cpu *vcpu, int ecode)
> >>>>    {
> >>>>           if (!kvm_guest_has_lbt(&vcpu->arch))
> >>>>                   kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >>>> -       else
> >>>> -               kvm_own_lbt(vcpu);
> >>>> +       else {
> >>>> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LBT;
> >>>> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >>>> +       }
> >>>>
> >>>>           return RESUME_GUEST;
> >>>>    }
> >>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >>>> index 995461d724b5..d05fe6c8f456 100644
> >>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>> @@ -232,6 +232,31 @@ static void kvm_late_check_requests(struct kvm_=
vcpu *vcpu)
> >>>>                           kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_g=
pa);
> >>>>                           vcpu->arch.flush_gpa =3D INVALID_GPA;
> >>>>                   }
> >>>> +
> >>>> +       if (kvm_check_request(KVM_REQ_FPU_LOAD, vcpu)) {
> >>>> +               switch (vcpu->arch.fpu_load_type) {
> >>>> +               case KVM_LARCH_FPU:
> >>>> +                       kvm_own_fpu(vcpu);
> >>>> +                       break;
> >>>> +
> >>>> +               case KVM_LARCH_LSX:
> >>>> +                       kvm_own_lsx(vcpu);
> >>>> +                       break;
> >>>> +
> >>>> +               case KVM_LARCH_LASX:
> >>>> +                       kvm_own_lasx(vcpu);
> >>>> +                       break;
> >>>> +
> >>>> +               case KVM_LARCH_LBT:
> >>>> +                       kvm_own_lbt(vcpu);
> >>>> +                       break;
> >>>> +
> >>>> +               default:
> >>>> +                       break;
> >>>> +               }
> >>>> +
> >>>> +               vcpu->arch.fpu_load_type =3D 0;
> >>>> +       }
> >>>>    }
> >>>>
> >>>>    /*
> >>>> @@ -1286,13 +1311,11 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_v=
cpu *vcpu, struct kvm_fpu *fpu)
> >>>>    #ifdef CONFIG_CPU_HAS_LBT
> >>>>    int kvm_own_lbt(struct kvm_vcpu *vcpu)
> >>>>    {
> >>>> -       preempt_disable();
> >>>>           if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
> >>>>                   set_csr_euen(CSR_EUEN_LBTEN);
> >>>>                   _restore_lbt(&vcpu->arch.lbt);
> >>>>                   vcpu->arch.aux_inuse |=3D KVM_LARCH_LBT;
> >>>>           }
> >>>> -       preempt_enable();
> >>>>
> >>>>           return 0;
> >>>>    }
> >>>> @@ -1335,8 +1358,6 @@ static inline void kvm_check_fcsr_alive(struct=
 kvm_vcpu *vcpu) { }
> >>>>    /* Enable FPU and restore context */
> >>>>    void kvm_own_fpu(struct kvm_vcpu *vcpu)
> >>>>    {
> >>>> -       preempt_disable();
> >>>> -
> >>>>           /*
> >>>>            * Enable FPU for guest
> >>>>            * Set FR and FRE according to guest context
> >>>> @@ -1347,16 +1368,12 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
> >>>>           kvm_restore_fpu(&vcpu->arch.fpu);
> >>>>           vcpu->arch.aux_inuse |=3D KVM_LARCH_FPU;
> >>>>           trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_F=
PU);
> >>>> -
> >>>> -       preempt_enable();
> >>>>    }
> >>>>
> >>>>    #ifdef CONFIG_CPU_HAS_LSX
> >>>>    /* Enable LSX and restore context */
> >>>>    int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>>>    {
> >>>> -       preempt_disable();
> >>>> -
> >>>>           /* Enable LSX for guest */
> >>>>           kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
> >>>>           set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
> >>>> @@ -1378,7 +1395,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>>>
> >>>>           trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_L=
SX);
> >>>>           vcpu->arch.aux_inuse |=3D KVM_LARCH_LSX | KVM_LARCH_FPU;
> >>>> -       preempt_enable();
> >>>>
> >>>>           return 0;
> >>>>    }
> >>>> @@ -1388,8 +1404,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>>>    /* Enable LASX and restore context */
> >>>>    int kvm_own_lasx(struct kvm_vcpu *vcpu)
> >>>>    {
> >>>> -       preempt_disable();
> >>>> -
> >>>>           kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
> >>>>           set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LAS=
XEN);
> >>>>           switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_=
LSX)) {
> >>>> @@ -1411,7 +1425,6 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
> >>>>
> >>>>           trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_L=
ASX);
> >>>>           vcpu->arch.aux_inuse |=3D KVM_LARCH_LASX | KVM_LARCH_LSX |=
 KVM_LARCH_FPU;
> >>>> -       preempt_enable();
> >>>>
> >>>>           return 0;
> >>>>    }
> >>>> --
> >>>> 2.39.3
> >>>>
> >>>>
> >>
> >>
>
>

