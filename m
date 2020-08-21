Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6717524D5D0
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 15:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgHUNIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 09:08:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbgHUNIt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 09:08:49 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LD3lYP105348;
        Fri, 21 Aug 2020 09:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XHpFRlBvLhzPbNUy/WcR7Iba8tVUXqJsA+kYx9ImcwQ=;
 b=EMRP2UcRsr3sZwUzXHOWWexcYGjU2w0YVHsaQkP68KAgzlTSDrRFQB5khT8JiiaQIrAS
 pEQwHETzP1EQvf2nmoNReYSShT4NJEjjD00afwBF7hv9e9SQ+NFxBT50uH0NZUnfD6E6
 5N0m8RJGkhESMM5KwK0nMsJlLJk8lSWCNC6/GhhCShzJlWIu4R8FdjIeHAYYSGx/GXRs
 KICBhHfeSx6Z1CklvxIMMbpCNo/yPbQD7yz6bGrWv8IWFPaV3xXYNGQYqQu64rlIbW4j
 EHMJqEL5sD3gC5RpSjTjpAt9BAQ3XJi95JcG5TToHEiyEbNwMbMGdb+IqKfOMtbBenZB sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3328e9ay0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 09:08:44 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LD40OG106366;
        Fri, 21 Aug 2020 09:08:43 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3328e9axxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 09:08:43 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LD4U0d020685;
        Fri, 21 Aug 2020 13:08:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3304c92pmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 13:08:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LD8bGS61604294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 13:08:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7057A405D;
        Fri, 21 Aug 2020 13:08:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BFC6A4055;
        Fri, 21 Aug 2020 13:08:37 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.168.20])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 13:08:36 +0000 (GMT)
Subject: Re: [PATCH v9 1/2] virtio: let arch advertise guest's memory access
 restrictions
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <1597854198-2871-1-git-send-email-pmorel@linux.ibm.com>
 <1597854198-2871-2-git-send-email-pmorel@linux.ibm.com>
 <20200821135906.1c6bede3.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <91c83bba-9a75-4ed4-b682-fcdce26edd54@linux.ibm.com>
Date:   Fri, 21 Aug 2020 15:08:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200821135906.1c6bede3.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-08-21 13:59, Cornelia Huck wrote:
> On Wed, 19 Aug 2020 18:23:17 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> An architecture may restrict host access to guest memory.
> 
> "e.g. IBM s390 Secure Execution or AMD SEV"
> 
> Just to make clearer what you are referring to?

yes, thanks

> 
>>
>> Provide a new Kconfig entry the architecture can select,
>> CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS, when it provides
>> the arch_has_restricted_virtio_memory_access callback to advertise
> 
> s/advertise/advertise to/

OK

> 
>> VIRTIO common code when the architecture restricts memory access
>> from the host.
> 
> "The common code can then fail the probe for any device where
> VIRTIO_F_IOMMU_PLATFORM is required, but not set."
> 
> ?

Yes, better thanks

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   drivers/virtio/Kconfig        |  6 ++++++
>>   drivers/virtio/virtio.c       | 15 +++++++++++++++
>>   include/linux/virtio_config.h |  9 +++++++++
>>   3 files changed, 30 insertions(+)
>>
>> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
>> index 5809e5f5b157..509f3b4d8ba1 100644
>> --- a/drivers/virtio/Kconfig
>> +++ b/drivers/virtio/Kconfig
>> @@ -6,6 +6,12 @@ config VIRTIO
>>   	  bus, such as CONFIG_VIRTIO_PCI, CONFIG_VIRTIO_MMIO, CONFIG_RPMSG
>>   	  or CONFIG_S390_GUEST.
>>   
>> +config ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS
>> +	bool
>> +	help
>> +	  This option is selected by any architecture enforcing
>> +	  VIRTIO_F_IOMMU_PLATFORM
> 
> "This option is selected if the architecture may need to enforce
> VIRTIO_F_IOMMU_PLATFORM."
> 
> ?

yes, better thanks

> 
>> +
>>   menuconfig VIRTIO_MENU
>>   	bool "Virtio drivers"
>>   	default y
> 
> (...)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

I will make the rewordings.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
