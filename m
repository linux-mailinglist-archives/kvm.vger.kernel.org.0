Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB23D69DBE3
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 09:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbjBUI0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 03:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbjBUI0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 03:26:43 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55ED234CA
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 00:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676967989; x=1708503989;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+5WHf6C2sT658tDHPh+X+uovNTfiwHJEASlJLSgry2U=;
  b=WEaOEsQkFECyKS7AlyB4JbQgGqpjEqg2oI3ARJhmLyVbQbisPmZtRc6p
   OkEvRqbS0/nMvFmVAJZPy6ezYR4Pn7VwdW0L/pB++a69j6Gshi7idRLzK
   OzX2wrjTvpdjFxIA7Vq29m8NmLLnxBL+0GHMAdKHOLR2YuOx4hXsy2TX6
   Z6B2naF4NevKHkCbSpg9gVai8c46XJmNnQkdF4K3EDUxOuzIuh1EPqOdA
   jrIdraLoZ4vk0meBcH1IDR+SI4ugF8aCmKt44oh0XD4UpE2/BHM6Knm1q
   Zj+rLSJ0hHB4675lb7Iq0nKqYfn6T5YlHyYpBRVAqlkhaOuh7u5AjTiFG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="418800924"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="418800924"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 00:26:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="673596385"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="673596385"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.94]) ([10.238.10.94])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 00:26:26 -0800
Message-ID: <fc84dd84-67c5-5565-b989-7e6bb9116c6e@linux.intel.com>
Date:   Tue, 21 Feb 2023 16:26:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 9/9] KVM: x86: LAM: Expose LAM CPUID to user space VMM
To:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-10-robert.hu@linux.intel.com>
 <2c7c4d73-810e-6c9c-0480-46d68dedadc8@linux.intel.com>
 <587054f9715283ef4414af64dd69cda1f7597380.camel@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <587054f9715283ef4414af64dd69cda1f7597380.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/21/2023 3:26 PM, Robert Hoo wrote:
> On Tue, 2023-02-21 at 13:47 +0800, Binbin Wu wrote:
>> On 2/9/2023 10:40 AM, Robert Hoo wrote:
>>> LAM feature is enumerated by (EAX=07H, ECX=01H):EAX.LAM[bit26].
>>>
>>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>>> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
>>> ---
>>>    arch/x86/kvm/cpuid.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index b14653b61470..79f45cbe587e 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -664,7 +664,7 @@ void kvm_set_cpu_caps(void)
>>>    
>>>    	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>>>    		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>>> F(AMX_FP16) |
>>> -		F(AVX_IFMA)
>>> +		F(AVX_IFMA) | F(LAM)
>> Do we allow to expose the LAM capability to guest when host kernel
>> disabled LAM feature (e.g. via clearcpuid)?
> No
>> May be it should be handled similarly as LA57.
>>
> You mean expose LAM to guest based on HW capability rather than host
> status?
> Why is LA57 exposure like this? unlike most features.

The special handling for LA57 is from the patch "kvm: x86: Return LA57 
feature based on hardware capability".
https://lore.kernel.org/lkml/1548950983-18458-1-git-send-email-yu.c.zhang@linux.intel.com/

The reason is host kernel may disable 5-level paging using cmdline 
parameter 'no5lvl', and it will clear the feature bit for LA57 in 
boot_cpu_data.
boot_cpu_data is queried in kvm_set_cpu_caps to derive kvm cpu cap masks.

" VMs can still benefit from extended linear address width, e.g. to 
enhance features like ASLR" even when host  doesn't use 5-level paging.
So, the patch sets LA57 based on hardware capability.

I was just wondering  whether LAM could be the similar case that the 
host disabled the feature somehow (e.g via clearcpuid), and the guest 
still want to use it.



>
> Without explicit rationality, I would tend to follow most conventions.
>
>
