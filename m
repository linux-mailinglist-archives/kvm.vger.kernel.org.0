Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BD05F64B1
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 12:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiJFK7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 06:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiJFK6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 06:58:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE62E9B870
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 03:58:43 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296AMeDT006892
        for <kvm@vger.kernel.org>; Thu, 6 Oct 2022 10:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/mBr/ItIWfB9XxACJFSk2B2XlNrPmL+AHbjFOM5893E=;
 b=fPYh+fqT0i53GFT53GFvVsqa9ELxnvubLF1oBqyTOi1PTwYisiQEl/ohA9i9mTMagIEt
 qTQ+oJ+PCp/vkk2Lf19HXDKsnJadHFJ4FatB7e7ElLmmqWvYReg/QgGKgBcb8wEtN5QI
 h/87UKsAVjguX2Wcz6Ygqg1Q1WjCqocbmbH773tFO3qnWeJq/uV0v55IxnAOazLzMheV
 HlFwUD0G5XdP6486TKRRZY1Zh8ABArAIop5yizrZSJ5Ik2DZSeYJdZAONHaE14wqTYIW
 sSprFsfaaTH35KpNpF9WyX317vEnCgROTLhpMPRYLase2u5dow9bSaoVk+/he1udoaIp BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1vdgj8dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 10:58:41 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2969Vl14031055
        for <kvm@vger.kernel.org>; Thu, 6 Oct 2022 10:58:41 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1vdgj8c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 10:58:41 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 296ApIi5011577;
        Thu, 6 Oct 2022 10:58:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3jxd68w3dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 10:58:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 296AwVfC2556654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Oct 2022 10:58:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 288AE4203F;
        Thu,  6 Oct 2022 10:58:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E781342042;
        Thu,  6 Oct 2022 10:58:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Oct 2022 10:58:30 +0000 (GMT)
Date:   Thu, 6 Oct 2022 12:58:28 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add migration TOD clock
 test
Message-ID: <20221006125828.7364e4f2@p-imbrenda>
In-Reply-To: <20220826084944.19466-3-nrb@linux.ibm.com>
References: <20220826084944.19466-1-nrb@linux.ibm.com>
        <20220826084944.19466-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MjgSOsJnJEqY7PsFW7UCTDErKRMmcIGI
X-Proofpoint-GUID: TE2FYrxLvmZ3IegG4jsaI10YN3invaVo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210060063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Aug 2022 10:49:44 +0200
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
>  s390x/migration-sck.c | 45 +++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg   |  4 ++++
>  3 files changed, 50 insertions(+)
>  create mode 100644 s390x/migration-sck.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c13102..be8e647bb35f 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -34,6 +34,7 @@ tests += $(TEST_DIR)/migration.elf
>  tests += $(TEST_DIR)/pv-attest.elf
>  tests += $(TEST_DIR)/migration-cmm.elf
>  tests += $(TEST_DIR)/migration-skey.elf
> +tests += $(TEST_DIR)/migration-sck.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/migration-sck.c b/s390x/migration-sck.c
> new file mode 100644
> index 000000000000..701d33f9db5a
> --- /dev/null
> +++ b/s390x/migration-sck.c
> @@ -0,0 +1,45 @@
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
> +#include <bitops.h>
> +
> +static void test_sck_migration(void)
> +{
> +	uint64_t now_before_set = 0, now_after_migration, time_to_set, time_to_advance;
> +	int cc;
> +
> +	stckf(&now_before_set);
> +
> +	/* Advance the clock by a lot more than we might ever need to migrate (60s) */

maybe give an even bigger value, just to be really sure. like 600s

> +	time_to_advance = (60ULL * 1000ULL * 1000ULL << STCK_SHIFT_US);

you can do * 1000000, and you don't need ULL everywhere; use the braces
to help humans understand what's going on:

time_to_advance = (600ULL * 1000000) << STCK_SHIFT_US;

> +	time_to_set = now_before_set + time_to_advance;
> +
> +	cc = sck(&time_to_set);
> +	report(!cc, "setting clock succeeded");
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
> index f7b1fc3dbca1..808e8a28ba96 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -185,3 +185,7 @@ groups = migration
>  [migration-skey]
>  file = migration-skey.elf
>  groups = migration
> +
> +[migration-sck]
> +file = migration-sck.elf
> +groups = migration

