Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECBA2FEB33
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 14:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbhAUNEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 08:04:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8468 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731618AbhAUNDs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 08:03:48 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LD2Y9f113829;
        Thu, 21 Jan 2021 08:03:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y9Mr1MzDMRHy7YeUFac/+rI+aOUhxvrrFtMQYl/nTZE=;
 b=p7Akf0WAZSsWxd3Ue6lUwG85Hfu09K3EgPjPWh4HyxmPl0V3U+DFmcpD1+vS6yzLKlLy
 3p0nGBeDVd+UTz4wBb/98/i0Tsja0iZ5SUPmAkurJSl46dDp1kIkFkHE4BEldad0Nm/z
 MqHTsmX22X8kGq561xg6IjnzQ6q+rio6JrEfzBN+udBYdL279drPToyKnhNkVl5CmoyW
 /tpK4aSGGjTZD6yp9HQ9w5i7KtGOMOeGF5bdTCXaAUoEEM7LGcLDI8q3Es+uG6U38k50
 s6LUfaVLApFDIfdmud6ge4JrMNHN10RfbmP+svVtP2StkXKBGynW0mXmf48BGgKbku91 QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367a1kr7fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:03:03 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LD33tH116565;
        Thu, 21 Jan 2021 08:03:03 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367a1kr753-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:03:02 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LCpVTO012979;
        Thu, 21 Jan 2021 13:02:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3668pasnrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 13:02:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LD2Ycn50921962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 13:02:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A940BA4053;
        Thu, 21 Jan 2021 13:02:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44847A4040;
        Thu, 21 Jan 2021 13:02:34 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.36.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 13:02:34 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: define UV compatible I/O
 allocation
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
 <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <3bce47db-c58c-6a2e-be72-9953f16a2dd4@linux.ibm.com>
Date:   Thu, 21 Jan 2021 14:02:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_06:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 phishscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/21/21 10:46 AM, Janosch Frank wrote:
> On 1/21/21 10:13 AM, Pierre Morel wrote:
>> To centralize the memory allocation for I/O we define
>> the alloc_io_page/free_io_page functions which share the I/O
>> memory with the host in case the guest runs with
>> protected virtualization.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   MAINTAINERS           |  1 +
>>   lib/s390x/malloc_io.c | 70 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/malloc_io.h | 45 ++++++++++++++++++++++++++++
>>   s390x/Makefile        |  1 +
>>   4 files changed, 117 insertions(+)
>>   create mode 100644 lib/s390x/malloc_io.c
>>   create mode 100644 lib/s390x/malloc_io.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 54124f6..89cb01e 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -82,6 +82,7 @@ M: Thomas Huth <thuth@redhat.com>
>>   M: David Hildenbrand <david@redhat.com>
>>   M: Janosch Frank <frankja@linux.ibm.com>
>>   R: Cornelia Huck <cohuck@redhat.com>
>> +R: Pierre Morel <pmorel@linux.ibm.com>
> 
> If you're ok with the amount of mails you'll get then go ahead.
> But I think maintainer file changes should always be in a separate patch.
> 
>>   L: kvm@vger.kernel.org
>>   L: linux-s390@vger.kernel.org
>>   F: s390x/*
>> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
>> new file mode 100644
>> index 0000000..bfe8c6a
>> --- /dev/null
>> +++ b/lib/s390x/malloc_io.c
>> @@ -0,0 +1,70 @@
>> +// SPDX-License-Identifier: GPL-2.0
> 
> I think we wanted to use:

@Janosch , @Thomas

> /* SPDX-License-Identifier: GPL-2.0-or-later */

or

// SPDX-License-Identifier: GPL-2.0-only

later or only ?

/* or // ?


If both are OK, I will take the Janosch proposition which is in use in 
vm.[ch] and ignore the Linux checkpatch warning.

Just to : Why are you people not using the Linux style code completely 
instead of making new exceptions.

i.e. SPDX license and MAINTAINERS


-- 
Pierre Morel
IBM Lab Boeblingen
