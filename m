Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9F11C7FFD
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 04:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgEGCWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 22:22:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:31295 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgEGCWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 22:22:11 -0400
IronPort-SDR: 8SbwEQyzKkwfuf17MedXmDJw37z4rnamwpZxzZfELUlCyh/KMv5MYsIgVGswtwHIsq3T012SuI
 WnXBsTlxoBOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 19:22:11 -0700
IronPort-SDR: N44NmMeJFi8fM31NdVbMUW5ElTg0hNdWotwLp5GU+rlmslq/H+0ZFBWB/1e1UVRVrU5d7l1AQA
 SZtMqQz3RC9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,361,1583222400"; 
   d="scan'208";a="407477588"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by orsmga004.jf.intel.com with ESMTP; 06 May 2020 19:22:08 -0700
Reply-To: like.xu@intel.com
Subject: Re: [RESEND PATCH] KVM: x86/pmu: Support full width counting
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200427071922.86257-1-like.xu@linux.intel.com>
 <aa182eec-3d0b-1452-19cc-20654190a2ae@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <ce270752-191e-8610-b253-b53870b3f358@intel.com>
Date:   Thu, 7 May 2020 10:22:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <aa182eec-3d0b-1452-19cc-20654190a2ae@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Thanks for your comments!

On 2020/5/5 0:57, Paolo Bonzini wrote:
> On 27/04/20 09:19, Like Xu wrote:
>> +	if (vmx_supported_perf_capabilities())
>> +		kvm_cpu_cap_check_and_set(X86_FEATURE_PDCM);
> I think we can always set it, worst case it will be zero.
Sure,  we could set it for x86.
>
> However, blocking intel_pmu_set_msr altogether is incorrect.  Instead,
> you need to:
>
> - list the MSR in msr_based_features_all so that it appears in
> KVM_GET_MSR_FEATURE_INDEX_LIST
>
> - return the supported bits in vmx_get_msr_feature
>
> - allow host-initiated writes (as long as they only set supported bits)
> of the MSR in intel_pmu_set_msr.
Please review the v2 patch for this feature,
https://lore.kernel.org/kvm/20200507021452.174646-1-like.xu@linux.intel.com/

Thanks,
Like Xu
>
> Thanks,
>
> Paolo
>

