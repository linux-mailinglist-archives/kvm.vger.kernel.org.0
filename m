Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4077341955
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 11:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhCSKDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 06:03:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230035AbhCSKCq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 06:02:46 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12J9Y0NW103582
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 06:02:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=A43Lc3u2opwac0y5wwCM892A5T+0MtuBCnSO91nK+vo=;
 b=AdvCRHL5mZKtRimTtJktMQJelBkouMUL9rhyC108B+lD358RKqVBaG0qSmTAObj+dBb6
 lae3cj/envk7NjCEBd5vEdwb/jt4ZBMV9k4+a+ISDJypgMSv/EHeshvCaYAQmVktPWFz
 +3sEZkfRhFu5A4AHpEEtgViZWWXHB2BsKTWyZv7NgDUj7VGkXYHNkTd/ozHEy6vMkJBD
 UzfzN8YnIRmqM16TJAIESpc+1V+ewYvtAPgyW0wqr7vyKLBfE6pPEXBeU7pW2+jOl6O2
 1rFXTUGLv4Y9/qyE9g3DD/ystOl0D+u1ZJdvfGmyC7X7JVaukeI1LbwXItwLV0BRA2zY gQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c302xgjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 06:02:45 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JA25qL024855
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 10:02:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 37crcrg2eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 10:02:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JA2NaL35848488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 10:02:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E51FEA4064;
        Fri, 19 Mar 2021 10:02:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A36A7A4054;
        Fri, 19 Mar 2021 10:02:40 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.64.79])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 10:02:40 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 5/6] s390x: css: testing ssch error
 response
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-6-git-send-email-pmorel@linux.ibm.com>
 <201e476c-a014-55f6-b4d0-ff2c1d429c42@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <23eb9189-d8a5-7b59-ad04-a3a3b3ae45c2@linux.ibm.com>
Date:   Fri, 19 Mar 2021 11:02:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <201e476c-a014-55f6-b4d0-ff2c1d429c42@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_03:2021-03-17,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/21 10:18 AM, Janosch Frank wrote:
> On 3/18/21 2:26 PM, Pierre Morel wrote:
>> Checking error response on various eroneous SSCH instructions:
>> - ORB alignment
>> - ORB above 2G
>> - CCW above 2G
>> - bad ORB flags
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 102 insertions(+)
>>
>> diff --git a/s390x/css.c b/s390x/css.c
>> index a6a9773..1c891f8 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -51,6 +51,107 @@ static void test_enable(void)
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
>> +	phys_addr_t base, top;
>> +
>> +	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
>> +	assert(register_io_int_func(css_irq_io) == 0);
>> +
>> +	/* ORB address should be aligned on 32 bits */
>> +	report_prefix_push("ORB alignment");
>> +	expect_pgm_int();
>> +	ssch(test_device_sid, (void *)0x110002);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +
>> +	/* ORB address should be lower than 2G */
>> +	report_prefix_push("ORB Address above 2G");
>> +	expect_pgm_int();
>> +	ssch(test_device_sid, (void *)0x80000000);
>> +	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>> +	report_prefix_pop();
>> +
>> +	phys_alloc_get_unused(&base, &top);
>> +	report_info("base %08lx, top %08lx", base, top);
> 
> Please use this function from lib/s390x/sclp.c
> 
> uint64_t get_ram_size(void)
> {
>          return ram_size;
> }
> 

thanks, I was not aware of this function.


>> +
>> +	/* ORB address should be available we check 1G*/
>> +	report_prefix_push("ORB Address must be available");
>> +	if (top < 0x40000000) {
>> +		expect_pgm_int();
>> +		ssch(test_device_sid, (void *)0x40000000);
>> +		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>> +	} else {
>> +		report_skip("guest started with more than 1G memory");
>> +	}
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("CCW address above 2G");
>> +	orb.cpa = 0x80000000;
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
>> +	report_prefix_push("Disabled subchannel");
>> +	assert(css_disable(test_device_sid) == 0);
>> +	report(ssch(test_device_sid, &orb) == 3, "CC = 3");
>> +	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
>> +	report_prefix_pop();
>> +
>> +	/*
>> +	 * Check sending a second SSCH before clearing the status with TSCH >> +	 * the subchannel is left disabled.
> 
> If a second SSCH is sent before clearing via TSCH the subchannel is
> disabled by firmware? Did I get that right?


Oh, no, sorry, the comment is not good, no the firmware does not disable 
the subchannel, the comment is not at the right place.

> 
>> +	 */
>> +	report_prefix_push("SSCH on channel with status pending");
>> +	assert(css_enable(test_device_sid, IO_SCH_ISC) == 0);
>> +	assert(ssch(test_device_sid, &orb) == 0);
>> +	report(ssch(test_device_sid, &orb) == 1, "CC = 1");
>> +	/* now we clear the status */
>> +	assert(wait_and_check_io_completion(test_device_sid, SCSW_FC_START) == 0);

The comment about leaving the channel disabled should be here  should be 
here... :(
The idea about disabling the subchannel is to make sure to have a clean 
subchannel for the next test.
However I am not so sure it really bring something.


Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
