Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEEB3BDA2C
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 17:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhGFPaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 11:30:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43820 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231773AbhGFPaH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 11:30:07 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166F2rHV126818;
        Tue, 6 Jul 2021 11:27:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZA3MCUuZJ8Q7i+oOXK13OazfWlUXRG+7zgjcNju32HA=;
 b=R33ImGdAv80xH7f4gYXX3eHFBRFiz+ZLZaoqLpNIWGMUdqovQzjnxEdvTOnN0qkMe6jx
 hO2036llZ2deoIJd5HuBo1Q0EVi/VCMaapQ/eDi4g3k7cB1STEmbYaJO1FDEK45VFZbI
 +NL3l9tvNfEdyYQPr621nEzp7ncLIPJ7o1pssRzRGSC42UcKA/qmn5B9NLGkiDfVK0WZ
 TEk4aozUqPOkf3EKURJRBcznjV1ixUVEoQvZkzT0Dub0dPAz4+8ckxCZEYcj2yocgApE
 Ccqm7ZlrP5oT/EJRJEoRpOhBUroflVWbGhgwPLU7fErWbo/7Kr4HWUbigBb3MtSCudEy OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mse5gvhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 11:27:28 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166F2rQo126847;
        Tue, 6 Jul 2021 11:27:28 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mse5gvgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 11:27:27 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166FDeEo010599;
        Tue, 6 Jul 2021 15:27:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5h9axk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 15:27:25 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166FRM3220054462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 15:27:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5585DAE06A;
        Tue,  6 Jul 2021 15:27:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0ED8AE053;
        Tue,  6 Jul 2021 15:27:21 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.60.98])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 15:27:21 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Enable specification exception interpretation
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "open list:KERNEL VIRTUAL MACHINE for s390 (KVM/s390)" 
        <kvm@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210706114714.3936825-1-scgl@linux.ibm.com>
 <87k0m3hd7h.fsf@redhat.com> <194128c1-8886-5b8b-2249-5ec58b8e7adb@de.ibm.com>
 <be78ce5d-92e4-36bd-aa28-e32db0342a44@redhat.com>
 <45690e80-5c7c-1e11-99d5-c0d1482755ad@de.ibm.com>
 <c7d61761-3426-6e44-99a8-7aa9e1cad5b6@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <8318ce18-65ea-8b4d-4df1-9f9ba79f2bb7@linux.vnet.ibm.com>
Date:   Tue, 6 Jul 2021 17:27:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c7d61761-3426-6e44-99a8-7aa9e1cad5b6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U-cQ8wgD2grxXBIP4XeYLrNPF-TTRxV7
X-Proofpoint-GUID: tVuasAeLR2I1ZKnKoNRsbodBfRXFz0DS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_07:2021-07-06,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 mlxscore=0 phishscore=0 impostorscore=0
 clxscore=1011 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/6/21 5:16 PM, David Hildenbrand wrote:
> On 06.07.21 14:02, Christian Borntraeger wrote:
>>
>>
>> On 06.07.21 13:59, David Hildenbrand wrote:
>>> On 06.07.21 13:56, Christian Borntraeger wrote:
>>>>
>>>>
>>>> On 06.07.21 13:52, Cornelia Huck wrote:
>>>>> On Tue, Jul 06 2021, Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
>>>>>
>>>>>> When this feature is enabled the hardware is free to interpret
>>>>>> specification exceptions generated by the guest, instead of causing
>>>>>> program interruption interceptions.
>>>>>>
>>>>>> This benefits (test) programs that generate a lot of specification
>>>>>> exceptions (roughly 4x increase in exceptions/sec).
>>>>>>
>>>>>> Interceptions will occur as before if ICTL_PINT is set,
>>>>>> i.e. if guest debug is enabled.
>>>>>>
>>>>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>>>>> ---
>>>>>> I'll additionally send kvm-unit-tests for testing this feature.
>>>>>>
>>>>>>     arch/s390/include/asm/kvm_host.h | 1 +
>>>>>>     arch/s390/kvm/kvm-s390.c         | 2 ++
>>>>>>     arch/s390/kvm/vsie.c             | 2 ++
>>>>>>     3 files changed, 5 insertions(+)
>>>>>
>>>>> (...)
>>>>>
>>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>>> index b655a7d82bf0..aadd589a3755 100644
>>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>>> @@ -3200,6 +3200,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>>>>>>             vcpu->arch.sie_block->ecb |= ECB_SRSI;
>>>>>>         if (test_kvm_facility(vcpu->kvm, 73))
>>>>>>             vcpu->arch.sie_block->ecb |= ECB_TE;
>>>>>> +    if (!kvm_is_ucontrol(vcpu->kvm))
>>>>>> +        vcpu->arch.sie_block->ecb |= ECB_SPECI;
>>>>>
>>>>> Does this exist for any hardware version (i.e. not guarded by a cpu
>>>>> feature?)
>>>>
>>>> Not for all hardware versions, but also no indication. The architecture
>>>> says that the HW is free to do this or not. (which makes the vsie code
>>>> simpler).
>>>
>>> I remember the architecture said at some point to never set undefined bits - and this bit is undefined on older HW generations. I might be wrong, though.
>>
>> I can confirm that this bit will be ignored on older machines. The notion of
>> never setting undefined bits comes from "you never know what this bit will
>> change in future machines". Now we know :-)
> 
> Well, okay then :)
> 
> So the plan for vSIE is to always keep it disabled? IIUC, one could similarly always forward the bit of set.

The bit does get copied for vSIE.

