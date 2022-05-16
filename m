Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67B6528AD2
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 18:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343719AbiEPQsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 12:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiEPQsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 12:48:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FF73C70B;
        Mon, 16 May 2022 09:48:04 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GGXAJM005769;
        Mon, 16 May 2022 16:48:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VNUdLvdX0E2cFai9PPauNmj5sGnbkJyC1D19ckT58og=;
 b=AkIYoXpdrxiRe3KXLFzBMLxd4bvkVIvDWuBexidiH9EPvjqea7XR+B+itFKoqz4vZJlM
 XLxRFg1hSvTk3Gkq1Vy875ymQWsoNMMnoEkhF16nG2cYXL0iNNqrlYOTQ8amdIqF9vGo
 7nkp/zKJqQiwue/o/KUW+k1k94tM/VGowg7C9JYGVCldI6A/HyHOtrIJmkwTqFT068yN
 tt3SPO7C8kAsUaPMkiWppmk1sEGYZnPI21trnA3cHwvZm2VjBicUwJqNloMopTszYQwR
 /ctMJ2vESuWY8dpjgHcnlOmAmhR1nCvoxor+ej2ih7LKsKVG5u9KUA3CNYsS5lOuu6pD Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3t8088kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:48:03 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GGXph3007432;
        Mon, 16 May 2022 16:48:02 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3t8088ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:48:02 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GGSMFf005573;
        Mon, 16 May 2022 16:47:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429b0jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:47:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GGlqlJ50397488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 16:47:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EEA65204F;
        Mon, 16 May 2022 16:47:52 +0000 (GMT)
Received: from [9.171.29.242] (unknown [9.171.29.242])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 11F9B52050;
        Mon, 16 May 2022 16:47:52 +0000 (GMT)
Message-ID: <947af627-64e0-486d-18e2-c877bc4c4ba6@linux.ibm.com>
Date:   Mon, 16 May 2022 18:47:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add migration test for
 storage keys
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220516090702.1939253-1-nrb@linux.ibm.com>
 <20220516090702.1939253-2-nrb@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220516090702.1939253-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G4VITCLOIp49hJpOHD3Q9i0fDDOzwFm_
X-Proofpoint-ORIG-GUID: pjTzmbFzcItItzAHDy--ycrOtlkX2XEi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160092
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/22 11:07, Nico Boehr wrote:
> Upon migration, we expect storage keys being set by the guest to be preserved,
> so add a test for it.

"being set" implies that keys are set while the migration is going on.
That's not the case, is it?
> 
> We keep 128 pages and set predictable storage keys. Then, we migrate and check
> they can be read back and the respective access restrictions are in place when

... check that they ...

> the access key in the PSW doesn't match.

The latter half of the sentence doesn't apply anymore, now that you simplified the test.
So maybe something like: ... and check that they can be read back and match the value
originally set.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile         |  1 +
>  s390x/migration-skey.c | 78 ++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg    |  4 +++
>  3 files changed, 83 insertions(+)
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
> index 000000000000..ee4622eb94ba
> --- /dev/null
> +++ b/s390x/migration-skey.c
> @@ -0,0 +1,78 @@
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
> +	union skey expected_key, actual_key;
> +
> +	for (i = 0; i < NUM_PAGES; i++) {
> +		/*
> +		 * Storage keys are 7 bit, lowest bit is always returned as zero
> +		 * by iske
> +		 */
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
> +		page = &pagebuf[i][0];
> +		actual_key.val = get_storage_key(page);

The page variable is kinda useless now, I'd just do get_storage_key(pagebuf[0]).
> +		expected_key.val = i * 2;
> +
> +		/* ignore reference bit */

Why? Are there any implicit references I'm missing?
> +		actual_key.str.rf = 0;
> +		expected_key.str.rf = 0;
> +
> +		report(actual_key.val == expected_key.val, "expected_key=0x%x actual_key=0x%x", expected_key.val, actual_key.val);
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

