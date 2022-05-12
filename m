Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9A2525077
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 16:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355532AbiELOnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 10:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347679AbiELOnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 10:43:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1558A140866;
        Thu, 12 May 2022 07:43:10 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CETeuN014305;
        Thu, 12 May 2022 14:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bCYntmLBv7zIwpeXThdfmgPfVSJZtndBYOzUoNeGOlE=;
 b=dk6vuL4kEOoXGCLHqIwg11Qc4NVlkRjAWDSKzBEDLLcxmW2y5Y0mgGLpVcW3tX5IBPNk
 kSSmNSk31c1YAmFA6bbVj1J15upT9GFRTBP89X6aiLorJmgKCXxqiObW0YO50h4twYt0
 9Hc+oE5TyroU0xeulsQUvqq6m5sZFocEPjXF5gXV0vRw5UNzsK0hjw7GV5+qFN935BIc
 fAeSZ1KU9vTchu7eAbRf32U61ggA9hCMs04JmQQrN7F+82m62FJ0WjpqERONvq4AaDep
 esPQ8L9ECsD7DRfhJdHCI7vEt/ImTyPS5sS3iujxdQSiv702QrqzKG+SiCFaxnEAeJAw og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g14238d07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 14:43:09 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CEX6Xf028186;
        Thu, 12 May 2022 14:43:08 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g14238cy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 14:43:08 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CEg5KF004047;
        Thu, 12 May 2022 14:43:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3fwgd8wmx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 14:43:06 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CEh2Zi37945748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 14:43:02 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCE73A4057;
        Thu, 12 May 2022 14:43:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D608A4040;
        Thu, 12 May 2022 14:43:02 +0000 (GMT)
Received: from [9.145.2.10] (unknown [9.145.2.10])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 14:43:02 +0000 (GMT)
Message-ID: <60462048-c661-1af2-e55f-24bf4d636e63@linux.ibm.com>
Date:   Thu, 12 May 2022 16:43:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add migration test for
 storage keys
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, scgl@linux.ibm.com
References: <20220512140107.1432019-1-nrb@linux.ibm.com>
 <20220512140107.1432019-3-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220512140107.1432019-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: F5sAPNy7dQfTX9uRWx17Zi3WzVklIo2M
X-Proofpoint-GUID: GkROzabkxP_-kD5yxpW-I3G7qnhD3j6u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_11,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=990 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120069
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/12/22 16:01, Nico Boehr wrote:
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
>   s390x/Makefile         |  1 +
>   s390x/migration-skey.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg    |  4 ++
>   3 files changed, 103 insertions(+)
>   create mode 100644 s390x/migration-skey.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index a8e04aa6fe4d..f8ea594b641d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -32,6 +32,7 @@ tests += $(TEST_DIR)/epsw.elf
>   tests += $(TEST_DIR)/adtl-status.elf
>   tests += $(TEST_DIR)/migration.elf
>   tests += $(TEST_DIR)/pv-attest.elf
> +tests += $(TEST_DIR)/migration-skey.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
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

What's the expected pgm code?
Is it 0 because no pgm was injected?
