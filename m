Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461A11FCCD6
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 13:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgFQL4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 07:56:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8202 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725894AbgFQL4A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 07:56:00 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HBY7aa098643;
        Wed, 17 Jun 2020 07:55:58 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6gtm5cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:55:58 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HBkVwU140049;
        Wed, 17 Jun 2020 07:55:57 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6gtm5c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:55:57 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HBpxng023969;
        Wed, 17 Jun 2020 11:55:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 31q6ckrd9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 11:55:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HBtrPD2425106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 11:55:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62F9011C04A;
        Wed, 17 Jun 2020 11:55:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDE4411C04C;
        Wed, 17 Jun 2020 11:55:52 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.186.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 11:55:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 12/12] s390x: css: ssch/tsch with sense
 and interrupt
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-13-git-send-email-pmorel@linux.ibm.com>
 <20200617115442.036735c5.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <2383bdc0-caaf-9cb0-f4c4-ed57c1d3dfb1@linux.ibm.com>
Date:   Wed, 17 Jun 2020 13:55:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617115442.036735c5.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_03:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-17 11:54, Cornelia Huck wrote:
> On Mon, 15 Jun 2020 11:32:01 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> After a channel is enabled we start a SENSE_ID command using
>> the SSCH instruction to recognize the control unit and device.
>>
>> This tests the success of SSCH, the I/O interruption and the TSCH
>> instructions.
>>
>> The SENSE_ID command response is tested to report 0xff inside
>> its reserved field and to report the same control unit type
>> as the cu_type kernel argument.
>>
>> Without the cu_type kernel argument, the test expects a device
>> with a default control unit type of 0x3832, a.k.a virtio-net-ccw.
> 
> 0x3832 is any virtio-ccw device; you could also test for the cu model
> to make sure that it is a net device, but that probably doesn't add
> much additional coverage.
> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  20 +++++++
>>   lib/s390x/css_lib.c |  46 +++++++++++++++
>>   s390x/css.c         | 140 +++++++++++++++++++++++++++++++++++++++++++-
>>   3 files changed, 205 insertions(+), 1 deletion(-)
> 
...snip...

>> +/*
>> + * In the next revisions we will implement the possibility to handle
>> + * CCW chains doing this we will need to work with ccw1 pointers.
> 
> "In the future, we want to implement support for CCW chains; for that,
> we will need to work with ccw1 pointers."
> 
> ?

yes, better, thanks.

> 
>> + * For now we only need a unique CCW.
>> + */
>> +static struct ccw1 unique_ccw;
>> +
>> +int start_subchannel(unsigned int sid, int code, void *data, int count,
>> +		     unsigned char flags)
>> +{
>> +	int cc;
>> +	struct ccw1 *ccw = &unique_ccw;
> 
> Hm... it might better to call this function "start_single_ccw" or
> something like that.

You are right.
I will rework this.
What about differentiating this badly named "start_subchannel()" into:

ccw_setup_ccw(ccw, data, cnt, flgs);
ccw_setup_orb(orb, ccw, flgs)
ccw_start_request(schid, orb);

would be much clearer I think.

> 
>> +
>> +	report_prefix_push("start_subchannel");
>> +	/* Build the CCW chain with a single CCW */
>> +	ccw->code = code;
>> +	ccw->flags = flags; /* No flags need to be set */
>> +	ccw->count = count;
>> +	ccw->data_address = (int)(unsigned long)data;
>> +
>> +	cc = start_ccw1_chain(sid, ccw);
>> +	if (cc) {
>> +		report(0, "start_ccw_chain failed ret=%d", cc);
>> +		report_prefix_pop();
>> +		return cc;
>> +	}
>> +	report_prefix_pop();
>> +	return 0;
>> +}
>> +
>> +int sch_read_len(int sid)
>> +{
>> +	return unique_ccw.count;
>> +}
> 
> This function is very odd... it takes a subchannel id as a parameter,
> which it ignores, and instead returns the count field of the static ccw
> used when starting I/O. What is the purpose of this function? Grab the
> data length for the last I/O operation that was started on the
> subchannel? If yes, it might be better to store that information along
> with the sid? If it is the length for the last I/O operation that the
> code _thinks_ it started, it might be better to reuse that information
> from further up in the function instead.

agreed, I forgot to update this, totally confused.
will rework this.


> 
>> diff --git a/s390x/css.c b/s390x/css.c
>> index 6948d73..6b618a1 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -16,10 +16,18 @@
>>   #include <string.h>
>>   #include <interrupt.h>
>>   #include <asm/arch_def.h>
>> +#include <kernel-args.h>
>>   
>>   #include <css.h>
>>   
>> +#define DEFAULT_CU_TYPE		0x3832
> 
> Maybe append /* virtio-ccw */

