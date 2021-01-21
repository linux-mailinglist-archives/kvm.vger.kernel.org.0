Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EDB2FEC53
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 14:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbhAUNvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 08:51:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728942AbhAUNsx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 08:48:53 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LDV5pG130278;
        Thu, 21 Jan 2021 08:48:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jF7ftTOYIv6emFBYx0PM5wNu4w4TQOeJeQM2c2+5QKw=;
 b=mh2X/9CSx9yVunhPsYn37jnP/mmrbPOxNBP6TqM0pVkNfq+DPnHGRX9nwRTYrVc4jyyZ
 9x+NEB3XH5m8B6Kpy13rvMExNPPN7DpRSae3L/DIkTs9mnxM/XDMY0vFrvFo831RZiV/
 7WkFwz0zsZe0ZrdCPUVpgX4XcH03P7Hn4ZgNYcJO6zOXRtzA9b6RSP5uRTbUYe5F0KdX
 YS5S1lcW9HtquUUAe7x0Dk88JaaHdNWk+E+TVE5aswR6wjO8bDx2pkZ/EyOwhEFswip3
 bTITFI/YNVa3Uidts3TwglAFaD+OGmMkG/juJv83ng6lBLqTm3iNnLQSD7ANgxel7a+w Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36792a3q96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:48:03 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LDV4dm130188;
        Thu, 21 Jan 2021 08:48:03 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36792a3q89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:48:03 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LDjASQ013775;
        Thu, 21 Jan 2021 13:48:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3668p0sq06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 13:48:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LDlwju46137600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 13:47:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49566A4057;
        Thu, 21 Jan 2021 13:47:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE6F8A4055;
        Thu, 21 Jan 2021 13:47:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.36.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 13:47:57 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: define UV compatible I/O
 allocation
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
 <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
 <3bce47db-c58c-6a2e-be72-9953f16a2dd4@linux.ibm.com>
 <0a46a299-c52d-2c7f-bb38-8d58afe053e0@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ab6a5d6d-29e1-4ccd-64dd-6e39888cb439@linux.ibm.com>
Date:   Thu, 21 Jan 2021 14:47:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <0a46a299-c52d-2c7f-bb38-8d58afe053e0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_06:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/21/21 2:43 PM, Thomas Huth wrote:
> On 21/01/2021 14.02, Pierre Morel wrote:
>>
>>
>> On 1/21/21 10:46 AM, Janosch Frank wrote:
>>> On 1/21/21 10:13 AM, Pierre Morel wrote:
>>>> To centralize the memory allocation for I/O we define
>>>> the alloc_io_page/free_io_page functions which share the I/O
>>>> memory with the host in case the guest runs with
>>>> protected virtualization.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>   MAINTAINERS           |  1 +
>>>>   lib/s390x/malloc_io.c | 70 
>>>> +++++++++++++++++++++++++++++++++++++++++++
>>>>   lib/s390x/malloc_io.h | 45 ++++++++++++++++++++++++++++
>>>>   s390x/Makefile        |  1 +
>>>>   4 files changed, 117 insertions(+)
>>>>   create mode 100644 lib/s390x/malloc_io.c
>>>>   create mode 100644 lib/s390x/malloc_io.h
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index 54124f6..89cb01e 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -82,6 +82,7 @@ M: Thomas Huth <thuth@redhat.com>
>>>>   M: David Hildenbrand <david@redhat.com>
>>>>   M: Janosch Frank <frankja@linux.ibm.com>
>>>>   R: Cornelia Huck <cohuck@redhat.com>
>>>> +R: Pierre Morel <pmorel@linux.ibm.com>
>>>
>>> If you're ok with the amount of mails you'll get then go ahead.
>>> But I think maintainer file changes should always be in a separate 
>>> patch.
>>>
>>>>   L: kvm@vger.kernel.org
>>>>   L: linux-s390@vger.kernel.org
>>>>   F: s390x/*
>>>> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
>>>> new file mode 100644
>>>> index 0000000..bfe8c6a
>>>> --- /dev/null
>>>> +++ b/lib/s390x/malloc_io.c
>>>> @@ -0,0 +1,70 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>
>>> I think we wanted to use:
>>
>> @Janosch , @Thomas
>>
>>> /* SPDX-License-Identifier: GPL-2.0-or-later */
>>
>> or
>>
>> // SPDX-License-Identifier: GPL-2.0-only
>>
>> later or only ?
> 
> If it's a new file, it's up to the author. I personally prefer -later, 
> but I think IBM's preference is normally -only instead. Please check 
> with your colleagues.
> Most s390x-related files in the kvm-unit-tests currently use 
> "GPL-2.0-only", so that should be ok anyway.
> 
>> /* or // ?
> 
> I don't mind. // seems to be kernel style for .c files, but so far we've 
> only used /* with SPDX in the kvm-unit-tests, so both should be fine, I 
> think.
> 
>> Just to : Why are you people not using the Linux style code completely 
>> instead of making new exceptions.
>>
>> i.e. SPDX license and MAINTAINERS
> 
> Actually, I wonder why the Linux documentation still recommends the 
> identifiers that are marked as deprecated on the SPDX website. The 
> deprecated "GPL-2.0" can be rather confusing, since it IMHO can easily 
> be mistaken as "GPL-2.0+", so the newer identifiers are better, indeed.
> 
> Not sure what you mean with MAINTAINERS, though.

Thanks for the explanations :)

For MAINTAINERS, the Linux kernel checkpatch warns that we should use
TABS instead of SPACES between item and names.

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
