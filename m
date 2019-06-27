Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B8257C8E
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 08:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfF0Gyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 02:54:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21086 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726052AbfF0Gyn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jun 2019 02:54:43 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5R6qadN056258
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 02:54:41 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tcr8a9urf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 02:54:41 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 27 Jun 2019 07:54:39 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 07:54:36 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5R6sXNQ39715232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 06:54:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A06CD11C054;
        Thu, 27 Jun 2019 06:54:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 253AE11C050;
        Thu, 27 Jun 2019 06:54:33 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.87])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 06:54:33 +0000 (GMT)
Subject: Re: [PATCH v9 4/4] s390: ap: kvm: Enable PQAP/AQIC facility for the
 guest
To:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, pasic@linux.ibm.com,
        david@redhat.com, heiko.carstens@de.ibm.com, freude@linux.ibm.com,
        mimu@linux.ibm.com
References: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
 <1558452877-27822-5-git-send-email-pmorel@linux.ibm.com>
 <69ca50bd-3f5c-98b1-3b39-04af75151baf@de.ibm.com>
 <25a9ff69-47f0-fcba-e1fe-f0cc9914acba@de.ibm.com>
 <58cdbf55-6853-0523-eea9-5d07dbfb7bd0@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Thu, 27 Jun 2019 08:54:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <58cdbf55-6853-0523-eea9-5d07dbfb7bd0@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19062706-0028-0000-0000-0000037DF512
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062706-0029-0000-0000-0000243E1DA1
Message-Id: <b103b619-9aab-b5f9-0c79-9f4399f69b49@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.06.19 23:12, Tony Krowiak wrote:
> On 6/25/19 4:15 PM, Christian Borntraeger wrote:
>>
>>
>> On 25.06.19 22:13, Christian Borntraeger wrote:
>>>
>>>
>>> On 21.05.19 17:34, Pierre Morel wrote:
>>>> AP Queue Interruption Control (AQIC) facility gives
>>>> the guest the possibility to control interruption for
>>>> the Cryptographic Adjunct Processor queues.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>> ---
>>>>   arch/s390/tools/gen_facilities.c | 1 +
>>>>   1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
>>>> index 61ce5b5..aed14fc 100644
>>>> --- a/arch/s390/tools/gen_facilities.c
>>>> +++ b/arch/s390/tools/gen_facilities.c
>>>> @@ -114,6 +114,7 @@ static struct facility_def facility_defs[] = {
>>>>           .bits = (int[]){
>>>>               12, /* AP Query Configuration Information */
>>>>               15, /* AP Facilities Test */
>>>> +            65, /* AP Queue Interruption Control */
>>>>               156, /* etoken facility */
>>>>               -1  /* END */
>>>>           }
>>>>
>>>
>>> I think we should only set stfle.65 if we have the aiv facility (Because we do not
>>> have a GISA otherwise)
> 
> My assumption here is that you are taking the line added above
> (STFLE.65) out and replacing with one of the two suggestions
> below.

Yes, I want to replace this hunk.

 I am quite fuzzy on how all of this CPU model stuff works,
> but I am thinking that the above makes STFLE.65 available to be
> set via the CPU model (i.e., aqic=on on the QEMU command line) as
> long as it is supported by the host.

Yes, it makes it available when the host has stfle.65. But at the same
time it does not look if the adapter interruption virtualization facility
is available. For example for vsie the guest2 will enable stfle.65 for its
guests, but we do not support AIV.

 By taking that line out, we
> are relying on one of the suggestions below to make STFLE.65
> available to the guest only if AIV facility is available. Does that
> sound about right?
> 
> If that is the case, then wouldn't we also have to add a check to make
> sure that STFLE.65 is available on the host (i.e., test_facility(65))?

I think AIV in level n is enough to provide STFLE.65 in level n+1. 
On the other hand also checking for stfle.65 does not hurt.


> 
> 
>>>
>>> So something like this instead?
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index 28ebd64..1501cd6 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -2461,6 +2461,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>>                  set_kvm_facility(kvm->arch.model.fac_list, 147);
>>>          }
>>>   +       if (css_general_characteristics.aiv)
>>> +               set_kvm_facility(kvm->arch.model.fac_mask, 65);
>>> +
>>>          kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
>>>          kvm->arch.model.ibc = sclp.ibc & 0x0fff;
>>>  
>>
>> Maybe even just piggyback on gisa init (it will bail out early).
> 
> It could also go in the kvm_s390_crypto_init() function since it
> is related to crypto.
> 
>>
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index 9dde4d7..9182a04 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -3100,6 +3100,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
>>          gi->timer.function = gisa_vcpu_kicker;
>>          memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
>>          gi->origin->next_alert = (u32)(u64)gi->origin;
>> +       set_kvm_facility(kvm->arch.model.fac_mask, 65);
>>          VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
>>   }
>>  
> 

