Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B56571856
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 13:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiGLLNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 07:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiGLLNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 07:13:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B59DB197D;
        Tue, 12 Jul 2022 04:12:55 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CAcQXJ010671;
        Tue, 12 Jul 2022 11:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=d/c8z8hIzZvH4U0gTfpIhN+uvRwWJvXqTx6twBJ2R98=;
 b=GkUNvHQSBizP9F5L3jp7rY3lyEfBd9jc83pUqp+hWnSAXV+EV5TuRld50jreHcbyb1Q6
 Sb9t1tt++S52DzKGYre8vGkji1Zy2RWcOSkpFyqFoJgsNcFcmf+Z6amxeh12vASd2I+n
 v9NLQwJCNW9L/Eufpjoyv15dl09qGQbjdgDeGTCiAa17nyznjLKjSymbm3xwmfaj1PlJ
 rAUqV6PqNmim07gP89qz7SiV2g9VhF5pnkC2NWHZNgcELyfmEqsiAVxoBoMbAkjZkSh0
 cjTNtFbyIYyftAcd0uQMN17SwmOHpz+be1KL+fBYEEMcuzjXoogL57fgR8SFAiUn/iqs lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h96qf9qhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 11:12:54 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26CB16ZU005036;
        Tue, 12 Jul 2022 11:12:54 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h96qf9qgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 11:12:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26CB8ES8026802;
        Tue, 12 Jul 2022 11:12:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3h71a8v2fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 11:12:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26CBCmYT14877130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 11:12:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14455204E;
        Tue, 12 Jul 2022 11:12:48 +0000 (GMT)
Received: from [9.171.74.72] (unknown [9.171.74.72])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0BCC05204F;
        Tue, 12 Jul 2022 11:12:47 +0000 (GMT)
Message-ID: <0c73fc23-2cfe-86c6-b91d-77a73bc435b4@linux.ibm.com>
Date:   Tue, 12 Jul 2022 13:17:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v12 3/3] KVM: s390: resetting the Topology-Change-Report
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220711084148.25017-1-pmorel@linux.ibm.com>
 <20220711084148.25017-4-pmorel@linux.ibm.com>
 <58016efc-9053-b743-05d6-4ace4dcdc2a8@linux.ibm.com>
 <a268d8b7-bbd8-089d-896c-e4e3e4167e46@linux.ibm.com>
 <87c5514b-4971-b283-912c-573ab1b4d636@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <87c5514b-4971-b283-912c-573ab1b4d636@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tudk723zFjck8ttfIJ15LaKdI9fMCpbs
