Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0A741410F
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 07:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhIVFJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 01:09:20 -0400
Received: from verein.lst.de ([213.95.11.211]:58677 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231775AbhIVFJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 01:09:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2FB4667373; Wed, 22 Sep 2021 07:07:46 +0200 (CEST)
Date:   Wed, 22 Sep 2021 07:07:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Liu Yi L <yi.l.liu@intel.com>,
        alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, david@gibson.dropbear.id.au,
        nicolinc@nvidia.com
Subject: Re: [RFC 04/20] iommu: Add iommu_device_get_info interface
Message-ID: <20210922050746.GA12921@lst.de>
References: <20210919063848.1476776-1-yi.l.liu@intel.com> <20210919063848.1476776-5-yi.l.liu@intel.com> <20210921161930.GP327412@nvidia.com> <a8a72eba-bae3-9f42-f79c-c5646e425255@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8a72eba-bae3-9f42-f79c-c5646e425255@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 10:31:47AM +0800, Lu Baolu wrote:
> Hi Jason,
>
> On 9/22/21 12:19 AM, Jason Gunthorpe wrote:
>> On Sun, Sep 19, 2021 at 02:38:32PM +0800, Liu Yi L wrote:
>>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>>
>>> This provides an interface for upper layers to get the per-device iommu
>>> attributes.
>>>
>>>      int iommu_device_get_info(struct device *dev,
>>>                                enum iommu_devattr attr, void *data);
>>
>> Can't we use properly typed ops and functions here instead of a void
>> *data?
>>
>> get_snoop()
>> get_page_size()
>> get_addr_width()
>
> Yeah! Above are more friendly to the upper layer callers.

The other option would be a struct with all the attributes.  Still
type safe, but not as many methods.  It'll require a little boilerplate
in the callers, though.
