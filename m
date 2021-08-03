Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D54D3DEF3F
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 15:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhHCNsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 09:48:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234388AbhHCNsL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 09:48:11 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173DbcTa137613;
        Tue, 3 Aug 2021 09:47:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=L18TyFKizwRJHWpW8VSMeK81EQm3rFiGSjHYCZqO0sk=;
 b=I5dGHeeypijC9Zicu+cru/DmOgLhkQfEWTpCqVBib8auwcUjAOQXMu6OK81soZJmBc6R
 00PEvzGW0Fb54z4//Vzkn+UAaNhpV6aEPZLoMueA5dzY9Ii9jCd3HRsszOSVALl5GrhW
 7j0EcK3RTtTMCUwk/DbJW0OpUOEDLB31MzbQ+/EIhklJSEZYsG6cJdDnT/gwRvbaEZrB
 ZzSuqMkxEXgxmQtPzhHnJnfLyWvtj5WL7buY3gMQWhwqSw85Bj4z3SZDlz+ZH8r9rQrX
 KNsoxa7KiBS9RhilWcvBJI8g6Eqw1qWx96eYkfei1OeYUY+r/R6Fq3M81+fKYE3eDfmF jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a5nh8qpxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 09:47:59 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 173DcWgF139671;
        Tue, 3 Aug 2021 09:47:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a5nh8qpv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 09:47:58 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 173DhSFU018867;
        Tue, 3 Aug 2021 13:47:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3a4x58y57h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 13:47:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 173Divir28901876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 13:44:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FD3F52051;
        Tue,  3 Aug 2021 13:47:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.171.18])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 42F7652052;
        Tue,  3 Aug 2021 13:47:53 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210729134803.183358-1-frankja@linux.ibm.com>
 <20210729134803.183358-2-frankja@linux.ibm.com>
 <e4b7d844-a602-78be-2cdb-3f87bb22a04e@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/4] s390x: sie: Add sie lib validity
 handling
Message-ID: <ca027e7f-9baf-f48e-459b-0d365db09023@linux.ibm.com>
Date:   Tue, 3 Aug 2021 15:47:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e4b7d844-a602-78be-2cdb-3f87bb22a04e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R5yGEPvq3F6Hujl_fNMKPYJhwc8R2qX1
X-Proofpoint-ORIG-GUID: Vy7YvAuYe3yYDbZZW44dpFc-7s5HTPpt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_03:2021-08-03,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108030090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/30/21 4:45 PM, Thomas Huth wrote:
> On 29/07/2021 15.48, Janosch Frank wrote:
>> Let's start off the SIE lib with validity handling code since that has
>> the least amount of dependencies to other files.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/sie.c  | 41 +++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/sie.h  |  3 +++
>>   s390x/Makefile   |  1 +
>>   s390x/mvpg-sie.c |  2 +-
>>   s390x/sie.c      |  7 +------
>>   5 files changed, 47 insertions(+), 7 deletions(-)
>>   create mode 100644 lib/s390x/sie.c
>>
>> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
>> new file mode 100644
>> index 00000000..9107519f
>> --- /dev/null
>> +++ b/lib/s390x/sie.c
>> @@ -0,0 +1,41 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Virtualization library that speeds up managing guests.
> 
> "speeds up managing guests" ... so this means that guests can be scheduled 
> faster? ;-)

Maybe once I implement scheduling which is not on my current plan.

> 
>> + * Copyright (c) 2021 IBM Corp
>> + *
>> + * Authors:
>> + *  Janosch Frank <frankja@linux.ibm.com>
>> + */
>> +
>> +#include <asm/barrier.h>
>> +#include <libcflat.h>
>> +#include <sie.h>
>> +
>> +static bool validity_expected;
>> +static uint16_t vir;
> 
> What does "vir" stand for? A short comment would be nice.

So apparently it's called "Validity-Interception Reason" in the
specification which makes sense in the context it's used :)

I'll add a few words.

> 
>   Thomas
> 

