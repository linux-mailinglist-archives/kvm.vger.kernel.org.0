Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397A23421FC
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhCSQeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:34:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230186AbhCSQeL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 12:34:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JGXEGa061988
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 12:34:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZZ8SV8iYmJZKUaeLILsejeIKLPfijm6zW5QRQZpq8n0=;
 b=M0wNOdgyy+JsAQhdbS1Kss0bR/txHEoB8zr2DmEo647Vv3Mn9bB8SIf3dH9HwDJxfjs7
 hzjHy5pWfHuv7bQa9bq14F7vUj8LBoM19hVzBIltx81o8Zbfdx8ApkR4O0hcjxnQibjP
 t4O1gY08/6JwYTSWdMe7EfC1H/uNYoqwLTC2mEEUWo3T3CYGs7V0buUZh58r2KctbQZ8
 H5LN8i5ZfPBNhre3hyjJjLt1ee5dqe5UanDdQerz+CP7hZgDCeFq7d3YQD16qA/XWSOc
 +dgco4FeASXM0kotS07a7i4XqkxW5FrsLHoC6mWExJOdFc+h451roYJLXhOv68379pLX mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37byr4kac1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 12:34:10 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12JGXU3W063009
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 12:34:10 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37byr4kab3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 12:34:09 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JGXWA9008941;
        Fri, 19 Mar 2021 16:34:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 378n18b4n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 16:34:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JGY4h837945706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 16:34:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6F284203F;
        Fri, 19 Mar 2021 16:34:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E0C242041;
        Fri, 19 Mar 2021 16:34:04 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.3.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 16:34:04 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 3/6] s390x: lib: css: upgrading IRQ
 handling
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-4-git-send-email-pmorel@linux.ibm.com>
 <20210319120105.182c8684.cohuck@redhat.com>
 <d5e2e4cf-8f76-2099-f0d6-edcb32696bf2@linux.ibm.com>
 <20210319170919.172ee8d5.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ba363893-e88c-f22f-cc91-e06ce804ad1e@linux.ibm.com>
Date:   Fri, 19 Mar 2021 17:34:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210319170919.172ee8d5.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_06:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/21 5:09 PM, Cornelia Huck wrote:
> On Fri, 19 Mar 2021 16:55:15 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 3/19/21 12:01 PM, Cornelia Huck wrote:
>>> On Thu, 18 Mar 2021 14:26:25 +0100
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>>>> @@ -422,38 +464,38 @@ static struct irb irb;
>>>>    void css_irq_io(void)
>>>>    {
>>>>    	int ret = 0;
>>>> -	char *flags;
>>>> -	int sid;
>>>> +	struct irq_entry *irq;
>>>>    
>>>>    	report_prefix_push("Interrupt");
>>>> -	sid = lowcore_ptr->subsys_id_word;
>>>> +	irq = alloc_irq();
>>>> +	assert(irq);
>>>> +
>>>> +	irq->sid = lowcore_ptr->subsys_id_word;
>>>>    	/* Lowlevel set the SID as interrupt parameter. */
>>>> -	if (lowcore_ptr->io_int_param != sid) {
>>>> +	if (lowcore_ptr->io_int_param != irq->sid) {
>>>>    		report(0,
>>>>    		       "io_int_param: %x differs from subsys_id_word: %x",
>>>> -		       lowcore_ptr->io_int_param, sid);
>>>> +		       lowcore_ptr->io_int_param, irq->sid);
>>>>    		goto pop;
>>>>    	}
>>>>    	report_prefix_pop();
>>>>    
>>>>    	report_prefix_push("tsch");
>>>> -	ret = tsch(sid, &irb);
>>>> +	ret = tsch(irq->sid, &irq->irb);
>>>>    	switch (ret) {
>>>>    	case 1:
>>>> -		dump_irb(&irb);
>>>> -		flags = dump_scsw_flags(irb.scsw.ctrl);
>>>> -		report(0,
>>>> -		       "I/O interrupt, but tsch returns CC 1 for subchannel %08x. SCSW flags: %s",
>>>> -		       sid, flags);
>>>> +		report_info("no status pending on %08x : %s", irq->sid,
>>>> +			    dump_scsw_flags(irq->irb.scsw.ctrl));
>>>
>>> This is not what you are looking at here, though?
>>>
>>> The problem is that the hypervisor gave you cc 1 (stored, not status
>>> pending) while you just got an interrupt; the previous message logged
>>> that, while the new one does not. (The scsw flags are still
>>> interesting, as it gives further information about the mismatch.)
>>
>> I can keep the old message.
>> How ever I do not think it is a reason to report a failure.
>> Do you agree with replaacing report(0,) with report_info()
> 
> I don't really see how we could get an I/O interrupt for a subchannel
> that is not status pending, unless we have other code racing with this
> one that cleared the status pending already (and that would be a bug in
> our test program.) Or are you aware in anything in the architecture
> that could make the status pending go away again (other than the
> subchannel becoming not operational?)

:) no
I really messed up with this patch.
sorry, can only do better


> 
>>
>>>    
>>>>    		break;
>>>>    	case 2:
>>>>    		report(0, "tsch returns unexpected CC 2");
>>>>    		break;
>>>>    	case 3:
>>>> -		report(0, "tsch reporting sch %08x as not operational", sid);
>>>> +		report(0, "tsch reporting sch %08x as not operational", irq->sid);
>>>>    		break;
>>>>    	case 0:
>>>>    		/* Stay humble on success */
>>>> +		save_irq(irq);
>>>>    		break;
>>>>    	}
>>>>    pop:
>>>> @@ -498,47 +540,70 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
>>>>    int wait_and_check_io_completion(int schid)
>>>>    {
>>>>    	int ret = 0;
>>>> -
>>>> -	wait_for_interrupt(PSW_MASK_IO);
>>>> +	struct irq_entry *irq = NULL;
>>>>    
>>>>    	report_prefix_push("check I/O completion");
>>>>    
>>>> -	if (lowcore_ptr->io_int_param != schid) {
>>>> +	disable_io_irq();
>>>> +	irq = get_irq();
>>>> +	while (!irq) {
>>>> +		wait_for_interrupt(PSW_MASK_IO);
>>>> +		disable_io_irq();
>>>
>>> Isn't the disable_io_irq() redundant here?
>>
>> No because wait for interrupt re-enable the interrupts
>> I will add a comment
> 
> Hm, I thought it restored the previous status.
> 
>>
>>>
>>> (In general, I'm a bit confused about the I/O interrupt handling here.
>>> Might need to read through the whole thing again.)
> 
> But also see this comment :)
> 

Oh you mean the comment were it restores the psw mask.
yes,I see it now.
hum
yes, this patch is awful. really sorry

please do not lose more time I must really rework the all series.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
