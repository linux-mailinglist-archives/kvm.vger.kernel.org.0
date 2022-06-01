Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5906F53A623
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 15:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353323AbiFANsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 09:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353299AbiFANsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 09:48:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F3F56C00
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 06:48:19 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251C1Jib003127;
        Wed, 1 Jun 2022 13:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UErtf5KaoMBpfs/dBKHYGT2Orwww6J81RpTk2o0y5+s=;
 b=PVD64m5/DfLcyCUNuGm0WU3J5MzBlcbfRF7rjLzteON4eROlA06Q32cOeJdP6ph9n98N
 MiRENSGrZJ8lI8U/hEpDDyuTomHqzUiP9aTSuPI7dD/pDxoBjQG/NdoLtEoHLt6EqKUy
 34sTftQ0ZpAvIFuF3YVoV706Xz4YDYSH20gdojCipGfEuDJ+8Oyl/c1kHerIC/njpNR0
 J9LFY/mHKmss0rEm8kDyB6egZgKsoY59ddMQ4NOqSlyh9mHvFb8LVvnQtjufNG6q0Svx
 qvQwbndcDf8imfaAeEKzUdclxyB143FAU0Sieq8Qwh+PSrjB0K8VCb/nhs/y8w4E9/8n pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge7g9at9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 13:48:13 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251Ci6iO023682;
        Wed, 1 Jun 2022 13:48:12 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge7g9at99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 13:48:12 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251DbpH9014733;
        Wed, 1 Jun 2022 13:48:11 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 3gbc9vku1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 13:48:11 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251DmAon29163790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 13:48:10 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC0257805C;
        Wed,  1 Jun 2022 13:48:10 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AC7478063;
        Wed,  1 Jun 2022 13:48:09 +0000 (GMT)
