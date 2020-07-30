Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367C32330F9
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 13:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgG3LcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 07:32:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3160 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726615AbgG3LcV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 07:32:21 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UBW5MM026230;
        Thu, 30 Jul 2020 07:32:12 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32kv5rj4q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 07:32:11 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06UBW9cu026634;
        Thu, 30 Jul 2020 07:32:11 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32kv5rj4hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 07:32:11 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06UBKROE016839;
        Thu, 30 Jul 2020 11:31:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 32gcqgp3wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 11:31:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06UBVrQT9568562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 11:31:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACC43520C9;
        Thu, 30 Jul 2020 11:31:51 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.51.62])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 893CB52133;
        Thu, 30 Jul 2020 11:31:20 +0000 (GMT)
Subject: Re: [PATCH v7 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <1594801869-13365-1-git-send-email-pmorel@linux.ibm.com>
 <1594801869-13365-3-git-send-email-pmorel@linux.ibm.com>
 <20200715054807-mutt-send-email-mst@kernel.org>
 <bc5e09ad-faaf-8b38-83e0-5f4a4b1daeb0@redhat.com>
 <20200715074917-mutt-send-email-mst@kernel.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <e41d039c-5fe2-b9db-093b-c0dddcc2ad4f@linux.ibm.com>
Date:   Thu, 30 Jul 2020 13:31:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715074917-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_09:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


gentle ping.


On 2020-07-15 13:51, Michael S. Tsirkin wrote:
> On Wed, Jul 15, 2020 at 06:16:59PM +0800, Jason Wang wrote:
>>
>> On 2020/7/15 下午5:50, Michael S. Tsirkin wrote:
>>> On Wed, Jul 15, 2020 at 10:31:09AM +0200, Pierre Morel wrote:
>>>> If protected virtualization is active on s390, the virtio queues are
>>>> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
>>>> negotiated. Use the new arch_validate_virtio_features() interface to
>>>> fail probe if that's not the case, preventing a host error on access
>>>> attempt.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>>> Acked-by: Halil Pasic <pasic@linux.ibm.com>
>>>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> ---
>>>>    arch/s390/mm/init.c | 28 ++++++++++++++++++++++++++++
>>>>    1 file changed, 28 insertions(+)
>>>>
>>>> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
>>>> index 6dc7c3b60ef6..d39af6554d4f 100644
>>>> --- a/arch/s390/mm/init.c
>>>> +++ b/arch/s390/mm/init.c
>>>> @@ -45,6 +45,7 @@
>>>>    #include <asm/kasan.h>
>>>>    #include <asm/dma-mapping.h>
>>>>    #include <asm/uv.h>
>>>> +#include <linux/virtio_config.h>
>>>>    pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>>>> @@ -161,6 +162,33 @@ bool force_dma_unencrypted(struct device *dev)
>>>>    	return is_prot_virt_guest();
>>>>    }
>>>> +/*
>>>> + * arch_validate_virtio_features
>>>> + * @dev: the VIRTIO device being added
>>>> + *
>>>> + * Return an error if required features are missing on a guest running
>>>> + * with protected virtualization.
>>>> + */
>>>> +int arch_validate_virtio_features(struct virtio_device *dev)
>>>> +{
>>>> +	if (!is_prot_virt_guest())
>>>> +		return 0;
>>>> +
>>>> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
>>>> +		dev_warn(&dev->dev,
>>>> +			 "legacy virtio not supported with protected virtualization\n");
>>>> +		return -ENODEV;
>>>> +	}
>>>> +
>>>> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
>>>> +		dev_warn(&dev->dev,
>>>> +			 "support for limited memory access required for protected virtualization\n");
>>>> +		return -ENODEV;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>    /* protected virtualization */
>>>>    static void pv_init(void)
>>>>    {
>>> What bothers me here is that arch code depends on virtio now.
>>> It works even with a modular virtio when functions are inline,
>>> but it seems fragile: e.g. it breaks virtio as an out of tree module,
>>> since layout of struct virtio_device can change.
>>
>>
>> The code was only called from virtio.c so it should be fine.
>>
>> And my understanding is that we don't need to care about the kABI issue
>> during upstream development?
>>
>> Thanks
> 
> No, but so far it has been convenient at least for me, for development,
> to just be able to unload all of virtio and load a different version.
> 
> 
>>
>>>
>>> I'm not sure what to do with this yet, will try to think about it
>>> over the weekend. Thanks!
>>>
>>>
>>>> -- 
>>>> 2.25.1
> 

-- 
Pierre Morel
IBM Lab Boeblingen
