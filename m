Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7AC34A5BA
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 11:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhCZKmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 06:42:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229738AbhCZKlk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 06:41:40 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12QAbUSI057425
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 06:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CGNZEOqWO+DxOmZL5w020AS5R6fKIrObI+eO3xc3dnY=;
 b=owl/GSE4/Q/et9HmlbU5F7F3v177Cq7tsfLUzHaRToDLC8ou1C+ffjKBReQOIUufWjGa
 o/qkXnyaBJ7nxNuqYhqSOcWAzCr54o5gwMvxsfMfNrXDo4KOQ3jhhrV/IV9/Dzl3RKgB
 8Um24WfieIThVtoPQjmBX8fOdMsz7fHxuH6SJpdqoED3Z4ybf9sszfwtUKv0kIgHyN81
 9YIyXJgVN1OgVcy1g8HybAgH49HIVNYv/LNP9WmFT/l39HDlFJYEi/6PtSBFuMHFN+jB
 idQO9bZi4mATqiu/0jKiqxM4tITuBZ8Xi/pzI4q605jg3cpVMtwpkqQM5crQHAshuOpO Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37hccfatt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 06:41:39 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12QAbm2l058861
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 06:41:39 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37hccfatsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 06:41:39 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12QAfawM002854;
        Fri, 26 Mar 2021 10:41:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 37h1510j8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 10:41:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12QAfYam20316646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 10:41:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8905BA4051;
        Fri, 26 Mar 2021 10:41:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A51EA4053;
        Fri, 26 Mar 2021 10:41:34 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.63.51])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Mar 2021 10:41:34 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 6/8] s390x: css: testing ssch error
 response
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-7-git-send-email-pmorel@linux.ibm.com>
 <20210325170257.2e753967@ibm-vm>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <12260eaf-1fc8-00ce-f500-b56e7ad7ae2a@linux.ibm.com>
Date:   Fri, 26 Mar 2021 11:41:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325170257.2e753967@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hnQ0ZQxEHx9SPzR-DrHlTQd1Ix3y_KGm
X-Proofpoint-GUID: D6kqeUXF-gx-2epNb2AHux3lzj58zLdk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_03:2021-03-26,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 5:02 PM, Claudio Imbrenda wrote:
> On Thu, 25 Mar 2021 10:39:05 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 

...snip...


Trying to follow your comment, I have some questions:


>> +	/* 2- ORB address should be lower than 2G */
>> +	report_prefix_push("ORB Address above 2G");
>> +	expect_pgm_int();
>> +	ssch(test_device_sid, (void *)0x80000000);
> 
> another hardcoded address... you should try allocating memory over 2G,
> and try to use it. put a check if there is enough memory, and skip if
> you do not have enough memory, like you did below

How can I allocate memory above 2G?

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

I do not understand, if I test with 3G RAM, I suppose that the framework 
works right and I have my 3G RAM available.
Then I can check with an address under 1G and recheck with an address 
above 1G.

What is the purpose to check with only 1G memory?


Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
