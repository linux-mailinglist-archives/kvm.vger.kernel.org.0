Return-Path: <kvm+bounces-58134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 849DBB88A62
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 11:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EF8516E177
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86402F1FD9;
	Fri, 19 Sep 2025 09:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVN/Olrz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123902D0274;
	Fri, 19 Sep 2025 09:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758275368; cv=none; b=tr5h/OFeVrYIuym7LVC5Y3a0jAvXC1gjEYAI7F6ChVG5lg/ZGxAv2ugMkJsSGQN9OcnlOHd9eqj/4Q6+Zh9JPba44BIEUg56brPHsqb1d2niB3qfPAan8/fxkiIllKh7UAg+7yYePgV2TAcC8oZuCT0lz1TXl0ANJ5/WJZHkMkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758275368; c=relaxed/simple;
	bh=D5iZNmBBZ5aKBtfnzqBn7wqTVaUbc/5Lg9CzO28Ivcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qc7fCtaMuIjNi5Ydb9bn44MBFP1y2Fu6GAm/A5ajvQVe3FWiuh7YngpafgCl9iyYndLhUjR603hYMGeiONSULcoQDaylOc6ao0qaU0tHwRuVdgx8PnkbXYPY6ffxuq9alEhyTM7kivQVqzF7sXjNFijAkIM+wTJnm1PwPZvx0Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVN/Olrz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144D2C4CEF1;
	Fri, 19 Sep 2025 09:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758275367;
	bh=D5iZNmBBZ5aKBtfnzqBn7wqTVaUbc/5Lg9CzO28Ivcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iVN/OlrzsjHiJ0qfIx9nbPCv/HafC7cgJXTM9S3s6naTa0+ZyjYy+SxXBvPPP7Aiq
	 FsBCLS/7MvJGLwIyfDEL7678Qgjq5v5abOVgJuaebnUULmgDJS6mM5UBc6kgXp5Kg0
	 E+2fSAfDssXrfVX3mfEtVKS8vH4k+i2EBJoFVEUtxdqN1RAvN1GpZpmGEXumA3avag
	 UOyWAIRRF+381RCQ+UZMlC7LPKlnmWWkm7T3GOuORdyf8YfcMU+bk2lO4Ov+navSJ1
	 mfB7wXPbPz+zzrHoWlqlzYmEePWLde39ICLtN1iBYci8YBXBPFZTxnq4Hi8WQyUzbt
	 ueUVTCE/cA29w==
Date: Fri, 19 Sep 2025 15:12:19 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] KVM: SVM: Update "APICv in x2APIC without x2AVIC"
 in avic.c, not svm.c
Message-ID: <i4znbv2qka5nswuirlbm6ycjmeqmxtfflz6rbukzsdpfte7p3e@wez3k34xsrqa>
References: <20250919002136.1349663-1-seanjc@google.com>
 <20250919002136.1349663-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919002136.1349663-3-seanjc@google.com>

On Thu, Sep 18, 2025 at 05:21:32PM -0700, Sean Christopherson wrote:
> Set the "allow_apicv_in_x2apic_without_x2apic_virtualization" flag as part
> of avic_hardware_setup() instead of handling in svm_hardware_setup(), and
> make x2avic_enabled local to avic.c (setting the flag was the only use in
> svm.c).
> 
> Opportunistically tag avic_hardware_setup() with __init to make it clear
> that nothing untoward is happening with svm_x86_ops.
> 
> No functional change intended (aside from the side effects of tagging
> avic_hardware_setup() with __init).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 6 ++++--
>  arch/x86/kvm/svm/svm.c  | 4 +---
>  arch/x86/kvm/svm/svm.h  | 3 +--
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 478a18208a76..683411442476 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -77,7 +77,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
>  static u32 next_vm_id = 0;
>  static bool next_vm_id_wrapped = 0;
>  static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
> -bool x2avic_enabled;
> +static bool x2avic_enabled;
>  
>  
>  static void avic_set_x2apic_msr_interception(struct vcpu_svm *svm,
> @@ -1147,7 +1147,7 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>   * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
>   * - The mode can be switched at run-time.
>   */
> -bool avic_hardware_setup(void)
> +bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops)
>  {
>  	if (!npt_enabled)
>  		return false;
> @@ -1182,6 +1182,8 @@ bool avic_hardware_setup(void)
>  	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
>  	if (x2avic_enabled)
>  		pr_info("x2AVIC enabled\n");
> +	else
> +		svm_ops->allow_apicv_in_x2apic_without_x2apic_virtualization = true;

I'm not entirely convinced that this is better since svm_x86_ops fields 
are now being updated outside of svm.c. But, I do see your point about 
limiting x2avic_enabled to avic.c

Would it be better to name this field as svm_x86_ops here too, so it is 
at least easy to grep and find?

Otherwise, for this patch:
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>


- Naveen


