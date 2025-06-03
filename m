Return-Path: <kvm+bounces-48243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 00F3BACBE85
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 04:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E35E1891613
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 02:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664E016E863;
	Tue,  3 Jun 2025 02:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ahJo5/04"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3C22C3242;
	Tue,  3 Jun 2025 02:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748917945; cv=none; b=rP7aclaV5eltnb/Vqms4Mz7FvvwsY3ax5N76/Tpiy33HrrhqZ/QTYoE+ezELYYE/yUChU5ngsP6BrdTIIkYx+l4eXuaS/KtZlyJoVGf3z6VY82CAYLE6zC5XYroKcWzfYVbJpfGzNz/ot3H+ndjgTUdQYIn+SELvFBR19yvP2dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748917945; c=relaxed/simple;
	bh=iukzqPLEHUEamTvzln+FXjqg8pe2ST7JYjMWxBm2Z8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XRAv0dvzI3SDCo+VFNtT6g/Yi5tvMM7h7kCEnoploIDsOierEi4Gd66aKXS+8OPe2uJQci2ISuAON5Nmm8PSfGCWNpfVUjhhCH879M7yLM4kdIhTQuBKxmEHrWH6lpOFw3LQLMHuvLfmZRCoFlzOSA5L6oYvwspuL/YjHqWTwQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ahJo5/04; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748917944; x=1780453944;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iukzqPLEHUEamTvzln+FXjqg8pe2ST7JYjMWxBm2Z8E=;
  b=ahJo5/04EAq9fowbjC1P6mWk1k9c7ieoGgBaBP2D2qYX9i8E3XZa8ReR
   V/De9qtzSL2II/P943FoHj9OHjTdQJP7LTtugPJUmfxT8vCA3HutKJ6BU
   u7ZN0qQO/n8Vu6LKSw9iLeKYlX05ayWg7GS9lHgTDLTaN7wC5Mj1zGylR
   c9z7EHRkI5Iad+DmLJCTbAoY1/skH8VMeJQd2TuCz98Ez/clsQo4884CU
   NLQBZIz1Igl9SsGSeNIoDNQCQgivUGERoDe4BnN7qYAdID88BpDNRDDhZ
   35rpCZOzT+QOoml/a5NYeb2uDTzNTixig/C9cH0COD5rvYrhMOCvlWaEe
   Q==;
X-CSE-ConnectionGUID: In1D+8zvQQabJ9kRSPteDg==
X-CSE-MsgGUID: 3/k66s/2R+C4IdTjs/ys6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="61992996"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="61992996"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 19:32:23 -0700
X-CSE-ConnectionGUID: 6nURPut1TEqDQMkzHPPAXA==
X-CSE-MsgGUID: SkYJvXOGSSa/37gUShZ+yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="175571632"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 19:32:21 -0700
Message-ID: <89f66499-26b6-4b7d-a17e-4e74007e8c53@linux.intel.com>
Date: Tue, 3 Jun 2025 10:32:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/28] KVM: SVM: Massage name and param of helper that
 merges vmcb01 and vmcb12 MSRPMs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Chao Gao <chao.gao@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-7-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529234013.3826933-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/2025 7:39 AM, Sean Christopherson wrote:
> Renam nested_svm_vmrun_msrpm() to nested_svm_merge_msrpm() to better

"Renam" -> "Rename".


> capture its role, and opportunistically feed it @vcpu instead of @svm, as
> grabbing "svm" only to turn around and grab svm->vcpu is rather silly.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 15 +++++++--------
>  arch/x86/kvm/svm/svm.c    |  2 +-
>  2 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8427a48b8b7a..89a77f0f1cc8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -189,8 +189,9 @@ void recalc_intercepts(struct vcpu_svm *svm)
>   * is optimized in that it only merges the parts where KVM MSR permission bitmap
>   * may contain zero bits.
>   */
> -static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
> +static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
>  	int i;
>  
>  	/*
> @@ -205,7 +206,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  	if (!svm->nested.force_msr_bitmap_recalc) {
>  		struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
>  
> -		if (kvm_hv_hypercall_enabled(&svm->vcpu) &&
> +		if (kvm_hv_hypercall_enabled(vcpu) &&
>  		    hve->hv_enlightenments_control.msr_bitmap &&
>  		    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
>  			goto set_msrpm_base_pa;
> @@ -230,7 +231,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  
>  		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
>  
> -		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4))
> +		if (kvm_vcpu_read_guest(vcpu, offset, &value, 4))
>  			return false;
>  
>  		svm->nested.msrpm[p] = svm->msrpm[p] | value;
> @@ -937,7 +938,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
>  		goto out_exit_err;
>  
> -	if (nested_svm_vmrun_msrpm(svm))
> +	if (nested_svm_merge_msrpm(vcpu))
>  		goto out;
>  
>  out_exit_err:
> @@ -1819,13 +1820,11 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  {
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -
>  	if (WARN_ON(!is_guest_mode(vcpu)))
>  		return true;
>  
>  	if (!vcpu->arch.pdptrs_from_userspace &&
> -	    !nested_npt_enabled(svm) && is_pae_paging(vcpu))
> +	    !nested_npt_enabled(to_svm(vcpu)) && is_pae_paging(vcpu))
>  		/*
>  		 * Reload the guest's PDPTRs since after a migration
>  		 * the guest CR3 might be restored prior to setting the nested
> @@ -1834,7 +1833,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3)))
>  			return false;
>  
> -	if (!nested_svm_vmrun_msrpm(svm)) {
> +	if (!nested_svm_merge_msrpm(vcpu)) {
>  		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		vcpu->run->internal.suberror =
>  			KVM_INTERNAL_ERROR_EMULATION;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b55a60e79a73..2085259644b6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3134,7 +3134,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		 *
>  		 * For nested:
>  		 * The handling of the MSR bitmap for L2 guests is done in
> -		 * nested_svm_vmrun_msrpm.
> +		 * nested_svm_merge_msrpm().
>  		 * We update the L1 MSR bit as well since it will end up
>  		 * touching the MSR anyway now.
>  		 */

