Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECAD4147E7
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 13:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbhIVLib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 07:38:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21244 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230171AbhIVLi3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 07:38:29 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M9M74s022231;
        Wed, 22 Sep 2021 07:36:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NXBx5dqDCc9S943AjoQYTz/4bTTyMld2VJLektLQdDE=;
 b=MDtt8n/Xs5SqfaGzZzjO5Fd0UTXJqc+e5QXiWIa0Ga3rVAV8DTi+UCHGu+59Hj/RTArZ
 JgwgmFzr1ENy8iFtHZh7SVzs3CwUaHMR4MWfRQctJkmG+uzFDKsjrC4az4Gegtpw9tep
 XYzO4UxnSP8fJUPuExvrIHzA6FvzMEK0Qg04yHCr1Nqz74E21tZf477+iqtehn+AEOYk
 7P957IdCZYZNd9q+RcyMB7HteMb6rQVk9fTqc49K/4aFUmKFKbrMr4D2A32bkVBlKvAT
 mXNVDVB0n0yoDa6fSON/+WeyHawhUlDv+mmlFHUKaL9hQY4CNre/9HcY8IL5rHA0HLMJ QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7yqjnqww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:36:59 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18MAlq3L025225;
        Wed, 22 Sep 2021 07:36:58 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7yqjnqw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:36:58 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18MBVxTw012893;
        Wed, 22 Sep 2021 11:36:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3b7q6qx262-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 11:36:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18MBW3Ki57540972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 11:32:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A4704C064;
        Wed, 22 Sep 2021 11:36:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8D414C044;
        Wed, 22 Sep 2021 11:36:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.85.176])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 11:36:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/9] s390x: uv: Tolerate 0x100 query return
 code
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-2-frankja@linux.ibm.com>
 <20210922111256.04febb7e@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <75c8d08e-3b93-c001-cc84-5f77aaee5248@linux.ibm.com>
Date:   Wed, 22 Sep 2021 13:36:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922111256.04febb7e@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Is28jtXBkCtBC0VAM09VKkaDWH5spvK_
X-Proofpoint-ORIG-GUID: vBrqJQbRlYIRUnF_CniR5kC44D0RW2OK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_04,2021-09-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109200000 definitions=main-2109220081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/21 11:12 AM, Claudio Imbrenda wrote:
> On Wed, 22 Sep 2021 07:18:03 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> RC 0x100 is not an error but a notice that we could have gotten more
>> data from the Ultravisor if we had asked for it. So let's tolerate
>> them in our tests.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/uv-guest.c | 4 ++--
>>  s390x/uv-host.c  | 2 +-
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
>> index f05ae4c3..e7446e03 100644
>> --- a/s390x/uv-guest.c
>> +++ b/s390x/uv-guest.c
>> @@ -70,8 +70,8 @@ static void test_query(void)
>>  	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
>>  
>>  	uvcb.header.len = sizeof(uvcb);
>> -	cc = uv_call(0, (u64)&uvcb);
>> -	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "successful query");
>> +	uv_call(0, (u64)&uvcb);
>> +	report(uvcb.header.rc == UVC_RC_EXECUTED || uvcb.header.rc
>> == 0x100, "successful query");
> 
> if you want to be even more pedantic:
> 	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED ||
> 		cc == 1 && uvcb.header.rc == 0x100, ... 

Yeah I pondered about that but at the end I chose to drop the cc check

> 
>>  
>>  	/*
>>  	 * These bits have been introduced with the very first
>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>> index 28035707..66a11160 100644
>> --- a/s390x/uv-host.c
>> +++ b/s390x/uv-host.c
>> @@ -401,7 +401,7 @@ static void test_query(void)
>>  
>>  	uvcb_qui.header.len = sizeof(uvcb_qui);
>>  	uv_call(0, (uint64_t)&uvcb_qui);
>> -	report(uvcb_qui.header.rc == UVC_RC_EXECUTED, "successful query");
>> +	report(uvcb_qui.header.rc == UVC_RC_EXECUTED || uvcb_qui.header.rc == 0x100, "successful query");
> 
> same here
> 
>>  
>>  	for (i = 0; cmds[i].name; i++)
>>  		report(uv_query_test_call(cmds[i].call_bit), "%s", cmds[i].name);
> 

