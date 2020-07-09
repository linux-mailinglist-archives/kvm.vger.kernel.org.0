Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B8921A09E
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 15:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGINSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 09:18:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726376AbgGINSb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 09:18:31 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069D21Y9125719;
        Thu, 9 Jul 2020 09:18:31 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32637w9jxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 09:18:31 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 069D2WLb127986;
        Thu, 9 Jul 2020 09:18:30 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32637w9jws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 09:18:30 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 069DEXno011694;
        Thu, 9 Jul 2020 13:18:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 325k230frh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 13:18:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 069DH42V55181590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 13:17:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C81BAE053;
        Thu,  9 Jul 2020 13:18:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2EA8AE045;
        Thu,  9 Jul 2020 13:18:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.34.67])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 13:18:25 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v11 9/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        drjones@redhat.com
References: <1594282068-11054-1-git-send-email-pmorel@linux.ibm.com>
 <1594282068-11054-10-git-send-email-pmorel@linux.ibm.com>
 <20200709141348.6ae5ff18.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <9aba6196-edd4-4eb0-1e1c-e6410291863b@linux.ibm.com>
Date:   Thu, 9 Jul 2020 15:18:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709141348.6ae5ff18.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_07:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 priorityscore=1501 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007090097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-09 14:13, Cornelia Huck wrote:
> On Thu,  9 Jul 2020 10:07:48 +0200
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
>>   lib/s390x/css.h          |  35 ++++++++
>>   lib/s390x/css_lib.c      | 183 +++++++++++++++++++++++++++++++++++++++
>>   s390x/css.c              |  80 +++++++++++++++++
>>   4 files changed, 299 insertions(+)
> 
> (...)
> 
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index eda68a4..c64edd5 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -16,6 +16,7 @@
>>   #include <interrupt.h>
>>   #include <asm/arch_def.h>
>>   #include <asm/time.h>
>> +#include <asm/arch_def.h>
>>   
>>   #include <css.h>
>>   
>> @@ -103,6 +104,9 @@ retry:
>>   	/* Update the SCHIB to enable the channel and set the ISC */
>>   	pmcw->flags |= flags;
>>   
>> +	/* Set Interruption Subclass to IO_SCH_ISC */
>> +	pmcw->flags |= (isc << PMCW_ISC_SHIFT);
> 
> But isn't the isc already contained in 'flags'? I think you should just
> delete these two lines.

right.

> 
>> +
>>   	/* Tell the CSS we want to modify the subchannel */
>>   	cc = msch(schid, &schib);
>>   	if (cc) {
> 
> (...)
> 
>> +/* wait_and_check_io_completion:
>> + * @schid: the subchannel ID
>> + *
>> + * Makes the most common check to validate a successful I/O
>> + * completion.
>> + * Only report failures.
>> + */
>> +int wait_and_check_io_completion(int schid)
>> +{
>> +	int ret = 0;
>> +
>> +	wait_for_interrupt(PSW_MASK_IO);
>> +
>> +	report_prefix_push("check I/O completion");
>> +
>> +	if (lowcore_ptr->io_int_param != schid) {
>> +		report(0, "interrupt parameter: expected %08x got %08x",
>> +		       schid, lowcore_ptr->io_int_param);
>> +		ret = -1;
>> +		goto end;
>> +	}
>> +
>> +	/* Verify that device status is valid */
>> +	if (!(irb.scsw.ctrl & SCSW_SC_PENDING)) {
>> +		report(0, "No status pending after interrupt. Subch Ctrl: %08x",
>> +		       irb.scsw.ctrl);
>> +		ret = -1;
>> +		goto end;
>> +	}
>> +
>> +	if (!(irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
>> +		report(0, "Primary or secondary status missing. Subch Ctrl: %08x",
>> +		       irb.scsw.ctrl);
>> +		ret = -1;
>> +		goto end;
>> +	}
>> +
>> +	if (!(irb.scsw.dev_stat & (SCSW_DEVS_DEV_END | SCSW_DEVS_SCH_END))) {
>> +		report(0, "No device end nor sch end. Dev. status: %02x",
> 
> s/nor/or/ ?

OK

> 
>> +		       irb.scsw.dev_stat);
>> +		ret = -1;
>> +		goto end;
>> +	}
>> +
>> +	if (irb.scsw.sch_stat & !(SCSW_SCHS_PCI | SCSW_SCHS_IL)) {
> 
> Did you mean ~(SCSW_SCHS_PCI | SCSW_SCHS_IL)?

grrr... yes, thanks.

> 
> If yes, why do think a PCI may show up?

Should not in the current implementation.
I thought I can add it as a general test.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
