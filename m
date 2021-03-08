Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2DA3310FC
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhCHOhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:37:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231215AbhCHOhR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:37:17 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EXjr8192906
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:37:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CWClg7huZ6PeLzR/295qq4Rs6qv42JosqDwli0zCKIQ=;
 b=Bh4SsI4Tvfdos283c4+Iw8iC7KwRkDUcgtQVTGePuzI+xwes4yw0OVVGRpAS6C4OhVlx
 zeYporqT9S8kqsyg0ziLJRbgvx65FurDQ0jQZLMAnQ1jw1uACSsz7TatrLbIBrWKgmEP
 ZpHcqLrZqDhTkGxm4P7d7wB762sf8Y6HQyVxqqDaQtE4eeZ6bZE81Fu0oIkpsJ2N6VHk
 hxrkbNbW50CkBRYvjluP1Ns5S4vz3jjfcIaAvkS2kmQwaG3NyWc6WrSL/5cEf7XC47C7
 qzzp7Mm1EFeaaQoyrjjL9NouNbr3DHb/xzeZa+OcLBxzwrRVoI9BzLT+vAYIn8cY3Vu6 Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375muahvh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 09:37:16 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EY1kF193959
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:37:15 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375muahv9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:37:14 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EXYij004749;
        Mon, 8 Mar 2021 14:37:02 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3741c8902m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:37:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EaiOJ30540062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:36:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 718B44C046;
        Mon,  8 Mar 2021 14:36:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 188EF4C040;
        Mon,  8 Mar 2021 14:36:59 +0000 (GMT)
Received: from [9.145.7.187] (unknown [9.145.7.187])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:36:59 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/6] s390x: css: simplifications of the
 tests
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-3-git-send-email-pmorel@linux.ibm.com>
 <70bbccca-6372-ee9a-37ae-913f5cc6a700@linux.ibm.com>
 <25d4a855-903a-32e7-d0de-dc5f4401b8a9@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <73de4bcc-e650-fdb0-aec3-dedb9d872008@linux.ibm.com>
Date:   Mon, 8 Mar 2021 15:36:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <25d4a855-903a-32e7-d0de-dc5f4401b8a9@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/21 3:13 PM, Pierre Morel wrote:
> 
> 
> On 3/1/21 4:00 PM, Janosch Frank wrote:
>> On 3/1/21 12:47 PM, Pierre Morel wrote:
>>> In order to ease the writing of tests based on:
> 
> ...snip...
> 
>>> -static void test_sense(void)
>>> +static bool do_test_sense(void)
>>>   {
>>>   	struct ccw1 *ccw;
>>> +	bool success = false;
>>
>> That is a very counter-intuitive name, something like "retval" might be
>> better.
>> You're free to use the normal int returns but unfortunately you can't
>> use the E* error constants like ENOMEM.
> 
> hum, I had retval and changed it to success on a proposition of Thomas...
> I find it more intuitive as a bool since this function succeed or fail, 
> no half way and is used for the reporting.
> 
> other opinion?

Alright, it's 2:1 for "success", so keep it if you want.

> 
> 
>>
>>>   	int ret;
>>>   	int len;
>>>   
>>>   	if (!test_device_sid) {
>>>   		report_skip("No device");
>>> -		return;
>>> +		return success;
>>>   	}
>>>   
>>> -	ret = css_enable(test_device_sid, IO_SCH_ISC);
>>> -	if (ret) {
>>> -		report(0, "Could not enable the subchannel: %08x",
>>> -		       test_device_sid);
>>> -		return;
>>> +	if (!css_enabled(test_device_sid)) {
>>> +		report(0, "enabling subchannel %08x", test_device_sid);
>>> +		return success;
>>>   	}
>>>   
>>> -	ret = register_io_int_func(css_irq_io);
>>> -	if (ret) {
>>> -		report(0, "Could not register IRQ handler");
>>> -		return;
>>> -	}
>>> -
>>> -	lowcore_ptr->io_int_param = 0;
>>> -
>>>   	senseid = alloc_io_mem(sizeof(*senseid), 0);
>>>   	if (!senseid) {
>>>   		report(0, "Allocation of senseid");
>>> -		goto error_senseid;
>>> +		return success;
>>>   	}
>>>   
>>>   	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
>>> @@ -129,21 +120,34 @@ static void test_sense(void)
>>>   	report_info("reserved 0x%02x cu_type 0x%04x cu_model 0x%02x dev_type 0x%04x dev_model 0x%02x",
>>>   		    senseid->reserved, senseid->cu_type, senseid->cu_model,
>>>   		    senseid->dev_type, senseid->dev_model);
>>> +	report_info("cu_type expected 0x%04x got 0x%04x", (uint16_t)cu_type,
>>> +		    senseid->cu_type);
>>>   
>>> -	report(senseid->cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
>>> -	       (uint16_t)cu_type, senseid->cu_type);
>>> +	success = senseid->cu_type == cu_type;
>>>   
>>>   error:
>>>   	free_io_mem(ccw, sizeof(*ccw));
>>>   error_ccw:
>>>   	free_io_mem(senseid, sizeof(*senseid));
>>> -error_senseid:
>>> -	unregister_io_int_func(css_irq_io);
>>> +	return success;
>>> +}
>>> +
>>> +static void test_sense(void)
>>> +{
>>> +	report(do_test_sense(), "Got CU type expected");
>>>   }
>>>   
>>>   static void css_init(void)
>>>   {
>>>   	report(!!get_chsc_scsc(), "Store Channel Characteristics");
>>> +
>>> +	if (register_io_int_func(css_irq_io)) {
>>> +		report(0, "Could not register IRQ handler");
>>> +		return;
>>
>> assert() please
> 
> Yes.
> 
> Thanks,
> Pierre
> 

