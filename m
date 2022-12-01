Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA263F19D
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 14:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiLAN3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 08:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiLAN3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 08:29:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E58DA9CFB
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 05:29:29 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1CfaQ5001635
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 13:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tZAbEw3tSlOTvoRWBIO0mGeRdkuR4ow6TQpFLjD2iKY=;
 b=B15kT6b9Y99fXVIN9qemg3J1wA05eMxyerzKLEqfnFt6DA0JucDD6G9JKVEUVB3cnam9
 tm4MdCJdi93FSRCT1+cM77J4tQuwUSq3KIQcT69W5D1KN2rkoUS23S33rTuzEosnScpS
 N6rrWJ6xrlVMLGY/1g2qXJT2QYUrOOHotHnM2TqBDMqX/Hq6wcT96aKYey1BOVKw/NtG
 EUFO291NUvCyE8DfWHUjCR3MJCWQo0A1Kkj0LSauGo7iTGG1I5ib5qqQCYKv9u56FaCL
 +YkbA9mjzlwNzJtxBVzSRX41Axhg6nYCOzjZdI7fgfHuIQAiDqYGBNR9srxgq2oE17Tz /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6uwt1xh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 13:29:28 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B1Cg7MN003267
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 13:29:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6uwt1xge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 13:29:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B1DLlxZ029174;
        Thu, 1 Dec 2022 13:29:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3m3ae9fcrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 13:29:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B1DTMY91114642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 13:29:22 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A98FA4040;
        Thu,  1 Dec 2022 13:29:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14251A404D;
        Thu,  1 Dec 2022 13:29:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 13:29:22 +0000 (GMT)
Date:   Thu, 1 Dec 2022 14:16:50 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for
 skey-related functions
Message-ID: <20221201141650.32cfe787@p-imbrenda>
In-Reply-To: <20221201084642.3747014-2-nrb@linux.ibm.com>
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
        <20221201084642.3747014-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: skZvIS_-BAyBw66nm6LOd7wmEWR7WiwT
X-Proofpoint-ORIG-GUID: JyLexYiTYB2DkYT7U45npA-mM3yJAEwa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  1 Dec 2022 09:46:40 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upcoming changes will add a test which is very similar to the existing
> skey migration test. To reduce code duplication, move the common
> functions to a library which can be re-used by both tests.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

a few nits, otherwise looks pretty straightforward

> ---
>  lib/s390x/skey.c       | 92 ++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/skey.h       | 32 +++++++++++++++
>  s390x/Makefile         |  1 +
>  s390x/migration-skey.c | 44 +++-----------------
>  4 files changed, 131 insertions(+), 38 deletions(-)
>  create mode 100644 lib/s390x/skey.c
>  create mode 100644 lib/s390x/skey.h
> 
> diff --git a/lib/s390x/skey.c b/lib/s390x/skey.c
> new file mode 100644
> index 000000000000..100f0949a244
> --- /dev/null
> +++ b/lib/s390x/skey.c
> @@ -0,0 +1,92 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Storage key migration test library
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm/facility.h>
> +#include <asm/mem.h>
> +#include <skey.h>
> +
> +/*
> + * Set storage keys on pagebuf.

surely you should explain better what the function does (e.g. how are
you setting the keys and why)

> + * pagebuf must point to page_count consecutive pages.
> + */
> +void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)

this name does not make clear what the function is doing. at first one
would think that it sets the same key for all pages.

maybe something like set_storage_keys_test_pattern or
skey_set_test_pattern or something like that

> +{
> +	unsigned char key_to_set;
> +	unsigned long i;
> +
> +	for (i = 0; i < page_count; i++) {
> +		/*
> +		 * Storage keys are 7 bit, lowest bit is always returned as zero
> +		 * by iske.
> +		 * This loop will set all 7 bits which means we set fetch
> +		 * protection as well as reference and change indication for
> +		 * some keys.
> +		 */
> +		key_to_set = i * 2;
> +		set_storage_key(pagebuf + i * PAGE_SIZE, key_to_set, 1);

why not just i * 2 instead of using key_to_set ?

> +	}
> +}
> +
> +/*
> + * Verify storage keys on pagebuf.
> + * Storage keys must have been set by skey_set_keys on pagebuf before.
> + *
> + * If storage keys match the expected result, will return a skey_verify_result
> + * with verify_failed false. All other fields are then invalid.
> + * If there is a mismatch, returned struct will have verify_failed true and will
> + * be filled with the details on the first mismatch encountered.
> + */
> +struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_count)

and here then adjust the function name accordingly

