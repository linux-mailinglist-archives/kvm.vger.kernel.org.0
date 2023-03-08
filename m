Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84886B0C92
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 16:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjCHPYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 10:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjCHPYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 10:24:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF1660AB5
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 07:24:35 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328EGrIh028349;
        Wed, 8 Mar 2023 15:24:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cwv9W1Z1/PryWc40CBifjaXA3AIX0Q8YofBF3zmmnxA=;
 b=eThgYWtebwwHMz+uj9y5ZSt1VTU0nGRyjxgfv4Rawt4IrIsCOSF+dg5qwpPuggDbXrC9
 Dp6RNOGLSpVFw0JO56nZN75/2+ubePMcSURZg1RXgXCaB3WsQkJmq2+rqCPbE+tEAvGE
 uMGbFzQtSMFOcL/enESkJAcfd/Df0to6jka7bOz9RXQFRFYMioIhrwXLQO3gSoDq4cLd
 R4ZMfY3umdWhcD+aJkow+j1CovwAdT4h76is9jW6DPdvCGJe9IMr4lwFAmDu67srEpTi
 mrQdvhSxONstAGSSS9jQBK5iFG2xviy6vLlbIIUh6MYR9pmSxeenpFjdiba4LKubgWLC BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6pmxa5cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 15:24:27 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 328FIWqG009241;
        Wed, 8 Mar 2023 15:24:26 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6pmxa5ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 15:24:26 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3280dFnK002812;
        Wed, 8 Mar 2023 15:24:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3p6g0pgr15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 15:24:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 328FOKo040042982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 15:24:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E267220040;
        Wed,  8 Mar 2023 15:24:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84D1F2004D;
        Wed,  8 Mar 2023 15:24:18 +0000 (GMT)
Received: from [9.179.28.81] (unknown [9.179.28.81])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  8 Mar 2023 15:24:18 +0000 (GMT)
Message-ID: <c924933e-4814-e7d8-e62b-76cc7f68fba4@linux.ibm.com>
Date:   Wed, 8 Mar 2023 16:24:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 03/11] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-4-pmorel@linux.ibm.com>
 <01fa83156fa7452b0e45fe9df8d799b1f3589295.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <01fa83156fa7452b0e45fe9df8d799b1f3589295.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FIJRCvJGtB0jao56Vh1zzl99z4AZhk_L
