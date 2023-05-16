Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAC37043F7
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 05:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjEPDbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 23:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjEPDbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 23:31:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1A249DF;
        Mon, 15 May 2023 20:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684207869; x=1715743869;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B0do+1g3vcTblxJFOMtHG8mJfWB+a64BWZw/WqEvlRA=;
  b=dYDs5jVTM5gM7/lCc0F2fYJiWAZvrrgv4uQiBxaxCea9IjmnbMFVqriW
   8Fl9auMNDbaNsu7x+j+TrxrbEBAKth8PnxmRnQneeCX/dP1qlrUHO6AzW
   qcFdiTXV9X0FuCYMgw9DpCJzOkfccPRbLutK7hGFbZQPQQ3f3yEfbH7wi
   yOJlhBMeHI+ZqGTDuErWKgYMj5rgQNv+iBiQb3KiB2ex6D9BasjeLHuUN
   j+lmPVNb4fTfEhfUPY5YS3QaS79cDI5bFis3kEN9C7t79qZV4O1KguVQB
   ce2XVdyBis/HfkRn0R1YsQ2OEErr5ZOYtIGjPG/q0wJfrjYsgVBuityt3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="351403263"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="351403263"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 20:31:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="695278786"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="695278786"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.172.231]) ([10.249.172.231])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 20:30:58 -0700
Message-ID: <edad36c5-e718-a54e-596a-b086cf486b55@linux.intel.com>
Date:   Tue, 16 May 2023 11:30:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v8 6/6] KVM: x86: Expose LAM feature to userspace VMM
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-7-binbin.wu@linux.intel.com>
 <cee713c15a4d9c4b8dabe6cfd8b9e689a8bdf375.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <cee713c15a4d9c4b8dabe6cfd8b9e689a8bdf375.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/2023 8:49 PM, Huang, Kai wrote:
> On Wed, 2023-05-10 at 14:06 +0800, Binbin Wu wrote:
>> From: Robert Hoo <robert.hu@linux.intel.com>
>>
>> LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
>> Expose the feature to userspace as the final step after the following
>> supports:
>> - CR4.LAM_SUP virtualization
>> - CR3.LAM_U48 and CR3.LAM_U57 virtualization
>> - Check and untag 64-bit linear address when LAM applies in instruction
>>    emulations and VMExit handlers.
>>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
>> Reviewed-by: Chao Gao <chao.gao@intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 123bf8b97a4b..fc8286f747ac 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -664,7 +664,7 @@ void kvm_set_cpu_caps(void)
>>   	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>>   		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>>   		F(FZRM) | F(FSRS) | F(FSRC) |
>> -		F(AMX_FP16) | F(AVX_IFMA)
>> +		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
>>   	);
>>   
>>   	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
> Per spec LAM supports SGX enclave mode too (chapter 6.8 INTEL SGX INTERACTIONS).
>
> Per my read, whether you can enable LAM57 or LAM48 can be determined by bit 8
> and 9 of CPUID.(EAX=12H, ECX=01H):EAX.  There are some special rule of whether
> LAM is applied to certain linear address too, i.e. per my read SECS.BASEADDR
> isn't subject to LAM in ECREATE.
This is considered when implement patch 5, but you remind me that I 
should add the materials to describe the handling of SGX system leaf 
functions in the chagelog.


>
> My first glance to expose LAM to guest's SGX enclave is just as simple as what
> you did here -- we just need to expose the two new bits to userspace in
> KVM_GET_SUPPORTED_CPUID.
>
> But I think this can be done in a separate series,
Yes, support LAM inside SGX enclave is not included in the inital 
enabling patch series.

>   especially as the spec
> doesn't say when LAM is available in CPUID(0x7, 0x1):EAX, it will be always
> available in CPUID(0x12, 0x1).EAX.
>
> But could you help to check the hardware hehaviour whether they will always
> appear together in CPUID?
For this part, I need furtuer investigation.
Will get back to you when I get the answer.



