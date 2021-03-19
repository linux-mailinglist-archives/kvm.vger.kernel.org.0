Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753D6342154
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 16:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCSPzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 11:55:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230108AbhCSPzW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 11:55:22 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JFWejF038656
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 11:55:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tV+KV3HxSU9EH4zWpvFMPXPip5c9D/u/REAcR3jU4Hg=;
 b=JPU1ou8ihqd0jM2xqtTRwG71m6Qdv4CF9seX4tHukbhPN1fnrBAXtGNXffEmUVCA4AMf
 mOvDprggN1ySKMAlWZXFLW5yHeoxylLcxBT9baOMunJwBOSYNL+8XglfLGsfEDXnlSF/
 rqUyQbQZXSpyCluyqVNalPGSw5MRAEUxUDTug8d6wwdskiNDCuPAJhqU8Y9FCZOk6/os
 AkPdzyn6bvGJP5hjZbco57sN9jQMWirEhnejOmUMPEolV+K9JHLICparQivmr/FWI5LU
 JNbh74htRaGWCJRnmvrMdRZtMHrDCfExlIwA+XaWcQKu4Sh1D6ppYNo+wr4HNyax+2SX YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c19a2qvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 11:55:21 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12JFWton040009
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 11:55:21 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c19a2quy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 11:55:21 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JFbZB4024237;
        Fri, 19 Mar 2021 15:55:19 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 378n18b4et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 15:55:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JFtG7w29032846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 15:55:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 858A3A404D;
        Fri, 19 Mar 2021 15:55:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1738A4053;
        Fri, 19 Mar 2021 15:55:15 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.3.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 15:55:15 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 3/6] s390x: lib: css: upgrading IRQ
 handling
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-4-git-send-email-pmorel@linux.ibm.com>
 <20210319120105.182c8684.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <d5e2e4cf-8f76-2099-f0d6-edcb32696bf2@linux.ibm.com>
Date:   Fri, 19 Mar 2021 16:55:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210319120105.182c8684.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_06:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103190109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/21 12:01 PM, Cornelia Huck wrote:
> On Thu, 18 Mar 2021 14:26:25 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Until now we had very few usage of interrupts, to be able to handle
>> several interrupts coming up asynchronously we need to take care
>> to save the previous interrupt before handling the next one.
> 
> An alternative would be to keep I/O interrupts disabled until you are
> done with processing any information that might be overwritten.
> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  29 +++++++++++
>>   lib/s390x/css_lib.c | 117 ++++++++++++++++++++++++++++++++++----------
>>   2 files changed, 120 insertions(+), 26 deletions(-)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 460b0bd..65fc335 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -425,4 +425,33 @@ struct measurement_block_format1 {
>>   	uint32_t irq_prio_delay_time;
>>   };
>>   
>> +struct irq_entry {
>> +	struct irq_entry *next;
>> +	struct irb irb;
>> +	uint32_t sid;
> 
> I'm wondering whether that set of information make sense for saving.
> 
> We basically have some things in the lowcore that get overwritten by
> subsequent I/O interrupts (in addition to the sid the intparm and the
> interrupt identification word which contains the isc), and the irb,
> which only gets overwritten if you do a tsch into the same memory area.
> So, if you need to save some things, I'd suggest to add the intparm and
> the interrupt identification word to it. Not sure whether the irb can
> be handled independently? Need to read code first :)

That is right.
I only saved what I needed for the moment.

