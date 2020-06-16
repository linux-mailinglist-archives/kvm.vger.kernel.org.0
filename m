Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2861FAEA7
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 12:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgFPKxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 06:53:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51676 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725775AbgFPKxF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 06:53:05 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GAVD7s012471;
        Tue, 16 Jun 2020 06:52:57 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31pjnayuk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 06:52:57 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05GAVRfu013411;
        Tue, 16 Jun 2020 06:52:56 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31pjnayujb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 06:52:56 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05GAk93I029967;
        Tue, 16 Jun 2020 10:52:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 31mpe856fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 10:52:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05GAqps163897766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 10:52:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC36B4C040;
        Tue, 16 Jun 2020 10:52:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 022204C04A;
        Tue, 16 Jun 2020 10:52:51 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.26.88])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jun 2020 10:52:50 +0000 (GMT)
Subject: Re: [PATCH v2 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        David Gibson <david@gibson.dropbear.id.au>,
        Ram Pai <linuxram@us.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <1592224764-1258-1-git-send-email-pmorel@linux.ibm.com>
 <1592224764-1258-2-git-send-email-pmorel@linux.ibm.com>
 <20200616115202.0285aa08.pasic@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ef235cc9-9d4b-1247-c01a-9dd1c63f437c@linux.ibm.com>
Date:   Tue, 16 Jun 2020 12:52:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200616115202.0285aa08.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_04:2020-06-15,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 priorityscore=1501 cotscore=-2147483648 malwarescore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006160075
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-16 11:52, Halil Pasic wrote:
> On Mon, 15 Jun 2020 14:39:24 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> I find the subject (commit short) sub optimal. The 'arch' is already
> accepting devices 'without IOMMU feature'. What you are introducing is
> the ability to reject.
> 
>> An architecture protecting the guest memory against unauthorized host
>> access may want to enforce VIRTIO I/O device protection through the
>> use of VIRTIO_F_IOMMU_PLATFORM.
>>
>> Let's give a chance to the architecture to accept or not devices
>> without VIRTIO_F_IOMMU_PLATFORM.
>>
> 
> I don't particularly like the commit message. In general, I believe
> using access_platform instead of iommu_platform would really benefit us.

IOMMU_PLATFORM is used overall in Linux, and I did not find any 
occurrence for ACCESS_PLATFORM.


> 
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/mm/init.c     | 6 ++++++
>>   drivers/virtio/virtio.c | 9 +++++++++
>>   include/linux/virtio.h  | 2 ++
>>   3 files changed, 17 insertions(+)
>>
>> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
>> index 87b2d024e75a..3f04ad09650f 100644
>> --- a/arch/s390/mm/init.c
>> +++ b/arch/s390/mm/init.c
>> @@ -46,6 +46,7 @@
>>   #include <asm/kasan.h>
>>   #include <asm/dma-mapping.h>
>>   #include <asm/uv.h>
>> +#include <linux/virtio.h>
> 
> arch/s390/mm/init.c including virtio.h looks a bit strange to me, but
> if Heiko and Vasily don't mind, neither do I.

Do we have a better place to install the hook?
I though that since it is related to memory management and that, since 
force_dma_unencrypted already is there, it would be a good place.

However, kvm-s390 is another candidate.

> 
>>   
>>   pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>>   
>> @@ -162,6 +163,11 @@ bool force_dma_unencrypted(struct device *dev)
>>   	return is_prot_virt_guest();
>>   }
>>   
>> +int arch_needs_iommu_platform(struct virtio_device *dev)
> 
> Maybe prefixing the name with virtio_ would help provide the
> proper context.

The virtio_dev makes it obvious and from the virtio side it should be 
obvious that the arch is responsible for this.

However if nobody has something against I change it.

> 
>> +{
>> +	return is_prot_virt_guest();
>> +}
>> +
>>   /* protected virtualization */
>>   static void pv_init(void)
>>   {
>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>> index a977e32a88f2..30091089bee8 100644
>> --- a/drivers/virtio/virtio.c
>> +++ b/drivers/virtio/virtio.c
>> @@ -167,6 +167,11 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
>>   }
>>   EXPORT_SYMBOL_GPL(virtio_add_status);
>>   
>> +int __weak arch_needs_iommu_platform(struct virtio_device *dev)
>> +{
>> +	return 0;
>> +}
>> +
> 
> Adding some people that could be interested in overriding this as well
> to the cc list.

Thanks,

> 
>>   int virtio_finalize_features(struct virtio_device *dev)
>>   {
>>   	int ret = dev->config->finalize_features(dev);
>> @@ -179,6 +184,10 @@ int virtio_finalize_features(struct virtio_device *dev)
>>   	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>>   		return 0;
>>   
>> +	if (arch_needs_iommu_platform(dev) &&
>> +		!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM))
>> +		return -EIO;
>> +
> 
> Why EIO?

Because I/O can not occur correctly?
I am open to suggestions.

> 
> Overall, I think it is a good idea to have something that is going to
> protect us from this scenario.
> 

It would clearly be a good thing that trusted hypervizors like QEMU 
forbid this scenario however should we let the door open?

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
