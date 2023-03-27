Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770446C9A56
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 05:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjC0Dqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Mar 2023 23:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjC0Dqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Mar 2023 23:46:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE603C31;
        Sun, 26 Mar 2023 20:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679888793; x=1711424793;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fXrRImbeVCKFeYifkrpEBPigjtmxkLzuc5BNV/52qrE=;
  b=GKODUAtwQCFROKzOCMdcbW/DuyAyLgFoGrOSA3WztasN8PdmG+is8FB8
   wnVvnSf+3eiM0nkwLPFjl26iXoYnKmx1BJh7XGAxf/MSTsIFEZKEQfl1p
   JAaHe6uLYI13Wt5HWwA7y1uonHHinvjC6wpBPctGOauubmMHOWCH9d+gy
   uWMnRoUZPT4vWRYYklzhhQGvUjjgep02PxRnorzqcgCDAvmWcshaStXYr
   Tjn03tbgqgrJV20B9jvJf4+eM96hevUuFrGd+wfR7w3kHhBiy8LT1ye1x
   Gfzjczb3Z1foIhIsS0iBwmFogDErfTOAvPhETGrh3JyBq9FX+bnbWmf22
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="337677967"
X-IronPort-AV: E=Sophos;i="5.98,293,1673942400"; 
   d="scan'208";a="337677967"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2023 20:46:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="676814236"
X-IronPort-AV: E=Sophos;i="5.98,293,1673942400"; 
   d="scan'208";a="676814236"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.174.244]) ([10.249.174.244])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2023 20:46:28 -0700
Message-ID: <541e48f0-9985-885a-d296-4bcd9d5101a3@intel.com>
Date:   Mon, 27 Mar 2023 11:46:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH 2/6] KVM: VMX: Passthrough MSR_IA32_PRED_CMD based purely
 on host+guest CPUID
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20230322011440.2195485-1-seanjc@google.com>
 <20230322011440.2195485-3-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230322011440.2195485-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/2023 9:14 AM, Sean Christopherson wrote:
> Passthrough MSR_IA32_PRED_CMD based purely on whether or not the MSR is
> supported and enabled, i.e. don't wait until the first write.  There's no
> benefit to deferred passthrough, and the extra logic only adds complexity.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 16 +++-------------
>   1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f777509ecf17..5c01c76c0d45 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2298,19 +2298,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			break;
>   
>   		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
> -
> -		/*
> -		 * For non-nested:
> -		 * When it's written (to non-zero) for the first time, pass
> -		 * it through.
> -		 *
> -		 * For nested:
> -		 * The handling of the MSR bitmap for L2 guests is done in
> -		 * nested_vmx_prepare_msr_bitmap. We should not touch the
> -		 * vmcs02.msr_bitmap here since it gets completely overwritten
> -		 * in the merging.
> -		 */
> -		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
>   		break;
>   	case MSR_IA32_CR_PAT:
>   		if (!kvm_pat_valid(data))
> @@ -7743,6 +7730,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
>   					  !guest_cpuid_has(vcpu, X86_FEATURE_XFD));
>   
> +	if (boot_cpu_has(X86_FEATURE_IBPB))
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
> +					  !guest_has_pred_cmd_msr(vcpu));
>   
>   	set_cr4_guest_host_mask(vmx);
>   

