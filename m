Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D7B7324C5
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 03:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjFPBpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 21:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjFPBpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 21:45:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167682959;
        Thu, 15 Jun 2023 18:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686879914; x=1718415914;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=0VIFDVSAvKBr8DjtPJ88A4Z4sYf9WrNHoSM3G41+Jf4=;
  b=nr4sttV0nxmCyu4RumzvR2fIaggo6m7FhQndYnFqf1CeiMFndoXomUdF
   rQuva+cMTHG2GPm860Mz/nLroDA8e9Z5Zubj7rFvoApFadqbO+j6UXaxY
   YK704QReGOt7Z9MV2gyexlJftwvQOD76wwZxhMbPuHiS+p3D9jHei/haI
   kpt1agpeiQV5geys+PZAknw1bsGsePZNwplLmfz3sRtn8VO8wmF9avNzb
   Zc2o5xir9NmW1SaNoZf8/6vKjZ6GKxHiOfs3IVndhvKF8yfnqrWiAb7cp
   +0spvM9HWkoen1TvnkguYUiD9B5sUBPAUbqqz1yUje2Sgg0VCQTN4euB5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="357963579"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="357963579"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 18:45:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="1042901864"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="1042901864"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.210.223]) ([10.254.210.223])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 18:45:11 -0700
Message-ID: <aa80acbb-2e2e-0b27-9e25-6e608bc6df17@linux.intel.com>
Date:   Fri, 16 Jun 2023 09:45:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From:   Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v9 6/6] KVM: x86: Expose LAM feature to userspace VMM
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-7-binbin.wu@linux.intel.com>
 <e019ba47ddadfe4aec2f11e7f0b360f0bb352180.camel@intel.com>
In-Reply-To: <e019ba47ddadfe4aec2f11e7f0b360f0bb352180.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/7/2023 11:52 AM, Huang, Kai wrote:
> On Tue, 2023-06-06 at 17:18 +0800, Binbin Wu wrote:
>> From: Robert Hoo<robert.hu@linux.intel.com>
>>
>> LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
>> Expose the feature to userspace as the final step after the following
>> supports:
>> - CR4.LAM_SUP virtualization
>> - CR3.LAM_U48 and CR3.LAM_U57 virtualization
>> - Check and untag 64-bit linear address when LAM applies in instruction
>>    emulations and VMExit handlers.
>>
>> LAM support in SGX enclave mode needs additional enabling and is not
>> included in this patch series.
> "needs additional enabling" may not be accurate.  Just say:
>
> Exposing SGX LAM support is not supported yet.  SGX LAM support is enumerated in
> SGX's own CPUID and there's no hard requirement that it must be supported when
> LAM is reported in CPUID leaf 0x7.
> ?
>
> Or have you found the answer to above question that I asked in previous series.
Sorry for late response.
It's just got confirmed that there is _NO_ hard requirement that SGX LAM 
must be supported when LAM is reported in CPUID leaf 0x7.
The changelog you suggeusted above is right and LGTM. Thanks.

And another question "Is it possible that 
CPUID.(EAX=12H,ECX=1):EAX[9:8]=0x3, while CPUID.7.1:EAX.LAM[bit 26] is 0?"
No certain answer yet. Will figure it out before adding SGX LAM support.

> Anyway:
>
> Reviewed-by: Kai Huang<kai.huang@intel.com>
>
>> Signed-off-by: Robert Hoo<robert.hu@linux.intel.com>
>> Signed-off-by: Binbin Wu<binbin.wu@linux.intel.com>
>> Reviewed-by: Jingqi Liu<jingqi.liu@intel.com>
>> Reviewed-by: Chao Gao<chao.gao@intel.com>
>> Tested-by: Xuelian Guo<xuelian.guo@intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 241f554f1764..166243fb5705 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -643,7 +643,7 @@ void kvm_set_cpu_caps(void)
>>   	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>>   		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>>   		F(FZRM) | F(FSRS) | F(FSRC) |
>> -		F(AMX_FP16) | F(AVX_IFMA)
>> +		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
>>   	);
>>   
>>   	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,

