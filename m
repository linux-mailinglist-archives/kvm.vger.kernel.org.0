Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E775A46CAFD
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 03:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243086AbhLHCsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 21:48:00 -0500
Received: from mga06.intel.com ([134.134.136.31]:34242 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233825AbhLHCsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 21:48:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="298538167"
X-IronPort-AV: E=Sophos;i="5.87,296,1631602800"; 
   d="scan'208";a="298538167"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 18:44:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,296,1631602800"; 
   d="scan'208";a="515586056"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2021 18:44:23 -0800
Cc:     baolu.lu@linux.intel.com, peter.maydell@linaro.org,
        kvm@vger.kernel.org, vivek.gautam@arm.com,
        kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com,
        jean-philippe@linaro.org, ashok.raj@intel.com, maz@kernel.org,
        vsethi@nvidia.com, zhangfei.gao@linaro.org, kevin.tian@intel.com,
        will@kernel.org, alex.williamson@redhat.com,
        wangxingang5@huawei.com, linux-kernel@vger.kernel.org,
        lushenming@huawei.com, iommu@lists.linux-foundation.org,
        robin.murphy@arm.com, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To:     eric.auger@redhat.com, Joerg Roedel <joro@8bytes.org>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
Date:   Wed, 8 Dec 2021 10:44:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 12/7/21 6:22 PM, Eric Auger wrote:
> On 12/6/21 11:48 AM, Joerg Roedel wrote:
>> On Wed, Oct 27, 2021 at 12:44:20PM +0200, Eric Auger wrote:
>>> Signed-off-by: Jean-Philippe Brucker<jean-philippe.brucker@arm.com>
>>> Signed-off-by: Liu, Yi L<yi.l.liu@linux.intel.com>
>>> Signed-off-by: Ashok Raj<ashok.raj@intel.com>
>>> Signed-off-by: Jacob Pan<jacob.jun.pan@linux.intel.com>
>>> Signed-off-by: Eric Auger<eric.auger@redhat.com>
>> This Signed-of-by chain looks dubious, you are the author but the last
>> one in the chain?
> The 1st RFC in Aug 2018
> (https://lists.cs.columbia.edu/pipermail/kvmarm/2018-August/032478.html)
> said this was a generalization of Jacob's patch
> 
> 
>    [PATCH v5 01/23] iommu: introduce bind_pasid_table API function
> 
> 
>    https://lists.linuxfoundation.org/pipermail/iommu/2018-May/027647.html
> 
> So indeed Jacob should be the author. I guess the multiple rebases got
> this eventually replaced at some point, which is not an excuse. Please
> forgive me for that.
> Now the original patch already had this list of SoB so I don't know if I
> shall simplify it.

As we have decided to move the nested mode (dual stages) implementation
onto the developing iommufd framework, what's the value of adding this
into iommu core?

Best regards,
baolu
