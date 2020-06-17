Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813DB1FCF30
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 16:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgFQOM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 10:12:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726328AbgFQOM4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 10:12:56 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HE6Tjk135905;
        Wed, 17 Jun 2020 10:12:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6hdr6du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 10:12:48 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HE7P0c146770;
        Wed, 17 Jun 2020 10:12:48 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6hdr6cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 10:12:48 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HEBHtQ000389;
        Wed, 17 Jun 2020 14:12:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 31q6c90fef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 14:12:46 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HEChCu14614638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 14:12:43 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46F6D11C058;
        Wed, 17 Jun 2020 14:12:43 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A6AC11C050;
        Wed, 17 Jun 2020 14:12:42 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.186.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 14:12:42 +0000 (GMT)
Subject: Re: [PATCH v3 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1592390637-17441-1-git-send-email-pmorel@linux.ibm.com>
 <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
 <e5204218-6e93-8713-6056-2a62531c310e@amd.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <64544f14-eecf-6dda-d232-0bceeb2840ff@linux.ibm.com>
Date:   Wed, 17 Jun 2020 16:12:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e5204218-6e93-8713-6056-2a62531c310e@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_04:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 mlxscore=0 priorityscore=1501 cotscore=-2147483648 malwarescore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-17 15:36, Tom Lendacky wrote:
> On 6/17/20 5:43 AM, Pierre Morel wrote:
>> An architecture protecting the guest memory against unauthorized host
>> access may want to enforce VIRTIO I/O device protection through the
>> use of VIRTIO_F_IOMMU_PLATFORM.
>>
>> Let's give a chance to the architecture to accept or not devices
>> without VIRTIO_F_IOMMU_PLATFORM.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>   arch/s390/mm/init.c     |  6 ++++++
>>   drivers/virtio/virtio.c | 22 ++++++++++++++++++++++
>>   include/linux/virtio.h  |  2 ++
>>   3 files changed, 30 insertions(+)
>>
>> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
>> index 6dc7c3b60ef6..215070c03226 100644
>> --- a/arch/s390/mm/init.c
>> +++ b/arch/s390/mm/init.c
>> @@ -45,6 +45,7 @@
>>   #include <asm/kasan.h>
>>   #include <asm/dma-mapping.h>
>>   #include <asm/uv.h>
>> +#include <linux/virtio.h>
>>   
>>   pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>>   
>> @@ -161,6 +162,11 @@ bool force_dma_unencrypted(struct device *dev)
>>   	return is_prot_virt_guest();
>>   }
>>   
>> +int arch_needs_virtio_iommu_platform(struct virtio_device *dev)
>> +{
>> +	return is_prot_virt_guest();
>> +}
>> +
>>   /* protected virtualization */
>>   static void pv_init(void)
>>   {
>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>> index a977e32a88f2..aa8e01104f86 100644
>> --- a/drivers/virtio/virtio.c
>> +++ b/drivers/virtio/virtio.c
>> @@ -167,6 +167,21 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
>>   }
>>   EXPORT_SYMBOL_GPL(virtio_add_status);
>>   
>> +/*
>> + * arch_needs_virtio_iommu_platform - provide arch specific hook when finalizing
>> + *				      features for VIRTIO device dev
>> + * @dev: the VIRTIO device being added
>> + *
>> + * Permits the platform to provide architecture specific functionality when
>> + * devices features are finalized. This is the default implementation.
>> + * Architecture implementations can override this.
>> + */
>> +
>> +int __weak arch_needs_virtio_iommu_platform(struct virtio_device *dev)
>> +{
>> +	return 0;
>> +}
>> +
>>   int virtio_finalize_features(struct virtio_device *dev)
>>   {
>>   	int ret = dev->config->finalize_features(dev);
>> @@ -179,6 +194,13 @@ int virtio_finalize_features(struct virtio_device *dev)
>>   	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>>   		return 0;
>>   
>> +	if (arch_needs_virtio_iommu_platform(dev) &&
>> +		!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> 
> Just a style nit, but the "!virtio..." should be directly under the
> "arch_...", not tabbed out.

Oh right, thanks!

Pierre

> 
> Thanks,
> Tom
> 

...snip...

-- 
Pierre Morel
IBM Lab Boeblingen
