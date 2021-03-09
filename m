Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1840332201
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 10:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCIJa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 04:30:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbhCIJar (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 04:30:47 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12994iqC055324
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 04:30:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9QHvICG2orT8/TVNgvHGHDJKga67v98k4Rms9jHzsV0=;
 b=G/9JPbnI6wTIRbk8qnaAiTuW+arJCwHg+Wm+dJ+Gf6sFFZw7RlnFJ5jbPEQzXkYosiof
 ZhclFfE2g/N54XvhGchw7d/S3dr6X5mYKIroI+sLjuU1B0KEyRanRCXyCH5eTB+S1G5+
 3MuJnzA7rFi7r0Xr1cROZCq0omPBXCmh7PK4r1uPYSOITzyl5MYuQp+ixp/AQydJyNhi
 zNR7/jww6z77xDpSFPrHOf5sV4gpRpV5FzdsgDLjVd+u8rXFmmjxEPs8ELAHSrpqrfMl
 xNPWtzCkfhL3ZDdxVeSVf0/LblK0iJM1HB6cMqcsDReG4JGc+S7MshnLEk8wgir8LY87 mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37640hv5s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 04:30:47 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12995CA7057651
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 04:30:47 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37640hv5qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 04:30:46 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1299MIED024242;
        Tue, 9 Mar 2021 09:30:44 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3741c89bu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 09:30:44 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1299Ufsn20840914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 09:30:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4E2942045;
        Tue,  9 Mar 2021 09:30:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6447242041;
        Tue,  9 Mar 2021 09:30:41 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.215])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Mar 2021 09:30:41 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/6] s390x: css: simplifications of the
 tests
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-3-git-send-email-pmorel@linux.ibm.com>
 <70bbccca-6372-ee9a-37ae-913f5cc6a700@linux.ibm.com>
 <25d4a855-903a-32e7-d0de-dc5f4401b8a9@linux.ibm.com>
 <3e59a15b-a2d0-4527-edb3-582c723ab526@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <9cc48323-1d6a-4f43-680f-5adb2843f9da@linux.ibm.com>
Date:   Tue, 9 Mar 2021 10:30:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3e59a15b-a2d0-4527-edb3-582c723ab526@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_06:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=928 clxscore=1015 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103090045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/8/21 3:41 PM, Thomas Huth wrote:
> On 08/03/2021 15.13, Pierre Morel wrote:
>>
>>
>> On 3/1/21 4:00 PM, Janosch Frank wrote:
>>> On 3/1/21 12:47 PM, Pierre Morel wrote:
>>>> In order to ease the writing of tests based on:
>>
>> ...snip...
>>
>>>> -static void test_sense(void)
>>>> +static bool do_test_sense(void)
>>>>   {
>>>>       struct ccw1 *ccw;
>>>> +    bool success = false;
>>>
>>> That is a very counter-intuitive name, something like "retval" might be
>>> better.
>>> You're free to use the normal int returns but unfortunately you can't
>>> use the E* error constants like ENOMEM.
>>
>> hum, I had retval and changed it to success on a proposition of Thomas...
>> I find it more intuitive as a bool since this function succeed or 
>> fail, no half way and is used for the reporting.
>>
>> other opinion?
> 
> I'd say either "static int ..." + retval (with 0 for success), or 
> "static bool ..." and "success" (with true for success) ... but "bool" + 
> "retval" sounds confusing to me.
> 
>   Thomas
> 


Hum, OK, I think I see were the unsatisfation about this function comes 
from. (I do not like it either)
Slowly understanding the benefit of assert() and report_abort() in the 
tests cases I will rework this part and do not change the test_senseid() 
test.

I will introduce a sense_id() function when needing to do I/O in the 
fmt0 test, asserting in this function that all parts already checked in 
the preceding tests are functional.

This makes all much shorter and cleaner.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
