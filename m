Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A34219E41
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 12:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgGIKwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 06:52:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47754 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbgGIKwN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 06:52:13 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069AX7Cc090673;
        Thu, 9 Jul 2020 06:52:05 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325wbv7gtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 06:52:05 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 069AXgrM091981;
        Thu, 9 Jul 2020 06:52:04 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325wbv7gt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 06:52:04 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 069ApOtI015883;
        Thu, 9 Jul 2020 10:52:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 325k2drdgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 10:52:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 069Apxrw46727170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 10:51:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A50FAE056;
        Thu,  9 Jul 2020 10:51:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4B58AE051;
        Thu,  9 Jul 2020 10:51:58 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.34.67])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 10:51:58 +0000 (GMT)
Subject: Re: [PATCH v5 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1594283959-13742-1-git-send-email-pmorel@linux.ibm.com>
 <1594283959-13742-3-git-send-email-pmorel@linux.ibm.com>
 <20200709105733.6d68fa53.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <270d8674-0f73-0a38-a2a7-fbc1caa44301@linux.ibm.com>
Date:   Thu, 9 Jul 2020 12:51:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709105733.6d68fa53.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_05:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 phishscore=0 suspectscore=0 adultscore=0 spamscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-09 10:57, Cornelia Huck wrote:
> On Thu,  9 Jul 2020 10:39:19 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> If protected virtualization is active on s390, the virtio queues are
>> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
>> negotiated. Use the new arch_validate_virtio_features() interface to
>> fail probe if that's not the case, preventing a host error on access
>> attempt
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/mm/init.c | 27 +++++++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>
>> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
>> index 6dc7c3b60ef6..b8e6f90117da 100644
>> --- a/arch/s390/mm/init.c
>> +++ b/arch/s390/mm/init.c
>> @@ -45,6 +45,7 @@
>>   #include <asm/kasan.h>
>>   #include <asm/dma-mapping.h>
>>   #include <asm/uv.h>
>> +#include <linux/virtio_config.h>
>>   
>>   pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>>   
>> @@ -161,6 +162,32 @@ bool force_dma_unencrypted(struct device *dev)
>>   	return is_prot_virt_guest();
>>   }
>>   
>> +/*
>> + * arch_validate_virtio_features
>> + * @dev: the VIRTIO device being added
>> + *
>> + * Return an error if required features are missing on a guest running
>> + * with protected virtualization.
>> + */
>> +int arch_validate_virtio_features(struct virtio_device *dev)
>> +{
>> +	if (!is_prot_virt_guest())
>> +		return 0;
>> +
>> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
>> +		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");
> 
> I'd probably use "legacy virtio not supported with protected
> virtualization".
> 
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
>> +		dev_warn(&dev->dev,
>> +			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
> 
> "support for limited memory access required for protected
> virtualization"
> 
> ?
> 
> Mentioning the feature flag is shorter in both cases, though.

And I think easier to look for in case of debugging purpose.
I change it if there is more demands.

> 
>> +		return -ENODEV;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   /* protected virtualization */
>>   static void pv_init(void)
>>   {
> 
> Either way,
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
