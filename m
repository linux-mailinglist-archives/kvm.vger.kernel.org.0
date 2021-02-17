Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6006531DD12
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 17:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhBQQNW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 11:13:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45188 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233982AbhBQQNG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 11:13:06 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HG4Qwq156529;
        Wed, 17 Feb 2021 11:12:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gZZy4shRbyB4GxdZc61mS7tg83C6TUCJr2wq6YTRaMU=;
 b=ELH+Edvv8iN1P48z2Ey0u0ctIkKMV+3Izy8DV7+oC1FCgY88hojaLmDusjByiQG5FVFt
 iNAlFy6EhvizD9irqWrGVfP8gyT2do/J0SV0pHwqtdjonqmBVGrphaXp3UdweICTkL7n
 WhEiXddrHvHPXj6sphOtgSkYKPg1P6gQr7zG2QrZBz2B9Gh9wo2LyRq4PupZG3oQHdnJ
 mo1FTKZUnHvDIo2xCZYhi3ycW75gSloYhtKU9dYVML5mnKKlrjZ63u7Kf3eQIHwkDK8E
 Ua0Cvyq4xJdFv7rXLPhRdj2+72GmN0jbfI+xd+OgBPu8RzCGjWtoPPqjkuTgx3z6YwqP Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s588351c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 11:12:22 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HG4sJp159292;
        Wed, 17 Feb 2021 11:12:22 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s5883500-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 11:12:22 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HG2UNG028682;
        Wed, 17 Feb 2021 16:12:19 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 36p6d8j0u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 16:12:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HGCGeR62587312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 16:12:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B1B652050;
        Wed, 17 Feb 2021 16:12:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.1.64])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E95505204E;
        Wed, 17 Feb 2021 16:12:15 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: Provide preliminary
 backtrace support
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210217144116.3368-1-frankja@linux.ibm.com>
 <20210217144116.3368-6-frankja@linux.ibm.com>
 <1bba9659-efa4-192a-ef60-ab62069f2901@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <81d9d0f4-691e-50c5-6e9d-afa8ebb73d48@linux.ibm.com>
Date:   Wed, 17 Feb 2021 17:12:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1bba9659-efa4-192a-ef60-ab62069f2901@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_13:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 adultscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102170122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/21 5:01 PM, Thomas Huth wrote:
> On 17/02/2021 15.41, Janosch Frank wrote:
>> After the stack changes we can finally use -mbackchain and have a
>> working backtrace.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/interrupt.c | 12 ++++++++++++
>>   lib/s390x/stack.c     | 20 ++++++++++++++------
>>   s390x/Makefile        |  1 +
>>   3 files changed, 27 insertions(+), 6 deletions(-)
>>
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index a59df80e..23ad922c 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -115,6 +115,18 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>>   	/* suppressed/terminated/completed point already at the next address */
>>   }
>>   
>> +static void print_pgm_info(struct stack_frame_int *stack)
>> +
>> +{
>> +	printf("\n");
>> +	printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
>> +	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
>> +	       lc->pgm_int_id);
>> +	dump_stack();
>> +	report_summary();
>> +	abort();
>> +}
> 
> I asssume this hunk should go into the next patch instead?
> Or should the change to handle_pgm_int() from the next patch go into this 
> patch here instead?
> Otherwise you have an unused static function here and the compiler might 
> complain about it (when bisecting later).

I'll move it to the next patch

> 
>   Thomas
> 

