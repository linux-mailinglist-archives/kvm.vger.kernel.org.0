Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBDF4C8151
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 03:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiCAC4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 21:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiCAC4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 21:56:31 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F222F026;
        Mon, 28 Feb 2022 18:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646103352; x=1677639352;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/z7xcV6dl5VH6iMxyI/FmOZYADVup3Kf2UPfn1iS7uU=;
  b=WC7OMSMeOs4NLtfBcS/hP7TP9X4MgwzjjPwd/Vmlr5x3qRsg9TP5ONNp
   GKQ8ejVVR9Wl72dCrroXGPXm9N64Icc6zaU+U6ciFOqKmS3CqYr6toikd
   VQpTGzG+q0ZpvhRZ32hF8B8UI7tZr10ZBAdAEkYxT2/pzpqu4VobV4bY3
   QPO3LdE1co+G4JMZEKSIOBanf2ULSKekfNxwxLMu0hA1g0rXEctcdtrQc
   M1D++CQoy6SFU//ZhUtpj9DJT8KKgW8hsjiHJyrxqe5OGahPUyKAkFCiM
   vPz36h1xC3/SaMJuZY/u6FpGaohE/IPnEWmCOhPhpDTB3iPRyuQej23GM
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="253233751"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="253233751"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:55:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="534724101"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga007.jf.intel.com with ESMTP; 28 Feb 2022 18:55:43 -0800
Message-ID: <80672557-59ab-8eb9-2fcf-d045ff52104b@linux.intel.com>
Date:   Tue, 1 Mar 2022 10:54:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v7 06/11] PCI: portdrv: Set driver_managed_dma
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20220228195628.GA515785@bhelgaas>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220228195628.GA515785@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

On 3/1/22 3:56 AM, Bjorn Helgaas wrote:
> On Mon, Feb 28, 2022 at 08:50:51AM +0800, Lu Baolu wrote:
>> If a switch lacks ACS P2P Request Redirect, a device below the switch can
>> bypass the IOMMU and DMA directly to other devices below the switch, so
>> all the downstream devices must be in the same IOMMU group as the switch
>> itself.
>>
>> The existing VFIO framework allows the portdrv driver to be bound to the
>> bridge while its downstream devices are assigned to user space. The
>> pci_dma_configure() marks the IOMMU group as containing only devices
>> with kernel drivers that manage DMA. Avoid this default behavior for the
>> portdrv driver in order for compatibility with the current VFIO usage.
> 
> It would be nice to explicitly say here how we can look at portdrv
> (and pci_stub) and conclude that ".driver_managed_dma = true" is safe.
> 
> Otherwise I won't know what kind of future change to portdrv might
> make it unsafe.

Fair enough. We can add below words:

We achieve this by setting ".driver_managed_dma = true" in pci_driver
structure. It is safe because the portdrv driver meets below criteria:

- This driver doesn't use DMA, as you can't find any related calls like
   pci_set_master() or any kernel DMA API (dma_map_*() and etc.).
- It doesn't use MMIO as you can't find ioremap() or similar calls. It's
   tolerant to userspace possibly also touching the same MMIO registers
   via P2P DMA access.

> 
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Suggested-by: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thank you!

Best regards,
baolu

> 
>> ---
>>   drivers/pci/pcie/portdrv_pci.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
>> index 35eca6277a96..6b2adb678c21 100644
>> --- a/drivers/pci/pcie/portdrv_pci.c
>> +++ b/drivers/pci/pcie/portdrv_pci.c
>> @@ -202,6 +202,8 @@ static struct pci_driver pcie_portdriver = {
>>   
>>   	.err_handler	= &pcie_portdrv_err_handler,
>>   
>> +	.driver_managed_dma = true,
>> +
>>   	.driver.pm	= PCIE_PORTDRV_PM_OPS,
>>   };
>>   
>> -- 
>> 2.25.1
>>
>> _______________________________________________
>> iommu mailing list
>> iommu@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/iommu
