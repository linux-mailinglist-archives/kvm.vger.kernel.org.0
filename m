Return-Path: <kvm+bounces-49354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7AB0AD8067
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 03:40:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DDF93B4441
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 01:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0211E1A05;
	Fri, 13 Jun 2025 01:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KYiNcJn5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AB02F4317;
	Fri, 13 Jun 2025 01:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749778784; cv=none; b=uQTskWcFh9gLTGrn/bNR38KX7VCyAcOtn5G6sRi65fDsU7rdeGx2RHwc1ERiEiuRaAaLvBc/aCR7AK0M0VMKLr0w2LH/Za+sbkM/bCqZigGHOyusiD/I6oIyHB6u3n9Je6GFREjW6vxOWH4//O0ONBd6xIxZGxqb4cX6PwhoO3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749778784; c=relaxed/simple;
	bh=n1Pc+/F+lZD7XpWBDY2OCZe2bsr4RBx8NEgdqZx8+2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cl55PkrzM7MA801l1zs95QBT/bqaXhggM7sgxf8wVDJ23wCroC3l1Tu9rhE5uVyIBAbE9TAaL5TYRnfKKDsR3PKlUvL0HVDuGcRyVXmv+e94es14uZYYhhowV5J4qyBzdWdhKaTRbOhJrgZMGLOexv8+VN463yKUliRc2BcJrac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KYiNcJn5; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749778783; x=1781314783;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n1Pc+/F+lZD7XpWBDY2OCZe2bsr4RBx8NEgdqZx8+2I=;
  b=KYiNcJn5+y0qL1MyYihFia4qVpTa1xOgW7E8EI2dPPvYIBILQGFTK2jK
   edKDRS46tlKdNd+hu2omZ2Z+zFZbmKEfuPRzKFQu6jqVEgpZB5LgYLFms
   bBRWQahrWoJsuh7WjX61m/cWzRWRwGju2T0rFqxZ9l+pELZg9uBs3iCZQ
   oOduTpW+6QdD4WM6dp2NNa7J7TuoMBA8WHbIQjAJCqSL/2J6psciE9edm
   gIX1wQqtfDqeXoJYI9WhsW29hf41uwY3tocGVY4Em9KvHjZKfGnqr7Fhd
   KZYWH1hDtjaommVLHKaMXVnSaZX3B1BXEoEX7wnHahsHLqdpVyBsnovOU
   w==;
X-CSE-ConnectionGUID: pVYNghmeSxa2clcQ0atQXQ==
X-CSE-MsgGUID: ht4EXhXsQ86Fc6HSN+mEvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="62262834"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="62262834"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 18:39:43 -0700
X-CSE-ConnectionGUID: pmwl7KwBSCGbk0WpHdCDxQ==
X-CSE-MsgGUID: lrtBlAjITCuDuKi/EQI9RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="147542032"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 18:39:41 -0700
Message-ID: <5a64c348-7d6f-4b66-b441-4a551686b5ca@linux.intel.com>
Date: Fri, 13 Jun 2025 09:39:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: SVM: Simplify MSR interception logic for
 IA32_XSS MSR
To: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com
References: <20250612081947.94081-1-chao.gao@intel.com>
 <20250612081947.94081-3-chao.gao@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250612081947.94081-3-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/12/2025 4:19 PM, Chao Gao wrote:
> Use svm_set_intercept_for_msr() directly to configure IA32_XSS MSR
> interception, ensuring consistency with other cases where MSRs are
> intercepted depending on guest caps and CPUIDs.
>
> No functional change intended.
>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
> With this patch applied, svm_enable_intercept_for_msr() has no user.
> Should it be removed?
> ---
>  arch/x86/kvm/svm/sev.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6282c2930cda..504e8a87644a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4371,11 +4371,9 @@ void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  	 * XSAVES being exposed to the guest so that KVM can at least honor
>  	 * guest CPUID for RDMSR and WRMSR.
>  	 */
> -	if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
> -	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> -		svm_disable_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW);
> -	else
> -		svm_enable_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW);
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW,
> +				  !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) ||
> +				  !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES));
>  }
>  
>  void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



