Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA302FEC48
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 14:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbhAUNux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 08:50:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10906 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730068AbhAUNtc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 08:49:32 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LDVmjw048096;
        Thu, 21 Jan 2021 08:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HbKxS23N/SkCNr+xmMgq1esC+oCSBQLYlqeQ42GlWLY=;
 b=XTY/xpcHz4mnxnkgxby2sWn9+HJbpXgTx0+LosUKIJsJFBbTUleHLA4Bz64frua1d5Y9
 rOI8WCvIdZ5dJj6czhYZbQqBsYrMcmq5tKtY07ZQrmNKyOaIMnfbvfUAHcafHOwGD6/g
 /ZwQUO+sJRFJ2s2yqtenToTLpKaEBxsNZYx5aCiGCc+IxxlHRmd4ZBg82X/HgMRhGdRE
 eYrB3VJz8yejWDqnShLLQoj/7sYSgMmr0cIC0cn6feu8JzN8wxryOY1Dhh8nMxyJw2A8
 XhrfziyUGHHq8Sm7R+5B4i499AHB92m+kEBGEKHxGEqVZGjmNazAjxv3hYOys44BIJnv 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3679vd20k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:48:50 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LDW7XY050622;
        Thu, 21 Jan 2021 08:48:50 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3679vd20j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:48:50 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LDmmSb032608;
        Thu, 21 Jan 2021 13:48:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3668ny0vpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 13:48:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LDmjCC38601172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 13:48:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60C5811C052;
        Thu, 21 Jan 2021 13:48:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD80311C058;
        Thu, 21 Jan 2021 13:48:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.35])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 13:48:44 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
 <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
 <3bce47db-c58c-6a2e-be72-9953f16a2dd4@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: define UV compatible I/O
 allocation
Message-ID: <75d5f645-cbfb-0a39-54ff-c61c67ed6355@linux.ibm.com>
Date:   Thu, 21 Jan 2021 14:48:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <3bce47db-c58c-6a2e-be72-9953f16a2dd4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_06:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/21 2:02 PM, Pierre Morel wrote:
> 
> 
> On 1/21/21 10:46 AM, Janosch Frank wrote:
>> On 1/21/21 10:13 AM, Pierre Morel wrote:
>>> To centralize the memory allocation for I/O we define
>>> the alloc_io_page/free_io_page functions which share the I/O
>>> memory with the host in case the guest runs with
>>> protected virtualization.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   MAINTAINERS           |  1 +
>>>   lib/s390x/malloc_io.c | 70 +++++++++++++++++++++++++++++++++++++++++++
>>>   lib/s390x/malloc_io.h | 45 ++++++++++++++++++++++++++++
>>>   s390x/Makefile        |  1 +
>>>   4 files changed, 117 insertions(+)
>>>   create mode 100644 lib/s390x/malloc_io.c
>>>   create mode 100644 lib/s390x/malloc_io.h
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 54124f6..89cb01e 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -82,6 +82,7 @@ M: Thomas Huth <thuth@redhat.com>
>>>   M: David Hildenbrand <david@redhat.com>
>>>   M: Janosch Frank <frankja@linux.ibm.com>
>>>   R: Cornelia Huck <cohuck@redhat.com>
>>> +R: Pierre Morel <pmorel@linux.ibm.com>
>>
>> If you're ok with the amount of mails you'll get then go ahead.
>> But I think maintainer file changes should always be in a separate patch.
>>
>>>   L: kvm@vger.kernel.org
>>>   L: linux-s390@vger.kernel.org
>>>   F: s390x/*
>>> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
>>> new file mode 100644
>>> index 0000000..bfe8c6a
>>> --- /dev/null
>>> +++ b/lib/s390x/malloc_io.c
>>> @@ -0,0 +1,70 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>
>> I think we wanted to use:
> 
> @Janosch , @Thomas
> 
>> /* SPDX-License-Identifier: GPL-2.0-or-later */
> 
> or
> 
> // SPDX-License-Identifier: GPL-2.0-only
> 
> later or only ?
> 
> /* or // ?
> 
> 
> If both are OK, I will take the Janosch proposition which is in use in 
> vm.[ch] and ignore the Linux checkpatch warning.
> 
> Just to : Why are you people not using the Linux style code completely 
> instead of making new exceptions.
> 
> i.e. SPDX license and MAINTAINERS
> 

s390 also has /* */ style SPDX and GPL2.0+ statements in the kernel...

Since KUT has way less developers the style rules aren't as strict and
currently I see that as an advantage. Following checkpatch down the
cliff is a bad idea in the kernel and for unit tests. It's most often
correct, but not always.
