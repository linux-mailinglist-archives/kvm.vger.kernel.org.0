Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8023407BD
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 15:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhCROXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 10:23:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230048AbhCROWo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 10:22:44 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IE43aA027430
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 10:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=it5kDzwkg7tphbYOm/unlQ+9TOv5PzbBQc67RaSqtAQ=;
 b=VOQC6wMcNOu4pRY8Z+z7Kwa5xLb78b0V3F9KLwjhBdF+8Vo0GZlSIyVu8LJZl2RBCyYo
 7BJ2r3lh8sJmPvcDO8M8LDms/nPKZeTyFnafDhLxzyshmubHi+5O6fXxGTA6W69SyoH8
 VimN1WVR3Jk61/Rfy2GEHFlIvn59PdeI6BcUh13zDDSHTE42dFOkYejUqpWhcorkKx68
 49h2gLCoGA+SMNbKMI42NhOg/M73oeyjYKz+qiwb77GI4aSQMvZV3AKJ2t7TnbQabDcE
 9x4rLIRttpJju0dthPf2CAwqPVpaJlT4r145TSAj+TnUcsdbnwcVj1LL+rU7Dzi+hdzZ vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrf7wus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 10:22:43 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12IE4m1N030079
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 10:22:43 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrf7wu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 10:22:43 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IEICLv014174;
        Thu, 18 Mar 2021 14:22:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 37b30p1pgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 14:22:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IEMcpo3474134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 14:22:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65CE011C04C;
        Thu, 18 Mar 2021 14:22:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 271E311C04A;
        Thu, 18 Mar 2021 14:22:38 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.64.4])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 14:22:38 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 3/6] s390x: lib: css: upgrading IRQ
 handling
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-4-git-send-email-pmorel@linux.ibm.com>
Message-ID: <b1438ee9-2110-cbe9-316b-d3c472045d1a@linux.ibm.com>
Date:   Thu, 18 Mar 2021 15:22:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616073988-10381-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


hum, I just saw I forgot to upgrade the report of the residual count.
This is not really relevant for this series.
Of course I will adapt it for the v2.


