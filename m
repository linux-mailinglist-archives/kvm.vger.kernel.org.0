Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6772C5FB8F0
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJKRHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 13:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJKRHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 13:07:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6FB32A96
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 10:07:30 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BGrOwX003680
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=VXpTYk5Djwm8xgm9+rYe6OHvxTsVGrA2MAJqkUugsJc=;
 b=diOjtMwZ30alWfMRKvLwX2d9vlaYno9icJi6CM/I9HJhXxWZ1S/M2RLee9H1FG47KV+6
 ZpPIvosVukjba383X6mmpL/+PFolX1h9GJK9D83qMCRoNWXVLvAnFPbsr2ji7vyBPpxQ
 mR9Yd6vGprdVkYtOjtcFmz5jwQxmfHtjVewkJ0DE3l/eHzk5op4JLuLudT9AVS9hV3gR
 7/gU+Wytbj7bX0fXnN5KpKmavoKj55ApZ9L5HEvQa+VjIdldLdKldBv9OZ86/tidGTa8
 GN69dTrwbVDYMoJox5bw88koXdvmhhrKh5mltq2rJlvmClkd+FZJz3iRQmP6G7mkX1g3 Fw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5cd70dkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:07:30 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BH4fH9006088
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:07:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3k30u94rhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:07:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BH7PNd721634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 17:07:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E76AC5204F;
        Tue, 11 Oct 2022 17:07:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B486F5204E;
        Tue, 11 Oct 2022 17:07:24 +0000 (GMT)
Date:   Tue, 11 Oct 2022 19:07:23 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: add migration TOD clock
 test
Message-ID: <20221011190723.358a8628@p-imbrenda>
In-Reply-To: <20221011170024.972135-3-nrb@linux.ibm.com>
References: <20221011170024.972135-1-nrb@linux.ibm.com>
        <20221011170024.972135-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3SE63n5Zt3znwEwvkNRBkyGwHEhvUJFU
X-Proofpoint-ORIG-GUID: 3SE63n5Zt3znwEwvkNRBkyGwHEhvUJFU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Oct 2022 19:00:24 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On migration, we expect the guest clock value to be preserved. Add a
> test to verify this:
> - advance the guest TOD by much more than we need to migrate
> - migrate the guest
> - get the guest TOD
> 
> After migration, assert the guest TOD value is at least the value we set
> before migration. This is the minimal check for architectural
> compliance; implementations may decide to do something more
> sophisticated.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/Makefile        |  1 +
>  s390x/migration-sck.c | 54 +++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg   |  4 ++++
>  3 files changed, 59 insertions(+)
>  create mode 100644 s390x/migration-sck.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 649486f2d4a0..fba09bc2df3a 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -36,6 +36,7 @@ tests += $(TEST_DIR)/migration-cmm.elf
>  tests += $(TEST_DIR)/migration-skey.elf
>  tests += $(TEST_DIR)/panic-loop-extint.elf
>  tests += $(TEST_DIR)/panic-loop-pgm.elf
> +tests += $(TEST_DIR)/migration-sck.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/migration-sck.c b/s390x/migration-sck.c
> new file mode 100644
> index 000000000000..2d9a195ab4c4
> --- /dev/null
> +++ b/s390x/migration-sck.c
> @@ -0,0 +1,54 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * SET CLOCK migration tests
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm/time.h>
> +
> +static void test_sck_migration(void)
> +{
> +	uint64_t now_before_set = 0, now_after_set = 0, now_after_migration, time_to_set, time_to_advance;
> +	int cc;
> +
> +	stckf(&now_before_set);
> +
> +	/* Advance the clock by a lot more than we might ever need to migrate (600s) */
> +	time_to_advance = (600ULL * 1000000) << STCK_SHIFT_US;
> +	time_to_set = now_before_set + time_to_advance;
> +
> +	cc = sck(&time_to_set);
> +	report(!cc, "setting clock succeeded");
> +
> +	/* Check the clock is running after being set */
> +	cc = stckf(&now_after_set);
> +	report(!cc, "clock running after set");
> +	report(now_after_set >= time_to_set, "TOD clock value is larger than what has been set");
> +
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
> +
> +	cc = stckf(&now_after_migration);
> +	report(!cc, "clock still set");
> +
> +	/*
> +	 * The architectural requirement for the TOD clock is that it doesn't move backwards after
> +	 * migration. Implementations can just migrate the guest TOD value or do something more
> +	 * sophisticated (e.g. slowly adjust to the host TOD).
> +	 */
> +	report(now_after_migration >= time_to_set, "TOD clock value did not jump backwards");
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("migration-sck");
> +
> +	test_sck_migration();
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index f9f102abfa89..2c04ae7c7c15 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -197,3 +197,7 @@ file = panic-loop-pgm.elf
>  groups = panic
>  accel = kvm
>  timeout = 5
> +
> +[migration-sck]
> +file = migration-sck.elf
> +groups = migration

