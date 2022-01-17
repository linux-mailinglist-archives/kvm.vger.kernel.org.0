Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1432490AD1
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 15:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbiAQO4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 09:56:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3242 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234410AbiAQO4A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 09:56:00 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HE9Mmq021756;
        Mon, 17 Jan 2022 14:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EM/Zo8XomvPxayzfziPj1hc+/GTt4F6iaw8bM5d2Uy4=;
 b=kbFBUgPIc6nCXcwUWFLvnpmiek+rc9lbJnm/k2EH3R5u7gcNEYmU5PRSkalA1ke04yUg
 wk683lx9ZTe2oY8i5URyxoYmbBMK+e5GkA41kNL8us03biH+L6plmsE42ChOUlRS/HkL
 S+rFklhhAhY+xTIdFM1fUUxLR/4l8Rj6t/xcPexFIeMUhoNC7FPtIrBz+rNbGvZ+2pPU
 SJLklP9VXOsYNZbMmdFgkG86LvOU4NqR69csFRlCFpeTGdHSw5kHJTieOjX0jBvUR1op
 aljOq+4w3N7w9gwTrBVkQUP7rWF+J4lwEG9mARINm+mVdR/dIbCfeUNmzzHKsDW4u00R 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn7m6uxp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 14:55:59 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HEpip6019093;
        Mon, 17 Jan 2022 14:55:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn7m6uxnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 14:55:58 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HEt9xV023751;
        Mon, 17 Jan 2022 14:55:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9d5vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 14:55:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HEtouh43712914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 14:55:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6C784C058;
        Mon, 17 Jan 2022 14:55:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C02F4C040;
        Mon, 17 Jan 2022 14:55:50 +0000 (GMT)
Received: from [9.171.80.201] (unknown [9.171.80.201])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 14:55:50 +0000 (GMT)
Message-ID: <e9a00d5f-98db-c68b-6cea-ecddb945d49b@linux.ibm.com>
Date:   Mon, 17 Jan 2022 15:57:33 +0100
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
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <75d4a897-55dd-5140-ac8b-638fa18d2e17@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cCI8CGwWuimwq4bBLjP7j50huPVu9WWC
X-Proofpoint-GUID: 1i6VZURULOndMQ0qps5Vwk82AIDwLVHU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201170093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/22 13:27, Janosch Frank wrote:
> On 1/10/22 14:37, Pierre Morel wrote:
>> We need in several tests to check if the VM we are running in
>> is KVM.
>> Let's add the test.
>>
>> To check the VM type we use the STSI 3.2.2 instruction, let's
>> define it's response structure in a central header.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++++++
>>   lib/s390x/vm.c   | 39 +++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/vm.h   |  1 +
>>   s390x/stsi.c     | 23 ++---------------------
>>   4 files changed, 74 insertions(+), 21 deletions(-)
>>   create mode 100644 lib/s390x/stsi.h
>>
>> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
>> new file mode 100644
>> index 00000000..02cc94a6
>> --- /dev/null
>> +++ b/lib/s390x/stsi.h
>> @@ -0,0 +1,32 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + * Structures used to Store System Information
>> + *
>> + * Copyright (c) 2021 IBM Inc
>> + */
>> +
>> +#ifndef _S390X_STSI_H_
>> +#define _S390X_STSI_H_
>> +
>> +struct sysinfo_3_2_2 {
>> +    uint8_t reserved[31];
>> +    uint8_t count;
>> +    struct {
>> +        uint8_t reserved2[4];
>> +        uint16_t total_cpus;
>> +        uint16_t conf_cpus;
>> +        uint16_t standby_cpus;
>> +        uint16_t reserved_cpus;
>> +        uint8_t name[8];
>> +        uint32_t caf;
>> +        uint8_t cpi[16];
>> +        uint8_t reserved5[3];
>> +        uint8_t ext_name_encoding;
>> +        uint32_t reserved3;
>> +        uint8_t uuid[16];
>> +    } vm[8];
>> +    uint8_t reserved4[1504];
>> +    uint8_t ext_names[8][256];
>> +};
>> +
>> +#endif  /* _S390X_STSI_H_ */
>> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
>> index a5b92863..3e11401e 100644
>> --- a/lib/s390x/vm.c
>> +++ b/lib/s390x/vm.c
>> @@ -12,6 +12,7 @@
>>   #include <alloc_page.h>
>>   #include <asm/arch_def.h>
>>   #include "vm.h"
>> +#include "stsi.h"
>>   /**
>>    * Detect whether we are running with TCG (instead of KVM)
> 
> We could add a fc < 3 check to the vm_is_tcg() function and add a 

OK

> vm_is_lpar() which does a simple fc ==1 check.

hum, the doc says 1 is basic, 2 is lpar, 3 is vm, shouldn't we
do a check on fc == 2 or have a vm_is_vm checking fc < 3 ?

Do you have an experimental return on this?

> 
>> @@ -43,3 +44,41 @@ out:
>>       free_page(buf);
>>       return is_tcg;
>>   }
>> +
>> +/**
>> + * Detect whether we are running with KVM
>> + */
>> +
>> +bool vm_is_kvm(void)
>> +{
>> +    /* EBCDIC for "KVM/" */
>> +    const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
>> +    static bool initialized;
>> +    static bool is_kvm;
>> +    struct sysinfo_3_2_2 *stsi_322;
>> +
>> +    if (initialized)
>> +        return is_kvm;
>> +
>> +    if (stsi_get_fc() < 3) {
>> +        initialized = true;
>> +        return is_kvm;
>> +    }
>> +
>> +    stsi_322 = alloc_page();
>> +    if (!stsi_322)
>> +        return false;
>> +
>> +    if (stsi(stsi_322, 3, 2, 2))
>> +        goto out;
>> +
>> +    /*
>> +     * If the manufacturer string is "KVM/" in EBCDIC, then we
>> +     * are on KVM (otherwise the string is "IBM" in EBCDIC)
>> +     */
>> +    is_kvm = !memcmp(&stsi_322->vm[0].cpi, kvm_ebcdic, 
>> sizeof(kvm_ebcdic));
> 
> So I had a look at this before Christmas and I think it's wrong.
> 
> QEMU will still set the cpi to KVM/LINUX if we are under tcg.
> So we need to do add a !tcg check here and fix this comment.
> 
> I.e. we always have the KVM/LINUX cpi but if we're under TCG the 
> manufacturer in fc == 1 is QEMU. I'm not sure if this is intentional and 
> if we want to fix this at some point or not.

indeed I did not check this!!

> 
>> +    initialized = true;
>> +out:
>> +    free_page(stsi_322);
>> +    return is_kvm;
>> +}

...snip...

Thanks for the review, I make the changes.
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
