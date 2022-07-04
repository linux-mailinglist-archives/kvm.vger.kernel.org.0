Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9D556505D
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 11:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiGDJG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 05:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbiGDJGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 05:06:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D373FB7E7;
        Mon,  4 Jul 2022 02:06:52 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2648oPcP020678;
        Mon, 4 Jul 2022 09:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HW+sPMQyRFFcPJLwEMs+JcvR+mWUArbdmz4egIce6NI=;
 b=B/RVLTC8kUUQaPVfin2ekQoGFtLHQVP4NCbgRW/so14Vy1MRfpk9CcYF0XF05Tq0Y5Br
 CDVOiDuJHxGZxTiZgixY30Y32Rx2LXS/VbSclnx5VrWO0EmNzsyzUw21ix0Kgqth41Pk
 yfjuj7Rht6V9QmDnvaPGkiYBMGpkyHzAiO7xcNT23boaVfoZ+s1/dUCnlQvdTAJsr+WP
 hB5Wp+ng2TLcGYOB9+fL/HB30adMY3DXbyaG+wkeRcF6NvlHuweT6gu5T8+szJkIb8lD
 rMa3tRvTqC0C2DvFq6/pR3B5THhapOy8/t4X/7QjD4jf60qMoYhatMeJ4/8bopdJOdRi Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3w22rcf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 09:06:51 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2648omST021884;
        Mon, 4 Jul 2022 09:06:50 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3w22rceu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 09:06:50 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26496EX4018205;
        Mon, 4 Jul 2022 09:06:49 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3h2dn91ttu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 09:06:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26496jVD20447606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 09:06:45 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3FDC42041;
        Mon,  4 Jul 2022 09:06:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 910204203F;
        Mon,  4 Jul 2022 09:06:45 +0000 (GMT)
Received: from [9.145.190.147] (unknown [9.145.190.147])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jul 2022 09:06:45 +0000 (GMT)
Message-ID: <6f6403ef-ebf9-8f3e-a66e-c9141800826c@linux.ibm.com>
Date:   Mon, 4 Jul 2022 11:06:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v1 3/3] s390x: add pgm spec interrupt loop
 test
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220630113059.229221-1-nrb@linux.ibm.com>
 <20220630113059.229221-4-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220630113059.229221-4-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5HAdkJUoMbdx6j5bRAb2iKdCPM0IfVcm
X-Proofpoint-GUID: l1hHwpTEe5rLRV1F-aNcsuJeBG3WI2al
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0
 mlxlogscore=944 mlxscore=0 suspectscore=0 spamscore=0 clxscore=1015
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2207040038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/22 13:30, Nico Boehr wrote:
> An invalid PSW causes a program interrupt. When an invalid PSW is
> introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
> program interrupt is caused.
> 
> QEMU should detect that and panick the guest, hence add a test for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Test is fine but the same general comments as in patch #2 apply.

> ---
>   s390x/Makefile      |  1 +
>   s390x/pgmint-loop.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |  4 ++++
>   3 files changed, 51 insertions(+)
>   create mode 100644 s390x/pgmint-loop.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 92a020234c9f..a600dbfb3f4c 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -35,6 +35,7 @@ tests += $(TEST_DIR)/pv-attest.elf
>   tests += $(TEST_DIR)/migration-cmm.elf
>   tests += $(TEST_DIR)/migration-skey.elf
>   tests += $(TEST_DIR)/extint-loop.elf
> +tests += $(TEST_DIR)/pgmint-loop.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/pgmint-loop.c b/s390x/pgmint-loop.c
> new file mode 100644
> index 000000000000..5b74f26dbc3d
> --- /dev/null
> +++ b/s390x/pgmint-loop.c
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Program interrupt loop test
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <bitops.h>
> +#include <asm/interrupt.h>
> +#include <asm/barrier.h>
> +
> +static void pgm_int_handler(void)
> +{
> +	/*
> +	 * return to pgm_old_psw. This gives us the chance to print the return_fail
> +	 * in case something goes wrong.
> +	 */
> +	asm volatile (
> +		"lpswe %[pgm_old_psw]\n"
> +		:
> +		: [pgm_old_psw] "Q"(lowcore.pgm_old_psw)
> +		: "memory"
> +	);
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("pgmint-loop");
> +
> +	lowcore.pgm_new_psw.addr = (uint64_t) pgm_int_handler;
> +	/* bit 12 set is invalid */
> +	lowcore.pgm_new_psw.mask = extract_psw_mask() | BIT(63 - 12);
> +	mb();
> +
> +	/* cause a pgm int */
> +	*((int *)-4) = 0x42;
> +	mb();
> +
> +	report_fail("survived pgmint loop");
> +
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 7d408f2d5310..c3073bfc4363 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -188,3 +188,7 @@ groups = migration
>   [extint-loop]
>   file = extint-loop.elf
>   groups = panic
> +
> +[pgmint-loop]
> +file = pgmint-loop.elf
> +groups = panic

