Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90FB10D5F6
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 14:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfK2NEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 08:04:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbfK2NEU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 08:04:20 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xATD3Htu090060
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 08:04:19 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wk2393u60-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 08:04:19 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 29 Nov 2019 13:04:17 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 29 Nov 2019 13:04:14 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xATD4DVf57540644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Nov 2019 13:04:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 195814C050;
        Fri, 29 Nov 2019 13:04:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7A874C052;
        Fri, 29 Nov 2019 13:04:12 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.75])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Nov 2019 13:04:12 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/9] s390x: Define the PSW bits
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, cohuck@redhat.com
References: <7abb4725-b814-8b43-8a4f-e0e2cf7a44f8@linux.ibm.com>
 <30DD27E7-BE6E-4986-AD69-7718E6B9A730@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 29 Nov 2019 14:04:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <30DD27E7-BE6E-4986-AD69-7718E6B9A730@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19112913-4275-0000-0000-0000038804B3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112913-4276-0000-0000-0000389B99C7
Message-Id: <ce7a6a0b-bf9e-cfd6-c517-3aa15ed7a771@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-29_03:2019-11-29,2019-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 adultscore=0 mlxlogscore=967
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911290114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-11-28 20:48, David Hildenbrand wrote:
> 
> 
>> Am 28.11.2019 um 20:16 schrieb Pierre Morel <pmorel@linux.ibm.com>:
>>
>> ﻿
>>> On 2019-11-28 15:36, David Hildenbrand wrote:
>>>> On 28.11.19 13:46, Pierre Morel wrote:
>>>> Let's define the PSW bits  explicitly, it will clarify their
>>>> usage.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>   lib/s390x/asm/arch_bits.h | 20 ++++++++++++++++++++
>>>>   lib/s390x/asm/arch_def.h  |  6 ++----
>>> I'm sorry, but I don't really see a reason to move these 4/5 defines to
>>> a separate header. Can you just keep them in arch_def.h and extend?
>>
>> no because arch_def.h contains C structures and inline.
> 
> (resend because the iOS Mail app does crazy html thingies)
> 
> You‘re looking for
> 
> #ifndef __ASSEMBLER__
> ...
> 
> See lib/s390x/asm/sigp.h
> 

Yes, better. :)

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

