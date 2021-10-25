Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2E2439E87
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 20:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhJYSbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 14:31:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28240 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230111AbhJYSbT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 14:31:19 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PINXkl015214;
        Mon, 25 Oct 2021 18:28:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1mvSTNGvLCV9PUnuowvpAPqkZCNOXCY1NojWMzHPPXY=;
 b=pQlDintzTv0LWhek4yEQ/KEGBFGTirSxupafObyOW6Dl0eZEiYpSzTTzLpLxp/7itLmm
 KO4mHqhVj6KgQnX6y53DlqwPZM8aY+40O2t0usSfbg76MBI/BruBFoTbT1wvHqvCL/8Y
 Kdm+Jo7So42OKfuGYScNWbdtKZncVHZSoF0TYIhZmyInnVN0L5gRr2qrPtR4MT3znhv+
 nx24oSdjltc2lg2A7fChBephBSAKlKtmEhy8sQk6PK7FtwIc1omCOvFchdQsx62VG6+3
 NLpg/o29BgVLgRx6FtljpNzyavqn5jOlEUJCw8gNQ5WIoyHJA6dc2InFSQFNc4S0Nk5o 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx1gh0r0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 18:28:57 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19PISuBv007246;
        Mon, 25 Oct 2021 18:28:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx1gh0qya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 18:28:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19PIHXpQ006162;
        Mon, 25 Oct 2021 18:28:54 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3bwqsteusf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 18:28:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19PISoBE43385276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 18:28:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD384A4059;
        Mon, 25 Oct 2021 18:28:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C0F1A4057;
        Mon, 25 Oct 2021 18:28:50 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.19.138])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 18:28:50 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: Test specification
 exceptions during transaction
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211022120156.281567-1-scgl@linux.ibm.com>
 <20211022120156.281567-3-scgl@linux.ibm.com>
 <20211025193012.3be31938@p-imbrenda>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <71c181b9-6216-dc89-5ab8-619e08d04538@de.ibm.com>
Date:   Mon, 25 Oct 2021 20:28:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025193012.3be31938@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NlwWvrJ3-zfnDHQ6oWGqrs-70TYxIeMG
X-Proofpoint-ORIG-GUID: GykHcxTWWroGpgAwKoh_SFbZoCSA7hAl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_06,2021-10-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 25.10.21 um 19:30 schrieb Claudio Imbrenda:
> On Fri, 22 Oct 2021 14:01:56 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Program interruptions during transactional execution cause other
>> interruption codes.
>> Check that we see the expected code for (some) specification exceptions.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>   lib/s390x/asm/arch_def.h |   1 +
>>   s390x/spec_ex.c          | 172 +++++++++++++++++++++++++++++++++++++--
>>   2 files changed, 168 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 40626d7..f7fb467 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -55,6 +55,7 @@ struct psw {
>>   #define PSW_MASK_BA			0x0000000080000000UL
>>   #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
>>   
>> +#define CTL0_TRANSACT_EX_CTL		(63 -  8)
>>   #define CTL0_LOW_ADDR_PROT		(63 - 35)
>>   #define CTL0_EDAT			(63 - 40)
>>   #define CTL0_IEP			(63 - 43)
>> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
>> index ec3322a..f3628bd 100644
>> --- a/s390x/spec_ex.c
>> +++ b/s390x/spec_ex.c
>> @@ -4,9 +4,14 @@
>>    *
>>    * Specification exception test.
>>    * Tests that specification exceptions occur when expected.
>> + * This includes specification exceptions occurring during transactional execution
>> + * as these result in another interruption code (the transactional-execution-aborted
>> + * bit is set).
>>    */
>>   #include <stdlib.h>
>> +#include <htmintrin.h>
>>   #include <libcflat.h>
>> +#include <asm/barrier.h>
>>   #include <asm/interrupt.h>
>>   #include <asm/facility.h>
>>   
>> @@ -92,18 +97,23 @@ static void not_even(void)
>>   struct spec_ex_trigger {
>>   	const char *name;
>>   	void (*func)(void);
>> +	bool transactable;
>>   	void (*fixup)(void);
>>   };
>>   
>>   static const struct spec_ex_trigger spec_ex_triggers[] = {
>> -	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw},
>> -	{ "bad_alignment", &bad_alignment, NULL},
>> -	{ "not_even", &not_even, NULL},
>> -	{ NULL, NULL, NULL},
>> +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw},
>> +	{ "bad_alignment", &bad_alignment, true, NULL},
>> +	{ "not_even", &not_even, true, NULL},
>> +	{ NULL, NULL, true, NULL},
>>   };
>>   
>>   struct args {
>>   	uint64_t iterations;
>> +	uint64_t max_retries;
>> +	uint64_t suppress_info;
>> +	uint64_t max_failures;
>> +	bool diagnose;
>>   };
>>   
>>   static void test_spec_ex(struct args *args,
>> @@ -131,14 +141,132 @@ static void test_spec_ex(struct args *args,
>>   		    expected_pgm);
>>   }
>>   
>> +#define TRANSACTION_COMPLETED 4
>> +#define TRANSACTION_MAX_RETRIES 5
>> +
>> +/* NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
>> + * being NULL to keep things simple
>> + */
>> +static int __attribute__((nonnull))
>> +with_transaction(void (*trigger)(void), struct __htm_tdb *diagnose)
>> +{
>> +	int cc;
>> +
> 
> if you want to be extra sure, put an assert here (although I'm not sure
> how nonnull works, I have never seen it before)
> 
>> +	cc = __builtin_tbegin(diagnose);
>> +	if (cc == _HTM_TBEGIN_STARTED) {
>> +		trigger();
>> +		__builtin_tend();
>> +		return -TRANSACTION_COMPLETED;
>> +	} else {
>> +		return -cc;
>> +	}
>> +}
>> +
>> +static int retry_transaction(const struct spec_ex_trigger *trigger, unsigned int max_retries,
>> +			     struct __htm_tdb *tdb, uint16_t expected_pgm)
>> +{
>> +	int trans_result, i;
>> +	uint16_t pgm;
>> +
>> +	for (i = 0; i < max_retries; i++) {
>> +		expect_pgm_int();
>> +		trans_result = with_transaction(trigger->func, tdb);
>> +		if (trans_result == -_HTM_TBEGIN_TRANSIENT) {
>> +			mb();
>> +			pgm = lc->pgm_int_code;
>> +			if (pgm == 0)
>> +				continue;
>> +			else if (pgm == expected_pgm)
>> +				return 0;
>> +		}
>> +		return trans_result;
>> +	}
>> +	return -TRANSACTION_MAX_RETRIES;
> 
> so this means that a test will be considered failed if the transaction
> failed too many times?
> this means that could fail if the test is run on busy system, even if
> the host running the unit test is correct

Can we use constrained transactions for this test? those will succeed.
