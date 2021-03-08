Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64C9331119
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhCHOlz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:41:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32584 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229650AbhCHOlZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:41:25 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EXhTp067594
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:41:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=v2iarzKLqfukzY4td1IvmSUlZe/NS1TUcVbphP+R/X0=;
 b=UEol6Aw4PhSJcA8SaMXff6VJdB/kPY3qTGtW7DmQZuyDK4klUAPqFROA/9/LnpIOzI1H
 +DQ7DEbIimFZPm9JUZkkI9PzhG5d7hzROd6rUIrYukNx4RxxzFrLKPd0jrL5ydRGaCrp
 fKwFFHBusouV7gDtYdnxZtBOKb+6mZy8MxFn6oxungcAcyttwNDqPokjKpjXqShXCpHC
 roSgitS9mpzIttI7XlC61xBSkZh0VGWIp+Hs1VyR1G6r4eZp5BKAmcnHLYuq9hYIkBrN
 Nw0Ev+lwr/fRivwtw6s6NJG8pXNeLi3rxvMbRfw+LmtqoQDFEvk5toR4HUMZoXaR0Opx 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nke8rbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 09:41:25 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EZeIv080336
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:41:24 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nke8ra3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:41:24 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EWjTs010750;
        Mon, 8 Mar 2021 14:41:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3741c8904y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:41:22 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EfJAR46137720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:41:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91EE0AE055;
        Mon,  8 Mar 2021 14:41:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57682AE045;
        Mon,  8 Mar 2021 14:41:19 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.87.232])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:41:19 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/6] s390x: css: simplifications of the
 tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-3-git-send-email-pmorel@linux.ibm.com>
 <70bbccca-6372-ee9a-37ae-913f5cc6a700@linux.ibm.com>
 <25d4a855-903a-32e7-d0de-dc5f4401b8a9@linux.ibm.com>
 <73de4bcc-e650-fdb0-aec3-dedb9d872008@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b1276af3-e19a-4e07-aa30-c4416ad569b0@linux.ibm.com>
Date:   Mon, 8 Mar 2021 15:41:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <73de4bcc-e650-fdb0-aec3-dedb9d872008@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 spamscore=0 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/8/21 3:36 PM, Janosch Frank wrote:
> On 3/8/21 3:13 PM, Pierre Morel wrote:
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
>>>>    {
>>>>    	struct ccw1 *ccw;
>>>> +	bool success = false;
>>>
>>> That is a very counter-intuitive name, something like "retval" might be
>>> better.
>>> You're free to use the normal int returns but unfortunately you can't
>>> use the E* error constants like ENOMEM.
>>
>> hum, I had retval and changed it to success on a proposition of Thomas...
>> I find it more intuitive as a bool since this function succeed or fail,
>> no half way and is used for the reporting.
>>
>> other opinion?
> 
> Alright, it's 2:1 for "success", so keep it if you want.

:) OK thanks

-- 
Pierre Morel
IBM Lab Boeblingen
