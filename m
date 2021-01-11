Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132EF2F21A0
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 22:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbhAKVRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 16:17:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53754 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbhAKVRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 16:17:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BLDmrc109681;
        Mon, 11 Jan 2021 21:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=n31LFTWwN2ldJZgeBrxPUK5Z9Nux23yrgiz3z4Pylps=;
 b=lSkmwEPhj9R4Cu4tVVsWTXQ2SB6DdaKCOg7/x72oMR5k4djotm0vSU/AEWTFK5smnj4U
 Ybc8sJ3Sh2vyGCLHLRE5JEJfDGfwcWFCaHwRf5yt3Ew1HFR/3WSxNzHRM3s9ykUllral
 EChL5t8GRs2SDvYaGOwMW8FeAdcBk4yxFbMsKfrdqDrf145y8FDtx0DIbIiiWscLUns8
 +L5m22mM1MVRs/Jd4UodF63eb448oJjB/pa2I7blLzkdBLaoTVnod9xKvlYOb5IfS5lX
 pWOSMX1tKfnT0ca7csTes5wxoPbyKMVdjCXl+9Fbv8U6HrEBeDiyiilj7mFj+3vgq/o5 fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 360kcykdqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Jan 2021 21:16:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BLGS28191852;
        Mon, 11 Jan 2021 21:16:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 360kf48169-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 21:16:27 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10BLGFrH019161;
        Mon, 11 Jan 2021 21:16:15 GMT
Received: from [10.39.203.150] (/10.39.203.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Jan 2021 13:16:15 -0800
Subject: Re: [PATCH V1 5/5] vfio: block during VA suspend
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
 <1609861013-129801-6-git-send-email-steven.sistare@oracle.com>
 <20210108143229.0543ccce@omen.home>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <fba2351a-4a8d-6840-3d14-b0694cb3414e@oracle.com>
Date:   Mon, 11 Jan 2021 16:16:14 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108143229.0543ccce@omen.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/2021 4:32 PM, Alex Williamson wrote:
> On Tue,  5 Jan 2021 07:36:53 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Block translation of host virtual address while an iova range is suspended.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 48 ++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 45 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 2c164a6..8035b9a 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -31,6 +31,8 @@
>>  #include <linux/rbtree.h>
>>  #include <linux/sched/signal.h>
>>  #include <linux/sched/mm.h>
>> +#include <linux/delay.h>
>> +#include <linux/kthread.h>
>>  #include <linux/slab.h>
>>  #include <linux/uaccess.h>
>>  #include <linux/vfio.h>
>> @@ -484,6 +486,34 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>>  	return ret;
>>  }
>>  
>> +static bool vfio_iommu_contained(struct vfio_iommu *iommu)
>> +{
>> +	struct vfio_domain *domain = iommu->external_domain;
>> +	struct vfio_group *group;
>> +
>> +	if (!domain)
>> +		domain = list_first_entry(&iommu->domain_list,
>> +					  struct vfio_domain, next);
>> +
>> +	group = list_first_entry(&domain->group_list, struct vfio_group, next);
>> +	return vfio_iommu_group_contained(group->iommu_group);
>> +}
> 
> This seems really backwards for a vfio iommu backend to ask vfio-core
> whether its internal object is active.

Yes.  I considered the architecturally purer approach of defining a new back end
interface and calling it from the core when the change to uncontained occurs,
but it seemed like overkill.
 
>> +
>> +
>> +bool vfio_vaddr_valid(struct vfio_iommu *iommu, struct vfio_dma *dma)
>> +{
>> +	while (dma->suspended) {
>> +		mutex_unlock(&iommu->lock);
>> +		msleep_interruptible(10);
>> +		mutex_lock(&iommu->lock);
>> +		if (kthread_should_stop() || !vfio_iommu_contained(iommu) ||
>> +		    fatal_signal_pending(current)) {
>> +			return false;
>> +		}
>> +	}
>> +	return true;
>> +}
>> +
>>  /*
>>   * Attempt to pin pages.  We really don't want to track all the pfns and
>>   * the iommu can only map chunks of consecutive pfns anyway, so get the
>> @@ -690,6 +720,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  			continue;
>>  		}
>>  
>> +		if (!vfio_vaddr_valid(iommu, dma)) {
>> +			ret = -EFAULT;
>> +			goto pin_unwind;
>> +		}
> 
> This could have dropped iommu->lock, we have no basis to believe our
> vfio_dma object is still valid.  

Ouch, I am embarrassed. To fix, I will pass iova to vfio_vaddr_valid() and call
vfio_find_dma after re-acquiring the lock.

> Also this is called with an elevated
> reference to the container, so we theoretically should not need to test
> whether the iommu is still contained.

We still have a reference to the container, but userland may have closed the container fd
and hence will never call the ioctl to replace the vaddr, so we must bail.
 
>> +
>>  		remote_vaddr = dma->vaddr + (iova - dma->iova);
>>  		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
>>  					     do_accounting);
>> @@ -1514,12 +1549,16 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>>  					i += PAGE_SIZE;
>>  				}
>>  			} else {
>> -				unsigned long pfn;
>> -				unsigned long vaddr = dma->vaddr +
>> -						     (iova - dma->iova);
>> +				unsigned long pfn, vaddr;
>>  				size_t n = dma->iova + dma->size - iova;
>>  				long npage;
>>  
>> +				if (!vfio_vaddr_valid(iommu, dma)) {
>> +					ret = -EFAULT;
>> +					goto unwind;
>> +				}
> 
> This one is even scarier, do we have any basis to assume either object
> is still valid after iommu->lock is released?  

Another ouch. The iommu object still exists, but its dma_list may have changed.  
We cannot even unwind and punt with EAGAIN.

I can fix this by adding a preamble loop that holds iommu->lock and verifies that
all dma_list entries are not suspended.  If the loop hits a suspended entry, it
drops the lock and sleeps (like vfio_vaddr_valid), and retries from the beginning
of the list.  On reaching the end of the list, the lock remains held and prevents
entries from being suspended.

Instead of retrying, I could return EAGAIN, but that would require unwinding of 
earlier groups in __vfio_container_attach_groups.

> We can only get here if
> we're attaching a group to the iommu with suspended vfio_dmas.  Do we
> need to allow that?  It seems we could -EAGAIN and let the user figure
> out that they can't attach a group while mappings have invalid vaddrs.

I would like to allow it to minimize userland code changes.

>> +				vaddr = dma->vaddr + (iova - dma->iova);
>> +
>>  				npage = vfio_pin_pages_remote(dma, vaddr,
>>  							      n >> PAGE_SHIFT,
>>  							      &pfn, limit);
>> @@ -2965,6 +3004,9 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>>  	if (count > dma->size - offset)
>>  		count = dma->size - offset;
>>  
>> +	if (!vfio_vaddr_valid(iommu, dma))
> 
> Same as the pinning path, this should hold a container user reference
> but we cannot assume our vfio_dma object is valid if we've released the
> lock.  Thanks,

Yup.  Same fix needed.

- Steve

>> +		goto out;
>> +
>>  	vaddr = dma->vaddr + offset;
>>  
>>  	if (write) {
> 
