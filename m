Return-Path: <kvm+bounces-72257-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eJVLFQ87omk71AQAu9opvQ
	(envelope-from <kvm+bounces-72257-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:47:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1ABB1BF7C8
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1DAF23008CA2
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C034719D8A8;
	Sat, 28 Feb 2026 00:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZAOemLA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE9D1AE877
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 00:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772239622; cv=none; b=mR1/I+EpczmWZTWc8End/PjQ4ttGK8DQJ01WjDs9nPB6tMALZJApzCr+3+dBTgWukUYq46OlmJi8YNW0CTLsek+R9JmRIiGRpGwRj33ggTtz6NXiJNQ66TYH6CF2l6Bg6E22vG1+t8BkY2pi8mDI3Zx8rNMoqhc7BbeTzPqoz8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772239622; c=relaxed/simple;
	bh=fdo6TPmuGcNdCa9dePZZk6EZTcMkP9umdD92dv0c71k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rVa6zSPydeHTu4r8v1LYvgrtrghcWh1LAvwj2aO7nIGcQqinJgyjFMkkkDoQCXE+9pg5J9lbDv9cSwKPRYrPk4ro5hChds74zQrKhuszvKWVlMRPimukqXm0jhx8k+JK4LT5NmKjIQknCvh1t+3EzTdXfBy5XOwmz96heMQU6Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZAOemLA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7185C2BC86
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 00:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772239621;
	bh=fdo6TPmuGcNdCa9dePZZk6EZTcMkP9umdD92dv0c71k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GZAOemLArlZoxB6eaYpOQg5uWLLwxOGXFiHXcYHm41lgmuC9lCi5Aq5RjTpTuHmVY
	 F0CvNGduEY7maJzyXnmfeLcDJUd/vJ+kERKZulaWu9lp8dBkaiUZEmbiEmzme/R6EW
	 tKvgubpPyixTOEiCynPq9v2q+pjKFzpcty38whbYTy7YwdHMGkFFmk2InPUOSFnCty
	 x6lGsqBpEBkrPU//pUmuUk8uo3xmYnQFcTge76XdXRQznu+d/i+FtubOohWC5q9Guk
	 07uoY2dZqvu58tnQvZsgIGAIpg9E8g0IabVBfej6k0Lb2Tx8FkdQMdLvY8ATt5zHa3
	 3oPuDFnvfYI4Q==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b935ff845c8so311822966b.2
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:47:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXSm4OeMGkvrrYzAt1jXBqk+d1Gc5vWuLFf+Fy+n5KFA22ijNCaXfPE/b4W4IY5Qj6iDOs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywug3pogvgrFwzESV0semSzuFa1NSrPZMR9zYYRzyjXD0+HEdZ0
	UItI9pJ0Mu9TVXOzgao1vPv5Wjq6+vYgxJbU+tLNUKq5ZdogF8jA/77jv0Nko66lC3PD57/l3Fw
	d+8QWqab9Xh2QNGZzNxhdlHyiczTvDMg=
X-Received: by 2002:a17:907:803:b0:b8a:f7fb:4f4d with SMTP id
 a640c23a62f3a-b9376385917mr270101666b.16.1772239620487; Fri, 27 Feb 2026
 16:47:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org> <20260224223405.3270433-17-yosry@kernel.org>
 <aaIxtBYRNCHdEvsV@google.com>
In-Reply-To: <aaIxtBYRNCHdEvsV@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 27 Feb 2026 16:46:49 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMRkFfxm_zs88uc_ijARrU4XxHQQZAQFmC_t0H9qdbM-A@mail.gmail.com>
X-Gm-Features: AaiRm533CyEX4TQbd1-6amDST_Vrw0ZT1a5h-AyrGEPbqLiGyLqIW3fupTgKFLo
Message-ID: <CAO9r8zMRkFfxm_zs88uc_ijARrU4XxHQQZAQFmC_t0H9qdbM-A@mail.gmail.com>
Subject: Re: [PATCH v6 16/31] KVM: nSVM: Unify handling of VMRUN failures with
 proper cleanup
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-72257-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: C1ABB1BF7C8
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 4:07=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Feb 24, 2026, Yosry Ahmed wrote:
> > There are currently two possible causes of VMRUN failures emulated by
> > KVM:
> >
> > 1) Consistency checks failures. In this case, KVM updates the exit code
> >    in the mapped VMCB12 and exits early in nested_svm_vmrun(). This
> >    causes a few problems:
> >
> >   A) KVM does not clear the GIF if the early consistency checks fail
> >      (because nested_svm_vmexit() is not called). Nothing requires
> >      GIF=3D0 before a VMRUN, from the APM:
> >
> >       It is assumed that VMM software cleared GIF some time before
> >       executing the VMRUN instruction, to ensure an atomic state
> >       switch.
> >
> >      So an early #VMEXIT from early consistency checks could leave the
> >      GIF set.
> >
> >   B) svm_leave_smm() is missing consistency checks on the newly loaded
> >      guest state, because the checks aren't performed by
> >      enter_svm_guest_mode().
>
> This is flat out wrong.  RSM isn't missing any consistency checks that ar=
e
> provided by nested_vmcb_check_save().
>
>         if (CC(!(save->efer & EFER_SVME)))                               =
     <=3D=3D=3D irrelevant given KVM's implementation
