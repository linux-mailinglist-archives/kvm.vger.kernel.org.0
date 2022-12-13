Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D39D64BAF1
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 18:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiLMR1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 12:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbiLMR1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 12:27:48 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA81DD3
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:27:46 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGmtZO021423;
        Tue, 13 Dec 2022 17:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=idz+Vuygoe/GdjLQz2FWzilgsSqdq+gCe+w1Hm9fOCA=;
 b=NOYPK0+ebqi9qvIMaJe/sMW6sI3Xio/MBPK89IK8ytCxxf3II98jsjSFJCveQP+2JgEX
 pkzkRK+y/e6jP+1KVoHO04xf9HaF+LqX2FeutESAN9sUKnvLAGz6SYVlfKqNxDWV4mRX
 4vY6nH18RKu/7aIF225Ru/YY3U2rO5zctFmq6dWGWJ7E1/aAraBRVPVPNJBzwJM0TSCx
 86cwSeNN+XETsg0dwJtvYvFw1cB8/5vaHzs+yT62kgvrqfKvy4veWG878esgtECx26sc
 Bly0yJfS4HXlDY6iFhpBFDxDqU9vI4QmO7B7DcAPwRNH3J0XGyc6giQ4YvJ4hyAO8DBx tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mew8cgx97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:27:41 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDHRO2b039945;
        Tue, 13 Dec 2022 17:27:41 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mew8cgx8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:27:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDH4QSP007817;
        Tue, 13 Dec 2022 17:27:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mchcf4ha0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:27:38 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDHRZki25035020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 17:27:35 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 566752008B;
        Tue, 13 Dec 2022 17:27:35 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC05C2004D;
        Tue, 13 Dec 2022 17:27:33 +0000 (GMT)
Received: from [9.171.23.219] (unknown [9.171.23.219])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 17:27:33 +0000 (GMT)
Message-ID: <e881b8fb-a137-6bdc-fa28-7378c3294dfd@linux.ibm.com>
Date:   Tue, 13 Dec 2022 18:27:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <d29c06e6-48e2-6cff-0524-297eaab0516b@kaod.org>
 <663e6861-be17-88ae-866a-e62569d6c721@linux.ibm.com>
 <e9927252-c711-6ddf-bc53-28e373eea371@de.ibm.com>
 <f5bd6479-5717-2dd8-f8f2-c85ab77b7e2b@de.ibm.com>
 <363b4882fdd50abfeea5b1154a0845732f8364c4.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <363b4882fdd50abfeea5b1154a0845732f8364c4.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YG1SpNDK5QfbW4XpH8OQ8ad2v1JJUIPX
