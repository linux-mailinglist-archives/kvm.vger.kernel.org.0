Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2464D64082F
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 15:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiLBOI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 09:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiLBOIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 09:08:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399CB9FEEA
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 06:08:24 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B2DgAxg021482;
        Fri, 2 Dec 2022 14:08:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oULq9ebBKI9JjP7FuumqR8cwsDgwubKsG6F3/MJ/a84=;
 b=ENfZsR0vKP7f0be9G9jxvlX5MWOR0WkjueQFommQSyYnNx/ZJj2jnIErrOza5f2pk4YU
 z4Mwkds1T0PONXADm1u88nB0v/+33G50zfJLT+E7pK1AEcCicuoT961ToSb8Qyod54ju
 a+hwa2FT8jucl0AB24B11uSctfWElRz6lwPABKHa9gihFkRD6BkcM2R2SGlTEi8nNMK2
 vhmWf94lN9Aq0+MtSD9IPasqdRMyU0vVR5TDH4nhAeN2Tc4Ja0Vu72RnX5UNLHFZHVLj
 ZsipFIM2EquoLmg/2aX7rSIOarSeTGtmaYs7SB99QTwfnuGfsAAq9ivC845T3aLTdAon zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7jfp8n5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 14:08:15 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B2DuJIJ029855;
        Fri, 2 Dec 2022 14:08:14 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7jfp8n4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 14:08:14 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B2E5umO023097;
        Fri, 2 Dec 2022 14:08:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3m3ae96qsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 14:08:11 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B2E88g26947546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Dec 2022 14:08:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6F204C040;
        Fri,  2 Dec 2022 14:08:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AACC14C046;
        Fri,  2 Dec 2022 14:08:07 +0000 (GMT)
Received: from [9.171.75.172] (unknown [9.171.75.172])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Dec 2022 14:08:07 +0000 (GMT)
Message-ID: <59669e8e-6242-9c01-4c2e-5d70b9c31b2b@linux.ibm.com>
Date:   Fri, 2 Dec 2022 15:08:07 +0100
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
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <37a20bee-a3fb-c421-b89d-c1760e77cb11@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7MzlxV-ajWJOEtbqxHtXpVGChPL_juug
X-Proofpoint-GUID: R7A-AgtHI0ZCrUYPKVSg1gM2DrCKybf7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_06,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 phishscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212020111
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/2/22 10:05, Thomas Huth wrote:
> On 01/12/2022 12.52, Pierre Morel wrote:
>>
>>
>> On 12/1/22 11:15, Thomas Huth wrote:
>>> On 29/11/2022 18.42, Pierre Morel wrote:
>>>> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
>>>> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
>>>> the topology facility for the guest in the case the topology
>>>> is available in QEMU and in KVM.
>>>>
>>>> The feature is fenced for SE (secure execution).
>>>
>>> Out of curiosity: Why does it not work yet?
>>>
>>>> To allow smooth migration with old QEMU the feature is disabled by
>>>> default using the CPU flag -disable-topology.
>>>
>>> I stared at this code for a while now, but I have to admit that I 
>>> don't quite get it. Why do we need a new "disable" feature flag here? 
>>> I think it is pretty much impossible to set "ctop=on" with an older 
>>> version of QEMU, since it would require the QEMU to enable 
>>> KVM_CAP_S390_CPU_TOPOLOGY in the kernel for this feature bit - and 
>>> older versions of QEMU don't set this capability yet.
>>>
>>> Which scenario would fail without this disable-topology feature bit? 
>>> What do I miss?
>>
>> The only scenario it provides is that ctop is then disabled by default 
>> on newer QEMU allowing migration between old and new QEMU for older 
>> machine without changing the CPU flags.
>>
>> Otherwise, we would need -ctop=off on newer QEMU to disable the topology.
> 
> Ah, it's because you added S390_FEAT_CONFIGURATION_TOPOLOGY to the 
> default feature set here:
> 
>   static uint16_t default_GEN10_GA1[] = {
>       S390_FEAT_EDAT,
>       S390_FEAT_GROUP_MSA_EXT_2,
> +    S390_FEAT_DISABLE_CPU_TOPOLOGY,
> +    S390_FEAT_CONFIGURATION_TOPOLOGY,
>   };
> 
> ?
> 
> But what sense does it make to enable it by default, just to disable it 
> by default again with the S390_FEAT_DISABLE_CPU_TOPOLOGY feature? ... 
> sorry, I still don't quite get it, but maybe it's because my sinuses are 
> quite clogged due to a bad cold ... so if you could elaborate again, 
> that would be very appreciated!
> 
> However, looking at this from a distance, I would not rather not add 
> this to any default older CPU model at all (since it also depends on the 
> kernel to have this feature enabled)? Enabling it in the host model is 
> still ok, since the host model is not migration safe anyway.
> 
>   Thomas
> 

I think I did not understand what is exactly the request that was made 
about having a CPU flag to disable the topology when we decide to not 
have a new machine with new machine property.

Let see what we have if the only change to mainline is to activate 
S390_FEAT_CONFIGURATION_TOPOLOGY with the KVM capability:

In mainline, ctop is enabled in the full GEN10 only.

Consequently we have this feature activated by default for the host 
model only and deactivated by default if we specify the CPU.
It can be activated if we specify the CPU with the flag ctop=on.

This is what was in the patch series before the beginning of the 
discussion about having a new machine property for new machines.

If this what we want: activating the topology by the CPU flag ctop=on it 
is perfect for me and I can take the original patch.
We may later make it a default for new machines.

Otherwise or if I misunderstood something, which is greatly possible, I 
need more advises.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
