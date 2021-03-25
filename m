Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C897D3497D8
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 18:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhCYRXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 13:23:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229900AbhCYRXM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 13:23:12 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PH4apF054791
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 13:23:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SCbDKg8eSaiGFtlR8qOPpiAKZYZXZrUvJrPfqYXx3II=;
 b=Yg4cjkNdKYD3EHeLe/GgOZ29vGZMbevcE5BzGpdbytdGAUek9XWQv3P1nqUAiwWFiNl8
 KBne4VEw4R2qHJn6p9T/yZ8Hwm4uavc3/g7npYt3riuU3wB3qXKnQoD42leOVucZXbSm
 EXQpMJd+iCexrCt6rJ94KYNCCwqm2P8JKblGgaaU1oIlvIpZxSdWP9u3mKQ/X4w1grW5
 L9TSttnO/C96ohGTuztcECcMINonZTv1D/kM6rakVkBrphMov4JJ7IBebqpwcWTf2Ee6
 yW7oSk2sH8BhkAn4Wkp8KvSANPc1QHT2Ti6XLQXM/3BbuCrX1rPqD45Tjb+8W4vwaEqL Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37guxhwvd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 13:23:09 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PH8EwD073163
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 13:23:08 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37guxhwvcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 13:23:08 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PHJVGU029088;
        Thu, 25 Mar 2021 17:23:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 37d99rdk27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 17:23:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PHMjTo19792258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 17:22:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2A5511C05C;
        Thu, 25 Mar 2021 17:23:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B61C511C054;
        Thu, 25 Mar 2021 17:23:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 17:23:03 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 6/8] s390x: css: testing ssch error
 response
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-7-git-send-email-pmorel@linux.ibm.com>
 <20210325170257.2e753967@ibm-vm>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <2e1c410d-3c97-e169-903f-a3a5ac7cdcec@linux.ibm.com>