X-Proofpoint-GUID: ns2BSKgHQNf8AdyWdkpFq7tHwdKrz7BN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_05,2022-07-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/22 10:47, Janis Schoetterl-Glausch wrote:
> On 7/12/22 09:24, Pierre Morel wrote:
>>
>>
>> On 7/11/22 15:22, Janis Schoetterl-Glausch wrote:
>>> On 7/11/22 10:41, Pierre Morel wrote:
>>>> During a subsystem reset the Topology-Change-Report is cleared.
>>>>
>>>> Let's give userland the possibility to clear the MTCR in the case
>>>> of a subsystem reset.
>>>>
>>>> To migrate the MTCR, we give userland the possibility to
>>>> query the MTCR state.
>>>>
>>>> We indicate KVM support for the CPU topology facility with a new
>>>> KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>
>>> Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>>
>>
>> Thanks!
>>
>>> See nits/comments below.
>>>
>>>> ---
>>>>    Documentation/virt/kvm/api.rst   | 25 ++++++++++++++
>>>>    arch/s390/include/uapi/asm/kvm.h |  1 +
>>>>    arch/s390/kvm/kvm-s390.c         | 56 ++++++++++++++++++++++++++++++++
>>>>    include/uapi/linux/kvm.h         |  1 +
>>>>    4 files changed, 83 insertions(+)
>>>>
>>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>>> index 11e00a46c610..5e086125d8ad 100644
>>>> --- a/Documentation/virt/kvm/api.rst
>>>> +++ b/Documentation/virt/kvm/api.rst
>>>> @@ -7956,6 +7956,31 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>>>>    When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
>>>>    type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
>>>>    +8.37 KVM_CAP_S390_CPU_TOPOLOGY
>>>> +------------------------------
>>>> +
>>>> +:Capability: KVM_CAP_S390_CPU_TOPOLOGY
>>>> +:Architectures: s390
>>>> +:Type: vm
>>>> +
>>>> +This capability indicates that KVM will provide the S390 CPU Topology
>>>> +facility which consist of the interpretation of the PTF instruction for
>>>> +the function code 2 along with interception and forwarding of both the
>>>> +PTF instruction with function codes 0 or 1 and the STSI(15,1,x)
>>>
>>> Is the architecture allowed to extend STSI without a facility?
>>> If so, if we say here that STSI 15.1.x is passed to user space, then
>>> I think we should have a
>>>
>>> if (sel1 != 1)
>>>      goto out_no_data;
>>>
>>> or maybe even
>>>
>>> if (sel1 != 1 || sel2 < 2 || sel2 > 6)
>>>      goto out_no_data;
>>>
>>> in priv.c
>>
>> I am not a big fan of doing everything in the kernel.
>> Here we have no performance issue since it is an error of the guest if it sends a wrong selector.
>>
> I agree, but I didn't suggest it for performance reasons.

Yes, and that is why I do not agree ;)

> I was thinking about future proofing, that is if the architecture is extended.
> We don't know if future extensions are best handled in the kernel or user space,
> so if we prevent it from going to user space, we can defer the decision to when we know more.

If future extensions are better handle in kernel we will handle them in 
kernel, obviously, in this case we will need a patch.

If it is not better handle in kernel we will handle the extensions in 
userland and we will not need a kernel patch making the update of the 
virtual architecture easier and faster.

If we prohibit the extensions in kernel we will need a kernel patch in 
both cases and a userland patch if it is not completely handled in kernel.

In userland we check any wrong selector before the instruction goes back 
to the guest.

> But that's only relevant if STSI can be extended without a capability, which is why I asked about that.

Logicaly any change, extension, in the architecture should be signaled 
by a facility bit or something.

> 
>> Even testing the facility or PV in the kernel is for my opinion arguable in the case we do not do any treatment in the kernel.
>>
>> I do not see what it brings to us, it increase the LOCs and makes the implementation less easy to evolve.
>>
>>
>>>
>>>> +instruction to the userland hypervisor.
>>>> +
>>>> +The stfle facility 11, CPU Topology facility, should not be indicated
>>>> +to the guest without this capability.
>>>> +
>>>> +When this capability is present, KVM provides a new attribute group
>>>> +on vm fd, KVM_S390_VM_CPU_TOPOLOGY.
>>>> +This new attribute allows to get, set or clear the Modified Change
>>>
>>> get or set, now that there is no explicit clear anymore.
>>
>> Yes now it is a set to 0 but the action of clearing remains.
>>
>>>
>>>> +Topology Report (MTCR) bit of the SCA through the kvm_device_attr
>>>> +structure.> +
>>>> +When getting the Modified Change Topology Report value, the attr->addr
>>>
>>> When getting/setting the...
>>>
>>>> +must point to a byte where the value will be stored.
>>>
>>> ... will be stored/retrieved from.
>>
>> OK
> 
> Wait no, I didn't get how that works. You're passing the value via attr->attr, not reading it from addr.

:) OK

