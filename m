Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A04D42C143
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 15:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhJMNXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 09:23:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229535AbhJMNXY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 09:23:24 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DD1PaN003559;
        Wed, 13 Oct 2021 09:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nJbQ5F+J67KJscNa8cetmNNRiv/rN9eSUYvHsX7DVr4=;
 b=mvhfu62g0XFBqHVE5GlN2qjRrJreYWG/Y/IiakSScLO6nLZqF+XcAcr40pGCMtCl8wiq
 gNbnm5APO7wqgmGEN99R0cP33Hkdighmo+HA5YtKL7bxAdwkf9ajFGG4T7jrrPYeNVgL
 PqoQkEe7jA8ix/xUbDROnLwgS3ZAbFZgOpLuYKzt0HrjpwhvP7n9tc1QnFKFGUhfHjQy
 oeT8OLpXadHiZGXjf8cHCq/b37UEqGpMeeCpb8qJiTWx4G8qXJwyG+RyIjKLsIEzQeCO
 RX8ivSxBvYKls70TTnU4RGKACoTOE0SvtsiGNT/WlhY2raxudmqxq8F2DTyG7FQMpHHg dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnmn9psmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 09:21:21 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19DCxFnf024722;
        Wed, 13 Oct 2021 09:21:20 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnmn9psks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 09:21:20 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DDI0fg023061;
        Wed, 13 Oct 2021 13:21:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bjk9ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 13:21:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DDL17Y57737700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 13:21:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E2504C052;
        Wed, 13 Oct 2021 13:21:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD0A64C04E;
        Wed, 13 Oct 2021 13:21:00 +0000 (GMT)
Received: from [9.145.94.172] (unknown [9.145.94.172])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 13:21:00 +0000 (GMT)
Message-ID: <076683e7-ebe2-87b4-132a-357c748f7ff7@linux.ibm.com>
Date:   Wed, 13 Oct 2021 15:21:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH 2/2] lib: s390x: snippet.h: Add a few
 constants that will make our life easier
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
References: <20211013102722.17160-1-frankja@linux.ibm.com>
 <20211013102722.17160-3-frankja@linux.ibm.com>
 <9a59c435-f717-784f-48c0-13ff9c3f0251@linux.vnet.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <9a59c435-f717-784f-48c0-13ff9c3f0251@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Kf27p2f644oprauZFKh_2WXzDdO9NOgL
X-Proofpoint-ORIG-GUID: SAontQTOd70_KjjxCBg8E2HBUFW-vr78
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_05,2021-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/13/21 15:15, Janis Schoetterl-Glausch wrote:
> On 10/13/21 12:27 PM, Janosch Frank wrote:
>> The variable names for the snippet objects are of gigantic length so
>> let's define a few macros to make them easier to read.
>>
>> Also add a standard PSW which should be used to start the snippet.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/snippet.h | 40 ++++++++++++++++++++++++++++++++++++++++
>>   s390x/mvpg-sie.c    | 13 ++++++-------
>>   2 files changed, 46 insertions(+), 7 deletions(-)
>>   create mode 100644 lib/s390x/snippet.h
>>
>> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
>> new file mode 100644
>> index 00000000..9ead4fe3
>> --- /dev/null
>> +++ b/lib/s390x/snippet.h
>> @@ -0,0 +1,40 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Snippet definitions
>> + *
>> + * Copyright IBM, Corp. 2021
>                     ^
> That comma should not be there.

Right, copied that over from css.h.
Fixed that and wrote a reminder to fix sclp.h and css.h in v2

>> + * Author: Janosch Frank <frankja@linux.ibm.com>
>> + */
>> +
> [...]
> 

