Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E9E219E76
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 12:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGIK6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 06:58:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726357AbgGIK6V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 06:58:21 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069AW0dZ137680;
        Thu, 9 Jul 2020 06:58:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325uqvagwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 06:58:16 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 069AWrOs141843;
        Thu, 9 Jul 2020 06:58:16 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325uqvaguc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 06:58:16 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 069AtdJV011983;
        Thu, 9 Jul 2020 10:58:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 325u410f14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 10:58:13 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 069AwA1w58065042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 10:58:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79A01AE045;
        Thu,  9 Jul 2020 10:58:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4C8FAE04D;
        Thu,  9 Jul 2020 10:58:09 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.34.67])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 10:58:09 +0000 (GMT)
Subject: Re: [PATCH v5 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1594283959-13742-1-git-send-email-pmorel@linux.ibm.com>
 <1594283959-13742-3-git-send-email-pmorel@linux.ibm.com>
 <20200709105733.6d68fa53.cohuck@redhat.com>
 <20200709115553.2dde6ab1.pasic@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <12b1ca5c-fc03-18c7-bdca-cedabc5f1e1d@linux.ibm.com>
Date:   Thu, 9 Jul 2020 12:58:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709115553.2dde6ab1.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_05:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007090079
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-09 11:55, Halil Pasic wrote:
> On Thu, 9 Jul 2020 10:57:33 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
>> On Thu,  9 Jul 2020 10:39:19 +0200
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> If protected virtualization is active on s390, the virtio queues are
>>> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
>>> negotiated. Use the new arch_validate_virtio_features() interface to
>>> fail probe if that's not the case, preventing a host error on access
>>> attempt
> 
> Punctuation at the end?
> 
> Also 'that's not the case' refers to the negation
> 'VIRTIO_F_IOMMU_PLATFORM has been negotiated',
> arch_validate_virtio_features() is however part of
> virtio_finalize_features(), which is in turn part of the feature
> negotiation. But that is details. I'm fine with keeping the message as
> is.
> 
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   arch/s390/mm/init.c | 27 +++++++++++++++++++++++++++
>>>   1 file changed, 27 insertions(+)
>>>
>>> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
>>> index 6dc7c3b60ef6..b8e6f90117da 100644
>>> --- a/arch/s390/mm/init.c
>>> +++ b/arch/s390/mm/init.c
>>> @@ -45,6 +45,7 @@
>>>   #include <asm/kasan.h>
>>>   #include <asm/dma-mapping.h>
>>>   #include <asm/uv.h>
>>> +#include <linux/virtio_config.h>
>>>   
>>>   pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>>>   
>>> @@ -161,6 +162,32 @@ bool force_dma_unencrypted(struct device *dev)
>>>   	return is_prot_virt_guest();
>>>   }
>>>   
>>> +/*
>>> + * arch_validate_virtio_features
>>> + * @dev: the VIRTIO device being added
>>> + *
>>> + * Return an error if required features are missing on a guest running
>>> + * with protected virtualization.
>>> + */
>>> +int arch_validate_virtio_features(struct virtio_device *dev)
>>> +{
>>> +	if (!is_prot_virt_guest())
>>> +		return 0;
>>> +
>>> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
>>> +		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");
>>
>> I'd probably use "legacy virtio not supported with protected
>> virtualization".
>>
>>> +		return -ENODEV;
>>> +	}
>>> +
>>> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
>>> +		dev_warn(&dev->dev,
>>> +			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
>>
>> "support for limited memory access required for protected
>> virtualization"
>>
>> ?
>>
>> Mentioning the feature flag is shorter in both cases, though.
> 
> I liked the messages in v4. Why did we change those? Did somebody
> complain?
> 
> I prefer the old ones, but it any case:
> 
> Acked-by: Halil Pasic <pasic@linux.ibm.com>

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
