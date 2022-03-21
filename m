Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAB64E2B5F
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 15:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349742AbiCUPAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 11:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiCUPAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 11:00:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA6A26AFD;
        Mon, 21 Mar 2022 07:59:09 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LDTohc026936;
        Mon, 21 Mar 2022 14:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2+brqg8pFznMD7NS0LZNPbZJrg7wX1Ij6J5257FRkn0=;
 b=ov6mV8LRObCF1Qt2sgD888B6XCvuhw1/Rw/z4A4paURGhEGMTyz/es2B8HAQuc1DE34C
 HSWW42ViqeOtsTmgK8IUKpnnNjos26ijjfXgaeHK6zCOGm0izp9uf2kix4B1rQ13jbTi
 QWkt1SPdjJZqLgyzkXZUZ3CT3pwnqGfVSE0plDu/w473kxz8HGCc5cbbtZDXzYzbn/ZM
 pBhZcUamS2i96XIoPm/51m56Q3sggweITK3gMsHaljO1IS7CsjiSnkpxmeNO7/wNTyh3
 XbRLa+VLTQRY3i8dsH3gNTTVVz1nVgp0aIqXsOibPKtNvNxP/53MQ/DqFWyp7RzL9ta4 lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3exqu3wc29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 14:59:08 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22LCa3ZC007229;
        Mon, 21 Mar 2022 14:59:08 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3exqu3wc1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 14:59:08 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LErPVu003699;
        Mon, 21 Mar 2022 14:59:06 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3ew6t8v6k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 14:59:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LElOBN35062024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 14:47:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E95A4203F;
        Mon, 21 Mar 2022 14:59:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1B7E42041;
        Mon, 21 Mar 2022 14:59:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.232])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 14:59:02 +0000 (GMT)
Date:   Mon, 21 Mar 2022 15:59:00 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 4/9] s390x: smp: add test for
 SIGP_STORE_ADTL_STATUS order
Message-ID: <20220321155900.77bd89d8@p-imbrenda>
In-Reply-To: <20220321101904.387640-5-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
        <20220321101904.387640-5-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _rSc9V6N-b990z-6bxKjr5oXB8ZbXf5v
X-Proofpoint-GUID: xpgRLpr97O2fL4OujXZOzyp2Dnncpkvk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_06,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Mar 2022 11:18:59 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Add a test for SIGP_STORE_ADDITIONAL_STATUS order.
> 
> There are several cases to cover:
> - when neither vector nor guarded-storage facility is available, check
>   the order is rejected.
> - when one of the facilities is there, test the order is rejected and
>   adtl_status is not touched when the target CPU is running or when an
>   invalid CPU address is specified. Also check the order is rejected
>   in case of invalid alignment.
> - when the vector facility is there, write some data to the CPU's
>   vector registers and check we get the right contents.
> - when the guarded-storage facility is there, populate the CPU's
>   guarded-storage registers with some data and again check we get the
>   right contents.
> 
> To make sure we cover all these cases, adjust unittests.cfg to run the
> smp tests with both guarded-storage and vector facility off and on.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/smp.c         | 259 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   6 +
>  2 files changed, 265 insertions(+)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index e5a16eb5a46a..5d3265f6be64 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -16,6 +16,7 @@
>  #include <asm/sigp.h>
>  
>  #include <smp.h>
> +#include <gs.h>
>  #include <alloc_page.h>
>  
>  static int testflag = 0;
> @@ -37,6 +38,19 @@ static const struct sigp_invalid_cases cases_valid_cpu_addr[] = {
>  	{ INVALID_ORDER_CODE,         "invalid order code" },
>  };
>  
> +/*
> + * We keep two structs, one for comparing when we want to assert it's not
> + * touched.
> + */
> +static uint8_t adtl_status[2][4096] __attribute__((aligned(4096)));

it's a little bit ugly. maybe define a struct, with small buffers inside
for the vector and gs areas? that way we would not need ugly magic
numbers below (see below)

