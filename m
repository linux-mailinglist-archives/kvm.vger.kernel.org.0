Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF95546072
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 10:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348287AbiFJIuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 04:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348479AbiFJIti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 04:49:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E341AEC48;
        Fri, 10 Jun 2022 01:49:36 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A8hjwe028360;
        Fri, 10 Jun 2022 08:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TbpY1QUU82zSINcuPqMyhi60ym+wKD+4NBlLCes3KyI=;
 b=fLDjrtl5TBZyp7OW9zLHdAjSe3qM4wX5AXa4CKvD9iHNM+8AsONlj8eK1luScOHLjCNp
 L/FnR754I7dC1Sx7/ehCJx1ZsKa/SKPSQmHm9n9J8lMJSuLeET160kaP5zaXfYXh/8p+
 pMN3SxNllxpEfdW1oq/QmQvz2VT1FoDpCC00kiN05M6Geel2S/DYMUA3g1ro2Yc020BE
 vRk9Oe/SeJbQ9J7Cb0JNnH86CwHHztOsNf/GTcqrRDI6e8Ei0FNmU7rIYUo75SoPhhf/
 3/uaZDEqTX2RYgg+TBULbdI+53z+sxQjub3PRH5/RFcD/sSKVvCYmLQSmvf5OtDFmcs0 rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gkykj3ej7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 08:49:35 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25A8dXbi022514;
        Fri, 10 Jun 2022 08:49:35 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gkykj3ehn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 08:49:35 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25A8b6P9008976;
        Fri, 10 Jun 2022 08:49:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3gfy18xase-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 08:49:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25A8nTGC15335810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:49:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9590F52050;
        Fri, 10 Jun 2022 08:49:29 +0000 (GMT)
Received: from [9.145.63.156] (unknown [9.145.63.156])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 44A065204E;
        Fri, 10 Jun 2022 08:49:29 +0000 (GMT)
Message-ID: <2fc9f517-57d0-73ae-3083-26e5dcf05dbb@linux.ibm.com>
Date:   Fri, 10 Jun 2022 10:49:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, scgl@linux.ibm.com
References: <20220608131328.6519-1-nrb@linux.ibm.com>
 <20220608131328.6519-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 1/1] s390x: add migration test for
 storage keys
In-Reply-To: <20220608131328.6519-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VRerNxa_LDjcladSTAjVV74V_tlxRqsY
X-Proofpoint-ORIG-GUID: -XA-Gy_F3kSrag5w9SuJrQc6XyfW77am
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-10_02,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 impostorscore=0 clxscore=1011 mlxscore=0 malwarescore=0 suspectscore=0
 phishscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206100030
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/22 15:13, Nico Boehr wrote:
> Upon migration, we expect storage keys set by the guest to be preserved, so add
> a test for it.
> 
> We keep 128 pages and set predictable storage keys. Then, we migrate and check
> that they can be read back and match the value originally set.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>   s390x/Makefile         |  1 +
>   s390x/migration-skey.c | 73 ++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg    |  4 +++
>   3 files changed, 78 insertions(+)
>   create mode 100644 s390x/migration-skey.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 25802428fa13..94fc5c1a3527 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -33,6 +33,7 @@ tests += $(TEST_DIR)/adtl-status.elf
>   tests += $(TEST_DIR)/migration.elf
>   tests += $(TEST_DIR)/pv-attest.elf
>   tests += $(TEST_DIR)/migration-cmm.elf
> +tests += $(TEST_DIR)/migration-skey.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> new file mode 100644
> index 000000000000..323aa83202bb
> --- /dev/null
> +++ b/s390x/migration-skey.c
> @@ -0,0 +1,73 @@
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
> +	union skey expected_key, actual_key;
> +	int i, key_to_set;
> +
> +	for (i = 0; i < NUM_PAGES; i++) {
> +		/*
> +		 * Storage keys are 7 bit, lowest bit is always returned as zero
> +		 * by iske
> +		 */

Maybe add:
This loop will set all 7 bits which means we set fetch protection as 
well as reference and change indication for some keys.

> +		key_to_set = i * 2;
> +		set_storage_key(pagebuf[i], key_to_set, 1);
> +	}
> +
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
> +
> +	for (i = 0; i < NUM_PAGES; i++) {
> +		report_prefix_pushf("page %d", i);
> +
> +		actual_key.val = get_storage_key(pagebuf[i]);

iske is nice but I think it would also be interesting to check if the 
actual memory protection was carried over. The iske check is enough for 
now though.

> +		expected_key.val = i * 2;
> +
> +		/* ignore reference bit */
> +		actual_key.str.rf = 0;
> +		expected_key.str.rf = 0;
> +
> +		report(actual_key.val == expected_key.val, "expected_key=0x%x actual_key=0x%x", expected_key.val, actual_key.val);

This spams the log with useless information and hence I generally try to 
avoid printing large loops.

Instead we should print all fails or a simple success message if all 
comparisons were successful.

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
> +		 * skip this test altogether.
> +		 */
> +		puts("Please migrate me, then press return\n");
> +		(void)getchar();
> +	} else {
> +		test_migration();
> +	}
> +
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 9b97d0471bcf..8e52f560bb1e 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -180,3 +180,7 @@ smp = 2
>   [migration-cmm]
>   file = migration-cmm.elf
>   groups = migration
> +
> +[migration-skey]
> +file = migration-skey.elf
> +groups = migration

