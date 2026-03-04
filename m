Return-Path: <kvm+bounces-72715-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DcrKFBxqGkkugAAu9opvQ
	(envelope-from <kvm+bounces-72715-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:52:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C72205784
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:52:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1BDA730745D5
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 17:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19AE3C2786;
	Wed,  4 Mar 2026 17:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onpBoruE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695243CCA10
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 17:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646631; cv=none; b=A7NLu29PMMAWfRXKeS3zH9aaafHqjb5GHFBCgT5/VVc1LhZo3L+sLxyQKUXlTMBjV3Iatl+EdvpfdBXRgYiJJrr0XdwEmL3Ri0nBo9t9P+HrX6+UQ0rb7qQtO2vgTa8b8xWqrmfPp3nmivWDYeZNaNYPScrT7vwWEPmcqDkewLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646631; c=relaxed/simple;
	bh=4LDC2nu5NniIP4Si21rDsQfH11m42tcUxvqO4yBcSN4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q7RlSl4tzkr4QaxUNWI9Ts6V8A0O/W6zVM2hgNhFvs15vcnlrfrqko4gPL/ugj6xQ1PYyIwEuETgZ/aMUgiB5hf9dwCVQl+3+vRKYN9hpLvl99W11GF01qm0koQ9ExZwEV9chXUjIDQDqSCRJ80IbAkcnmsAlXvOS5yFrPq+Dsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onpBoruE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDEAC2BCAF
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 17:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772646631;
	bh=4LDC2nu5NniIP4Si21rDsQfH11m42tcUxvqO4yBcSN4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=onpBoruEvqv3fFobGaRa2iFycL6yUNqXT+RBylOXGA0XG3S734lziY2wbV/gWhbxv
	 lLiSfFnCjbti5qTaKUp/Eb0I2SgF/jgYP/2YqqDduDh9H3XwaZuKy62+Irln6FF8Y3
	 ltrR15LMMVLlU6/dwIbSKqfx6ZEI561sdZd1/Gr5HB4pBnjc9bKQu6Y2WPFlp/Nmkt
	 lehJiPAVIZZHYoXY33qMpwjMeMEEu5YFqRhtWUZIPPcE54VNiJdUl4cZ45oMjtnFjg
	 QbIuMXHny1ZENTKjZghZU88wM0WsJcd2tI2MnFbyk6To3oDBUaiBfPXseqk0orwpdL
	 q7xCn5LsNLFmg==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65f812e0d93so11027562a12.2
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 09:50:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXbhJmZWloodyoAF/XsSvHtSasYQdcr5FJE9aMeQXyg/O3jnRgJVNwgw04ecZa2Z6IZI+w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPfLknVuK7rIzfR4e9MCBCpjOWAAuWFnYVJ9Z4rzip8kcY764g
	uiGPdxA398u7ny/tjCy9F5OpP58etOOi4tlwLXD5gCLXob7fxlWcJQKZ3LyN8uFpjyQvfrJQ7Uk
	zwGwW1J54A/pS4kYhXf1pQZABQs2oLoA=
X-Received: by 2002:a17:906:c110:b0:b93:46a8:3f37 with SMTP id
 a640c23a62f3a-b93f144de7amr195302066b.42.1772646629803; Wed, 04 Mar 2026
 09:50:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260225005950.3739782-1-yosry@kernel.org> <20260225005950.3739782-8-yosry@kernel.org>
In-Reply-To: <20260225005950.3739782-8-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 4 Mar 2026 09:50:17 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOvhJgA2v3CXomddmyfrR2KX23fv=HQ6xH2C+m0niswyQ@mail.gmail.com>
X-Gm-Features: AaiRm53u13u1VS-ZH6aFMy3tQSyXpnWmM0HMa0jZgCQDg_nDpachZD-4Ou2AGus
Message-ID: <CAO9r8zOvhJgA2v3CXomddmyfrR2KX23fv=HQ6xH2C+m0niswyQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] KVM: nSVM: Delay setting soft IRQ RIP tracking
 fields until vCPU run
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 47C72205784
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72715-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 5:00=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> In the save+restore path, when restoring nested state, the values of RIP
> and CS base passed into nested_vmcb02_prepare_control() are mostly
> incorrect.  They are both pulled from the vmcb02. For CS base, the value
> is only correct if system regs are restored before nested state. The
> value of RIP is whatever the vCPU had in vmcb02 before restoring nested
> state (zero on a freshly created vCPU).
>
> Instead, take a similar approach to NextRIP, and delay initializing the
> RIP tracking fields until shortly before the vCPU is run, to make sure
> the most up-to-date values of RIP and CS base are used regardless of
> KVM_SET_SREGS, KVM_SET_REGS, and KVM_SET_NESTED_STATE's relative
> ordering.
>
> Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_S=
ET_NESTED_STATE")
> CC: stable@vger.kernel.org
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> ---
>  arch/x86/kvm/svm/nested.c | 17 ++++++++---------
>  arch/x86/kvm/svm/svm.c    | 10 ++++++++++
>  2 files changed, 18 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index dcd4a8eb156f2..4499241b4e401 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -742,9 +742,7 @@ static bool is_evtinj_nmi(u32 evtinj)
>         return type =3D=3D SVM_EVTINJ_TYPE_NMI;
>  }
>
> -static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> -                                         unsigned long vmcb12_rip,
> -                                         unsigned long vmcb12_csbase)
> +static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>  {
>         u32 int_ctl_vmcb01_bits =3D V_INTR_MASKING_MASK;
>         u32 int_ctl_vmcb12_bits =3D V_TPR_MASK | V_IRQ_INJECTION_BITS_MAS=
K;
> @@ -856,14 +854,15 @@ static void nested_vmcb02_prepare_control(struct vc=
pu_svm *svm,
>                 vmcb02->control.next_rip =3D svm->nested.ctl.next_rip;
>
>         svm->nmi_l1_to_l2 =3D is_evtinj_nmi(vmcb02->control.event_inj);
> +
> +       /*
> +        * soft_int_csbase, soft_int_old_rip, and soft_int_next_rip (if L=
1
> +        * doesn't have NRIPS)  are initialized later, before the vCPU is=
 run.
> +        */
>         if (is_evtinj_soft(vmcb02->control.event_inj)) {
>                 svm->soft_int_injected =3D true;
> -               svm->soft_int_csbase =3D vmcb12_csbase;
> -               svm->soft_int_old_rip =3D vmcb12_rip;
>                 if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>                         svm->soft_int_next_rip =3D svm->nested.ctl.next_r=
ip;
> -               else
> -                       svm->soft_int_next_rip =3D vmcb12_rip;
>         }
>
>         /* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
> @@ -961,7 +960,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 v=
mcb12_gpa,
>         nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.=
ptr);
>
>         svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -       nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save=
.cs.base);
> +       nested_vmcb02_prepare_control(svm);
>         nested_vmcb02_prepare_save(svm, vmcb12);
>
>         ret =3D nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
> @@ -1906,7 +1905,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vc=
pu,
>         nested_copy_vmcb_control_to_cache(svm, ctl);
>
>         svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -       nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb=
->save.cs.base);
> +       nested_vmcb02_prepare_control(svm);
>
>         /*
>          * While the nested guest CR3 is already checked and set by
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ded4372f2d499..7948e601ea784 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3670,11 +3670,21 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
>          * This is done here (as opposed to when preparing vmcb02) to use=
 the
>          * most up-to-date value of RIP regardless of the order of restor=
ing
>          * registers and nested state in the vCPU save+restore path.
> +        *
> +        * Simiarly, initialize svm->soft_int_* fields here to use the mo=
st
> +        * up-to-date values of RIP and CS base, regardless of restore or=
der.
>          */
>         if (is_guest_mode(vcpu) && svm->nested.nested_run_pending) {
>                 if (boot_cpu_has(X86_FEATURE_NRIPS) &&
>                     !guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>                         svm->vmcb->control.next_rip =3D kvm_rip_read(vcpu=
);
> +
> +               if (svm->soft_int_injected) {
> +                       svm->soft_int_csbase =3D svm->vmcb->save.cs.base;
> +                       svm->soft_int_old_rip =3D kvm_rip_read(vcpu);
> +                       if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> +                               svm->soft_int_next_rip =3D kvm_rip_read(v=
cpu);
> +               }

AI found a bug here. These fields will be left uninitialized if we
cancel injection before pre_svm_run() (e.g. due to
kvm_vcpu_exit_request()). I was going to suggest moving this to
pre-run, but this leaves a larger gap where RIP can be updated from
under us. Sean has a better fixup in progress.

