Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859C81E48A9
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 17:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390605AbgE0Pym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 11:54:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390576AbgE0Pyc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 11:54:32 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04RFYh45123041;
        Wed, 27 May 2020 11:54:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=E6qREuCJv1NZZlqRAr9ZUHhojEvQQ/j1Vpc6bCO1HxM=;
 b=Bk516RV6n7lqbxn0AzzUCbRa8JvKTtw9mJkHHNIwwHMwjZatf3BLBZ8em2mgghJ8n8cT
 VJIDijsfKjP+vtg50Fr3zzvvyreefZHM1viwiDHuzDnQW8V3t8agBfwiVt2UZBi9wJFD
 0ccwfCgxm4bHZZXxRn1WXGtNQHvpos5xIutEfjbCbs3XJThfDvauaBwrzYAPA9Hk44aj
 kmDyFZZ/a3mn0HHFx6tyOHT25g0hkJOpq6ZTDZQHek/L/S8A4Fb0M+HZZYKEc4CmUk0N
 9pptvIoIlTV2QjDQOcfzTHkVTtPrl4Fh/5AEn/2BU3EG7SfSWOIQ1Zy/2NvwDkskaJDj 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 319s3bn5k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 11:54:31 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04RFZ6Dr126031;
        Wed, 27 May 2020 11:54:31 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 319s3bn5jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 11:54:30 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04RFpK0r028488;
        Wed, 27 May 2020 15:54:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 316uf885sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 15:54:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04RFsRLH42664082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 15:54:27 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F338411C054;
        Wed, 27 May 2020 15:54:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9A9611C050;
        Wed, 27 May 2020 15:54:26 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.63.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 May 2020 15:54:26 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 04/12] s390x: interrupt registration
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-5-git-send-email-pmorel@linux.ibm.com>
 <dcfa518e-ce93-fb71-3e70-b95c12b0b32e@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <6ebf59e6-4fd1-a85c-d0aa-cd64382f9a10@linux.ibm.com>
Date:   Wed, 27 May 2020 17:54:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <dcfa518e-ce93-fb71-3e70-b95c12b0b32e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-27,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 priorityscore=1501
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005270116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-26 20:08, Thomas Huth wrote:
> On 18/05/2020 18.07, Pierre Morel wrote:
>> Let's make it possible to add and remove a custom io interrupt handler,
>> that can be used instead of the normal one.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/interrupt.c | 23 ++++++++++++++++++++++-
>>   lib/s390x/interrupt.h |  8 ++++++++
>>   2 files changed, 30 insertions(+), 1 deletion(-)
>>   create mode 100644 lib/s390x/interrupt.h
> ...
>> diff --git a/lib/s390x/interrupt.h b/lib/s390x/interrupt.h
>> new file mode 100644
>> index 0000000..323258d
>> --- /dev/null
>> +++ b/lib/s390x/interrupt.h
>> @@ -0,0 +1,8 @@
>> +#ifndef __INTERRUPT_H
>> +#define __INTERRUPT_H
> 
> Looking at this patch again, I noticed another nit: No double
> underscores at the beginning of header guards, please! That's reserved
> namespace. Simply use INTERRUPT_H or S390X_INTERRUPT_H or something
> similar instead.
> 
>   Thanks,
>    Thomas
> 

OK, thanks
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
