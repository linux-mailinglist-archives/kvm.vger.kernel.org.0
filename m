Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50E864B699
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 14:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbiLMNuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 08:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbiLMNux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 08:50:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E6DE87
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 05:50:52 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDD67wF019815;
        Tue, 13 Dec 2022 13:50:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RiIEqg+3AhSK8fbZM02cL1LtlUKFRTGkMD4LwZamsXo=;
 b=ID4Il9bhzP/8Ryy20kenfaapLHweJJKd9iu3zfulGq407zK1wi+dx0l3OSXzzAxl2Ven
 XxAvgmNrmbi1QF24IEq0ZidB1v265zXB708r7Lu5zl7r/VRVUaJ/gdQRhKhtq83kyhKM
 kh+AE0KjMGCxZGn7CaQCtq1rxn/eEsD/v9sC5u5Ed4QsaW2QzpYpVDlVHu3C6f2CUz3f
 04kPD9FyZntbkti1blb+T6FA8TjVtjfbUxOPTLtJ8qBLJQRrqJYMTeEsWMNHvWuvqKaG
 riFHMwr97a20vDKaEkZaBgnkfJquTePwKwoy4B320smyG2XXDdrU5L4wMPhowuOrG7Tw lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3merajkmgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:50:39 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDD6api022459;
        Tue, 13 Dec 2022 13:50:38 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3merajkmg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:50:38 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD1YYs6011845;
        Tue, 13 Dec 2022 13:50:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3mchr632sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:50:35 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDDoW2n37945746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 13:50:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0671B20043;
        Tue, 13 Dec 2022 13:50:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D938420040;
        Tue, 13 Dec 2022 13:50:30 +0000 (GMT)
Received: from [9.171.21.177] (unknown [9.171.21.177])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 13:50:30 +0000 (GMT)
Message-ID: <e9927252-c711-6ddf-bc53-28e373eea371@de.ibm.com>
Date:   Tue, 13 Dec 2022 14:50:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <d29c06e6-48e2-6cff-0524-297eaab0516b@kaod.org>
 <663e6861-be17-88ae-866a-e62569d6c721@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <663e6861-be17-88ae-866a-e62569d6c721@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iJZEv7I46yvfJocdlu3sIv5pJo_qd0eo
X-Proofpoint-GUID: cidet9MIXUkggbea-4WDBEFzCMywAEX3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212130120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 12.12.22 um 11:01 schrieb Pierre Morel:
> 
> 
> On 12/9/22 15:45, Cédric Le Goater wrote:
>> On 12/8/22 10:44, Pierre Morel wrote:
>>> Hi,
>>>
>>> Implementation discussions
>>> ==========================
>>>
>>> CPU models
>>> ----------
>>>
>>> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
>>> for old QEMU we could not activate it as usual from KVM but needed
>>> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>> Checking and enabling this capability enables
>>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>>
>>> Migration
>>> ---------
>>>
>>> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
>>> host the STFL(11) is provided to the guest.
>>> Since the feature is already in the CPU model of older QEMU,
>>> a migration from a new QEMU enabling the topology to an old QEMU
>>> will keep STFL(11) enabled making the guest get an exception for
>>> illegal operation as soon as it uses the PTF instruction.
>>>
>>> A VMState keeping track of the S390_FEAT_CONFIGURATION_TOPOLOGY
>>> allows to forbid the migration in such a case.
>>>
>>> Note that the VMState will be used to hold information on the
>>> topology once we implement topology change for a running guest.
>>>
>>> Topology
>>> --------
>>>
>>> Until we introduce bookss and drawers, polarization and dedication
>>> the topology is kept very simple and is specified uniquely by
>>> the core_id of the vCPU which is also the vCPU address.
>>>
>>> Testing
>>> =======
>>>
>>> To use the QEMU patches, you will need Linux V6-rc1 or newer,
>>> or use the following Linux mainline patches:
>>>
>>> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
>>> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
>>> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac..
>>>
>>> Currently this code is for KVM only, I have no idea if it is interesting
>>> to provide a TCG patch. If ever it will be done in another series.
>>>
>>> Documentation
>>> =============
>>>
>>> To have a better understanding of the S390x CPU Topology and its
>>> implementation in QEMU you can have a look at the documentation in the
>>> last patch of this series.
>>>
>>> The admin will want to match the host and the guest topology, taking
>>> into account that the guest does not recognize multithreading.
>>> Consequently, two vCPU assigned to threads of the same real CPU should
>>> preferably be assigned to the same socket of the guest machine.
>>>
>>> Future developments
>>> ===================
>>>
>>> Two series are actively prepared:
>>> - Adding drawers, book, polarization and dedication to the vCPU.
>>> - changing the topology with a running guest
>>
>> Since we have time before the next QEMU 8.0 release, could you please
>> send the whole patchset ? Having the full picture would help in taking
>> decisions for downstream also.
>>
>> I am still uncertain about the usefulness of S390Topology object because,
>> as for now, the state can be computed on the fly, the reset can be
>> handled at the machine level directly under s390_machine_reset() and so
>> could migration if the machine had a vmstate (not the case today but
>> quite easy to add). So before merging anything that could be difficult
>> to maintain and/or backport, I would prefer to see it all !
>>
> 
> The goal of dedicating an object for topology was to ease the maintenance and portability by using the QEMU object framework.
> 
> If on contrary it is a problem for maintenance or backport we surely better not use it.
> 
> Any other opinion?

I agree with Cedric. There is no point in a topology object.
The state is calculated on the fly depending on the command line. This
would change if we ever implement the PTF horizontal/vertical state. But this
can then be another CPU state.

So I think we could go forward with this patch as a simple patch set that allows to
sets a static topology. This makes sense on its own, e.g. if you plan to pin your
vCPUs to given host CPUs.

Dynamic changes do come with CPU hotplug, not sure what libvirt does with new CPUs
in that case during migration. I assume those are re-generated on the target with
whatever topology was created on the source. So I guess this will just work, but
it would be good if we could test that.

A more fine-grained topology (drawer, book) could be added later or upfront. It
does require common code and libvirt enhancements, though.
