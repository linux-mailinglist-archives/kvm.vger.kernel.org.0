Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4FE3C9DD7
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 13:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhGOLkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 07:40:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30600 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229862AbhGOLkE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 07:40:04 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FBY6Aq121744;
        Thu, 15 Jul 2021 07:37:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uzyiFYZM2o8mNLNpOQxYTPq/BcvkTehjVFUibpHLdeg=;
 b=qhQCbfKVFp7dk98NA2MhyxdzMnyYKE0RkER0UsuRwQztpCjz+qAeLQ572sAyqeyzkvjO
 WZ5zEiYwRGDWZXd/CN6CL5ZX17OdQ7n5VlAWjh8omnYJmyDLYDlLBSQd2Om53Pbux7RN
 6GR6iP0s5mkOiaXQMSGrt3EoF93ywL1XEHXJA6NH4PHd3NFH3d62ABKVtu0kevU+HEEt
 RQUmbCjEWH3a+oKlWiuK05mR+RtOviEYews2jZDmQFK97gKOGFSiSpLeuKywGAAwBDAK
 +ZY03bri2xHpZWRY5sl/9Fosl7ore2Bkm33elxCR1q5LFtDSeHR0JxF/IzshQicOsdin mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc301j2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 07:37:11 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16FBYi0S126052;
        Thu, 15 Jul 2021 07:37:10 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc301j16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 07:37:10 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16FBWwlX010702;
        Thu, 15 Jul 2021 11:37:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 39q2tha876-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 11:37:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16FBb5Bf34341204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 11:37:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AAB0AE056;
        Thu, 15 Jul 2021 11:37:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B8A2AE045;
        Thu, 15 Jul 2021 11:37:05 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.77.125])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jul 2021 11:37:05 +0000 (GMT)
Subject: Re: [PATCH v1 1/2] s390x: KVM: accept STSI for CPU topology
 information
To:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <1626276343-22805-1-git-send-email-pmorel@linux.ibm.com>
 <1626276343-22805-2-git-send-email-pmorel@linux.ibm.com>
 <db788a8c-99a9-6d99-07ab-b49e953d91a2@redhat.com> <87fswfdiuu.fsf@redhat.com>
 <57e57ba5-62ea-f1ff-0d83-5605d57be92d@redhat.com> <87czrjdgrd.fsf@redhat.com>
 <6df8a43f-ddba-75ef-0aa7-f873bb8e0032@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <490efee4-56ee-b53b-24a6-429164bc6c69@linux.ibm.com>
Date:   Thu, 15 Jul 2021 13:37:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6df8a43f-ddba-75ef-0aa7-f873bb8e0032@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fmWLlGC7ZGdWZ-DmrdfLY9lpueA_bRXc
X-Proofpoint-ORIG-GUID: mBTGT1-ug2vIAlm6qWh2DS563mQS2rwA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-15_07:2021-07-14,2021-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 spamscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/21 12:19 PM, David Hildenbrand wrote:
> On 15.07.21 12:16, Cornelia Huck wrote:
>> On Thu, Jul 15 2021, David Hildenbrand <david@redhat.com> wrote:
>>
>>> On 15.07.21 11:30, Cornelia Huck wrote:
>>>> On Thu, Jul 15 2021, David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>>> On 14.07.21 17:25, Pierre Morel wrote:
>>>>>> STSI(15.1.x) gives information on the CPU configuration topology.
>>>>>> Let's accept the interception of STSI with the function code 15 and
>>>>>> let the userland part of the hypervisor handle it.
>>>>>>
>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>> ---
>>>>>>     arch/s390/kvm/priv.c | 11 ++++++++++-
>>>>>>     1 file changed, 10 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>>>>> index 9928f785c677..4ab5f8b7780e 100644
>>>>>> --- a/arch/s390/kvm/priv.c
>>>>>> +++ b/arch/s390/kvm/priv.c
>>>>>> @@ -856,7 +856,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>>>>         if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>>>>>             return kvm_s390_inject_program_int(vcpu, 
>>>>>> PGM_PRIVILEGED_OP);
>>>>>> -    if (fc > 3) {
>>>>>> +    if (fc > 3 && fc != 15) {
>>>>>>             kvm_s390_set_psw_cc(vcpu, 3);
>>>>>>             return 0;
>>>>>>         }
>>>>>> @@ -893,6 +893,15 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>>>>                 goto out_no_data;
>>>>>>             handle_stsi_3_2_2(vcpu, (void *) mem);
>>>>>>             break;
>>>>>> +    case 15:
>>>>>> +        if (sel1 != 1 || sel2 < 2 || sel2 > 6)
>>>>>> +            goto out_no_data;
>>>>>> +        if (vcpu->kvm->arch.user_stsi) {
>>>>>> +            insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, 
>>>>>> sel2);
>>>>>> +            return -EREMOTE;
>>>>
>>>> This bypasses the trace event further down.
>>>>
>>>>>> +        }
>>>>>> +        kvm_s390_set_psw_cc(vcpu, 3);
>>>>>> +        return 0;
>>>>>>         }
>>>>>>         if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>>>>>>             memcpy((void *)sida_origin(vcpu->arch.sie_block), 
>>>>>> (void *)mem,
>>>>> 3. User space awareness
>>>>>
>>>>> How can user space identify that we actually forward these intercepts?
>>>>> How can it enable them? The old KVM_CAP_S390_USER_STSI capability
>>>>> is not sufficient.
>>>>
>>>> Why do you think that it is not sufficient? USER_STSI basically says
>>>> "you may get an exit that tells you about a buffer to fill in some more
>>>> data for a stsi command, and we also tell you which call". If userspace
>>>> does not know what to add for a certain call, it is free to just do
>>>> nothing, and if it does not get some calls it would support, that 
>>>> should
>>>> not be a problem, either?
>>>
>>> If you migrate your VM from machine a to machine b, from kernel a to
>>> kernel b, and kernel b does not trigger exits to user space for fc=15,
>>> how could QEMU spot and catch the different capabilities to make sure
>>> the guest can continue using the feature?
>>
>> Wouldn't that imply that the USER_STSI feature, in the function-agnostic
>> way it is documented, was broken from the start?
> 
> Likely. We should have forwarded everything to user space most probably 
> and not try being smart in the kernel.
> 
>>
>> Hm. Maybe we need some kind of facility where userspace can query the
>> kernel and gets a list of the stsi subcodes it may get exits for, and
>> possibly fail to start the migration. Having a new capability to be
>> enabled for every new subcode feels like overkill. I don't think we can
>> pass a payload ("enable these subfunctions") to a cap.
> 
> Maybe a new capability that forwards everything to user space when 
> enabled, and lets user space handle errors.
> 
> Or a specialized one only to unlock fc=15.
> 

I think the lack of a good comment in patch 2/2 is the problem.
Facility 11 belong to CPU model and enables both the STSI 15 and the PFT 
instructions

Sorry about that.

-- 
Pierre Morel
IBM Lab Boeblingen
