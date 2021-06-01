Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77CD396C67
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 06:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhFAEh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 00:37:59 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3310 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbhFAEh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 00:37:58 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FvK472ZK2z19S5s;
        Tue,  1 Jun 2021 12:31:35 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 12:36:16 +0800
Received: from [10.174.185.220] (10.174.185.220) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 12:36:15 +0800
Subject: Re: [RFC PATCH v3 8/8] vfio: Add nested IOPF support
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
 <20210409034420.1799-9-lushenming@huawei.com>
 <20210518125808.345b812c.alex.williamson@redhat.com>
 <ea8c92a8-6e51-8be6-de19-d5e6f1d5527f@huawei.com>
 <83747758-ceb6-b498-8d95-609fdd0d763b@huawei.com>
 <20210524161129.085503ad@x1.home.shazbot.org>
 <90b00e7d-7934-ee79-7643-e2949e2d3af4@huawei.com>
 <9daf8877-a538-2d19-f548-b00ea6f127df@linux.intel.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <8b6e5abd-d965-2331-7af3-08bef399af0f@huawei.com>
Date:   Tue, 1 Jun 2021 12:36:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <9daf8877-a538-2d19-f548-b00ea6f127df@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.220]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/27 19:18, Lu Baolu wrote:
> Hi Shenming and Alex,
> 
> On 5/27/21 7:03 PM, Shenming Lu wrote:
>>> I haven't fully read all the references, but who imposes the fact that
>>> there's only one fault handler per device?  If type1 could register one
>>> handler and the vfio-pci bus driver another for the other level, would
>>> we need this path through vfio-core?
>> If we could register more than one handler per device, things would become
>> much more simple, and the path through vfio-core would not be needed.
>>
>> Hi Baolu,
>> Is there any restriction for having more than one handler per device?
>>
> 
> Currently, each device could only have one fault handler. But one device
> might consume multiple page tables. From this point of view, it's more
> reasonable to have one handler per page table.

Sounds good to me. I have pointed it out in the IOASID uAPI proposal. :-)

Thanks,
Shenming

> 
> Best regards,
> baolu
> .
