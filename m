Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C4977850A
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 03:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjHKBnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 21:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjHKBnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 21:43:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AEB2690;
        Thu, 10 Aug 2023 18:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691718194; x=1723254194;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VpNe3KG6YE2UxMhHpsSTPKnMAYPUPp2Qol79EMM11+4=;
  b=CPy1efQQCgdZ7sZhW+O86b555eM4vJi27F6ZKOztwkj8FEOU7QwYzhRB
   bby19sjyBa645QTtjmvEriyTawPy0TGp8gcnkiAN31I0pB0kiB8a+W1QD
   QTXXMlYdOtW4lhMalNUJ2XW4yxLL/F00OlAGi5kY6QuOLhFZBHeJFpEjm
   2ATFwKq2xMdGekZCrRLrX1YGoUm3ELgbxVLbSLnZHDbAlP6aWwqrw2ZBg
   73DYTldi+CutQcrESd2znxBIQDH4n+QBlaNqb09bzQqhead6Ir5dS14YR
   bx2c8pNTtouAsuiwTynt7vU5p+C6PO35SpZRPqBjvY7Ho7TUvXmHDaj5t
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="402537879"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="402537879"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:43:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="762010588"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="762010588"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.214.70]) ([10.254.214.70])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:43:10 -0700
Message-ID: <621683c0-ad01-22ff-dbf9-4edb27f42640@linux.intel.com>
Date:   Fri, 11 Aug 2023 09:43:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/12] iommu: Make dev->fault_param static
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-7-baolu.lu@linux.intel.com>
 <ZNUqV5Mte2AsVa1L@ziepe.ca> <ZNUwgjJ+2GHf2MOW@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZNUwgjJ+2GHf2MOW@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/11 2:46, Jason Gunthorpe wrote:
> On Thu, Aug 10, 2023 at 03:20:07PM -0300, Jason Gunthorpe wrote:
>> On Thu, Jul 27, 2023 at 01:48:31PM +0800, Lu Baolu wrote:
>>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>>> index 4ba3bb692993..3e4ff984aa85 100644
>>> --- a/drivers/iommu/iommu.c
>>> +++ b/drivers/iommu/iommu.c
>>> @@ -302,7 +302,15 @@ static int dev_iommu_get(struct device *dev)
>>>   		return -ENOMEM;
>>>   
>>>   	mutex_init(&param->lock);
>>> +	param->fault_param = kzalloc(sizeof(*param->fault_param), GFP_KERNEL);
>>> +	if (!param->fault_param) {
>>> +		kfree(param);
>>> +		return -ENOMEM;
>>> +	}
>>> +	mutex_init(&param->fault_param->lock);
>>> +	INIT_LIST_HEAD(&param->fault_param->faults);
>>>   	dev->iommu = param;
>> This allocation seems pointless?
>>
>> If we always allocate the fault param then just don't make it a
>> pointer in the first place.
>>
>> The appeal of allocation would be to save a few bytes in the common
>> case that the driver doesn't support faulting.
>>
>> Which means the driver needs to make some call to enable faulting for
>> a device. In this case I'd continue to lazy free on release like this
>> patch does.
> For instance allocate the fault_param in iopf_queue_add_device() which
> is the only thing that needs it.
> 
> Actually probably just merge struct iopf_device_param and
> iommu_fault_param ?
> 
> When you call iopf_queue_add_device() it enables page faulting mode,
> does 1 additional allocation for all additional required per-device
> memory and thats it.

Agreed.

I originally kept the iommu_fault_param structure because I thought it
could also be used to store temporary data for unrecoverable faults,
just like the iopf_device_param structure is used for iopf. However, I
am not sure whether we actually need any temporary data for
unrecoverable fault forwarding, which doesn't require any response.

So, it's better to do like you suggested. It's cleaner and simpler.

Best regards,
baolu

