Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E3A57157D
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 11:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiGLJRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 05:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiGLJRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 05:17:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C827823F;
        Tue, 12 Jul 2022 02:17:09 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26C9F9tT025516;
        Tue, 12 Jul 2022 09:17:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=owkvwMRylodKF+j0xJNN/3K4H/v3uCmowpZ2+D85uqA=;
 b=mK993XXt8WoxoE75i+hm2ZZkuXX8cxUEtoNozB0gG3c18lkcGM3pKzudT5/AeSQZAkM9
 qyTIXyii/YFfxg0O+EZz6pZkob14+LswN9QmAu7GDM1RUvR5HnTxB7cvzxMwzTDKCqFP
 WtJgUBLOZrn6owdG/nCC9lvJlBDQgKHLe4lropfUYSWDO37KxzUSrDoRKWum9vWkliVu
 ASli/Gv5raqxTUK2vqsGmwRGGkFG7GypbcJQfNs1BK0STEXvvbjLBFHf95kLBUYUaEnk
 6SVn9xsQqa7l8dAPt5EYiuIdCcpkM2DdlO5kKoBwTF4FncjU3/VOPlkbyMvI4tcc+cec yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h93v0bpw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 09:17:08 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26C9CJtj028860;
        Tue, 12 Jul 2022 09:17:08 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h93v0bpve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 09:17:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26C8o6iN001602;
        Tue, 12 Jul 2022 09:17:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3h70xhuy56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 09:17:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26C9H3RN11731362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 09:17:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FA655204F;
        Tue, 12 Jul 2022 09:17:03 +0000 (GMT)
Received: from [9.171.74.72] (unknown [9.171.74.72])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 543E852050;
        Tue, 12 Jul 2022 09:17:02 +0000 (GMT)
Message-ID: <5c3d9637-7739-1323-8630-433ff8cb4dc4@linux.ibm.com>
Date:   Tue, 12 Jul 2022 11:21:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v12 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220711084148.25017-1-pmorel@linux.ibm.com>
 <20220711084148.25017-3-pmorel@linux.ibm.com>
 <92c6d13c-4494-de56-83f4-9d7384444008@linux.ibm.com>
 <1884bc26-b91b-83a7-7f8b-96b6090a0bac@linux.ibm.com>
 <6124248a-24be-b43a-f827-b6bebf9e7f3d@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <6124248a-24be-b43a-f827-b6bebf9e7f3d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QmCKDgJcCsJ4T-NBqsRZQ2hw87Vud27N
X-Proofpoint-GUID: 1o5-9W05gETsspmgDHaDgWJZaXgIyARk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_05,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/22 10:50, Janis Schoetterl-Glausch wrote:
> On 7/12/22 09:45, Pierre Morel wrote:
>>
>>
>> On 7/11/22 14:30, Janis Schoetterl-Glausch wrote:
>>> On 7/11/22 10:41, Pierre Morel wrote:
>>>> We report a topology change to the guest for any CPU hotplug.
>>>>
>>>> The reporting to the guest is done using the Multiprocessor
>>>> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
>>>> SCA which will be cleared during the interpretation of PTF.
>>>>
>>>> On every vCPU creation we set the MCTR bit to let the guest know the
>>>> next time it uses the PTF with command 2 instruction that the
>>>> topology changed and that it should use the STSI(15.1.x) instruction
>>>> to get the topology details.
>>>>
>>>> STSI(15.1.x) gives information on the CPU configuration topology.
>>>> Let's accept the interception of STSI with the function code 15 and
>>>> let the userland part of the hypervisor handle it when userland
>>>> supports the CPU Topology facility.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>>>
>>> Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>
>> Thanks.
>>
>>
>>> See nit below.
>>>> ---
>>>>    arch/s390/include/asm/kvm_host.h | 18 +++++++++++++++---
>>>>    arch/s390/kvm/kvm-s390.c         | 31 +++++++++++++++++++++++++++++++
>>>>    arch/s390/kvm/priv.c             | 22 ++++++++++++++++++----
>>>>    arch/s390/kvm/vsie.c             |  8 ++++++++
>>>>    4 files changed, 72 insertions(+), 7 deletions(-)
>>>>
>>>
>>> [...]
>>>
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index 8fcb56141689..70436bfff53a 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -1691,6 +1691,32 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>        return ret;
>>>>    }
>>>>    +/**
>>>> + * kvm_s390_update_topology_change_report - update CPU topology change report
>>>> + * @kvm: guest KVM description
>>>> + * @val: set or clear the MTCR bit
>>>> + *
>>>> + * Updates the Multiprocessor Topology-Change-Report bit to signal
>>>> + * the guest with a topology change.
>>>> + * This is only relevant if the topology facility is present.
>>>> + *
>>>> + * The SCA version, bsca or esca, doesn't matter as offset is the same.
>>>> + */
>>>> +static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
>>>> +{
>>>> +    union sca_utility new, old;
>>>> +    struct bsca_block *sca;
>>>> +
>>>> +    read_lock(&kvm->arch.sca_lock);
>>>> +    do {
>>>> +        sca = kvm->arch.sca;
>>>
>>> I find this assignment being in the loop unintuitive, but it should not make a difference.
>>
>> The price would be an ugly cast.
> 
> I don't get what you mean. Nothing about the types changes if you move it before the loop.

Yes right, did wrong understand.
It is better before.

>>
>>
>>>
>>>> +        old = READ_ONCE(sca->utility);
>>>> +        new = old;
>>>> +        new.mtcr = val;
>>>> +    } while (cmpxchg(&sca->utility.val, old.val, new.val) != old.val);
>>>> +    read_unlock(&kvm->arch.sca_lock);
>>>> +}
>>>> +
>>> [...]
>>>
>>
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
