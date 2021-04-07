Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EA4356A73
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 12:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351645AbhDGKyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 06:54:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25134 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351624AbhDGKxr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 06:53:47 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137AY5xc077539
        for <kvm@vger.kernel.org>; Wed, 7 Apr 2021 06:53:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=X0BeAEfIwQxFZ1Sjn9lTwhX/TaSe0ySs+/nxCP2Chpc=;
 b=ok4XD9gxPuasaGPMWyTLqL2f9cv6Z0oskm3Q+cMSYlR0TNL+cA7Cbddzpdb3MzTbkQon
 E5gE/yXcEZ+WPBqmFHCJPLkyfoxj0CyMKVJFRcMxkPS2FFG5jnZ6Xy4R2/z9tQ2hXEAv
 w864Kqa+bqlS/GTB0C5drPLswAXU3Mhn7Qt+lwdDee7ANzqy+ZcizdE2P5jbaOBNnL4C
 f4CbXhPbyh4BEKW+7tKBDnTk45Ey9AGfLRDhLyel43lL5L962etfrnKDSuMmF6aix/W1
 KfZwfrY3PgnTU1sscQeERg1QnN50o8t41ZIPdKimH1Ebttk6xYWSNBXFBBzSXnsEjaRQ JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvm066gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 06:53:38 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 137AgOIY118327
        for <kvm@vger.kernel.org>; Wed, 7 Apr 2021 06:53:38 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvm066g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 06:53:38 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137AjTuZ001726;
        Wed, 7 Apr 2021 10:53:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 37rvbvgb7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 10:53:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137ArWZh42009024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 10:53:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1CA2AE055;
        Wed,  7 Apr 2021 10:53:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80F6AAE053;
        Wed,  7 Apr 2021 10:53:32 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.161])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Apr 2021 10:53:32 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 03/16] s390x: css: simplify skipping
 tests on no device
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
 <1617694853-6881-4-git-send-email-pmorel@linux.ibm.com>
 <20210406144405.09647bb4.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <3db65f02-fb55-e925-c8e8-265bc2d1c9ee@linux.ibm.com>
Date:   Wed, 7 Apr 2021 12:53:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210406144405.09647bb4.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: POfNJpIXs1IlYH7xTzTVDSz2P57iYQ41
X-Proofpoint-ORIG-GUID: u7pI-Y5v86ZF2j3Ec1pQvih3oQlL1TwT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_07:2021-04-06,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104070074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/6/21 2:44 PM, Cornelia Huck wrote:
> On Tue,  6 Apr 2021 09:40:40 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We will have to test if a device is present for every tests
>> in the future.
>> Let's provide separate the first tests from the test loop and
>> skip the remaining tests if no device is present.
> 
> What about the following patch description:
> 
> "We keep adding tests that act upon a concrete device, and we have to
> test that a device is present for all of those.
> 
> Instead, just skip all of the tests requiring a device if we were not
> able to set it up in the first place. The enumeration test will already
> have failed in that case."

ok yes better.

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 36 ++++++++++++++----------------------
>>   1 file changed, 14 insertions(+), 22 deletions(-)
>>
> 
> (...)
> 
>> @@ -336,8 +316,6 @@ static struct {
>>   	void (*func)(void);
>>   } tests[] = {
>>   	/* The css_init test is needed to initialize the CSS Characteristics */
> 
> If you remove the css_init test from this list, the above comment does
> not make sense anymore :)


grrr I thought I did remove this.
will do.

> 
>> -	{ "initialize CSS (chsc)", css_init },
>> -	{ "enumerate (stsch)", test_enumerate },
>>   	{ "enable (msch)", test_enable },
>>   	{ "sense (ssch/tsch)", test_sense },
>>   	{ "measurement block (schm)", test_schm },
>> @@ -352,11 +330,25 @@ int main(int argc, char *argv[])
>>   
>>   	report_prefix_push("Channel Subsystem");
>>   	enable_io_isc(0x80 >> IO_SCH_ISC);
>> +
>> +	report_prefix_push("initialize CSS (chsc)");
>> +	css_init();
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("enumerate (stsch)");
>> +	test_enumerate();
>> +	report_prefix_pop();
> 
> Could we maybe have two lists of tests: one that don't require a
> device, and one that does?

Yes, I can do that.

> 
>> +
>> +	if (!test_device_sid)
>> +		goto end;
> 
> In any case, I think we should log an explicit message that we skip the
> remaining tests because of no device being available.

OK, I will re-arrange the test order.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
