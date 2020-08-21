Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C13B24D5C8
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 15:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgHUNHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 09:07:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19412 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726975AbgHUNHR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 09:07:17 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LD3cod085946;
        Fri, 21 Aug 2020 09:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rCX53BW9XWck10T5IMGv9OVxfYJ84h/kfh43uFw0aFQ=;
 b=rEWUNxN4NrA6aHediaUELPUNMJvgvQiDvTC6KTeQIJxnuOb6Va8ZFE0kC9/mhfm+KO1i
 nyNI81g3sdX2xXyVa9iBJG1dRGClBHzr3pGsKl5E57DRFGQWIVZJTsQjuK7CSsRlGuot
 NXh6VJJCbKVkmBpkx6TVffhpNBZ9r0Qp86f6mqW6wR893ZYxi9yfZzMD2L5zpSIsylxW
 GFDDdEwJw1HG7Zp3JB1+UnXdrhcB1vfX5mBseE0cGjctQaTXdQK2jiBKJNz99vPG6xRj
 Z3e0V6BPM6NMJML3mjFrC9i8VbEimpkRlpkUHtrnMOJkGUiKg9PtfJbYkJ4I8wP4iVoM RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 331yc8qbt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 09:07:07 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LD4TUx089473;
        Fri, 21 Aug 2020 09:07:07 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 331yc8qbrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 09:07:07 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LD59oq008635;
        Fri, 21 Aug 2020 13:07:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3304bujpcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 13:07:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LD5VHw459264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 13:05:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 845A9A404D;
        Fri, 21 Aug 2020 13:07:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC77A4051;
        Fri, 21 Aug 2020 13:06:59 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.168.20])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 13:06:59 +0000 (GMT)
Subject: Re: [PATCH v9 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <1597854198-2871-1-git-send-email-pmorel@linux.ibm.com>
 <1597854198-2871-3-git-send-email-pmorel@linux.ibm.com>
 <20200821140510.3849410c.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <19f742f8-8cc2-8f5a-90b0-c33e7b6a45b9@linux.ibm.com>
Date:   Fri, 21 Aug 2020 15:06:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200821140510.3849410c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_06:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-08-21 14:05, Cornelia Huck wrote:
> On Wed, 19 Aug 2020 18:23:18 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> If protected virtualization is active on s390, VIRTIO has retricted
> 
> s/retricted/only restricted/
> 
>> access to the guest memory.
>> Define CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS and export
>> arch_has_restricted_virtio_memory_access to advertize VIRTIO if that's
>> the case, preventing a host error on access attempt.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/Kconfig   |  1 +
>>   arch/s390/mm/init.c | 11 +++++++++++
>>   2 files changed, 12 insertions(+)
> 
> (...)
> 
>> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
>> index 6dc7c3b60ef6..8febd73ed6ca 100644
>> --- a/arch/s390/mm/init.c
>> +++ b/arch/s390/mm/init.c
>> @@ -45,6 +45,7 @@
>>   #include <asm/kasan.h>
>>   #include <asm/dma-mapping.h>
>>   #include <asm/uv.h>
>> +#include <linux/virtio_config.h>
> 
> I don't think you need this include anymore.

right,
> 
>>   
>>   pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>>   
> 
> (...)
> 
> With the nit fixed,
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
