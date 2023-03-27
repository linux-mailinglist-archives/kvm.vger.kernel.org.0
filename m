Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AE66CA2B7
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 13:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbjC0Lpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 07:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjC0Lpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 07:45:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F941FF3;
        Mon, 27 Mar 2023 04:45:33 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RB1gWs003002;
        Mon, 27 Mar 2023 11:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=haU/+pBGHGrXy1nlPx7R0zdhMnpuNobijhi5H7iCoCY=;
 b=tJTDhvtA7bqnO6HSmYtLPjFs5TGfIspqJ4H5ExAOB3USac/jcBz8/s/R94+lomAg2Zzz
 ORApALDSjTreeKkiK8uv1Ibxyg0JiaOIqCCFY9dn+LczRx3So11hAU+4JYujAZJtwrHn
 0C/azlk4IHpE3i4HsD0JdshgGPd/JNOg4xi2QvpyqfdNa6RHSTRuIbbh7U85RJA5WbPL
 zh8qUmZ4Zni6OAU1oMAwEyjLSs9H94v7O4VMGLGeQtd02ZwudlKrsnjozgnyTw6Q/e8I
 L0w40xjybgLQ1TkWWAW/vu3asSfsylDRiFJkJ05qakJHi2Q1FtU+r0HJ38CbexJulnea sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pjasre0n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 11:45:33 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32RB2f3S009969;
        Mon, 27 Mar 2023 11:45:32 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pjasre0m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 11:45:32 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32RAGkxm030303;
        Mon, 27 Mar 2023 11:45:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3phr7fjqxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 11:45:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32RBjQw029884954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 11:45:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9844D2005A;
        Mon, 27 Mar 2023 11:45:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E2BD2004F;
        Mon, 27 Mar 2023 11:45:26 +0000 (GMT)
Received: from [9.171.92.86] (unknown [9.171.92.86])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Mar 2023 11:45:26 +0000 (GMT)
Message-ID: <fd8984f3-58d1-e591-f168-760a90bfaf38@linux.ibm.com>
Date:   Mon, 27 Mar 2023 13:45:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v7 1/2] s390x: topology: Check the Perform
 Topology Function
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20230320085642.12251-1-pmorel@linux.ibm.com>
 <20230320085642.12251-2-pmorel@linux.ibm.com>
 <20230323164512.4cdf985e@p-imbrenda>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20230323164512.4cdf985e@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wJUZiCPnmdnhgCBkLSZJ9CeQJ4aGg13C
