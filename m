Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5302F1E78C7
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgE2Iwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:52:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:55753 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgE2Iwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 04:52:38 -0400
IronPort-SDR: foGOxCxYA2FwGq9TNiDaOLGEVMwltI18G0NZPAUC0gEW4exxKT55tqm5iiWug/EZyBN+nBhfCx
 s1iAXRQonpzw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:52:37 -0700
IronPort-SDR: 9KFXrRfq7jvOdJ+Pa8JB5uZ41UtP3NO1E5ieKmGca4LGdurBRMFAqwI5NIoVgbDwpXZJW4t3wb
 A3/m4CbS1L3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,448,1583222400"; 
   d="scan'208";a="311187339"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by FMSMGA003.fm.intel.com with ESMTP; 29 May 2020 01:52:33 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH RESEND] Enable full width counting for KVM: x86/pmu
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200529074347.124619-1-like.xu@linux.intel.com>
 <8ff77a5b-21fd-31f0-b97c-d188ec776808@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <800997eb-91f9-efb4-34f5-44e130e720ab@intel.com>
Date:   Fri, 29 May 2020 16:52:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <8ff77a5b-21fd-31f0-b97c-d188ec776808@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/29 16:47, Paolo Bonzini wrote:
> On 29/05/20 09:43, Like Xu wrote:
>> Hi Paolo,
>>
>> As you said, you will queue the v3 of KVM patch, but it looks like we
>> are missing that part at the top of the kvm/queue tree.
>>
>> For your convenience, let me resend v4 so that we can upstream this
>> feature in the next merged window. Also this patch series includes
>> patches for qemu and kvm-unit-tests. Please help review.
>>
>> Previous:
>> https://lore.kernel.org/kvm/f1c77c79-7ff8-c5f3-e011-9874a4336217@redhat.com/
>>
>> Like Xu (1):
>>    KVM: x86/pmu: Support full width counting
>>    [kvm-unit-tests] x86: pmu: Test full-width counter writes
>>    [Qemu-devel] target/i386: define a new MSR based feature
>>   word - FEAT_PERF_CAPABILITIES
>>
>> Wei Wang (1):
>>    KVM: x86/pmu: Tweak kvm_pmu_get_msr to pass 'struct msr_data' in
>>
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/cpuid.c            |  2 +-
>>   arch/x86/kvm/pmu.c              |  4 +-
>>   arch/x86/kvm/pmu.h              |  4 +-
>>   arch/x86/kvm/svm/pmu.c          |  7 ++--
>>   arch/x86/kvm/vmx/capabilities.h | 11 +++++
>>   arch/x86/kvm/vmx/pmu_intel.c    | 71 +++++++++++++++++++++++++++------
>>   arch/x86/kvm/vmx/vmx.c          |  3 ++
>>   arch/x86/kvm/x86.c              |  6 ++-
>>   9 files changed, 87 insertions(+), 22 deletions(-)
>>
> Thanks, I was busy with AMD stuff as you saw. :)  I've queued it now.
Yes, we all know you're busy.

I will be very grateful if you could comment the KVM part for the LBR 
feature. :D

https://lore.kernel.org/kvm/20200514083054.62538-1-like.xu@linux.intel.com/

Thanks,
Like Xu
>
> Paolo
>