> 
>> +};
> 
> (...)
> 
>> @@ -422,38 +464,38 @@ static struct irb irb;
>>   void css_irq_io(void)
>>   {
>>   	int ret = 0;
>> -	char *flags;
>> -	int sid;
>> +	struct irq_entry *irq;
>>   
>>   	report_prefix_push("Interrupt");
>> -	sid = lowcore_ptr->subsys_id_word;
>> +	irq = alloc_irq();
>> +	assert(irq);
>> +
>> +	irq->sid = lowcore_ptr->subsys_id_word;
>>   	/* Lowlevel set the SID as interrupt parameter. */
>> -	if (lowcore_ptr->io_int_param != sid) {
>> +	if (lowcore_ptr->io_int_param != irq->sid) {
>>   		report(0,
>>   		       "io_int_param: %x differs from subsys_id_word: %x",
>> -		       lowcore_ptr->io_int_param, sid);
>> +		       lowcore_ptr->io_int_param, irq->sid);
>>   		goto pop;
>>   	}
>>   	report_prefix_pop();
>>   
>>   	report_prefix_push("tsch");
>> -	ret = tsch(sid, &irb);
>> +	ret = tsch(irq->sid, &irq->irb);
>>   	switch (ret) {
>>   	case 1:
>> -		dump_irb(&irb);
>> -		flags = dump_scsw_flags(irb.scsw.ctrl);
>> -		report(0,
>> -		       "I/O interrupt, but tsch returns CC 1 for subchannel %08x. SCSW flags: %s",
>> -		       sid, flags);
>> +		report_info("no status pending on %08x : %s", irq->sid,
>> +			    dump_scsw_flags(irq->irb.scsw.ctrl));
> 
> This is not what you are looking at here, though?
> 
> The problem is that the hypervisor gave you cc 1 (stored, not status
> pending) while you just got an interrupt; the previous message logged
> that, while the new one does not. (The scsw flags are still
> interesting, as it gives further information about the mismatch.)

I can keep the old message.
How ever I do not think it is a reason to report a failure.
Do you agree with replaacing report(0,) with report_info()

> 
>>   		break;
>>   	case 2:
>>   		report(0, "tsch returns unexpected CC 2");
>>   		break;
>>   	case 3:
>> -		report(0, "tsch reporting sch %08x as not operational", sid);
>> +		report(0, "tsch reporting sch %08x as not operational", irq->sid);
>>   		break;
>>   	case 0:
>>   		/* Stay humble on success */
>> +		save_irq(irq);
>>   		break;
>>   	}
>>   pop:
>> @@ -498,47 +540,70 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
>>   int wait_and_check_io_completion(int schid)
>>   {
>>   	int ret = 0;
>> -
>> -	wait_for_interrupt(PSW_MASK_IO);
>> +	struct irq_entry *irq = NULL;
>>   
>>   	report_prefix_push("check I/O completion");
>>   
>> -	if (lowcore_ptr->io_int_param != schid) {
>> +	disable_io_irq();
>> +	irq = get_irq();
>> +	while (!irq) {
>> +		wait_for_interrupt(PSW_MASK_IO);
>> +		disable_io_irq();
> 
> Isn't the disable_io_irq() redundant here?

No because wait for interrupt re-enable the interrupts
I will add a comment

> 
> (In general, I'm a bit confused about the I/O interrupt handling here.
> Might need to read through the whole thing again.)
> 
>> +		irq = get_irq();
>> +		report_info("next try");
>> +	}
>> +	enable_io_irq();
>> +
>> +	assert(irq);
>> +
>> +	if (irq->sid != schid) {
>>   		report(0, "interrupt parameter: expected %08x got %08x",
>> -		       schid, lowcore_ptr->io_int_param);
>> +		       schid, irq->sid);
>>   		ret = -1;
>>   		goto end;
> 
> You're still expecting that there's only one subchannel enabled for I/O
> interrupts at the same time, right?

Yes, I plan to introduce multiple channels later.

> 
>>   	}
>>   
>>   	/* Verify that device status is valid */
>> -	if (!(irb.scsw.ctrl & SCSW_SC_PENDING)) {
>> -		report(0, "No status pending after interrupt. Subch Ctrl: %08x",
>> -		       irb.scsw.ctrl);
>> -		ret = -1;
>> +	if (!(irq->irb.scsw.ctrl & SCSW_SC_PENDING)) {
> 
> Confused. An I/O interrupt for a subchannel that is not status pending
> is surely an issue?
> 
>> +		ret = 0;
>>   		goto end;
>>   	}
>>   
>> -	if (!(irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
>> +	/* clear and halt pending are valid even without secondary or primary status */
>> +	if (irq->irb.scsw.ctrl & (SCSW_FC_CLEAR | SCSW_FC_HALT)) {
> 
> Can you factor out the new/changed checks here into a separate patch?
> Would make the change easier to follow.

yes, these changes should not belong here.
I will rewrite this all

> 
> Also, you might want to check other things for halt/clear as well?

Yes in a further patch

> 
>> +		ret = 0;
>> +		goto end;
>> +	}
>> +
>> +	/* For start pending we need at least one of primary or secondary status */
>> +	if (!(irq->irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
>>   		report(0, "Primary or secondary status missing. Subch Ctrl: %08x",
>> -		       irb.scsw.ctrl);
>> +		       irq->irb.scsw.ctrl);
> 
> I'm wondering whether that is actually true. Maybe need to double check
> what happens with deferred ccs etc.

Yes,

> 
>>   		ret = -1;
>>   		goto end;
>>   	}
>>   
>> -	if (!(irb.scsw.dev_stat & (SCSW_DEVS_DEV_END | SCSW_DEVS_SCH_END))) {
>> +	/* For start pending we also need to have device or channel end information */
>> +	if (!(irq->irb.scsw.dev_stat & (SCSW_DEVS_DEV_END | SCSW_DEVS_SCH_END))) {
>>   		report(0, "No device end or sch end. Dev. status: %02x",
>> -		       irb.scsw.dev_stat);
>> +		       irq->irb.scsw.dev_stat);
> 
> Again, not sure whether that is true in any case (surely for the good
> path, and I think for unit check as well; but ISTR that there can be
> error conditions where we won't get another interrupt for the same I/O,
> but device end is not set, because the error occurred before we even
> reached the device... should those be logged?)

surely

> 
>>   		ret = -1;
>>   		goto end;
>>   	}
>>   
>> -	if (irb.scsw.sch_stat & ~SCSW_SCHS_IL) {
>> -		report_info("Unexpected Subch. status %02x", irb.scsw.sch_stat);
>> +	/* We only accept the SubCHannel Status for Illegal Length */
> 
> It's more like that we just don't deal with any of the other subchannel
> status flags, right?

OK, I will rework this completely
Thanks for the comment,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
