Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262AD638CA9
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 15:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiKYOrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 09:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiKYOrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 09:47:02 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C78CDDA
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 06:47:01 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APEU9rS039444
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2yGRQlkYe35bJAZmzXIefkTVVZ3m6giyBfpSqBf1pNE=;
 b=YFEiB4OdfIGaB7eRIfhncdND6sZ8Pdkxm9fsJg6gXmPTy5EVc3+oOUS4230zHcCikzj9
 Y5mFOBzZ01VcrqgQ8dhqBGIA/L02vTOVNhQOotWRNR9PV863INJlfSLQHTmsbIQKBjDI
 XklawOaSMN2wQPvnWFeACjuYH019SZ0f+EEjh8t5MdTexyVUnU3XXRvN/vEMFv6TgLxj
 ufKRqHanFm3Ib36fvIb9aJeztxKbaFQ5UWQIRucwzWUbaTG9TrUyaY1pPad94XzYv78y
 vTeXd5MNYRcghrjLUPvat2tiY2993i63najPlvZhxdUqlUtKMsjBpOWtKmtpUG6ndddi 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2yhc0bjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:47:00 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APEbLfg025300
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:47:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2yhc0bj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 14:47:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APEZbJC025095;
        Fri, 25 Nov 2022 14:46:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdj1rh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 14:46:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APEksqA46596522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 14:46:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B360EA405F;
        Fri, 25 Nov 2022 14:46:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9E27A405C;
        Fri, 25 Nov 2022 14:46:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.0.125])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 25 Nov 2022 14:46:53 +0000 (GMT)
Date:   Fri, 25 Nov 2022 15:03:48 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: add a library for
 CMM-related functions
Message-ID: <20221125150348.55676f0c@p-imbrenda>
In-Reply-To: <20221124134429.612467-2-nrb@linux.ibm.com>
References: <20221124134429.612467-1-nrb@linux.ibm.com>
        <20221124134429.612467-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Du7Ta1W67SeLVgP6ZMAWkK9GgsZam6A7
X-Proofpoint-ORIG-GUID: VGK4CxiOtFtSODRPCz_dAJbFY0UwpJRV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_06,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 impostorscore=0 suspectscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211250114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Nov 2022 14:44:28 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upcoming changes will add a test which is very similar to the existing
> CMM migration test. To reduce code duplication, move the common function
> to a library which can be re-used by both tests.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/cmm.c       | 90 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/cmm.h       | 31 +++++++++++++++
>  s390x/Makefile        |  1 +
>  s390x/migration-cmm.c | 34 ++++------------
>  4 files changed, 130 insertions(+), 26 deletions(-)
>  create mode 100644 lib/s390x/cmm.c
>  create mode 100644 lib/s390x/cmm.h
> 
> diff --git a/lib/s390x/cmm.c b/lib/s390x/cmm.c
> new file mode 100644
> index 000000000000..5da02fe628f9
> --- /dev/null
> +++ b/lib/s390x/cmm.c
> @@ -0,0 +1,90 @@
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
> +/*
> + * Set CMM page states on pagebuf.
> + * pagebuf must point to page_count consecutive pages.
> + * page_count must be a multiple of 4.
> + */
> +void cmm_set_page_states(uint8_t *pagebuf, int page_count)

this could be an unsigned int (but maybe unsigned long would be better)

> +{
> +	unsigned long addr = (unsigned long)pagebuf;
> +	int i;
> +
> +	assert(page_count % 4 == 0);
> +	for (i = 0; i < page_count; i += 4) {
> +		essa(ESSA_SET_STABLE, addr + i * PAGE_SIZE);
> +		essa(ESSA_SET_UNUSED, addr + (i + 1) * PAGE_SIZE);
> +		essa(ESSA_SET_VOLATILE, addr + (i + 2) * PAGE_SIZE);
> +		essa(ESSA_SET_POT_VOLATILE, addr + (i + 3) * PAGE_SIZE);
> +	}
> +}
> +
> +/*
> + * Verify CMM page states on pagebuf.
> + * Page states must have been set by cmm_set_page_states on pagebuf before.
> + * page_count must be a multiple of 4.
> + *
> + * If page states match the expected result, will return a cmm_verify_result
> + * with verify_failed false. All other fields are then invalid.
> + * If there is a mismatch, the returned struct will have verify_failed true
> + * and will be filled with details on the first mismatch encountered.
> + */
> +struct cmm_verify_result cmm_verify_page_states(uint8_t *pagebuf, int page_count)

same here

> +{
> +	struct cmm_verify_result result = {
> +		.verify_failed = true
> +	};
> +	int i, expected_mask, actual_mask;
> +	unsigned long addr;
> +
> +	assert(page_count % 4 == 0);
> +
> +	for (i = 0; i < page_count; i++) {
> +		addr = (unsigned long)(pagebuf + i * PAGE_SIZE);
> +		actual_mask = essa(ESSA_GET_STATE, addr);
> +		/* usage state in bits 60 and 61 */
> +		actual_mask = BIT((actual_mask >> 2) & 0x3);
> +		expected_mask = allowed_essa_state_masks[i % ARRAY_SIZE(allowed_essa_state_masks)];
> +		if (!(actual_mask & expected_mask)) {
> +			result.page_mismatch_idx = i;
> +			result.page_mismatch_addr = addr;
> +			result.expected_mask = expected_mask;
> +			result.actual_mask = actual_mask;
> +			result.verify_failed = true;

it's already true, you don't need to set it again

> +			return result;
> +		}
> +	}
> +
> +	result.verify_failed = false;
> +	return result;
> +}
> +
> +void cmm_report_verify(struct cmm_verify_result const *result)
> +{
> +	if (result->verify_failed)
> +		report_fail("page state mismatch: first page idx = %d, addr = %lx, expected_mask = 0x%x, actual_mask = 0x%x", result->page_mismatch_idx, result->page_mismatch_addr, result->expected_mask, result->actual_mask);

this line looks longer than 120 columns

> +	else
> +		report_pass("page states match");
> +}
> diff --git a/lib/s390x/cmm.h b/lib/s390x/cmm.h
> new file mode 100644
> index 000000000000..41dcc2f953fd
> --- /dev/null
> +++ b/lib/s390x/cmm.h
> @@ -0,0 +1,31 @@
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
> +	bool verify_failed;
> +	char expected_mask;
> +	char actual_mask;
> +	int page_mismatch_idx;

maybe also unsigned long to be consistent with
cmm_set_page_states

> +	unsigned long page_mismatch_addr;
> +};
> +
> +void cmm_set_page_states(uint8_t *pagebuf, int page_count);
> +
> +struct cmm_verify_result cmm_verify_page_states(uint8_t *pagebuf, int page_count);
> +
> +void cmm_report_verify(struct cmm_verify_result const *result);
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
> index aa7910ca76bf..720ef9fb9799 100644
> --- a/s390x/migration-cmm.c
> +++ b/s390x/migration-cmm.c
> @@ -14,41 +14,23 @@
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
> +	struct cmm_verify_result result;
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
> +	result = cmm_verify_page_states(pagebuf, NUM_PAGES);
> +	cmm_report_verify(&result);
>  }
>  
>  int main(void)

