Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B7E2F5398
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 20:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbhAMTpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 14:45:13 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55168 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbhAMTpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 14:45:13 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10DJdfAO130320;
        Wed, 13 Jan 2021 19:44:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ghB12JomBMV0iBHWSulHKvTREP6VRMtewCovGvFCFik=;
 b=AAI7CHJAqbqbBu+8DGzV1FXn++THjEbZi1fxxEGmPWCCboqALZmzN8GDGzv+DnPADhYz
 WF1abjItbRsu+WzX7pLRsJ4pX25uX/aSg3SFFqpMHeqAhURDZ9eFECSutlkCG7oO1Ym1
 XGMdXdhqx0gJcgP/wU3zbklNLcjfH31BIN+gKTiCUhtbtPeSPJIairxWzYmfGryzfXzi
 Ec+hAK/SPGSW720XnmO6NQG2k7eIPCuUcSoLLYdp3MKc2C95pB62ss+6fZQEX1s2ui8w
 YzRrXWtIQJCXnpMnfPi9M6YYaD0Mu4NZd5Gnt4q3GxPTYUjN+9+dfJ/YPxRLSKCw+mK0 Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg1w8fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 19:44:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10DJeZGv142465;
        Wed, 13 Jan 2021 19:44:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 360kf87gdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 19:44:27 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10DJiQCs027141;
        Wed, 13 Jan 2021 19:44:26 GMT
Received: from [10.39.255.41] (/10.39.255.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Jan 2021 11:44:26 -0800
Subject: Re: [PATCH V1 3/5] vfio: detect closed container
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
 <1609861013-129801-4-git-send-email-steven.sistare@oracle.com>
 <20210108123905.30d647d4@omen.home>
 <b7b51ee2-b7f6-61c4-c00d-166d9f56cbe7@oracle.com>
 <20210113122609.2bedad55@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <c6393c85-0aed-8235-7cda-c9376df189bf@oracle.com>
Date:   Wed, 13 Jan 2021 14:44:26 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210113122609.2bedad55@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/2021 2:26 PM, Alex Williamson wrote:
> On Mon, 11 Jan 2021 16:12:18 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
>> On 1/8/2021 2:39 PM, Alex Williamson wrote:
>>> On Tue,  5 Jan 2021 07:36:51 -0800
>>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>>   
>>>> Add a function that detects if an iommu_group has a valid container.
>>>>
>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>> ---
>>>>  drivers/vfio/vfio.c  | 12 ++++++++++++
>>>>  include/linux/vfio.h |  1 +
>>>>  2 files changed, 13 insertions(+)
>>>>
>>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>>> index 262ab0e..f89ab80 100644
>>>> --- a/drivers/vfio/vfio.c
>>>> +++ b/drivers/vfio/vfio.c
>>>> @@ -61,6 +61,7 @@ struct vfio_container {
>>>>  	struct vfio_iommu_driver	*iommu_driver;
>>>>  	void				*iommu_data;
>>>>  	bool				noiommu;
>>>> +	bool				closed;
>>>>  };
>>>>  
>>>>  struct vfio_unbound_dev {
>>>> @@ -1223,6 +1224,7 @@ static int vfio_fops_release(struct inode *inode, struct file *filep)
>>>>  
>>>>  	filep->private_data = NULL;
>>>>  
>>>> +	container->closed = true;
>>>>  	vfio_container_put(container);
>>>>  
>>>>  	return 0;
>>>> @@ -2216,6 +2218,16 @@ void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(vfio_group_set_kvm);
>>>>  
>>>> +bool vfio_iommu_group_contained(struct iommu_group *iommu_group)
>>>> +{
>>>> +	struct vfio_group *group = vfio_group_get_from_iommu(iommu_group);
>>>> +	bool ret = group && group->container && !group->container->closed;
>>>> +
>>>> +	vfio_group_put(group);
>>>> +	return ret;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(vfio_iommu_group_contained);  
>>>
>>> This seems like a pointless interface, the result is immediately stale.
>>> Anything that relies on the container staying open needs to add itself
>>> as a user.  We already have some interfaces for that, ex.
>>> vfio_group_get_external_user().  Thanks,  
>>
>> The significant part here is container->closed, which is only set if userland closes the
>> container fd, which is a one-way trip -- the fd for this instance can never be opened 
>> again.  The container object may still have other references, and not be destroyed yet.
>> In patch 5, kernel code that waits for the RESUME ioctl calls this accessor to test if 
>> the ioctl will never arrive.
> 
> Ok, that makes sense, the "contained" naming notsomuch.  You mention on
> 5/5 that you considered defining a new backend interface to call from
> the core, but considered it overkill.  I'm not sure what you're
> imagining that would be overkill.  We can pretty simply add an optional
> callback to struct vfio_iommu_drivers_ops that would allow the iommu
> driver to be notified when the container fd is released.  That seems
> quite simple and avoids the inverted calling structure presented here.
> Thanks,

OK.

Thanks very much for all your comments.  Off to write PATCH V2 ...

- Steve
