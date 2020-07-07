Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71891216B49
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 13:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgGGLSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 07:18:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58202 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726540AbgGGLSA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 07:18:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 067B2hlP027315;
        Tue, 7 Jul 2020 07:17:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 324fapwumf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 07:17:54 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 067B4Alx033811;
        Tue, 7 Jul 2020 07:17:53 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 324fapwum0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 07:17:53 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 067B0TXM004660;
        Tue, 7 Jul 2020 11:17:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 322hd83dnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 11:17:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 067BGRsD61276438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jul 2020 11:16:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC2BEA4065;
        Tue,  7 Jul 2020 11:17:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFAFAA405C;
        Tue,  7 Jul 2020 11:17:47 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.29.12])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jul 2020 11:17:47 +0000 (GMT)
Subject: Re: [PATCH v4 1/2] virtio: let arch validate VIRTIO features
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        frankja@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1594111477-15401-1-git-send-email-pmorel@linux.ibm.com>
 <1594111477-15401-2-git-send-email-pmorel@linux.ibm.com>
 <20200707112652.42fcab80.cohuck@redhat.com>
 <afbb9979-9136-3d52-e6cb-4c6905f73b6d@de.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <8dd35508-8863-9a61-9535-5fa6f6b399fa@linux.ibm.com>
Date:   Tue, 7 Jul 2020 13:17:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <afbb9979-9136-3d52-e6cb-4c6905f73b6d@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_06:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007070081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-07 13:09, Christian Borntraeger wrote:
> 
> 
> On 07.07.20 11:26, Cornelia Huck wrote:
>> On Tue,  7 Jul 2020 10:44:36 +0200
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> An architecture may need to validate the VIRTIO devices features
>>> based on architecture specificities.
>>
>> s/specifities/specifics/

yes

>>
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   drivers/virtio/virtio.c       | 19 +++++++++++++++++++
>>>   include/linux/virtio_config.h |  1 +
>>>   2 files changed, 20 insertions(+)
>>>
>>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>>> index a977e32a88f2..3179a8aa76f5 100644
>>> --- a/drivers/virtio/virtio.c
>>> +++ b/drivers/virtio/virtio.c
>>> @@ -167,6 +167,21 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
>>>   }
>>>   EXPORT_SYMBOL_GPL(virtio_add_status);
>>>   
>>> +/*
>>> + * arch_needs_virtio_iommu_platform - provide arch specific hook when finalizing
>>
>> s/arch_needs_virtio_iommu_platform/arch_validate_virtio_features/
> 
> With the things from Conny fixed,
> 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
