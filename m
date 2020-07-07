Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5711A216A8B
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 12:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgGGKjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 06:39:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbgGGKju (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 06:39:50 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 067AXRKf129418;
        Tue, 7 Jul 2020 06:39:43 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324f7dv0cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 06:39:42 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 067AYHYF131555;
        Tue, 7 Jul 2020 06:39:42 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324f7dv0ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 06:39:40 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 067AafGE015944;
        Tue, 7 Jul 2020 10:39:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 322hd83ckw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 10:39:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 067AcIit393544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jul 2020 10:38:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC590A405B;
        Tue,  7 Jul 2020 10:38:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D362DA4054;
        Tue,  7 Jul 2020 10:38:17 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.29.12])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jul 2020 10:38:17 +0000 (GMT)
Subject: Re: [PATCH v4 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1594111477-15401-1-git-send-email-pmorel@linux.ibm.com>
 <1594111477-15401-3-git-send-email-pmorel@linux.ibm.com>
 <20200707114633.68122a00.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <e9976a77-f4a6-841d-6b95-59811751bce9@linux.ibm.com>
Date:   Tue, 7 Jul 2020 12:38:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707114633.68122a00.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_06:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1015
 cotscore=-2147483648 mlxscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007070077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-07 11:46, Cornelia Huck wrote:
> On Tue,  7 Jul 2020 10:44:37 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> S390, protecting the guest memory against unauthorized host access
>> needs to enforce VIRTIO I/O device protection through the use of
>> VIRTIO_F_VERSION_1 and VIRTIO_F_IOMMU_PLATFORM.
> 
> Hm... what about:
> 
> "If protected virtualization is active on s390, the virtio queues are
> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
> negotiated. Use the new arch_validate_virtio_features() interface to
> enforce this."

Yes, thanks.


> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/kernel/uv.c | 25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>> index c296e5c8dbf9..106330f6eda1 100644
>> --- a/arch/s390/kernel/uv.c
>> +++ b/arch/s390/kernel/uv.c
>> @@ -14,6 +14,7 @@
>>   #include <linux/memblock.h>
>>   #include <linux/pagemap.h>
>>   #include <linux/swap.h>
>> +#include <linux/virtio_config.h>
>>   #include <asm/facility.h>
>>   #include <asm/sections.h>
>>   #include <asm/uv.h>
>> @@ -413,3 +414,27 @@ static int __init uv_info_init(void)
>>   }
>>   device_initcall(uv_info_init);
>>   #endif
>> +
>> +/*
>> + * arch_validate_virtio_iommu_platform
> 
> s/arch_validate_virtio_iommu_platform/arch_validate_virtio_features/
> 
>> + * @dev: the VIRTIO device being added
>> + *
>> + * Return value: returns -ENODEV if any features of the
>> + *               device breaks the protected virtualization
>> + *               0 otherwise.
> 
> I don't think you need to specify the contract here: that belongs to
> the definition in the virtio core. What about simply adding a sentence
> "Return an error if required features are missing on a guest running
> with protected virtualization." ?

OK, right.

> 
>> + */
>> +int arch_validate_virtio_features(struct virtio_device *dev)
>> +{
> 
> Maybe jump out immediately if the guest is not protected?
> 
>> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
>> +		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");
>> +		return is_prot_virt_guest() ? -ENODEV : 0;
>> +	}
>> +
>> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
>> +		dev_warn(&dev->dev,
>> +			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
>> +		return is_prot_virt_guest() ? -ENODEV : 0;
>> +	}
> 
> if (!is_prot_virt_guest())
> 	return 0;
> 
> if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> 	dev_warn(&dev->dev,
>                   "legacy virtio is incompatible with protected guests");
> 	return -ENODEV;
> }
> 
> if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> 	dev_warn(&dev->dev,
> 		 "device does not work with limited memory access in protected guests");
> 	return -ENODEV;
> }

Yes, easier to read.

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
