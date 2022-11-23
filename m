Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1867F635CDC
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 13:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbiKWM20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 07:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237681AbiKWM1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 07:27:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68297657F5
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 04:26:08 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANCA3Ux029455
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 12:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=kR0SeJgoSukxHAufecxHF4MUFdUrPYtgCVtJPNG5Rts=;
 b=aZmZgozK5cfVY0WamiLT7MIJyGsdBNGTZAbNwOmnqEj6Hw1bbVBVB5Trh/KSdxFTRFsT
 T7Hqku6HP6kVuUfJhoiHQyqqUQqTlsG0J3Ogl79vygd/r//4Ma7obIAZFgsF08GRYxWj
 AFgWwUxG0fkZOONr3cQ1DtPK3ahUwtPOwx9G9YrYSIoDbcpyTqUwY3lF4N1Lyd7nJkHu
 yYf4qtbfMzWn4BRkc7Q4ZejRDq7XSP2FzqimIYb44e0wMC9TOP8KkxT40pV3B4L6sAX/
 INfA/Y33Dh3m1Vj58fsirbjXPBgq4DwjNNXBad53i86WYn1XMh03sfMAMlLkwqSDgQz/ IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100svrmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 12:26:07 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANC5ti7002946
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 12:26:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100svrkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 12:26:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ANCKlN7021112;
        Wed, 23 Nov 2022 12:26:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3kxps8wp90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 12:26:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ANCJlcj42336712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 12:19:47 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6E6B4C04E;
        Wed, 23 Nov 2022 12:26:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3B764C04A;
        Wed, 23 Nov 2022 12:26:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 12:26:01 +0000 (GMT)
Date:   Wed, 23 Nov 2022 13:13:38 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x: add a library for
 CMM-related functions
Message-ID: <20221123131338.7c091974@p-imbrenda>
In-Reply-To: <20221122161243.214814-2-nrb@linux.ibm.com>
References: <20221122161243.214814-1-nrb@linux.ibm.com>
        <20221122161243.214814-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NURPBS6gV8y3DJgU485NvZIekAZHEZqx
X-Proofpoint-ORIG-GUID: EjxOt_2b1H5GS5uG2cz8KSSFr6k7jnG_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Nov 2022 17:12:42 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upcoming changes will add a test which is very similar to the existing
> CMM migration test. To reduce code duplication, move the common function
> to a library which can be re-used by both tests.

I have several (mostly cosmetic) nits

> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/cmm.c       | 83 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/cmm.h       | 29 +++++++++++++++
>  s390x/Makefile        |  1 +
>  s390x/migration-cmm.c | 36 ++++++-------------
>  4 files changed, 123 insertions(+), 26 deletions(-)
>  create mode 100644 lib/s390x/cmm.c
>  create mode 100644 lib/s390x/cmm.h
> 
> diff --git a/lib/s390x/cmm.c b/lib/s390x/cmm.c
> new file mode 100644
> index 000000000000..9609cea68950
> --- /dev/null
> +++ b/lib/s390x/cmm.c
> @@ -0,0 +1,83 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CMM test library
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <bitops.h>
> +#include "cmm.h"
> +
> +/*
> + * Maps ESSA actions to states the page is allowed to be in after the
> + * respective action was executed.
> + */
> +const int allowed_essa_state_masks[4] = {
> +	BIT(ESSA_USAGE_STABLE),					/* ESSA_SET_STABLE */
> +	BIT(ESSA_USAGE_UNUSED),					/* ESSA_SET_UNUSED */
> +	BIT(ESSA_USAGE_VOLATILE),				/* ESSA_SET_VOLATILE */
> +	BIT(ESSA_USAGE_VOLATILE) | BIT(ESSA_USAGE_POT_VOLATILE) /* ESSA_SET_POT_VOLATILE */
> +};
> +
> +static inline unsigned long get_page_addr(uint8_t *pagebuf, int page_idx)

I don't like the name of this function, but maybe you can just get rid
of it (see below)

