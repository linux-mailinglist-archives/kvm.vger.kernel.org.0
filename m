Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A81D395E5F
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 14:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbfHTMZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 08:25:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728366AbfHTMZn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Aug 2019 08:25:43 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KCNWfn103839
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 08:25:42 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uge7a7ujk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 08:25:42 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 20 Aug 2019 13:25:40 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 13:25:38 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KCPbMY50856126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 12:25:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DED0011C05B;
        Tue, 20 Aug 2019 12:25:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B103C11C050;
        Tue, 20 Aug 2019 12:25:36 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 12:25:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: Diag288 test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <20190820105550.4991-3-frankja@linux.ibm.com>
 <6f25a51e-136e-1afb-215d-a2639fbd5510@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 20 Aug 2019 14:25:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6f25a51e-136e-1afb-215d-a2639fbd5510@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19082012-0012-0000-0000-00000340B04E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082012-0013-0000-0000-0000217AD448
Message-Id: <caf41bc6-6dcf-fa68-6b44-d8bcc1479acb@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/20/19 1:59 PM, Thomas Huth wrote:
> On 8/20/19 12:55 PM, Janosch Frank wrote:
>> A small test for the watchdog via diag288.
>>
>> Minimum timer value is 15 (seconds) and the only supported action with
>> QEMU is restart.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/Makefile      |   1 +
>>  s390x/diag288.c     | 111 ++++++++++++++++++++++++++++++++++++++++++++
>>  s390x/unittests.cfg |   4 ++
>>  3 files changed, 116 insertions(+)
>>  create mode 100644 s390x/diag288.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 1f21ddb..b654c56 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -11,6 +11,7 @@ tests += $(TEST_DIR)/cmm.elf
>>  tests += $(TEST_DIR)/vector.elf
>>  tests += $(TEST_DIR)/gs.elf
>>  tests += $(TEST_DIR)/iep.elf
>> +tests += $(TEST_DIR)/diag288.elf
>>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>  
>>  all: directories test_cases test_cases_binary
>> diff --git a/s390x/diag288.c b/s390x/diag288.c
>> new file mode 100644
>> index 0000000..5abcec4
>> --- /dev/null
>> +++ b/s390x/diag288.c
>> @@ -0,0 +1,111 @@
>> +/*
>> + * Timer Event DIAG288 test
>> + *
>> + * Copyright (c) 2019 IBM Corp
>> + *
>> + * Authors:
>> + *  Janosch Frank <frankja@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU Library General Public License version 2.
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/interrupt.h>
>> +
>> +struct lowcore *lc = (void *)0x0;
> 
> Maybe use "NULL" instead of "(void *)0x0" ?

Well I'd rather have:
struct lowcore *lc = (struct lowcore *)0x0;

Than using NULL.

> 
> ... maybe we could also introduce such a variable as a global variable
> in lib/s390x/ since this is already the third or fourth time that we use
> it in the kvm-unit-tests...

Sure I also thought about that, any particular place?

> 
>> +#define CODE_INIT	0
>> +#define CODE_CHANGE	1
>> +#define CODE_CANCEL	2
>> +
>> +#define ACTION_RESTART	0
>> +
>> +static inline void diag288(unsigned long code, unsigned long time,
>> +			   unsigned long action)
>> +{
>> +	register unsigned long fc asm("0") = code;
>> +	register unsigned long tm asm("1") = time;
>> +	register unsigned long ac asm("2") = action;
>> +
>> +	asm volatile("diag %0,%2,0x288"
>> +		     : : "d" (fc), "d" (tm), "d" (ac));
>> +}
>> +
>> +static inline void diag288_uneven(void)
>> +{
>> +	register unsigned long fc asm("1") = 0;
>> +	register unsigned long time asm("1") = 15;
> 
> So you're setting register 1 twice? And "time" is not really used in the
> inline assembly below? How's that supposed to work? Looks like a bug to
> me... if not, please explain with a comment in the code here.

Well I'm waiting for a spec exception here, so it doesn't have to work.
I'll probably just remove the register variables and do a:

"diag %r1,%r2,0x288"

> 
>> +	register unsigned long action asm("2") = 0;
>> +
>> +	asm volatile("diag %0,%2,0x288"
>> +		     : : "d" (fc), "d" (time), "d" (action));
>> +}
>> +
>> +static void test_specs(void)
>> +{
>> +	report_prefix_push("spec ex");
> 
> After all those Spectre bugs in the last year, "spec ex" makes me think
> of speculative execution first... maybe better use "specification" as
> prefix?

Sure, I'll take the review for the prefixes.
I thought a short prefix makes that more readable, but if it only
confuses, let's use a longer one.

> 
>> +	report_prefix_push("uneven");
>> +	expect_pgm_int();
>> +	diag288_uneven();
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("unsup act");
> 
> "unsupported action" ? ... it's not that long, is it?
> 
>> +	expect_pgm_int();
>> +	diag288(CODE_INIT, 15, 42);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("unsup fctn");
> 
> "unsupported function" ?
> 
>> +	expect_pgm_int();
>> +	diag288(42, 15, ACTION_RESTART);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("no init");
>> +	expect_pgm_int();
>> +	diag288(CODE_CANCEL, 15, ACTION_RESTART);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("min timer");
>> +	expect_pgm_int();
>> +	diag288(CODE_INIT, 14, ACTION_RESTART);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_priv(void)
>> +{
>> +	report_prefix_push("privileged");
>> +	expect_pgm_int();
>> +	enter_pstate();
>> +	diag288(0, 15, 0);
>     diag288(CODE_INIT, 0, ACTION_RESTART) ?
> 
>> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_bite(void)
>> +{
>> +	if (lc->restart_old_psw.addr) {
>> +		report("restart", true);
>> +		return;
>> +	}
>> +	lc->restart_new_psw.addr = (uint64_t)test_bite;
>> +	diag288(CODE_INIT, 15, ACTION_RESTART);
>> +	while(1) {};
> 
> Should this maybe timeout after a minute or so?

Well run_tests.sh does timeout externally.
Do you need it backed into the test?

> 
>> +}
>> +
>> +int main(void)
>> +{
>> +	report_prefix_push("diag288");
>> +	test_priv();
>> +	test_specs();
>> +	test_bite();
>> +	return report_summary();
>> +}
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 546b1f2..ca10f38 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -61,3 +61,7 @@ file = gs.elf
>>  
>>  [iep]
>>  file = iep.elf
>> +
>> +[diag288]
>> +file = diag288.elf
>> +extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
>> \ No newline at end of file
> 
> Nit: Add newline (well, it gets added by the next patch, but if you
> touch this patch again anyway...)

Ok

> 
>  Thomas
> 

