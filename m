Return-Path: <kvm+bounces-58140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D44A7B89162
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 12:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F69D1CC0F95
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 10:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A43BC3093C4;
	Fri, 19 Sep 2025 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ykg4m/cv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03F82ECE90;
	Fri, 19 Sep 2025 10:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758278372; cv=none; b=oaSLUaQ6H/1mudwGYHMo6btb7cj+ZxESLsvg19rVnWQRoTxFSN7N3uUBBO0iTcdkgmQcxy6IdxVlB9aupjRqSuh4PVJY3+mX3vOLNaRHZBqtfpkrgyZS79voFtIdRpHe+otwPvoXZlJMllhv2/p7je6unS9bIU0DwymglRd5org=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758278372; c=relaxed/simple;
	bh=tm7lbrglmTktL5KAPrB2DX92fAhO0R7ueOB0hqhzYkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y7O1FN29vmZYMbExZwYh10UGD5pAv2RbxM238T5waVfnZ0NSrtExsiOOlofw81pAyz3VKX80lKksBdXzraW6Yy/EJZs/SlZ///b1wwCZkGnjCzpvVUUt+9VvplA42bELsSI+yjBRswHGSkH5RWrnAlnawVKUhLnfo6r0q86BPIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ykg4m/cv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4ABC4CEF9;
	Fri, 19 Sep 2025 10:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758278372;
	bh=tm7lbrglmTktL5KAPrB2DX92fAhO0R7ueOB0hqhzYkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ykg4m/cvIXL0y8mjqH6OTniizpvkgRvO4Xrp702IzIyfHUl3EADNYq0BN6pvAWZ9D
	 nr8risRefCCrBYtg7Uvx3S700Ut64OCDCW2KgjcDWs6dyhruuTEgREThszQVEBhMyO
	 8MG4z9YNpZDN8aURu9RCvd6h96teCaRnzhH1r6lNQHyLLyLGe5aEkImtXmsv1Owt2o
	 d2Bhp6oIwvYCIFI6+jOdsfiQhUmuIA1fub9CFdR4SLLSgMw45z/Sr1iQauhn2oZrPp
	 4Jgpao6Xmow33LO/dh63DvM1F8kGQgbA1zDdlD8oh8D5FkWNiYTd43t7i3wgmesdYt
	 h124RF2sgeCAw==
Date: Fri, 19 Sep 2025 16:07:34 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/6] KVM: SVM: Enable AVIC by default for Zen4+ if
 x2AVIC is support
Message-ID: <4vqqbmsqcaeabbslmrmxbtrq4wubt2avhimijk3xqgerkifune@ahyotfj55gds>
References: <20250919002136.1349663-1-seanjc@google.com>
 <20250919002136.1349663-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919002136.1349663-7-seanjc@google.com>

On Thu, Sep 18, 2025 at 05:21:36PM -0700, Sean Christopherson wrote:
> KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support
							  ^^ supported

> From: Naveen N Rao <naveen@kernel.org>

_ From: Naveen N Rao (AMD) <naveen@kernel.org>

> 
> AVIC and x2AVIC are fully functional since Zen 4, with no known hardware
> errata.  Enable AVIC and x2AVIC by default on Zen4+ so long as x2AVIC is
> supported (to avoid enabling partial support for APIC virtualization by
> default).
> 
> Internally, convert "avic" to an integer so that KVM can identify if the
> user has asked to explicitly enable or disable AVIC, i.e. so that KVM
> doesn't override an explicit 'y' from the user.  Arbitrarily use -1 to
> denote auto-mode, and accept the string "auto" for the module param in
> addition to standard boolean values, i.e. continue to allow to the user
						       allow the user to

> configure the "avic" module parameter to explicitly enable/disable AVIC.
> 
> To again maintain backward compatibility with a standard boolean param,
> set KERNEL_PARAM_OPS_FL_NOARG, which tells the params infrastructure to
> allow empty values for %true, i.e. to interpret a bare "avic" as "avic=y".
> Take care to check for a NULL @val when looking for "auto"!
> 
> Lastly, always print "avic" as a boolean, since auto-mode is resolved
> during module initialization, i.e. the user should never see "auto" in
> sysfs.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 39 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index e059dcae6945..5cccee755213 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -64,12 +64,31 @@
>  
>  static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_IDX_MASK) == -1u);
>  
> +#define AVIC_AUTO_MODE -1
> +
> +static int avic_param_set(const char *val, const struct kernel_param *kp)
> +{
> +	if (val && sysfs_streq(val, "auto")) {
> +		*(int *)kp->arg = AVIC_AUTO_MODE;
> +		return 0;
> +	}
> +
> +	return param_set_bint(val, kp);
> +}

Nit: missing newline.

> +static const struct kernel_param_ops avic_ops = {
> +	.flags = KERNEL_PARAM_OPS_FL_NOARG,
> +	.set = avic_param_set,
> +	.get = param_get_bool,
> +};
> +
>  /*
> - * enable / disable AVIC.  Because the defaults differ for APICv
> - * support between VMX and SVM we cannot use module_param_named.
> + * Enable / disable AVIC.  In "auto" mode (default behavior), AVIC is enabled
> + * for Zen4+ CPUs with x2AVIC (and all other criteria for enablement are met).
>   */
> -static bool avic;
> -module_param(avic, bool, 0444);
> +static int avic = AVIC_AUTO_MODE;
> +module_param_cb(avic, &avic_ops, &avic, 0444);
> +__MODULE_PARM_TYPE(avic, "bool");
> +
>  module_param(enable_ipiv, bool, 0444);
>  
>  static bool force_avic;
> @@ -1151,6 +1170,18 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  
>  static bool __init avic_want_avic_enable(void)
>  {
> +	/*
> +	 * In "auto" mode, enable AVIC by default for Zen4+ if x2AVIC is
> +	 * supported (to avoid enabling partial support by default, and because
> +	 * x2AVIC should be supported by all Zen4+ CPUs).  Explicitly check for
> +	 * family 0x19 and later (Zen5+), as the kernel's synthetic ZenX flags
> +	 * aren't inclusive of previous generations, i.e. the kernel will set
> +	 * at most one ZenX feature flag.
> +	 */
> +	if (avic == AVIC_AUTO_MODE)
> +		avic = boot_cpu_has(X86_FEATURE_X2AVIC) &&

This can use cpu_feature_enabled() as well, I think.

> +		       (boot_cpu_data.x86 > 0x19 || cpu_feature_enabled(X86_FEATURE_ZEN4));
> +
>  	if (!avic || !npt_enabled)
>  		return false;

Otherwise, this LGTM.


- Naveen


