Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332BD26B82C
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 02:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgIPAho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 20:37:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726576AbgIONXw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 09:23:52 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FCwapS143128;
        Tue, 15 Sep 2020 09:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lbjYXLezcfX0TD+v0MomMJVwhn27P9pwl9E0ixp99d4=;
 b=OEpnKORJXtDo8nWg3yXyT11N8FWlA9F8xpuqdd4nOnSU2HuqKL+jOIARkBiHlK18RIyQ
 vre/nWR9r+OCGfJdUz9r7UIXOKdUwhEVttsw8jQ3wqzzv+T26R7pUpwCd+/S3p33m1mP
 mYPJMeHFFTLyhizIaDaA8jGXMfWw6IYwX4Ol0v69YAHQ0qrkiooAS42Pt4PG/GxWJrZT
 xok9q2U4afCt55r028UD1E1ajz/aFG5UUBwnDqiyssvEDZaPq6ewnAozJvo6R37g6OZt
 AfYGr6QDs5DkrBVkXm4wJhTXBGcxjd9fvO0wRK/2tiahWixUYsAxJrWjKpYVkYORymdH pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jwnhhqwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 09:22:17 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08FCwgv1143561;
        Tue, 15 Sep 2020 09:22:17 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jwnhhqvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 09:22:17 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08FDMECX024631;
        Tue, 15 Sep 2020 13:22:16 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 33gny95k9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 13:22:16 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08FDMARe48955792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 13:22:10 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CB65136061;
        Tue, 15 Sep 2020 13:22:14 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CCAB13605D;
        Tue, 15 Sep 2020 13:22:13 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 13:22:13 +0000 (GMT)
Subject: Re: [PATCH v2] vfio iommu: Add dma available capability
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     alex.williamson@redhat.com, pmorel@linux.ibm.com,
        schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1600122331-12181-1-git-send-email-mjrosato@linux.ibm.com>
 <1600122331-12181-2-git-send-email-mjrosato@linux.ibm.com>
 <20200915114401.4db5e009.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <1e4ff5b6-f2de-228c-3cfb-5dee833000aa@linux.ibm.com>
Date:   Tue, 15 Sep 2020 09:22:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200915114401.4db5e009.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_08:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 phishscore=0 mlxlogscore=894 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/20 5:44 AM, Cornelia Huck wrote:
> On Mon, 14 Sep 2020 18:25:31 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container")
>> added the ability to limit the number of memory backed DMA mappings.
>> However on s390x, when lazy mapping is in use, we use a very large
>> number of concurrent mappings.  Let's provide the current allowable
>> number of DMA mappings to userspace via the IOMMU info chain so that
>> userspace can take appropriate mitigation.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
>>   include/uapi/linux/vfio.h       | 16 ++++++++++++++++
>>   2 files changed, 33 insertions(+)
> 
> (...)
> 
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 9204705..a8cc4a5 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1039,6 +1039,22 @@ struct vfio_iommu_type1_info_cap_migration {
>>   	__u64	max_dirty_bitmap_size;		/* in bytes */
>>   };
>>   
>> +/*
>> + * The DMA available capability allows to report the current number of
>> + * simultaneously outstanding DMA mappings that are allowed.
>> + *
>> + * The structures below define version 1 of this capability.
> 
> "The structure below defines..." ?
> 

OK

>> + *
>> + * max: specifies the maximum number of outstanding DMA mappings allowed.
> 
> I think you forgot to tweak that one:
> 
> "avail: specifies the current number of outstanding DMA mappings allowed."
> 
> ?

Yep, that's a leftover from v1 :(

> 
>> + */
>> +#define VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL 3
>> +
>> +struct vfio_iommu_type1_info_dma_avail {
>> +	struct	vfio_info_cap_header header;
>> +	__u32	avail;
>> +};
>> +
>> +
>>   #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>>   
>>   /**
> 

