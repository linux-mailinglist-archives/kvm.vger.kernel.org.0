Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87AAC76F852
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 05:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjHDDTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 23:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbjHDDSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 23:18:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA624EC4;
        Thu,  3 Aug 2023 20:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691119022; x=1722655022;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p5M6mWZOrJbOzGv3rGRYdsPicseUodG6yxaSQfOLaTY=;
  b=m3lncYGDC4em4Bj7SOYyGLqWLGtt7DYvZ07Ho/E6651KIBYNwTuKrYyU
   b5rc9UMLEV4WW9Uie0c6YGpDlUbs0ko5tK0wNc9HlIgtxhSo0QRN+ckX0
   MnTo0hI6f7Ja7JExX3w9dB79t/xrNq55S94BwuMYqlnW/zB4fAHxl2d+7
   P8v9u7Rw/HbZjALz6PG4kLfKYhtKAkMA51cBooyE1iAsnKLFZF8/HmIs1
   yiXlBKyfRdvGTu+Z7BuX1KpiL5W4G1COTRgLH38yjbpjX13i6B09mU6yF
   vinu0BCfcVy6Lw6PFb/yw4TgVZ6KGA4TV+AWaJPS2MQ5TWO2eZ0Oc9Vzg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="367515880"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="367515880"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:17:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="723474212"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="723474212"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.88]) ([10.254.210.88])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:16:58 -0700
Message-ID: <ae481bea-e692-dc88-61ba-90d9ab4f9b48@linux.intel.com>
Date:   Fri, 4 Aug 2023 11:16:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 06/12] iommu: Make dev->fault_param static
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-7-baolu.lu@linux.intel.com>
 <BN9PR11MB5276BE0DB32E8E7ACD84828E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276BE0DB32E8E7ACD84828E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/3 16:08, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Thursday, July 27, 2023 1:49 PM
>>
>> @@ -4630,7 +4621,6 @@ static int intel_iommu_disable_iopf(struct device
>> *dev)
>>   	 * fault handler and removing device from iopf queue should never
>>   	 * fail.
>>   	 */
>> -	WARN_ON(iommu_unregister_device_fault_handler(dev));
>>   	WARN_ON(iopf_queue_remove_device(iommu->iopf_queue, dev));
> 
> the comment should be updated too.

Ack.

> 
>>
>>   	mutex_init(&param->lock);
>> +	param->fault_param = kzalloc(sizeof(*param->fault_param),
>> GFP_KERNEL);
>> +	if (!param->fault_param) {
>> +		kfree(param);
>> +		return -ENOMEM;
>> +	}
>> +	mutex_init(&param->fault_param->lock);
>> +	INIT_LIST_HEAD(&param->fault_param->faults);
> 
> let's also move 'partial' from struct iopf_device_param into struct
> iommu_fault_param. That logic is not specific to sva.
> 
> meanwhile probably iopf_device_param can be renamed to
> iopf_sva_param since all the remaining fields are only used by
> the sva handler.
> 
> current naming (iommu_fault_param vs. iopf_device_param) is a
> bit confusing when reading related code.

My understanding is that iommu_fault_param is for all kinds of iommu
faults. Currently they probably include recoverable IO page faults or
unrecoverable DMA faults.

While, iopf_device_param is for the recoverable IO page faults. I agree
that this naming is not specific and even confusing. Perhaps renaming it
to something like iommu_iopf_param?

Best regards,
baolu
