Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13963578250
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 14:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiGRM2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 08:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbiGRM2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 08:28:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A6C25E80
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 05:28:05 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IC6uMx029333;
        Mon, 18 Jul 2022 12:27:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=btgA3sSDn2nOTu2pzBg3/xLoxx3EO1lmhat0pqnMwQ4=;
 b=fny3eRBgmmUjSvj9fIsR+gImQcowrj48O3r4RRAHVMfjaV3KybwdEa579hr/xwvhZ4hk
 PEUzjADpjbbPTGLrqydY6sz80vKKSaIM3Vi79ZoPMcpx2zBwSPfnMnfwNBBaloB2GnZ/
 wPRey+rkiJeMqlS1lgfUeCAzRqRwSZsEOwkFq7PXIaCwnJmqs/t9Ne+Ox5Bz7DHczRNF
 jmYkRQPDCTL6+jr0ji4RAZ71GgBbIO+2lnpSONhrH6BypyUq4KYJMmsPJv7xC5/2nsbu
 os6L6ebL3E1seUbx81zSlN+hrJfMg/npw8qpvQFpeIdKW8W4QlTPmBgO9LZjen/Yih5H jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hd787ggc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 12:27:57 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26ICCOTT031008;
        Mon, 18 Jul 2022 12:27:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hd787ggbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 12:27:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26ICKVVl000637;
        Mon, 18 Jul 2022 12:27:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8thv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 12:27:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26ICRpHt20971896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 12:27:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F79942041;
        Mon, 18 Jul 2022 12:27:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 908BE4203F;
        Mon, 18 Jul 2022 12:27:50 +0000 (GMT)
Received: from [9.171.68.43] (unknown [9.171.68.43])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 Jul 2022 12:27:50 +0000 (GMT)
Message-ID: <080e0f9b-7d75-24f4-6cb2-aa46df86dd58@linux.ibm.com>
Date:   Mon, 18 Jul 2022 14:32:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 00/12] s390x: CPU Topology
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <6ad0e006-72ee-3e24-48ed-fc8dd49db130@linux.ibm.com>
 <9c554788-aa51-d0fb-193b-f01ad266b256@linux.ibm.com>
 <df9e6199-21e5-7044-8793-9b088c5ff29c@linux.ibm.com>
 <040c0a83-a987-0daa-531d-97e149e6e96a@linux.ibm.com>
 <a5f10560-7243-358d-dabe-3ad8ac8a9e80@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <a5f10560-7243-358d-dabe-3ad8ac8a9e80@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: phwzmz8S5NMGx3a2j2E9VOGNgsN9bSFY
X-Proofpoint-ORIG-GUID: uSRxZUNjIXtJjgnNcnioPq8YQX4epLWI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_11,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/22 20:28, Janis Schoetterl-Glausch wrote:
> On 7/15/22 15:47, Pierre Morel wrote:
>>
>>
>> On 7/15/22 11:31, Janis Schoetterl-Glausch wrote:
>>> On 7/14/22 22:05, Pierre Morel wrote:
>>>>
>>>>
>>>> On 7/14/22 20:43, Janis Schoetterl-Glausch wrote:
>>>>> On 6/20/22 16:03, Pierre Morel wrote:
>>>>>> Hi,
>>>>>>
>>>>>> This new spin is essentially for coherence with the last Linux CPU
>>>>>> Topology patch, function testing and coding style modifications.
>>>>>>
>>>>>> Forword
>>>>>> =======
>>>>>>
>>>>>> The goal of this series is to implement CPU topology for S390, it
>>>>>> improves the preceeding series with the implementation of books and
>>>>>> drawers, of non uniform CPU topology and with documentation.
>>>>>>
>>>>>> To use these patches, you will need the Linux series version 10.
>>>>>> You find it there:
>>>>>> https://lkml.org/lkml/2022/6/20/590
>>>>>>
>>>>>> Currently this code is for KVM only, I have no idea if it is interesting
>>>>>> to provide a TCG patch. If ever it will be done in another series.
>>>>>>
>>>>>> To have a better understanding of the S390x CPU Topology and its
>>>>>> implementation in QEMU you can have a look at the documentation in the
>>>>>> last patch or follow the introduction here under.
>>>>>>
>>>>>> A short introduction
>>>>>> ====================
>>>>>>
>>>>>> CPU Topology is described in the S390 POP with essentially the description
>>>>>> of two instructions:
>>>>>>
>>>>>> PTF Perform Topology function used to poll for topology change
>>>>>>        and used to set the polarization but this part is not part of this item.
>>>>>>
>>>>>> STSI Store System Information and the SYSIB 15.1.x providing the Topology
>>>>>>        configuration.
>>>>>>
>>>>>> S390 Topology is a 6 levels hierarchical topology with up to 5 level
>>>>>>        of containers. The last topology level, specifying the CPU cores.
>>>>>>
>>>>>>        This patch series only uses the two lower levels sockets and cores.
>>>>>>             To get the information on the topology, S390 provides the STSI
>>>>>>        instruction, which stores a structures providing the list of the
>>>>>>        containers used in the Machine topology: the SYSIB.
>>>>>>        A selector within the STSI instruction allow to chose how many topology
>>>>>>        levels will be provide in the SYSIB.
>>>>>>
>>>>>>        Using the Topology List Entries (TLE) provided inside the SYSIB we
>>>>>>        the Linux kernel is able to compute the information about the cache
>>>>>>        distance between two cores and can use this information to take
>>>>>>        scheduling decisions.
>>>>>
>>>>> Do the socket, book, ... metaphors and looking at STSI from the existing
>>>>> smp infrastructure even make sense?
>>>>
>>>> Sorry, I do not understand.
>>>> I admit the cover-letter is old and I did not rewrite it really good since the first patch series.
>>>>
>>>> What we do is:
>>>> Compute the STSI from the SMP + numa + device QEMU parameters .
>>>>
>>>>>
>>>>> STSI 15.1.x reports the topology to the guest and for a virtual machine,
>>>>> this topology can be very dynamic. So a CPU can move from from one topology
>>>>> container to another, but the socket of a cpu changing while it's running seems
>>>>> a bit strange. And this isn't supported by this patch series as far as I understand,
>>>>> the only topology changes are on hotplug.
>>>>
>>>> A CPU changing from a socket to another socket is the only case the PTF instruction reports a change in the topology with the case a new CPU is plug in.
>>>
>>> Can a CPU actually change between sockets right now?
>>
>> To be exact, what I understand is that a shared CPU can be scheduled to another real CPU exactly as a guest vCPU can be scheduled by the host to another host CPU.
> 
> Ah, ok, this is what I'm forgetting, and what made communication harder,
> there are two ways by which the topology can change:
> 1. the host topology changes
> 2. the vCPU threads are scheduled on another host CPU
> 
> I've been only thinking about the 2.
> I assumed some outside entity (libvirt?) pins vCPU threads, and so it would
> be the responsibility of that entity to set the topology which then is
> reported to the guest. So if you pin vCPUs for the whole lifetime of the vm
> then you could do that by specifying the topology up front with -devices.
> If you want to support migration, then the outside entity would need a way
> to tell qemu the updated topology.

