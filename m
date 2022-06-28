Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C8655E76B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347012AbiF1Pjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 11:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiF1Pjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 11:39:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46232E97;
        Tue, 28 Jun 2022 08:39:52 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SFWrCl015604;
        Tue, 28 Jun 2022 15:39:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Rw+cHWta3Hs8bPqItYUe2Y+amYeSEkmKV3dERFFngHs=;
 b=PjgNh9Aiy0JMy4tA8CT2DOkdA+9tQ2if4mvUTCNi0SVPv4RgjWjoMU7fBWuvxm6A6hV/
 0Peb2IjH+W/8me9xMrV4SIgRt0l4gctAx+03l8rw2jRnFcOGn2YMsbsgU7wiaRl+cw8x
 6sWwtDDVNgsdcY/H6N4vu7SuNru7sb0If2w6l50lHqKIQEKEObUaHP+bDb8rl1bDyJs8
 dgcrTUIwHmZNPh7s/s8SDHejo5Shr5yvQEa89mb/TZz7AdNebOMUkbJC5OOt/meS+oCT
 cHEeO3qMSKxvOqAN9ONbNhdDBeS7E/tDOKk4Ekl9epGth0j9OALz6fH4Kp6O1k7vNBrY AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h04cgg5wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 15:39:51 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SFaJU5029045;
        Tue, 28 Jun 2022 15:39:50 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h04cgg5vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 15:39:50 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SFbBxE022821;
        Tue, 28 Jun 2022 15:39:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3gwt08w36g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 15:39:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SFdjGq25166196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 15:39:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B028AE045;
        Tue, 28 Jun 2022 15:39:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAA21AE04D;
        Tue, 28 Jun 2022 15:39:44 +0000 (GMT)
