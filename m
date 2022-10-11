Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546545FB7BE
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 17:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJKPwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 11:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiJKPvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 11:51:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE093F337
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 08:49:20 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BFL2WR025812
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:49:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1IL2X5LagJcTTHKfBB0fQKL4MG7UJJa6lxeVwBzDK9k=;
 b=EbrsSsmAJJQPXAVqdccVA5b4uhvRSs1FBoEmRD85BmIET5J8q5rQWZha346gOKhk74T/
 xEmRFbz6ka8uyJQHqyBGJYqS17y/RhjEToF7VWaUIUG5lofrsGv0K07S/DbX+BXzcRai
 Bil+GN2z58CWJ+hV1Wt1zS+iTJFHm6uTq5w0qZSoKj9ASXbcLODEd4VYPZ32sERFqOc+
 Ko/w2Xhi5nsPvjC8EqwEkLzBQnUZmCVkTWpvSMlnHe7/rvtme0gkNzctMDZwopKrUwnU
 AZLS4ojMDHqK0eoWDOOfmRm3hz1ewxRre36zK2CtSpDMHJGpY5nxIMZjXWZd3OOm14+q WQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5b270v58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:49:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BFaZsH005428
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:49:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3k30u9cpcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:49:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BFnjSD51446256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 15:49:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F37BAE051;
        Tue, 11 Oct 2022 15:49:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06A75AE045;
        Tue, 11 Oct 2022 15:49:14 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 15:49:13 +0000 (GMT)
Date:   Tue, 11 Oct 2022 17:49:12 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: add migration TOD clock
 test
Message-ID: <20221011174912.1495d8c7@p-imbrenda>
In-Reply-To: <20221011151433.886294-3-nrb@linux.ibm.com>
References: <20221011151433.886294-1-nrb@linux.ibm.com>
        <20221011151433.886294-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VDdm00gfo9v0JnuQT0hHWtDxzWNiMICf
X-Proofpoint-GUID: VDdm00gfo9v0JnuQT0hHWtDxzWNiMICf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Oct 2022 17:14:33 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On migration, we expect the guest clock value to be preserved. Add a
> test to verify this:
> - advance the guest TOD by much more than we need to migrate
> - migrate the guest
> - get the guest TOD
> 
> After migration, assert the guest TOD value is at least the value we set
> before migration.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile        |  1 +
>  s390x/migration-sck.c | 44 +++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg   |  4 ++++
>  3 files changed, 49 insertions(+)
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
> index 000000000000..286a693b4858
> --- /dev/null
> +++ b/s390x/migration-sck.c
> @@ -0,0 +1,44 @@
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
> +	uint64_t now_before_set = 0, now_after_migration, time_to_set, time_to_advance;
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

I would also check here that the clock is set. This way we can
differentiate between a migration issue or a more general (and more
severe) clock issue. Even if we have this test somewhere else, this
makes it easier when debugging to narrow down the issue to migration.

> +
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
> +
> +	cc = stckf(&now_after_migration);
> +	report(!cc, "clock still set");
> +
> +	report(now_after_migration >= time_to_set, "TOD clock value preserved");
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

