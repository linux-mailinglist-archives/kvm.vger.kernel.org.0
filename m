Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F5046AFAC
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 02:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354507AbhLGBZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 20:25:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:17752 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354419AbhLGBZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 20:25:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="234962637"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="234962637"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 17:21:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="515020741"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 06 Dec 2021 17:21:38 -0800
Cc:     baolu.lu@linux.intel.com, Stuart Yoder <stuyoder@gmail.com>,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 03/18] driver core: platform: Rename
 platform_dma_configure()
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-4-baolu.lu@linux.intel.com>
 <Ya3BYxrgkNK3kbGI@kroah.com> <Ya4abbx5M31LYd3N@infradead.org>
 <20211206144535.GB4670@nvidia.com> <Ya4ikRpenoQPXfML@infradead.org>
 <20211206150415.GD4670@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <33f088b2-19c6-c8fe-38f6-f3016ff13f26@linux.intel.com>
Date:   Tue, 7 Dec 2021 09:21:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206150415.GD4670@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/21 11:04 PM, Jason Gunthorpe wrote:
> On Mon, Dec 06, 2021 at 06:47:45AM -0800, Christoph Hellwig wrote:
>> On Mon, Dec 06, 2021 at 10:45:35AM -0400, Jason Gunthorpe via iommu wrote:
>>> IIRC the only thing this function does is touch ACPI and OF stuff?
>>> Isn't that firmware?
>>>
>>> AFAICT amba uses this because AMBA devices might be linked to DT
>>> descriptions?
>> But DT descriptions aren't firmware.  They are usually either passed onb
>> the bootloader or in some deeply embedded setups embedded into the
>> kernel image.
> Pedenatically yes, but do you know of a common word to refer to both
> OF and ACPI that is better than firmware?:)

If the firmware_ name is confusing, how about common_dma_configure()?
Or, copy the 6 lines of code to amba bus driver?

Best regards,
baolu
