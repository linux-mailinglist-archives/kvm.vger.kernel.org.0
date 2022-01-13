Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722F248D812
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbiAMMgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:36:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18340 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229991AbiAMMgi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 07:36:38 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DCT7FQ032254;
        Thu, 13 Jan 2022 12:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2M2r0rqpw04rNGq8EOFPcL+ISpOPnqlYBcVO1k23UUU=;
 b=AiGalp2QrvR2/IGAv4oP884M0Ripwr0c/gOhWFXC/vu55px0NiZNf8eiT0pU2AN7BgFZ
 fQVGv1b4otGFHm2eCYLrir9E/vHJbhpn54ZkyYKv6X1CNVMSRSxIKTpHLa7IKnu7lc/y
 qe9JP1OVp+tVdnaKaA5I5H99iuQjwHIymDi+mY5d8424wwXHxANtjynWwImT7kryCXf9
 2weS3XSdpCqeJvHFyPeE1SfnOyhUubUm9p8LFRuMV5LJX3pBNx46db4pA9e0WfNUM0Be
 a+VdT/eckf061fuUJ9q1Tdb90yK7XYDGSIw3eUPG2RJOi3ERsCfzSElHCM5V/3J5n47o nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djgkamjg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:36:37 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DCTYdZ000945;
        Thu, 13 Jan 2022 12:36:37 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djgkamjfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:36:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DCSKIG014012;
        Thu, 13 Jan 2022 12:36:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vjmgqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:36:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DCaWvo41091444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 12:36:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41D404204B;
        Thu, 13 Jan 2022 12:36:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E693F4203F;
        Thu, 13 Jan 2022 12:36:31 +0000 (GMT)
Received: from [9.171.31.87] (unknown [9.171.31.87])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 12:36:31 +0000 (GMT)
Message-ID: <56aab283-5dea-556b-dbcc-cad177ff7e33@linux.ibm.com>
Date:   Thu, 13 Jan 2022 13:36:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v4 1/2] s390x: Add specification exception
 test
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220111163901.1263736-1-scgl@linux.ibm.com>
 <20220111163901.1263736-2-scgl@linux.ibm.com>
 <20220113085648.7cf81084@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220113085648.7cf81084@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WpLYEUV_YyLyYiaf5ovj5V1QM_yTsxW7
X-Proofpoint-GUID: bW0h_YPHgEbrLC7Q-7Ic0hDeQVa-rsGv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_04,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/22 08:56, Claudio Imbrenda wrote:
> On Tue, 11 Jan 2022 17:39:00 +0100
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Generate specification exceptions and check that they occur.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  s390x/Makefile      |   1 +
>>  s390x/spec_ex.c     | 154 ++++++++++++++++++++++++++++++++++++++++++++
>>  s390x/unittests.cfg |   3 +
>>  3 files changed, 158 insertions(+)
>>  create mode 100644 s390x/spec_ex.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 1e567c1..5635c08 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -25,6 +25,7 @@ tests += $(TEST_DIR)/uv-host.elf
>>  tests += $(TEST_DIR)/edat.elf
>>  tests += $(TEST_DIR)/mvpg-sie.elf
>>  tests += $(TEST_DIR)/spec_ex-sie.elf
>> +tests += $(TEST_DIR)/spec_ex.elf
>>  tests += $(TEST_DIR)/firq.elf
>>  
>>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
>> new file mode 100644
>> index 0000000..a9f9f31
>> --- /dev/null
>> +++ b/s390x/spec_ex.c
>> @@ -0,0 +1,154 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright IBM Corp. 2021
>> + *
>> + * Specification exception test.
>> + * Tests that specification exceptions occur when expected.
>> + *
>> + * Can be extended by adding triggers to spec_ex_triggers, see comments below.
>> + */
>> +#include <stdlib.h>
>> +#include <libcflat.h>
>> +#include <asm/interrupt.h>
>> +
>> +static struct lowcore *lc = (struct lowcore *) 0;
>> +
>> +static bool invalid_psw_expected;
>> +static struct psw expected_psw;
>> +static struct psw invalid_psw;
>> +static struct psw fixup_psw;
>> +
>> +/* The standard program exception handler cannot deal with invalid old PSWs,
>> + * especially not invalid instruction addresses, as in that case one cannot
>> + * find the instruction following the faulting one from the old PSW.
>> + * The PSW to return to is set by load_psw.
>> + */
>> +static void fixup_invalid_psw(void)
>> +{
>> +	// signal occurrence of invalid psw fixup
>> +	invalid_psw_expected = false;
>> +	invalid_psw = lc->pgm_old_psw;
>> +	lc->pgm_old_psw = fixup_psw;
>> +}
>> +
>> +/* Load possibly invalid psw, but setup fixup_psw before,
>> + * so that *fixup_invalid_psw() can bring us back onto the right track.
> 
> is the * just a typo?

Must be :)

[...]

>> +static void test_spec_ex(const struct spec_ex_trigger *trigger)
>> +{
>> +	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
>> +	uint16_t pgm;
>> +	int rc;
>> +
>> +	expect_pgm_int();
>> +	register_pgm_cleanup_func(trigger->fixup);
>> +	rc = trigger->func();
>> +	register_pgm_cleanup_func(NULL);
>> +	if (rc)
>> +		return;
> 
> why do you exit early in case of failure? (moreover, your are not even
> reporting the failure)

In that case it's the triggers responsibility to report. That is, we're testing
for additional conditions specific to the trigger and one of those failed.
Might not make sense to check if the expected interrupt occurred, so we don't.
Basically it's because check_invalid_psw might fail in psw_bit_12_is_1.

> 
>> +	pgm = clear_pgm_int();
>> +	report(pgm == expected_pgm, "Program interrupt: expected(%d) == received(%d)",
>> +	       expected_pgm, pgm);
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +	unsigned int i;
>> +
>> +	report_prefix_push("specification exception");
>> +	for (i = 0; spec_ex_triggers[i].name; i++) {
>> +		report_prefix_push(spec_ex_triggers[i].name);
>> +		test_spec_ex(&spec_ex_triggers[i]);
>> +		report_prefix_pop();
>> +	}
>> +	report_prefix_pop();
>> +
>> +	return report_summary();
>> +}
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 054560c..26510cf 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -113,6 +113,9 @@ file = mvpg-sie.elf
>>  [spec_ex-sie]
>>  file = spec_ex-sie.elf
>>  
>> +[spec_ex]
>> +file = spec_ex.elf
>> +
>>  [firq-linear-cpu-ids]
>>  file = firq.elf
>>  timeout = 20
> 

