Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8294B4565
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 10:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242745AbiBNJRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 04:17:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242747AbiBNJQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 04:16:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003C2606DD;
        Mon, 14 Feb 2022 01:16:51 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21E7oh0i021749;
        Mon, 14 Feb 2022 09:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8S/TKRvHLHYRVao+09wzWljYArgxaVQUX2AXtagLq9Q=;
 b=ZLQ577zc6CFJ8UAqjBySbJRP09ef1/3Ii77mejGKV5YmYEEyeK14RHJQbgtLXFXRoqtX
 SpVbwcLeNYiPZJ2uGP7Yccz3Eptuz3bPso2btxqu97kx2juJ4XtwNetWYrjaenZL3Owy
 05QJScZ19Wa35miAFxXWMy6X9hEcqH37HvCztWyyCQ9yaQugcaBiDGQChl2lHTCUi8w3
 lP2dUPgzgB5ciZUbjaBLiLHPrwD0enTU7hbWwYAO0Y7aiIXPg9l+nxBfZ05O2aXIW0Z2
 mwT8oO4M0C/bwsahy2qBmNubLEIMs+C6o7RG6YvWy2H9zZgCzfoG+D2vPRm0cO56v35I 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e785svw4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 09:16:51 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21E8xOI3031851;
        Mon, 14 Feb 2022 09:16:51 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e785svw3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 09:16:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21E9DcID032756;
        Mon, 14 Feb 2022 09:16:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3e64h9jjg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 09:16:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21E9Gi5f44695844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 09:16:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8134AA4065;
        Mon, 14 Feb 2022 09:16:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AAE3A4054;
        Mon, 14 Feb 2022 09:16:44 +0000 (GMT)
Received: from [9.171.42.254] (unknown [9.171.42.254])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 09:16:44 +0000 (GMT)
Message-ID: <009ae65a-1400-f155-0d59-1c6d8c0521d3@linux.ibm.com>
Date:   Mon, 14 Feb 2022 10:18:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v4 2/4] s390x: stsi: Define vm_is_kvm to be
 used in different tests
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
 <20220208132709.48291-3-pmorel@linux.ibm.com>
 <62c23e3a-8cc9-2072-6022-cb23dfa08ce7@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <62c23e3a-8cc9-2072-6022-cb23dfa08ce7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7hmMGj8H_3xafs1IbNQ08MKktzj5JDuc
X-Proofpoint-ORIG-GUID: 2zvqRwWhLYI4I2X-O7OUFKyVoXuXcJz0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_01,2022-02-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/8/22 16:31, Janosch Frank wrote:
> On 2/8/22 14:27, Pierre Morel wrote:
>> We need in several tests to check if the VM we are running in
>> is KVM.
>> Let's add the test.
> 
> Several tests are in need of a way to check on which hypervisor and 
> virtualization level they are running on to be able to fence certain 
> tests. This patch adds functions that return true if a vm is running 
> under KVM, LPAR or generally as a level 2 guest.
> 
>>
>> To check the VM type we use the STSI 3.2.2 instruction, let's
> 
> To check if we're running under KVM we...

OK

> 
>> define it's response structure in a central header.
> 
> Since we already have a stsi test that defines the 3.2.2 structure let's 
> move the struct from the test into a new library header.

