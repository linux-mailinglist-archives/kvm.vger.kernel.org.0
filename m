Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9B2525173
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 17:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355814AbiELPmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 11:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiELPmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 11:42:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B2553B66;
        Thu, 12 May 2022 08:42:10 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CFHiC6014848;
        Thu, 12 May 2022 15:42:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=G5u320V8ZklhKrPoljmBJRBUhnBooAKMZMGLGUns34Q=;
 b=Voz7ge8f444EY32uJOgUUjAe0oh6Ekfc7yiiOSNS5w4j/t+R+qWBy2XEHegU2J6+c5/e
 LmAyv4F4CiiRWf7xUdfT8s7aGHQKBC1JS7Pxnfk06bcY13XB3vtmPsjzKnJdg+UzJKLe
 xlP95jYE/x/yYwxHv/fmxzXH4pgH+UxnmCzTY4tBvcf+Kbiy3aoFRqLZ1YK0hzLlMyRy
 Lj+DulG0e48/4Njul+IoV92e9WkCP/25xzJNbSp7pmGRaSQiSXgia4p2jeOCChWgg7fF
 KgojPkvD3FKIwoTl/7fQGKeKsxTFQ22msTDCcWAURo+Bqopmb2N7fHVkRqVB9TU/C6tn Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g13yc2256-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 15:42:10 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CFLA7E030542;
        Thu, 12 May 2022 15:42:09 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g13yc224j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 15:42:09 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CFPIKg005778;
        Thu, 12 May 2022 15:42:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fwgd8wnq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 15:42:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CFg4fs50069886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 15:42:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11126A4059;
        Thu, 12 May 2022 15:42:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3AA6A4055;
        Thu, 12 May 2022 15:42:03 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.145])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 15:42:03 +0000 (GMT)
Date:   Thu, 12 May 2022 17:41:07 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add migration test for
 storage keys
Message-ID: <20220512174107.0500a5e6@p-imbrenda>
In-Reply-To: <20220512140107.1432019-3-nrb@linux.ibm.com>
References: <20220512140107.1432019-1-nrb@linux.ibm.com>
        <20220512140107.1432019-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tfWJYCv6_zzFDiwX4zGumKM1BzS_zCyk
X-Proofpoint-ORIG-GUID: z0PLSJO3FwJI4y-rutb_2WDEgaaNvkDI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_12,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 spamscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205120075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 May 2022 16:01:07 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upon migration, we expect storage keys being set by the guest to be preserved,
> so add a test for it.
> 
> We keep 128 pages and set predictable storage keys. Then, we migrate and check
> they can be read back and the respective access restrictions are in place when
> the access key in the PSW doesn't match.
> 
> TCG currently doesn't implement key-controlled protection, see
> target/s390x/mmu_helper.c, function mmu_handle_skey(), hence add the relevant
> tests as xfails.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile         |  1 +
>  s390x/migration-skey.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg    |  4 ++
>  3 files changed, 103 insertions(+)
>  create mode 100644 s390x/migration-skey.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index a8e04aa6fe4d..f8ea594b641d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -32,6 +32,7 @@ tests += $(TEST_DIR)/epsw.elf
>  tests += $(TEST_DIR)/adtl-status.elf
>  tests += $(TEST_DIR)/migration.elf
>  tests += $(TEST_DIR)/pv-attest.elf
> +tests += $(TEST_DIR)/migration-skey.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> new file mode 100644
> index 000000000000..6f3053d8ab40
> --- /dev/null
> +++ b/s390x/migration-skey.c
> @@ -0,0 +1,98 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Storage Key migration tests
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm/facility.h>
> +#include <asm/page.h>
> +#include <asm/mem.h>
> +#include <asm/interrupt.h>
> +#include <hardware.h>
> +
> +#define NUM_PAGES 128
> +static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +
> +static void test_migration(void)
> +{
> +	int i, key_to_set;
> +	uint8_t *page;
> +	union skey expected_key, actual_key, mismatching_key;
> +
> +	for (i = 0; i < NUM_PAGES; i++) {
> +		/*
> +		 * Storage keys are 7 bit, lowest bit is always returned as zero
> +		 * by iske
> +		 */
> +		key_to_set = i * 2;
> +		set_storage_key(pagebuf + i, key_to_set, 1);
> +	}
> +
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
> +
> +	for (i = 0; i < NUM_PAGES; i++) {
> +		report_prefix_pushf("page %d", i);
> +
> +		page = &pagebuf[i][0];
> +		actual_key.val = get_storage_key(page);
> +		expected_key.val = i * 2;
> +
> +		/* ignore reference bit */
> +		actual_key.str.rf = 0;
> +		expected_key.str.rf = 0;
> +
> +		report(actual_key.val == expected_key.val, "expected_key=0x%x actual_key=0x%x", expected_key.val, actual_key.val);
> +
> +		/* ensure access key doesn't match storage key and is never zero */
> +		mismatching_key.str.acc = expected_key.str.acc < 15 ? expected_key.str.acc + 1 : 1;

mismatching_key.str.acc = (expected_key.str.acc ^ 2) | 1;

> +		*page = 0xff;
> +
> +		expect_pgm_int();
> +		asm volatile (
> +			/* set access key */
> +			"spka 0(%[mismatching_key])\n"
> +			/* try to write page */
> +			"mvi 0(%[page]), 42\n"
> +			/* reset access key */
> +			"spka 0\n"
> +			:
> +			: [mismatching_key] "a"(mismatching_key.val),
> +			  [page] "a"(page)
> +			: "memory"
> +		);
> +		check_pgm_int_code_xfail(host_is_tcg(), PGM_INT_CODE_PROTECTION);
> +		report_xfail(host_is_tcg(), *page == 0xff, "no store occured");
> +
> +		report_prefix_pop();
> +	}
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("migration-skey");
> +	if (test_facility(169)) {
> +		report_skip("storage key removal facility is active");
> +
> +		/*
> +		 * If we just exit and don't ask migrate_cmd to migrate us, it
> +		 * will just hang forever. Hence, also ask for migration when we
> +		 * skip this test alltogether.
> +		 */
> +		puts("Please migrate me, then press return\n");
> +		(void)getchar();
> +
> +		goto done;
> +	}
> +
> +	test_migration();
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index b456b2881448..1e851d8e3dd8 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -176,3 +176,7 @@ extra_params = -cpu qemu,gs=off,vx=off
>  file = migration.elf
>  groups = migration
>  smp = 2
> +
> +[migration-skey]
> +file = migration-skey.elf
> +groups = migration

