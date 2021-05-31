Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41469395A27
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 14:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhEaMLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 08:11:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58066 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231670AbhEaMLD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 08:11:03 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VC2vmG145859;
        Mon, 31 May 2021 08:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uyoPLmz1i1YcQV1f0M6oftc/7Lnj7eEsKzdH9yo/ORE=;
 b=GUu0XkvakgZmvtiLOGHrY1myrw54OlWJeXix2wrG9nSmMzfw/wwFBQEiUXvosK5GoLkn
 HhIAUO7z5TGLQiN0xxZjUQOUSL+8XR9H3Q20T80sOOy1XpCofrXQMHX5NeYwXjLKqNSP
 Gz52uoqCoJ4gX+3urWq4J8CBRhfEyaCMzYJYBJ1slk3eTnaRPnRZGjZefRWdqCzOCE+9
 vhFqIxDTUzp0HyEclk3FqxJefgCEiVJH1vIviqNIy4CIIg4S8vCwDGeSL1h2N15pKY0M
 e0boIQEh/4bUlKp/uA1qARmmDphothnZM73109Az3hi0QZ0S3NKKSLpB6MWyWldWke5U yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38vye3r7jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 08:09:23 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14VC37ar147051;
        Mon, 31 May 2021 08:09:23 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38vye3r7j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 08:09:23 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14VC9Lw3022855;
        Mon, 31 May 2021 12:09:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 38ud8890rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 12:09:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14VC9ICs35062112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 May 2021 12:09:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE28FA4065;
        Mon, 31 May 2021 12:09:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58537A406A;
        Mon, 31 May 2021 12:09:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.89.221])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 May 2021 12:09:18 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: selftest: Fix report output
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <20210531105003.44737-1-frankja@linux.ibm.com>
 <20210531131119.65587773.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <ee1c2162-027a-f6b2-694f-08e9aae7f44d@linux.ibm.com>
Date:   Mon, 31 May 2021 14:09:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210531131119.65587773.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gw3XPXCkcTEDmS1UqjJUtZKmE65mGt_C
X-Proofpoint-GUID: 9E6j179ncDiZAyaaRWOh3bFFotV9TB27
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_08:2021-05-31,2021-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105310087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/21 1:11 PM, Cornelia Huck wrote:
> On Mon, 31 May 2021 10:50:03 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> To make our TAP parser (and me) happy we don't want to have to reports
> 
> "we want to have two reports" ?
> 
> If that's not what has been intended, I'm confused :)

Things that happen if the following sentence is heard:
"Can you fix this quickly, please?"

Will fix, thanks for the review!

> 
>> with exactly the same wording.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/selftest.c | 18 +++++++++++++-----
>>  1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/s390x/selftest.c b/s390x/selftest.c
>> index b2fe2e7b..c2ca9896 100644
>> --- a/s390x/selftest.c
>> +++ b/s390x/selftest.c
>> @@ -47,12 +47,19 @@ static void test_malloc(void)
>>  	*tmp2 = 123456789;
>>  	mb();
>>  
>> -	report((uintptr_t)tmp & 0xf000000000000000ul, "malloc: got vaddr");
>> -	report(*tmp == 123456789, "malloc: access works");
>> +	report_prefix_push("malloc");
>> +	report_prefix_push("ptr_0");
>> +	report((uintptr_t)tmp & 0xf000000000000000ul, "allocated memory");
>> +	report(*tmp == 123456789, "wrote allocated memory");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("ptr_1");
>>  	report((uintptr_t)tmp2 & 0xf000000000000000ul,
>> -	       "malloc: got 2nd vaddr");
>> -	report((*tmp2 == 123456789), "malloc: access works");
>> -	report(tmp != tmp2, "malloc: addresses differ");
>> +	       "allocated memory");
>> +	report((*tmp2 == 123456789), "wrote allocated memory");
>> +	report_prefix_pop();
>> +
>> +	report(tmp != tmp2, "allocated memory addresses differ");
>>  
>>  	expect_pgm_int();
>>  	configure_dat(0);
>> @@ -62,6 +69,7 @@ static void test_malloc(void)
>>  
>>  	free(tmp);
>>  	free(tmp2);
>> +	report_prefix_pop();
>>  }
>>  
>>  int main(int argc, char**argv)
> 

