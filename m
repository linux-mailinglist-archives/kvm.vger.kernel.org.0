Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21E266810
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 20:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbgIKSJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 14:09:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgIKSJP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 14:09:15 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BI4ija007043;
        Fri, 11 Sep 2020 14:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MIUpt10ZTd/d8+sVytWwb8B8j38fUC83MUE3OWcxIRA=;
 b=q8Tbe8XYG+Wt7GVpMa3bHxBDenaQVN8IXHmagcvdUIR40iKv7BglQFDny9Z6zn+7kGcm
 rpqNKykpC5JR3NqN0QOGKVs6akhqxmXv7zXQwuzj//uV7cLleuEP/pvZrIiDa3dp59IX
 2qoFfIC0gq7N/+YqYV+FGHzUM0yxXrs4TIQJ8FGnUxwjQIvX9s3H2fXOaMDvLlvDFlIz
 HEs5ehP/Qyjb+zSDzX0lwarG1Se0hMwd4ToeUkwtTNL8FljOmNZ5QvQUx++67FuIbvZw
 QD0i7kH4+YSm+f0kZSjMnICwGYK54kZ0nNpYiao6GymfOY8PYCFQ5gfxpfSC3mlyC/Pr LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33gdmjgx8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 14:09:13 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08BI6lfZ019614;
        Fri, 11 Sep 2020 14:09:13 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33gdmjgx81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 14:09:13 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08BI7x7f017968;
        Fri, 11 Sep 2020 18:09:12 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 33d46ngvf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 18:09:12 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08BI97MI262706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 18:09:07 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D551C6055;
        Fri, 11 Sep 2020 18:09:10 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCAFDC6057;
        Fri, 11 Sep 2020 18:09:09 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.91.207])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 11 Sep 2020 18:09:09 +0000 (GMT)
Subject: Re: [PATCH] vfio iommu: Add dma limit capability
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1599842643-2553-1-git-send-email-mjrosato@linux.ibm.com>
 <1599842643-2553-2-git-send-email-mjrosato@linux.ibm.com>
 <20200911110915.13302afa@w520.home>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <ced5c20e-b4a2-ce0f-ceef-b6bb311de607@linux.ibm.com>
Date:   Fri, 11 Sep 2020 14:09:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200911110915.13302afa@w520.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_09:2020-09-10,2020-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/20 1:09 PM, Alex Williamson wrote:
> On Fri, 11 Sep 2020 12:44:03 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container")
>> added the ability to limit the number of memory backed DMA mappings.
>> However on s390x, when lazy mapping is in use, we use a very large
>> number of concurrent mappings.  Let's provide the limitation to
>> userspace via the IOMMU info chain so that userspace can take
>> appropriate mitigation.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
>>   include/uapi/linux/vfio.h       | 16 ++++++++++++++++
>>   2 files changed, 33 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 5fbf0c1..573c2c9 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -2609,6 +2609,20 @@ static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
>>   	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
>>   }
>>   
>> +static int vfio_iommu_dma_limit_build_caps(struct vfio_iommu *iommu,
>> +					   struct vfio_info_cap *caps)
>> +{
>> +	struct vfio_iommu_type1_info_dma_limit cap_dma_limit;
>> +
>> +	cap_dma_limit.header.id = VFIO_IOMMU_TYPE1_INFO_DMA_LIMIT;
>> +	cap_dma_limit.header.version = 1;
>> +
>> +	cap_dma_limit.max = dma_entry_limit;
> 
> 
> I think you want to report iommu->dma_avail, which might change the
> naming and semantics of the capability a bit.  dma_entry_limit is a
> writable module param, so the current value might not be relevant to
> this container at the time that it's read.  When a container is opened
> we set iommu->dma_avail to the current dma_entry_limit, therefore later
> modifications of dma_entry_limit are only relevant to subsequent
> containers.
> 
> It seems like there are additional benefits to reporting available dma
> entries as well, for example on mapping failure userspace could
> reevaluate, perhaps even validate usage counts between kernel and user.

Hmm, both good points.  I'll re-work to something that presents the 
current dma_avail for the container instead.  Thanks!

> Thanks,
> 
> Alex
> 
>> +
>> +	return vfio_info_add_capability(caps, &cap_dma_limit.header,
>> +					sizeof(cap_dma_limit));
>> +}
>> +
>>   static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
>>   				     unsigned long arg)
>>   {
>> @@ -2642,6 +2656,9 @@ static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
>>   	ret = vfio_iommu_migration_build_caps(iommu, &caps);
>>   
>>   	if (!ret)
>> +		ret = vfio_iommu_dma_limit_build_caps(iommu, &caps);
>> +
>> +	if (!ret)
>>   		ret = vfio_iommu_iova_build_caps(iommu, &caps);
>>   
>>   	mutex_unlock(&iommu->lock);
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 9204705..c91e471 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1039,6 +1039,22 @@ struct vfio_iommu_type1_info_cap_migration {
>>   	__u64	max_dirty_bitmap_size;		/* in bytes */
>>   };
>>   
>> +/*
>> + * The DMA limit capability allows to report the number of simultaneously
>> + * outstanding DMA mappings are supported.
>> + *
>> + * The structures below define version 1 of this capability.
>> + *
>> + * max: specifies the maximum number of outstanding DMA mappings allowed.
>> + */
>> +#define VFIO_IOMMU_TYPE1_INFO_DMA_LIMIT 3
>> +
>> +struct vfio_iommu_type1_info_dma_limit {
>> +	struct	vfio_info_cap_header header;
>> +	__u32	max;
>> +};
>> +
>> +
>>   #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>>   
>>   /**
> 