Received: from [9.211.104.178] (unknown [9.211.104.178])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Jun 2022 13:48:09 +0000 (GMT)
Message-ID: <6030c7e6-479d-660c-9198-1c65c74735a1@linux.ibm.com>
Date:   Wed, 1 Jun 2022 09:48:08 -0400
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
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <5b19dd64-d6be-0371-da63-0dd0b78a3a5c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ITSr7sL0Jtzx0mJL9F-H2AuDh_q40EKW
X-Proofpoint-ORIG-GUID: jqSrgzTPTA1CPEqGkq5KnLyMhhXP6Qr0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_04,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010062
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/22 5:52 AM, David Hildenbrand wrote:
> On 24.05.22 21:02, Matthew Rosato wrote:
>> The zpci-interp feature is used to specify whether zPCI interpretation is
>> to be used for this guest.
> 
> We have
> 
> DEF_FEAT(SIE_PFMFI, "pfmfi", SCLP_CONF_CHAR_EXT, 9, "SIE: PFMF
> interpretation facility")
> 
> and
> 
> DEF_FEAT(SIE_SIGPIF, "sigpif", SCLP_CPU, 12, "SIE: SIGP interpretation
> facility")
> 
> 
> Should we call this simply "zpcii" or "zpciif" (if the official name
> includes "Facility")
> 

This actually controls the use of 2 facilities which really only make 
sense together - Maybe just zpcii

>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/s390-virtio-ccw.c          | 1 +
>>   target/s390x/cpu_features_def.h.inc | 1 +
>>   target/s390x/gen-features.c         | 2 ++
>>   target/s390x/kvm/kvm.c              | 1 +
>>   4 files changed, 5 insertions(+)
>>
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index 047cca0487..b33310a135 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -806,6 +806,7 @@ static void ccw_machine_7_0_instance_options(MachineState *machine)
>>       static const S390FeatInit qemu_cpu_feat = { S390_FEAT_LIST_QEMU_V7_0 };
>>   
>>       ccw_machine_7_1_instance_options(machine);
>> +    s390_cpudef_featoff_greater(14, 1, S390_FEAT_ZPCI_INTERP);
>>       s390_set_qemu_cpu_model(0x8561, 15, 1, qemu_cpu_feat);
>>   }
>>   
>> diff --git a/target/s390x/cpu_features_def.h.inc b/target/s390x/cpu_features_def.h.inc
>> index e86662bb3b..4ade3182aa 100644
>> --- a/target/s390x/cpu_features_def.h.inc
>> +++ b/target/s390x/cpu_features_def.h.inc
>> @@ -146,6 +146,7 @@ DEF_FEAT(SIE_CEI, "cei", SCLP_CPU, 43, "SIE: Conditional-external-interception f
>>   DEF_FEAT(DAT_ENH_2, "dateh2", MISC, 0, "DAT-enhancement facility 2")
>>   DEF_FEAT(CMM, "cmm", MISC, 0, "Collaborative-memory-management facility")
>>   DEF_FEAT(AP, "ap", MISC, 0, "AP instructions installed")
>> +DEF_FEAT(ZPCI_INTERP, "zpci-interp", MISC, 0, "zPCI interpretation")
> 
> How is this feature exposed to the guest, meaning, how can the guest
> sense support?
> 
> Just a gut feeling: does this toggle enable the host to use
> interpretation and the guest cannot really determine the difference
> whether it's enabled or not? Then, it's not a guest CPU feature. But
> let's hear first what this actually enables :)

This has changed a few times, but collectively we can determine on the 
host kernel if it is allowable based upon the availability of certain 
facility/sclp bits + the availability of an ioctl interface.

If all of these are available, the host kernel allows zPCI 
interpretation, with userspace able to toggle it on/off for the guest 
via this feature.  When allowed and enabled, 2 ECB bits then get set for 
each guest vcpu that enable the associated facilities.  The guest 
continues to use zPCI instructions in the same manner as before; the 
function handles it receives from CLP instructions will look different 
but are still used in the same manner.

We don't yet add vsie support of the facilities with this series, so the 
corresponding facility and sclp bits aren't forwarded to the guest.

> 
>>   
>>   /* Features exposed via the PLO instruction. */
>>   DEF_FEAT(PLO_CL, "plo-cl", PLO, 0, "PLO Compare and load (32 bit in general registers)")
>> diff --git a/target/s390x/gen-features.c b/target/s390x/gen-features.c
>> index c03ec2c9a9..f991646c01 100644
>> --- a/target/s390x/gen-features.c
>> +++ b/target/s390x/gen-features.c
>> @@ -554,6 +554,7 @@ static uint16_t full_GEN14_GA1[] = {
>>       S390_FEAT_HPMA2,
>>       S390_FEAT_SIE_KSS,
>>       S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
>> +    S390_FEAT_ZPCI_INTERP,
>>   };
>>   
>>   #define full_GEN14_GA2 EmptyFeat
>> @@ -650,6 +651,7 @@ static uint16_t default_GEN14_GA1[] = {
>>       S390_FEAT_GROUP_MSA_EXT_8,
>>       S390_FEAT_MULTIPLE_EPOCH,
>>       S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
>> +    S390_FEAT_ZPCI_INTERP,
> 
> I'm curious, should we really add this to the default model?
> 
> This implies that on any setup where we don't have zpci interpretation
> support (including missing kernel support), that a basic "-cpu z14" will
> no longer work with the new machine type.
> 
> If, OTOH, we expect this feature to be around in any sane installation,
> then it's good to include it in the
> 

 From a hardware perspective, everything will be available on z14 and 
later so it's only a question of missing host kernel support (or, you 
aren't running in a z14 LPAR).  As far as host kernel support, the 
expectation is that for a distro release where this QEMU support lands 
the associated kernel support would also be backported.  I guess that 
leaves some awkwardness if one upgrades their distro qemu to a new 
release version without picking up the kernel upgrade for some reason.. 
In that case, you're not totally stuck, you could still use -cpu 
z14,zpcii=off (or better yet pick up the associated kernel upgrade...) 
The intent is for exploitation of interpretation facilities to become 
the default on z14 and later, with the ability to turn it off offered as 
a fall-back / backwards compatibility.

If there's a better way to accomplish that, I'm open to suggestion.