Yes

>   
>>
>>> The socket-id is computed from the core-id, so it's fixed, is it not?
>>
>> the virtual socket-id is computed from the virtual core-id
> 
> Meaning cpu.env.core_id, correct? (which is the same as cpu.cpu_index which is the same as
> ms->possible_cpus->cpus[core_id].props.core_id)
> And a cpu's core id doesn't change during the lifetime of the vm, right?

right

> And so it's socket id doesn't either.

Yes

> 
>>
>>>
>>>> It is not expected to appear often but it does appear.
>>>> The code has been removed from the kernel in spin 10 for 2 reasons:
>>>> 1) we decided to first support only dedicated and pinned CPU> 2) Christian fears it may happen too often due to Linux host scheduling and could be a performance problem
>>>
>>> This seems sensible, but now it seems too static.
>>> For example after migration, you cannot tell the guest which CPUs are in the same socket, book, ...,
>>> unless I'm misunderstanding something.
>>
>> No, to do this we would need to ask the kernel about it.
> 
> You mean polling /sys/devices/system/cpu/cpu*/topology/*_id ?
> That should work if it isn't done to frequently, right?
> And if it's done by the entity doing the pinning it could judge if the host topology change
> is relevant to the guest and if so tell qemu how to update it.

yes, I guess we will need to change the core-id which may be complicated 
or find another way to link the vCPU topology with the host CPU topology.
First I wanted to have something directly from the kernel, as we have 
there all the info on vCPU and host topology.
That is why I had a struct in the UAPI.

Viktor is as you say here for something in userland only.

For the moment I would like to stay for this patch series on a fixed 
topology, set by the admin, then we go on updating the topology.


>>
>>> And migration is rare, but something you'd want to be able to react to.
>>> And I could imaging that the vCPUs are pinned most of the time, but the pinning changes occasionally.
>>
>> I think on migration we should just make a kvm_set_mtcr on post_load like Nico suggested everything else seems complicated for a questionable benefit.
> 
> But what is the point? The result of STSI reported to the guest doesn't actually change, does it?
> Since the same CPUs with the same calculated socket-ids, ..., exist.
> You cannot migrate to a vm with a different virtual topology, since the CPUs get matched via the cpu_index
> as far as I can tell, which is the same as the core_id, or am I misunderstanding something?
> Migrating the MTCR bit is correct, if it is 1 than there was a cpu hotplug that the guest did not yet observe,
> but setting it to 1 after migration would we wrong if the STSI result would be the same.

That is a good point, IIUC it follows that:
- a CPU hotplug can not be done during the migration.
- migration can not be started while a CPU is being hot plugged.


-- 
Pierre Morel
IBM Lab Boeblingen
