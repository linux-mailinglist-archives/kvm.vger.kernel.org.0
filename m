Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E41B387990
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 15:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245131AbhERNL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 09:11:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240133AbhERNL4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 09:11:56 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14ID3WQ2192128;
        Tue, 18 May 2021 09:10:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mF3P/VeetkKAwNEGpUgid4e65MpPaM5gg4t58kodHQs=;
 b=NOcMCHwz+KpsCeWZUNpox/SWq1IpfY752AEkBVFWOTnQtpwwp6ckGeI1oIFYiWIQd6UV
 i/FtNEF7hSWy3ssFLys3HCwzESk4JS3oFqSS5objAgz0pF/9rg7nmkJJtIMP8mUVbTP1
 9NzX3Sol+9kJ2O4KLwBcgOWgbf+zY/J71ldD3ZCGTeRV+EwoSRekvNggur5RPGv0DBTm
 wfUoJxdbPmPWyqL1zqReLBQcZmxaOaRnW9j/Dmk+MZ623Q40kaLiew1TWVFiNydLKbDy
 Z8GzzwPxw+YLAYoOlEtBAMJCOnpawWrFxg9Uwfi44W12QmUrxtTajyDyihYz97FF3ADb 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mc9vbsjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 09:10:37 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14ID4H1n195274;
        Tue, 18 May 2021 09:10:37 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mc9vbsh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 09:10:36 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14ID8F5F014937;
        Tue, 18 May 2021 13:10:34 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 38m19sr643-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 13:10:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IDAVAP38076872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 13:10:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0FD1A4059;
        Tue, 18 May 2021 13:10:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DE80A4057;
        Tue, 18 May 2021 13:10:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.37.27])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 13:10:31 +0000 (GMT)
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
References: <20210510135148.1904-1-frankja@linux.ibm.com>
 <20210510135148.1904-4-frankja@linux.ibm.com>
 <20210511181333.56e25c31.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/6] s390x: uv: Add UV lib
Message-ID: <7a574791-f7c9-d8b4-fd5c-b4e941b199d1@linux.ibm.com>
Date:   Tue, 18 May 2021 15:10:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210511181333.56e25c31.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8vYnHxCrkUQVmftXiItNY3Hk5TDnl61m
X-Proofpoint-GUID: 8mQ0SU-du_4rUsxyJ8l3FzVDtuA4OH86
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_04:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105180091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/21 6:13 PM, Cornelia Huck wrote:
> On Mon, 10 May 2021 13:51:45 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Let's add a UV library to make checking the UV feature bit easier.
>> In the future this library file can take care of handling UV
>> initialization and UV guest creation.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>  lib/s390x/asm/uv.h |  4 ++--
>>  lib/s390x/io.c     |  2 ++
>>  lib/s390x/uv.c     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>>  lib/s390x/uv.h     | 10 ++++++++++
>>  s390x/Makefile     |  1 +
>>  5 files changed, 60 insertions(+), 2 deletions(-)
>>  create mode 100644 lib/s390x/uv.c
>>  create mode 100644 lib/s390x/uv.h
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index 11f70a9f..b22cbaa8 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -9,8 +9,8 @@
>>   * This code is free software; you can redistribute it and/or modify it
>>   * under the terms of the GNU General Public License version 2.
>>   */
>> -#ifndef UV_H
>> -#define UV_H
>> +#ifndef ASM_S390X_UV_H
>> +#define ASM_S390X_UV_H
> 
> Completely unrelated, but this made me look at the various header
> guards, and they seem to be a bit all over the place.
> 
> E.g. in lib/s390x/asm/, I see no prefix, ASM_S390X, _ASMS390X,
> __ASMS390X, ...
> 
> Would consolidating this be worthwhile, or just busywork?
> 

Good catch
Having a consolidated naming scheme would be good so new devs don't get
confused.
