Return-Path: <kvm+bounces-70439-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8HGnFJD1hWnHIgQAu9opvQ
	(envelope-from <kvm+bounces-70439-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:07:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80EDAFE9F9
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 54587300D9D7
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 14:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E653EF0C6;
	Fri,  6 Feb 2026 14:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIIyYIFA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9DC212D7C;
	Fri,  6 Feb 2026 14:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770386826; cv=none; b=lxOdBe2qpIxqVm2Ul6e4rsIP+fO7eRSmhGJQxleR1LfnCASeC0DAann6qXz1nWM/V/xi/pcyTRKNHHGmHSa+4ABk5Sul6AGfDmz38xiEul4o3KS5o+td8xzeWZyUjZTWEQtdqt1q5lfOxC7zyhXTN0KkbRphYVhCGvDDz5b7tmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770386826; c=relaxed/simple;
	bh=JS58VcyJojSCIVFDyEePAH+2VNddwJcji83Y0eTumnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAAZY3guKbaTNjzsQDVrM7FOgXxsCUETeoZX4+482BAo6aVxtllTwZTiazHef/xEeGK+J2zgVOsZVrbhW86H/V+o98TBIUDbJZg6056RqwV81UD9zOkAmNz5PnY8GkhPmtirHwCNwuf+GRTCgGqYVPFVDH8drnjMyvR4I/0lO98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIIyYIFA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727B6C116C6;
	Fri,  6 Feb 2026 14:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770386826;
	bh=JS58VcyJojSCIVFDyEePAH+2VNddwJcji83Y0eTumnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JIIyYIFAZ6TCqcUf9dxy7g97nmundwPqg7mWPTOAsoPg5LhGWtUstnHEzC8zqhlye
	 GWJTRRjnQcojnYeDm5R2Gm14olyjF9jt6VHq+3JfvxjrGomE7Muc2+Xd7HD2rZ9qJ8
	 31h4kzpxFc6Yq05ww0NQ/iAIge4oTmaXwlju6D9KULd7Su9mjJxmrB8WbXfqgAMi+J
	 jeacn/z/SPft0oJLWZBy3Nu/KB3+j93clS35L0QRH81PfdshAltbOH+LbaBZES21c5
	 MokeUf5M+GY6Iq4OifRjjFfXuc4Gn6SchqqnXnPniAOvWxYsZ++HQh8AMETlGodAkH
	 EsTWOI3a4LnIQ==
Date: Fri, 6 Feb 2026 19:30:08 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	"Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Initialize AVIC VMCB fields if AVIC is
 enabled with in-kernel APIC
Message-ID: <aYXvp1S7lg2sq4AS@blrnaveerao1>
References: <20260203190711.458413-1-seanjc@google.com>
 <20260203190711.458413-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203190711.458413-2-seanjc@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70439-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naveen@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 80EDAFE9F9
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 11:07:09AM -0800, Sean Christopherson wrote:
> Initialize all per-vCPU AVIC control fields in the VMCB if AVIC is enabled
> in KVM and the VM has an in-kernel local APIC, i.e. if it's _possible_ the
> vCPU could activate AVIC at any point in its lifecycle.  Configuring the
> VMCB if and only if AVIC is active "works" purely because of optimizations
> in kvm_create_lapic() to speculatively set apicv_active if AVIC is enabled
> *and* to defer updates until the first KVM_RUN.  In quotes because KVM

I think it will be good to clarify that two issues are being addressed 
here (it wasn't clear to me to begin with):
- One, described above, is about calling into avic_init_vmcb() 
  regardless of the vCPU APICv status.
- Two, described below is about using the vCPU APICv status for init and 
  not consulting the VM-level APICv inhibit status.

> likely won't do the right thing if kvm_apicv_activated() is false, i.e. if
> a vCPU is created while APICv is inhibited at the VM level for whatever
> reason.  E.g. if the inhibit is *removed* before KVM_REQ_APICV_UPDATE is
> handled in KVM_RUN, then __kvm_vcpu_update_apicv() will elide calls to
> vendor code due to seeing "apicv_active == activate".
> 
> Cleaning up the initialization code will also allow fixing a bug where KVM
> incorrectly leaves CR8 interception enabled when AVIC is activated without
> creating a mess with respect to whether AVIC is activated or not.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Any reason not to add a Fixes: tag? It looks like the below commits are 
to blame, but those are really old so I understand if you don't think 
this is useful:
Fixes: 67034bb9dd5e ("KVM: SVM: Add irqchip_split() checks before enabling AVIC")
Fixes: 6c3e4422dd20 ("svm: Add support for dynamic APICv")

Other than that:
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

> ---
>  arch/x86/kvm/svm/avic.c | 2 +-
>  arch/x86/kvm/svm/svm.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index f92214b1a938..44e07c27b190 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -368,7 +368,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>  	vmcb->control.avic_physical_id = __sme_set(__pa(kvm_svm->avic_physical_id_table));
>  	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
>  
> -	if (kvm_apicv_activated(svm->vcpu.kvm))
> +	if (kvm_vcpu_apicv_active(&svm->vcpu))
>  		avic_activate_vmcb(svm);
>  	else
>  		avic_deactivate_vmcb(svm);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5f0136dbdde6..e8313fdc5465 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1189,7 +1189,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
>  	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
>  		svm->vmcb->control.erap_ctl |= ERAP_CONTROL_ALLOW_LARGER_RAP;
>  
> -	if (kvm_vcpu_apicv_active(vcpu))
> +	if (enable_apicv && irqchip_in_kernel(vcpu->kvm))
>  		avic_init_vmcb(svm, vmcb);

Doesn't have to be done as part of this series, but I'm wondering if it 
makes sense to turn this into a helper to clarify the intent and to make 
it more obvious:

---
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e441f270f354..4e0ec4bf0db6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2289,6 +2289,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
                                struct x86_exception *exception);

+bool kvm_apicv_possible(struct kvm *kvm);
 bool kvm_apicv_activated(struct kvm *kvm);
 bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu);
 void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 13a4a8949aba..f7b1271cea88 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -285,7 +285,7 @@ int avic_alloc_physical_id_table(struct kvm *kvm)
 {
        struct kvm_svm *kvm_svm = to_kvm_svm(kvm);

-       if (!irqchip_in_kernel(kvm) || !enable_apicv)
+       if (!kvm_apicv_possible(kvm))
                return 0;

        if (kvm_svm->avic_physical_id_table)
@@ -839,7 +839,7 @@ int avic_init_vcpu(struct vcpu_svm *svm)
        INIT_LIST_HEAD(&svm->ir_list);
        raw_spin_lock_init(&svm->ir_list_lock);

-       if (!enable_apicv || !irqchip_in_kernel(vcpu->kvm))
+       if (!kvm_apicv_possible(vcpu->kvm))
                return 0;

        ret = avic_init_backing_page(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4115fe583052..b964d834512e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1188,7 +1188,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
        if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
                svm->vmcb->control.erap_ctl |= ERAP_CONTROL_ALLOW_LARGER_RAP;

-       if (enable_apicv && irqchip_in_kernel(vcpu->kvm))
+       if (kvm_apicv_possible(vcpu->kvm))
                avic_init_vmcb(svm, vmcb);

        if (vnmi)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8acfdfc583a1..86f99c5b831a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10270,6 +10270,12 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
        kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq);
 }

+bool kvm_apicv_possible(struct kvm *kvm)
+{
+       return enable_apicv && irqchip_in_kernel(kvm);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_apicv_possible);
+
 bool kvm_apicv_activated(struct kvm *kvm)
 {
	return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);


- Naveen


