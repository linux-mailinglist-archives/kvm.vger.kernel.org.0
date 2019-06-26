Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652515735D
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 23:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfFZVMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 17:12:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726227AbfFZVMh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jun 2019 17:12:37 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QL8CEp129045;
        Wed, 26 Jun 2019 17:12:17 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tce4q5cqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 17:12:17 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5QL9xDj024155;
        Wed, 26 Jun 2019 21:12:16 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 2t9by79rgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 21:12:16 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5QLCCrZ52232604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 21:12:12 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 038F013604F;
        Wed, 26 Jun 2019 21:12:12 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D16E136055;
        Wed, 26 Jun 2019 21:12:11 +0000 (GMT)
Received: from [9.60.84.60] (unknown [9.60.84.60])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jun 2019 21:12:11 +0000 (GMT)
Subject: Re: [PATCH v9 4/4] s390: ap: kvm: Enable PQAP/AQIC facility for the
 guest
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
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
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <58cdbf55-6853-0523-eea9-5d07dbfb7bd0@linux.ibm.com>
Date:   Wed, 26 Jun 2019 17:12:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <25a9ff69-47f0-fcba-e1fe-f0cc9914acba@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260245
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/25/19 4:15 PM, Christian Borntraeger wrote:
> 
> 
> On 25.06.19 22:13, Christian Borntraeger wrote:
>>
>>
>> On 21.05.19 17:34, Pierre Morel wrote:
>>> AP Queue Interruption Control (AQIC) facility gives
>>> the guest the possibility to control interruption for
>>> the Cryptographic Adjunct Processor queues.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> ---
>>>   arch/s390/tools/gen_facilities.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
>>> index 61ce5b5..aed14fc 100644
>>> --- a/arch/s390/tools/gen_facilities.c
>>> +++ b/arch/s390/tools/gen_facilities.c
>>> @@ -114,6 +114,7 @@ static struct facility_def facility_defs[] = {
>>>   		.bits = (int[]){
>>>   			12, /* AP Query Configuration Information */
>>>   			15, /* AP Facilities Test */
>>> +			65, /* AP Queue Interruption Control */
>>>   			156, /* etoken facility */
>>>   			-1  /* END */
>>>   		}
>>>
>>
>> I think we should only set stfle.65 if we have the aiv facility (Because we do not
>> have a GISA otherwise)

My assumption here is that you are taking the line added above
(STFLE.65) out and replacing with one of the two suggestions
below. I am quite fuzzy on how all of this CPU model stuff works,
but I am thinking that the above makes STFLE.65 available to be
set via the CPU model (i.e., aqic=on on the QEMU command line) as
long as it is supported by the host. By taking that line out, we
are relying on one of the suggestions below to make STFLE.65
available to the guest only if AIV facility is available. Does that
sound about right?

If that is the case, then wouldn't we also have to add a check to make
sure that STFLE.65 is available on the host (i.e., test_facility(65))?




>>
>> So something like this instead?
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 28ebd64..1501cd6 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2461,6 +2461,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>                  set_kvm_facility(kvm->arch.model.fac_list, 147);
>>          }
>>   
>> +       if (css_general_characteristics.aiv)
>> +               set_kvm_facility(kvm->arch.model.fac_mask, 65);
>> +
>>          kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
>>          kvm->arch.model.ibc = sclp.ibc & 0x0fff;
>>   
>>
> 
> Maybe even just piggyback on gisa init (it will bail out early).

It could also go in the kvm_s390_crypto_init() function since it
is related to crypto.

> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 9dde4d7..9182a04 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3100,6 +3100,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
>          gi->timer.function = gisa_vcpu_kicker;
>          memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
>          gi->origin->next_alert = (u32)(u64)gi->origin;
> +       set_kvm_facility(kvm->arch.model.fac_mask, 65);
>          VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
>   }
>   
> 

