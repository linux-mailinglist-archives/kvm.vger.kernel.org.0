Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535972F748D
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 09:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbhAOIsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 03:48:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:55382 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbhAOIsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 03:48:53 -0500
IronPort-SDR: thnlNs/BUGLW2zWmzEotKQwhtFiK1mxvoaRvdtTTAqGaFSkY+PTKKQYzl1og4MH9jBJSjcuCdv
 UJ6y5JfHcLeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="178669450"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="178669450"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 00:47:04 -0800
IronPort-SDR: SdOdKSFHHg3PsRBqDfAzO4qO7AQvuyr+ujeq23zbjofLXPQY7BG4cCkwDVcRojxTTlLR7Pks5S
 eOM6YisK+Svg==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="382590183"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 00:46:59 -0800
Subject: Re: [PATCH] KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding
 in intel_arch_events[]
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201230081916.63417-1-like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <1ff5381c-3057-7ca2-6f62-bbdcefd8e427@linux.intel.com>
Date:   Fri, 15 Jan 2021 16:46:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20201230081916.63417-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping ?

On 2020/12/30 16:19, Like Xu wrote:
> The HW_REF_CPU_CYCLES event on the fixed counter 2 is pseudo-encoded as
> 0x0300 in the intel_perfmon_event_map[]. Correct its usage.
>
> Fixes: 62079d8a4312 ("KVM: PMU: add proper support for fixed counter 2")
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index a886a47daebd..013e8d253dfa 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -29,7 +29,7 @@ static struct kvm_event_hw_type_mapping intel_arch_events[] = {
>   	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
>   	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
>   	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> -	[7] = { 0x00, 0x30, PERF_COUNT_HW_REF_CPU_CYCLES },
> +	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
>   };
>   
>   /* mapping between fixed pmc index and intel_arch_events array */

