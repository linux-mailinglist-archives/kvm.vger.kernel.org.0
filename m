Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F08704359
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 04:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjEPCWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 22:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjEPCWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 22:22:31 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DE3F2;
        Mon, 15 May 2023 19:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684203749; x=1715739749;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xhub620MvUkYB5ByKu+zzBEV74A0k3faGyp2jpIPNqo=;
  b=nyA0Yhl4OJIhJERB3C9eHDKSGvW5u4/1gyxkPV8GWRHCJOavYtA5wAu4
   Wr4dnSLKe332AYy1XApP0bj4NBptUUnlUaDM7nfwkCFkCLV63PE2X9k/d
   MMSQ6Hjf/m1cP5uH719+m/NR+eF9irAr6k44qMcDG3me1L0J8zA2yblz2
   jo8Yj/fQTnq6XTinurc9+JL+uOYmtJkKqSel6CUpk47+tygEKUu4qqZn3
   e4qoTS0czsgi9V4H6X8/GJ3o/OOl6elDNwOsqTPjy9lBpbnKOwPsdDYtm
   ioqcC73AYdC6gyMtXt5jik4i/Edeafpn0kyTePPFzw/bJdfHIBW3028p8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="417018389"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="417018389"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 19:22:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="695261042"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="695261042"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.174.127]) ([10.249.174.127])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 19:22:25 -0700
Message-ID: <9c75663c-6363-34e7-8341-d8f719365768@intel.com>
Date:   Tue, 16 May 2023 10:22:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [RFC PATCH v2 02/11] KVM: x86: Advertise CPUID.7.2.EDX and
 RRSBA_CTRL support
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-3-chao.gao@intel.com>
 <a88b2504-b79b-83d6-383e-a948f9da662b@intel.com>
 <ZGLkvlx5W0JStTjD@chao-email>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZGLkvlx5W0JStTjD@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/2023 10:04 AM, Chao Gao wrote:
> On Mon, May 15, 2023 at 02:53:07PM +0800, Xiaoyao Li wrote:
>> On 4/14/2023 2:25 PM, Chao Gao wrote:
>>> From: Zhang Chen <chen.zhang@intel.com>
>>>
>>> Add a kvm-only CPUID feature leaf for CPUID.7.2.EDX and RRSBA_CTRL
>>> as the first feature in the leaf.
>>>
>>> RRSBA_CTRL is enumerated by CPUID.7.2.EDX[2]. If supported, RRSBA_DIS_U
>>> (bit 5) and RRSBA_DIS_S (bit 6) of IA32_SPEC_CTRL MSR can be used to
>>> disable RRSBA behavior for CPL3 and CPL0/1/2 respectively.
>>>
>>> Note that KVM does not intercept guests' IA32_SPEC_CTRL MSR accesses
>>> after a non-zero is written to the MSR. Therefore, guests can already
>>> toggle the two bits if the host supports RRSBA_CTRL, and no extra code
>>> is needed to allow guests to toggle the two bits.
>>
>> This is a bug that also matters with other bits in MSR_IA32_SPEC_CTRL which
>> has a dedicated enumeration CPUID bit and no support in KVM yet.
> 
> Do you mean passing through the MSR is a bug? guest can write any hardware
> supported value to the MSR if the MSR isn't intercepted.
> 
> I guess this is intentional and a trade-off for performance (note that
> context-switch may cause writes to the MSR). And see
> 
> commit 841c2be09fe4 ("kvm: x86: replace kvm_spec_ctrl_test_value with runtime test on the host")
> 
> it appears that this behavior is widely recognized.
> 
>>
>> I think we need to fix this bug at first.
> 
> I have no idea how to fix the "bug" without intercepting the MSR. The
> performance penalty makes me think intercepting the MSR is not a viable
> solution.

I thought correctness always takes higher priority over performance.

>>
>>> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
>>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>>> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
>>> ---
>>>    arch/x86/kvm/cpuid.c         | 22 +++++++++++++++++++---
>>>    arch/x86/kvm/reverse_cpuid.h |  7 +++++++
>>>    2 files changed, 26 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 9583a110cf5f..f024c3ac2203 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -685,6 +685,10 @@ void kvm_set_cpu_caps(void)
>>>    		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
>>>    	);
>>> +	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
>>> +		SF(RRSBA_CTRL)
>>> +	);
>>> +
>>
>> Please move this hook up to right follow the leaf CPUID_7_1_EAX.
> 
> sure. will do.

