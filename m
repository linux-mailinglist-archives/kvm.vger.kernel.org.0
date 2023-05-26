Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07F5711D63
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 04:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240695AbjEZCFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 22:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbjEZCFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 22:05:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC28194;
        Thu, 25 May 2023 19:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685066721; x=1716602721;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3FRtV+V0lyCeW1Ovj8JS9xrSCJC7ltM313nVTl9jV+0=;
  b=UqHv8BIsP+L7/7/5CCL+got7RmAJd7NMlf1zJgYW1dDd7MqsIQSttk2j
   fRZIqglrtLYlwF1+oDMIaKo2G6Ni/Qr/OuB1CCtJ6JJsCeQ4IXCdfUs91
   yPOjwy9GvFaM/HqWqp6rwB4NaaQkqzQbSa8TiMC8VUZ/D5LR9Thvtgi+T
   WMH0VND2xJN1ENilSmjwlcr2d87dYV3ehB5Fk8XP8VZoPQFtYg+PtUV0v
   7gextqFyHEeCyUYm80+kQOYjJCgqa3EcQ8g8YRe80V4di25VUNVysRGrD
   QVRB0fjUEWlQ8Q4y6gvMAkP1A1s2sDfAmoELuFVG3tqfHZGV0Bj+FwMi9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="440442231"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="440442231"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 19:05:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="735804563"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="735804563"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga008.jf.intel.com with ESMTP; 25 May 2023 19:05:14 -0700
Message-ID: <355a9f1e-64e6-d785-5a22-027b708b4935@linux.intel.com>
Date:   Fri, 26 May 2023 10:04:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Cc:     baolu.lu@linux.intel.com, "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v6 09/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Content-Language: en-US
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20230522115751.326947-1-yi.l.liu@intel.com>
 <20230522115751.326947-10-yi.l.liu@intel.com>
 <20230524135603.33ee3d91.alex.williamson@redhat.com>
 <DS0PR11MB752935203F87D69D4468B890C3469@DS0PR11MB7529.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <DS0PR11MB752935203F87D69D4468B890C3469@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/23 9:02 PM, Liu, Yi L wrote:
>>   It's possible that requirement
>> might be relaxed in the new DMA ownership model, but as it is right
>> now, the code enforces that requirement and any new discussion about
>> what makes hot-reset available should note both the ownership and
>> dev_set requirement.  Thanks,
> I think your point is that if an iommufd_ctx has acquired DMA ownerhisp
> of an iommu_group, it means the device is owned. And it should not
> matter whether all the devices in the iommu_group is present in the
> dev_set. It is allowed that some devices are bound to pci-stub or
> pcieport driver. Is it?
> 
> Actually I have a doubt on it. IIUC, the above requirement on dev_set
> is to ensure the reset to the devices are protected by the dev_set->lock.
> So that either the reset issued by driver itself or a hot reset request
> from user, there is no race. But if a device is not in the dev_set, then
> hot reset request from user might race with the bound driver. DMA ownership
> only guarantees the drivers won't handle DMA via DMA API which would have
> conflict with DMA mappings from user. I'm not sure if it is able to
> guarantee reset is exclusive as well. I see pci-stub and pcieport driver
> are the only two drivers that set the driver_managed_dma flag besides the
> vfio drivers. pci-stub may be fine. not sure about pcieport driver.

commit c7d469849747 ("PCI: portdrv: Set driver_managed_dma") described
the criteria of adding driver_managed_dma to the pcieport driver.

"
We achieve this by setting ".driver_managed_dma = true" in pci_driver
structure. It is safe because the portdrv driver meets below criteria:

- This driver doesn't use DMA, as you can't find any related calls like
   pci_set_master() or any kernel DMA API (dma_map_*() and etc.).
- It doesn't use MMIO as you can't find ioremap() or similar calls. It's
   tolerant to userspace possibly also touching the same MMIO registers
   via P2P DMA access.
"

pci_rest_device() definitely shouldn't be done by the kernel drivers
that have driver_managed_dma set.

> 
>     #   line  filename / context / line
>     1     39  drivers/pci/pci-stub.c <<GLOBAL>>
>               .driver_managed_dma = true,
>     2    796  drivers/pci/pcie/portdrv.c <<GLOBAL>>
>               .driver_managed_dma = true,
>     3    607  drivers/vfio/fsl-mc/vfio_fsl_mc.c <<GLOBAL>>
>               .driver_managed_dma = true,
>     4   1459  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c <<GLOBAL>>
>               .driver_managed_dma = true,
>     5   1374  drivers/vfio/pci/mlx5/main.c <<GLOBAL>>
>               .driver_managed_dma = true,
>     6    203  drivers/vfio/pci/vfio_pci.c <<GLOBAL>>
>               .driver_managed_dma = true,
>     7    139  drivers/vfio/platform/vfio_amba.c <<GLOBAL>>
>               .driver_managed_dma = true,
>     8    120  drivers/vfio/platform/vfio_platform.c <<GLOBAL>>
>               .driver_managed_dma = true,
> 
> Anyhow, I think this is not a must so far. is it? Even doable, it shall
> be done in the future. 😄

Perhaps we can take it in this way: it's a bug if any driver sets its
driver_managed_dma but still resets the hardware during it's life cycle?

Best regards,
baolu
