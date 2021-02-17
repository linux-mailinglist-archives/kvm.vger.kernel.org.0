Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4E331DCEF
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 17:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhBQQJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 11:09:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234002AbhBQQJd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 11:09:33 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HG1Ffi011737;
        Wed, 17 Feb 2021 11:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TgWYIpRZegpqRdQ/uHE7/HdVTBmBDKh2z02ix8Ia0vY=;
 b=B6i0IVeGxVmIM8sWFaRA/Y3NvK7jGXLI+1SBFagRCXHDttVQp0GYdwWPlNmkKTVXYdbM
 4nezq09MTMahyGSFL30y3pcNS8iAhZeGat6eoTHmkFdDwJ3GK2P60D0ECGuMJOhzxHJm
 v/GLJkKJ+0KroKcLQCX8o3y0S4JVehQtDjAw3Yle7a5NphqiU+s7uWTLmc02Qa47/DWm
 WQiVgakbSzZlJlMo5C7OKbR77NKUtgFc5xZinFcDe8WOvkGHlYOqwPjwCZRApcReJIoE
 o8l8FIH5N+V6c8wnQF+ZExLuMD8fsf/W9O5z3Hzb13lSXiOl5y47QYG3ODVYxg7BdqPd 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36s6a18ams-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 11:08:51 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HG32cp019917;
        Wed, 17 Feb 2021 11:08:51 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36s6a18am0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 11:08:50 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HG32j3008466;
        Wed, 17 Feb 2021 16:08:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 36p6d8a0fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 16:08:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HG8kxC49545526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 16:08:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FEF852050;
        Wed, 17 Feb 2021 16:08:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.1.64])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C92915204E;
        Wed, 17 Feb 2021 16:08:45 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] RFC: s390x: Define
 STACK_FRAME_INT_SIZE macro
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210217144116.3368-1-frankja@linux.ibm.com>
 <20210217144116.3368-4-frankja@linux.ibm.com>
 <6fd0eb37-03f5-d0ee-8649-27fca1aa50fb@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <834f2e69-e08b-de15-fb9f-bed73fd2cc04@linux.ibm.com>
Date:   Wed, 17 Feb 2021 17:08:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <6fd0eb37-03f5-d0ee-8649-27fca1aa50fb@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_13:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 spamscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/21 4:38 PM, Thomas Huth wrote:
> On 17/02/2021 15.41, Janosch Frank wrote:
>> Using sizeof is safer than using magic constants. However, it doesn't
>> really fit into asm-offsets.h as it's not an offset so I'm happy to
>> receive suggestions on where to put it.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/asm-offsets.c | 1 +
>>   s390x/macros.S          | 4 ++--
>>   2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>> index 96cb21cf..2658b59a 100644
>> --- a/lib/s390x/asm-offsets.c
>> +++ b/lib/s390x/asm-offsets.c
>> @@ -86,6 +86,7 @@ int main(void)
>>   	OFFSET(STACK_FRAME_INT_CRS, stack_frame_int, crs);
>>   	OFFSET(STACK_FRAME_INT_GRS0, stack_frame_int, grs0);
>>   	OFFSET(STACK_FRAME_INT_GRS1, stack_frame_int, grs1);
>> +	DEFINE(STACK_FRAME_INT_SIZE, sizeof(struct stack_frame_int));
>>   
>>   	return 0;
>>   }
>> diff --git a/s390x/macros.S b/s390x/macros.S
>> index d7eeeb55..a7d62c6f 100644
>> --- a/s390x/macros.S
>> +++ b/s390x/macros.S
>> @@ -43,14 +43,14 @@
>>   /* Save registers on the stack (r15), so we can have stacked interrupts. */
>>   	.macro SAVE_REGS_STACK
>>   	/* Allocate a full stack frame */
>> -	slgfi   %r15, 32 * 8 + 4 * 8
>> +	slgfi   %r15, STACK_FRAME_INT_SIZE
>>   	/* Store registers r0 to r14 on the stack */
>>   	stmg    %r2, %r15, STACK_FRAME_INT_GRS0(%r15)
>>   	stg     %r0, STACK_FRAME_INT_GRS1(%r15)
>>   	stg     %r1, STACK_FRAME_INT_GRS1 + 8(%r15)
>>   	/* Store the gr15 value before we allocated the new stack */
>>   	lgr     %r0, %r15
>> -	algfi   %r0, 32 * 8 + 4 * 8
>> +	algfi   %r0, STACK_FRAME_INT_SIZE
> 
> Ah, well, that of course fixes the problem that I had with the previous 
> patch. I'd suggest to merge it into patch 2.

That was the plan anyway, I had so much pain until I yanked out the int
offsets in favor of the macros. :)

Did you have time to read the commit message?
I'm not completely convinced that asm-offset.c is the right place for
the DEFINE() so I kept this patch as a discussion starter.

> 
>   Thomas
> 

