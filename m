Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8F43D12B8
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 17:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbhGUPDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:03:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37654 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238276AbhGUPDm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 11:03:42 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16LFhvB0071598;
        Wed, 21 Jul 2021 11:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=r3gzbbIhvW8DSTquo2fcEuKogGbN+OM2iE9mhjS35yo=;
 b=O+WuoNGtuRamukOxtJWtFRBdo9/OWkWwssojQFLEYcFsYtoCjIOxBuKhLK4Fw5puxxcO
 B5TQ1/Y24/rD52lfPLbcmcEQokB1IAWqPV81m+wwjP9vFO3zZcOYia/CKU7rGPDTXpPj
 tI7gFrbEsa+/yZ+Ts+m0dkE+8KBiQjlO+1I1UQBrOzBhI7xSINmDD0OBnq1g7mDnOPb6
 1QpMENpbG0vqn2kaU1Q0ShK0U/r/NXeC1ww4OM5/AWTMCCmblNvh+kIDe2qvFUwB9YyB
 gQcBCqA517/jEbvvTwDWhZiL1JoLVhbVZuB7DrrMa6sQp8WLAYZX5iGj+mLl1rYMSf+g iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39xpfv808t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jul 2021 11:44:19 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16LFi7iL072801;
        Wed, 21 Jul 2021 11:44:18 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39xpfv8089-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jul 2021 11:44:18 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16LFhIaH003365;
        Wed, 21 Jul 2021 15:44:16 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 39upfh96ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jul 2021 15:44:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16LFfnTh27132230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 15:41:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C4164C040;
        Wed, 21 Jul 2021 15:44:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BAED4C044;
        Wed, 21 Jul 2021 15:44:12 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.84.14])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jul 2021 15:44:12 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Add specification exception test
To:     Thomas Huth <thuth@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210706115459.372749-1-scgl@linux.ibm.com>
 <18803632-6a9c-5999-2a8a-d4501a0a77d8@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <9bf3313e-0d96-1312-550a-0d1662d50130@linux.vnet.ibm.com>
Date:   Wed, 21 Jul 2021 17:44:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <18803632-6a9c-5999-2a8a-d4501a0a77d8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: a4lmdGHJbx8MpIEHKqG1HPK2tGjB4cMP
X-Proofpoint-GUID: cXbj-ULiK-6lWeZpIkkDrohs82ChtFaI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-21_09:2021-07-21,2021-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107210090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/21 3:26 PM, Thomas Huth wrote:
> On 06/07/2021 13.54, Janis Schoetterl-Glausch wrote:
>> Generate specification exceptions and check that they occur.
>> Also generate specification exceptions during a transaction,
>> which results in another interruption code.
>> With the iterations argument one can check if specification
>> exception interpretation occurs, e.g. by using a high value and
>> checking that the debugfs counters are substantially lower.
>> The argument is also useful for estimating the performance benefit
>> of interpretation.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>   s390x/Makefile           |   1 +
>>   lib/s390x/asm/arch_def.h |   1 +
>>   s390x/spec_ex.c          | 344 +++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg      |   3 +
>>   4 files changed, 349 insertions(+)
>>   create mode 100644 s390x/spec_ex.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 8820e99..be100d3 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -23,6 +23,7 @@ tests += $(TEST_DIR)/sie.elf
>>   tests += $(TEST_DIR)/mvpg.elf
>>   tests += $(TEST_DIR)/uv-host.elf
>>   tests += $(TEST_DIR)/edat.elf
>> +tests += $(TEST_DIR)/spec_ex.elf
>>     tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>   ifneq ($(HOST_KEY_DOCUMENT),)
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 15cf7d4..7cb0b92 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -229,6 +229,7 @@ static inline uint64_t stctg(int cr)
>>       return value;
>>   }
>>   +#define CTL0_TRANSACT_EX_CTL    (63 -  8)
>>   #define CTL0_LOW_ADDR_PROT    (63 - 35)
>>   #define CTL0_EDAT        (63 - 40)
>>   #define CTL0_IEP        (63 - 43)
>> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
>> new file mode 100644
>> index 0000000..2e05bfb
>> --- /dev/null
>> +++ b/s390x/spec_ex.c
>> @@ -0,0 +1,344 @@
> 
> Please add a short comment header at the top of the file with some information on what it is all about, and license information (e.g. a SPDX-License-Identifier)
> 
>> +#include <stdlib.h>
>> +#include <htmintrin.h>
>> +#include <libcflat.h>
>> +#include <asm/barrier.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/facility.h>
>> +
>> +struct lowcore *lc = (struct lowcore *) 0;
>> +
>> +static bool expect_early;
>> +static struct psw expected_early_pgm_psw;
>> +static struct psw fixup_early_pgm_psw;
>> +
>> +static void fixup_early_pgm_ex(void)
> 
> Could you please add a comment in front of this function with a description why this is required / good for?