yes, thanks

> 
>> +static unsigned long cu_type = DEFAULT_CU_TYPE;
>> +
>> +struct lowcore *lowcore = (void *)0x0;
>> +
>>   static int test_device_sid;
>> +static struct irb irb;
>> +static struct senseid senseid;
>>   
>>   static void test_enumerate(void)
>>   {
>> @@ -45,20 +53,150 @@ static void test_enable(void)
>>   	report(cc == 0, "Enable subchannel %08x", test_device_sid);
>>   }
>>   
>> +static void enable_io_isc(void)
>> +{
>> +	/* Let's enable all ISCs for I/O interrupt */
>> +	lctlg(6, 0x00000000ff000000);
>> +}
>> +
>> +static void irq_io(void)
>> +{
>> +	int ret = 0;
>> +	char *flags;
>> +	int sid;
>> +
>> +	report_prefix_push("Interrupt");
>> +	/* Lowlevel set the SID as interrupt parameter. */
>> +	if (lowcore->io_int_param != test_device_sid) {
>> +		report(0,
>> +		       "Bad io_int_param: %x expected %x",
>> +		       lowcore->io_int_param, test_device_sid);
>> +		goto pop;
>> +	}
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("tsch");
>> +	sid = lowcore->subsys_id_word;
>> +	ret = tsch(sid, &irb);
>> +	switch (ret) {
>> +	case 1:
>> +		dump_irb(&irb);
>> +		flags = dump_scsw_flags(irb.scsw.ctrl);
>> +		report(0,
>> +		       "I/O interrupt, CC 1 but tsch reporting sch %08x as not status pending: %s",
>> +		       sid, flags);
>> +		break;
>> +	case 2:
>> +		report(0, "tsch returns unexpected CC 2");
>> +		break;
>> +	case 3:
>> +		report(0, "tsch reporting sch %08x as not operational", sid);
>> +		break;
>> +	case 0:
>> +		/* Stay humble on success */
>> +		break;
>> +	}
>> +pop:
>> +	report_prefix_pop();
>> +	lowcore->io_old_psw.mask &= ~PSW_MASK_WAIT;
>> +}
>> +
>> +/*
>> + * test_sense
>> + * Pre-requisits:
>> + * - We need the test device as the first recognized
>> + *   device by the enumeration.
>> + */
>> +static void test_sense(void)
>> +{
>> +	int ret;
>> +
>> +	if (!test_device_sid) {
>> +		report_skip("No device");
>> +		return;
>> +	}
>> +
>> +	ret = css_enable(test_device_sid);
>> +	if (ret) {
>> +		report(0,
>> +		       "Could not enable the subchannel: %08x",
>> +		       test_device_sid);
>> +		return;
>> +	}
>> +
>> +	ret = register_io_int_func(irq_io);
>> +	if (ret) {
>> +		report(0, "Could not register IRQ handler");
>> +		goto unreg_cb;
>> +	}
>> +
>> +	lowcore->io_int_param = 0;
>> +
>> +	memset(&senseid, 0, sizeof(senseid));
>> +	ret = start_subchannel(test_device_sid, CCW_CMD_SENSE_ID,
>> +			       &senseid, sizeof(senseid), CCW_F_SLI);
>> +	if (ret) {
>> +		report(0, "ssch failed for SENSE ID on sch %08x with cc %d",
>> +		       test_device_sid, ret);
>> +		goto unreg_cb;
>> +	}
>> +
>> +	wait_for_interrupt(PSW_MASK_IO);
>> +
>> +	ret = sch_read_len(test_device_sid);
>> +	if (ret < CSS_SENSEID_COMMON_LEN) {
>> +		report(0,
>> +		       "ssch succeeded for SENSE ID but report a too short length: %d",
>> +		       ret);
>> +		goto unreg_cb;
>> +	}
> 
> Oh, so you want to check something even different: You know what you
> put in the request, and you expect a certain minimal length back. But
> that length is contained in the scsw, not in the started ccw, isn't it?

yes it is.

> 
>> +
>> +	if (senseid.reserved != 0xff) {
>> +		report(0,
>> +		       "ssch succeeded for SENSE ID but reports garbage: %x",
>> +		       senseid.reserved);
>> +		goto unreg_cb;
>> +	}
>> +
>> +	if (lowcore->io_int_param != test_device_sid)
>> +		goto unreg_cb;
> 
> You probably want to check this further up? But doesn't irq_io()
> already check this?

yes it does

Thanks for the comments,

I will rework this.

- rework the start_subchannel()
- rework the read_len() if we ever need this

Also thinking to put the irq_io routine inside the library, it will be 
reused by other tests.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
