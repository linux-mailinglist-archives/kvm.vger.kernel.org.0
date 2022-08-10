Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88ED358EA49
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 12:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiHJKKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 06:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiHJKKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 06:10:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AE72715E
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 03:10:16 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AA9njf008162
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BUgnC22olh4p0Td/uwZLyBTnqUENb2Y+klRQ/wU10MQ=;
 b=i8AKf2OVkQHn5UHSCivFtO30rsGkq/fpCeee+N6MPiyLmBy4CbNGJVQxD06Q6U2AU9qn
 V+7HC1buzakPFqfJ1dzk5Aw3Ovhk+GbBmqWEHNW3isCQHEh9u8DYxHcNAj5yIKRukvJs
 Rt7Syjmym2MH7pFXgnx8qid62NSpvr8/sZgnRj90T91EmnZkEzwZG62Wef5/zyjFMdrn
 vQOSXOlzFFqX/WCo4eG0pFfcRp79PqrkMX+mWiAxj5lniJwY/gsm2VnRZPCmV0K6iSAN
 oecZILAsewVejbYJJEZzkERoclpADCugd85j1hQvTD4m4rq+kWlmmGTgIq7DsmLgKjp0 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv5xerey0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:15 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27A88hNC018637
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:14 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv5xerex1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 10:10:14 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27AA8ZtJ003624;
        Wed, 10 Aug 2022 10:10:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3huww2gpdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 10:10:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27AAA92A25755908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 10:10:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0516A404D;
        Wed, 10 Aug 2022 10:10:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49ADCA4040;
        Wed, 10 Aug 2022 10:10:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.105])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 10:10:09 +0000 (GMT)
Date:   Wed, 10 Aug 2022 12:08:22 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/4] s390x: add extint loop test
Message-ID: <20220810120822.51ead12d@p-imbrenda>
In-Reply-To: <20220722060043.733796-4-nrb@linux.ibm.com>
References: <20220722060043.733796-1-nrb@linux.ibm.com>
        <20220722060043.733796-4-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: efIZCsJesQZBbnwTI0axWUc30Io33SfF
X-Proofpoint-ORIG-GUID: a7BSIr_3ajv_XKJfSGDii7odCwzYzBRy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jul 2022 08:00:42 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> The CPU timer interrupt stays pending as long as the CPU timer value is
> negative. This can lead to interruption loops when the ext_new_psw mask
> has external interrupts enabled.
> 
> QEMU is able to detect this situation and panic the guest, so add a test
> for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  s390x/Makefile            |  1 +
>  s390x/panic-loop-extint.c | 60 +++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg       |  6 ++++
>  3 files changed, 67 insertions(+)
>  create mode 100644 s390x/panic-loop-extint.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c13102..e4649da50d9d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -34,6 +34,7 @@ tests += $(TEST_DIR)/migration.elf
>  tests += $(TEST_DIR)/pv-attest.elf
>  tests += $(TEST_DIR)/migration-cmm.elf
>  tests += $(TEST_DIR)/migration-skey.elf
> +tests += $(TEST_DIR)/panic-loop-extint.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/panic-loop-extint.c b/s390x/panic-loop-extint.c
> new file mode 100644
> index 000000000000..d3a3f06d9a34
> --- /dev/null
> +++ b/s390x/panic-loop-extint.c
> @@ -0,0 +1,60 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * External interrupt loop test
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <asm/interrupt.h>
> +#include <asm/barrier.h>
> +#include <asm/time.h>
> +#include <hardware.h>
> +
> +static void ext_int_handler(void)
> +{
> +	/*
> +	 * return to ext_old_psw. This gives us the chance to print the return_fail
> +	 * in case something goes wrong.
> +	 */
> +	asm volatile (
> +		"lpswe %[ext_old_psw]\n"
> +		:
> +		: [ext_old_psw] "Q"(lowcore.ext_old_psw)
> +		: "memory"
> +	);
> +}

why should ext_old_psw contain a good PSW? wouldn't it contain the
PSW at the time of the interrupt? (which in this case is the new PSW)

but this should never happen anyway, right?

> +
> +int main(void)
> +{
> +	struct psw ext_new_psw_orig;
> +
> +	report_prefix_push("panic-loop-extint");
> +
> +	if (!host_is_qemu() || host_is_tcg()) {
> +		report_skip("QEMU-KVM-only test");
> +		goto out;
> +	}
> +
> +	ext_new_psw_orig = lowcore.ext_new_psw;
> +	lowcore.ext_new_psw.addr = (uint64_t)ext_int_handler;
> +	lowcore.ext_new_psw.mask |= PSW_MASK_EXT;
> +
> +	load_psw_mask(extract_psw_mask() | PSW_MASK_EXT);
> +	ctl_set_bit(0, CTL0_CLOCK_COMPARATOR);
> +
> +	cpu_timer_set_ms(1);
> +
> +	mdelay(2000);
> +
> +	/* restore previous ext_new_psw so QEMU can properly terminate */
> +	lowcore.ext_new_psw = ext_new_psw_orig;
> +
> +	report_fail("survived extint loop");
> +
> +out:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index f7b1fc3dbca1..b1b25f118ff6 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -185,3 +185,9 @@ groups = migration
>  [migration-skey]
>  file = migration-skey.elf
>  groups = migration
> +
> +[panic-loop-extint]
> +file = panic-loop-extint.elf
> +groups = panic
> +accel = kvm
> +timeout = 5

