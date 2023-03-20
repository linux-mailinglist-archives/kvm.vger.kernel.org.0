Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FB66C1421
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 14:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjCTN4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 09:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjCTN4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 09:56:30 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B90A24707
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 06:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679320579; x=1710856579;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=KJtZ1QCCHTUbkLuMTaLTYhAwwP+jbi68WXCNLjQe59o=;
  b=M1hu2oOOfnEk+tGKHFhLqSj/FY8df7qBGW8BtNiD4Ep5p1xg04P++mlb
   iKz6BthtijPRJ+KVZk2FE58WzsFZR7M5a49oErxFrLutcbmxfNnNwgcxw
   jcX42CicgVwyOyruSOgKWOpLBFH6ywK91/+3o01D4aoIUgY1ujvI0Ryhh
   9EeuvDqOaJ+qlr6claup729sKQL/clm3df2OImLoa4m0v84lys7lMT/uJ
   Sl/IOsHJ5TLYHFbioVxJ/AhN6cKwL+Mko9H/amB8WnVix87+lchvwcQVO
   aef80k197HUgp4n506q7zTeaWtt8UOk8sU2xXPGIBct6HFp0OK8JmFFAE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="366385441"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="366385441"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 06:56:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="681073237"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="681073237"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.172.177]) ([10.249.172.177])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 06:56:17 -0700
Message-ID: <4ff37ff4-b89e-8683-f6ea-865211ae01d2@linux.intel.com>
Date:   Mon, 20 Mar 2023 21:56:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v5 2/5] [Trivial]KVM: x86: Explicitly cast ulong to bool
 in kvm_set_cr3()
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Gao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-3-robert.hu@linux.intel.com>
 <ZABPFII40v1nQ2EV@gao-cwp>
 <9db9bd3a2ade8c436a8b9ab6f61ee8dafa2e072a.camel@linux.intel.com>
 <ZAuRec2NkC3+4jvD@google.com>
 <75f628e3-9621-ac9e-a258-33efc7ce56af@linux.intel.com>
In-Reply-To: <75f628e3-9621-ac9e-a258-33efc7ce56af@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/20/2023 8:05 PM, Binbin Wu wrote:
>
> On 3/11/2023 4:22 AM, Sean Christopherson wrote:
>> As Chao pointed out, this does not belong in the LAM series.  And 
>> FWIW, I highly
>> recommend NOT tagging things as Trivial.  If you're wrong and the 
>> patch _isn't_
>> trivial, it only slows things down.  And if you're right, then 
>> expediting the
>> patch can't possibly be necessary.
>>
>> On Fri, Mar 03, 2023, Robert Hoo wrote:
>>> On Thu, 2023-03-02 at 15:24 +0800, Chao Gao wrote:
>>>>> -    bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>>>>> +    bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>>>>>
>>>>>     if (pcid_enabled) {
>>>>>         skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
>>>> pcid_enabled is used only once. You can drop it, i.e.,
>>>>
>>>>     if (kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)) {
>>>>
>>> Emm, that's actually another point.
>>> Though I won't object so, wouldn't this be compiler optimized?
>>>
>>> And my point was: honor bool type, though in C implemention it's 0 and
>>> !0, it has its own type value: true, false.
>>> Implicit type casting always isn't good habit.
>> I don't disagree, but I also don't particularly want to "fix" one 
>> case while
>> ignoring the many others, e.g. kvm_handle_invpcid() has the exact 
>> same "buggy"
>> pattern.
>>
>> I would be supportive of a patch that adds helpers and then converts 
>> all of the
>> relevant CR0/CR4 checks though...
>
> Hi Sean, I can cook a patch by your suggesion and sent out the patch 
> seperately.

Sean, besides the call of kvm_read_cr0_bits() and kvm_read_cr4_bits(), 
there are also a lot checks in if statement like
if ( cr4 & X86_CR4_XXX )
or
if ( cr0 & X86_CR0_XXX )
I suppose these usages are OK, right?


>
>
>>
>> diff --git a/arch/x86/kvm/kvm_cache_regs.h 
>> b/arch/x86/kvm/kvm_cache_regs.h
>> index 4c91f626c058..6e3cb958afdd 100644
>> --- a/arch/x86/kvm/kvm_cache_regs.h
>> +++ b/arch/x86/kvm/kvm_cache_regs.h
>> @@ -157,6 +157,14 @@ static inline ulong kvm_read_cr0_bits(struct 
>> kvm_vcpu *vcpu, ulong mask)
>>          return vcpu->arch.cr0 & mask;
>>   }
>>   +static __always_inline bool kvm_is_cr0_bit_set(struct kvm_vcpu *vcpu,
>> +                                              unsigned long cr0_bit)
>> +{
>> +       BUILD_BUG_ON(!is_power_of_2(cr0_bit));
>> +
>> +       return !!kvm_read_cr0_bits(vcpu, cr0_bit);
>> +}
>> +
>>   static inline ulong kvm_read_cr0(struct kvm_vcpu *vcpu)
>>   {
>>          return kvm_read_cr0_bits(vcpu, ~0UL);
>> @@ -178,6 +186,14 @@ static inline ulong kvm_read_cr3(struct kvm_vcpu 
>> *vcpu)
>>          return vcpu->arch.cr3;
>>   }
>>   +static __always_inline bool kvm_is_cr4_bit_set(struct kvm_vcpu *vcpu,
>> +                                              unsigned long cr4_bit)
>> +{
>> +       BUILD_BUG_ON(!is_power_of_2(cr4_bit));
>> +
>> +       return !!kvm_read_cr4_bits(vcpu, cr4_bit);
>> +}
>> +
