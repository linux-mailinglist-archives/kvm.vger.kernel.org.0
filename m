Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E372783B17
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 09:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbjHVHmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 03:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjHVHms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 03:42:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E98198;
        Tue, 22 Aug 2023 00:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692690166; x=1724226166;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PtfQlBNpQEHy7YglStwyz4T6JAjzzd90JE4ZiwNrUUI=;
  b=Dv54Nnu70iQjEoeWMY4044tPs1kZ3vXgVd8Y8GxW91lF5VA4E3BnKCNA
   pRpdOm0V6dZVloeLLhvg5oLIbm2DRB5q0nio/c3SAgE4djZYy9+oo3Qmj
   kTRFsKwLW1xBudQzMxfD5oHofXlPlQTwRNF2yTiXdryF62NRgFxRpyOeg
   nHTljIr+3diZSIjF6DWeLQzv9qwNHbLkklOUOH8TP/LF4ZR84cRxZ2mkx
   BKWS2rrBYUKAQQM/MbcjpGP0BaLG7mOJztAkpQTxN7Eg/3lb8ZWWxGHm8
   GriS0I3q6YBTnnyWiyzXLEETX2QOGrMFzQBv0XRpiehkSDafT5zAYFUjr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="440176174"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="440176174"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 00:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="771268894"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="771268894"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.189.107]) ([10.252.189.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 00:42:41 -0700
Message-ID: <ed0c0d2b-dee0-dd43-dee4-a73a46686168@linux.intel.com>
Date:   Tue, 22 Aug 2023 15:42:37 +0800
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
Subject: Re: [PATCH v3 05/11] iommu: Merge iopf_device_param into
 iommu_fault_param
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230817234047.195194-1-baolu.lu@linux.intel.com>
 <20230817234047.195194-6-baolu.lu@linux.intel.com>
 <ZOOZJ/aQNKY2UDxj@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZOOZJ/aQNKY2UDxj@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/22 1:04, Jason Gunthorpe wrote:
> On Fri, Aug 18, 2023 at 07:40:41AM +0800, Lu Baolu wrote:
>> @@ -472,21 +473,31 @@ struct iommu_fault_event {
>>    * struct iommu_fault_param - per-device IOMMU fault data
>>    * @handler: Callback function to handle IOMMU faults at device level
>>    * @data: handler private data
>> - * @faults: holds the pending faults which needs response
>>    * @lock: protect pending faults list
>> + * @dev: the device that owns this param
>> + * @queue: IOPF queue
>> + * @queue_list: index into queue->devices
>> + * @partial: faults that are part of a Page Request Group for which the last
>> + *           request hasn't been submitted yet.
>> + * @faults: holds the pending faults which needs response
>>    */
>>   struct iommu_fault_param {
>>   	iommu_dev_fault_handler_t handler;
>>   	void *data;
>> -	struct list_head faults;
>> -	struct mutex lock;
>> +	struct mutex			lock;
>> +
>> +	struct device			*dev;
>> +	struct iopf_queue		*queue;
>> +	struct list_head		queue_list;
>> +
>> +	struct list_head		partial;
>> +	struct list_head		faults;
>>   };
> Don't add the horizontal spaces

Fixed. Thanks!

Best regards,
baolu
