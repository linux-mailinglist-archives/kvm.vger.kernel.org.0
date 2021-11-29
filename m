Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD3B460DEC
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 05:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhK2EHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 23:07:30 -0500
Received: from mga17.intel.com ([192.55.52.151]:43641 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232073AbhK2EFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 23:05:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10182"; a="216590786"
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="216590786"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2021 19:59:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="458984844"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga006.jf.intel.com with ESMTP; 28 Nov 2021 19:59:51 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
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
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/17] Fix BUG_ON in vfio_iommu_group_notifier()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
 <YaM5ko+VkJUT7ZDs@kroah.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <c3230ace-c878-39db-1663-2b752ff5384e@linux.intel.com>
Date:   Mon, 29 Nov 2021 11:59:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YaM5ko+VkJUT7ZDs@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Greg,

On 11/28/21 4:10 PM, Greg Kroah-Hartman wrote:
> On Sun, Nov 28, 2021 at 10:50:34AM +0800, Lu Baolu wrote:
>> The original post and intent of this series is here.
>> https://lore.kernel.org/linux-iommu/20211115020552.2378167-1-baolu.lu@linux.intel.com/
> 
> Please put the intent in the message, dont make us go and dig it up
> again.

Sure! I will include the message next time. Thanks!

> thanks,
> 
> greg k-h
> 

Best regards,
baolu
