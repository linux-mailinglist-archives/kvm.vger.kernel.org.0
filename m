Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31A341DB5D
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 15:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351686AbhI3Npu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 09:45:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:39054 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351414AbhI3Npu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 09:45:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="204671574"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="204671574"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 06:44:07 -0700
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="564177724"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.214.141]) ([10.254.214.141])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 06:44:00 -0700
Cc:     baolu.lu@linux.intel.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica> <20210923112716.GE964074@nvidia.com>
 <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923122220.GL964074@nvidia.com>
 <BN9PR11MB5433F33CB7CFBCD41BE2F5C68CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <9a04c421-4a25-f1de-a896-321026b3f0ce@linux.intel.com>
Date:   Thu, 30 Sep 2021 21:43:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <BN9PR11MB5433F33CB7CFBCD41BE2F5C68CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/9/30 16:49, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Thursday, September 23, 2021 8:22 PM
>>
>>>> These are different things and need different bits. Since the ARM path
>>>> has a lot more code supporting it, I'd suggest Intel should change
>>>> their code to use IOMMU_BLOCK_NO_SNOOP and abandon
>> IOMMU_CACHE.
>>>
>>> I didn't fully get this point. The end result is same, i.e. making the DMA
>>> cache-coherent when IOMMU_CACHE is set. Or if you help define the
>>> behavior of IOMMU_CACHE, what will you define now?
>>
>> It is clearly specifying how the kernel API works:
>>
>>   !IOMMU_CACHE
>>     must call arch cache flushers
>>   IOMMU_CACHE -
>>     do not call arch cache flushers
>>   IOMMU_CACHE|IOMMU_BLOCK_NO_SNOOP -
>>     dot not arch cache flushers, and ignore the no snoop bit.
> 
> Who will set IOMMU_BLOCK_NO_SNOOP? I feel this is arch specific
> knowledge about how cache coherency is implemented, i.e.
> when IOMMU_CACHE is set intel-iommu driver just maps it to
> blocking no-snoop. It's not necessarily to be an attribute in
> the same level as IOMMU_CACHE?
> 
>>
>> On Intel it should refuse to create a !IOMMU_CACHE since the HW can't
>> do that.
> 
> Agree. In reality I guess this is not hit because all devices are marked
> coherent on Intel platforms...
> 
> Baolu, any insight here?

I am trying to follow the discussion here. Please guide me if I didn't
get the right context.

Here, we are discussing arch_sync_dma_for_cpu() and
arch_sync_dma_for_device(). The x86 arch has clflush to sync dma buffer
for device, but I can't see any instruction to sync dma buffer for cpu
if the device is not cache coherent. Is that the reason why x86 can't
have an implementation for arch_sync_dma_for_cpu(), hence all devices
are marked coherent?

> Thanks
> Kevin
> 

Best regards,
baolu