>                 return false;
>
>         if (CC((save->cr0 & X86_CR0_CD) =3D=3D 0 && (save->cr0 & X86_CR0_=
NW)) ||  <=3D=3D kvm_set_cr0() in rsm_enter_protected_mode()
>             CC(save->cr0 & ~0xffffffffULL))
>                 return false;
>
>         if (CC(!kvm_dr6_valid(save->dr6)) || CC(!kvm_dr7_valid(save->dr7)=
))   <=3D=3D kvm_set_dr() in rsm_load_state_{32,64}
>                 return false;
>
>         /*
>          * These checks are also performed by KVM_SET_SREGS,
>          * except that EFER.LMA is not checked by SVM against
>          * CR0.PG && EFER.LME.
>          */
>         if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
>                 if (CC(!(save->cr4 & X86_CR4_PAE)) ||                    =
     <=3D=3D kvm_set_cr4() in rsm_enter_protected_mode()
>                     CC(!(save->cr0 & X86_CR0_PE)) ||                     =
     <=3D=3D kvm_set_cr0() in rsm_enter_protected_mode()
>                     CC(!kvm_vcpu_is_legal_cr3(vcpu, save->cr3)))         =
     <=3D=3D kvm_set_cr3() in rsm_enter_protected_mode()
>                         return false;
>         }
>
>         /* Note, SVM doesn't have any additional restrictions on CR4. */
>         if (CC(!__kvm_is_valid_cr4(vcpu, save->cr4)))                    =
     <=3D=3D kvm_set_cr4() in rsm_enter_protected_mode()
>                 return false;
>
>         if (CC(!kvm_valid_efer(vcpu, save->efer)))                       =
     <=3D=3D __kvm_emulate_msr_write() in rsm_load_state_64()
>                 return false;
>
> Even if RSM were missing checks on the L2 state being loaded, I'm not wil=
ling to
> take on _any_ complexity in nested VMRUN to make RSM suck a little less. =
 KVM's
> L2 =3D> SMM =3D> RSM =3D> L2 is fundamentally broken.  Anyone that argues=
 otherwise is
> ignoring architecturally defined behavior in the SDM and APM.
>
> If someone wants to actually put in the effort to properly emulating SMI =
=3D> RSM
> from L2, then I'd be happy to take on some complexity, but even then it's=
 not at
> all clear that it would be necessary.
>
> > 2) Failure to load L2's CR3 or merge the MSR bitmaps. In this case, a
> >    fully-fledged #VMEXIT injection is performed as VMCB02 is already
> >    prepared.
> >
> > Arguably all VMRUN failures should be handled before the VMCB02 is
> > prepared, but with proper cleanup (e.g. clear the GIF).
>
> Eh, so long as KVM cleans up after itself, I don't see anything wrong wit=
h
> preparing some of vmcb02.
>
> So after staring at this for some time, us having gone through multiple a=
ttempts
> to get things right, and this being tagged for stable@, unless I'm missin=
g some
> massive simplification this provides down the road, I am strongly against=
 refactoring
> this code, and 100% against reworking things to "fix" SMM.

For context, this patch (and others you quoted below) were a direct
result of this discussion in v2:
https://lore.kernel.org/kvm/aThIQzni6fC1qdgj@google.com/. I didn't
look too closely into the SMM bug tbh I just copy/pasted that verbatim
into the changelog.

As for refactoring the code, I didn't really do it for SMM, but I
think the code is generally cleaner with the single VMRUN failure
path. That being said..

> And so for the stable@ patches, I'm also opposed to all of these:
>
>   KVM: nSVM: Refactor minimal #VMEXIT handling out of nested_svm_vmexit()
>   KVM: nSVM: Call nested_svm_init_mmu_context() before switching to VMCB0=
2
>   KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
>   KVM: nSVM: Make nested_svm_merge_msrpm() return an errno
>   KVM: nSVM: Call enter_guest_mode() before switching to VMCB02
>   KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers
>
> unless they're *needed* by some later commit (I didn't look super closely=
).
>
> For stable@, just fix the GIF case and move on.

.. I am not sure if you mean dropping them completely, or dropping
them from stable@.

I am fine with dropping the stable@ tag from everything from this
point onward, or re-ordering the patches to keep it for the missing
consistency checks.

If you mean drop them completely, it's a bit of a shame because I
think the code ends up looking much better, but I also understand
given all the back-and-forth, and the new problem I reported recently
that will need further refactoring to address (see my other reply to
the same patch).

Let me know how you want to proceed: drop the patches entirely and
just fix GIF, or fix GIF first for stable, and keep the refactoring
for non-stable.


>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index d734cd5eef5e..d9790e37d4e8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1036,6 +1036,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>                 vmcb12->control.exit_code    =3D SVM_EXIT_ERR;
>                 vmcb12->control.exit_info_1  =3D 0;
>                 vmcb12->control.exit_info_2  =3D 0;
> +               svm_set_gif(svm, false);
>                 goto out;
>         }
>
> Sorry for not catching this earlier, I didn't actually read the changelog=
 until
> this version.  /facepalm

