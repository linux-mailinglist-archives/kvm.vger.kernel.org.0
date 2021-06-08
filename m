Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9491439EB37
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 03:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhFHBLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 21:11:25 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8064 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFHBLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 21:11:23 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzXBQ5JNHzYrPB;
        Tue,  8 Jun 2021 09:06:38 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 09:09:22 +0800
Received: from [10.174.185.220] (10.174.185.220) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 09:09:21 +0800
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <c9c066ae-2a25-0799-51a7-0ca47fff41a1@huawei.com>
 <aa1624bf-e472-2b66-1d20-54ca23c19fd2@linux.intel.com>
 <ed4f6e57-4847-3ed2-75de-cea80b2fbdb8@huawei.com>
 <01fe5034-42c8-6923-32f1-e287cc36bccc@linux.intel.com>
 <20210601173323.GN1002214@nvidia.com>
 <23a482f9-b88a-da98-3800-f3fd9ea85fbd@huawei.com>
 <20210603111914.653c4f61@jacob-builder>
 <eebe5926-efa0-8bab-e8d4-bd327669637f@huawei.com>
 <BN6PR11MB4068FDFFF36C1F15046E0A0EC3389@BN6PR11MB4068.namprd11.prod.outlook.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <9653f2a9-b6a0-86e8-19d4-53ab9079c49c@huawei.com>
Date:   Tue, 8 Jun 2021 09:09:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <BN6PR11MB4068FDFFF36C1F15046E0A0EC3389@BN6PR11MB4068.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.220]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/6/7 20:19, Liu, Yi L wrote:
>> From: Shenming Lu <lushenming@huawei.com>
>> Sent: Friday, June 4, 2021 10:03 AM
>>
>> On 2021/6/4 2:19, Jacob Pan wrote:
>>> Hi Shenming,
>>>
>>> On Wed, 2 Jun 2021 12:50:26 +0800, Shenming Lu
>> <lushenming@huawei.com>
>>> wrote:
>>>
>>>> On 2021/6/2 1:33, Jason Gunthorpe wrote:
>>>>> On Tue, Jun 01, 2021 at 08:30:35PM +0800, Lu Baolu wrote:
>>>>>
>>>>>> The drivers register per page table fault handlers to /dev/ioasid which
>>>>>> will then register itself to iommu core to listen and route the per-
>>>>>> device I/O page faults.
>>>>>
>>>>> I'm still confused why drivers need fault handlers at all?
>>>>
>>>> Essentially it is the userspace that needs the fault handlers,
>>>> one case is to deliver the faults to the vIOMMU, and another
>>>> case is to enable IOPF on the GPA address space for on-demand
>>>> paging, it seems that both could be specified in/through the
>>>> IOASID_ALLOC ioctl?
>>>>
>>> I would think IOASID_BIND_PGTABLE is where fault handler should be
>>> registered. There wouldn't be any IO page fault without the binding
>> anyway.
>>
>> Yeah, I also proposed this before, registering the handler in the
>> BIND_PGTABLE
>> ioctl does make sense for the guest page faults. :-)
>>
>> But how about the page faults from the GPA address space (it's page table is
>> mapped through the MAP_DMA ioctl)? From your point of view, it seems
>> that we should register the handler for the GPA address space in the (first)
>> MAP_DMA ioctl.
> 
> under new proposal, I think the page fault handler is also registered
> per ioasid object. The difference compared with guest page table case
> is there is no need to inject the fault to VM.

Yeah.  And there are some issues specific to the GPA address space case
which have been discussed with Alex..  Thanks,

Shenming
