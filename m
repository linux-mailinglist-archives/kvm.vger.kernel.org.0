Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A9E4228E1
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbhJENyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:54:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235461AbhJENxJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:53:09 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195D46b9024082;
        Tue, 5 Oct 2021 09:51:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Dy6TW5xK4VAm8EwBGzAHuTpTVR+6CeI5dIIwR3iqHTc=;
 b=QgAmKh9FhgwUkp6yAKVk7gHmOTc4OV1+/zTx+yt3vJuwcyqWHkxn2x6Z8gepbnZFMcZP
 quA8VZQUVgVOkGY6BvdwxuRlwNe/t6TaQn+vK6foL0nKVYjeOoXoQt3Cz2lS8Xs1WyrX
 PrSH6gZp64xEpal3bGnUJtQFgUwyPWvvDCH82RLN4R4ZxB/HwtRC6QsAZyZTnUOhqwkN
 wlgszgtOOhYVGoP5Cfv5pP+13IKCIo3v5v2ZVhZvMrIqihyuhXm1ZBS14mRjvBzFpXeg
 +M0eVdxO0yR58eQ7aIeCc2ywzbrlZFRrizdGplypXNhURBKBe/6gDx6dmYeoG6RlTFyD dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgnm9bws7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:51:17 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195DZ1pO025133;
        Tue, 5 Oct 2021 09:51:17 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgnm9bwru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:51:17 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195Dl3lf001700;
        Tue, 5 Oct 2021 13:51:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3beepjh1x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:51:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195DpBaZ36962772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:51:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA7AC5204F;
        Tue,  5 Oct 2021 13:51:11 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.6.58])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 389875204E;
        Tue,  5 Oct 2021 13:51:11 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: Remove assert from
 arch_def.h
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
 <20211005091153.1863139-2-scgl@linux.ibm.com>
 <0ab2acc7-47da-59fc-c959-1d61417ca181@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <dd2b1cd2-6d97-0d3a-8db2-f33dcc35f226@linux.vnet.ibm.com>
Date:   Tue, 5 Oct 2021 15:51:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0ab2acc7-47da-59fc-c959-1d61417ca181@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kmAvN72YB8UFJZ2fObAqDC2Fr2J8koV1
X-Proofpoint-ORIG-GUID: 02eOEvbySAjWfxbX_pFl5TUf_1LQVtb5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/21 2:51 PM, Janosch Frank wrote:
> On 10/5/21 11:11, Janis Schoetterl-Glausch wrote:
>> Do not use asserts in arch_def.h so it can be included by snippets.
>> The caller in stsi.c does not need to be adjusted, returning -1 causes
>> the test to fail.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 
> A few days ago I had a minute to investigate what needed to be added to be able to link the libcflat. Fortunately it wasn't a lot and I'll try to post it this week so this patch can hopefully be dropped.

One could argue that cc being != 0 is part of the test and so should go through report() and not assert().
Which happens naturally, since the caller will likely compare it to some positive expected value.
> 
>> ---
>>   lib/s390x/asm/arch_def.h | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 302ef1f..4167e2b 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -334,7 +334,7 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
>>       return cc;
>>   }
>>   -static inline unsigned long stsi_get_fc(void)
>> +static inline int stsi_get_fc(void)
>>   {
>>       register unsigned long r0 asm("0") = 0;
>>       register unsigned long r1 asm("1") = 0;
>> @@ -346,7 +346,8 @@ static inline unsigned long stsi_get_fc(void)
>>                : "+d" (r0), [cc] "=d" (cc)
>>                : "d" (r1)
>>                : "cc", "memory");
>> -    assert(!cc);
>> +    if (cc != 0)
>> +        return -1;
>>       return r0 >> 28;
>>   }
>>  
> 

