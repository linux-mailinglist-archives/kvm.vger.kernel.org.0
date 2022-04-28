Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AD9512A14
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 05:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242441AbiD1Dnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 23:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242433AbiD1Dnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 23:43:32 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDB17DAA9;
        Wed, 27 Apr 2022 20:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651117219; x=1682653219;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ry+D9wOFPYRYyUqTM70lgrXgYZpSpKUu24sZAW7i480=;
  b=PHDkpEPXb2eLtO5ZAOR/fPvt6VR5oAO4vVDEeCvZieDT53KJ+rRKp8dZ
   Hl0O6UrDgELQUVAlT69Pxtme/itYHL7XBeuJ6+lPd+7Jcb9G2x58tq7rP
   RTUx/wSfp1EdrEvLHG8rHWWuo5MEp1PJoXZb28KGOyB5ArTplgoezVYfi
   ILGmmbykslAZD42AKNBuZrGd5OhNBE4r3DtbKHkjHc/+zAEDLa7GNOUOc
   qsA+rjrUzG/Zkz1693LUG1ERGkK/B+Dig0KJAAi3szS7XnR5GzCdRO0j4
   8t7gu5mYvSVX75fbepyfFHHlKKmniTjVvrbtlj20JJvtk+Fc9T53rob8/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="265673700"
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="265673700"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 20:40:18 -0700
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="731166522"
Received: from lcdaughe-mobl1.amr.corp.intel.com (HELO [10.212.72.252]) ([10.212.72.252])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 20:39:53 -0700
Message-ID: <73c8e61c-1057-a3ff-904d-6b7ddaaac83b@intel.com>
Date:   Wed, 27 Apr 2022 20:40:09 -0700
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
 <1624e839-81e5-7bc7-533b-c5c838d35f47@intel.com>
 <a6fb489700ce00fcb32a670a2fd7bf99a113d878.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a6fb489700ce00fcb32a670a2fd7bf99a113d878.camel@intel.com>
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

On 4/27/22 18:35, Kai Huang wrote:
> On Wed, 2022-04-27 at 18:07 -0700, Dave Hansen wrote:
>> Also, considering that you're about to go allocate potentially gigabytes
>> of physically contiguous memory, it seems laughable that you'd go to any
>> trouble at all to allocate an array of pointers here.  Why not just
>>
>> 	kcalloc(tdx_sysinfo.max_tdmrs, sizeof(struct tmdr_info), ...);
> 
> kmalloc() guarantees the size-alignment if the size is power-of-two.  TDMR_INFO
> (512-bytes) itself is  power of two, but the 'max_tdmrs x sizeof(TDMR_INFO)' may
> not be power of two.  For instance, when max_tdmrs == 3, the result is not
> power-of-two.
> 
> Or am I wrong? I am not good at math though.

No, you're right, the kcalloc() wouldn't work for odd sizes.

But, the point is still that you don't need an array of pointers.  Use
vmalloc().  Use a plain old alloc_pages_exact().  Why bother wasting
the memory and addiong the complexity of an array of pointers?

>> Or, heck, just vmalloc() the dang thing.  Why even bother with the array
>> of pointers?
>>
>>
>>>>> +	if (!tdmr_array) {
>>>>> +		ret = -ENOMEM;
>>>>> +		goto out;
>>>>> +	}
>>>>> +
>>>>> +	/* Construct TDMRs to build TDX memory */
>>>>> +	ret = construct_tdmrs(tdmr_array, &tdmr_num);
>>>>> +	if (ret)
>>>>> +		goto out_free_tdmrs;
>>>>> +
>>>>>  	/*
>>>>>  	 * Return -EFAULT until all steps of TDX module
>>>>>  	 * initialization are done.
>>>>>  	 */
>>>>>  	ret = -EFAULT;
>>>>
>>>> There's the -EFAULT again.  I'd replace these with a better error code.
>>>
>>> I couldn't think out a better error code.  -EINVAL looks doesn't suit.  -EAGAIN
>>> also doesn't make sense for now since we always shutdown the TDX module in case
>>> of any error so caller should never retry.  I think we need some error code to
>>> tell "the job isn't done yet".  Perhaps -EBUSY?
>>
>> Is this going to retry if it sees -EFAULT or -EBUSY?
> 
> No.  Currently we always shutdown the module in case of any error.  Caller won't
> be able to retry.
> 
> In the future, this can be optimized.  We don't shutdown the module in case of
> *some* error (i.e. -ENOMEM), but record an internal state when error happened,
> so the caller can retry again.  For now, there's no retry.

Just make the error codes -EINVAL, please.  I don't think anything else
makes sense.

