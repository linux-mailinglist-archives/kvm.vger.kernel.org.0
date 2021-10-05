Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1153C422D9E
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 18:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhJEQQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 12:16:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40388 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235875AbhJEQQr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 12:16:47 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195F9gf7006541;
        Tue, 5 Oct 2021 12:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NsuXP86vR7i1s9B4/CVp2zrhVNJidGURdPEtczlKUHY=;
 b=YqPJoEt1XjebsOrRV9xcAQA2XF9rZezhVMB7JGLEODsd/cr42Rhkf8xQsFXxQ/ENIsEl
 yCp/BFkY6NbUKRIK4aOoF+qMt0Upf0omXvYGl9ybzTIFhLPtK3OLaZ6/jVrMxMMdf3Vw
 8MGcgO27BP8Xvp1sSqSuAzY0xIb/HQL59mvnyotBzbluuCEsJt/jhW7l/FYTA80ASA9Q
 XhPmUAWOgfG47VCQ8t17mTP4ZetZB8G/ZNpdVCi+drX6uoOnGS5BFSyq8BEr9fsR7IBO
 w1UUnpF/mGu5/uLNFdrjbumxuwqHdtbwvKs14UG8NqI0eWX1hKD7HP7RIF/aUtXLlQ9z BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgq15ds5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 12:14:56 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195FOtvk024858;
        Tue, 5 Oct 2021 12:14:55 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgq15ds56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 12:14:55 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195GCsfg026264;
        Tue, 5 Oct 2021 16:14:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3bef2a299v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 16:14:53 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195GEo4036634948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 16:14:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ECD05204F;
        Tue,  5 Oct 2021 16:14:50 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.6.58])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C08EA5204E;
        Tue,  5 Oct 2021 16:14:49 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/5] s390x: Add specification exception
 test
To:     Thomas Huth <thuth@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
 <20211005090921.1816373-2-scgl@linux.ibm.com>
 <f21d1d6e-41bd-cab2-d427-f79b734c433c@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <ae035e27-17e5-a0ca-383a-4936e807918f@linux.vnet.ibm.com>
Date:   Tue, 5 Oct 2021 18:14:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f21d1d6e-41bd-cab2-d427-f79b734c433c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v-elHm1TMEhPpV5QZ2tZ3XZpmdKl8n0-
X-Proofpoint-GUID: sjIkUYTBbHKDxuM1JPyA7Gc72X1Yck11
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501
 spamscore=0 clxscore=1015 bulkscore=0 impostorscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/21 4:51 PM, Thomas Huth wrote:
> On 05/10/2021 11.09, Janis Schoetterl-Glausch wrote:
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
> 
> Could we please avoid non-ASCII characters in source code if possible? ... it's maybe best if you do the Copyright line similar to the other *.c files from IBM that are already in the repository.

Yes, I'll remove it. I thought it would be fine since it's in a comment,
didn't consider that it might cause trouble with some mail clients.
So that's grounds for removal by itself.
> 
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
>> +        "    larl    %0,nop%=\n"
>> +        "    stg    %0,%[addr]\n"
>> +        "    lpswe    %[psw]\n"
>> +        "nop%=:    nop\n"
>> +        : "+&r"(r0), "+&a"(r1), [mask] "=&R"(fixup_psw.mask),
>> +          [addr] "=&R"(fixup_psw.addr)
> 
> stg uses long displacement, so maybe the constraint should rather be "T" instead?

Good catch.
> 
>> +        : [psw] "Q"(psw)
>> +        : "cc", "memory"
>> +    );
>> +}
>> +

[...]

>> +static struct args parse_args(int argc, char **argv)
>> +{
>> +    struct args args = {
>> +        .iterations = 1,
>> +    };
>> +    unsigned int i;
>> +    long arg;
>> +    bool no_arg;
>> +    char *end;
>> +
>> +    for (i = 1; i < argc; i++) {
>> +        no_arg = true;
>> +        if (i < argc - 1) {
>> +            no_arg = *argv[i+1] == '\0';
>> +            arg = strtol(argv[i+1], &end, 10);
> 
> Nit: It's more common to use spaces around the "+" (i.e. "i + 1")

Ok
> 
>> +            no_arg |= *end != '\0';
>> +            no_arg |= arg < 0;
>> +        }
>> +
>> +        if (!strcmp("--iterations", argv[i])) {
>> +            if (no_arg)
>> +                report_abort("--iterations needs a positive parameter");
>> +            args.iterations = arg;
>> +            ++i;
>> +        } else {
>> +            report_abort("Unsupported parameter '%s'",
>> +                     argv[i]);
>> +        }
>> +    }
>> +    return args;
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +    unsigned int i;
>> +
>> +    struct args args = parse_args(argc, argv);
>> +
>> +    report_prefix_push("specification exception");
>> +    for (i = 0; spec_ex_triggers[i].name; i++) {
>> +        report_prefix_push(spec_ex_triggers[i].name);
>> +        test_spec_ex(&args, &spec_ex_triggers[i]);
>> +        report_prefix_pop();
>> +    }
>> +    report_prefix_pop();
>> +
>> +    return report_summary();
>> +}
> 
> Apart from the nits, this looks fine to me.

Thanks for the review.
> 
>  Thomas
> 

