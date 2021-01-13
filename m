Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201602F4C47
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 14:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbhAMNgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 08:36:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7354 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbhAMNgA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 08:36:00 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10DDWPQ5023643;
        Wed, 13 Jan 2021 08:35:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WhLHITp0C1LPPBQ31P+2PwF1q2KN7Zxg2U1Y1r/1a6k=;
 b=mvZ2UzLDLezBiPjlY5XFSxhDA9ABNt2LFcE9NXYV+eLP/yvtQ+j0DPP1wcQFgdL5aUYQ
 KgjckkEmolhDvXO/4K/rk4zY6jzZXFOxPL24lBcnXU/x8v2d60vBb7DYOBrffKS746Qo
 pPU7X/1ZM5Ob7mwxK+d8Z4VQamBqt2pZpLL9cFrZWP9Er47RzvCAh2DD0lkE93z6DF2d
 raoJiJo+4yyEwtukYPoHysv/64SIQfeCtyi9OaSUaDOvOzIfHxyovGwhaDxcSk9sM7tF
 JrNbdphxDt9M+6kQC0Uo4UE1hNeVnxlUAvj7EXHetQl1wAajUcG3VXLVqQgBiPM+fKOV Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3621mf0j9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 08:35:17 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10DDX9Jl030332;
        Wed, 13 Jan 2021 08:35:14 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3621mf0hq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 08:35:13 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10DDRYdG026918;
        Wed, 13 Jan 2021 13:34:56 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 35y4482mam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 13:34:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10DDYrRd42271022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 13:34:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8BF94204D;
        Wed, 13 Jan 2021 13:34:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8658942047;
        Wed, 13 Jan 2021 13:34:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.171.171])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 13:34:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 5/9] s390x: sie: Add SIE to lib
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210112132054.49756-1-frankja@linux.ibm.com>
 <20210112132054.49756-6-frankja@linux.ibm.com>
 <85cd46f1-fd09-752d-a85f-2a5907ee0802@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <9689f5a6-e1a8-d27f-d063-42006b8e7934@linux.ibm.com>
Date:   Wed, 13 Jan 2021 14:34:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <85cd46f1-fd09-752d-a85f-2a5907ee0802@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 adultscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 1:44 PM, Thomas Huth wrote:
> On 12/01/2021 14.20, Janosch Frank wrote:
>> This commit adds the definition of the SIE control block struct and
>> the assembly to execute SIE and save/restore guest registers.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/asm-offsets.c  |  11 +++
>>   lib/s390x/asm/arch_def.h |   9 ++
>>   lib/s390x/interrupt.c    |   7 ++
>>   lib/s390x/sie.h          | 197 +++++++++++++++++++++++++++++++++++++++
>>   s390x/lib.S              |  56 +++++++++++
>>   5 files changed, 280 insertions(+)
>>   create mode 100644 lib/s390x/sie.h
> [...]
>> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
>> new file mode 100644
>> index 0000000..66aa3b8
>> --- /dev/null
>> +++ b/lib/s390x/sie.h
>> @@ -0,0 +1,197 @@
>> +#ifndef SIE_H
>> +#define SIE_H
> 
> Add a SPDX license identifier at the top of the new file?

Will do

> 
> Apart from that looks ok to me.
> 
> Acked-by: Thomas Huth <thuth@redhat.com>

Thanks!

