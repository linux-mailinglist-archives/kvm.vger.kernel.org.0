Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1306F64296A
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 14:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiLENaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 08:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiLENaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 08:30:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B20D1C41A
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 05:30:14 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5D18Wo012140;
        Mon, 5 Dec 2022 13:29:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WUzCfESkyFFIuC9WiIk3qDdeCHZdqZniLdARtboXzQM=;
 b=XYrX2y/+mZbh9ZBt6ShuZPFlqfexA1vKRsdQGDRzGuYkO7UiXo9f7tYKIT+SoF8K1opW
 hpQFcg+T9bteLlxO33nkh4+QPTi2ZmcWka4Yjs+cSrQbOYX4PqFvkt06YrhvyGC9alx0
 3qgkWB0nYjjXJRTfMz6euzwXBg5cTExUVo6lFYM0b4c/AQVnQOXKPyvRCmSoQOhe42/u
 vz2hNBsPHwi/L0UBlRRXsZlQRO7Y19AVAbox36yidjDUteSHjgEtn2nsQtJnjkqEgSjA
 JMO1t/iKzznkxX4tguufhZjC5coLl+EzrAuwgWZj8Tw0nDG0MgWA0Oa8XjhC8xRBmnG+ oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8gm3bwt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 13:29:59 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B5DMlrf030122;
        Mon, 5 Dec 2022 13:29:58 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8gm3bwsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 13:29:58 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B5DKSFI031944;
        Mon, 5 Dec 2022 13:29:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3m7x38t3t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 13:29:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B5DNDaD1573530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Dec 2022 13:23:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FA18AE04D;
        Mon,  5 Dec 2022 13:29:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 481B2AE045;
        Mon,  5 Dec 2022 13:29:52 +0000 (GMT)
Received: from [9.179.21.36] (unknown [9.179.21.36])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Dec 2022 13:29:52 +0000 (GMT)
Message-ID: <61ecb690-73f5-6ff8-6ca7-c0d2a0eeafb2@linux.ibm.com>
Date:   Mon, 5 Dec 2022 14:29:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v12 6/7] s390x/cpu_topology: activating CPU topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org,
        david@redhat.com
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, cohuck@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-7-pmorel@linux.ibm.com>
 <fcedb98d-4333-9100-5366-8848727528f3@redhat.com>
 <ea965d1c-ab6a-5aa3-8ce3-65b8177f6320@linux.ibm.com>
 <37a20bee-a3fb-c421-b89d-c1760e77cb11@redhat.com>
 <59669e8e-6242-9c01-4c2e-5d70b9c31b2b@linux.ibm.com>
 <2c65f234-688a-796b-b451-e1661b2c07a4@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <2c65f234-688a-796b-b451-e1661b2c07a4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yE2WmXbnJ1xs5eSXDQnyOjOzUoUN8Ype
X-Proofpoint-GUID: t8S7KHiyFwNIorUgHFKAFBSeKLX8ZpWN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212050105
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/2/22 15:26, Thomas Huth wrote:
> On 02/12/2022 15.08, Pierre Morel wrote:
>>
>>
>> On 12/2/22 10:05, Thomas Huth wrote:
>>> On 01/12/2022 12.52, Pierre Morel wrote:
>>>>
>>>>
>>>> On 12/1/22 11:15, Thomas Huth wrote:
>>>>> On 29/11/2022 18.42, Pierre Morel wrote:
>>>>>> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
>>>>>> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
>>>>>> the topology facility for the guest in the case the topology
>>>>>> is available in QEMU and in KVM.
>>>>>>
>>>>>> The feature is fenced for SE (secure execution).
>>>>>
>>>>> Out of curiosity: Why does it not work yet?
>>>>>
>>>>>> To allow smooth migration with old QEMU the feature is disabled by
>>>>>> default using the CPU flag -disable-topology.
>>>>>
>>>>> I stared at this code for a while now, but I have to admit that I 
>>>>> don't quite get it. Why do we need a new "disable" feature flag 
>>>>> here? I think it is pretty much impossible to set "ctop=on" with an 
>>>>> older version of QEMU, since it would require the QEMU to enable 
>>>>> KVM_CAP_S390_CPU_TOPOLOGY in the kernel for this feature bit - and 
>>>>> older versions of QEMU don't set this capability yet.
>>>>>
>>>>> Which scenario would fail without this disable-topology feature 
>>>>> bit? What do I miss?
>>>>
>>>> The only scenario it provides is that ctop is then disabled by 
>>>> default on newer QEMU allowing migration between old and new QEMU 
>>>> for older machine without changing the CPU flags.
>>>>
>>>> Otherwise, we would need -ctop=off on newer QEMU to disable the 
>>>> topology.
>>>
>>> Ah, it's because you added S390_FEAT_CONFIGURATION_TOPOLOGY to the 
>>> default feature set here:
>>>
>>>   static uint16_t default_GEN10_GA1[] = {
>>>       S390_FEAT_EDAT,
>>>       S390_FEAT_GROUP_MSA_EXT_2,
>>> +    S390_FEAT_DISABLE_CPU_TOPOLOGY,
>>> +    S390_FEAT_CONFIGURATION_TOPOLOGY,
>>>   };
>>>
>>> ?
>>>
>>> But what sense does it make to enable it by default, just to disable 
>>> it by default again with the S390_FEAT_DISABLE_CPU_TOPOLOGY feature? 
>>> ... sorry, I still don't quite get it, but maybe it's because my 
>>> sinuses are quite clogged due to a bad cold ... so if you could 
>>> elaborate again, that would be very appreciated!
>>>
>>> However, looking at this from a distance, I would not rather not add 
>>> this to any default older CPU model at all (since it also depends on 
>>> the kernel to have this feature enabled)? Enabling it in the host 
>>> model is still ok, since the host model is not migration safe anyway.
>>>
>>>   Thomas
>>>
>>
>> I think I did not understand what is exactly the request that was made 
>> about having a CPU flag to disable the topology when we decide to not 
>> have a new machine with new machine property.
>>
>> Let see what we have if the only change to mainline is to activate 
>> S390_FEAT_CONFIGURATION_TOPOLOGY with the KVM capability:
>>
>> In mainline, ctop is enabled in the full GEN10 only.
>>
>> Consequently we have this feature activated by default for the host 
>> model only and deactivated by default if we specify the CPU.
>> It can be activated if we specify the CPU with the flag ctop=on.
>>
>> This is what was in the patch series before the beginning of the 
>> discussion about having a new machine property for new machines.
> 
> Sorry for all the mess ... I'm also not an expert when it comes to CPU 
> model features paired with compatibility and migration, and I'm still in 
> progress of learning ...
> 
>> If this what we want: activating the topology by the CPU flag ctop=on 
>> it is perfect for me and I can take the original patch.
>> We may later make it a default for new machines.
> 
> Given my current understanding, I think it's the best thing to do right 
> now. Not enable it by default, except for the host model where the 
> enablement is fine since migration is not supported any.
> 
> As you said, we could still decide later to change the default for new 
> machines. Though, I recently learnt that features should also not be 
> enable by default at all if they depend on the environment, like a Linux 
> kernel that needs to have support for the feature. So maybe we should 
> keep it off by default forever - or just enable it on new CPU models 
> (>=z17?) that would require a new host kernel anyway.
> 
>   Thomas
> 

OK, thanks, so I let it with a default as off and we change that later 
in a new CPU model or a new machine as we will see what is the best fit.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
