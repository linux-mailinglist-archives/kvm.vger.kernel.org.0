Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6451DC75D
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 09:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgEUHKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 03:10:04 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6743 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbgEUHKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 03:10:04 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec6293e0002>; Thu, 21 May 2020 00:09:50 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 21 May 2020 00:10:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 21 May 2020 00:10:02 -0700
Received: from [10.40.103.233] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 May
 2020 07:09:53 +0000
Subject: Re: [PATCH Kernel v22 0/8] Add UAPIs to support migration for VFIO
 devices
To:     Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
 <20200519105804.02f3cae8@x1.home> <20200520025500.GA10369@joy-OptiPlex-7040>
 <97977ede-3c5b-c5a5-7858-7eecd7dd531c@nvidia.com>
 <20200520104612.03a32977@w520.home>
 <20200521050846.GC10369@joy-OptiPlex-7040>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <d8b40fed-5f54-31ac-0b7c-e2ae74a0ad19@nvidia.com>
Date:   Thu, 21 May 2020 12:39:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521050846.GC10369@joy-OptiPlex-7040>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590044990; bh=VTiS02EYYni68rR9NU0+vdz2D4dkf+0GDnLnrPiq+ME=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=l/bbfoV9yySFjoD9dUxGw8hsF4Mg8lz3z7H/q+x+Cjm3p/LkNlZU23B8seg6HkVyR
         zlJ41KCFJvCRbU/KMjndtiI18o2JFSfAxljilRaxZMuBPaNtbZYyb5gmk7Xe1zBM6K
         dvM1+CJPUKlfiDk51q00MTbq3Ph0xnrlayuDYLes0qEzH06KpPKJDrw9iNNWEqivFf
         IkkXLgxgaEv8FS6HJGeE/reqa2fB53dWZ4JD3qWYLCZ7JUkYtS2aPWnTBCmz6GvG5N
         XtNUzgh3Hkg+rSBYIyOv0RjcFGxHAeGh7P4e2zUjINrblYqVcgTZ64Mjes2rwiHeLA
         IyH6nd1tXcpVQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/21/2020 10:38 AM, Yan Zhao wrote:
> On Wed, May 20, 2020 at 10:46:12AM -0600, Alex Williamson wrote:
>> On Wed, 20 May 2020 19:10:07 +0530
>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>
>>> On 5/20/2020 8:25 AM, Yan Zhao wrote:
>>>> On Tue, May 19, 2020 at 10:58:04AM -0600, Alex Williamson wrote:
>>>>> Hi folks,
>>>>>
>>>>> My impression is that we're getting pretty close to a workable
>>>>> implementation here with v22 plus respins of patches 5, 6, and 8.  We
>>>>> also have a matching QEMU series and a proposal for a new i40e
>>>>> consumer, as well as I assume GVT-g updates happening internally at
>>>>> Intel.  I expect all of the latter needs further review and discussion,
>>>>> but we should be at the point where we can validate these proposed
>>>>> kernel interfaces.  Therefore I'd like to make a call for reviews so
>>>>> that we can get this wrapped up for the v5.8 merge window.  I know
>>>>> Connie has some outstanding documentation comments and I'd like to make
>>>>> sure everyone has an opportunity to check that their comments have been
>>>>> addressed and we don't discover any new blocking issues.  Please send
>>>>> your Acked-by/Reviewed-by/Tested-by tags if you're satisfied with this
>>>>> interface and implementation.  Thanks!
>>>>>   
>>>> hi Alex and Kirti,
>>>> after porting to qemu v22 and kernel v22, it is found out that
>>>> it can not even pass basic live migration test with error like
>>>>
>>>> "Failed to get dirty bitmap for iova: 0xca000 size: 0x3000 err: 22"
>>>>    
>>>
>>> Thanks for testing Yan.
>>> I think last moment change in below cause this failure
>>>
>>> https://lore.kernel.org/kvm/1589871178-8282-1-git-send-email-kwankhede@nvidia.com/
>>>
>>>   > 	if (dma->iova > iova + size)
>>>   > 		break;
>>>
>>> Surprisingly with my basic testing with 2G sys mem QEMU didn't raise
>>> abort on g_free, but I do hit this with large sys mem.
>>> With above change, that function iterated through next vfio_dma as well.
>>> Check should be as below:
>>>
>>> -               if (dma->iova > iova + size)
>>> +               if (dma->iova > iova + size -1)
>>
>>
>> Or just:
>>
>> 	if (dma->iova >= iova + size)
>>
>> Thanks,
>> Alex
>>
>>
>>>                           break;
>>>
>>> Another fix is in QEMU.
>>> https://lists.gnu.org/archive/html/qemu-devel/2020-05/msg04751.html
>>>
>>>   > > +        range->bitmap.size = ROUND_UP(pages, 64) / 8;
>>>   >
>>>   > ROUND_UP(npages/8, sizeof(u64))?
>>>   >
>>>
>>> If npages < 8, npages/8 is 0 and ROUND_UP(0, 8) returns 0.
>>>
>>> Changing it as below
>>>
>>> -        range->bitmap.size = ROUND_UP(pages / 8, sizeof(uint64_t));
>>> +        range->bitmap.size = ROUND_UP(pages, sizeof(__u64) *
>>> BITS_PER_BYTE) /
>>> +                             BITS_PER_BYTE;
>>>
>>> I'm updating patches with these fixes and Cornelia's suggestion soon.
>>>
>>> Due to short of time I may not be able to address all the concerns
>>> raised on previous versions of QEMU, I'm trying make QEMU side code
>>> available for testing for others with latest kernel changes. Don't
>>> worry, I will revisit comments on QEMU patches. Right now first priority
>>> is to test kernel UAPI and prepare kernel patches for 5.8
>>>
>>
> hi Kirti
> by updating kernel/qemu to v23, still met below two types of errors.
> just basic migration test.
> (the guest VM size is 2G for all reported bugs).
> 
> "Failed to get dirty bitmap for iova: 0xfe011000 size: 0x3fb0 err: 22"
> 

size doesn't look correct here, below check should be failing.
  range.size & (iommu_pgsize - 1)

> or
> 
> "qemu-system-x86_64-lm: vfio_load_state: Error allocating buffer
> qemu-system-x86_64-lm: error while loading state section id 49(vfio)
> qemu-system-x86_64-lm: load of migration failed: Cannot allocate memory"
> 
> 

Above error is from:
         buf = g_try_malloc0(data_size);
         if (!buf) {
             error_report("%s: Error allocating buffer ", __func__);
             return -ENOMEM;
         }

Seems you are running out of memory?

Thanks,
Kirti