On 3/18/21 2:26 PM, Pierre Morel wrote:
> Until now we had very few usage of interrupts, to be able to handle
> several interrupts coming up asynchronously we need to take care
> to save the previous interrupt before handling the next one.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/css.h     |  29 +++++++++++
>   lib/s390x/css_lib.c | 117 ++++++++++++++++++++++++++++++++++----------
>   2 files changed, 120 insertions(+), 26 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 460b0bd..65fc335 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -425,4 +425,33 @@ struct measurement_block_format1 {
>   	uint32_t irq_prio_delay_time;
>   };
>   
> +struct irq_entry {
> +	struct irq_entry *next;
> +	struct irb irb;
> +	uint32_t sid;
> +};
> +
> +struct irq_entry *alloc_irq(void);
> +struct irq_entry *get_irq(void);
> +void put_irq(struct irq_entry *irq);
> +
> +#include <asm/arch_def.h>
> +static inline void disable_io_irq(void)
> +{
> +	uint64_t mask;
> +
> +	mask = extract_psw_mask();
> +	mask &= ~PSW_MASK_IO;
> +	load_psw_mask(mask);
> +}
> +
> +static inline void enable_io_irq(void)
> +{
> +	uint64_t mask;
> +
> +	mask = extract_psw_mask();
> +	mask |= PSW_MASK_IO;
> +	load_psw_mask(mask);
> +}
> +
>   #endif
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index f8db205..211c73c 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -9,6 +9,8 @@
>    */
>   #include <libcflat.h>
>   #include <alloc_phys.h>
> +#include <util.h>
> +#include <alloc.h>
>   #include <asm/page.h>
>   #include <string.h>
>   #include <interrupt.h>
> @@ -22,6 +24,46 @@
>   struct schib schib;
>   struct chsc_scsc *chsc_scsc;
>   
> +static struct irq_entry *irqs;
> +
> +struct irq_entry *get_irq(void)
> +{
> +	struct irq_entry *irq = NULL;
> +
> +	if (irqs) {
> +		irq = irqs;
> +		irqs = irq->next;
> +	}
> +	return irq;
> +}
> +
> +void put_irq(struct irq_entry *irq)
> +{
> +	free(irq);
> +}
> +
> +static void save_irq(struct irq_entry *irq)
> +{
> +	struct irq_entry *e;
> +
> +	if (!irqs) {
> +		irqs = irq;
> +	} else {
> +		e = irqs;
> +		while (e && e->next)
> +			e = e->next;
> +		e->next = irq;
> +	}
> +}
> +
> +struct irq_entry *alloc_irq(void)
> +{
> +	struct irq_entry *irq;
> +
> +	irq = calloc(1, sizeof(*irq));
> +	return irq;
> +}
> +
>   static const char * const chsc_rsp_description[] = {
>   	"CHSC unknown error",
>   	"Command executed",
> @@ -422,38 +464,38 @@ static struct irb irb;
>   void css_irq_io(void)
>   {
>   	int ret = 0;
> -	char *flags;
> -	int sid;
> +	struct irq_entry *irq;
>   
>   	report_prefix_push("Interrupt");
> -	sid = lowcore_ptr->subsys_id_word;
> +	irq = alloc_irq();
> +	assert(irq);
> +
> +	irq->sid = lowcore_ptr->subsys_id_word;
>   	/* Lowlevel set the SID as interrupt parameter. */
> -	if (lowcore_ptr->io_int_param != sid) {
> +	if (lowcore_ptr->io_int_param != irq->sid) {
>   		report(0,
>   		       "io_int_param: %x differs from subsys_id_word: %x",
> -		       lowcore_ptr->io_int_param, sid);
> +		       lowcore_ptr->io_int_param, irq->sid);
>   		goto pop;
>   	}
>   	report_prefix_pop();
>   
>   	report_prefix_push("tsch");
> -	ret = tsch(sid, &irb);
> +	ret = tsch(irq->sid, &irq->irb);
>   	switch (ret) {
>   	case 1:
> -		dump_irb(&irb);
> -		flags = dump_scsw_flags(irb.scsw.ctrl);
> -		report(0,
> -		       "I/O interrupt, but tsch returns CC 1 for subchannel %08x. SCSW flags: %s",
> -		       sid, flags);
> +		report_info("no status pending on %08x : %s", irq->sid,
> +			    dump_scsw_flags(irq->irb.scsw.ctrl));
>   		break;
>   	case 2:
>   		report(0, "tsch returns unexpected CC 2");
>   		break;
>   	case 3:
> -		report(0, "tsch reporting sch %08x as not operational", sid);
> +		report(0, "tsch reporting sch %08x as not operational", irq->sid);
>   		break;
>   	case 0:
>   		/* Stay humble on success */
> +		save_irq(irq);
>   		break;
>   	}
>   pop:
> @@ -498,47 +540,70 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
>   int wait_and_check_io_completion(int schid)
>   {
>   	int ret = 0;
> -
> -	wait_for_interrupt(PSW_MASK_IO);
> +	struct irq_entry *irq = NULL;
>   
>   	report_prefix_push("check I/O completion");
>   
> -	if (lowcore_ptr->io_int_param != schid) {
> +	disable_io_irq();
> +	irq = get_irq();
> +	while (!irq) {
> +		wait_for_interrupt(PSW_MASK_IO);
> +		disable_io_irq();
> +		irq = get_irq();
> +		report_info("next try");
> +	}
> +	enable_io_irq();
> +
> +	assert(irq);
> +
> +	if (irq->sid != schid) {
>   		report(0, "interrupt parameter: expected %08x got %08x",
> -		       schid, lowcore_ptr->io_int_param);
> +		       schid, irq->sid);
>   		ret = -1;
>   		goto end;
>   	}
>   
>   	/* Verify that device status is valid */
> -	if (!(irb.scsw.ctrl & SCSW_SC_PENDING)) {
> -		report(0, "No status pending after interrupt. Subch Ctrl: %08x",
> -		       irb.scsw.ctrl);
> -		ret = -1;
> +	if (!(irq->irb.scsw.ctrl & SCSW_SC_PENDING)) {
> +		ret = 0;
>   		goto end;
>   	}
>   
> -	if (!(irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
> +	/* clear and halt pending are valid even without secondary or primary status */
> +	if (irq->irb.scsw.ctrl & (SCSW_FC_CLEAR | SCSW_FC_HALT)) {
> +		ret = 0;
> +		goto end;
> +	}
> +
> +	/* For start pending we need at least one of primary or secondary status */
> +	if (!(irq->irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
>   		report(0, "Primary or secondary status missing. Subch Ctrl: %08x",
> -		       irb.scsw.ctrl);
> +		       irq->irb.scsw.ctrl);
>   		ret = -1;
>   		goto end;
>   	}
>   
> -	if (!(irb.scsw.dev_stat & (SCSW_DEVS_DEV_END | SCSW_DEVS_SCH_END))) {
> +	/* For start pending we also need to have device or channel end information */
> +	if (!(irq->irb.scsw.dev_stat & (SCSW_DEVS_DEV_END | SCSW_DEVS_SCH_END))) {
>   		report(0, "No device end or sch end. Dev. status: %02x",
> -		       irb.scsw.dev_stat);
> +		       irq->irb.scsw.dev_stat);
>   		ret = -1;
>   		goto end;
>   	}
>   
> -	if (irb.scsw.sch_stat & ~SCSW_SCHS_IL) {
> -		report_info("Unexpected Subch. status %02x", irb.scsw.sch_stat);
> +	/* We only accept the SubCHannel Status for Illegal Length */
> +	if (irq->irb.scsw.sch_stat & ~SCSW_SCHS_IL) {
> +		report_info("Unexpected Subch. status %02x",
> +			    irq->irb.scsw.sch_stat);
>   		ret = -1;
>   		goto end;
>   	}
>   
>   end:
> +	if (ret)
> +		dump_irb(&irq->irb);
> +
> +	put_irq(irq);
>   	report_prefix_pop();
>   	return ret;
>   }
> 

-- 
Pierre Morel
IBM Lab Boeblingen
