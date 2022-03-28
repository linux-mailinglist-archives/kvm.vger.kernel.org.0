Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC244E95F6
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 13:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241999AbiC1L7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 07:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242149AbiC1L5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 07:57:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597EC3CA76;
        Mon, 28 Mar 2022 04:54:36 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22SBjZhX027084;
        Mon, 28 Mar 2022 11:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ze2J/ENhugHCcmF12duJDc7SMNLGo2VEJG0SOjFA7cM=;
 b=HOsezpx2HGdK2L4PIOy4hZ9B6vNKj9yGJ+zdh3rsQo4jgMqYt9XtU/RDIYuBKYlNFGq8
 2HgY6jxXb+CefXc+vsKr7NyBsr+r8iJyXE8aIkYYXEPoBuf7HzaJCTGq8MmrXBGT9o4q
 nBYU8iUMvf9ob/v1Zzwt7JgX4+ije4Fbka+idJMnMb1JnvWkhTDGCJ0o+alMSCrMidiN
 OrUTZ8RhTCiOw06u6gXZyVHhsHLo/+Im3aYdUnZVqEY6/34XUwqe7+2qzclpwCPOFc5R
 1jAnpPz9ziJpX+iIUVPhgxpP1MnoTrlmw1OIgi5FK9dVEWfs/+AueBnMXTEmTNR8UVLS tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3ce605aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 11:54:35 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22SBjXo2026911;
        Mon, 28 Mar 2022 11:54:35 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3ce6059w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 11:54:35 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22SBrQwi019932;
        Mon, 28 Mar 2022 11:54:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3f1t3hua7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 11:54:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22SBsTAX42205554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 11:54:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3D6EAE053;
        Mon, 28 Mar 2022 11:54:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 396F1AE04D;
        Mon, 28 Mar 2022 11:54:29 +0000 (GMT)
Received: from [9.145.52.48] (unknown [9.145.52.48])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Mar 2022 11:54:29 +0000 (GMT)
Message-ID: <2fafa98b-e342-047a-3a94-cf4111bc7198@linux.ibm.com>
Date:   Mon, 28 Mar 2022 13:54:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
References: <20220328093048.869830-1-nrb@linux.ibm.com>
 <20220328093048.869830-3-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 2/2] s390x: add test for SIGP STORE_ADTL_STATUS order
In-Reply-To: <20220328093048.869830-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9lE1M1ykl3704IxeysEg9RCa-JqUide0
X-Proofpoint-ORIG-GUID: R33KznhnNdhFEEHrwfzkbgV55p2E_4rP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_04,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280066
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/28/22 11:30, Nico Boehr wrote:
> Add a test for SIGP STORE_ADDITIONAL_STATUS order.
> 
> There are several cases to cover:
> - when neither vector nor guarded-storage facility is available, check
>    the order is rejected.
> - when one of the facilities is there, test the order is rejected and
>    adtl_status is not touched when the target CPU is running or when an
>    invalid CPU address is specified. Also check the order is rejected
>    in case of invalid alignment.
> - when the vector facility is there, write some data to the CPU's
>    vector registers and check we get the right contents.
> - when the guarded-storage facility is there, populate the CPU's
>    guarded-storage registers with some data and again check we get the
>    right contents.
> 
> To make sure we cover all these cases, adjust unittests.cfg to run the
> test with both guarded-storage and vector facility off and on. In TCG, we don't
> have guarded-storage support, so we just run with vector facility off and on.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile      |   1 +
>   s390x/adtl_status.c | 407 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |  25 +++
>   3 files changed, 433 insertions(+)
>   create mode 100644 s390x/adtl_status.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 53b0fe044fe7..47e915fbdc51 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -26,6 +26,7 @@ tests += $(TEST_DIR)/edat.elf
>   tests += $(TEST_DIR)/mvpg-sie.elf
>   tests += $(TEST_DIR)/spec_ex-sie.elf
>   tests += $(TEST_DIR)/firq.elf
> +tests += $(TEST_DIR)/adtl_status.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/adtl_status.c b/s390x/adtl_status.c
> new file mode 100644
> index 000000000000..7a2bd2b07804
> --- /dev/null
> +++ b/s390x/adtl_status.c
> @@ -0,0 +1,407 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Tests sigp store additional status order
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *    Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +#include <asm/facility.h>
> +#include <asm-generic/barrier.h>
> +#include <asm/sigp.h>
> +
> +#include <smp.h>
> +#include <gs.h>
> +#include <alloc_page.h>
> +
> +static int testflag = 0;
> +
> +#define INVALID_CPU_ADDRESS -4711
> +
> +struct mcesa_lc12 {
> +	uint8_t vector_reg[0x200];            /* 0x000 */

Hrm we could do:
__uint128_t vregs[32];

or:
uint64_t vregs[16][2];

or leave it as it is.

> +	uint8_t reserved200[0x400 - 0x200];   /* 0x200 */
> +	struct gs_cb gs_cb;                   /* 0x400 */
> +	uint8_t reserved420[0x800 - 0x420];   /* 0x420 */
> +	uint8_t reserved800[0x1000 - 0x800];  /* 0x800 */
> +};

