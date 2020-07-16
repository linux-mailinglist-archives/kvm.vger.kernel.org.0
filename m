Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBA622215B
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 13:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgGPL1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 07:27:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726383AbgGPL1n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jul 2020 07:27:43 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GB0dtu188182;
        Thu, 16 Jul 2020 07:27:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32aj747u28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 07:27:42 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06GBRgp0083372;
        Thu, 16 Jul 2020 07:27:42 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32aj747u1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 07:27:41 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GBQ7n7003995;
        Thu, 16 Jul 2020 11:27:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 329nmyhr7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 11:27:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GBQFt245416814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 11:26:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E181442042;
        Thu, 16 Jul 2020 11:27:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25CD94203F;
        Thu, 16 Jul 2020 11:27:37 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.61.186])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 11:27:37 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v13 6/9] s390x: Library resources for CSS
 tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, drjones@redhat.com
References: <1594887809-10521-1-git-send-email-pmorel@linux.ibm.com>
 <1594887809-10521-7-git-send-email-pmorel@linux.ibm.com>
 <9d6f0445-9c13-c23b-6095-0699ad09be87@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <196f3522-1880-c178-6ddd-56dd2d0b5256@linux.ibm.com>
Date:   Thu, 16 Jul 2020 13:27:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <9d6f0445-9c13-c23b-6095-0699ad09be87@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_05:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxscore=0 impostorscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-16 13:15, Janosch Frank wrote:
> On 7/16/20 10:23 AM, Pierre Morel wrote:
>> Provide some definitions and library routines that can be used by
>> tests targeting the channel subsystem.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Acked-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> Acked-by: Janosch Frank <frankja@de.ibm.com>
>> ---
> [...]
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index ddb4b48..050c40b 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -51,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
>>   cflatobjs += lib/s390x/interrupt.o
>>   cflatobjs += lib/s390x/mmu.o
>>   cflatobjs += lib/s390x/smp.o
>> +cflatobjs += lib/s390x/css_dump.o
>>   
>>   OBJDIRS += lib/s390x
>>   
> 
> I need to fix this up when picking because Thomas added vm.o after smp.o.
> Can I do that or do you want to rebase on my next branch?
> 
> 

I can do it and respin, that will give me the occasion to suppress the 
goto as demanded by Thomas.

Is it OK?


-- 
Pierre Morel
IBM Lab Boeblingen
