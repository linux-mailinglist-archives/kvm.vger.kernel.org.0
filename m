Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D064722140
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 10:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjFEImv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 04:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjFEImt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 04:42:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC10B0;
        Mon,  5 Jun 2023 01:42:48 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35587Mba021500;
        Mon, 5 Jun 2023 08:42:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=04KNaehcxq3i5pmViaEh2j0uX3Q34jArvcwibC0nHjA=;
 b=I7hKM7edOzWQ7RpflRNU8DqZZX2YnvLhj8c61fNpw5gN2aPDLNwEu4U2yet8Vzx9xcPx
 1+acMt2HCWyPJJbw/1KpRVwxWpH6pzwkkBD2zl24MXIkDJLC2faAz7ihPrk2ZyTTWNWI
 UMPxMYq0CPjF80I2SalDptLBJBd/Z26DFPeSACl041r5pN0eqRRkLPNlM8cmtOjvMN8s
 bmKIxVJQFHzb5h1F0AXqp0yhKX/yvYakIQH4fTRNZUj6Oy0ICEAVkOTK1vrU5tPEs/LK
 zhRAURMeG5yZ3bqvZ7ElXH8ykV2G7S7PFTZzXGOZB8gWKBA8HKZB7XXCouOYEC9dzjXw EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1bpjs8sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 08:42:47 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35587Vjx022579;
        Mon, 5 Jun 2023 08:42:47 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1bpjs8s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 08:42:47 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3550sfFI016654;
        Mon, 5 Jun 2023 08:42:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qyxbu8ytm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 08:42:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3558gfpa16712310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 08:42:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 390DA2004B;
        Mon,  5 Jun 2023 08:42:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF43A20040;
        Mon,  5 Jun 2023 08:42:40 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 08:42:40 +0000 (GMT)
Message-ID: <e9be6bfb-344c-efb5-9019-355ecb54b5aa@linux.ibm.com>
Date:   Mon, 5 Jun 2023 10:42:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230601070202.152094-1-nrb@linux.ibm.com>
 <20230601070202.152094-3-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/6] s390x: add function to set DAT mode
 for all interrupts
In-Reply-To: <20230601070202.152094-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mAr-pVT6lfrtXrkiEnxkWj9MKkMagw7q
X-Proofpoint-GUID: ri66TQuhJZyXNmB5q4Wka2-u08lUHRN0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050077
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/23 09:01, Nico Boehr wrote:
> When toggling DAT or switch address space modes, it is likely that

s/switch/switching/

> interrupts should be handled in the same DAT or address space mode.
> 
> Add a function which toggles DAT and address space mode for all
> interruptions, except restart interrupts.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/interrupt.h |  4 ++++
>   lib/s390x/interrupt.c     | 35 +++++++++++++++++++++++++++++++++++
>   lib/s390x/mmu.c           |  5 +++--
>   3 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 35c1145f0349..55759002dce2 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -83,6 +83,10 @@ void expect_ext_int(void);
>   uint16_t clear_pgm_int(void);
>   void check_pgm_int_code(uint16_t code);
>   
> +#define IRQ_DAT_ON	true
> +#define IRQ_DAT_OFF	false
> +void irq_set_dat_mode(bool dat, uint64_t as);
> +
>   /* Activate low-address protection */
>   static inline void low_prot_enable(void)
>   {
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 3f993a363ae2..d97b5a3a7e97 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -9,6 +9,7 @@
>    */
>   #include <libcflat.h>
>   #include <asm/barrier.h>
> +#include <asm/mem.h>
>   #include <asm/asm-offsets.h>
>   #include <sclp.h>
>   #include <interrupt.h>
> @@ -104,6 +105,40 @@ void register_ext_cleanup_func(void (*f)(struct stack_frame_int *))
>   	THIS_CPU->ext_cleanup_func = f;
>   }
>   
> +/**
> + * irq_set_dat_mode - Set the DAT mode of all interrupt handlers, except for
> + * restart.
> + * This will update the DAT mode and address space mode of all interrupt new
> + * PSWs.
> + *
> + * Since enabling DAT needs initalized CRs and the restart new PSW is often used

s/initalized/initialized/

That seems to be a problematic word.

> + * to initalize CRs, the restart new PSW is never touched to avoid the chicken
> + * and egg situation.

Same here.

> + *
> + * @dat specifies whether to use DAT or not
> + * @as specifies the address space mode to use - one of AS_PRIM, AS_ACCR,
> + * AS_SECN or AS_HOME.
> + */
> +void irq_set_dat_mode(bool dat, uint64_t as)
> +{
> +	struct psw* irq_psws[] = {
> +		OPAQUE_PTR(GEN_LC_EXT_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_SVC_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_PGM_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_MCCK_NEW_PSW),
> +		OPAQUE_PTR(GEN_LC_IO_NEW_PSW),
> +		NULL /* sentinel */
> +	};
> +
> +	assert(as == AS_PRIM || as == AS_ACCR || as == AS_SECN || as == AS_HOME);

/* There are only 4 spaces */
assert(as < 4); ?

> +
> +	for (struct psw *psw = irq_psws[0]; psw != NULL; psw++) {

While this is ok in gnu99/c99 I generally prefer declaring the variable 
outside of the loop since it's more readable when using structs and unions.

> +		psw->dat = dat;
> +		if (dat)
> +			psw->as = as;

Does that check even matter?

> +	}
> +}
> +
>   static void fixup_pgm_int(struct stack_frame_int *stack)
>   {
>   	/* If we have an error on SIE we directly move to sie_exit */
> diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
> index b474d7021d3f..199bd3fbc9c8 100644
> --- a/lib/s390x/mmu.c
> +++ b/lib/s390x/mmu.c
> @@ -12,6 +12,7 @@
>   #include <asm/pgtable.h>
>   #include <asm/arch_def.h>
>   #include <asm/barrier.h>
> +#include <asm/interrupt.h>
>   #include <vmalloc.h>
>   #include "mmu.h"
>   
> @@ -41,8 +42,8 @@ static void mmu_enable(pgd_t *pgtable)
>   	/* enable dat (primary == 0 set as default) */
>   	enable_dat();
>   
> -	/* we can now also use DAT unconditionally in our PGM handler */
> -	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT;
> +	/* we can now also use DAT in all interrupt handlers */
> +	irq_set_dat_mode(IRQ_DAT_ON, AS_PRIM);
>   }
>   
>   /*

