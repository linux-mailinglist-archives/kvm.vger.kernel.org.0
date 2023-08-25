Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D19F788B83
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 16:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343598AbjHYOTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 10:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343807AbjHYOTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 10:19:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D27EE7B;
        Fri, 25 Aug 2023 07:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692973158; x=1724509158;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XlJ5BTZzpqkEXXAdCvRXhAbBmjekbNjP7CxSWawHat0=;
  b=RmLG0lzNmrP7iNj84KCO7/LSosAErPJem4lKzt0OOrh6Z4qxh9R+4h99
   XaQ9BxEboiRvE7RuSFJdC+jUMZlrXfmK0rMu3NUS0UtikdiguKNHbZ78R
   k74cO9m9uEUyR39oDFBxUhpnWs7R7+OQ7/eU4La+8DUpINpaI0LACiDt9
   p2mDAVop1ozplzfCBD2JZCVFfw7afGg5CGC+bC2X2enL9t+ZyhTa8m5+R
   UH981nOcS/ePSbQ7R8fR/W3hFsrZJu/AlxeHMHcqaAKNO6yl969cKqCCD
   tTkFwtkDUWajJUd3yHdOcUE/eY0ajbvRB8Fhxx9P8NORVJUpf0hPgfUd4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="374698242"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="374698242"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 07:19:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="1068255444"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="1068255444"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.249.169.63]) ([10.249.169.63])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 07:19:15 -0700
Message-ID: <873ccab4-1470-3ff0-2e59-01d1110809be@intel.com>
Date:   Fri, 25 Aug 2023 22:18:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 0/9] Linear Address Masking (LAM) KVM Enabling
To:     Sean Christopherson <seanjc@google.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "David.Laight@aculab.com" <David.Laight@aculab.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <ZN1M5RvuARP1YMfp@google.com>
 <6e990b88-1e28-9563-2c2f-0d5d52f9c7ca@linux.intel.com>
 <e4aa03cb-0f80-bd5f-f69e-39b636476f00@linux.intel.com>
 <ZN93wp9lgmuJqYIA@google.com>
Content-Language: en-US
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <ZN93wp9lgmuJqYIA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/18/2023 9:53 PM, Sean Christopherson wrote:
> On Fri, Aug 18, 2023, Binbin Wu wrote:
>> On 8/17/2023 5:17 PM, Binbin Wu wrote:
>>> On 8/17/2023 6:25 AM, Sean Christopherson wrote:
>>>> On Wed, Jul 19, 2023, Binbin Wu wrote:
>>>>> Binbin Wu (7):
>>>>>     KVM: x86/mmu: Use GENMASK_ULL() to define __PT_BASE_ADDR_MASK
>>>>>     KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
>>>>>     KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
>>>>>     KVM: x86: Virtualize CR3.LAM_{U48,U57}
>>>>>     KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and
>>>>> call it in
>>>>>       emulator
>>>>>     KVM: VMX: Implement and wire get_untagged_addr() for LAM
>>>>>     KVM: x86: Untag address for vmexit handlers when LAM applicable
>>>>>
>>>>> Robert Hoo (2):
>>>>>     KVM: x86: Virtualize CR4.LAM_SUP
>>>>>     KVM: x86: Expose LAM feature to userspace VMM
>>>> Looks good, just needs a bit of re-organination.  Same goes for the
>>>> LASS series.
>>>>
>>>> For the next version, can you (or Zeng) send a single series for LAM
>>>> and LASS?
>>>> They're both pretty much ready to go, i.e. I don't expect one to
>>>> hold up the other
>>>> at this point, and posting a single series will reduce the
>>>> probability of me
>>>> screwing up a conflict resolution or missing a dependency when applying.
>>>>
>> Hi Sean,
>> Do you still prefer a single series for LAM and LASS  for the next version
>> when we don't need to rush for v6.6?
> Yes, if it's not too much trouble on your end.  Since the two have overlapping
> prep work and concepts, and both series are in good shape, my strong preference
> is to grab them at the same time.  I would much rather apply what you've tested
> and reduce the probability of messing up any conflicts.
>
>
>
Hi Sean,
One more concern, KVM LASS patch has an extra dependency on kernel LASS 
series in which
enumerates lass feature bit (X86_FEATURE_LASS/X86_CR4_LASS). So far 
kernel lass patch is
still under review, as alternative we may extract relevant patch part 
along with kvm lass patch
set for a single series in case kernel lass cannot be merged before v6.7.
Do you think it OK in that way?

