Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A222FE5E4
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 10:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbhAUJJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 04:09:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbhAUJI0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 04:08:26 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L95jIw171612;
        Thu, 21 Jan 2021 04:07:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F5x62VVNkmWy1MUATkZQoh4CM5LN79z9h+Gu4OnKQQs=;
 b=PKR3tNYIpNwn6Ql3Ssr9VEkSscyu5WcvkKiX/YRkrCxZx5qdeSuoBH/k7hwnuaIggnZ5
 oVm1LyM53d0ajSdvq397nQlRS3bo7G2eB4+HFJwB9pOuV0cireZ4HBGnYAh6oIgpz/k+
 oaoJqgqHSof1pWLB04U7d6lUw/+pODJqwvdhGrl0ohGgKnrjl9293EKkji42AMDXq73T
 nJ/aPO41uDJ3dXEpTbssgL2eUWhAMvwBP3sObrmBUC5M+GIZLvIQ07FxqTUneflIec2S
 YJ8r4lvUUxjD2LYpL9PQ0640lWlVqJ87vYO9RGLaykwECdgsQVjGoXPAzyjRCj8eNp+9 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3676p28136-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:07:35 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10L97ZJv178205;
        Thu, 21 Jan 2021 04:07:35 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3676p2812n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:07:35 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L94VqX021512;
        Thu, 21 Jan 2021 09:07:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3668pj8s7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 09:07:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L97T6l47382976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 09:07:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA9DDA4059;
        Thu, 21 Jan 2021 09:07:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54544A4051;
        Thu, 21 Jan 2021 09:07:29 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.36.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 09:07:29 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: css: pv: css test adaptation
 for PV
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
 <1611085944-21609-4-git-send-email-pmorel@linux.ibm.com>
 <b4656e81-1492-d902-73cf-5a08a0a6247d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b08a9fa2-6b08-d616-ba3d-a04140490f75@linux.ibm.com>
Date:   Thu, 21 Jan 2021 10:07:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <b4656e81-1492-d902-73cf-5a08a0a6247d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_04:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/20/21 1:03 PM, Thomas Huth wrote:
> On 19/01/2021 20.52, Pierre Morel wrote:
>> We want the tests to automatically work with or without protected
>> virtualisation.
>> To do this we need to share the I/O memory with the host.
>>
>> Let's replace all static allocations with dynamic allocations
>> to clearly separate shared and private memory.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> [...]
>> diff --git a/s390x/css.c b/s390x/css.c
>> index ee3bc83..4b0b6b1 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -17,13 +17,15 @@
>>   #include <interrupt.h>
>>   #include <asm/arch_def.h>
>> +#include <malloc_io.h>
>>   #include <css.h>
>> +#include <asm/barrier.h>
>>   #define DEFAULT_CU_TYPE        0x3832 /* virtio-ccw */
>>   static unsigned long cu_type = DEFAULT_CU_TYPE;
>>   static int test_device_sid;
>> -static struct senseid senseid;
>> +static struct senseid *senseid;
>>   static void test_enumerate(void)
>>   {
>> @@ -57,6 +59,7 @@ static void test_enable(void)
>>    */
>>   static void test_sense(void)
>>   {
>> +    struct ccw1 *ccw;
>>       int ret;
>>       int len;
>> @@ -80,9 +83,15 @@ static void test_sense(void)
>>       lowcore_ptr->io_int_param = 0;
>> -    memset(&senseid, 0, sizeof(senseid));
>> -    ret = start_single_ccw(test_device_sid, CCW_CMD_SENSE_ID,
>> -                   &senseid, sizeof(senseid), CCW_F_SLI);
>> +    senseid = alloc_io_page(sizeof(*senseid));
> 
> Would it make sense to move the above alloc_io_page into the ccw_alloc() 
> function, too?

If the goal is to have all allocations inside the ccw_alloc(),
I don't think so, we may have an already allocated buffer for which we 
want to pass the address without any allocation inside ccw_alloc() to 
reuse the same buffer.


> 
>> +    if (!senseid)
>> +        goto error_senseid;
>> +
>> +    ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), 
>> CCW_F_SLI);
>> +    if (!ccw)
>> +        goto error_ccw;
>> +
>> +    ret = start_ccw1_chain(test_device_sid, ccw);
>>       if (ret)
>>           goto error;
> 
> I think you should add a "report(0, ...)" or report_abort() in front of 
> all three gotos above - otherwise the problems might go unnoticed.

Yes, right, I will do this,
Thanks.

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
