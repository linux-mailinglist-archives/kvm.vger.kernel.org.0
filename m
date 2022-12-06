Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B973964415B
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 11:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiLFKin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 05:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiLFKik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 05:38:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A1560CF
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 02:38:39 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B69ctoN003315;
        Tue, 6 Dec 2022 10:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hH/FTXgZ2yOU/NoP/VcobPa1vmlSn3wBI5iT7xZtYfY=;
 b=j8VTF9Ib2qeCU3r5UlqiiVen2907lXGF+ChXxPVPcZGVYmX3BIPraOk67RXZJVzUij33
 CqWvogx+x6ok98ot1GL9LaYJpQ8KnAzc4kqJzF2a6iOquoBAvMVUDThsLaDphiTsuVvW
 62hHxCnEcFna+5yHHc4f0oRC3rDHxAJC31pPY8Ea9pf4fpsUZKL1waiiWQwh0ROealkL
 3vcw1nda6H970K3Su+ao4v9rt6o+F/p71toG0YezlAkLzNESood2TJuxuOKr80Q05bqg
 EQskMykm5x94xfvvhRWz89bPyYWF8S53chIDmozJrdYKGY2bbw5K+7h56WOL96HM/K4N vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m9wybgk16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 10:38:31 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6A727p015275;
        Tue, 6 Dec 2022 10:38:31 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m9wybgk0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 10:38:31 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B69XW1s010875;
        Tue, 6 Dec 2022 10:38:29 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3m9kvb97fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 10:38:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com ([9.149.105.58])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6AcPjF36176216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 10:38:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D24E4C044;
        Tue,  6 Dec 2022 10:38:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53E434C040;
        Tue,  6 Dec 2022 10:38:24 +0000 (GMT)
Received: from [9.171.52.4] (unknown [9.171.52.4])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 10:38:24 +0000 (GMT)
Message-ID: <d883f3be-0ded-72bb-a08a-29a43ffa3a09@linux.ibm.com>
Date:   Tue, 6 Dec 2022 11:38:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v12 2/7] s390x/cpu topology: reporting the CPU topology to
 the guest
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-3-pmorel@linux.ibm.com>
 <be6e4c3a2a3b1b4a944ce0558d3e852f78bd9645.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <be6e4c3a2a3b1b4a944ce0558d3e852f78bd9645.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mIuWOCddOuwxnZNRsL3CX8gtROREdTvF
X-Proofpoint-ORIG-GUID: Qct7h4vLui3bkWNwQ1HDfMSB7acpPaK2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_05,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060088
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/22 10:48, Janis Schoetterl-Glausch wrote:
> On Tue, 2022-11-29 at 18:42 +0100, Pierre Morel wrote:
>> The guest uses the STSI instruction to get information on the
>> CPU topology.
>>
>> Let us implement the STSI instruction for the basis CPU topology
>> level, level 2.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   target/s390x/cpu.h          |  77 +++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c  |  12 +--
>>   target/s390x/cpu_topology.c | 186 ++++++++++++++++++++++++++++++++++++
>>   target/s390x/kvm/kvm.c      |   6 +-
>>   target/s390x/meson.build    |   1 +
>>   5 files changed, 274 insertions(+), 8 deletions(-)
>>   create mode 100644 target/s390x/cpu_topology.c
>>
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index 7d6d01325b..dd878ac916 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>>
> [...]
> 
>> +/* Configuration topology */
>> +typedef struct SysIB_151x {
>> +    uint8_t  reserved0[2];
>> +    uint16_t length;
>> +    uint8_t  mag[S390_TOPOLOGY_MAG];
>> +    uint8_t  reserved1;
>> +    uint8_t  mnest;
>> +    uint32_t reserved2;
>> +    char tle[0];
> 
> AFAIK [] is preferred over [0].

grr, yes, I think I have been already told so :)


> 
>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
> 
> [...]
>>
>> +/*
>> + * s390_topology_add_cpu:
>> + * @topo: pointer to the topology
>> + * @cpu : pointer to the new CPU
>> + *
>> + * The topology pointed by S390CPU, gives us the CPU topology
>> + * established by the -smp QEMU aruments.
>> + * The core-id is used to calculate the position of the CPU inside
>> + * the topology:
>> + *  - the socket, container TLE, containing the CPU, we have one socket
>> + *    for every num_cores cores.
>> + *  - the CPU TLE inside the socket, we have potentionly up to 4 CPU TLE
>> + *    in a container TLE with the assumption that all CPU are identical
>> + *    with the same polarity and entitlement because we have maximum 256
>> + *    CPUs and each TLE can hold up to 64 identical CPUs.
>> + *  - the bit in the 64 bit CPU TLE core mask
>> + */
>> +static void s390_topology_add_cpu(S390Topology *topo, S390CPU *cpu)
>> +{
>> +    int core_id = cpu->env.core_id;
>> +    int bit, origin;
>> +    int socket_id;
>> +
>> +    cpu->machine_data = topo;
>> +    socket_id = core_id / topo->num_cores;
>> +    /*
>> +     * At the core level, each CPU is represented by a bit in a 64bit
>> +     * uint64_t which represent the presence of a CPU.
>> +     * The firmware assume that all CPU in a CPU TLE have the same
>> +     * type, polarization and are all dedicated or shared.
>> +     * In that case the origin variable represents the offset of the first
>> +     * CPU in the CPU container.
>> +     * More than 64 CPUs per socket are represented in several CPU containers
>> +     * inside the socket container.
>> +     * The only reason to have several S390TopologyCores inside a socket is
>> +     * to have more than 64 CPUs.
>> +     * In that case the origin variable represents the offset of the first CPU
>> +     * in the CPU container. More than 64 CPUs per socket are represented in
>> +     * several CPU containers inside the socket container.
>> +     */
> 
> This comment still contains redundant sentences.
> Did you have a look at my suggestion in v10 patch 1?

Yes, I had, and sorry, I forgot to report here inside the patch 11.
I will take it, thanks for it.

> 
>> +    bit = core_id;
>> +    origin = bit / 64;
>> +    bit %= 64;
>> +    bit = 63 - bit;
>> +
>> +    topo->socket[socket_id].active_count++;
>> +    set_bit(bit, &topo->socket[socket_id].mask[origin]);
>> +}
>> +
>> +/*
>> + * s390_prepare_topology:
>> + * @s390ms : pointer to the S390CcwMachite State
>> + *
>> + * Calls s390_topology_add_cpu to organize the topology
>> + * inside the topology device before writing the SYSIB.
>> + *
>> + * The topology is currently fixed on boot and do not change
> 
> does not change

yes, thanks


regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