Do we have plans to use this struct in the future for other tests?

> +
> +static struct mcesa_lc12 adtl_status __attribute__((aligned(4096)));
> +
> +#define NUM_VEC_REGISTERS 32
> +#define VEC_REGISTER_SIZE 16

I'd shove that into lib/s390x/asm/float.h or create a vector.h as
#define VEC_REGISTERS_NUM 32
#define VEC_REGISTERS_SIZE 16

Most likely vector.h since we can do both int and float with vector regs.

> +static uint8_t expected_vec_contents[NUM_VEC_REGISTERS][VEC_REGISTER_SIZE];
> +
> +static struct gs_cb gs_cb;
> +static struct gs_epl gs_epl;
> +
> +static bool memisset(void *s, int c, size_t n)
> +{
> +	uint8_t *p = s;
> +	size_t i;
> +
> +	for (i = 0; i < n; i++) {
> +		if (p[i] != c) {
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +static void wait_for_flag(void)
> +{
> +	while (!testflag)
> +		mb();
> +}
> +
> +static void set_flag(int val)
> +{
> +	mb();
> +	testflag = val;
> +	mb();
> +}
> +
> +static void test_func(void)
> +{
> +	set_flag(1);
> +}
> +
> +static int have_adtl_status(void)

bool

> +{
> +	return test_facility(133) || test_facility(129);
> +}
> +
> +static void test_store_adtl_status(void)
> +{
> +	uint32_t status = -1;
> +	int cc;
> +
> +	report_prefix_push("store additional status");
> +
> +	if (!have_adtl_status()) {
> +		report_skip("no guarded-storage or vector facility installed");
> +		goto out;
> +	}
> +
> +	memset(&adtl_status, 0xff, sizeof(adtl_status));
> +
> +	report_prefix_push("running");
> +	smp_cpu_restart(1);
> +
> +	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> +		  (unsigned long)&adtl_status, &status);
> +
> +	report(cc == 1, "CC = 1");
> +	report(status == SIGP_STATUS_INCORRECT_STATE, "status = INCORRECT_STATE");
> +	report(memisset(&adtl_status, 0xff, sizeof(adtl_status)),
> +	       "additional status not touched");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("invalid CPU address");
> +
> +	cc = sigp(INVALID_CPU_ADDRESS, SIGP_STORE_ADDITIONAL_STATUS,
> +		  (unsigned long)&adtl_status, &status);
> +	report(cc == 3, "CC = 3");
> +	report(memisset(&adtl_status, 0xff, sizeof(adtl_status)),
> +	       "additional status not touched");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("unaligned");
> +	smp_cpu_stop(1);
> +
> +	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> +		  (unsigned long)&adtl_status + 256, &status);
> +	report(cc == 1, "CC = 1");
> +	report(status == SIGP_STATUS_INVALID_PARAMETER, "status = INVALID_PARAMETER");
> +	report(memisset(&adtl_status, 0xff, sizeof(adtl_status)),
> +	       "additional status not touched");
> +
> +	report_prefix_pop();
> +
> +out:
> +	report_prefix_pop();
> +}
> +
> +static void test_store_adtl_status_unavail(void)
> +{
> +	uint32_t status = 0;
> +	int cc;
> +
> +	report_prefix_push("store additional status unvailable");

unavailable

> +
> +	if (have_adtl_status()) {
> +		report_skip("guarded-storage or vector facility installed");
> +		goto out;
> +	}
> +
> +	report_prefix_push("not accepted");
> +	smp_cpu_stop(1);
> +
> +	memset(&adtl_status, 0xff, sizeof(adtl_status));
> +
> +	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> +		  (unsigned long)&adtl_status, &status);
> +
> +	report(cc == 1, "CC = 1");
> +	report(status == SIGP_STATUS_INVALID_ORDER,
> +	       "status = INVALID_ORDER");
> +	report(memisset(&adtl_status, 0xff, sizeof(adtl_status)),
> +	       "additional status not touched");
> +
> +	report_prefix_pop();
> +
> +out:
> +	report_prefix_pop();
> +}
> +
> +static void restart_write_vector(void)
> +{
> +	uint8_t *vec_reg;
> +	/* vlm handles at most 16 registers at a time */
> +	uint8_t *vec_reg_16_31 = &expected_vec_contents[16][0];
> +	int i;
> +
> +	for (i = 0; i < NUM_VEC_REGISTERS; i++) {
> +		vec_reg = &expected_vec_contents[i][0];
> +		/* i+1 to avoid zero content */
> +		memset(vec_reg, i + 1, VEC_REGISTER_SIZE);
> +	}
> +
> +	ctl_set_bit(0, CTL0_VECTOR);
> +
> +	asm volatile (
> +		"	.machine z13\n"
> +		"	vlm 0,15, %[vec_reg_0_15]\n"
> +		"	vlm 16,31, %[vec_reg_16_31]\n"
> +		:
> +		: [vec_reg_0_15] "Q"(expected_vec_contents),
> +		  [vec_reg_16_31] "Q"(*vec_reg_16_31)
> +		: "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9",
> +		  "v10", "v11", "v12", "v13", "v14", "v15", "v16", "v17", "v18",
> +		  "v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27",
> +		  "v28", "v29", "v30", "v31", "memory"

We change memory on a load?

> +	);

We could also move vlm as a function to vector.h and do two calls.

[...]
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 1600e714c8b9..2e65106fa140 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -78,6 +78,31 @@ extra_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac130003 -sm
>   file = smp.elf
>   smp = 2
>   
> +[adtl_status-kvm]

Hmmmmm (TM) I don't really want to mix - and _.
Having spec_ex-sie.c is already bad enough.

> +file = adtl_status.elf
> +smp = 2
> +accel = kvm
> +extra_params = -cpu host,gs=on,vx=on
> +
> +[adtl_status-no-vec-no-gs-kvm]
> +file = adtl_status.elf
> +smp = 2
> +accel = kvm
> +extra_params = -cpu host,gs=off,vx=off
> +
> +[adtl_status-tcg]
> +file = adtl_status.elf
> +smp = 2
> +accel = tcg
> +# no guarded-storage support in tcg
> +extra_params = -cpu qemu,vx=on
> +
> +[adtl_status-no-vec-no-gs-tcg]
> +file = adtl_status.elf
> +smp = 2
> +accel = tcg
> +extra_params = -cpu qemu,gs=off,vx=off
> +

Are you trying to sort this in any way?
Normally we put new entries at the EOF.

>   [sclp-1g]
>   file = sclp.elf
>   extra_params = -m 1G

