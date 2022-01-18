Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19336492BDC
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbiARRFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:05:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230126AbiARRFt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:05:49 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IExOhl005948;
        Tue, 18 Jan 2022 17:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+KCwsBu6P5jzJDQBoiE73y6IsX3adaZvjsXMZUUDSCA=;
 b=ACyG0kY4pOMbp9hB0G/6RWzZJsgiEy4NJ86ExY4ckSUaQRupaQOn980ZuaEAGIN4fYZo
 4iG/uUjZ6cx8uVyDncwxRxBJA3snvA5F9XZ225IyGq1Cy/Yk+qOMVN+LBQ5KwcnT1qiF
 7o/EAiz4eYJBgnJHlZ88ocIzu4Vbdn2tfJ8h8l37AKCASmgrpY7EgFGr88dF3PiUohU5
 9mi5ZpJHKA63edlgdbWZcGcGk4wl5YxmLKKlUqCR9KPaXWgoP3AYxNpbPEbGhNIfvQvb
 ZGffdcO6t9hJGG9JHys9F4FWYyEqFMAr+cbmlgOwDbTXhXz4o0wLcN1O0N1Ay7gRDt9n vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnvpmsctq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:05:48 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IGgJXA018418;
        Tue, 18 Jan 2022 17:05:48 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnvpmsct3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:05:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IGuxxN029376;
        Tue, 18 Jan 2022 17:05:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3dknwad9fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:05:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IH5gqH17301930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:05:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 271EFAE057;
        Tue, 18 Jan 2022 17:05:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 713F6AE04D;
        Tue, 18 Jan 2022 17:05:41 +0000 (GMT)
Received: from [9.171.70.230] (unknown [9.171.70.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 17:05:41 +0000 (GMT)
Message-ID: <8be1829f-45e4-95c0-4b0a-96ade6e2533e@linux.ibm.com>
Date:   Tue, 18 Jan 2022 18:07:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v3 2/4] s390x: stsi: Define vm_is_kvm to be
 used in different tests
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
 <20220110133755.22238-3-pmorel@linux.ibm.com>
 <75d4a897-55dd-5140-ac8b-638fa18d2e17@linux.ibm.com>
 <e9a00d5f-98db-c68b-6cea-ecddb945d49b@linux.ibm.com>
 <08238127-2887-3da3-6fe4-8440e8275d46@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <08238127-2887-3da3-6fe4-8440e8275d46@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eyKrC_12-6zqa3BIgqTvMJprtWn6vLUr
X-Proofpoint-GUID: gzMiSyzCob7W2OcobNWkFt3l4mySYxtL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_04,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 phishscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/18/22 09:35, Janosch Frank wrote:
> On 1/17/22 15:57, Pierre Morel wrote:
>>
>>
>> On 1/11/22 13:27, Janosch Frank wrote:
>>> On 1/10/22 14:37, Pierre Morel wrote:
>>>> We need in several tests to check if the VM we are running in
>>>> is KVM.
>>>> Let's add the test.
>>>>
>>>> To check the VM type we use the STSI 3.2.2 instruction, let's
>>>> define it's response structure in a central header.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++++++
>>>>    lib/s390x/vm.c   | 39 +++++++++++++++++++++++++++++++++++++++
>>>>    lib/s390x/vm.h   |  1 +
>>>>    s390x/stsi.c     | 23 ++---------------------
>>>>    4 files changed, 74 insertions(+), 21 deletions(-)
>>>>    create mode 100644 lib/s390x/stsi.h
>>>>
>>>> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
>>>> new file mode 100644
>>>> index 00000000..02cc94a6
>>>> --- /dev/null
>>>> +++ b/lib/s390x/stsi.h
>>>> @@ -0,0 +1,32 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>>>> +/*
>>>> + * Structures used to Store System Information
>>>> + *
>>>> + * Copyright (c) 2021 IBM Inc
>>>> + */
>>>> +
>>>> +#ifndef _S390X_STSI_H_
>>>> +#define _S390X_STSI_H_
>>>> +
>>>> +struct sysinfo_3_2_2 {
>>>> +    uint8_t reserved[31];
>>>> +    uint8_t count;
>>>> +    struct {
>>>> +        uint8_t reserved2[4];
>>>> +        uint16_t total_cpus;
>>>> +        uint16_t conf_cpus;
>>>> +        uint16_t standby_cpus;
>>>> +        uint16_t reserved_cpus;
>>>> +        uint8_t name[8];
>>>> +        uint32_t caf;
>>>> +        uint8_t cpi[16];
>>>> +        uint8_t reserved5[3];
>>>> +        uint8_t ext_name_encoding;
>>>> +        uint32_t reserved3;
>>>> +        uint8_t uuid[16];
>>>> +    } vm[8];
>>>> +    uint8_t reserved4[1504];
>>>> +    uint8_t ext_names[8][256];
>>>> +};
>>>> +
>>>> +#endif  /* _S390X_STSI_H_ */
>>>> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
>>>> index a5b92863..3e11401e 100644
>>>> --- a/lib/s390x/vm.c
>>>> +++ b/lib/s390x/vm.c
>>>> @@ -12,6 +12,7 @@
>>>>    #include <alloc_page.h>
>>>>    #include <asm/arch_def.h>
>>>>    #include "vm.h"
>>>> +#include "stsi.h"
>>>>    /**
>>>>     * Detect whether we are running with TCG (instead of KVM)
>>>
>>> We could add a fc < 3 check to the vm_is_tcg() function and add a
>>
>> OK
>>
>>> vm_is_lpar() which does a simple fc ==1 check.
>>
>> hum, the doc says 1 is basic, 2 is lpar, 3 is vm, shouldn't we
>> do a check on fc == 2 or have a vm_is_vm checking fc < 3 ?
>>
> 
> Right
> I'll do some tests on the lpar stsi output and have a look what we get 
> back.
> 
>> Do you have an experimental return on this?
> 
> ENOPARSE

:) you just answered.
I wanted to ask if you did tests which gave you "1" as result.


-- 
Pierre Morel
IBM Lab Boeblingen
