Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B045D8FC
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 02:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfGCAcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 20:32:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46774 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727169AbfGCAce (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jul 2019 20:32:34 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62K2ilv005541
        for <kvm@vger.kernel.org>; Tue, 2 Jul 2019 16:04:57 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tgaryfjbt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 16:04:56 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <walling@linux.ibm.com>;
        Tue, 2 Jul 2019 21:04:56 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 2 Jul 2019 21:04:54 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x62K4rGU46924144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Jul 2019 20:04:53 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1049A28059;
        Tue,  2 Jul 2019 20:04:53 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F409728058;
        Tue,  2 Jul 2019 20:04:52 +0000 (GMT)
Received: from [9.63.14.98] (unknown [9.63.14.98])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Jul 2019 20:04:52 +0000 (GMT)
Subject: Re: [PATCH v5 2/2] s390/kvm: diagnose 318 handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>, cohuck@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <1561475022-18348-1-git-send-email-walling@linux.ibm.com>
 <1561475022-18348-3-git-send-email-walling@linux.ibm.com>
 <19c73246-48dd-ddc6-c5b1-b93f15cbf2f0@redhat.com>
 <17fe3423-91b1-2351-54cb-26cd9e1b0e3f@de.ibm.com>
 <dd1f4c39-9937-b223-adc8-01a764cf9462@linux.ibm.com>
 <a7f4b3aa-b9d8-59b3-22c4-251acc2ef20f@redhat.com>
 <ae6e3725-2d5e-3fc6-96bf-7875fb14d919@linux.ibm.com>
 <78617ca5-d822-ea4e-60ef-7a545b23ef15@de.ibm.com>
From:   Collin Walling <walling@linux.ibm.com>
Date:   Tue, 2 Jul 2019 16:04:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <78617ca5-d822-ea4e-60ef-7a545b23ef15@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070220-0052-0000-0000-000003D978AB
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011367; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01226513; UDB=6.00645712; IPR=6.01007733;
 MB=3.00027558; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-02 20:04:56
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070220-0053-0000-0000-0000618B3312
Message-Id: <3bc397ef-990e-a35f-b619-a60c526dd39e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020223
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/2/19 4:00 PM, Christian Borntraeger wrote:
> 
> 
> On 02.07.19 21:50, Collin Walling wrote:
>> On 6/26/19 10:31 AM, David Hildenbrand wrote:
>>> On 26.06.19 16:30, Collin Walling wrote:
>>>> On 6/26/19 6:28 AM, Christian Borntraeger wrote:
>>>>>
>>>>>
>>>>> On 26.06.19 11:45, David Hildenbrand wrote:
>>>>>
>>>>>>
>>>>>> BTW. there is currently no mechanism to fake absence of diag318. Should
>>>>>> we have one? (in contrast, for CMMA we have, which is also a CPU feature)
>>>>>
>>>>> Yes, we want to be able to disable diag318 via a CPU model feature. That actually
>>>>> means that the kernel must not answer this if we disable it.
>>>>>
>>>> Correct. If the guest specifies diag318=off, then the instruction
>>>> shouldn't be executed (it is fenced off in the kernel by checking the
>>>> Read SCP Info bit).
>>>
>>> But the guest *could* execute it and not get an exception.
>>>
>>
>> IIUC, you're talking about the situation where QEMU supports diag318,
>> but KVM does not. The worst case is the guest specifies diag318=on, and
>> nothing will stop the guest from attempting to execute the instruction.
>>
>> However, this is fenced in my QEMU patches. In (v5), I have this
>> following snippet:
>>
>> @@ -2323,6 +2345,13 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
>>           KVM_S390_VM_CRYPTO_ENABLE_APIE)) {
>>           set_bit(S390_FEAT_AP, model->features);
>>       }
>> +
>> +    /* if KVM supports interception of diag318, then let's provide the bit */
>> +    if (kvm_vm_check_attr(kvm_state, KVM_S390_VM_MISC,
>> +        KVM_S390_VM_MISC_DIAG318)) {
>> +        set_bit(S390_FEAT_DIAG318, model->features);
>> +    }
>> +
>>       /* strip of features that are not part of the maximum model */
>>       bitmap_and(model->features, model->features, model->def->full_feat,
>>                  S390_FEAT_MAX);
>>
>> If the guest specifies diag318=on, and KVM does *not* support emulation,
>> then the following message will be observed:
>>
>> qemu-system-s390x: Some features requested in the CPU model are not
>> available in the configuration: diag318
>>
>> and the guest will fail to start. Does this suffice?
> 
> But what happens if the guest ignores read scp info and executes diag318 anyway.
> It should get a specification exception, but it does not instead diag318 is
> executed.
> 

Hmm... I'm not following the logic here. When or how could diag318 be
executed without checking the feature bit? Are we concerned about other
hypervisors running a linux guest with diag318 enabled? Understanding
the scenario will help me follow along with this issue.

