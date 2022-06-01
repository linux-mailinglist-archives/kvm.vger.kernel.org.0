Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2E453A9B1
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 17:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353553AbiFAPLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 11:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351739AbiFAPLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 11:11:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4726C79823
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 08:11:34 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251Ewk05029898;
        Wed, 1 Jun 2022 15:11:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iPngrm32Xb7mJ01st+3s4Sqm2DbIkBrtaCiTXg/Ry6I=;
 b=cV8xygwPrPF9XFuOCiJzHxIDjSQ1Ib6AaRwL6mIeg12BwLUxg1x+wVz1zoUrktC1ZRB/
 jQFWXBskAB9QnuCyjaVWfOZ6IWomCbPUkpEikHJG9DMrWS//6+nc4Yv2bLUbCoBb9Ml1
 c1JedBbZm3TDXL+2V5U/7/+/VLGVjCMJp+QU96ZxMapufrQ69a3Bu5rntRKMgMRTfEIz
 SDyk9KfRJ9cOlpau8s9VojSLAKJVUEv/JvsunYy8BAJ8sYaFAjbWTXt5+IdYGAPsIKgK
 iQOt/H3cdICxfCc2vM383YuTcIyqgcTyT7nZ2bw1+YXDVaP6NSCjynjFTCm4WR1w/1DF LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geabq8bfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:11:27 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251Ex9bm030415;
        Wed, 1 Jun 2022 15:11:27 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geabq8bev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:11:27 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251F6Deu019213;
        Wed, 1 Jun 2022 15:11:25 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 3gbcbj4a1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:11:25 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251FBO9I22217010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 15:11:24 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EC5078063;
        Wed,  1 Jun 2022 15:11:24 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF91678067;
        Wed,  1 Jun 2022 15:11:22 +0000 (GMT)
Received: from [9.211.104.178] (unknown [9.211.104.178])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Jun 2022 15:11:22 +0000 (GMT)
Message-ID: <535b79a5-372d-9bca-d7c7-bac263277230@linux.ibm.com>
Date:   Wed, 1 Jun 2022 11:11:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v6 2/8] target/s390x: add zpci-interp to cpu models
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220524190305.140717-1-mjrosato@linux.ibm.com>
 <20220524190305.140717-3-mjrosato@linux.ibm.com>
 <5b19dd64-d6be-0371-da63-0dd0b78a3a5c@redhat.com>
 <6030c7e6-479d-660c-9198-1c65c74735a1@linux.ibm.com>
 <f8d128d2-e58a-e0a0-ff8a-7ff2b2ffa31e@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <f8d128d2-e58a-e0a0-ff8a-7ff2b2ffa31e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Gw7e0XfOIPYYTGhq37wfT8-ZgAKk5hro