X-Proofpoint-GUID: oFC_1sywnm_Aw9CGitDDBoi46vlWcXI5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270090
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/23/23 16:45, Claudio Imbrenda wrote:
> On Mon, 20 Mar 2023 09:56:41 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
>
>> We check that the PTF instruction is working correctly when
>> the cpu topology facility is available.
>>
>> For KVM only, we test changing of the polarity between horizontal
>> and vertical and that a reset set the horizontal polarity.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/Makefile      |   1 +
>>   s390x/topology.c    | 180 ++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |   3 +
>>   3 files changed, 184 insertions(+)
>>   create mode 100644 s390x/topology.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index e94b720..05dac04 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -40,6 +40,7 @@ tests += $(TEST_DIR)/panic-loop-pgm.elf
>>   tests += $(TEST_DIR)/migration-sck.elf
>>   tests += $(TEST_DIR)/exittime.elf
>>   tests += $(TEST_DIR)/ex.elf
>> +tests += $(TEST_DIR)/topology.elf
>>   
>>   pv-tests += $(TEST_DIR)/pv-diags.elf
>>   
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 0000000..ce248f1
>> --- /dev/null
>> +++ b/s390x/topology.c
>> @@ -0,0 +1,180 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <asm/page.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/facility.h>
>> +#include <smp.h>
>> +#include <sclp.h>
>> +#include <s390x/hardware.h>
>> +
>> +#define PTF_REQ_HORIZONTAL	0
>> +#define PTF_REQ_VERTICAL	1
>> +#define PTF_REQ_CHECK		2
>> +
>> +#define PTF_ERR_NO_REASON	0
>> +#define PTF_ERR_ALRDY_POLARIZED	1
>> +#define PTF_ERR_IN_PROGRESS	2
>> +
>> +extern int diag308_load_reset(u64);
>> +
>> +static int ptf(unsigned long fc, unsigned long *rc)
>> +{
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"	ptf	%1	\n"
>> +		"       ipm     %0	\n"
>> +		"       srl     %0,28	\n"
>> +		: "=d" (cc), "+d" (fc)
>> +		:
>> +		: "cc");
>> +
>> +	*rc = fc >> 8;
>> +	return cc;
>> +}
>> +
>> +static void check_privilege(int fc)
>> +{
>> +	unsigned long rc;
>> +
>> +	report_prefix_push("Privilege");
>> +	report_info("function code %d", fc);
>> +	enter_pstate();
>> +	expect_pgm_int();
>> +	ptf(fc, &rc);
>> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>> +	report_prefix_pop();
>> +}
>> +
>> +static void check_function_code(void)
>> +{
>> +	unsigned long rc;
>> +
>> +	report_prefix_push("Undefined fc");
>> +	expect_pgm_int();
>> +	ptf(0xff, &rc);
> please don't use magic numbers, add a new macro PTF_INVALID_FUNCTION
> (or something like that)

OK


>
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +}
>> +
>> +static void check_reserved_bits(void)
>> +{
>> +	unsigned long rc;
>> +
>> +	report_prefix_push("Reserved bits");
>> +	expect_pgm_int();
>> +	ptf(0xffffffffffffff00UL, &rc);
> I would like every single bit to be tested, since all of them are
> required to be zero.
>
> make a loop and test each, but please report success of failure only
> once at the end.
> use a report_info in case of failure to indicate which bit failed


OK


>
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +}
>> +
>> +static void check_mtcr_pending(void)
>> +{
>> +	unsigned long rc;
>> +	int cc;
>> +
>> +	report_prefix_push("Topology Report pending");
>> +	/*
>> +	 * At this moment the topology may already have changed
>> +	 * since the VM has been started.
>> +	 * However, we can test if a second PTF instruction
>> +	 * reports that the topology did not change since the
>> +	 * preceding PFT instruction.
>> +	 */
>> +	ptf(PTF_REQ_CHECK, &rc);
>> +	cc = ptf(PTF_REQ_CHECK, &rc);
>> +	report(cc == 0, "PTF check should clear topology report");
>> +	report_prefix_pop();
>> +}
>> +
>> +static void check_polarization_change(void)
>> +{
>> +	unsigned long rc;
>> +	int cc;
>> +
>> +	report_prefix_push("Topology polarization check");
>> +
>> +	/* We expect a clean state through reset */
>> +	report(diag308_load_reset(1), "load normal reset done");
>> +
>> +	/*
>> +	 * Set vertical polarization to verify that RESET sets
>> +	 * horizontal polarization back.
>> +	 */
>> +	cc = ptf(PTF_REQ_VERTICAL, &rc);
>> +	report(cc == 0, "Set vertical polarization.");
>> +
>> +	report(diag308_load_reset(1), "load normal reset done");
>> +
>> +	cc = ptf(PTF_REQ_CHECK, &rc);
>> +	report(cc == 0, "Reset should clear topology report");
>> +
>> +	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
>> +	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
>> +	       "After RESET polarization is horizontal");
>> +
>> +	/* Flip between vertical and horizontal polarization */
>> +	cc = ptf(PTF_REQ_VERTICAL, &rc);
>> +	report(cc == 0, "Change to vertical polarization.");
> either here or in a new block, test that setting vertical twice in
> a row will also result in a cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED


OK


>
>> +
>> +	cc = ptf(PTF_REQ_CHECK, &rc);
>> +	report(cc == 1, "Polarization change should set topology report");
>> +
>> +	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
>> +	report(cc == 0, "Change to horizontal polarization.");
> it cannot hurt to add here another check for pending reports


OK


Thanks for the comments,


Regards,

Pierre