Received: from [9.171.41.104] (unknown [9.171.41.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 15:39:44 +0000 (GMT)
Message-ID: <19e1003f-a6cd-930c-9af3-c21ee04d0395@linux.ibm.com>
Date:   Tue, 28 Jun 2022 17:44:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-3-pmorel@linux.ibm.com>
 <207a01aa-d92c-4a17-7b2f-aed59da4ce09@linux.ibm.com>
 <28c52d15-aa80-09a8-297c-f5ae2b798998@linux.ibm.com>
 <851dd253-8412-ed5f-3a97-980b3a3850cc@linux.ibm.com>
 <7924cf38-83cb-5d5c-9ad9-a4faaa89f9d5@linux.ibm.com>
 <c4cb8d51-64c1-290b-92d5-314272fffc23@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <c4cb8d51-64c1-290b-92d5-314272fffc23@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NK1xlvDM8YdkHH-Vp8j_1fag8GkvxtEK
X-Proofpoint-ORIG-GUID: Rs3Iq5dKcpA04M8MTHHqcKKxc27CaZdL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/28/22 17:01, Janis Schoetterl-Glausch wrote:
> On 6/28/22 16:13, Pierre Morel wrote:
>>
>>
>> On 6/28/22 14:18, Janis Schoetterl-Glausch wrote:
>>> On 6/28/22 12:58, Pierre Morel wrote:
>>>>
>>>>
>>>> On 6/28/22 10:59, Janis Schoetterl-Glausch wrote:
>>>>> On 6/20/22 14:54, Pierre Morel wrote:
>>>>>> We report a topology change to the guest for any CPU hotplug.
>>>>>>
>>>>>> The reporting to the guest is done using the Multiprocessor
>>>>>> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
>>>>>> SCA which will be cleared during the interpretation of PTF.
>>>>>>
>>>>>> On every vCPU creation we set the MCTR bit to let the guest know the
>>>>>> next time he uses the PTF with command 2 instruction that the
>>>>>> topology changed and that he should use the STSI(15.1.x) instruction
>>>>>> to get the topology details.
>>>>>>
>>>>>> STSI(15.1.x) gives information on the CPU configuration topology.
>>>>>> Let's accept the interception of STSI with the function code 15 and
>>>>>> let the userland part of the hypervisor handle it when userland
>>>>>> support the CPU Topology facility.
>>>>>>
>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>> ---
>>>>>>     arch/s390/include/asm/kvm_host.h | 11 ++++++++---
>>>>>>     arch/s390/kvm/kvm-s390.c         | 27 ++++++++++++++++++++++++++-
>>>>>>     arch/s390/kvm/priv.c             | 15 +++++++++++----
>>>>>>     arch/s390/kvm/vsie.c             |  3 +++
>>>>>>     4 files changed, 48 insertions(+), 8 deletions(-)
>>>>>>
>>>>> [...]
>>>>>
>>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>>> index 8fcb56141689..95b96019ca8e 100644
>>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>>> @@ -1691,6 +1691,25 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>>         return ret;
>>>>>>     }
>>>>>>
>>>>>> +/**
>>>>>> + * kvm_s390_sca_set_mtcr
>>>>>
>>>>> I wonder if there is a better name, kvm_s390_report_topology_change maybe?
>>>>>
>>>>>> + * @kvm: guest KVM description
>>>>>> + *
>>>>>> + * Is only relevant if the topology facility is present,
>>>>>> + * the caller should check KVM facility 11
>>>>>> + *
>>>>>> + * Updates the Multiprocessor Topology-Change-Report to signal
>>>>>> + * the guest with a topology change.
>>>>>> + */
>>>>>> +static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
>>>>>> +{
>>>>>
>>>>> Do we need a sca_lock read_section here? If we don't why not?
>>>>> Did not see one up the stack, but I might have overlooked something.
>>>>
>>>> Yes we do.
>>>> As I said about your well justified comment in a previous mail, ipte_lock is not the right thing to use here and I will replace with an inter locked update.
>>>
>>> Not sure I'm understanding you right, you're saying we need both? i.e.:
>>>
>>> struct bsca_block *sca;
>>>
>>> read_lock(&vcpu->kvm->arch.sca_lock);
>>> sca = kvm->arch.sca;
>>> atomic_or(SCA_UTILITY_MTCR, &sca->utility);
>>> read_unlock(&vcpu->kvm->arch.sca_lock);
>>>
>>> Obviously you would need to change the definition of the utility field and could not use a bit field like Janosch
>>> suggested, unless you want to use a cmpxchg loop.
>>> It's a bit ugly that utility is a two byte value.
>>> Maybe there is a nicer way to set that bit, OR (OI, OIY) seem appropriate, but I don't know if they have a nice
>>> abstraction in Linux or if you'd need inline asm.
>>
>> I was think to something like this because it is what is used most of the time when a bit is to be change concurrently with firmware.
> 
> Ah, ok you want to keep the bitfield.
> 
> [...]
>>
>> static void kvm_s390_sca_set_mtcr(struct kvm *kvm, int val)
> 
> If you use a bool val you can simply do new.mtcr = val; below.
>> {
>>          struct bsca_block *sca = kvm->arch.sca;
>>          union sca_utility new, old;
>>
>>          read_lock(&kvm->arch.sca_lock);
> 
> Don't forget to move the sca = kvm->arch.sca; under the lock here.
>>          do {
>>                  old = READ_ONCE(sca->utility);
>>                  new = old;
>>                  new.mtcr = val ? 1 : 0;
>>          } while (cmpxchg(&sca->utility.val, old.val, new.val) != old.val);
>>          read_lock(&kvm->arch.sca_lock);
>> }

right, thanks, and to unlock at the end :)

>>
>>>>
>>>>>
>>>>>> +    struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
>>>>>> +
>>>>>> +    ipte_lock(kvm);
>>>>>> +    sca->utility |= SCA_UTILITY_MTCR;
>>>>>> +    ipte_unlock(kvm);
>>>>>> +}
>>>>>> +
>>>>>
>>>>> [...]
>>>>>
>>>>
>>>
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
