Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826E0216A8E
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 12:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgGGKjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 06:39:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728303AbgGGKjy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 06:39:54 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 067AXC68125215;
        Tue, 7 Jul 2020 06:39:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324hfqt9ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 06:39:49 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 067Aa30U136538;
        Tue, 7 Jul 2020 06:39:49 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324hfqt9ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 06:39:49 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 067AZnnd028259;
        Tue, 7 Jul 2020 10:39:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 322hd7uata-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 10:39:47 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 067Adihw64553450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jul 2020 10:39:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50586A405B;
        Tue,  7 Jul 2020 10:39:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71D0FA4060;
        Tue,  7 Jul 2020 10:39:43 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.29.12])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jul 2020 10:39:43 +0000 (GMT)
Subject: Re: [PATCH v4 1/2] virtio: let arch validate VIRTIO features
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1594111477-15401-1-git-send-email-pmorel@linux.ibm.com>
 <1594111477-15401-2-git-send-email-pmorel@linux.ibm.com>
 <20200707112652.42fcab80.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <7bdd36e4-a626-18e0-bc7a-fe1fe1b877d8@linux.ibm.com>
Date:   Tue, 7 Jul 2020 12:39:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707112652.42fcab80.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_06:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 clxscore=1015 cotscore=-2147483648 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007070081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-07 11:26, Cornelia Huck wrote:
> On Tue,  7 Jul 2020 10:44:36 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> An architecture may need to validate the VIRTIO devices features
>> based on architecture specificities.
> 
> s/specifities/specifics/

OK

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   drivers/virtio/virtio.c       | 19 +++++++++++++++++++
>>   include/linux/virtio_config.h |  1 +
>>   2 files changed, 20 insertions(+)
>>
>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>> index a977e32a88f2..3179a8aa76f5 100644
>> --- a/drivers/virtio/virtio.c
>> +++ b/drivers/virtio/virtio.c
>> @@ -167,6 +167,21 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
>>   }
>>   EXPORT_SYMBOL_GPL(virtio_add_status);
>>   
>> +/*
>> + * arch_needs_virtio_iommu_platform - provide arch specific hook when finalizing
> 
> s/arch_needs_virtio_iommu_platform/arch_validate_virtio_features/
> 
> :)

grrr... yes.

> 
>> + *				      features for VIRTIO device dev
>> + * @dev: the VIRTIO device being added
>> + *
>> + * Permits the platform to provide architecture specific functionality when
> 
> s/provide architecture specific functionality/handle architecture-specific requirements/
> 
> ?

better, thanks.

> 
>> + * devices features are finalized. This is the default implementation.
> 
> s/devices/device/

yes.

> 
>> + * Architecture implementations can override this.
>> + */
>> +
>> +int __weak arch_validate_virtio_features(struct virtio_device *dev)
>> +{
>> +	return 0;
>> +}
>> +
>>   int virtio_finalize_features(struct virtio_device *dev)
>>   {
>>   	int ret = dev->config->finalize_features(dev);
>> @@ -176,6 +191,10 @@ int virtio_finalize_features(struct virtio_device *dev)
>>   	if (ret)
>>   		return ret;
>>   
>> +	ret = arch_validate_virtio_features(dev);
>> +	if (ret)
>> +		return ret;
>> +
>>   	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>>   		return 0;
>>   
>> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
>> index bb4cc4910750..3f4117adf311 100644
>> --- a/include/linux/virtio_config.h
>> +++ b/include/linux/virtio_config.h
>> @@ -459,4 +459,5 @@ static inline void virtio_cwrite64(struct virtio_device *vdev,
>>   		_r;							\
>>   	})
>>   
>> +int arch_validate_virtio_features(struct virtio_device *dev);
>>   #endif /* _LINUX_VIRTIO_CONFIG_H */
> 
> With the wording fixed,
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks for the review.

regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