Date:   Thu, 25 Mar 2021 18:23:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325170257.2e753967@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_05:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 5:02 PM, Claudio Imbrenda wrote:
> On Thu, 25 Mar 2021 10:39:05 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Checking error response on various eroneous SSCH instructions:
>> - ORB alignment
>> - ORB above 2G
>> - CCW above 2G
>> - bad ORB flags
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |   4 ++
>>   lib/s390x/css_lib.c |   5 +--
>>   s390x/css.c         | 105
>> ++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 111
>> insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 1603781..e1e9264 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -90,6 +90,9 @@ struct scsw {
>>   #define SCSW_ESW_FORMAT		0x04000000
>>   #define SCSW_SUSPEND_CTRL	0x08000000
>>   #define SCSW_KEY		0xf0000000
>> +#define SCSW_SSCH_COMPLETED	(SCSW_CCW_FORMAT | SCSW_FC_START
>> | \
>> +				 SCSW_SC_PENDING | SCSW_SC_SECONDARY
>> | \
>> +				 SCSW_SC_PRIMARY)
>>   	uint32_t ctrl;
>>   	uint32_t ccw_addr;
>>   #define SCSW_DEVS_DEV_END	0x04
>> @@ -138,6 +141,7 @@ struct irb {
>>   	uint32_t ecw[8];
>>   	uint32_t emw[8];
>>   } __attribute__ ((aligned(4)));
>> +extern struct irb irb;
>>   
>>   #define CCW_CMD_SENSE_ID	0xe4
>>   #define CSS_SENSEID_COMMON_LEN	8
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 55e70e6..7c93e94 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -21,6 +21,7 @@
>>   
>>   struct schib schib;
>>   struct chsc_scsc *chsc_scsc;
>> +struct irb irb;
>>   
>>   static const char * const chsc_rsp_description[] = {
>>   	"CHSC unknown error",
>> @@ -415,8 +416,6 @@ bool css_disable_mb(int schid)
>>   	return retry_count > 0;
>>   }
>>   
>> -static struct irb irb;
>> -
>>   void css_irq_io(void)
>>   {
>>   	int ret = 0;
>> @@ -512,7 +511,7 @@ int check_io_completion(int schid, uint32_t ctrl)
>>   
>>   	report_prefix_push("check I/O completion");
>>   
>> -	if (lowcore_ptr->io_int_param != schid) {
>> +	if (!ctrl && lowcore_ptr->io_int_param != schid) {
>>   		report(0, "interrupt parameter: expected %08x got
>> %08x", schid, lowcore_ptr->io_int_param);
>>   		ret = -1;
>> diff --git a/s390x/css.c b/s390x/css.c
>> index 57dc340..f6890f2 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -15,6 +15,7 @@
>>   #include <interrupt.h>
>>   #include <asm/arch_def.h>
>>   #include <alloc_page.h>
>> +#include <sclp.h>
>>   
>>   #include <malloc_io.h>
>>   #include <css.h>
>> @@ -55,6 +56,109 @@ static void test_enable(void)
>>   	report(cc == 0, "Enable subchannel %08x", test_device_sid);
>>   }
>>   
>> +static void test_ssch(void)
>> +{
>> +	struct orb orb = {
>> +		.intparm = test_device_sid,
>> +		.ctrl = ORB_CTRL_ISIC | ORB_CTRL_FMT | ORB_LPM_DFLT,
>> +	};
>> +	int i;
>> +	phys_addr_t top;
>> +
>> +	NODEV_SKIP(test_device_sid);
>> +
>> +	assert(css_enable(test_device_sid, 0) == 0);
>> +
>> +	/* 1- ORB address should be aligned on 32 bits */
>> +	report_prefix_push("ORB alignment");
>> +	expect_pgm_int();
>> +	ssch(test_device_sid, (void *)0x110002);
> 
> I don't like using random hardcoded addresses. can you use a valid
> address for it? either allocate it or use a static buffer.

OK, I can make it differently.

> 
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +
>> +	/* 2- ORB address should be lower than 2G */
>> +	report_prefix_push("ORB Address above 2G");
>> +	expect_pgm_int();
>> +	ssch(test_device_sid, (void *)0x80000000);
> 
> another hardcoded address... you should try allocating memory over 2G,
> and try to use it. put a check if there is enough memory, and skip if
> you do not have enough memory, like you did below

OK, you are right, here I can not know if the memory is available at 
this address.

> 
>> +	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>> +	report_prefix_pop();
>> +
>> +	/* 3- ORB address should be available we check 1G*/
>> +	top = get_ram_size();
>> +	report_prefix_push("ORB Address must be available");
>> +	if (top < 0x40000000) {
>> +		expect_pgm_int();
>> +		ssch(test_device_sid, (void *)0x40000000);
>> +		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>> +	} else {
>> +		report_skip("guest started with more than 1G
>> memory");
> 
> this is what I meant above. you will need to run this test both with 1G
> and with 3G of ram (look at the SCLP test, it has the same issue)

OK thanks, will take example from it.

> 
>> +	}
>> +	report_prefix_pop();
>> +
>> +	/* 3- ORB address should not be equal or above 2G */
> 
> the comment seems the same as the one above, maybe clarify that here
> you mean the address inside the ORB, instead of the address of the ORB
> itself

cut and past and forgot to adapt: here I check the CCW address not the 
ORB address

> 
>> +	report_prefix_push("CCW address above 2G");
>> +	orb.cpa = 0x80000000;
> 
> and again, please no hardcoded values; put a check that enough memory
> is available, and allocate from >2GB

and again.. yes

> 
>> +	expect_pgm_int();
>> +	ssch(test_device_sid, &orb);
>> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
>> +	report_prefix_pop();
>> +
>> +	senseid = alloc_io_mem(sizeof(*senseid), 0);
>> +	assert(senseid);
>> +	orb.cpa = (uint64_t)ccw_alloc(CCW_CMD_SENSE_ID, senseid,
>> +				      sizeof(*senseid), CCW_F_SLI);
>> +	assert(orb.cpa);
>> +
>> +	/* 4- Start on a disabled subchannel */
>> +	report_prefix_push("Disabled subchannel");
>> +	assert(css_disable(test_device_sid) == 0);
>> +	report(ssch(test_device_sid, &orb) == 3, "CC = 3");
>> +	report_prefix_pop();
>> +
>> +	/* 5- MIDAW is not supported by the firmware */
>> +	report_prefix_push("ORB MIDAW unsupported");
>> +	assert(css_enable(test_device_sid, 0) == 0);
>> +	orb.ctrl |= ORB_CTRL_MIDAW;
>> +	expect_pgm_int();
>> +	ssch(test_device_sid, &orb);
>> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
>> +	report_prefix_pop();
>> +	orb.ctrl = 0;
>> +
>> +	/* 6-12- Check the reserved bits of the ORB CTRL field */
>> +	for (i = 0; i < 5; i++) {
>> +		char buffer[30];
>> +
>> +		orb.ctrl = (0x02 << i);
>> +		snprintf(buffer, 30, "ORB reserved ctrl flags %02x",
>> orb.ctrl);
>> +		report_prefix_push(buffer);
>> +		expect_pgm_int();
>> +		ssch(test_device_sid, &orb);
>> +		check_pgm_int_code(PGM_INT_CODE_OPERAND);
>> +		report_prefix_pop();
>> +	}
>> +
>> +	/* 13- check the reserved bits of the ORB flags */
>> +	report_prefix_push("ORB wrong ctrl flags");
>> +	orb.ctrl |= 0x040000;
> 
> do you need the magic constant, or can you define a name for it? (or is
> even a name already defined?)

I can define this

...snip...

Thanks for the comments,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
