Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D1C4526AF
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 03:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343567AbhKPCKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 21:10:03 -0500
Received: from mga18.intel.com ([134.134.136.126]:52541 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239291AbhKPCFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 21:05:03 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220490188"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="220490188"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 18:02:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="494268259"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga007.jf.intel.com with ESMTP; 15 Nov 2021 18:01:56 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
To:     Christoph Hellwig <hch@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
Date:   Tue, 16 Nov 2021 09:57:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YZJdJH4AS+vm0j06@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Christoph,

On 11/15/21 9:14 PM, Christoph Hellwig wrote:
> On Mon, Nov 15, 2021 at 10:05:42AM +0800, Lu Baolu wrote:
>> +enum iommu_dma_owner {
>> +	DMA_OWNER_NONE,
>> +	DMA_OWNER_KERNEL,
>> +	DMA_OWNER_USER,
>> +};
>> +
> 
>> +	enum iommu_dma_owner dma_owner;
>> +	refcount_t owner_cnt;
>> +	struct file *owner_user_file;
> 
> I'd just overload the ownership into owner_user_file,
> 
>   NULL			-> no owner
>   (struct file *)1UL)	-> kernel
>   real pointer		-> user
> 
> Which could simplify a lot of the code dealing with the owner.
> 

Yeah! Sounds reasonable. I will make this in the next version.

Best regards,
baolu
