Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC6F1EF239
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 09:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgFEHhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 03:37:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725280AbgFEHhp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 03:37:45 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0557XGkS100379;
        Fri, 5 Jun 2020 03:37:45 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fgkkthde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 03:37:45 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0557Y104103692;
        Fri, 5 Jun 2020 03:37:45 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fgkkthcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 03:37:44 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0557Zx91020606;
        Fri, 5 Jun 2020 07:37:42 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 31f2q40jjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 07:37:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0557be6A65339882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 07:37:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 309294C050;
        Fri,  5 Jun 2020 07:37:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8ABA4C044;
        Fri,  5 Jun 2020 07:37:39 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.68.25])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 07:37:39 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v7 11/12] s390x: css: ssch/tsch with sense
 and interrupt
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-12-git-send-email-pmorel@linux.ibm.com>
 <20200527120905.5fb20a4e.cohuck@redhat.com>
Message-ID: <a53f84e9-8e32-2ac2-2af1-0edd911841c4@linux.ibm.com>
Date:   Fri, 5 Jun 2020 09:37:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527120905.5fb20a4e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_01:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 bulkscore=0 cotscore=-2147483648
 malwarescore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006050057
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-27 12:09, Cornelia Huck wrote:
> On Mon, 18 May 2020 18:07:30 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We add a new css_lib file to contain the I/O functions we may
>> share with different tests.
>> First function is the subchannel_enable() function.
>>
>> When a channel is enabled we can start a SENSE_ID command using
>> the SSCH instruction to recognize the control unit and device.
>>
>> This tests the success of SSCH, the I/O interruption and the TSCH
>> instructions.
>>
>> The test expects a device with a control unit type of 0xC0CA as the
>> first subchannel of the CSS.
> 
> It might make sense to extend this to be able to check for any expected
> type (e.g. 0x3832, should my suggestion to split css tests and css-pong
> tests make sense.)

right.

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  20 ++++++
>>   lib/s390x/css_lib.c |  55 +++++++++++++++++
>>   s390x/Makefile      |   1 +
>>   s390x/css.c         | 145 ++++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 221 insertions(+)
>>   create mode 100644 lib/s390x/css_lib.c
> 
> (...)
> 
>> +int enable_subchannel(unsigned int sid)
>> +{
>> +	struct schib schib;
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int try_count = 5;
>> +	int cc;
>> +
>> +	if (!(sid & SID_ONE))
>> +		return -1;
> 
> Hm... this error is indistinguishable for the caller from a cc 1 for
> the msch. Use something else (as this is a coding error)?

right it is a coding error -> assert ?

> 
>> +
>> +	cc = stsch(sid, &schib);
>> +	if (cc)
>> +		return -cc;
>> +
>> +	do {
>> +		pmcw->flags |= PMCW_ENABLE;
>> +
>> +		cc = msch(sid, &schib);
>> +		if (cc)
>> +			return -cc;
>> +
>> +		cc = stsch(sid, &schib);
>> +		if (cc)
>> +			return -cc;
>> +
>> +	} while (!(pmcw->flags & PMCW_ENABLE) && --try_count);
>> +
>> +	return try_count;
> 
> How useful is that information for the caller? I don't see the code
> below making use of it.

right,
I will change the fail cases to a report_info and return 0 in case of 
success.

> 
>> +}
>> +
>> +int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw)
>> +{
>> +	struct orb orb;
>> +
>> +	orb.intparm = sid;
> 
> Just an idea: If you use something else here (maybe the cpa), and set
> the intparm to the sid in msch, you can test something else: Does msch
> properly set the intparm, and is that intparm overwritten by a
> successful ssch, until the next ssch or msch comes around?

good idea.
Using cpa is all what we need at the current development.


> 
>> +	orb.ctrl = ORB_F_INIT_IRQ|ORB_F_FORMAT|ORB_F_LPM_DFLT;
>> +	orb.cpa = (unsigned int) (unsigned long)ccw;
> 
> Use a struct initializer, so that unset fields are 0?

not only more beautifull but effective. thanks!

> 
>> +
>> +	return ssch(sid, &orb);
>> +}
> 
> (...)
> 
>> +/*
>> + * test_sense
>> + * Pre-requisits:
>> + * - We need the QEMU PONG device as the first recognized
>> + *   device by the enumeration.
>> + * - ./s390x-run s390x/css.elf -device ccw-pong,cu_type=0xc0ca
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
>> +	ret = enable_subchannel(test_device_sid);
>> +	if (ret < 0) {
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
>> +	ret = start_subchannel(CCW_CMD_SENSE_ID, &senseid, sizeof(senseid),
>> +			       CCW_F_SLI);
> 
> Clear senseid, before actually sending the program?

yes.

> 
>> +	if (!ret) {
>> +		report(0, "ssch failed for SENSE ID on sch %08x",
>> +		       test_device_sid);
>> +		goto unreg_cb;
>> +	}
>> +
>> +	wait_for_interrupt(PSW_MASK_IO);
>> +
>> +	if (lowcore->io_int_param != test_device_sid)
>> +		goto unreg_cb;
>> +
>> +	report_info("reserved %02x cu_type %04x cu_model %02x dev_type %04x dev_model %02x",
>> +		    senseid.reserved, senseid.cu_type, senseid.cu_model,
>> +		    senseid.dev_type, senseid.dev_model);
>> +
> 
> I'd also recommend checking that senseid.reserved is indeed 0xff -- in
> combination with senseid clearing before the ssch, that ensures that
> the senseid structure has actually been written to and is not pure
> garbage. (It's also a cu type agnostic test :)

good idea, thanks.

> 
> It also might make sense to check how much data you actually got, as
> you set SLI.
> 
> 

Yes, will do.

Thanks for the comments, I make the changes for the next revision.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
