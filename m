Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A88BBFCA
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 03:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392643AbfIXBkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 21:40:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:31726 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729129AbfIXBkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 21:40:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 18:40:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,542,1559545200"; 
   d="scan'208";a="200739388"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 23 Sep 2019 18:40:48 -0700
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        sanjay.k.kumar@intel.com, jacob.jun.pan@linux.intel.com,
        kevin.tian@intel.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
To:     "Raj, Ashok" <ashok.raj@intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190923203102.GB21816@araj-mobl1.jf.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <9cfe6042-f0fb-ea5e-e134-f6f5bb9eb7b0@linux.intel.com>
Date:   Tue, 24 Sep 2019 09:38:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923203102.GB21816@araj-mobl1.jf.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ashok,

On 9/24/19 4:31 AM, Raj, Ashok wrote:
> On Mon, Sep 23, 2019 at 08:24:52PM +0800, Lu Baolu wrote:
>> This adds functions to manipulate first level page tables
>> which could be used by a scalale mode capable IOMMU unit.
> 
> s/scalale/scalable

Yes.

> 
>>
>> intel_mmmap_range(domain, addr, end, phys_addr, prot)
> 
> Maybe think of a different name..? mmmap seems a bit weird :-)

Yes. I don't like it either. I've thought about it and haven't
figured out a satisfied one. Do you have any suggestions?

Best regards,
Baolu

> 
>>   - Map an iova range of [addr, end) to the physical memory
>>     started at @phys_addr with the @prot permissions.
>>
>> intel_mmunmap_range(domain, addr, end)
>>   - Tear down the map of an iova range [addr, end). A page
>>     list will be returned which will be freed after iotlb
>>     flushing.
>>
>> Cc: Ashok Raj <ashok.raj@intel.com>
>> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Cc: Liu Yi L <yi.l.liu@intel.com>
>> Cc: Yi Sun <yi.y.sun@linux.intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> 
