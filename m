Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F50E4227EA
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbhJENed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:34:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234103AbhJENec (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:34:32 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195DVhto023042;
        Tue, 5 Oct 2021 09:32:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=r7g2wKjUYjHKcH9a6RkBqDYZA0zHT4wJXJMYJg/uC8Y=;
 b=cX9WUnpfBiFoAAinQQtsW2jKUx6FPpIBLxqWQCRIO2KFU/Tf/QC6eBCORivDvDiDP+cE
 oMhtaQssDXb3hGAi21fNpZqLMqBTocV/8qK410Vnc0P9MGV+YDKJD/cIzUd9+UeYoAWv
 3GPisCmCi36WMq2JwH+B4yP9AANM/fxo6xhWm7lOp88J2tlU8qzcAWdyKdFH9giI7em4
 uLT1H2pxkZumWFwkkY4m5eloGx7j67a8Ydr1861efdAr0YVvME2SVGpqevfwFUjssZZz
 SSTiTNuEyKk37tPb//mTWYku1E8R3PSUKYfRKytf6dLemED5RfIsslgasf2MEwTwwwQf Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgqnxr1p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:32:41 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195DWN2v026516;
        Tue, 5 Oct 2021 09:32:40 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgqnxr1mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:32:40 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195DDCpR015048;
        Tue, 5 Oct 2021 13:32:39 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2a2tq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:32:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195DWZgi57540890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:32:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB9F25206B;
        Tue,  5 Oct 2021 13:32:34 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.6.58])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6FE3A5204E;
        Tue,  5 Oct 2021 13:32:34 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/5] s390x: Add specification exception
 test
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
 <20211005090921.1816373-2-scgl@linux.ibm.com>
 <ef75d789-b613-e828-7d6d-2ab2b5e7618c@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <b4b8ccf1-ec99-5a02-7ee2-0e5af1cf07f6@linux.vnet.ibm.com>
Date:   Tue, 5 Oct 2021 15:32:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ef75d789-b613-e828-7d6d-2ab2b5e7618c@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FiBFxoGXoIfe0xjeiv60t4ycY5k52xDt
X-Proofpoint-ORIG-GUID: 1lROETXjlQVafs5obzSccf7na5iRLlPY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 suspectscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/21 1:56 PM, Janosch Frank wrote:
> On 10/5/21 11:09, Janis Schoetterl-Glausch wrote:
>> Generate specification exceptions and check that they occur.
>> With the iterations argument one can check if specification
>> exception interpretation occurs, e.g. by using a high value and
>> checking that the debugfs counters are substantially lower.
>> The argument is also useful for estimating the performance benefit
>> of interpretation.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>   s390x/Makefile      |   1 +
>>   s390x/spec_ex.c     | 182 ++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |   3 +
>>   3 files changed, 186 insertions(+)
>>   create mode 100644 s390x/spec_ex.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index ef8041a..57d7c9e 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>>   tests += $(TEST_DIR)/uv-host.elf
>>   tests += $(TEST_DIR)/edat.elf
>>   tests += $(TEST_DIR)/mvpg-sie.elf
>> +tests += $(TEST_DIR)/spec_ex.elf
>>     tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>   ifneq ($(HOST_KEY_DOCUMENT),)
>> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
>> new file mode 100644
>> index 0000000..dd0ee53
>> --- /dev/null
>> +++ b/s390x/spec_ex.c
>> @@ -0,0 +1,182 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * © Copyright IBM Corp. 2021
>> + *
>> + * Specification exception test.
>> + * Tests that specification exceptions occur when expected.
>> + */
>> +#include <stdlib.h>
>> +#include <libcflat.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/facility.h>
>> +
>> +static struct lowcore *lc = (struct lowcore *) 0;
>> +
>> +static bool expect_invalid_psw;
>> +static struct psw expected_psw;
>> +static struct psw fixup_psw;
>> +
>> +/* The standard program exception handler cannot deal with invalid old PSWs,
>> + * especially not invalid instruction addresses, as in that case one cannot
>> + * find the instruction following the faulting one from the old PSW.
>> + * The PSW to return to is set by load_psw.
>> + */
>> +static void fixup_invalid_psw(void)
>> +{
>> +    if (expect_invalid_psw) {
>> +        report(expected_psw.mask == lc->pgm_old_psw.mask
>> +               && expected_psw.addr == lc->pgm_old_psw.addr,
>> +               "Invalid program new PSW as expected");
>> +        expect_invalid_psw = false;
>> +    }
>> +    lc->pgm_old_psw = fixup_psw;
>> +}
>> +
>> +static void load_psw(struct psw psw)
>> +{
>> +    uint64_t r0 = 0, r1 = 0;
>> +
>> +    asm volatile (
>> +        "    epsw    %0,%1\n"
>> +        "    st    %0,%[mask]\n"
>> +        "    st    %1,4+%[mask]\n"
> 
> You're grabbing the mask for the fixup psw, right?

Yes

> Why don't you use the extract_psw_mask() function for that?

No reason, sounds like a good idea to use the function.
> 
> Also I'd recommend not mixing named operands and numeric operands, especially when the variables are then called r0 and r1.

I suppose I didn't name them because they're just scratch registers.
But using extract_psw_mask() will get rid of them anyway
> 
>> +        "    larl    %0,nop%=\n"
>> +        "    stg    %0,%[addr]\n"
> 
> This stores the address of the nop to the fixup psw addr.
> So far so good, but why is it only called "addr"?
> 
>> +        "    lpswe    %[psw]\n"
>> +        "nop%=:    nop\n"
>> +        : "+&r"(r0), "+&a"(r1), [mask] "=&R"(fixup_psw.mask),
>> +          [addr] "=&R"(fixup_psw.addr)
>> +        : [psw] "Q"(psw)
>> +        : "cc", "memory"
>> +    );
> 
> You made this a bit complicated and didn't document it.
> /*
>  * Setup fixup_psw before loading an invalid PSW so that *fixup_invalid_psw() can bring us back onto the right track.
>  */
> >> +}
>> +
>> +static void psw_bit_12_is_1(void)
>> +{
>> +    expected_psw.mask = 0x0008000000000000;
>> +    expected_psw.addr = 0x00000000deadbeee;
>> +    expect_invalid_psw = true;
>> +    load_psw(expected_psw);
>> +}
>> +

[...]
