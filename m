Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B544376F844
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 05:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjHDDNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 23:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbjHDDMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 23:12:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD27A5278;
        Thu,  3 Aug 2023 20:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691118622; x=1722654622;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ifI9ykdQ7oocrSyNeOcXUTl2KxrALUZ7bAa7qp62vJg=;
  b=oAEoqUqMZrOcbAjXeayI06iwNUqyImxkhwR2dne25NZfQUo1LUlpeCoh
   XeLxXmFYmH//va172zhuenAe8W4JRpokl5TWGFgQ7MeAoX9GAOlUlohOP
   8sBuPMa09jufVMZk6LJh6oNQo3MSzd9fU73OADPoh7Y23pyi91boJx+I+
   3xXuWt6v3iGEr8JABHL+A7YZj4j9si7IlrsB43xY3BentDZdH0/8xgGKw
   PYJ3QVPi1/ME3vRW2D76IEZu7pIt8LM94lsr9Kp0I8cg9vkhBgFxnChuf
   C9HVi9qU6p8rgMfYEMX90arousP6r3RMaQ6/wFns/WIcFBBMJEUStLR6v
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="401007533"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="401007533"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:10:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="729882400"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="729882400"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.88]) ([10.254.210.88])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:10:16 -0700
Message-ID: <0866104f-b070-405c-da27-71a138a10e7c@linux.intel.com>
Date:   Fri, 4 Aug 2023 11:10:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 05/12] iommu: Change the return value of
 dev_iommu_get()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-6-baolu.lu@linux.intel.com>
 <BN9PR11MB52769A468F912B7D395878ED8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52769A468F912B7D395878ED8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/3 15:59, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Thursday, July 27, 2023 1:49 PM
>>
>> Make dev_iommu_get() return 0 for success and error numbers for failure.
>> This will make the code neat and readable. No functionality changes.
>>
>> Reviewed-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/iommu.c | 19 +++++++++++--------
>>   1 file changed, 11 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 00309f66153b..4ba3bb692993 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -290,20 +290,20 @@ void iommu_device_unregister(struct
>> iommu_device *iommu)
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_device_unregister);
>>
>> -static struct dev_iommu *dev_iommu_get(struct device *dev)
>> +static int dev_iommu_get(struct device *dev)
>>   {
>>   	struct dev_iommu *param = dev->iommu;
>>
>>   	if (param)
>> -		return param;
>> +		return 0;
>>
>>   	param = kzalloc(sizeof(*param), GFP_KERNEL);
>>   	if (!param)
>> -		return NULL;
>> +		return -ENOMEM;
>>
>>   	mutex_init(&param->lock);
>>   	dev->iommu = param;
>> -	return param;
>> +	return 0;
>>   }
>>
> 
> Jason's series [1] has been queued. Time to refine according to
> the discussion in [2].
> 
> [1] https://lore.kernel.org/linux-iommu/ZLFYXlSBZrlxFpHM@8bytes.org/
> [2] https://lore.kernel.org/linux-iommu/c815fa2b-00df-91e1-8353-8258773957e4@linux.intel.com/

I'm not sure I understand your point here. This only changes the return
value of dev_iommu_get() to make the code more concise.

Best regards,
baolu
