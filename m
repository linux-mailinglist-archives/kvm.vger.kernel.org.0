Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CFC47EC33
	for <lists+kvm@lfdr.de>; Fri, 24 Dec 2021 07:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245711AbhLXGok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Dec 2021 01:44:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:4822 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229862AbhLXGok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Dec 2021 01:44:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640328279; x=1671864279;
  h=message-id:date:mime-version:cc:to:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=7Xc5dzX2sN4TanzEABvQdPekw88Sa8jkaWd1YmxT05k=;
  b=YO+aSWlCkCQEpQNNva4OG/49NbRUCY6BHO4LfJ06lijlMJVkQYLv7uH0
   ZkDy0dvPJv8+T1kNxIqW0u8CfPrV00Il158/WhDGFUJ3l/N0uSP+yMTho
   v2zYbDVtEEu1hruCiV030VETnRFQPODelkUN0IBHWE2KW1b531cbY/+t8
   oxeRPh/tAt0CnXaxPgkETRWWdTaGCujZDNpwwRE0JFM91sxHG7gGNCteQ
   wNGqEJJzb43GANBW0IUriANo4Zzn4qh/yq3YIJgIAn1c+01gBcPyd33ZY
   5bhrsOP1FySDMBrLzQ2IeN2i9ajDSFubORFLfOqxbk72hDi+4m7uTZJnH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10207"; a="265152741"
X-IronPort-AV: E=Sophos;i="5.88,231,1635231600"; 
   d="scan'208";a="265152741"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 22:44:39 -0800
X-IronPort-AV: E=Sophos;i="5.88,231,1635231600"; 
   d="scan'208";a="468769790"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.212.152]) ([10.254.212.152])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 22:44:28 -0800
Message-ID: <254d6e52-0644-6600-8f30-5331ed961298@linux.intel.com>
Date:   Fri, 24 Dec 2021 14:44:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Cc:     baolu.lu@linux.intel.com, Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
 <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
 <20211221184609.GF1432915@nvidia.com>
 <aebbd9c7-a239-0f89-972b-a9059e8b218b@arm.com>
 <20211223005712.GA1779224@nvidia.com>
 <fea0fc91-ac4c-dfe4-f491-5f906bea08bd@linux.intel.com>
 <20211223140300.GC1779224@nvidia.com>
 <50b8bb0f-3873-b128-48e8-22f6142f7118@linux.intel.com>
 <20211224025036.GD1779224@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH v4 07/13] iommu: Add iommu_at[de]tach_device_shared() for
 multi-device groups
In-Reply-To: <20211224025036.GD1779224@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2021/12/24 10:50, Jason Gunthorpe wrote:
> On Fri, Dec 24, 2021 at 09:30:17AM +0800, Lu Baolu wrote:
>> Hi Jason,
>>
>> On 12/23/21 10:03 PM, Jason Gunthorpe wrote:
>>>>> I think it would be clear why iommu_group_set_dma_owner(), which
>>>>> actually does detatch, is not the same thing as iommu_attach_device().
>>>> iommu_device_set_dma_owner() will eventually call
>>>> iommu_group_set_dma_owner(). I didn't get why
>>>> iommu_group_set_dma_owner() is special and need to keep.
>>> Not quite, they would not call each other, they have different
>>> implementations:
>>>
>>> int iommu_device_use_dma_api(struct device *device)
>>> {
>>> 	struct iommu_group *group = device->iommu_group;
>>>
>>> 	if (!group)
>>> 		return 0;
>>>
>>> 	mutex_lock(&group->mutex);
>>> 	if (group->owner_cnt != 0 ||
>>> 	    group->domain != group->default_domain) {
>>> 		mutex_unlock(&group->mutex);
>>> 		return -EBUSY;
>>> 	}
>>> 	group->owner_cnt = 1;
>>> 	group->owner = NULL;
>>> 	mutex_unlock(&group->mutex);
>>> 	return 0;
>>> }
>> It seems that this function doesn't work for multi-device groups. When
>> the user unbinds all native drivers from devices in the group and start
>> to bind them with vfio-pci and assign them to user, how could iommu know
>> whether the group is viable for user?
> It is just a mistake, I made this very fast. It should work as your
> patch had it with a ++. More like this:
> 
> int iommu_device_use_dma_api(struct device *device)
> {
> 	struct iommu_group *group = device->iommu_group;
> 
> 	if (!group)
> 		return 0;
> 
> 	mutex_lock(&group->mutex);
> 	if (group->owner_cnt != 0) {
> 		if (group->domain != group->default_domain ||
> 		    group->owner != NULL) {
> 			mutex_unlock(&group->mutex);
> 			return -EBUSY;
> 		}
> 	}
> 	group->owner_cnt++;
> 	mutex_unlock(&group->mutex);
> 	return 0;
> }
> 
>>> See, we get rid of the enum as a multiplexor parameter, each API does
>>> only wnat it needs, they don't call each other.
>> I like the idea of removing enum parameter and make the API name
>> specific. But I didn't get why they can't call each other even the
>> data in group is the same.
> Well, I think when you type them out you'll find they don't work the
> same. Ie the iommu_group_set_dma_owner() does __iommu_detach_group()
> which iommu_device_use_dma_api() definately doesn't want to
> do. iommu_device_use_dma_api() checks the domain while
> iommu_group_set_dma_owner() must not.
> 
> This is basically the issue, all the places touching ownercount are
> superficially the same but each use different predicates. Given the
> predicate is more than half the code I wouldn't try to share the rest
> of it. But maybe when it is all typed in something will become
> obvious?
> 

Get you and agree with you. For the remaining comments, let me wait and
listen what Robin will comment.

Best regards,
baolu
