Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820C22F2193
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 22:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbhAKVNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 16:13:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50746 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728923AbhAKVNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 16:13:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BL9udG091604;
        Mon, 11 Jan 2021 21:12:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=j6to/hEj/jM848oTUFT4TJp+qIt5EwxQCOhcBL1gIes=;
 b=kwCR9Lb+rI/eSMPbpaXU8sXWXoUxQzI1IofAjUkoHbEaEXy38J0s4JYkLiHIb752s9VF
 kjL7PsKiTPbeVyeBJarxvsyYi1GQB3bbUMVyLzyDZKVL50LGs1W7p6JyHBJFp3T8qoEe
 eHDCftpHz0oMJhizuUqWWwiTcu4PQk3+35bJCGHbpEwMMzyDMhk4axCY2G3fNlJrRKVE
 h5C3E3PPGf7Ff5B42fJbu4Wvh21wNxjMm7Pdj+rCWbe5NLe1gZXYasyuUThx2EjYJJlE
 3oXHFCESnxyMH8N4Kx4nEgFDsLk8Xyh+vKpALtXTQzzrBQ7pWrWFscjNVeHfhx6+P8Eh JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 360kcykd79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Jan 2021 21:12:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BL6Sa7122399;
        Mon, 11 Jan 2021 21:12:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 360kefqk6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 21:12:20 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10BLCJ6u005198;
        Mon, 11 Jan 2021 21:12:19 GMT
Received: from [10.39.203.150] (/10.39.203.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Jan 2021 13:12:19 -0800
Subject: Re: [PATCH V1 3/5] vfio: detect closed container
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
 <1609861013-129801-4-git-send-email-steven.sistare@oracle.com>
 <20210108123905.30d647d4@omen.home>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <b7b51ee2-b7f6-61c4-c00d-166d9f56cbe7@oracle.com>
Date:   Mon, 11 Jan 2021 16:12:18 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108123905.30d647d4@omen.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/2021 2:39 PM, Alex Williamson wrote:
> On Tue,  5 Jan 2021 07:36:51 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Add a function that detects if an iommu_group has a valid container.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio.c  | 12 ++++++++++++
>>  include/linux/vfio.h |  1 +
>>  2 files changed, 13 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index 262ab0e..f89ab80 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -61,6 +61,7 @@ struct vfio_container {
>>  	struct vfio_iommu_driver	*iommu_driver;
>>  	void				*iommu_data;
>>  	bool				noiommu;
>> +	bool				closed;
>>  };
>>  
>>  struct vfio_unbound_dev {
>> @@ -1223,6 +1224,7 @@ static int vfio_fops_release(struct inode *inode, struct file *filep)
>>  
>>  	filep->private_data = NULL;
>>  
>> +	container->closed = true;
>>  	vfio_container_put(container);
>>  
>>  	return 0;
>> @@ -2216,6 +2218,16 @@ void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_group_set_kvm);
>>  
>> +bool vfio_iommu_group_contained(struct iommu_group *iommu_group)
>> +{
>> +	struct vfio_group *group = vfio_group_get_from_iommu(iommu_group);
>> +	bool ret = group && group->container && !group->container->closed;
>> +
>> +	vfio_group_put(group);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_iommu_group_contained);
> 
> This seems like a pointless interface, the result is immediately stale.
> Anything that relies on the container staying open needs to add itself
> as a user.  We already have some interfaces for that, ex.
> vfio_group_get_external_user().  Thanks,

The significant part here is container->closed, which is only set if userland closes the
container fd, which is a one-way trip -- the fd for this instance can never be opened 
again.  The container object may still have other references, and not be destroyed yet.
In patch 5, kernel code that waits for the RESUME ioctl calls this accessor to test if 
the ioctl will never arrive.

- Steve
 
>> +
>>  static int vfio_register_group_notifier(struct vfio_group *group,
>>  					unsigned long *events,
>>  					struct notifier_block *nb)
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index 38d3c6a..b2724e7 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -148,6 +148,7 @@ extern int vfio_unregister_notifier(struct device *dev,
>>  
>>  struct kvm;
>>  extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
>> +extern bool vfio_iommu_group_contained(struct iommu_group *group);
>>  
>>  /*
>>   * Sub-module helpers
> 