X-Proofpoint-ORIG-GUID: ulJ2A0S5VsbiiqZKQBCFuB6nOMhuC-D1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_05,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010070
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/22 10:10 AM, David Hildenbrand wrote:
> On 01.06.22 15:48, Matthew Rosato wrote:
>> On 6/1/22 5:52 AM, David Hildenbrand wrote:
>>> On 24.05.22 21:02, Matthew Rosato wrote:
>>>> The zpci-interp feature is used to specify whether zPCI interpretation is
>>>> to be used for this guest.
>>>
>>> We have
>>>
>>> DEF_FEAT(SIE_PFMFI, "pfmfi", SCLP_CONF_CHAR_EXT, 9, "SIE: PFMF
>>> interpretation facility")
>>>
>>> and
>>>
>>> DEF_FEAT(SIE_SIGPIF, "sigpif", SCLP_CPU, 12, "SIE: SIGP interpretation
>>> facility")
>>>
>>>
>>> Should we call this simply "zpcii" or "zpciif" (if the official name
>>> includes "Facility")
>>>
>>
>> This actually controls the use of 2 facilities which really only make
>> sense together - Maybe just zpcii
>>
>>>>
>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>> ---
>>>>    hw/s390x/s390-virtio-ccw.c          | 1 +
>>>>    target/s390x/cpu_features_def.h.inc | 1 +
>>>>    target/s390x/gen-features.c         | 2 ++
>>>>    target/s390x/kvm/kvm.c              | 1 +
>>>>    4 files changed, 5 insertions(+)
>>>>
>>>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>>>> index 047cca0487..b33310a135 100644
>>>> --- a/hw/s390x/s390-virtio-ccw.c
>>>> +++ b/hw/s390x/s390-virtio-ccw.c
>>>> @@ -806,6 +806,7 @@ static void ccw_machine_7_0_instance_options(MachineState *machine)
>>>>        static const S390FeatInit qemu_cpu_feat = { S390_FEAT_LIST_QEMU_V7_0 };
>>>>    
>>>>        ccw_machine_7_1_instance_options(machine);
>>>> +    s390_cpudef_featoff_greater(14, 1, S390_FEAT_ZPCI_INTERP);
>>>>        s390_set_qemu_cpu_model(0x8561, 15, 1, qemu_cpu_feat);
>>>>    }
>>>>    
>>>> diff --git a/target/s390x/cpu_features_def.h.inc b/target/s390x/cpu_features_def.h.inc
>>>> index e86662bb3b..4ade3182aa 100644
>>>> --- a/target/s390x/cpu_features_def.h.inc
>>>> +++ b/target/s390x/cpu_features_def.h.inc
>>>> @@ -146,6 +146,7 @@ DEF_FEAT(SIE_CEI, "cei", SCLP_CPU, 43, "SIE: Conditional-external-interception f
>>>>    DEF_FEAT(DAT_ENH_2, "dateh2", MISC, 0, "DAT-enhancement facility 2")
>>>>    DEF_FEAT(CMM, "cmm", MISC, 0, "Collaborative-memory-management facility")
>>>>    DEF_FEAT(AP, "ap", MISC, 0, "AP instructions installed")
>>>> +DEF_FEAT(ZPCI_INTERP, "zpci-interp", MISC, 0, "zPCI interpretation")
>>>
>>> How is this feature exposed to the guest, meaning, how can the guest
>>> sense support?
>>>
>>> Just a gut feeling: does this toggle enable the host to use
>>> interpretation and the guest cannot really determine the difference
>>> whether it's enabled or not? Then, it's not a guest CPU feature. But
>>> let's hear first what this actually enables :)
>>
>> This has changed a few times, but collectively we can determine on the
>> host kernel if it is allowable based upon the availability of certain
>> facility/sclp bits + the availability of an ioctl interface.
>>
>> If all of these are available, the host kernel allows zPCI
>> interpretation, with userspace able to toggle it on/off for the guest
>> via this feature.  When allowed and enabled, 2 ECB bits then get set for
>> each guest vcpu that enable the associated facilities.  The guest
>> continues to use zPCI instructions in the same manner as before; the
>> function handles it receives from CLP instructions will look different
>> but are still used in the same manner.
>>
>> We don't yet add vsie support of the facilities with this series, so the
>> corresponding facility and sclp bits aren't forwarded to the guest.
> 
> That's exactly my point:
> 
> sigpif and pfmfi are actually vsie features. I'd have expected that
> zpcii would be a vsie feature as well.
> 
> If interpretation is really more an implementation detail in the
> hypervisor to implement zpci, than an actual guest feature (meaning, the
> guest is able to observe it as if it were a real CPU feature), then we
> most probably want some other way to toggle it (maybe via the machine?).
> 
> Example: KVM uses SIGP interpretation based on availability. However, we
> don't toggle it via sigpif. sigpif actually tells the guest that it can
> use the SIGP interpretation facility along with vsie.
> 
> You mention "CLP instructions will look different", I'm not sure if that
> should actually be handled via the CPU model. From my gut feeling, zpcii
> should actually be the vsie zpcii support to be implemented in the future.
> 

Well, what I meant was that the CLP response data looks different, 
primarily because when interpretation is enabled the guest would get 
passthrough of the function handle (which in turn has bits turned off 
that force hypervisor intercepts) rather than one that QEMU fabricated.

As far as a machine option, well we still need a mechanism by which 
userspace can decide whether it's OK to enable interpretation in the 
first place.  I guess we can take advantage of the fact that the 
capability associated with the ioctl interface can indicate both that 
the kernel interface is available + all of the necessary hardware 
facilities are available to that host kernel.

So I guess we could use that to make a decision to default a machine 
setting based upon that (yes if everything is available, no if not).

> 
> So I wonder if we could simply always enable zPCI interpretation if
> HW+kernel support is around and we're on a new compat machine? I there
> is a way that migration could break (from old kernel to new kernel),
> we'd have to think about alternatives.

zpci devices are currently marked unmigratable, so if you want to 
migrate you need to detach all of them first anyway today.
