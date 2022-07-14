Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFA2574218
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 06:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiGNEKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 00:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGNEKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 00:10:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED4D25286;
        Wed, 13 Jul 2022 21:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657771801; x=1689307801;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xgW+RSwfAkGWbvNjSF0gjO7vzwiF7RQdF9S7yWDKep8=;
  b=M7+5brGzyd8YvBJ7+zdcGbYN9u7ZEgiWiXwaUKfSxv+b+xTW6LlGy96o
   sXkaV4ssqznG2C3B/Yn+JIV9K7rVpIl7X2du+w8vMz5uHVcP0SvgFoJIi
   RoADaTv4Q8+xjhv61mh34aGy0+eAOZi8Uk8cvlJhll6uiMXvLfWxXnBDc
   sPxOirUjI0eYokVyR7J4bFOYxJISH8nA0n9Gh8wNGA8X3hA9gBISnBGul
   ZboDSn7d1EjkOyR3rJuJs9/RwFor8PQYilFm6FNTe07qP+YxcvmcWlAtq
   AuP5n2OWVDEYDiKspwok30YODBfuVsxliadO6z4llMrgDLCTH1ovQ8old
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="311057966"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="311057966"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 21:10:01 -0700
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="663625782"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.170.180]) ([10.249.170.180])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 21:10:00 -0700
Message-ID: <dc2cfd5e-8212-dfc7-28cd-9e3a1d63c638@intel.com>
Date:   Thu, 14 Jul 2022 12:09:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <Ys9rcnyIZlUc76iG@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Ys9rcnyIZlUc76iG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/2022 9:03 AM, Sean Christopherson wrote:
> On Mon, Jun 27, 2022, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> KVM TDX basic feature support
>>
>> Hello.  This is v7 the patch series vof KVM TDX support.
>> This is based on v5.19-rc1 + kvm/queue branch + TDX HOST patch series.
>> The tree can be found at https://github.com/intel/tdx/tree/kvm-upstream
>> How to run/test: It's describe at https://github.com/intel/tdx/wiki/TDX-KVM
>>
>> Major changes from v6:
>> - rebased to v5.19 base
>>
>> TODO:
>> - integrate fd-based guest memory. As the discussion is still on-going, I
>>    intentionally dropped fd-based guest memory support yet.  The integration can
>>    be found at https://github.com/intel/tdx/tree/kvm-upstream-workaround.
>> - 2M large page support. It's work-in-progress.
>> For large page support, there are several design choices. Here is the design options.
>> Any thoughts/feedback?
> 
> Apologies, I didn't read beyond the intro paragraph.  In case something like this
> comes up again, it's probably best to send a standalone email tagged RFC, I doubt
> I'm the only one that missed this embedded RFC.
> 
>> KVM MMU Large page support for TDX
>   
> ...
> 
>> * options to track private or shared
>> At each page size (4KB, 2MB, and 1GB), track private, shared, or mixed (2MB and
>> 1GB case). For 4KB each page, 1 bit per page is needed. private or shared.  For
>> large pages (2MB and 1GB), 2 bits per large page is needed. (private, shared, or
>> mixed).  When resolving KVM page fault, we don't want to check the lower-size
>> pages to check if the given GPA can be a large for performance.  On MapGPA check
>> it instead.
>>
>> Option A). enhance kvm_arch_memory_slot
>>    enum kvm_page_type {
>>         KVM_PAGE_TYPE_INVALID,
>>         KVM_PAGE_TYPE_SHARED,
>>         KVM_PAGE_TYPE_PRIVATE,
>>         KVM_PAGE_TYPE_MIXED,
>>    };
>>
>>    struct kvm_page_attr {
>>         enum kvm_page_type type;
>>    };
>>
>>   struct kvm_arch_memory_slot {
>>   +      struct kvm_page_attr *page_attr[KVM_NR_PAGE_SIZES];
>>
>> Option B). steal one more bit SPTE_MIXED_MASK in addition to SPTE_SHARED_MASK
>> If !SPTE_MIXED_MASK, it can be large page.

I don't think this is a good option, since it requires all the mappings 
exist all the time both in shared spte tree and private spte tree.

>> Option C). use SPTE_SHARED_MASK and kvm_mmu_page::mixed bitmap
>> kvm_mmu_page::mixed bitmap of 1GB, root indicates mixed for 2MB, 1GB.
>>
>>
>> * comparison
>> A).
>> + straightforward to implement
>> + SPTE_SHARED_MASK isn't needed
>> - memory overhead compared to B). or C).
>> - more memory reference on KVM page fault
>>
>> B).
>> + simpler than C) (complex than A)?)
>> + efficient on KVM page fault. (only SPTE reference)
>> + low memory overhead
>> - Waste precious SPTE bits.
>>
>> C).
>> + efficient on KVM page fault. (only SPTE reference)
>> + low memory overhead
>> - complicates MapGPA
>> - scattered data structure
> 
> Option D). track shared regions in an Xarray, update kvm_arch_memory_slot.lpage_info
> on insertion/removal to (dis)allow hugepages as needed.

UPM v7[1] introduces "struct xarray mem_attr_array" to track the 
shared/private attr of a range.

So in kvm_vm_ioctl_set_encrypted_region() it needs to

- increase the lpage_info counter when a 2m/1g range changed from 
identical to mixed, and

- decrease the counter when mixed -> identical

[1]: 
https://lore.kernel.org/all/20220706082016.2603916-12-chao.p.peng@linux.intel.com/

> 
>    + efficient on KVM page fault (no new lookups)
>    + zero memory overhead (assuming KVM has to eat the cost of the Xarray anyways)
>    + straightforward to implement
>    + can (and should) be merged as part of the UPM series
> 
> I believe xa_for_each_range() can be used to see if a given 2mb/1gb range is
> completely covered (fully shared) or not covered at all (fully private), but I'm
> not 100% certain that xa_for_each_range() works the way I think it does.