X-Proofpoint-GUID: b044WpIlRutKLm3nTwrLdRc6Nd1AnTzq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 spamscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130151
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/13/22 16:31, Janis Schoetterl-Glausch wrote:
> On Tue, 2022-12-13 at 16:12 +0100, Christian Borntraeger wrote:
>>
>> Am 13.12.22 um 14:50 schrieb Christian Borntraeger:
>>>
>>>
>>> Am 12.12.22 um 11:01 schrieb Pierre Morel:
>>>>
>>>>
>>>> On 12/9/22 15:45, Cédric Le Goater wrote:
>>>>> On 12/8/22 10:44, Pierre Morel wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Implementation discussions
>>>>>> ==========================
>>>>>>
>>>>>> CPU models
>>>>>> ----------
>>>>>>
>>>>>> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
>>>>>> for old QEMU we could not activate it as usual from KVM but needed
>>>>>> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>>>> Checking and enabling this capability enables
>>>>>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>>>>>
>>>>>> Migration
>>>>>> ---------
>>>>>>
>>>>>> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
>>>>>> host the STFL(11) is provided to the guest.
>>>>>> Since the feature is already in the CPU model of older QEMU,
>>>>>> a migration from a new QEMU enabling the topology to an old QEMU
>>>>>> will keep STFL(11) enabled making the guest get an exception for
>>>>>> illegal operation as soon as it uses the PTF instruction.
>>>>>>
>>>>>> A VMState keeping track of the S390_FEAT_CONFIGURATION_TOPOLOGY
>>>>>> allows to forbid the migration in such a case.
>>>>>>
>>>>>> Note that the VMState will be used to hold information on the
>>>>>> topology once we implement topology change for a running guest.
>>>>>>
>>>>>> Topology
>>>>>> --------
>>>>>>
>>>>>> Until we introduce bookss and drawers, polarization and dedication
>>>>>> the topology is kept very simple and is specified uniquely by
>>>>>> the core_id of the vCPU which is also the vCPU address.
>>>>>>
>>>>>> Testing
>>>>>> =======
>>>>>>
>>>>>> To use the QEMU patches, you will need Linux V6-rc1 or newer,
>>>>>> or use the following Linux mainline patches:
>>>>>>
>>>>>> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
>>>>>> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
>>>>>> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac..
>>>>>>
>>>>>> Currently this code is for KVM only, I have no idea if it is interesting
>>>>>> to provide a TCG patch. If ever it will be done in another series.
>>>>>>
>>>>>> Documentation
>>>>>> =============
>>>>>>
>>>>>> To have a better understanding of the S390x CPU Topology and its
>>>>>> implementation in QEMU you can have a look at the documentation in the
>>>>>> last patch of this series.
>>>>>>
>>>>>> The admin will want to match the host and the guest topology, taking
>>>>>> into account that the guest does not recognize multithreading.
>>>>>> Consequently, two vCPU assigned to threads of the same real CPU should
>>>>>> preferably be assigned to the same socket of the guest machine.
>>>>>>
>>>>>> Future developments
>>>>>> ===================
>>>>>>
>>>>>> Two series are actively prepared:
>>>>>> - Adding drawers, book, polarization and dedication to the vCPU.
>>>>>> - changing the topology with a running guest
>>>>>
>>>>> Since we have time before the next QEMU 8.0 release, could you please
>>>>> send the whole patchset ? Having the full picture would help in taking
>>>>> decisions for downstream also.
>>>>>
>>>>> I am still uncertain about the usefulness of S390Topology object because,
>>>>> as for now, the state can be computed on the fly, the reset can be
>>>>> handled at the machine level directly under s390_machine_reset() and so
>>>>> could migration if the machine had a vmstate (not the case today but
>>>>> quite easy to add). So before merging anything that could be difficult
>>>>> to maintain and/or backport, I would prefer to see it all !
>>>>>
>>>>
>>>> The goal of dedicating an object for topology was to ease the maintenance and portability by using the QEMU object framework.
>>>>
>>>> If on contrary it is a problem for maintenance or backport we surely better not use it.
>>>>
>>>> Any other opinion?
>>>
>>> I agree with Cedric. There is no point in a topology object.
>>> The state is calculated on the fly depending on the command line. This
>>> would change if we ever implement the PTF horizontal/vertical state. But this
>>> can then be another CPU state.
>>>
>>> So I think we could go forward with this patch as a simple patch set that allows to
>>> sets a static topology. This makes sense on its own, e.g. if you plan to pin your
>>> vCPUs to given host CPUs.
>>>
>>> Dynamic changes do come with CPU hotplug, not sure what libvirt does with new CPUs
>>> in that case during migration. I assume those are re-generated on the target with
>>> whatever topology was created on the source. So I guess this will just work, but
>>> it would be good if we could test that.
>>>
>>> A more fine-grained topology (drawer, book) could be added later or upfront. It
>>> does require common code and libvirt enhancements, though.
>>
>> Now I have discussed with Pierre and there IS a state that we want to migrate.
>> The topology change state is a guest wide bit that might be still set when
>> topology is changed->bit is set
>> guest is not yet started
>> migration
>>
>> 2 options:
>> 1. a vmstate with that bit and migrate the state
>> 2. always set the topology change bit after migration
> 
> 2. is the default behavior if you do nothing. VCPU creation on the target sets
> the change bit to 1.
> So 1. is only to prevent spurious topology change indication.
> 

OK, then I go the easy way and suppress the object.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
