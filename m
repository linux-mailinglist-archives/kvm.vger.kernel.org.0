Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A45C3D8CD7
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 13:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhG1LhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 07:37:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57622 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231631AbhG1LhD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 07:37:03 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SBZLlc142223;
        Wed, 28 Jul 2021 07:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JpvkP/sSx0+CicPZme9FwNAfcQuXADAEVl5JkdlP+y8=;
 b=YYRrYKqu55UzWN9g2r/udWLhqD91zs/s5oc/T8zvig8XXt+eBaRBMhibarMZcYV1P+eW
 kDpIv+CRroXStuCcyyJowQ2+CdMCbpn0RpjyYBccYSFAfqOpgEezmZNcQeISC7Y1mP3u
 jMQBuB2jbud2yGqR1SSBFPm70U3YifBp4qVjN4MiDqLIuW/ELMlTGjYXjcKakuzwxIjK
 2rViZhdcZXdvThXy74ZlgkKpI9UJaEF+q7Mb2QJWu+qQ8ZcAddkxn63B9ugqaH4XWkmm
 1F7yYSEy23sT/Vv4hQVg0XdMx/0Lm2Lr6tdLePIWZ4nCIA7GIwLoCA51YPyPSc0Wp3UO YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a36g88495-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 07:36:59 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SBZUXx143018;
        Wed, 28 Jul 2021 07:36:58 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a36g8841y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 07:36:58 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SBSfhV031628;
        Wed, 28 Jul 2021 11:36:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3a235kgntg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 11:36:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SBapLs27263350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 11:36:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DFFF4203F;
        Wed, 28 Jul 2021 11:36:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D847642047;
        Wed, 28 Jul 2021 11:36:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.21.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 11:36:50 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Add SPDX and header comments
 for s390x/* and lib/s390x/*
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        cohuck@redhat.com
References: <20210728101328.51646-1-frankja@linux.ibm.com>
 <20210728101328.51646-2-frankja@linux.ibm.com>
 <20210728123221.7ca90b35@p-imbrenda>
 <d5c31cc5-0645-aa91-374e-c668b37e1150@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <2e391a1a-54d4-8713-4a93-104a6b4cfaf1@linux.ibm.com>
Date:   Wed, 28 Jul 2021 13:36:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d5c31cc5-0645-aa91-374e-c668b37e1150@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LF6L63Ogvb2FfHfGhZYvyj3i20Afv0Pc
X-Proofpoint-ORIG-GUID: G65mkG3bDvg6WlUnehmw0MC89cSMrysO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/21 12:36 PM, Thomas Huth wrote:
> On 28/07/2021 12.32, Claudio Imbrenda wrote:
>> On Wed, 28 Jul 2021 10:13:26 +0000
>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>
>>> Seems like I missed adding them.
>>>
>>> The s390x/sieve.c one is a bit of a head scratcher since it came with
>>> the first commit but I assume it's lpgl2-only since that's what the
>>> COPYRIGHT file said then.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>   lib/s390x/uv.c   |  9 +++++++++
>>>   s390x/mvpg-sie.c |  9 +++++++++
>>>   s390x/sie.c      | 10 ++++++++++
>>>   x86/sieve.c      |  5 +++++
>>>   4 files changed, 33 insertions(+)
> [...]
>>> diff --git a/x86/sieve.c b/x86/sieve.c
>>> index 8150f2d9..b89d5f80 100644
>>> --- a/x86/sieve.c
>>> +++ b/x86/sieve.c
>>> @@ -1,3 +1,8 @@
>>> +/* SPDX-License-Identifier: LGPL-2.0-only */
>>
>> do you really need to fix something in the x86 directory? (even though
>> it is also used on other archs)
> 
> I just realized that s390x/sieve.c is just a symlink, not a copy of the file :-)

You're not the only one...

> 
>> maybe you can split out this as a separate patch, so s390x stuff is
>> more self contained, and others can then discuss the sieve.c patch
>> separately if needed?
> 
> That might make sense, indeed.

Yup will do

> 
>   Thomas
> 

