Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B978B113BA3
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 07:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfLEGTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 01:19:15 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14705 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfLEGTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 01:19:15 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de8a1510000>; Wed, 04 Dec 2019 22:18:57 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 04 Dec 2019 22:19:12 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 04 Dec 2019 22:19:12 -0800
Received: from [10.25.73.41] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Dec
 2019 06:19:04 +0000
Subject: Re: [PATCH v9 Kernel 2/5] vfio iommu: Add ioctl defination to get
 dirty pages bitmap.
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Yan Zhao <yan.y.zhao@intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
 <20191112153020.71406c44@x1.home>
 <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
 <20191113130705.32c6b663@x1.home>
 <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
 <20191114140625.213e8a99@x1.home> <20191126005739.GA31144@joy-OptiPlex-7040>
 <20191203110412.055c38df@x1.home>
 <cce08ca5-79df-2839-16cd-15723b995c07@nvidia.com>
 <20191204113457.16c1316d@x1.home> <20191205012835.GB31791@joy-OptiPlex-7040>
 <fc7e8cf2-d5e6-0fe6-7466-7bdde55ff7d6@nvidia.com>
 <20191204225637.382db416@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <77538a77-91ec-8a60-1f87-3fc18bd1cfe4@nvidia.com>
Date:   Thu, 5 Dec 2019 11:49:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191204225637.382db416@x1.home>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575526737; bh=+zWNj5XII1qpS8pZv1mmj/ewZsnUoze2KGDnA0UayWc=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=YNX8SUTwzk3JHOVeuS+ffxHOONPLDeJZ/aKR0c/VRCK1TyE2fhIxJF0Df7HWbIA6m
         zf16KevHaGAiv9stkCJh2FTG0tQ0HFVr3R5ZmKhej4yQZmOa1Jaki2G+d9An6ST1w6
         MLs1p7ndO7t06q778+31+D93DGkgw5bD8DlGTNzU6pvWQyI4nojXqxYJuhxAHWC+dP
         2ddG/2VZIgPTErcORw236Sr5nGse/bB7fEGZ5+fcLRKbJgUXYT3W9OnSTSA92J6myN
         adNJ2X7X25YpRLqnaqUzqgtcqSbsC52qDu3GRwydh5Qe0W4EPBBw6AT4VrCN86WaqP
         MtwuaxsJSV5LQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/5/2019 11:26 AM, Alex Williamson wrote:
> On Thu, 5 Dec 2019 11:12:23 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 12/5/2019 6:58 AM, Yan Zhao wrote:
>>> On Thu, Dec 05, 2019 at 02:34:57AM +0800, Alex Williamson wrote:
>>>> On Wed, 4 Dec 2019 23:40:25 +0530
>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>   
>>>>> On 12/3/2019 11:34 PM, Alex Williamson wrote:
>>>>>> On Mon, 25 Nov 2019 19:57:39 -0500
>>>>>> Yan Zhao <yan.y.zhao@intel.com> wrote:
>>>>>>       
>>>>>>> On Fri, Nov 15, 2019 at 05:06:25AM +0800, Alex Williamson wrote:
>>>>>>>> On Fri, 15 Nov 2019 00:26:07 +0530
>>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>>>>          
>>>>>>>>> On 11/14/2019 1:37 AM, Alex Williamson wrote:
>>>>>>>>>> On Thu, 14 Nov 2019 01:07:21 +0530
>>>>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>>>>>>            
>>>>>>>>>>> On 11/13/2019 4:00 AM, Alex Williamson wrote:
>>>>>>>>>>>> On Tue, 12 Nov 2019 22:33:37 +0530
>>>>>>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>>>>>>>>               
>>>>>>>>>>>>> All pages pinned by vendor driver through vfio_pin_pages API should be
>>>>>>>>>>>>> considered as dirty during migration. IOMMU container maintains a list of
>>>>>>>>>>>>> all such pinned pages. Added an ioctl defination to get bitmap of such
>>>>>>>>>>>>
>>>>>>>>>>>> definition
>>>>>>>>>>>>               
>>>>>>>>>>>>> pinned pages for requested IO virtual address range.
>>>>>>>>>>>>
>>>>>>>>>>>> Additionally, all mapped pages are considered dirty when physically
>>>>>>>>>>>> mapped through to an IOMMU, modulo we discussed devices opting in to
>>>>>>>>>>>> per page pinning to indicate finer granularity with a TBD mechanism to
>>>>>>>>>>>> figure out if any non-opt-in devices remain.
>>>>>>>>>>>>               
>>>>>>>>>>>
>>>>>>>>>>> You mean, in case of device direct assignment (device pass through)?
>>>>>>>>>>
>>>>>>>>>> Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are fully
>>>>>>>>>> pinned and mapped, then the correct dirty page set is all mapped pages.
>>>>>>>>>> We discussed using the vpfn list as a mechanism for vendor drivers to
>>>>>>>>>> reduce their migration footprint, but we also discussed that we would
>>>>>>>>>> need a way to determine that all participants in the container have
>>>>>>>>>> explicitly pinned their working pages or else we must consider the
>>>>>>>>>> entire potential working set as dirty.
>>>>>>>>>>            
>>>>>>>>>
>>>>>>>>> How can vendor driver tell this capability to iommu module? Any suggestions?
>>>>>>>>
>>>>>>>> I think it does so by pinning pages.  Is it acceptable that if the
>>>>>>>> vendor driver pins any pages, then from that point forward we consider
>>>>>>>> the IOMMU group dirty page scope to be limited to pinned pages?  There
>>>>>>> we should also be aware of that dirty page scope is pinned pages + unpinned pages,
>>>>>>> which means ever since a page is pinned, it should be regarded as dirty
>>>>>>> no matter whether it's unpinned later. only after log_sync is called and
>>>>>>> dirty info retrieved, its dirty state should be cleared.
>>>>>>
>>>>>> Yes, good point.  We can't just remove a vpfn when a page is unpinned
>>>>>> or else we'd lose information that the page potentially had been
>>>>>> dirtied while it was pinned.  Maybe that vpfn needs to move to a dirty
>>>>>> list and both the currently pinned vpfns and the dirty vpfns are walked
>>>>>> on a log_sync.  The dirty vpfns list would be cleared after a log_sync.
>>>>>> The container would need to know that dirty tracking is enabled and
>>>>>> only manage the dirty vpfns list when necessary.  Thanks,
>>>>>>       
>>>>>
>>>>> If page is unpinned, then that page is available in free page pool for
>>>>> others to use, then how can we say that unpinned page has valid data?
>>>>>
>>>>> If suppose, one driver A unpins a page and when driver B of some other
>>>>> device gets that page and he pins it, uses it, and then unpins it, then
>>>>> how can we say that page has valid data for driver A?
>>>>>
>>>>> Can you give one example where unpinned page data is considered reliable
>>>>> and valid?
>>>>
>>>> We can only pin pages that the user has already allocated* and mapped
>>>> through the vfio DMA API.  The pinning of the page simply locks the
>>>> page for the vendor driver to access it and unpinning that page only
>>>> indicates that access is complete.  Pages are not freed when a vendor
>>>> driver unpins them, they still exist and at this point we're now
>>>> assuming the device dirtied the page while it was pinned.  Thanks,
>>>>
>>>> Alex
>>>>
>>>> * An exception here is that the page might be demand allocated and the
>>>>     act of pinning the page could actually allocate the backing page for
>>>>     the user if they have not faulted the page to trigger that allocation
>>>>     previously.  That page remains mapped for the user's virtual address
>>>>     space even after the unpinning though.
>>>>   
>>>
>>> Yes, I can give an example in GVT.
>>> when a gem_object is allocated in guest, before submitting it to guest
>>> vGPU, gfx cmds in its ring buffer need to be pinned into GGTT to get a
>>> global graphics address for hardware access. At that time, we shadow
>>> those cmds and pin pages through vfio pin_pages(), and submit the shadow
>>> gem_object to physial hardware.
>>> After guest driver thinks the submitted gem_object has completed hardware
>>> DMA, it unnpinnd those pinned GGTT graphics memory addresses. Then in
>>> host, we unpin the shadow pages through vfio unpin_pages.
>>> But, at this point, guest driver is still free to access the gem_object
>>> through vCPUs, and guest user space is probably still mapping an object
>>> into the gem_object in guest driver.
>>> So, missing the dirty page tracking for unpinned pages would cause
>>> data inconsitency.
>>>    
>>
>> If pages are accessed by guest through vCPUs, then RAM module in QEMU
>> will take care of tracking those pages as dirty.
>>
>> All unpinned pages might not be used, so tracking all unpinned pages
>> during VM or application life time would also lead to tracking lots of
>> stale pages, even though they are not being used. Increasing number of
>> not needed pages could also lead to increasing migration data leading
>> increase in migration downtime.
> 
> We can't rely on the vCPU also dirtying a page, the overhead is
> unavoidable.  It doesn't matter if the migration is fast if it's
> incorrect.  We only need to track unpinned dirty pages while the
> migration is active and the tracking is flushed on each log_sync
> callback.  Thanks,
> 

 From Yan's comment, pasted below, I thought, need to track all unpinned 
pages during application or VM's lifetime.

 > There we should also be aware of that dirty page scope is pinned 
pages  > + unpinned pages, which means ever since a page is pinned, it 
should
 > be regarded as dirty no matter whether it's unpinned later.

But if its about tracking pages which are unpinned "while the migration 
is active", then that set would be less, will do this change.

Thanks,
Kirti
