Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57AA3640BA
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 13:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbhDSLpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 07:45:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53430 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232530AbhDSLpj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 07:45:39 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13JBXVvC166021;
        Mon, 19 Apr 2021 07:45:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4B0J9EGvrsk40z4rg+aKFTRAUUGzXi4Vc7CcLJFoo0k=;
 b=ARrGLmJaFQj1My7/I1uVeZ6ATkROfEhGaOLCHLJiKP3vHaFKbVwMH/3vrMY4UedZeKiS
 t70V9Z1RF2pmA0XxBwHiOSEvBBYAwKPgWX44r2OnficsirhN00kF3SY3uoCDL4dyyFpQ
 Zhn2KN7QTMWpwaUGEcY6eOqpOIxSgQGSAMJ0MfJJxnAhuI73oXt+gEUnfZDY3vssmCpb
 9CXkvSBcvia4BuCbD4LXW7pqtQESFPmFVd7aJl5jYybGmG8Mwo+kzodYFhJJOzzxbTs5
 ziw4I6IdMf9/tEPuYr4f/9/8rHFVyn0Z37N9BwECltaUuPxBdW3Y0PV7eiBf0sRIGMHB Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 380cybp00w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Apr 2021 07:45:09 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13JBXeKA166554;
        Mon, 19 Apr 2021 07:45:09 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 380cybp008-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Apr 2021 07:45:08 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13JBcRuC011017;
        Mon, 19 Apr 2021 11:45:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 37yqa88jsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Apr 2021 11:45:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13JBj4SF10486254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 11:45:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92EAAA4072;
        Mon, 19 Apr 2021 11:45:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 474E9A405B;
        Mon, 19 Apr 2021 11:45:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.252])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Apr 2021 11:45:04 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: uv-guest: Add invalid share
 location test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        imbrenda@linux.ibm.com
References: <20210316091654.1646-1-frankja@linux.ibm.com>
 <20210316091654.1646-2-frankja@linux.ibm.com>
 <2c178a2c-d207-e4b8-f159-ecd9e18a2d28@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <92c5e657-a483-eeb4-5902-651be2cd5356@linux.ibm.com>
Date:   Mon, 19 Apr 2021 13:45:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <2c178a2c-d207-e4b8-f159-ecd9e18a2d28@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yMMxYqXzH2lf4MCFMBA53g2kP99zbwTf
X-Proofpoint-ORIG-GUID: cK5TGJErSFpNv6_S9Dj3db_63lURwAem
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-19_07:2021-04-16,2021-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104190081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/21 1:24 PM, Thomas Huth wrote:
> On 16/03/2021 10.16, Janosch Frank wrote:
>> Let's also test sharing unavailable memory.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   s390x/uv-guest.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
>> index 99544442..a13669ab 100644
>> --- a/s390x/uv-guest.c
>> +++ b/s390x/uv-guest.c
>> @@ -15,6 +15,7 @@
>>   #include <asm/interrupt.h>
>>   #include <asm/facility.h>
>>   #include <asm/uv.h>
>> +#include <sclp.h>
>>   
>>   static unsigned long page;
>>   
>> @@ -99,6 +100,10 @@ static void test_sharing(void)
>>   	uvcb.header.len = sizeof(uvcb);
>>   	cc = uv_call(0, (u64)&uvcb);
>>   	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "share");
>> +	uvcb.paddr = get_ram_size() + PAGE_SIZE;
>> +	cc = uv_call(0, (u64)&uvcb);
>> +	report(cc == 1 && uvcb.header.rc == 0x101, "invalid memory");
> 
> Would it make sense to add a #define for 0x101 ?
> 

The RCs change meaning with each UV call so we can only re-use a small
number of constants which wouldn't gain us a lot.

> Anyway:
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks!