X-Proofpoint-ORIG-GUID: VsJ2ubrDMumfjN9nyfk1NvkvVR8vszZF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_08,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080129
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/27/23 14:21, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-22 at 15:20 +0100, Pierre Morel wrote:
>> On interception of STSI(15.1.x) the System Information Block
>> (SYSIB) is built from the list of pre-ordered topology entries.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h |  21 +++
>>   include/hw/s390x/sclp.h         |   1 +
>>   target/s390x/cpu.h              |  72 ++++++++
>>   hw/s390x/cpu-topology.c         |  14 +-
>>   target/s390x/kvm/cpu_topology.c | 312 ++++++++++++++++++++++++++++++++
>>   target/s390x/kvm/kvm.c          |   5 +-
>>   target/s390x/kvm/meson.build    |   3 +-
>>   7 files changed, 425 insertions(+), 3 deletions(-)
>>   create mode 100644 target/s390x/kvm/cpu_topology.c
>>
>> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
>> index fa7f885a9f..8dc42d2942 100644
>> --- a/include/hw/s390x/cpu-topology.h
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -16,8 +16,29 @@
>>   
>>   #define S390_TOPOLOGY_CPU_IFL   0x03
>>   
>> +typedef union s390_topology_id {
>> +    uint64_t id;
>> +    struct {
>> +        uint8_t level5;
> You could rename this to sentinel, since that's the only use case and
> if there ever is another level the sentinel implementation might need
> to be changed anyway.


OK


>
>> +        uint8_t drawer;
>> +        uint8_t book;
>> +        uint8_t socket;
>> +        uint8_t dedicated;
>> +        uint8_t entitlement;
>> +        uint8_t type;
>> +        uint8_t origin;
>> +    };
>> +} s390_topology_id;
>> +
>>
> [...]
>
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index d654267a71..c899f4e04b 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>> @@ -560,6 +560,25 @@ typedef struct SysIB_322 {
>>
> [...]
>>   
>> +/*
>> + * CPU Topology List provided by STSI with fc=15 provides a list
>> + * of two different Topology List Entries (TLE) types to specify
>> + * the topology hierarchy.
>> + *
>> + * - Container Topology List Entry
>> + *   Defines a container to contain other Topology List Entries
>> + *   of any type, nested containers or CPU.
>> + * - CPU Topology List Entry
>> + *   Specifies the CPUs position, type, entitlement and polarization
>> + *   of the CPUs contained in the last Container TLE.
>> + *
>> + * There can be theoretically up to five levels of containers, QEMU
>> + * uses only three levels, the drawer's, book's and socket's level.
>> + *
>> + * A container of with a nesting level (NL) greater than 1 can only
> s/of//


thanks.


>
>> + * contain another container of nesting level NL-1.
>> + *
>> + * A container of nesting level 1 (socket), contains as many CPU TLE
>> + * as needed to describe the position and qualities of all CPUs inside
>> + * the container.
>> + * The qualities of a CPU are polarization, entitlement and type.
>> + *
>> + * The CPU TLE defines the position of the CPUs of identical qualities
>> + * using a 64bits mask which first bit has its offset defined by
>> + * the CPU address orgin field of the CPU TLE like in:
>> + * CPU address = origin * 64 + bit position within the mask
>> + *
>> + */
>> +/* Container type Topology List Entry */
>> +typedef struct SysIBTl_container {
>> +        uint8_t nl;
>> +        uint8_t reserved[6];
>> +        uint8_t id;
>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
>> +
> [...]
>> +
>> +/**
>> + * s390_topology_from_cpu:
>> + * @cpu: The S390CPU
>> + *
>> + * Initialize the topology id from the CPU environment.
>> + */
>> +static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
>> +{
>> +    s390_topology_id topology_id = {0};
>> +
>> +    topology_id.drawer = cpu->env.drawer_id;
>> +    topology_id.book = cpu->env.book_id;
>> +    topology_id.socket = cpu->env.socket_id;
>> +    topology_id.origin = cpu->env.core_id / 64;
>> +    topology_id.type = S390_TOPOLOGY_CPU_IFL;
>> +    topology_id.dedicated = cpu->env.dedicated;
>> +
>> +    if (s390_topology.polarization == S390_CPU_POLARIZATION_VERTICAL) {
>> +        /*
>> +         * Vertical polarization with dedicated CPU implies
>> +         * vertical high entitlement.
>> +         */
>> +        if (topology_id.dedicated) {
>> +            topology_id.entitlement = S390_CPU_ENTITLEMENT_HIGH;
>> +        } else {
>> +            topology_id.entitlement = cpu->env.entitlement;
>> +        }
> I don't see why you need this if, it should already be correct.
>
>> +    }
> I'd suggest the following:
> * rename entitlement in s390_topology_id back to polarization, but keep entitlement everywhere else.
> * remove horizontal/none from CpuS390Entitlement, this way the user cannot set it,
> 	and it doesn't show up in the output of query-cpus-fast.
> * this is where you convert between the two, so:
> 	if horizontal, id.polarization = 0,
> 	otherwise id.polarization = entitlement + 1, or a switch case.
> * in patch 6 in s390_topology_set_cpus_entitlement you don't set the entitlement if the polarization
> 	is horizontal, which is ok because of the conversion above.

I do not like to remove the horizontal entitlement from the enum because 
every
existing s390 tool show "horizontal" entitlement when the polarization 
is horizontal.

See, lscpu -e or "/sys/devices/system/cpu/cpu*/polarization"

Also, the user may find strange that a field is missing depending of the 
polarization in the output of query-cpu-fast.

Regards,

Pierre