> +
> +#define NUM_VEC_REGISTERS 32
> +#define VEC_REGISTER_SIZE 16
> +static uint8_t expected_vec_contents[NUM_VEC_REGISTERS][VEC_REGISTER_SIZE];
> +
> +static struct gs_cb gs_cb;
> +static struct gs_epl gs_epl;
> +
>  static void test_invalid(void)
>  {
>  	const struct sigp_invalid_cases *c;
> @@ -200,6 +214,247 @@ static void test_store_status(void)
>  	report_prefix_pop();
>  }
>  
> +static int have_adtl_status(void)
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
> +	memset(adtl_status, 0xff, sizeof(adtl_status));
> +
> +	report_prefix_push("running");
> +	smp_cpu_restart(1);
> +
> +	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> +		  (unsigned long)adtl_status, &status);
> +
> +	report(cc == 1, "CC = 1");
> +	report(status == SIGP_STATUS_INCORRECT_STATE, "status = INCORRECT_STATE");
> +	report(!memcmp(adtl_status[0], adtl_status[1], sizeof(adtl_status[0])),
> +	       "additional status not touched");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("invalid CPU address");
> +
> +	cc = sigp(INVALID_CPU_ADDRESS, SIGP_STORE_ADDITIONAL_STATUS,
> +		  (unsigned long)adtl_status, &status);
> +	report(cc == 3, "CC = 3");
> +	report(!memcmp(adtl_status[0], adtl_status[1], sizeof(adtl_status[0])),
> +	       "additional status not touched");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("unaligned");
> +	smp_cpu_stop(1);
> +
> +	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> +		  (unsigned long)adtl_status + 256, &status);
> +	report(cc == 1, "CC = 1");
> +	report(status == SIGP_STATUS_INVALID_PARAMETER, "status = INVALID_PARAMETER");
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
> +
> +	if (have_adtl_status()) {
> +		report_skip("guarded-storage or vector facility installed");
> +		goto out;
> +	}
> +
> +	report_prefix_push("not accepted");
> +	smp_cpu_stop(1);
> +
> +	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> +		  (unsigned long)adtl_status, &status);
> +
> +	report(cc == 1, "CC = 1");
> +	report(status == SIGP_STATUS_INVALID_ORDER,
> +	       "status = INVALID_ORDER");
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
> +	uint8_t *vec_reg_16_31 = &expected_vec_contents[16][0];

add a comment to explain that vlm only handles at most 16 registers at
a time

> +	int i;
> +
> +	for (i = 0; i < NUM_VEC_REGISTERS; i++) {
> +		vec_reg = &expected_vec_contents[i][0];
> +		memset(vec_reg, i, VEC_REGISTER_SIZE);
> +	}

this way vector register 0 stays 0.
either special case it (e.g. 16, or whatever), or put a magic value
somewhere in every register

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
> +	);
> +
> +	ctl_clear_bit(0, CTL0_VECTOR);
> +
> +	set_flag(1);
> +
> +	/*
> +	 * function epilogue will restore floating point registers and hence
> +	 * destroy vector register contents
> +	 */
> +	while (1)
> +		;
> +}
> +
> +static void cpu_write_magic_to_vector_regs(uint16_t cpu_idx)
> +{
> +	struct psw new_psw;
> +
> +	smp_cpu_stop(cpu_idx);
> +
> +	new_psw.mask = extract_psw_mask();
> +	new_psw.addr = (unsigned long)restart_write_vector;
> +
> +	set_flag(0);
> +
> +	smp_cpu_start(cpu_idx, new_psw);
> +
> +	wait_for_flag();
> +}
> +
> +static void test_store_adtl_status_vector(void)
> +{
> +	uint32_t status = -1;
> +	struct psw psw;
> +	int cc;
> +
> +	report_prefix_push("store additional status vector");
> +
> +	if (!test_facility(129)) {
> +		report_skip("vector facility not installed");
> +		goto out;
> +	}
> +
> +	cpu_write_magic_to_vector_regs(1);
> +	smp_cpu_stop(1);
> +
> +	memset(adtl_status, 0xff, sizeof(adtl_status));
> +
> +	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> +		  (unsigned long)adtl_status, &status);
> +	report(!cc, "CC = 0");
> +
> +	report(!memcmp(adtl_status, expected_vec_contents, sizeof(expected_vec_contents)),
> +	       "additional status contents match");

it would be interesting to check that nothing is stored past the end of
the buffer.

moreover, I think you should also explicitly test with lc_10, to make
sure that works as well (no need to rerun the guest, just add another
sigp call)

