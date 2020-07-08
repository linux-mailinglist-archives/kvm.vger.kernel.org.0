Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1350B218A46
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 16:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbgGHOiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 10:38:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:46429 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729468AbgGHOiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 10:38:07 -0400
IronPort-SDR: cuzTBBI8lx7ijv8/XLOF3IkCXqxC/qaqwm60VrGzFZELVDheibtR2FselNOSFBVTSLjBdOXKDP
 91XXTE11MWkg==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="146878729"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="146878729"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 07:38:06 -0700
IronPort-SDR: q/6Fm8SieqlGqdux/lIR8JIg46GkcYtv5bKNgrkwJ9vimlib/sktAWycnltSE/ylTOCNQKFcRc
 S3T+mPPtOvnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="322956464"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.31.237]) ([10.255.31.237])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jul 2020 07:38:03 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v12 06/11] KVM: vmx/pmu: Expose LBR to guest via
 MSR_IA32_PERF_CAPABILITIES
To:     Andi Kleen <ak@linux.intel.com>, Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200613080958.132489-7-like.xu@linux.intel.com>
 <20200708133646.GM3448022@tassilo.jf.intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <f7f87595-9cec-8512-5385-e5d746b4e886@intel.com>
Date:   Wed, 8 Jul 2020 22:38:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708133646.GM3448022@tassilo.jf.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/7/8 21:36, Andi Kleen wrote:
>> +	/*
>> +	 * As a first step, a guest could only enable LBR feature if its cpu
>> +	 * model is the same as the host because the LBR registers would
>> +	 * be pass-through to the guest and they're model specific.
>> +	 */
>> +	if (boot_cpu_data.x86_model != guest_cpuid_model(vcpu))
>> +		return false;
> Could we relax this in a followon patch? (after this series is merged)
Sure, there would be a follow-on patch to relax this check after it's merged.
>
> It's enough of the perf cap LBR version matches, don't need full model
> number match.
I assume you are referring to the LBR_FMT value in the perf_capabilities.
> This would require a way to configure the LBR version
> from qemu.
Sure, I may propose this configuration in the QEMU community.
>
> This would allow more flexibility, for example migration from
> Icelake to Skylake and vice versa.
Yes, we need this flexibility to cover as many platforms as possible.

Thanks,
Like Xu
>
> -Andi

