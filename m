Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13B82200C2
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 00:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgGNWmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 18:42:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:19649 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgGNWmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 18:42:16 -0400
IronPort-SDR: qTqtn455vtyIa620HqIgoKezinDFlhjoKoHW5mpumaM+o3mJ8qC53fc/+rgmTS2bTHtzoPvEr9
 KXogANdIKLUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="150456971"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="150456971"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 15:42:14 -0700
IronPort-SDR: XqZEvOLkO9I0ha9jatkuuPZPcrYkQJr7Z6EoqENKxlRq75bng388Ikoxbo8FGHL/uIGRnKHZ4S
 hKwfnM/6VI+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="281897107"
Received: from zhangj4-mobl1.ccr.corp.intel.com (HELO [10.249.173.190]) ([10.249.173.190])
  by orsmga003.jf.intel.com with ESMTP; 14 Jul 2020 15:42:09 -0700
Subject: Re: [PATCH v2 3/4] x86: Expose SERIALIZE for supported cpuid
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        ricardo.neri-calderon@linux.intel.com, kyung.min.park@intel.com,
        jpoimboe@redhat.com, gregkh@linuxfoundation.org,
        ak@linux.intel.com, dave.hansen@intel.com, tony.luck@intel.com,
        ravi.v.shankar@intel.com
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
 <1594088183-7187-4-git-send-email-cathy.zhang@intel.com>
 <20200714030047.GA12592@linux.intel.com>
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
Message-ID: <80d91e21-6509-ff70-fb5a-5c042f6ea588@intel.com>
Date:   Wed, 15 Jul 2020 06:42:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714030047.GA12592@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/2020 11:00 AM, Sean Christopherson wrote:
> On Tue, Jul 07, 2020 at 10:16:22AM +0800, Cathy Zhang wrote:
>> SERIALIZE instruction is supported by intel processors,
>> like Sapphire Rapids. Expose it in KVM supported cpuid.
> Providing at least a rough overview of the instruction, e.g. its enumeration,
> usage, fault rules, controls, etc... would be nice.  In isolation, the
> changelog isn't remotely helpful in understanding the correctness of the
> patch.
Thanks Sean! Add it in the next version.
>
>> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 8a294f9..e603aeb 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -341,7 +341,8 @@ void kvm_set_cpu_caps(void)
>>   	kvm_cpu_cap_mask(CPUID_7_EDX,
>>   		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>>   		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>> -		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
>> +		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>> +		F(SERIALIZE)
>>   	);
>>   
>>   	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
>> -- 
>> 1.8.3.1
>>
