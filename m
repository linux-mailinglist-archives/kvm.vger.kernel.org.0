Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF411F3A53
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 14:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgFIMDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 08:03:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726395AbgFIMDL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 08:03:11 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 059C32MO117869;
        Tue, 9 Jun 2020 08:03:10 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31j6c8q502-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 08:03:10 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 059C383H118344;
        Tue, 9 Jun 2020 08:03:08 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31j6c8q4e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 08:03:08 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 059C1NiO030057;
        Tue, 9 Jun 2020 12:02:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 31g2s7wvrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 12:02:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 059C2Q1B54526060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jun 2020 12:02:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1E964C046;
        Tue,  9 Jun 2020 12:02:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CB264C04A;
        Tue,  9 Jun 2020 12:02:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.16.61])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jun 2020 12:02:25 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 12/12] s390x: css: ssch/tsch with sense
 and interrupt
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-13-git-send-email-pmorel@linux.ibm.com>
 <bfae9aa6-5802-dd24-a59f-75291cd5f67a@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <0b1739f1-63ce-9761-9cd9-edadbb6a6070@linux.ibm.com>
Date:   Tue, 9 Jun 2020 14:02:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <bfae9aa6-5802-dd24-a59f-75291cd5f67a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-09_03:2020-06-09,2020-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxscore=0 cotscore=-2147483648 lowpriorityscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 spamscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006090093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-09 10:15, Thomas Huth wrote:
> On 08/06/2020 10.13, Pierre Morel wrote:
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
>>   lib/s390x/css.h     |  20 ++++++
>>   lib/s390x/css_lib.c |  46 ++++++++++++++
>>   s390x/css.c         | 149 +++++++++++++++++++++++++++++++++++++++++++-
>>   3 files changed, 214 insertions(+), 1 deletion(-)
> [...]
>> +}
>> diff --git a/s390x/css.c b/s390x/css.c
>> index 6f58d4a..79c997d 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -16,10 +16,26 @@
>>   #include <string.h>
>>   #include <interrupt.h>
>>   #include <asm/arch_def.h>
>> +#include <kernel-args.h>
>>   
>>   #include <css.h>
>>   
>> +#define DEFAULT_CU_TYPE		0x3832
>> +static unsigned long cu_type = DEFAULT_CU_TYPE;
>> +
>> +struct lowcore *lowcore = (void *)0x0;
>> +
>>   static int test_device_sid;
>> +static struct irb irb;
>> +static struct senseid senseid;
>> +
>> +static void set_io_irq_subclass_mask(uint64_t const new_mask)
>> +{
>> +	asm volatile (
>> +		"lctlg %%c6, %%c6, %[source]\n"
>> +		: /* No outputs */
>> +		: [source] "R" (new_mask));
> 
> I think the "R" constraint is wrong here - this instruction does not use
> an index register. "Q" is likely the better choice. But it might be
> easier to use the lctlg() wrapper from lib/s390x/asm/arch_def.h instead.

OK, yes I do this.

> 
> [...]
>> +
>> +	report((senseid.cu_type == cu_type),
> 
> Please drop the innermost parentheses here.
> 

OK,
Thanks,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