OK

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/stsi.h | 32 +++++++++++++++++++++++++++
>>   lib/s390x/vm.c   | 56 ++++++++++++++++++++++++++++++++++++++++++++++--
>>   lib/s390x/vm.h   |  3 +++
>>   s390x/stsi.c     | 23 ++------------------
>>   4 files changed, 91 insertions(+), 23 deletions(-)
>>   create mode 100644 lib/s390x/stsi.h
>>
>> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
>> new file mode 100644
>> index 00000000..9b40664f
>> --- /dev/null
>> +++ b/lib/s390x/stsi.h
>> @@ -0,0 +1,32 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + * Structures used to Store System Information
>> + *
>> + * Copyright IBM Corp. 2022
>> + */
>> +
>> +#ifndef _S390X_STSI_H_
>> +#define _S390X_STSI_H_
>> +
>> +struct sysinfo_3_2_2 {
> 
> Any particular reason why you renamed this?

In addition to what I answered to Nico:
I found stsi_3_2_2 better to describe a function calling STSI(3,2,2) 
than the result of the STSI(3,2,2) instruction, the SYStem Information 
Block.


> 
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
>> index a5b92863..38886b76 100644
>> --- a/lib/s390x/vm.c
>> +++ b/lib/s390x/vm.c
>> @@ -12,6 +12,7 @@
>>   #include <alloc_page.h>
>>   #include <asm/arch_def.h>
>>   #include "vm.h"
>> +#include "stsi.h"
>>   /**
>>    * Detect whether we are running with TCG (instead of KVM)
>> @@ -26,9 +27,13 @@ bool vm_is_tcg(void)
>>       if (initialized)
>>           return is_tcg;
>> -    buf = alloc_page();
>> -    if (!buf)
>> +    if (!vm_is_vm()) {
>> +        initialized = true;
>>           return false;
>> +    }
>> +
>> +    buf = alloc_page();
>> +    assert(buf);
>>       if (stsi(buf, 1, 1, 1))
>>           goto out;
>> @@ -43,3 +48,50 @@ out:
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
>> +    if (!vm_is_vm() || vm_is_tcg()) {
>> +        initialized = true;
>> +        return is_kvm;
>> +    }
>> +
>> +    stsi_322 = alloc_page();
>> +    assert(stsi_322);
>> +
>> +    if (stsi(stsi_322, 3, 2, 2))
>> +        goto out;
>> +
>> +    /*
>> +     * If the manufacturer string is "KVM/" in EBCDIC, then we
>> +     * are on KVM.
>> +     */
>> +    is_kvm = !memcmp(&stsi_322->vm[0].cpi, kvm_ebcdic, 
>> sizeof(kvm_ebcdic));
>> +    initialized = true;
>> +out:
>> +    free_page(stsi_322);
>> +    return is_kvm;
>> +}
>> +
>> +bool vm_is_lpar(void)
>> +{
>> +    return stsi_get_fc() == 2;
>> +}
>> +
>> +bool vm_is_vm(void)
>> +{
>> +    return stsi_get_fc() == 3;
> 
> This would be true when running under z/VM, no?

yes

> 
> I.e. what you're testing here is that we're a level 2 guest and hence 
> the naming could be improved.

STSI(0,x,x) used by stsi_get_fc() returns the current configuration 
level number which can be one of: basic machine (1), LPAR(2) or VM(3)

by the way stsi_get_fc() should probably better be named 
stsi_get_cfglevel() or something like that.

> 
> Also: what if we're under VSIE where we would be > 3?

No other configuration level is defined in the architecture than (1,2,3)

> 
>> +}
>> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
>> index 7abba0cc..3aaf76af 100644
>> --- a/lib/s390x/vm.h
>> +++ b/lib/s390x/vm.h
>> @@ -9,5 +9,8 @@
>>   #define _S390X_VM_H_
>>   bool vm_is_tcg(void);
>> +bool vm_is_kvm(void);
>> +bool vm_is_vm(void);
>> +bool vm_is_lpar(void);
>>   #endif  /* _S390X_VM_H_ */
>> diff --git a/s390x/stsi.c b/s390x/stsi.c
>> index 391f8849..1ed045e2 100644
>> --- a/s390x/stsi.c
>> +++ b/s390x/stsi.c
>> @@ -13,27 +13,8 @@
>>   #include <asm/asm-offsets.h>
>>   #include <asm/interrupt.h>
>>   #include <smp.h>
>> +#include "stsi.h"
> 
> #include <stsi.h>
> 
> We're not in the lib.

OK

> 
>> -struct stsi_322 {
>> -    uint8_t reserved[31];
>> -    uint8_t count;
>> -    struct {
>> -        uint8_t reserved2[4];
>> -        uint16_t total_cpus;
>> -        uint16_t conf_cpus;
>> -        uint16_t standby_cpus;
>> -        uint16_t reserved_cpus;
>> -        uint8_t name[8];
>> -        uint32_t caf;
>> -        uint8_t cpi[16];
>> -        uint8_t reserved5[3];
>> -        uint8_t ext_name_encoding;
>> -        uint32_t reserved3;
>> -        uint8_t uuid[16];
>> -    } vm[8];
>> -    uint8_t reserved4[1504];
>> -    uint8_t ext_names[8][256];
>> -};
>>   static uint8_t pagebuf[PAGE_SIZE * 2] 
>> __attribute__((aligned(PAGE_SIZE * 2)));
>>   static void test_specs(void)
>> @@ -91,7 +72,7 @@ static void test_3_2_2(void)
>>       /* EBCDIC for "KVM/" */
>>       const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
>>       const char vm_name_ext[] = "kvm-unit-test";
>> -    struct stsi_322 *data = (void *)pagebuf;
>> +    struct sysinfo_3_2_2 *data = (void *)pagebuf;
>>       report_prefix_push("3.2.2");
> 

Thanks for the review,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
