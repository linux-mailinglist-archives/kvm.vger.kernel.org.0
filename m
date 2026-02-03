Return-Path: <kvm+bounces-69980-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPV8O129gWm7JAMAu9opvQ
	(envelope-from <kvm+bounces-69980-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 10:18:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 658A1D6B45
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 10:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 85BCA306D888
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 09:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5325223705;
	Tue,  3 Feb 2026 09:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Arj5qWJo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B09396D00
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 09:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770110261; cv=none; b=umO80FYqu6r2kOl1RUBSwMv2atRoJtXfKglr9iLsEgjDnLVsu9mbql8JYhLDUDLTWkJUDHmNm+nNuXgI5lonYGPbDYyxMRoGQTjBhi+1Hjqbj5gQdN2sgqYSy6AMPsW3z+dqlneQ6DF6LrV9A07MORa5eaEEHrrxfHvAQQgvGPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770110261; c=relaxed/simple;
	bh=mik66I7tLbwjOiZGXEXEppocsFMvgNbQI+ImA5LB5RE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EMWmRJZ7kB/5emMyJpuUCJmQuDsqbF7LZg1j0DLqJLvw6qcyuG9VfVljDEVma+dTar7iImR966yyDKaiwN18BQv112xH303klqttP+Q94Dx9W3ZRh3uWiciri310zARglaW4ZhHaPUUnUofrsYV9oZ27wYaWQSaAlCFHNp3GCvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Arj5qWJo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB6AC2BC86
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 09:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770110260;
	bh=mik66I7tLbwjOiZGXEXEppocsFMvgNbQI+ImA5LB5RE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Arj5qWJoJYBPsn5RCcksJe1KtEWU25H/KeqLWsqXKN2b0q/Y1QaqGhLHkvJNNyE3+
	 8le0D6J2gAA7cYcxxnoMNI9Wu9qg2qGFdp1OSmEOrCWa93aqFIQRhOuqHbrfxAQwXU
	 W/5qLzFN3JDnwmHzKaYmw96KrjygkjlEcFraaS6Osnw8Hh9Qx0S5NR+Q07/LPRjhwo
	 R2vVzn16xwb8LtJ13AjudyPga05WVmAeyF6zOyp4drJIwWnEy1ToyYRjywIhl+L6MV
	 n1Cx6hRCX4V8y/FtoWBuvMJlbE2DgYNqAkLaNU2kOWrWTahdEzavkOyYKiqTLKjdlC
	 XeAnLWj4IjkCw==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8837152db5so861577766b.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 01:17:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWgs8N+YBWG6CIvTlU3rPToBCZrVPGiYVhpNb0LNCzDh9ZGilwCvTJ3DQQrvltxLf/wD58=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJxmPyAHq1PTMcv5zBrZwkpOIEJnfwKy4W3y0uC5nxvSNQrPfn
	LTJT9yeuCQ2Z0e88kVcq5o0PAmCLJ7lmSC0N9ljdgdwmlpnWFPW0+4xkDPsUpnOtrtM5XF176Gy
	TTotB4UO6kpk/xelzwc8JsJNoLH+9ens=
X-Received: by 2002:a17:907:7212:b0:b73:9280:2e7 with SMTP id
 a640c23a62f3a-b8dff71f572mr942217966b.34.1770110259102; Tue, 03 Feb 2026
 01:17:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203033131.3372834-1-maobibo@loongson.cn> <20260203033131.3372834-5-maobibo@loongson.cn>
 <CAAhV-H7Y-m2wfV2YZ7J_nU0Zc198jroP6o8m0C+qSZ-8S79kwg@mail.gmail.com>
 <b9f311be-88f6-ffca-fc8e-70bec2cf7a75@loongson.cn> <CAAhV-H6v2oVe38HX7k_wvysUx4nyz6pbfUOU7wiaJO+1A3ASJw@mail.gmail.com>
 <03d39cc0-ed99-b32b-8678-575c646b6428@loongson.cn> <CAAhV-H5bz2dCGJbhGKMmgmmY8sgq4Ofex33+vRuQraKQRYC9mw@mail.gmail.com>
 <37a61461-bc15-39cf-61d0-3a908f25841f@loongson.cn>
In-Reply-To: <37a61461-bc15-39cf-61d0-3a908f25841f@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 3 Feb 2026 17:17:29 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5bs5E4pMbMaTX+AZ9UwmSB81q0ga+CjM+ivY4kWVp2eQ@mail.gmail.com>
X-Gm-Features: AZwV_QihaqAsZcppaN-xPOaiDY81xy4Fzx-3ML7VAK7CKNZCvABw_5cq_ZT1xN8
Message-ID: <CAAhV-H5bs5E4pMbMaTX+AZ9UwmSB81q0ga+CjM+ivY4kWVp2eQ@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69980-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 658A1D6B45
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 4:59=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2026/2/3 =E4=B8=8B=E5=8D=884:50, Huacai Chen wrote:
> > On Tue, Feb 3, 2026 at 3:51=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> w=
rote:
> >>
> >>
> >>
> >> On 2026/2/3 =E4=B8=8B=E5=8D=883:34, Huacai Chen wrote:
> >>> On Tue, Feb 3, 2026 at 2:48=E2=80=AFPM Bibo Mao <maobibo@loongson.cn>=
 wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2026/2/3 =E4=B8=8B=E5=8D=8812:15, Huacai Chen wrote:
> >>>>> Hi, Bibo,
> >>>>>
> >>>>> On Tue, Feb 3, 2026 at 11:31=E2=80=AFAM Bibo Mao <maobibo@loongson.=
cn> wrote:
> >>>>>>
> >>>>>> FPU is lazy enabled with KVM hypervisor. After FPU is enabled and
> >>>>>> loaded, vCPU can be preempted and FPU will be lost again, there wi=
ll
> >>>>>> be unnecessary FPU exception, load and store process. Here FPU is
> >>>>>> delay load until guest enter entry.
> >>>>> Calling LSX/LASX as FPU is a little strange, but somewhat reasonabl=
e.
> >>>>> Calling LBT as FPU is very strange. So I still like the V1 logic.
> >>>> yeap, LBT can use another different BIT and separate with FPU. It is
> >>>> actually normal use one bit + fpu type variant to represent differen=
t
> >>>> different FPU load requirement, such as
> >>>> TIF_FOREIGN_FPSTATE/TIF_NEED_FPU_LOAD on other architectures.
> >>>>
> >>>> I think it is better to put int fpu_load_type in structure loongarch=
_fpu.
> >>>>
> >>>> And there will be another optimization to avoid load FPU again if FP=
U HW
> >>>> is owned by current thread/vCPU, that will add last_cpu int type in
> >>>> structure loongarch_fpu also.
> >>>>
> >>>> Regards
> >>>> Bibo Mao
> >>>>>
> >>>>> If you insist on this version, please rename KVM_REQ_FPU_LOAD to
> >>>>> KVM_REQ_AUX_LOAD and rename fpu_load_type to aux_type, which is
> >>>>> similar to aux_inuse.
> >>> Then why not consider this?
> >> this can work now. However there is two different structure struct
> >> loongarch_fpu and struct loongarch_lbt.
> > Yes, but two structures don't block us from using KVM_REQ_AUX_LOAD and
> > aux_type to abstract both FPU and LBT, which is similar to aux_inuse.
> >>
> >> 1. If kernel wants to use late FPU load, new element fpu_load_type can
> >> be added in struct loongarch_fpu for both user app/KVM.
> where aux_type is put for kernel/kvm? Put it in thread structure with
> kernel late FPU load and vcpu.arch with KVM late FPU load?
aux_type is renamed from fpu_load_type, so where fpu_load_type is,
then where aux_type is.

> >>
> >> 2. With further optimization, FPU HW can own by user app/kernel/KVM,
> >> there will be another last_cpu int type added in struct loongarch_fpu.
> > Both loongarch_fpu and loongarch_lbt are register copies, so adding
> > fpu_load_type/last_cpu is not a good idea.
> If vCPU using FPU is preempted by kernel thread and kernel thread does
> not use FPU, HW FPU is the same with SW FPU state, HW FPU load can be
> skipped.
>
> BTW do you ever investigate FPU load/save process on other general
> architectures except MIPS?
I investigate nothing, including MIPS. Other architectures may give us
some inspiration, but that doesn't mean we should copy them, no matter
X86 or MIPS.

X86 introduced lazy fpu, then others also use lazy fpu; but now X86
have switched to eager fpu, others should also do the same?

On the other hand, when you use separate FPU/LSX/LASX, I only mention
the trace functions. Then you changed to centralized FPU/LSX/LASX/LBT.
Then I suggest you improve centralized FPU/LSX/LASX/LBT, you changed
to separate FPU/LBT again, where is the end?



Huacai
>
> Regards
> Bibo Mao
> >
> >
> > Huacai
> >>
> >> Regards
> >> Bibo Mao
> >>
> >> Regards
> >> Bibo Mao
> >>
> >>>
> >>> Huacai
> >>>
> >>>>>
> >>>>> Huacai
> >>>>>
> >>>>>>
> >>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>>>> ---
> >>>>>>     arch/loongarch/include/asm/kvm_host.h |  2 ++
> >>>>>>     arch/loongarch/kvm/exit.c             | 21 ++++++++++-----
> >>>>>>     arch/loongarch/kvm/vcpu.c             | 37 ++++++++++++++++++-=
--------
> >>>>>>     3 files changed, 41 insertions(+), 19 deletions(-)
> >>>>>>
> >>>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarc=
h/include/asm/kvm_host.h
> >>>>>> index e4fe5b8e8149..902ff7bc0e35 100644
> >>>>>> --- a/arch/loongarch/include/asm/kvm_host.h
> >>>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
> >>>>>> @@ -37,6 +37,7 @@
> >>>>>>     #define KVM_REQ_TLB_FLUSH_GPA          KVM_ARCH_REQ(0)
> >>>>>>     #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(1)
> >>>>>>     #define KVM_REQ_PMU                    KVM_ARCH_REQ(2)
> >>>>>> +#define KVM_REQ_FPU_LOAD               KVM_ARCH_REQ(3)
> >>>>>>
> >>>>>>     #define KVM_GUESTDBG_SW_BP_MASK                \
> >>>>>>            (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
> >>>>>> @@ -234,6 +235,7 @@ struct kvm_vcpu_arch {
> >>>>>>            u64 vpid;
> >>>>>>            gpa_t flush_gpa;
> >>>>>>
> >>>>>> +       int fpu_load_type;
> >>>>>>            /* Frequency of stable timer in Hz */
> >>>>>>            u64 timer_mhz;
> >>>>>>            ktime_t expire;
> >>>>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> >>>>>> index 65ec10a7245a..62403c7c6f9a 100644
> >>>>>> --- a/arch/loongarch/kvm/exit.c
> >>>>>> +++ b/arch/loongarch/kvm/exit.c
> >>>>>> @@ -754,7 +754,8 @@ static int kvm_handle_fpu_disabled(struct kvm_=
vcpu *vcpu, int ecode)
> >>>>>>                    return RESUME_HOST;
> >>>>>>            }
> >>>>>>
> >>>>>> -       kvm_own_fpu(vcpu);
> >>>>>> +       vcpu->arch.fpu_load_type =3D KVM_LARCH_FPU;
> >>>>>> +       kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >>>>>>
> >>>>>>            return RESUME_GUEST;
> >>>>>>     }
> >>>>>> @@ -794,8 +795,10 @@ static int kvm_handle_lsx_disabled(struct kvm=
_vcpu *vcpu, int ecode)
> >>>>>>     {
> >>>>>>            if (!kvm_guest_has_lsx(&vcpu->arch))
> >>>>>>                    kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >>>>>> -       else
> >>>>>> -               kvm_own_lsx(vcpu);
> >>>>>> +       else {
> >>>>>> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LSX;
> >>>>>> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >>>>>> +       }
> >>>>>>
> >>>>>>            return RESUME_GUEST;
> >>>>>>     }
> >>>>>> @@ -812,8 +815,10 @@ static int kvm_handle_lasx_disabled(struct kv=
m_vcpu *vcpu, int ecode)
> >>>>>>     {
> >>>>>>            if (!kvm_guest_has_lasx(&vcpu->arch))
> >>>>>>                    kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >>>>>> -       else
> >>>>>> -               kvm_own_lasx(vcpu);
> >>>>>> +       else {
> >>>>>> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LASX;
> >>>>>> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >>>>>> +       }
> >>>>>>
> >>>>>>            return RESUME_GUEST;
> >>>>>>     }
> >>>>>> @@ -822,8 +827,10 @@ static int kvm_handle_lbt_disabled(struct kvm=
_vcpu *vcpu, int ecode)
> >>>>>>     {
> >>>>>>            if (!kvm_guest_has_lbt(&vcpu->arch))
> >>>>>>                    kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >>>>>> -       else
> >>>>>> -               kvm_own_lbt(vcpu);
> >>>>>> +       else {
> >>>>>> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LBT;
> >>>>>> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >>>>>> +       }
> >>>>>>
> >>>>>>            return RESUME_GUEST;
> >>>>>>     }
> >>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >>>>>> index 995461d724b5..d05fe6c8f456 100644
> >>>>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>>>> @@ -232,6 +232,31 @@ static void kvm_late_check_requests(struct kv=
m_vcpu *vcpu)
> >>>>>>                            kvm_flush_tlb_gpa(vcpu, vcpu->arch.flus=
h_gpa);
> >>>>>>                            vcpu->arch.flush_gpa =3D INVALID_GPA;
> >>>>>>                    }
> >>>>>> +
> >>>>>> +       if (kvm_check_request(KVM_REQ_FPU_LOAD, vcpu)) {
> >>>>>> +               switch (vcpu->arch.fpu_load_type) {
> >>>>>> +               case KVM_LARCH_FPU:
> >>>>>> +                       kvm_own_fpu(vcpu);
> >>>>>> +                       break;
> >>>>>> +
> >>>>>> +               case KVM_LARCH_LSX:
> >>>>>> +                       kvm_own_lsx(vcpu);
> >>>>>> +                       break;
> >>>>>> +
> >>>>>> +               case KVM_LARCH_LASX:
> >>>>>> +                       kvm_own_lasx(vcpu);
> >>>>>> +                       break;
> >>>>>> +
> >>>>>> +               case KVM_LARCH_LBT:
> >>>>>> +                       kvm_own_lbt(vcpu);
> >>>>>> +                       break;
> >>>>>> +
> >>>>>> +               default:
> >>>>>> +                       break;
> >>>>>> +               }
> >>>>>> +
> >>>>>> +               vcpu->arch.fpu_load_type =3D 0;
> >>>>>> +       }
> >>>>>>     }
> >>>>>>
> >>>>>>     /*
> >>>>>> @@ -1286,13 +1311,11 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm=
_vcpu *vcpu, struct kvm_fpu *fpu)
> >>>>>>     #ifdef CONFIG_CPU_HAS_LBT
> >>>>>>     int kvm_own_lbt(struct kvm_vcpu *vcpu)
> >>>>>>     {
> >>>>>> -       preempt_disable();
> >>>>>>            if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
> >>>>>>                    set_csr_euen(CSR_EUEN_LBTEN);
> >>>>>>                    _restore_lbt(&vcpu->arch.lbt);
> >>>>>>                    vcpu->arch.aux_inuse |=3D KVM_LARCH_LBT;
> >>>>>>            }
> >>>>>> -       preempt_enable();
> >>>>>>
> >>>>>>            return 0;
> >>>>>>     }
> >>>>>> @@ -1335,8 +1358,6 @@ static inline void kvm_check_fcsr_alive(stru=
ct kvm_vcpu *vcpu) { }
> >>>>>>     /* Enable FPU and restore context */
> >>>>>>     void kvm_own_fpu(struct kvm_vcpu *vcpu)
> >>>>>>     {
> >>>>>> -       preempt_disable();
> >>>>>> -
> >>>>>>            /*
> >>>>>>             * Enable FPU for guest
> >>>>>>             * Set FR and FRE according to guest context
> >>>>>> @@ -1347,16 +1368,12 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
> >>>>>>            kvm_restore_fpu(&vcpu->arch.fpu);
> >>>>>>            vcpu->arch.aux_inuse |=3D KVM_LARCH_FPU;
> >>>>>>            trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AU=
X_FPU);
> >>>>>> -
> >>>>>> -       preempt_enable();
> >>>>>>     }
> >>>>>>
> >>>>>>     #ifdef CONFIG_CPU_HAS_LSX
> >>>>>>     /* Enable LSX and restore context */
> >>>>>>     int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>>>>>     {
> >>>>>> -       preempt_disable();
> >>>>>> -
> >>>>>>            /* Enable LSX for guest */
> >>>>>>            kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
> >>>>>>            set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
> >>>>>> @@ -1378,7 +1395,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>>>>>
> >>>>>>            trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AU=
X_LSX);
> >>>>>>            vcpu->arch.aux_inuse |=3D KVM_LARCH_LSX | KVM_LARCH_FPU=
;
> >>>>>> -       preempt_enable();
> >>>>>>
> >>>>>>            return 0;
> >>>>>>     }
> >>>>>> @@ -1388,8 +1404,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>>>>>     /* Enable LASX and restore context */
> >>>>>>     int kvm_own_lasx(struct kvm_vcpu *vcpu)
> >>>>>>     {
> >>>>>> -       preempt_disable();
> >>>>>> -
> >>>>>>            kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
> >>>>>>            set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_=
LASXEN);
> >>>>>>            switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LAR=
CH_LSX)) {
> >>>>>> @@ -1411,7 +1425,6 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
> >>>>>>
> >>>>>>            trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AU=
X_LASX);
> >>>>>>            vcpu->arch.aux_inuse |=3D KVM_LARCH_LASX | KVM_LARCH_LS=
X | KVM_LARCH_FPU;
> >>>>>> -       preempt_enable();
> >>>>>>
> >>>>>>            return 0;
> >>>>>>     }
> >>>>>> --
> >>>>>> 2.39.3
> >>>>>>
> >>>>>>
> >>>>
> >>>>
> >>
> >>
>
>