> +{
> +	union skey expected_key, actual_key;
> +	struct skey_verify_result result = {
> +		.verify_failed = true
> +	};
> +	uint8_t *cur_page;
> +	unsigned long i;
> +
> +	for (i = 0; i < page_count; i++) {
> +		cur_page = pagebuf + i * PAGE_SIZE;
> +		actual_key.val = get_storage_key(cur_page);
> +		expected_key.val = i * 2;
> +
> +		/*
> +		 * The PoP neither gives a guarantee that the reference bit is
> +		 * accurate nor that it won't be cleared by hardware. Hence we
> +		 * don't rely on it and just clear the bits to avoid compare
> +		 * errors.
> +		 */
> +		actual_key.str.rf = 0;
> +		expected_key.str.rf = 0;
> +
> +		if (actual_key.val != expected_key.val) {
> +			result.expected_key.val = expected_key.val;
> +			result.actual_key.val = actual_key.val;
> +			result.page_mismatch_idx = i;
> +			result.page_mismatch_addr = (unsigned long)cur_page;
> +			return result;
> +		}
> +	}
> +
> +	result.verify_failed = false;
> +	return result;
> +}
> +
> +void skey_report_verify(struct skey_verify_result * const result)
> +{
> +	if (result->verify_failed)
> +		report_fail("page skey mismatch: first page idx = %lu, addr = 0x%lx, "
> +			"expected_key = 0x%x, actual_key = 0x%x",
> +			result->page_mismatch_idx, result->page_mismatch_addr,
> +			result->expected_key.val, result->actual_key.val);
> +	else
> +		report_pass("skeys match");
> +}
> diff --git a/lib/s390x/skey.h b/lib/s390x/skey.h
> new file mode 100644
> index 000000000000..a0f8caa1270b
> --- /dev/null
> +++ b/lib/s390x/skey.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Storage key migration test library
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#ifndef S390X_SKEY_H
> +#define S390X_SKEY_H
> +
> +#include <libcflat.h>
> +#include <asm/facility.h>
> +#include <asm/page.h>
> +#include <asm/mem.h>
> +
> +struct skey_verify_result {
> +	bool verify_failed;
> +	union skey expected_key;
> +	union skey actual_key;
> +	unsigned long page_mismatch_idx;
> +	unsigned long page_mismatch_addr;
> +};
> +
> +void skey_set_keys(uint8_t *pagebuf, unsigned long page_count);
> +
> +struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned long page_count);
> +
> +void skey_report_verify(struct skey_verify_result * const result);
> +
> +#endif /* S390X_SKEY_H */
> diff --git a/s390x/Makefile b/s390x/Makefile
> index bf1504f9d58c..d097b7071dfb 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -99,6 +99,7 @@ cflatobjs += lib/s390x/malloc_io.o
>  cflatobjs += lib/s390x/uv.o
>  cflatobjs += lib/s390x/sie.o
>  cflatobjs += lib/s390x/fault.o
> +cflatobjs += lib/s390x/skey.o
>  
>  OBJDIRS += lib/s390x
>  
> diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> index b7bd82581abe..fed6fc1ed0f8 100644
> --- a/s390x/migration-skey.c
> +++ b/s390x/migration-skey.c
> @@ -10,55 +10,23 @@
>  
>  #include <libcflat.h>
>  #include <asm/facility.h>
> -#include <asm/page.h>
> -#include <asm/mem.h>
> -#include <asm/interrupt.h>
>  #include <hardware.h>
> +#include <skey.h>
>  
>  #define NUM_PAGES 128
> -static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +static uint8_t pagebuf[NUM_PAGES * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
>  
>  static void test_migration(void)
>  {
> -	union skey expected_key, actual_key;
> -	int i, key_to_set, key_mismatches = 0;
> +	struct skey_verify_result result;
>  
> -	for (i = 0; i < NUM_PAGES; i++) {
> -		/*
> -		 * Storage keys are 7 bit, lowest bit is always returned as zero
> -		 * by iske.
> -		 * This loop will set all 7 bits which means we set fetch
> -		 * protection as well as reference and change indication for
> -		 * some keys.
> -		 */
> -		key_to_set = i * 2;

ah I see, you have simply moved this code :)

> -		set_storage_key(pagebuf[i], key_to_set, 1);
> -	}
> +	skey_set_keys(pagebuf, NUM_PAGES);
>  
>  	puts("Please migrate me, then press return\n");
>  	(void)getchar();
>  
> -	for (i = 0; i < NUM_PAGES; i++) {
> -		actual_key.val = get_storage_key(pagebuf[i]);
> -		expected_key.val = i * 2;
> -
> -		/*
> -		 * The PoP neither gives a guarantee that the reference bit is
> -		 * accurate nor that it won't be cleared by hardware. Hence we
> -		 * don't rely on it and just clear the bits to avoid compare
> -		 * errors.
> -		 */
> -		actual_key.str.rf = 0;
> -		expected_key.str.rf = 0;
> -
> -		/* don't log anything when key matches to avoid spamming the log */
> -		if (actual_key.val != expected_key.val) {
> -			key_mismatches++;
> -			report_fail("page %d expected_key=0x%x actual_key=0x%x", i, expected_key.val, actual_key.val);
> -		}
> -	}
> -
> -	report(!key_mismatches, "skeys after migration match");
> +	result = skey_verify_keys(pagebuf, NUM_PAGES);
> +	skey_report_verify(&result);
>  }
>  
>  int main(void)

