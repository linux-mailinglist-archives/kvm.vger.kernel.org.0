Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7176413F7D
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 04:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhIVCgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 22:36:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:40920 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhIVCgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 22:36:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="287173362"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="287173362"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 19:35:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="533533519"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga004.fm.intel.com with ESMTP; 21 Sep 2021 19:35:09 -0700
Cc:     baolu.lu@linux.intel.com, alex.williamson@redhat.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org, jean-philippe@linaro.org,
        kevin.tian@intel.com, parav@mellanox.com, lkml@metux.net,
        pbonzini@redhat.com, lushenming@huawei.com, eric.auger@redhat.com,
        corbet@lwn.net, ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, david@gibson.dropbear.id.au,
        nicolinc@nvidia.com
Subject: Re: [RFC 04/20] iommu: Add iommu_device_get_info interface
To:     Jason Gunthorpe <jgg@nvidia.com>, Liu Yi L <yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-5-yi.l.liu@intel.com>
 <20210921161930.GP327412@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <a8a72eba-bae3-9f42-f79c-c5646e425255@linux.intel.com>
Date:   Wed, 22 Sep 2021 10:31:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210921161930.GP327412@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 9/22/21 12:19 AM, Jason Gunthorpe wrote:
> On Sun, Sep 19, 2021 at 02:38:32PM +0800, Liu Yi L wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>
>> This provides an interface for upper layers to get the per-device iommu
>> attributes.
>>
>>      int iommu_device_get_info(struct device *dev,
>>                                enum iommu_devattr attr, void *data);
> 
> Can't we use properly typed ops and functions here instead of a void
> *data?
> 
> get_snoop()
> get_page_size()
> get_addr_width()

Yeah! Above are more friendly to the upper layer callers.

> 
> ?
> 
> Jason
> 

Best regards,
baolu