> +
> +	/*
> +	 * To avoid the floating point/vector registers being cleaned up, we
> +	 * stopped CPU1 right in the middle of a function. Hence the cleanup of
> +	 * the function didn't run yet and the stackpointer is messed up.
> +	 * Destroy and re-initalize the CPU to fix that.
> +	 */
> +	smp_cpu_destroy(1);
> +	psw.mask = extract_psw_mask();
> +	psw.addr = (unsigned long)test_func;
> +	smp_cpu_setup(1, psw);
> +
> +out:
> +	report_prefix_pop();
> +}
> +
> +static void restart_write_gs_regs(void)
> +{
> +	const unsigned long gs_area = 0x2000000;
> +	const unsigned long gsc = 25; /* align = 32 M, section size = 512K */
> +
> +	ctl_set_bit(2, CTL2_GUARDED_STORAGE);
> +
> +	gs_cb.gsd = gs_area | gsc;
> +	gs_cb.gssm = 0xfeedc0ffe;
> +	gs_cb.gs_epl_a = (uint64_t) &gs_epl;
> +
> +	load_gs_cb(&gs_cb);
> +
> +	set_flag(1);
> +
> +	ctl_clear_bit(2, CTL2_GUARDED_STORAGE);

what happens when the function returns? is r14 set up properly? (or
maybe we just don't care, since we are going to stop the CPU anyway?)

> +}
> +
> +static void cpu_write_to_gs_regs(uint16_t cpu_idx)
> +{
> +	struct psw new_psw;
> +
> +	smp_cpu_stop(cpu_idx);
> +
> +	new_psw.mask = extract_psw_mask();
> +	new_psw.addr = (unsigned long)restart_write_gs_regs;
> +
> +	set_flag(0);
> +
> +	smp_cpu_start(cpu_idx, new_psw);
> +
> +	wait_for_flag();
> +}
> +
> +static void test_store_adtl_status_gs(void)
> +{
> +	const unsigned long adtl_status_lc_11 = 11;
> +	uint32_t status = 0;
> +	int cc;
> +
> +	report_prefix_push("store additional status guarded-storage");
> +
> +	if (!test_facility(133)) {
> +		report_skip("guarded-storage facility not installed");
> +		goto out;
> +	}
> +
> +	cpu_write_to_gs_regs(1);
> +	smp_cpu_stop(1);
> +
> +	memset(adtl_status, 0xff, sizeof(adtl_status));
> +
> +	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> +		  (unsigned long)adtl_status | adtl_status_lc_11, &status);
> +	report(!cc, "CC = 0");
> +
> +	report(!memcmp(&adtl_status[0][1024], &gs_cb, sizeof(gs_cb)),

e.g. the 1024 is one of those "magic number" I mentioned above 

> +	       "additional status contents match");

it would be interesting to test that nothing is stored after the end of
the buffer (i.e. everything is still 0xff in the second half of the
page)

> +
> +out:
> +	report_prefix_pop();
> +}
> +
>  static void ecall(void)
>  {
>  	unsigned long mask;
> @@ -388,6 +643,10 @@ int main(void)
>  	test_stop();
>  	test_stop_store_status();
>  	test_store_status();
> +	test_store_adtl_status_unavail();
> +	test_store_adtl_status_vector();
> +	test_store_adtl_status_gs();
> +	test_store_adtl_status();
>  	test_ecall();
>  	test_emcall();
>  	test_sense_running();
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 1600e714c8b9..2d0adc503917 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -77,6 +77,12 @@ extra_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac130003 -sm
>  [smp]
>  file = smp.elf
>  smp = 2
> +extra_params = -cpu host,gs=on,vx=on
> +
> +[smp-no-vec-no-gs]
> +file = smp.elf
> +smp = 2
> +extra_params = -cpu host,gs=off,vx=off

using "host" will break TCG
(and using "qemu" will break secure execution)

there are two possible solutions:

use "max" and deal with the warnings, or split each testcase in two,
one using host cpu and "accel = kvm" and the other with "accel = tcg"
and qemu cpu.

what should happen if only one of the two features is installed? should
the buffer for the unavailable feature be stored with 0 or should it be
left untouched? is it worth testing those scenarios?

>  
>  [sclp-1g]
>  file = sclp.elf

