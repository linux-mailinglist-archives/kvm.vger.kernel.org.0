Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2E0392C87
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 13:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhE0LV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 07:21:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:28325 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229657AbhE0LV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 07:21:26 -0400
IronPort-SDR: GwwLgeUlSFNmUQ52K+3rOhCjawhjdCNXz5jEXe1ObmPAt8ZlWLMh+WOIBY/7punkR++D4I7Uhk
 Fl6m6wAjj8sw==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="263911239"
X-IronPort-AV: E=Sophos;i="5.82,334,1613462400"; 
   d="scan'208";a="263911239"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 04:19:51 -0700
IronPort-SDR: qMTkGzZlbxcJQp1hHnj4lt5KkFwi8OSDcNNqVYY6mdA7AMhA7fqtx+FsxZ1s/CXLMQhuctgHH8
 AAArSe7J8nQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,334,1613462400"; 
   d="scan'208";a="631362727"
Received: from allen-box.sh.intel.com (HELO [10.239.159.105]) ([10.239.159.105])
  by fmsmga006.fm.intel.com with ESMTP; 27 May 2021 04:19:46 -0700
Cc:     baolu.lu@linux.intel.com, Eric Auger <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>, yi.l.liu@intel.com,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [RFC PATCH v3 8/8] vfio: Add nested IOPF support
To:     Shenming Lu <lushenming@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
 <20210409034420.1799-9-lushenming@huawei.com>
 <20210518125808.345b812c.alex.williamson@redhat.com>
 <ea8c92a8-6e51-8be6-de19-d5e6f1d5527f@huawei.com>
 <83747758-ceb6-b498-8d95-609fdd0d763b@huawei.com>
 <20210524161129.085503ad@x1.home.shazbot.org>
 <90b00e7d-7934-ee79-7643-e2949e2d3af4@huawei.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <9daf8877-a538-2d19-f548-b00ea6f127df@linux.intel.com>
Date:   Thu, 27 May 2021 19:18:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <90b00e7d-7934-ee79-7643-e2949e2d3af4@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shenming and Alex,

On 5/27/21 7:03 PM, Shenming Lu wrote:
>> I haven't fully read all the references, but who imposes the fact that
>> there's only one fault handler per device?  If type1 could register one
>> handler and the vfio-pci bus driver another for the other level, would
>> we need this path through vfio-core?
> If we could register more than one handler per device, things would become
> much more simple, and the path through vfio-core would not be needed.
> 
> Hi Baolu,
> Is there any restriction for having more than one handler per device?
> 

Currently, each device could only have one fault handler. But one device
might consume multiple page tables. From this point of view, it's more
reasonable to have one handler per page table.

Best regards,
baolu
