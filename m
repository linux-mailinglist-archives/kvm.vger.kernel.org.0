Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E072F218F
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 22:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbhAKVMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 16:12:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57892 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKVMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 16:12:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BL9dkm140176;
        Mon, 11 Jan 2021 21:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lXn7vpVtxE9H3ekGjlTETtq6RjARjMZjuomqjtoSnQw=;
 b=G1qCgaz2jdr+NZYwOSFnq48q6F+qRqIxtk6bohbdkgVMBVmyqB4nr2Fbgb4jZdM97cHv
 oUvB6E3PhQ08s/i6WhJLMoia2jTCcG8ToGu6MnOswQJmIrenV18EbObd2NblasxH+LCT
 DzE5od44QyeSVkTm09X8c2Wa+Sv0fJ4CdPukktWp/kf8YYlwu6EJP0n/1vXglxSfFAlP
 IlzBHcXw+rwjtgWwfpVJiA9ml+x5GQI4GonHqM5Tt70bnFHV3Z2uGwr2pAzkr34vF+L9
 03+k+3MIHv2j1nHfEKSNs9h5tScg1qBKtvFM2jIQ4qq3HIxoFk4uSa7YXyUkhLuWZEM1 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 360kvju92b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Jan 2021 21:11:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BL6R2P158233;
        Mon, 11 Jan 2021 21:09:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 360kf47gpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 21:09:20 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10BL9JfW003516;
        Mon, 11 Jan 2021 21:09:19 GMT
Received: from [10.39.203.150] (/10.39.203.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Jan 2021 13:09:19 -0800
Subject: Re: [PATCH V1 2/5] vfio: option to unmap all
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
 <1609861013-129801-3-git-send-email-steven.sistare@oracle.com>
 <20210108123548.033377e7@omen.home>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <c5850c5d-52c4-1f21-30cc-34f9b2d7b7f3@oracle.com>
Date:   Mon, 11 Jan 2021 16:09:18 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108123548.033377e7@omen.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/2021 2:35 PM, Alex Williamson wrote:
> Hi Steve,
> 
> On Tue,  5 Jan 2021 07:36:50 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> For VFIO_IOMMU_UNMAP_DMA, delete all mappings if iova=0 and size=0.
> 
> Only the latter is invalid, iova=0 is not special, so does it make
> sense to use this combination to invoke something special?  It seems
> like it opens the door that any size less than the minimum mapping
> granularity means something special.
> 
> Why not use a flag to trigger an unmap-all?

Hi Alex, that would be fine.

> Does userspace have any means to know this is supported other than to
> test it before creating any mappings?

Not currently.  We could overload VFIO_SUSPEND, or define a new extension code.
 
> What's the intended interaction with retrieving the dirty bitmap during
> an unmap-all?

Undefined and broken if there are gaps between segments :(  Good catch, thanks.  
I will disallow the combination of unmap-all and get-dirty-bitmap.

>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 11 ++++++++---
>>  include/uapi/linux/vfio.h       |  3 ++-
>>  2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 02228d0..3dc501d 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -1079,6 +1079,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  	size_t unmapped = 0, pgsize;
>>  	int ret = 0, retries = 0;
>>  	unsigned long pgshift;
>> +	dma_addr_t iova;
>> +	unsigned long size;
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> @@ -1090,7 +1092,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  		goto unlock;
>>  	}
>>  
>> -	if (!unmap->size || unmap->size & (pgsize - 1)) {
>> +	if ((!unmap->size && unmap->iova) || unmap->size & (pgsize - 1)) {
>>  		ret = -EINVAL;
>>  		goto unlock;
>>  	}
>> @@ -1154,8 +1156,11 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> 
> It looks like the code just above this would have an issue if there are
> dma mappings at iova=0.

Are you referring to this code?

        if (iommu->v2) {
                dma = vfio_find_dma(iommu, unmap->iova, 1);
                if (dma && dma->iova != unmap->iova) {
                        ret = -EINVAL;

Both unmap->iova and dma->iova would be 0, so I don't see the problem.

>>  		}
>>  	}
>>  
>> -	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size))) {
>> -		if (!iommu->v2 && unmap->iova > dma->iova)
>> +	iova = unmap->iova;
>> +	size = unmap->size ? unmap->size : SIZE_MAX;
> 
> AFAICT the only difference of this versus the user calling the unmap
> with iova=0 size=SIZE_MAX is that SIZE_MAX will throw an -EINVAL due to
> page size alignment.  If we assume there are no IOMMUs with 1 byte page
> size, the special combination could instead be {0, SIZE_MAX}.  

Fine, but we would still need to document it specifically so the user knows that 
the unaligned SIZE_MAX does not return EINVAL.

> Or the
> caller could just track a high water mark for their mappings and use
> the interface that exists.  Thanks,

I am trying to avoid the need to modify existing code, for legacy qemu live update.
Either a new flag or {0, SIZE_MAX} is suitable.  Which do you prefer?

- Steve
 
>> +
>> +	while ((dma = vfio_find_dma(iommu, iova, size))) {
>> +		if (!iommu->v2 && iova > dma->iova)
>>  			break;
>>  		/*
>>  		 * Task with same address space who mapped this iova range is
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 9204705..896e527 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1073,7 +1073,8 @@ struct vfio_bitmap {
>>   * Caller sets argsz.  The actual unmapped size is returned in the size
>>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
>>   * or size different from those used in the original mapping call will
>> - * succeed.
>> + * succeed.  If iova=0 and size=0, all addresses are unmapped.
>> + *
>>   * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
>>   * before unmapping IO virtual addresses. When this flag is set, the user must
>>   * provide a struct vfio_bitmap in data[]. User must provide zero-allocated
> 
