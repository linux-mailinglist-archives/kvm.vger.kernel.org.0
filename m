Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24FB59E148
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357797AbiHWLme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358353AbiHWLlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:41:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB31391084
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 02:29:13 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N9Ofgd006263
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CXCo7fgT/zXdjZOtSoxSSJ9jJuy4j5P6mjZkwCBWmhw=;
 b=RhIWYtGNxNLsI/4WrXw+v+KSWvw0sfqgLdZguQWkXIxxvTLjgshloDZ4/oqtJfU+PSaY
 I/+HglAO/Gp1dxfPFJ8fG0jiWZskS9RXJyxL2Yv3U1p+ZKUH5vpaQQHekSODtgcsNN6u
 BgSlGD9q/XLgwH/R0jja+1EhxndqMncH9hSD5o+YBaOwm+7qlJGm+WtYQZSKDVqlGE+e
 +ypwH/VVJtNpD2bl9eJ4eCDqa2q0e4SiO+e0FIFKMlO2FYp9GJaejeNXcyzNjpIM+xZI
 vsFSRfWERG6kddn4af+QCTi8m66mmqKmLjLBCMrj1pFDR0oV/MA33qgObWBMaM+u61Jp Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4v85r2pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:29:12 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27N9TCXG024784
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:29:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4v85r2np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:29:11 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27N9LKRR015981;
        Tue, 23 Aug 2022 09:29:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3j2q88uhkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:29:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27N9TQ1m30081284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 09:29:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FA4AA405F;
        Tue, 23 Aug 2022 09:29:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83BB3A4054;
        Tue, 23 Aug 2022 09:29:05 +0000 (GMT)
Received: from [9.145.84.26] (unknown [9.145.84.26])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 09:29:05 +0000 (GMT)
Message-ID: <81606959-de32-2cd8-2f0a-4886fabc73cc@linux.ibm.com>
Date:   Tue, 23 Aug 2022 11:29:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v5 3/4] s390x: add extint loop test
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220823084525.52365-1-nrb@linux.ibm.com>
 <20220823084525.52365-4-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220823084525.52365-4-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0VIWlRNKIUH9kDfjjwl2xwgdpZozOBpE
X-Proofpoint-ORIG-GUID: Fo0tnP-AxWEUCZLY7VRbxQ5AqR2cmpbR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 impostorscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/22 10:45, Nico Boehr wrote:
> The CPU timer interrupt stays pending as long as the CPU timer value is
> negative. This can lead to interruption loops when the ext_new_psw mask
> has external interrupts enabled.

and the CPU timer subclass in CR0 is enabled

Otherwise:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> QEMU is able to detect this situation and panic the guest, so add a test
> for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>   s390x/Makefile            |  1 +
>   s390x/panic-loop-extint.c | 59 +++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg       |  6 ++++
>   3 files changed, 66 insertions(+)
>   create mode 100644 s390x/panic-loop-extint.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c13102..e4649da50d9d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -34,6 +34,7 @@ tests += $(TEST_DIR)/migration.elf
>   tests += $(TEST_DIR)/pv-attest.elf
>   tests += $(TEST_DIR)/migration-cmm.elf
>   tests += $(TEST_DIR)/migration-skey.elf
> +tests += $(TEST_DIR)/panic-loop-extint.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/panic-loop-extint.c b/s390x/panic-loop-extint.c
> new file mode 100644
> index 000000000000..07325147dc17
> --- /dev/null
> +++ b/s390x/panic-loop-extint.c
> @@ -0,0 +1,59 @@
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
> +#include <bitops.h>
> +
> +static void ext_int_cleanup(struct stack_frame_int *stack)
> +{
> +	/*
> +	 * Since we form a loop of ext interrupts, this code should never be
> +	 * executed. In case it is executed, something went wrong and we want to
> +	 * print a failure.
> +	 *
> +	 * Because the CPU timer subclass mask is still enabled, the CPU timer
> +	 * interrupt will fire every time we enable external interrupts,
> +	 * preventing us from printing the failure on the console. To avoid
> +	 * this, clear the CPU timer subclass mask here.
> +	 */
> +	stack->crs[0] &= ~BIT(CTL0_CPU_TIMER);
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("panic-loop-extint");
> +
> +	if (!host_is_qemu() || host_is_tcg()) {
> +		report_skip("QEMU-KVM-only test");
> +		goto out;
> +	}
> +
> +	expect_ext_int();
> +	lowcore.ext_new_psw.mask |= PSW_MASK_EXT;
> +
> +	psw_mask_set_bits(PSW_MASK_EXT);
> +
> +	register_ext_cleanup_func(ext_int_cleanup);
> +
> +	cpu_timer_set_ms(10);
> +	ctl_set_bit(0, CTL0_CPU_TIMER);
> +	mdelay(2000);
> +
> +	register_ext_cleanup_func(NULL);
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
>   [migration-skey]
>   file = migration-skey.elf
>   groups = migration
> +
> +[panic-loop-extint]
> +file = panic-loop-extint.elf
> +groups = panic
> +accel = kvm
> +timeout = 5

