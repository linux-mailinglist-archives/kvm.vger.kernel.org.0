Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4192E69780C
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 09:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbjBOIU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 03:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbjBOIU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 03:20:57 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729E436446;
        Wed, 15 Feb 2023 00:20:56 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31F6WrNG020128;
        Wed, 15 Feb 2023 08:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UozxDnLNe0kSxd3poq/EykCkdnnEjuhk++Z9+9Vne28=;
 b=okY4Cwyqd9kGbbnYEQnuYEQ3YQ/on5ZA7TrAbtmYor8Xo59EozXujMMP6+wtxqspxc8B
 yTM2589wgvUHS5B6y0+6Bw1Eg4OIQ8z3eGHe6zml+6JQ8eXwtBJI5xViJN/+GdehSTJs
 72LxooRBUCf8KglHURJJmrJcoVBDdgPXhQy1eYjL7mGKT7eYL/VWq10yz1DUaaW9Jb9+
 o2LeE2F3zSdEkw4+807qURiy+5XB8RmqqKP2pofv7134/bWihH3SSybgagplAyMnHlDK
 yrB7QsjuoQAiDvcJEUucrm8OBFxATpMnJQEEEXbPymWcxQWVGPVYbowOTwlGgH2ryIE2 ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nrt7ma5x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 08:20:55 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31F7OOFn015395;
        Wed, 15 Feb 2023 08:20:55 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nrt7ma5w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 08:20:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31EKAhoY017639;
        Wed, 15 Feb 2023 08:20:53 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6n3ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 08:20:53 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31F8KnmK49218012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 08:20:49 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46F5F20043;
        Wed, 15 Feb 2023 08:20:49 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1426E20040;
        Wed, 15 Feb 2023 08:20:49 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 08:20:49 +0000 (GMT)
Message-ID: <67a2b0c2-f6cb-3db3-4978-d3be23d20ba0@linux.ibm.com>
Date:   Wed, 15 Feb 2023 09:20:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [kvm-unit-tests PATCH v6 1/2] s390x: topology: Check the Perform
 Topology Function
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com
References: <20230202092814.151081-1-pmorel@linux.ibm.com>
 <20230202092814.151081-2-pmorel@linux.ibm.com>
 <c4bb7c1854a1e46eb312ef629c3cb1bc9044b549.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <c4bb7c1854a1e46eb312ef629c3cb1bc9044b549.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Nh2FHnIQ8DZ-eTQva2LuIxBNp-TNhk_N
X-Proofpoint-ORIG-GUID: IAet4pRcwtywY_2JdPDR1df_4i_wBaJc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_04,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150073
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/10/23 15:51, Nina Schoetterl-Glausch wrote:
> On Thu, 2023-02-02 at 10:28 +0100, Pierre Morel wrote:
>> We check that the PTF instruction is working correctly when
>> the cpu topology facility is available.
>>
>> For KVM only, we test changing of the polarity between horizontal
>> and vertical and that a reset set the horizontal polarity.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/Makefile      |   1 +
>>   s390x/topology.c    | 155 ++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |   3 +
>>   3 files changed, 159 insertions(+)
>>   create mode 100644 s390x/topology.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 52a9d82..b5fe8a3 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
>>   tests += $(TEST_DIR)/panic-loop-pgm.elf
>>   tests += $(TEST_DIR)/migration-sck.elf
>>   tests += $(TEST_DIR)/exittime.elf
>> +tests += $(TEST_DIR)/topology.elf
>>   
>>   pv-tests += $(TEST_DIR)/pv-diags.elf
>>   
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 0000000..20f7ba2
>> --- /dev/null
>> +++ b/s390x/topology.c
>> @@ -0,0 +1,155 @@
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
> 
> Maybe also give the CC codes names for improved readability.

OK

> 
>> +
>> +extern int diag308_load_reset(u64);
>> +
>> +static int ptf(unsigned long fc, unsigned long *rc)
>> +{
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"       .insn   rre,0xb9a20000,%1,0\n"
>> +		"       ipm     %0\n"
>> +		"       srl     %0,28\n"
>> +		: "=d" (cc), "+d" (fc)
>> +		:
>> +		: "cc");
> 
> Personally I always name asm arguments, but it is a very short snippet,
> so still very readable. Could also pull the shift into C code,
> but again, small difference.
> 
>> +
>> +	*rc = fc >> 8;
>> +	return cc;
>> +}
>> +
>> +static void test_ptf(void)
>> +{
>> +	unsigned long rc;
>> +	int cc;
>> +
>> +	/* PTF is a privilege instruction */
>> +	report_prefix_push("Privilege");
>> +	enter_pstate();
>> +	expect_pgm_int();
>> +	ptf(PTF_REQ_CHECK, &rc);
>> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>> +	report_prefix_pop();
> 
> IMO, you should repeat this test for all FCs, since some are emulated,
> others interpreted by SIE.

right

> 
>> +
>> +	report_prefix_push("Wrong fc");
> 
> "Undefined fc" is more informative IMO.

OK

> 
>> +	expect_pgm_int();
>> +	ptf(0xff, &rc);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("Reserved bits");
>> +	expect_pgm_int();
>> +	ptf(0xffffffffffffff00UL, &rc);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
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
>> +
>> +	report_prefix_push("Topology polarisation check");
>> +	/*
>> +	 * We can not assume the state of the polarization for
>> +	 * any Virtual Machine but KVM.
> 
> Random Capitalization :)

OK

> Why can you not test the same thing for other hypervisors/LPAR?

At first QEMU did not support vertical polarization so my tests would 
have get a false negative on LPAR.
I could have done different tests but did not.

I think that now it is alright to do the checks on LPAR too.


> 
>> +	 * Let's skip the polarisation tests for other VMs.
>> +	 */
>> +	if (!host_is_kvm()) {
>> +		report_skip("Topology polarisation check is done for KVM only");
>> +		goto end;
>> +	}
>> +
>> +	/*
>> +	 * Set vertical polarization to verify that RESET sets
>> +	 * horizontal polarization back.
>> +	 */
> 
> You might want to do a reset here also, since there could be some other
> test case that could have run before and modified the polarization.
> There isn't right now of course, but doing a reset improves separation of tests.

Not sure about this but it does not arm so why not.

Thanks.

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
