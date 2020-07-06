Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B602157F9
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 15:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgGFNFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 09:05:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2982 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729124AbgGFNFW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jul 2020 09:05:22 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066D5CjR037246;
        Mon, 6 Jul 2020 09:05:20 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 322kcxd6qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 09:05:20 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 066D5Jr9037574;
        Mon, 6 Jul 2020 09:05:19 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 322kcxd6ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 09:05:19 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 066D1l4C003902;
        Mon, 6 Jul 2020 13:01:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 322hd7tard-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 13:01:53 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 066D1phU52560000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jul 2020 13:01:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04A5C52059;
        Mon,  6 Jul 2020 13:01:51 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.49.44])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8682752050;
        Mon,  6 Jul 2020 13:01:50 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v10 9/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        drjones@redhat.com
References: <1593707480-23921-1-git-send-email-pmorel@linux.ibm.com>
 <1593707480-23921-10-git-send-email-pmorel@linux.ibm.com>
 <20200706114655.5088b6b7.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <02eb7a70-7a74-6f09-334f-004e69aaa198@linux.ibm.com>
Date:   Mon, 6 Jul 2020 15:01:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200706114655.5088b6b7.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_09:2020-07-06,2020-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 spamscore=0 cotscore=-2147483648 mlxlogscore=999 mlxscore=0 malwarescore=0
 clxscore=1015 bulkscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007060097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-06 11:46, Cornelia Huck wrote:
> On Thu,  2 Jul 2020 18:31:20 +0200
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
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/asm/arch_def.h |   1 +
>>   lib/s390x/css.h          |  32 ++++++++-
>>   lib/s390x/css_lib.c      | 148 ++++++++++++++++++++++++++++++++++++++-
>>   s390x/css.c              |  94 ++++++++++++++++++++++++-
>>   4 files changed, 272 insertions(+), 3 deletions(-)
> 
> (...)
> 
>> -int css_enable(int schid)
>> +/*
>> + * css_enable: enable Subchannel
>> + * @schid: Subchannel Identifier
>> + * @isc: Interruption subclass for this subchannel as a number
> 
> "number of the interruption subclass to use"?

Yes, thanks.

> 
>> + * Return value:
>> + *   On success: 0
>> + *   On error the CC of the faulty instruction
>> + *      or -1 if the retry count is exceeded.
>> + *
>> + */
>> +int css_enable(int schid, int isc)
>>   {
>>   	struct pmcw *pmcw = &schib.pmcw;
>>   	int retry_count = 0;
>> @@ -92,6 +103,9 @@ retry:
>>   	/* Update the SCHIB to enable the channel */
>>   	pmcw->flags |= PMCW_ENABLE;
>>   
>> +	/* Set Interruption Subclass to IO_SCH_ISC */
> 
> The specified isc, current callers just happen to pass that value.
> 

Forgot to remove this comment. Will do.

>> +	pmcw->flags |= (isc << PMCW_ISC_SHIFT);
>> +
>>   	/* Tell the CSS we want to modify the subchannel */
>>   	cc = msch(schid, &schib);
>>   	if (cc) {
>> @@ -114,6 +128,7 @@ retry:
>>   		return cc;
>>   	}
>>   
>> +	report_info("stsch: flags: %04x", pmcw->flags);
> 
> It feels like all of this already should have been included in the
> previous patch?

Yes, I did not want to modify it since it was reviewed-by.

> 
>>   	if (pmcw->flags & PMCW_ENABLE) {
>>   		report_info("stsch: sch %08x enabled after %d retries",
>>   			    schid, retry_count);
>> @@ -129,3 +144,134 @@ retry:
>>   		    schid, retry_count, pmcw->flags);
>>   	return -1;
>>   }
>> +
>> +static struct irb irb;
>> +
>> +void css_irq_io(void)
>> +{
>> +	int ret = 0;
>> +	char *flags;
>> +	int sid;
>> +
>> +	report_prefix_push("Interrupt");
>> +	sid = lowcore_ptr->subsys_id_word;
>> +	/* Lowlevel set the SID as interrupt parameter. */
>> +	if (lowcore_ptr->io_int_param != sid) {
>> +		report(0,
>> +		       "io_int_param: %x differs from subsys_id_word: %x",
>> +		       lowcore_ptr->io_int_param, sid);
>> +		goto pop;
>> +	}
>> +	report_info("subsys_id_word: %08x io_int_param %08x io_int_word %08x",
>> +			lowcore_ptr->subsys_id_word,
>> +			lowcore_ptr->io_int_param,
>> +			lowcore_ptr->io_int_word);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("tsch");
>> +	ret = tsch(sid, &irb);
>> +	switch (ret) {
>> +	case 1:
>> +		dump_irb(&irb);
>> +		flags = dump_scsw_flags(irb.scsw.ctrl);
>> +		report(0,
>> +		       "I/O interrupt, CC 1 but tsch reporting sch %08x as not status pending: %s",
> 
> "I/O interrupt, but tsch returns CC 1 for subchannel %08x" ?

Yes better, thanks

> 
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
>> +	lowcore_ptr->io_old_psw.mask &= ~PSW_MASK_WAIT;
>> +}
>> +
>> +int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw)
>> +{
>> +	struct orb orb = {
>> +		.intparm = sid,
>> +		.ctrl = ORB_CTRL_ISIC|ORB_CTRL_FMT|ORB_LPM_DFLT,
>> +		.cpa = (unsigned int) (unsigned long)ccw,
>> +	};
>> +
>> +	return ssch(sid, &orb);
>> +}
>> +
>> +/*
>> + * In the future, we want to implement support for CCW chains;
>> + * for that, we will need to work with ccw1 pointers.
>> + */
>> +static struct ccw1 unique_ccw;
>> +
>> +int start_single_ccw(unsigned int sid, int code, void *data, int count,
>> +		     unsigned char flags)
>> +{
>> +	int cc;
>> +	struct ccw1 *ccw = &unique_ccw;
>> +
>> +	report_prefix_push("start_subchannel");
>> +	/* Build the CCW chain with a single CCW */
>> +	ccw->code = code;
>> +	ccw->flags = flags; /* No flags need to be set */
> 
> s/No flags/No additional flags/

obviously :)

> 
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
>> +/*
>> + * css_residual_count
>> + * We expect no residual count when the ORB request was successful
> 
> If we have a short block, but have suppressed the incorrect length
> indication, we may have a successful request with a nonzero count.
> Maybe replace this with "Return the residual count, if it is valid."?


OK

> 
>> + * The residual count is valid when the subchannel is status pending
>> + * with primary status and device status only or device status and
>> + * subchannel status with PCI or incorrect length.
>> + * Return value:
>> + * Success: the residual count
>> + * Not meaningful: -1 (-1 can not be a valid count)
>> + */
>> +int css_residual_count(unsigned int schid)
>> +{
>> +
>> +	if (!(irb.scsw.ctrl & (SCSW_SC_PENDING | SCSW_SC_PRIMARY)))
>> +		goto fail;
> 
> s/fail/invalid/ ? It's not really a failure :)

yes

> 
>> +
>> +	if (irb.scsw.dev_stat)
>> +		if (irb.scsw.sch_stat & ~(SCSW_SCHS_PCI | SCSW_SCHS_IL))
>> +			goto fail;
>> +
>> +	return irb.scsw.count;
>> +
>> +fail:
>> +	report_info("sch  status %02x", irb.scsw.sch_stat);
>> +	report_info("dev  status %02x", irb.scsw.dev_stat);
>> +	report_info("ctrl status %08x", irb.scsw.ctrl);
>> +	report_info("count       %04x", irb.scsw.count);
>> +	report_info("ccw addr    %08x", irb.scsw.ccw_addr);
> 
> I don't understand why you dump this data if no valid residual count is
> available. But maybe I don't understand the purpose of this function
> correctly.

As debug information to facilitate the search why the function failed.
Would you prefer more accurate report_info inside the if tests?
or just return with error code?

> 

>>   
>> +/*
>> + * test_sense
>> + * Pre-requisits:
> 
> s/Pre-requisists/Pre-requisites/

OK

> 
>> + * - We need the test device as the first recognized
>> + *   device by the enumeration.
>> + */
>> +static void test_sense(void)
>> +{
>> +	int ret;
>> +	int len;
>> +
>> +	if (!test_device_sid) {
>> +		report_skip("No device");
>> +		return;
>> +	}
>> +
>> +	ret = css_enable(test_device_sid, IO_SCH_ISC);
>> +	if (ret) {
>> +		report(0,
>> +		       "Could not enable the subchannel: %08x",
>> +		       test_device_sid);
>> +		return;
>> +	}
>> +
>> +	ret = register_io_int_func(css_irq_io);
>> +	if (ret) {
>> +		report(0, "Could not register IRQ handler");
>> +		goto unreg_cb;
>> +	}
>> +
>> +	lowcore_ptr->io_int_param = 0;
>> +
>> +	memset(&senseid, 0, sizeof(senseid));
>> +	ret = start_single_ccw(test_device_sid, CCW_CMD_SENSE_ID,
>> +			       &senseid, sizeof(senseid), CCW_F_SLI);
>> +	if (ret) {
>> +		report(0, "ssch failed for SENSE ID on sch %08x with cc %d",
>> +		       test_device_sid, ret);
>> +		goto unreg_cb;
>> +	}
>> +
>> +	wait_for_interrupt(PSW_MASK_IO);
>> +
>> +	if (lowcore_ptr->io_int_param != test_device_sid) {
>> +		report(0, "ssch succeeded but interrupt parameter is wrong: expect %08x got %08x",
>> +		       test_device_sid, lowcore_ptr->io_int_param);
>> +		goto unreg_cb;
>> +	}
>> +
>> +	ret = css_residual_count(test_device_sid);
>> +	if (ret < 0) {
>> +		report(0, "ssch succeeded for SENSE ID but can not get a valid residual count");
>> +		goto unreg_cb;
>> +	}
> 
> I'm not sure what you're testing here. You should first test whether
> the I/O concluded normally (i.e., whether you actually get something
> like status pending with channel end/device end). If not, it does not
> make much sense to look either at the residual count or at the sense id
> data.
> 
> If css_residual_count does not return something >= 0 for that 'normal'
> case, something is definitely fishy, though :)

I will add the test before the call to get the residual count.
May be it leads to rework the css_residual_count too.

> 
>> +
>> +	len = sizeof(senseid) - ret;
>> +	if (ret && len < CSS_SENSEID_COMMON_LEN) {
>> +		report(0,
>> +		       "ssch succeeded for SENSE ID but report a too short length: %d",
> 
> s/report/transferred/ ?

OK

> 
>> +		       ret);
>> +		goto unreg_cb;
>> +	}
>> +
>> +	if (ret && len)
>> +		report_info("ssch succeeded for SENSE ID but report a shorter length: %d",
> 
> Same here.

OK

snip...


Thanks for review.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