>>
>>
>>>> +
>>>>    9. Known KVM API problems
>>>>    =========================
>>>>    diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>>>> index 7a6b14874d65..a73cf01a1606 100644
>>>> --- a/arch/s390/include/uapi/asm/kvm.h
>>>> +++ b/arch/s390/include/uapi/asm/kvm.h
>>>> @@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
>>>>    #define KVM_S390_VM_CRYPTO        2
>>>>    #define KVM_S390_VM_CPU_MODEL        3
>>>>    #define KVM_S390_VM_MIGRATION        4
>>>> +#define KVM_S390_VM_CPU_TOPOLOGY    5
>>>>      /* kvm attributes for mem_ctrl */
>>>>    #define KVM_S390_VM_MEM_ENABLE_CMMA    0
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index 70436bfff53a..b18e0b940b26 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -606,6 +606,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>>        case KVM_CAP_S390_PROTECTED:
>>>>            r = is_prot_virt_host();
>>>>            break;
>>>> +    case KVM_CAP_S390_CPU_TOPOLOGY:
>>>> +        r = test_facility(11);
>>>> +        break;
>>>>        default:
>>>>            r = 0;
>>>>        }
>>>> @@ -817,6 +820,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>>>            icpt_operexc_on_all_vcpus(kvm);
>>>>            r = 0;
>>>>            break;
>>>> +    case KVM_CAP_S390_CPU_TOPOLOGY:
>>>> +        r = -EINVAL;
>>>> +        mutex_lock(&kvm->lock);
>>>> +        if (kvm->created_vcpus) {
>>>> +            r = -EBUSY;
>>>> +        } else if (test_facility(11)) {
>>>> +            set_kvm_facility(kvm->arch.model.fac_mask, 11);
>>>> +            set_kvm_facility(kvm->arch.model.fac_list, 11);
>>>> +            r = 0;
>>>> +        }
>>>> +        mutex_unlock(&kvm->lock);
>>>> +        VM_EVENT(kvm, 3, "ENABLE: CAP_S390_CPU_TOPOLOGY %s",
>>>> +             r ? "(not available)" : "(success)");
>>>> +        break;
>>>>        default:
>>>>            r = -EINVAL;
>>>>            break;
>>>> @@ -1717,6 +1734,36 @@ static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
>>>>        read_unlock(&kvm->arch.sca_lock);
>>>>    }
>>>>    +static int kvm_s390_set_topology(struct kvm *kvm, struct kvm_device_attr *attr)
>>>
>>> kvm_s390_set_topology_changed maybe?
>>> kvm_s390_get_topology_changed below then.
>>
> 
> I won't insist on it, but I do think it's more readable.

OK, I can change it

> 
>> No strong opinion, if you prefer I change this.
>>
>>>
>>>> +{
>>>> +    if (!test_kvm_facility(kvm, 11))
>>>> +        return -ENXIO;
>>>> +
>>>> +    kvm_s390_update_topology_change_report(kvm, !!attr->attr);
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
>>>> +{
>>>> +    union sca_utility utility;
>>>> +    struct bsca_block *sca;
>>>> +    __u8 topo;
>>>> +
>>>> +    if (!test_kvm_facility(kvm, 11))
>>>> +        return -ENXIO;
>>>> +
>>>> +    read_lock(&kvm->arch.sca_lock);
>>>> +    sca = kvm->arch.sca;
>>>> +    utility.val = READ_ONCE(sca->utility.val);
>>>
>>> I don't think you need the READ_ONCE anymore, now that there is a lock it should act as a compile barrier.
>>
>> I think you are right.
>>
>>>> +    read_unlock(&kvm->arch.sca_lock);
>>>> +    topo = utility.mtcr;
>>>> +
>>>> +    if (copy_to_user((void __user *)attr->addr, &topo, sizeof(topo)))
>>>
>>> Why void not u8?
>>
>> I like to say we write on "topo" with the size of "topo".
>> So we do not need to verify the effective size of topo.
>> But I understand, it is a UAPI, setting u8 in the copy_to_user makes sense too.
>> For my personal opinion, I would have prefer that userland tell us the size it awaits even here, for this special case, since we use a byte, we can not do really wrong.
> You're right, it doesn't make a difference.
> What about doing put_user(topo, (u8 *)attr->addr)), seems more straight forward.

OK

>>
>>>
>>>> +        return -EFAULT;
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>> [...]
>>>
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
