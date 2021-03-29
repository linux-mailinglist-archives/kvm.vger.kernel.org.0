Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7FB34C523
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 09:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhC2Hmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 03:42:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64930 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231142AbhC2Hmq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 03:42:46 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T7XQeu041166
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 03:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1DhbxlhYbuCEc2xixRJOuMvBgPOcumzYZqqNmBnPHac=;
 b=EEk8ZCH0OrI521TgyHkD+DHJM1vSMdlWNAfWMo6hiyERigVzzN63Ljm+d90TK0jr7xA7
 QnNCXSDSPM/wsZT/jYvKALyXTf1ZpulF183OYabe2puDChhY5n2c8utrWGLgTh1CiCgz
 X1Etay/UuD75wUI0tsk1WOlN4kVgeIaDOnHeEVXfD4G5TVihK7ZdEzwxbsH4j3ebpM7I
 mlWWq6r7XIDophhoYhEt6x1qHzuzYCgLuMZbrdfj23e5kQ1SXY6Pkk3yRW19lB6bJ/oW
 Q+/SNwbVDgwB+VsUWre5KRKABR6Y2wDHhG8ufnuq3rYk5zXyk2hOcvVdGTmkcKWAwV2e YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpme31kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 03:42:45 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12T7XidX042012
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 03:42:45 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpme31jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 03:42:45 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12T7WdQ2017982;
        Mon, 29 Mar 2021 07:42:43 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 37hvb8hjv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 07:42:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12T7gL7L34144528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 07:42:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC5B64C04E;
        Mon, 29 Mar 2021 07:42:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12C674C04A;
        Mon, 29 Mar 2021 07:42:40 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.173.162])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 07:42:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 6/8] s390x: css: testing ssch error
 response
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-7-git-send-email-pmorel@linux.ibm.com>
 <20210325170257.2e753967@ibm-vm>
 <12260eaf-1fc8-00ce-f500-b56e7ad7ae2a@linux.ibm.com>
 <20210326115855.21427c7d@ibm-vm>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <dfd959d6-453c-5c06-d0b1-5b657e72c8d4@linux.ibm.com>
Date:   Mon, 29 Mar 2021 09:42:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210326115855.21427c7d@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lu-nBtiebg9f1rLNvef5-XaBQm-VdES8
X-Proofpoint-ORIG-GUID: W6o68waw0ae3PlcE8vJP2PWalBw4EoKo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_04:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/26/21 11:58 AM, Claudio Imbrenda wrote:
> On Fri, 26 Mar 2021 11:41:34 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 3/25/21 5:02 PM, Claudio Imbrenda wrote:
>>> On Thu, 25 Mar 2021 10:39:05 +0100
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>    
>>
>> ...snip...
>>
>>
>> Trying to follow your comment, I have some questions:
>>
>>
>>>> +	/* 2- ORB address should be lower than 2G */
>>>> +	report_prefix_push("ORB Address above 2G");
>>>> +	expect_pgm_int();
>>>> +	ssch(test_device_sid, (void *)0x80000000);
>>>
>>> another hardcoded address... you should try allocating memory over
>>> 2G, and try to use it. put a check if there is enough memory, and
>>> skip if you do not have enough memory, like you did below
>>
>> How can I allocate memory above 2G?
> 
> alloc_pages_flags(order, AREA_NORMAL)
> 
> btw that allocation will fail if there is no free memory available
> above 2G
> 
>>>    
>>>> +	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>>>> +	report_prefix_pop();
>>>> +
>>>> +	/* 3- ORB address should be available we check 1G*/
>>>> +	top = get_ram_size();
>>>> +	report_prefix_push("ORB Address must be available");
>>>> +	if (top < 0x40000000) {
>>>> +		expect_pgm_int();
>>>> +		ssch(test_device_sid, (void *)0x40000000);
>>>> +		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>>>> +	} else {
>>>> +		report_skip("guest started with more than 1G
>>>> memory");
>>>
>>> this is what I meant above. you will need to run this test both
>>> with 1G and with 3G of ram (look at the SCLP test, it has the same
>>> issue)
>>
>> I do not understand, if I test with 3G RAM, I suppose that the
>> framework works right and I have my 3G RAM available.
>> Then I can check with an address under 1G and recheck with an address
>> above 1G.
>>
>> What is the purpose to check with only 1G memory?
> 
> you need to run this test twice, once with 1G and once with 3G.
> it's the same test, so it can't know if it is being run with 1G or
> 3G, so you have to test for it.
> 
> when you need a valid address above 2G, you need to make sure you have
> that much memory, and when you want an invalid address between 1G and
> 2G, you have to make sure you have no more than 1G.

OK, thanks




-- 
Pierre Morel
IBM Lab Boeblingen