> +{
> +	return (unsigned long)(pagebuf + PAGE_SIZE * page_idx);
> +}
> +
> +/*
> + * Set CMM page states on pagebuf.
> + * pagebuf must point to page_count consecutive pages.
> + * page_count must be a multiple of 4.
> + */
> +void cmm_set_page_states(uint8_t *pagebuf, int page_count)
> +{

unsigned long addr = (unsigned long)pagebuf;

> +	int i;
> +
> +	assert(page_count % 4 == 0);
> +	for (i = 0; i < page_count; i += 4) {
> +		essa(ESSA_SET_STABLE, get_page_addr(pagebuf, i));

addr + i * PAGE_SIZE

> +		essa(ESSA_SET_UNUSED, get_page_addr(pagebuf, i + 1));

addr + (i + 1) * PAGE_SIZE

> +		essa(ESSA_SET_VOLATILE, get_page_addr(pagebuf, i + 2));

etc

> +		essa(ESSA_SET_POT_VOLATILE, get_page_addr(pagebuf, i + 3));
> +	}
> +}
> +
> +/*
> + * Verify CMM page states on pagebuf.
> + * Page states must have been set by cmm_set_page_states on pagebuf before.
> + * page_count must be a multiple of 4.
> + *
> + * If page states match the expected result,
> + * will return true and result will be untouched. When a mismatch occurs, will
> + * return false and result will be filled with details on the first mismatch.
> + */
> +bool cmm_verify_page_states(uint8_t *pagebuf, int page_count, struct cmm_verify_result *result)
> +{
> +	int i, state_mask, actual_state;

I think "expected_mask" would be a better name, and maybe call the
other one "actual_mask"

> +
> +	assert(page_count % 4 == 0);
> +
> +	for (i = 0; i < page_count; i++) {
> +		actual_state = essa(ESSA_GET_STATE, get_page_addr(pagebuf, i));

addr + i * PAGE_SIZE (if we get rid of get_page_addr)

> +		/* extract the usage state in bits 60 and 61 */
> +		actual_state = (actual_state >> 2) & 0x3;

actual_mask = BIT((actual_mask >> 2) & 3);

> +		state_mask = allowed_essa_state_masks[i % ARRAY_SIZE(allowed_essa_state_masks)];
> +		if (!(BIT(actual_state) & state_mask)) {
> +			result->page_mismatch = i;
> +			result->expected_mask = state_mask;
> +			result->actual_mask = BIT(actual_state);
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +void cmm_report_verify_fail(struct cmm_verify_result const *result)
> +{
> +	report_fail("page state mismatch: first page = %d, expected_mask = 0x%x, actual_mask = 0x%x", result->page_mismatch, result->expected_mask, result->actual_mask);

it would be a good idea to also print the actual address where the
mismatch was found (with %p and (pagebuf + result->page_mismatch))

> +}
> +
> diff --git a/lib/s390x/cmm.h b/lib/s390x/cmm.h
> new file mode 100644
> index 000000000000..56e188c78704
> --- /dev/null
> +++ b/lib/s390x/cmm.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CMM test library
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#ifndef S390X_CMM_H
> +#define S390X_CMM_H
> +
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/cmm.h>
> +
> +struct cmm_verify_result {
> +	int page_mismatch;
> +	int expected_mask;
> +	int actual_mask;
> +};

I'm not too fond of this, I wonder if it's possible to just return the
struct (maybe make the masks chars, since they will be small)

but I am not sure if the code will actually look better in the end

> +
> +void cmm_set_page_states(uint8_t *pagebuf, int page_count);
> +
> +bool cmm_verify_page_states(uint8_t *pagebuf, int page_count, struct cmm_verify_result *result);
> +
> +void cmm_report_verify_fail(struct cmm_verify_result const *result);
> +
> +#endif /* S390X_CMM_H */
> diff --git a/s390x/Makefile b/s390x/Makefile
> index bf1504f9d58c..401cb6371cee 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -99,6 +99,7 @@ cflatobjs += lib/s390x/malloc_io.o
>  cflatobjs += lib/s390x/uv.o
>  cflatobjs += lib/s390x/sie.o
>  cflatobjs += lib/s390x/fault.o
> +cflatobjs += lib/s390x/cmm.o
>  
>  OBJDIRS += lib/s390x
>  
> diff --git a/s390x/migration-cmm.c b/s390x/migration-cmm.c
> index aa7910ca76bf..ffd656f4db75 100644
> --- a/s390x/migration-cmm.c
> +++ b/s390x/migration-cmm.c
> @@ -14,41 +14,25 @@
>  #include <asm/cmm.h>
>  #include <bitops.h>
>  
> +#include "cmm.h"
> +
>  #define NUM_PAGES 128
> -static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +
> +static uint8_t pagebuf[NUM_PAGES * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
>  
>  static void test_migration(void)
>  {
> -	int i, state_mask, actual_state;
> -	/*
> -	 * Maps ESSA actions to states the page is allowed to be in after the
> -	 * respective action was executed.
> -	 */
> -	int allowed_essa_state_masks[4] = {
> -		BIT(ESSA_USAGE_STABLE),					/* ESSA_SET_STABLE */
> -		BIT(ESSA_USAGE_UNUSED),					/* ESSA_SET_UNUSED */
> -		BIT(ESSA_USAGE_VOLATILE),				/* ESSA_SET_VOLATILE */
> -		BIT(ESSA_USAGE_VOLATILE) | BIT(ESSA_USAGE_POT_VOLATILE) /* ESSA_SET_POT_VOLATILE */
> -	};
> +	struct cmm_verify_result result = {};
>  
> -	assert(NUM_PAGES % 4 == 0);
> -	for (i = 0; i < NUM_PAGES; i += 4) {
> -		essa(ESSA_SET_STABLE, (unsigned long)pagebuf[i]);
> -		essa(ESSA_SET_UNUSED, (unsigned long)pagebuf[i + 1]);
> -		essa(ESSA_SET_VOLATILE, (unsigned long)pagebuf[i + 2]);
> -		essa(ESSA_SET_POT_VOLATILE, (unsigned long)pagebuf[i + 3]);
> -	}
> +	cmm_set_page_states(pagebuf, NUM_PAGES);
>  
>  	puts("Please migrate me, then press return\n");
>  	(void)getchar();
>  
> -	for (i = 0; i < NUM_PAGES; i++) {
> -		actual_state = essa(ESSA_GET_STATE, (unsigned long)pagebuf[i]);
> -		/* extract the usage state in bits 60 and 61 */
> -		actual_state = (actual_state >> 2) & 0x3;
> -		state_mask = allowed_essa_state_masks[i % ARRAY_SIZE(allowed_essa_state_masks)];
> -		report(BIT(actual_state) & state_mask, "page %d state: expected_mask=0x%x actual_mask=0x%lx", i, state_mask, BIT(actual_state));
> -	}
> +	if (!cmm_verify_page_states(pagebuf, NUM_PAGES, &result))
> +		cmm_report_verify_fail(&result);
> +	else
> +		report_pass("page states match");
>  }
>  
>  int main(void)

