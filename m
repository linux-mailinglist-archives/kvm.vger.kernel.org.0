Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE013D8CEF
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 13:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhG1Lmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 07:42:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231631AbhG1Lmi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 07:42:38 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SBdoqV091728;
        Wed, 28 Jul 2021 07:42:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4czXPcxgSfvf7Mvdaa7aDcQiGZYEqXwv/2frKQzrDI8=;
 b=Wj5qbhF74RRChimGLRfsBgLmDWR258KYqw7XBBj6g7ymBId0bWPHcuH7ak/ioO3DZA4n
 rXSfX3Azn/ZYtanO3ihcUMbFMCJVzkoFlKrcVUo0tYaclU2SyuI71ar+QDMEvqsrG1Y8
 HuyMsZgWEPxV+lv0BD5QyUI3Zfncf0dDNNUJacPe3cP9JCBgo5L24a4TNcnxz50J0IvT
 bHXTpDrVjZ3J6OIvvpm6X49EVMmf2q7WMHHC9G8tUN4o+05tJN7Oh6bh8D8pJNZ3HRlM
 vW9XUPQzL5o63W69dAd7Exx8l3c9l4+ii8jzcGQlBkxxgbpINgXMUbC6OFfIKgQXh/5Y WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a35dcjexn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 07:42:36 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SBedXg097930;
        Wed, 28 Jul 2021 07:42:23 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a35dcjdxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 07:42:23 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SBcjpl004953;
        Wed, 28 Jul 2021 11:41:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3a235m10un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 11:41:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SBfZvG29491562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 11:41:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B4B442049;
        Wed, 28 Jul 2021 11:41:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30FF742041;
        Wed, 28 Jul 2021 11:41:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.21.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 11:41:35 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Add SPDX and header comments
 for s390x/* and lib/s390x/*
From:   Janosch Frank <frankja@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        cohuck@redhat.com
References: <20210728101328.51646-1-frankja@linux.ibm.com>
 <20210728101328.51646-2-frankja@linux.ibm.com>
 <20210728123221.7ca90b35@p-imbrenda>
 <d5c31cc5-0645-aa91-374e-c668b37e1150@redhat.com>
 <2e391a1a-54d4-8713-4a93-104a6b4cfaf1@linux.ibm.com>
Message-ID: <d1c3e9f0-57c0-e941-3e3f-94a897ace177@linux.ibm.com>
Date:   Wed, 28 Jul 2021 13:41:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2e391a1a-54d4-8713-4a93-104a6b4cfaf1@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -rEg_a7XRZYaCbQ38OJ7gSljksTGVCfa
X-Proofpoint-GUID: ATkwrg-lApYQG0dcuBNN7LepNznN_iHk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 phishscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/21 1:36 PM, Janosch Frank wrote:
> On 7/28/21 12:36 PM, Thomas Huth wrote:
>> On 28/07/2021 12.32, Claudio Imbrenda wrote:
>>> On Wed, 28 Jul 2021 10:13:26 +0000
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>
>>>> Seems like I missed adding them.
>>>>
>>>> The s390x/sieve.c one is a bit of a head scratcher since it came with
>>>> the first commit but I assume it's lpgl2-only since that's what the
>>>> COPYRIGHT file said then.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>   lib/s390x/uv.c   |  9 +++++++++
>>>>   s390x/mvpg-sie.c |  9 +++++++++
>>>>   s390x/sie.c      | 10 ++++++++++
>>>>   x86/sieve.c      |  5 +++++
>>>>   4 files changed, 33 insertions(+)
>> [...]
>>>> diff --git a/x86/sieve.c b/x86/sieve.c
>>>> index 8150f2d9..b89d5f80 100644
>>>> --- a/x86/sieve.c
>>>> +++ b/x86/sieve.c
>>>> @@ -1,3 +1,8 @@
>>>> +/* SPDX-License-Identifier: LGPL-2.0-only */
>>>
>>> do you really need to fix something in the x86 directory? (even though
>>> it is also used on other archs)
>>
>> I just realized that s390x/sieve.c is just a symlink, not a copy of the file :-)
> 
> You're not the only one...
> 
>>
>>> maybe you can split out this as a separate patch, so s390x stuff is
>>> more self contained, and others can then discuss the sieve.c patch
>>> separately if needed?
>>
>> That might make sense, indeed.
> 
> Yup will do

On second thought I'm just gonna drop that hunk since x86 doesn't really
have SPDX or header comments for most of their files anyway.

> 
>>
>>   Thomas
>>
> 

