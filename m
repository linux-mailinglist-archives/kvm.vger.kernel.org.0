Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248792EBFD9
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 15:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbhAFOuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 09:50:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbhAFOuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 09:50:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106EnBtL073453;
        Wed, 6 Jan 2021 14:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JNAWPyCWJviERlMveN84cGDDBJa0fe4FORaMFulnrXA=;
 b=pdrQMB4wQFgciCdqy3CV0t/YZDEEXKbIEZT+0IfmCxSNakwe8DESAMnpJv3NrZ84TVBe
 keQUI4BzM14jX+tzFd9/xdyg7A63HowUQ5vKeI/bv6mfB8KszejWKud4cPx6TCQRiTN9
 I9QNw1I6Vo/qeQ+tmqsqymHkj2YqZyLF/I1rviU3eLNnKJbttVUB7jTR1BaFmA6Z9k5I
 s0qhouDqoUbxxJ23wxYX0VM1Qjhd23JKtbZKSvrKs9vN7fkH0Pc+zEa58RbN+HqwlhR/
 S/WZWXUZnbPpfUx3l8ry51WkySozoi/ohmSEVmfYgNnoyULZ3DWs1+WP4UpREmjxQOuu kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepm85t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 14:50:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106EfNi5078445;
        Wed, 6 Jan 2021 14:50:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35w3g15dsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 14:50:09 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106Eo7DV010722;
        Wed, 6 Jan 2021 14:50:08 GMT
Received: from [10.39.251.70] (/10.39.251.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 06:50:06 -0800
Subject: Re: [PATCH V1 1/5] vfio: maintain dma_list order
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
 <1609861013-129801-2-git-send-email-steven.sistare@oracle.com>
 <20210105170229.73799d97@omen.home>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <e17f46d5-9523-4644-ff15-e71653c07459@oracle.com>
Date:   Wed, 6 Jan 2021 09:50:06 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210105170229.73799d97@omen.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060092
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/2021 7:02 PM, Alex Williamson wrote:
> Hi Steven,
> 
> On Tue,  5 Jan 2021 07:36:49 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Keep entries properly sorted in the dma_list rb_tree
> 
> Nothing here changes the order of entries in the tree, they're already
> sorted.  The second chunk is the only thing that touches the tree
> construction, but that appears to be just a micro optimization that
> we've already used vfio_find_dma() to verify that a new entry doesn't
> overlap any existing entries, therefore if the start of the new entry
> is less than the test entry, the end must also be less.  The tree is
> not changed afaict.

Agreed.  Bad explanation on my part.

>> so that iterating
>> over multiple entries across a range with gaps works, without requiring
>> one to delete each visited entry as in vfio_dma_do_unmap.
> 
> As above, I don't see that the tree is changed, so this is just a
> manipulation of our search function, changing it from a "find any
> vfio_dma within this range" to a "find the vfio_dma with the lowest
> iova with this range".  But find-any and find-first are computationally
> different, so I don't think we should blindly replace one with the
> other.  Wouldn't it make more sense to add a vfio_find_first_dma()
> function in patch 4/ to handle this case?  Thanks,

Sure, will do.

- Steve

> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 18 +++++++++++-------
>>  1 file changed, 11 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 5fbf0c1..02228d0 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -157,20 +157,24 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>>  static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
>>  				      dma_addr_t start, size_t size)
>>  {
>> +	struct vfio_dma *res = 0;
>>  	struct rb_node *node = iommu->dma_list.rb_node;
>>  
>>  	while (node) {
>>  		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
>>  
>> -		if (start + size <= dma->iova)
>> +		if (start < dma->iova + dma->size) {
>> +			res = dma;
>> +			if (start >= dma->iova)
>> +				break;
>>  			node = node->rb_left;
>> -		else if (start >= dma->iova + dma->size)
>> +		} else {
>>  			node = node->rb_right;
>> -		else
>> -			return dma;
>> +		}
>>  	}
>> -
>> -	return NULL;
>> +	if (res && size && res->iova >= start + size)
>> +		res = 0;
>> +	return res;
>>  }
>>  
>>  static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
>> @@ -182,7 +186,7 @@ static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
>>  		parent = *link;
>>  		dma = rb_entry(parent, struct vfio_dma, node);
>>  
>> -		if (new->iova + new->size <= dma->iova)
>> +		if (new->iova < dma->iova)
>>  			link = &(*link)->rb_left;
>>  		else
>>  			link = &(*link)->rb_right;
> 
