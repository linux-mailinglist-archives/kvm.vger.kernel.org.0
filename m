Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E6F38BFA5
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 08:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhEUGlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 02:41:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3644 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbhEUGjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 02:39:22 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FmcLM4xKxzmXTd;
        Fri, 21 May 2021 14:35:39 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:37:56 +0800
Received: from [10.174.187.155] (10.174.187.155) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:37:56 +0800
Subject: Re: [RFC PATCH v3 4/8] vfio/type1: Pre-map more pages than requested
 in the IOPF handling
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Barry Song" <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
 <20210409034420.1799-5-lushenming@huawei.com>
 <20210518125826.7ba38b78.alex.williamson@redhat.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <ba8b6039-d053-2657-ae62-deaa30f452d2@huawei.com>
Date:   Fri, 21 May 2021 14:37:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210518125826.7ba38b78.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.155]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/19 2:58, Alex Williamson wrote:
> On Fri, 9 Apr 2021 11:44:16 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
> 
>> To optimize for fewer page fault handlings, we can pre-map more pages
>> than requested at once.
>>
>> Note that IOPF_PREMAP_LEN is just an arbitrary value for now, which we
>> could try further tuning.
> 
> I'd prefer that the series introduced full end-to-end functionality
> before trying to improve performance.  The pre-map value seems
> arbitrary here and as noted in the previous patch, the IOMMU API does
> not guarantee unmaps of ranges smaller than the original mapping.  This
> would need to map with single page granularity in order to guarantee
> page granularity at the mmu notifier when the IOMMU supports
> superpages.  Thanks,

Yeah, I will drop this patch in the current stage.

Thanks,
Shenming

> 
> Alex
> 
> .
> 
