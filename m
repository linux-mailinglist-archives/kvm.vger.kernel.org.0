Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8103D38A1
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 12:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhGWJoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 05:44:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230238AbhGWJop (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 05:44:45 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NA2xmG121913;
        Fri, 23 Jul 2021 06:25:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N/koVr3+xhFPghqYOt9mOVwoH+tNbDMOMFc9SDer/Ss=;
 b=plzuDKZQld9znk+xBx3W5/IZWhfDGUrVj/gszu+drYs5HGamMsapCz5JVOstXkggQFix
 u1LKzVTcTp39AmBtrjjQ5snNgX8a8F4n8y+IVXPaB+QO7buMyILE253vlc3Od98pwI+j
 L1tGxmT7TKndK/vvHiJHx1i/lpY99ycN2ksAEobI2UxQkzkgl8LiosqeNjHvx595J/Yn
 A/07aOh1heYUjHTRHUeAObTh01MNzhpc/EXIjP8enPxMtMQQtOWrI866k5rirlkNnRaa
 7LV4VfcZWyVyjAufZikbiWO/ZzYsXOuaHUH/d/Xd6bw19wWp47qENmooEvJBeKb8Xx3u UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39yuj4rsuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 06:25:19 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16NA31Cp122076;
        Fri, 23 Jul 2021 06:25:19 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39yuj4rsub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 06:25:18 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16NA7MKU012133;
        Fri, 23 Jul 2021 10:10:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 39xhx4951t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 10:10:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NAA4GL24445200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 10:10:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99409AE045;
        Fri, 23 Jul 2021 10:10:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07C87AE04D;
        Fri, 23 Jul 2021 10:10:04 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.58.144])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Jul 2021 10:10:03 +0000 (GMT)
Subject: Re: [PATCH v2 2/2] s390:kvm: Topology expose TOPOLOGY facility
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <1626973353-17446-1-git-send-email-pmorel@linux.ibm.com>
 <1626973353-17446-3-git-send-email-pmorel@linux.ibm.com>
 <7163cf4a-479a-3121-2261-cfb6e4024d0c@de.ibm.com> <87wnph5rz7.fsf@redhat.com>
 <46229585-507d-70a2-cc60-c06fb172fbfd@de.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <68c2e0d0-b591-7701-700c-400f1f040ca9@linux.ibm.com>
Date:   Fri, 23 Jul 2021 12:10:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <46229585-507d-70a2-cc60-c06fb172fbfd@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FggXFHKmBJgcV2M6_fFBljP3kKkKCDJE
X-Proofpoint-GUID: xJDIfJDElQ0JizbTpjP8uYX8Iv33LbFg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_04:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1015 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/23/21 11:28 AM, Christian Borntraeger wrote:
> 
> 
> On 23.07.21 10:55, Cornelia Huck wrote:
>> On Fri, Jul 23 2021, Christian Borntraeger <borntraeger@de.ibm.com> 
>> wrote:
>>
>>> On 22.07.21 19:02, Pierre Morel wrote:
>>>> We add a KVM extension KVM_CAP_S390_CPU_TOPOLOGY to tell the
>>>> userland hypervisor it is safe to activate the CPU Topology facility.
>>>
>>> I think the old variant of using the CPU model was actually better.
>>> It was just the patch description that was wrong.
>>
>> I thought we wanted a cap that userspace can enable to get ptf
>> intercepts? I'm confused.
>>
> 
> PTF goes to userspace in any case as every instruction that is
> not handled by kvm and where interpretion is not enabled.
> Now, having said that, we actually want PTF interpretion to be enabled
> for "Check topology-change status" as this is supposed to be a fast
> operation. Some OSes do query that in their interrupt handlers.
> 

An old QEMU getting the PTF instruction will send a OPERATION exception 
to the guest if the facility 11 is actzivated.
Facility 11 is in QEMU since GAEN10_GA1, if I enable the facility in the 
CPU model all cpu model starting with GEN10_GA1 will panic on PTF.

So I think we need the capability so that new QEMU enable the facility 
once it has the right handling for PTF.


> 
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    arch/s390/kvm/kvm-s390.c | 1 +
>>>>    include/uapi/linux/kvm.h | 1 +
>>>>    2 files changed, 2 insertions(+)
>>>>
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index b655a7d82bf0..8c695ee79612 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -568,6 +568,7 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>>> *kvm, long ext)
>>>>        case KVM_CAP_S390_VCPU_RESETS:
>>>>        case KVM_CAP_SET_GUEST_DEBUG:
>>>>        case KVM_CAP_S390_DIAG318:
>>>> +    case KVM_CAP_S390_CPU_TOPOLOGY:
>>>>            r = 1;
>>>>            break;
>>>>        case KVM_CAP_SET_GUEST_DEBUG2:
>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>> index d9e4aabcb31a..081ce0cd44b9 100644
>>>> --- a/include/uapi/linux/kvm.h
>>>> +++ b/include/uapi/linux/kvm.h
>>>> @@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
>>>>    #define KVM_CAP_BINARY_STATS_FD 203
>>>>    #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>>>>    #define KVM_CAP_ARM_MTE 205
>>>> +#define KVM_CAP_S390_CPU_TOPOLOGY 206
>>>>    #ifdef KVM_CAP_IRQ_ROUTING
>>>>
>>
>> Regardless of what we end up with: we need documentation for any new cap
>> :)
>>

-- 
Pierre Morel
IBM Lab Boeblingen
