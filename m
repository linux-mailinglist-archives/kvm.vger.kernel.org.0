Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76944216B46
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 13:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgGGLRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 07:17:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35684 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbgGGLRF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 07:17:05 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 067B3YK6042813;
        Tue, 7 Jul 2020 07:17:01 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324hfqu9k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 07:17:00 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 067B3dEa043066;
        Tue, 7 Jul 2020 07:17:00 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324hfqu9j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 07:17:00 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 067B1Ys4009631;
        Tue, 7 Jul 2020 11:16:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 322hd7spx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 11:16:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 067BGsop60948720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jul 2020 11:16:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8F2EA405F;
        Tue,  7 Jul 2020 11:16:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2A0BA405B;
        Tue,  7 Jul 2020 11:16:53 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.29.12])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jul 2020 11:16:53 +0000 (GMT)
Subject: Re: [PATCH v4 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1594111477-15401-1-git-send-email-pmorel@linux.ibm.com>
 <1594111477-15401-3-git-send-email-pmorel@linux.ibm.com>
 <862dce70-1aed-ace0-cb7b-54844e812be3@de.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <dbf28573-2100-20ed-9e8b-8e6d1795ec44@linux.ibm.com>
Date:   Tue, 7 Jul 2020 13:16:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <862dce70-1aed-ace0-cb7b-54844e812be3@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_07:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 clxscore=1015 cotscore=-2147483648 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007070085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-07 13:12, Christian Borntraeger wrote:
> 
> 
> On 07.07.20 10:44, Pierre Morel wrote:
>> S390, protecting the guest memory against unauthorized host access
>> needs to enforce VIRTIO I/O device protection through the use of
>> VIRTIO_F_VERSION_1 and VIRTIO_F_IOMMU_PLATFORM.
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
>> + * @dev: the VIRTIO device being added
>> + *
>> + * Return value: returns -ENODEV if any features of the
>> + *               device breaks the protected virtualization
>> + *               0 otherwise.
>> + */
>> +int arch_validate_virtio_features(struct virtio_device *dev)
>> +{
>> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
>> +		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");
> 
> I think you only want to warn if is_prot_virt_guest is true? We certainly
> want to be able to run as a guest of older hypervisors with virtio 0.95, no?

clear, yes.
I will first check for PV as Connie sugested.

> 
> 
>> +		return is_prot_virt_guest() ? -ENODEV : 0;
>> +	}
>> +
>> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
>> +		dev_warn(&dev->dev,
>> +			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
> 
> same here.

Yes,
Thanks,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
