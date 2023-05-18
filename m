Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A8C707D3E
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 11:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjERJu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 05:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjERJuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 05:50:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006A410E9;
        Thu, 18 May 2023 02:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684403424; x=1715939424;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=rPagqShIA0d1pTwUICG1O4W8vWxt4pVZ7r9/3WRbX4A=;
  b=eBP4kPMBOY6b/KedoTQhaCTpwZEDCtWRUa5ohdljD4Ylc4vZwrhSg2im
   4Sif/8dLdSWXXG1pesXX4/kw0r7asBnDHak7xoFEt5Cxlxd8Igm1fpPNG
   zyABCI3kGSfblzTABvVj/eb8EKacZdzPklp6OmN1Nghr55fJeUhQ4dVnI
   ep6FCILMUDEj3gRe0vld96vwZsxSYIl9zW4SvoGIzOe6nQuhQGQ9l+c0Z
   6QfLFxddgRcAOGP4Tnfxp5Ffxbv3cGoB5gM2ix4yjUk6UzQVoRRMgZA4V
   c5fX64/hkilk3Mg97+rw046Lp5mVQktr2Eh0UzvW3HgVc3Q1H6qnbn8ST
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="332392008"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="332392008"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:50:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="652575062"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="652575062"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.211.142]) ([10.254.211.142])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:50:20 -0700
Message-ID: <d9be9385-4101-2e9e-c6d7-1d980697c02f@intel.com>
Date:   Thu, 18 May 2023 17:50:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v2 02/11] KVM: x86: Advertise CPUID.7.2.EDX and
 RRSBA_CTRL support
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
 <9c75663c-6363-34e7-8341-d8f719365768@intel.com>
 <ZGLyEhKH+MoCY/R4@chao-email>
 <11b515b3-bb5a-bea1-ad01-caffdd151bf6@intel.com>
 <ZGNIN7O8BErVP88x@chao-email>
Content-Language: en-US
In-Reply-To: <ZGNIN7O8BErVP88x@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/2023 5:09 PM, Chao Gao wrote:
> On Tue, May 16, 2023 at 03:03:15PM +0800, Xiaoyao Li wrote:
>> On 5/16/2023 11:01 AM, Chao Gao wrote:
>>> On Tue, May 16, 2023 at 10:22:22AM +0800, Xiaoyao Li wrote:
>>>>>> I think we need to fix this bug at first.
>>>>>
>>>>> I have no idea how to fix the "bug" without intercepting the MSR. The
>>>>> performance penalty makes me think intercepting the MSR is not a viable
>>>>> solution.
>>>>
>>>> I thought correctness always takes higher priority over performance.
>>>
>>> It is generally true. however, there are situations where we should make
>>> trade-offs between correctness and other factors (like performance):
>>>
>>> E.g., instructions without control bits, to be 100% compliant with CPU
>>> spec, in theory, VMMs can trap/decode every instruction and inject #UD
>>> if a guest tries to use some instructions it shouldn't.
>>
>> This is the virtualization hole. IMHO, they are different things.
> 
> what are the differences between?
> 1. Executing some unsupported instructions should cause #UD. But this is allowed
>     in a KVM guest.
> 2. Setting some reserved bits in SPEC_CTRL MSR should cause #GP. But this is
>     allowed in a KVM guest.

The difference is that for virtualization hole, there is no way but 
intercept and decode every instruction if we want the correctness. It's 
a disaster.

But for MSR virtualization, we do have an option and we don't need to 
trap every instruction. MSR interception is the designated mechanism to 
correctly and elegantly virtualize the MSR.

>>
>> Pass through MSR_IA32_SPEC_CTRL was introduced in commit d28b387fb74d
>> ("KVM/VMX: Allow direct access to MSR_IA32_SPEC_CTRL"). At that time there
>> was only a few bits defined, and the changelog called out that
>>
>>   No attempt is made to handle STIBP here, intentionally. Filtering
>>   STIBP may be added in a future patch, which may require trapping all
>>   writes if we don't want to pass it through directly to the guest.
>>
>> Per my undesrstanding, it implied that we need to re-visit it when more bits
>> added instead of following the pass-through design siliently.
> 
> I don't object to re-visiting the design. My point is that to prevent guests from
> setting RRSBA_CTRL/BHI_CTRL when they are not advertised isn't a strong
> justfication for intercepting the MSR. STIBP and other bits (except IBRS) have
> the same problem. And the gain of fixing this is too small.
> 
> If passing through the SPEC_CTRL MSR to guests might cause security issues, I
> would agree to intercept accesses to the MSR.

I never buy it. How to interpret the security? If the user wants to hide 
one feature from guest but KVM allows it when KVM does have a reasonable 
way to hide it. Does it violate the security?
