Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5721851287C
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 03:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiD1BK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 21:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiD1BKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 21:10:55 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1A76A064;
        Wed, 27 Apr 2022 18:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651108062; x=1682644062;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2gBxdgt48nj77jzRla0ic/dl45U8oWm98zru5apAGlA=;
  b=jV3o/oRDzfSVeSwkYHfKYXOC9Ta1Zi97+hTCtD4vgpNekXxYmA06kli5
   Te+h4hsawr+M0waL160hOZ5HSl/5aplTJcjhHqyJ/7q6aNn0ytVMkYyFM
   C1hxyH2cIen6sTJq2eDjMNTiAjlCAqeRsJMecpFLZjbjjHboDviqgxvR8
   5YMjW+XPi19bGGEJONse5rDxpxj58J3mJR8j+qN8Xocv62PgeFoSjbde8
   Ia9pX0SnbNK7gQgaZL44scHaynW7VINFfmKrsGqVlw17+nF10fsXU/RMG
   TYVZ9Hxdted6U32CGqMtwyOdEURNhh6ElzlzXR89uZQA+YO/ETLR9B1CG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="253503506"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="253503506"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 18:07:42 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="513988230"
Received: from lcdaughe-mobl1.amr.corp.intel.com (HELO [10.212.72.252]) ([10.212.72.252])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 18:07:41 -0700
Message-ID: <1624e839-81e5-7bc7-533b-c5c838d35f47@intel.com>
Date:   Wed, 27 Apr 2022 18:07:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 10/21] x86/virt/tdx: Add placeholder to coveret all
 system RAM as TDX memory
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <6230ef28be8c360ab326c8f592acf1964ac065c1.1649219184.git.kai.huang@intel.com>
 <d69c08da-80fa-2001-bbe8-8c45552e74ae@intel.com>
 <228cfa7e5326fa378c1dde2b5e9022146f97b706.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <228cfa7e5326fa378c1dde2b5e9022146f97b706.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 17:53, Kai Huang wrote:
> On Wed, 2022-04-27 at 15:24 -0700, Dave Hansen wrote:
>> On 4/5/22 21:49, Kai Huang wrote:
>>> TDX provides increased levels of memory confidentiality and integrity.
>>> This requires special hardware support for features like memory
>>> encryption and storage of memory integrity checksums.  Not all memory
>>> satisfies these requirements.
>>>
>>> As a result, TDX introduced the concept of a "Convertible Memory Region"
>>> (CMR).  During boot, the firmware builds a list of all of the memory
>>> ranges which can provide the TDX security guarantees.  The list of these
>>> ranges, along with TDX module information, is available to the kernel by
>>> querying the TDX module.
>>>
>>> In order to provide crypto protection to TD guests, the TDX architecture
>>
>> There's that "crypto protection" thing again.  I'm not really a fan of
>> the changes made to this changelog since I wrote it. :)
> 
> Sorry about that.  I'll remove "In order to provide crypto protection to TD
> guests".

Seriously, though.  I took the effort to write these changelogs for you.
 They were fine.  I'm not stoked about needing to proofread them again.

>>> also needs additional metadata to record things like which TD guest
>>> "owns" a given page of memory.  This metadata essentially serves as the
>>> 'struct page' for the TDX module.  The space for this metadata is not
>>> reserved by the hardware upfront and must be allocated by the kernel
>>
>> 			    ^ "up front"
> 
> Thanks will change to "up front".
> 
> Btw, the gmail grammar check gives me a red line if I use "up front", but it
> doesn't complain "upfront".

I'm pretty sure it's wrong.  "up front" is an adverb that applies to
"reserved".  "Upfront" is an adjective and not how you used it in that
sentence.

>>> +	 * allocated individually within construct_tdmrs() to meet
>>> +	 * this requirement.
>>> +	 */
>>> +	tdmr_array = kcalloc(tdx_sysinfo.max_tdmrs, sizeof(struct tdmr_info *),
>>> +			GFP_KERNEL);
>>
>> Where, exactly is that alignment provided?  A 'struct tdmr_info *' is 8
>> bytes so a tdx_sysinfo.max_tdmrs=8 kcalloc() would only guarantee
>> 64-byte alignment.
> 
> The entries in the array only contain a pointer to TDMR_INFO.  The actual
> TDMR_INFO is allocated separately. The array itself is never used by TDX
> hardware so it doesn't matter.  We just need to guarantee each TDMR_INFO is
> 512B-byte aligned.

The comment was clear as mud about this.  If you're going to talk about
alignment, then do it near the allocation that guarantees the alignment,
not in some other function near *ANOTHER* allocation.

Also, considering that you're about to go allocate potentially gigabytes
of physically contiguous memory, it seems laughable that you'd go to any
trouble at all to allocate an array of pointers here.  Why not just

	kcalloc(tdx_sysinfo.max_tdmrs, sizeof(struct tmdr_info), ...);

Or, heck, just vmalloc() the dang thing.  Why even bother with the array
of pointers?


>>> +	if (!tdmr_array) {
>>> +		ret = -ENOMEM;
>>> +		goto out;
>>> +	}
>>> +
>>> +	/* Construct TDMRs to build TDX memory */
>>> +	ret = construct_tdmrs(tdmr_array, &tdmr_num);
>>> +	if (ret)
>>> +		goto out_free_tdmrs;
>>> +
>>>  	/*
>>>  	 * Return -EFAULT until all steps of TDX module
>>>  	 * initialization are done.
>>>  	 */
>>>  	ret = -EFAULT;
>>
>> There's the -EFAULT again.  I'd replace these with a better error code.
> 
> I couldn't think out a better error code.  -EINVAL looks doesn't suit.  -EAGAIN
> also doesn't make sense for now since we always shutdown the TDX module in case
> of any error so caller should never retry.  I think we need some error code to
> tell "the job isn't done yet".  Perhaps -EBUSY?

Is this going to retry if it sees -EFAULT or -EBUSY?
