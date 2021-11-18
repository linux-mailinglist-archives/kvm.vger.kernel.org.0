Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93E7455E89
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhKROwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:52:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229836AbhKROvy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 09:51:54 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIEfWUC029239
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 14:48:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CEzERD41iqdaC/zb13bQCtTx3OJT50NH3EnQOjjs+i0=;
 b=lrwdSs26ft0L9g7gwgGg1bARogr76aW8ywVzDFdxdK2AW1M2xGar6zJ3P5d+MfB1kG3D
 a/1dRY50UXFascErVXjkPmZJYQLmpdh9Zsh14MEs0RD2sV5GqRWsxfzCW5JUF5QNHpEm
 xGP9FYARVZsQGVd83KpTTESwxKPxwKYlNlVHFxOBV9gI63b3eD2FNNvUCwh3fj7/Bmr8
 eFtdiGb0kejqymkjoxXV1SjrUztrCmEDrrCjMIWi9AC8AzPKUoEGWTLqbdGeOi5kCWyX
 vAuHhe4x09e6bRW82fgl8Fp6WQ4lR8ayJ8v4IGc4frMkHDAMwcNcZB2tQ8xecEkeG/c5 fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdrtjr5vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 14:48:52 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AIEgujm006444
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 14:48:51 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdrtjr5uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 14:48:51 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIEfRXl008502;
        Thu, 18 Nov 2021 14:48:49 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3ca4mkf1m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 14:48:49 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIEmkjj26542422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 14:48:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12BAEAE05F;
        Thu, 18 Nov 2021 14:48:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAA64AE055;
        Thu, 18 Nov 2021 14:48:45 +0000 (GMT)
Received: from [9.171.84.168] (unknown [9.171.84.168])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Nov 2021 14:48:45 +0000 (GMT)
Message-ID: <2b7cdcb3-a8cf-5fa9-4cbd-70586966bc73@linux.ibm.com>
Date:   Thu, 18 Nov 2021 15:49:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v2] io: declare __cpu_is_be in generic code
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <20211118134848.336943-1-pmorel@linux.ibm.com>
 <a646aee0-dc3d-d5d6-268a-7994c7b86789@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <a646aee0-dc3d-d5d6-268a-7994c7b86789@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PZxJHh4Nj0cfbh3Zttr89ptH3GSH1v17
X-Proofpoint-GUID: 9bzG2USQNFrwLrBMa7n_IaJdmoeEMaO7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/18/21 15:45, Thomas Huth wrote:
> On 18/11/2021 14.48, Pierre Morel wrote:
>> To use the swap byte transformations in big endian architectures,
>> we need to declare __cpu_is_be in the generic code.
>> Let's move it from the ppc code to the generic code.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Suggested-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   lib/asm-generic/io.h | 8 ++++++++
>>   lib/ppc64/asm/io.h   | 8 --------
>>   2 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/lib/asm-generic/io.h b/lib/asm-generic/io.h
>> index 88972f3b..9fa76ddb 100644
>> --- a/lib/asm-generic/io.h
>> +++ b/lib/asm-generic/io.h
>> @@ -13,6 +13,14 @@
>>   #include "asm/page.h"
>>   #include "asm/barrier.h"
>> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
>> +#define __cpu_is_be() (0)
>> +#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
>> +#define __cpu_is_be() (1)
>> +#else
>> +#error Undefined byte order
>> +#endif
> 
> Please remove these three later lines in that file now:
> 
> #ifndef __cpu_is_be
> #define __cpu_is_be() (0)
> #endif
> 
>   Thomas
> 

grrr, stupid me

> 
>>   #ifndef __raw_readb
>>   static inline u8 __raw_readb(const volatile void *addr)
>>   {
>> diff --git a/lib/ppc64/asm/io.h b/lib/ppc64/asm/io.h
>> index 2b4dd2be..08d7297c 100644
>> --- a/lib/ppc64/asm/io.h
>> +++ b/lib/ppc64/asm/io.h
>> @@ -1,14 +1,6 @@
>>   #ifndef _ASMPPC64_IO_H_
>>   #define _ASMPPC64_IO_H_
>> -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
>> -#define __cpu_is_be() (0)
>> -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
>> -#define __cpu_is_be() (1)
>> -#else
>> -#error Undefined byte order
>> -#endif
>> -
>>   #define __iomem
>>   #include <asm-generic/io.h>
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