Sure, how about:

/* The standard program exception handler cannot deal with invalid old PSWs,
 * especially not invalid instruction addresses, as in that case one cannot
 * find the instruction following the faulting one from the old PSW.
 */

I'll also change some names since something like this is necessary for all
exceptions caused by invalid PSWs, not just the early ones:

static void fixup_invalid_psw(void)
> 
>> +{
>> +    if (expect_early) {
>> +        report(expected_early_pgm_psw.mask == lc->pgm_old_psw.mask
>> +               && expected_early_pgm_psw.addr == lc->pgm_old_psw.addr,
>> +               "Early program new PSW as expected");
>> +        expect_early = false;
>> +    }
>> +    lc->pgm_old_psw = fixup_early_pgm_psw;
>> +}
>> +
>> +static void lpsw(uint64_t psw)
>> +{
>> +    uint32_t *high, *low;
>> +    uint64_t r0 = 0, r1 = 0;
>> +
>> +    high = (uint32_t *) &fixup_early_pgm_psw.mask;
>> +    low = high + 1;
>> +
>> +    asm volatile (
>> +        "    epsw    %0,%1\n"
>> +        "    st    %0,%[high]\n"
>> +        "    st    %1,%[low]\n"
> 
> What's all this magic with high and low good for? Looks like high and low are not used afterwards anymore?

Seems like the easiest way to store both halves of the current mask into the global fixup PSW.
> 
>> +        "    larl    %0,nop%=\n"
>> +        "    stg    %0,%[addr]\n"
>> +        "    lpsw    %[psw]\n"
>> +        "nop%=:    nop\n"
>> +        : "+&r"(r0), "+&a"(r1), [high] "=&R"(*high), [low] "=&R"(*low)
> 
> ... also not sure why you need the "&" modifiers here?

r0, r1 are stored into before reading psw, also there are implied input registers for the
memory output operands. To be honest, I didn't care to figure out the minimal '&' usage,
it's just test code after all.
> 
>> +        , [addr] "=&R"(fixup_early_pgm_psw.addr)
>> +        : [psw] "Q"(psw)
>> +        : "cc", "memory"
>> +    );
>> +}
>> +
>> +static void psw_bit_31_32_are_1_0(void)
>> +{
>> +    uint64_t bad_psw = 0x000800015eadbeef;
>> +
>> +    //bit 12 gets inverted when extending to 128-bit PSW
> 
> I'd prefer a space after the "//"
> 
>> +    expected_early_pgm_psw.mask = 0x0000000100000000;
>> +    expected_early_pgm_psw.addr = 0x000000005eadbeef;
>> +    expect_early = true;
>> +    lpsw(bad_psw);
>> +}
>> +
>> +static void bad_alignment(void)
>> +{
>> +    uint32_t words[5] = {0, 0, 0};
>> +    uint32_t (*bad_aligned)[4];
>> +
>> +    register uint64_t r1 asm("6");
>> +    register uint64_t r2 asm("7");
>> +    if (((uintptr_t)&words[0]) & 0xf) {
>> +        bad_aligned = (uint32_t (*)[4])&words[0];
>> +    } else {
>> +        bad_aligned = (uint32_t (*)[4])&words[1];
>> +    }
>> +    asm volatile ("lpq %0,%2"
>> +              : "=r"(r1), "=r"(r2)
>> +              : "T"(*bad_aligned)
>> +    );
>> +}
>> +
>> +static void not_even(void)
>> +{
>> +    uint64_t quad[2];
>> +
>> +    register uint64_t r1 asm("7");
>> +    register uint64_t r2 asm("8");
>> +    asm volatile (".insn    rxy,0xe3000000008f,%0,%2" //lpq %0,%2
>> +              : "=r"(r1), "=r"(r2)
>> +              : "T"(quad)
>> +    );
>> +}
>> +
>> +struct spec_ex_trigger {
>> +    const char *name;
>> +    void (*func)(void);
>> +    bool transactable;
>> +    void (*fixup)(void);
>> +};
>> +
>> +static const struct spec_ex_trigger spec_ex_triggers[] = {
>> +    { "psw_bit_31_32_are_1_0", &psw_bit_31_32_are_1_0, false, &fixup_early_pgm_ex},
>> +    { "bad_alignment", &bad_alignment, true, NULL},
>> +    { "not_even", &not_even, true, NULL},
>> +    { NULL, NULL, true, NULL},
>> +};
>> +
>> +struct args {
>> +    uint64_t iterations;
>> +    uint64_t max_retries;
>> +    uint64_t suppress_info;
>> +    uint64_t max_failures;
>> +    bool diagnose;
>> +};
>> +
>> +static void test_spec_ex(struct args *args,
>> +             const struct spec_ex_trigger *trigger)
>> +{
>> +    uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
>> +    uint16_t pgm;
>> +    unsigned int i;
>> +
>> +    register_pgm_cleanup_func(trigger->fixup);
>> +    for (i = 0; i < args->iterations; i++) {
>> +        expect_pgm_int();
>> +        trigger->func();
>> +        pgm = clear_pgm_int();
>> +        if (pgm != expected_pgm) {
>> +            report(0,
>> +            "Program interrupt: expected(%d) == received(%d)",
>> +            expected_pgm,
>> +            pgm);
>> +            return;
>> +        }
>> +    }
> 
> Maybe it would be nice to "unregister" the cleanup function at the end with register_pgm_cleanup_func(NULL) ?

Yeah, I think I'll also move them just before and after the trigger->func().
> 
>> +    report(1,
>> +    "Program interrupt: always expected(%d) == received(%d)",
>> +    expected_pgm,
>> +    expected_pgm);
>> +}
>> +
>> +#define TRANSACTION_COMPLETED 4
>> +#define TRANSACTION_MAX_RETRIES 5
>> +
>> +static int __attribute__((nonnull))
> 
> Not sure whether that attribute makes much sense with a static function? ... the compiler has information about the implementation details here, so it should be able to see that e.g. trigger must be non-NULL anyway?

One isn't supposed to pass NULL to __builtin_tbegin via a variable, only via a constant.
I didn't want to deal with that constraint, so that's what the nonnull is there for.
Maybe I should add a comment?
> 
>> +with_transaction(void (*trigger)(void), struct __htm_tdb *diagnose)
>> +{
>> +    int cc;
>> +
>> +    cc = __builtin_tbegin(diagnose);
>> +    if (cc == _HTM_TBEGIN_STARTED) {
>> +        trigger();
>> +        __builtin_tend();
>> +        return -TRANSACTION_COMPLETED;
>> +    } else {
>> +        return -cc;
>> +    }
>> +}
> [...]
> 
>  Thomas
> 
Thank you for your comments.

