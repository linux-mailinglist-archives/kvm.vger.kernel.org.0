Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D4062D716
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239669AbiKQJcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiKQJcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:32:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C4C6D48C
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:32:33 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AH8w9OD009057;
        Thu, 17 Nov 2022 09:32:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AjOjO4XNzYqGhibj4p19QMedpqHORsCip0m6ZZFBkco=;
 b=mikOLBIf0AqiINWO72Zm6+yLwj6dJPWFLB1pKiXYS1Tgi0Q7JZeKcT/FMbtjyscbhrfq
 YXHMF3u+zwfjyC8PnwfnumEJbN8lFbo7v+T2ZFQnpdrgdtqzKkwUP2RUJ843kukVXiOP
 XCL+UVoJQ+QWgrJqMhW4prACvoe4znyb31xIYksFXgxeAtCtbVH3hIUH6lfNljoKgooL
 AdcupYCW+zaH78QP+hwc9NCQngjc+JERz7br/UUbScuw4tqL//caLgf1iR4QqBONO4Aw
 sKtbX94A9OV4C7azriBJMsR+zLruFF6YcOwEAXRJHL/FXmYSjPrDAsjJDOEiqdIFkfIa lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwhwqh56a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 09:32:10 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AH8wR5T009942;
        Thu, 17 Nov 2022 09:32:10 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwhwqh555-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 09:32:09 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AH9Nphx024744;
        Thu, 17 Nov 2022 09:32:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3kt2rj5g8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 09:32:07 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AH9W3RF48300386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 09:32:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E19D15204E;
        Thu, 17 Nov 2022 09:32:03 +0000 (GMT)
Received: from [9.171.46.61] (unknown [9.171.46.61])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DC0F252054;
        Thu, 17 Nov 2022 09:32:02 +0000 (GMT)
Message-ID: <34caa4c4-0b94-1729-fe88-77d9b4240f04@linux.ibm.com>
Date:   Thu, 17 Nov 2022 10:32:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v11 04/11] s390x/cpu topology: reporting the CPU topology
 to the guest
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-5-pmorel@linux.ibm.com>
 <1888d31f-227f-7edf-4cc8-dd88a9b19435@kaod.org>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <1888d31f-227f-7edf-4cc8-dd88a9b19435@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CZ1XZWcwmZ3V0-8dFjZI3GocC4yn3eiD
X-Proofpoint-GUID: BjQenOlUiMX1NgZgxsqgnCkBdMIIUanj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_05,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/17/22 09:40, Cédric Le Goater wrote:
> On 11/3/22 18:01, Pierre Morel wrote:
>> The guest can use the STSI instruction to get a buffer filled
>> with the CPU topology description.
>>
>> Let us implement the STSI instruction for the basis CPU topology
>> level, level 2.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h |   6 ++
>>   target/s390x/cpu.h              |  77 ++++++++++++++++++++++++
>>   hw/s390x/cpu-topology.c         |   1 -
>>   target/s390x/cpu_topology.c     | 100 ++++++++++++++++++++++++++++++++
>>   target/s390x/kvm/kvm.c          |   6 +-
>>   target/s390x/meson.build        |   1 +
>>   6 files changed, 189 insertions(+), 2 deletions(-)
>>   create mode 100644 target/s390x/cpu_topology.c
>>
>> diff --git a/include/hw/s390x/cpu-topology.h 
>> b/include/hw/s390x/cpu-topology.h
>> index 4e16a2153d..6fec10e032 100644
>> --- a/include/hw/s390x/cpu-topology.h
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -16,6 +16,11 @@
>>   #define S390_TOPOLOGY_CPU_IFL 0x03
>>   #define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
>> +#define S390_TOPOLOGY_POLARITY_HORIZONTAL      0x00
>> +#define S390_TOPOLOGY_POLARITY_VERTICAL_LOW    0x01
>> +#define S390_TOPOLOGY_POLARITY_VERTICAL_MEDIUM 0x02
>> +#define S390_TOPOLOGY_POLARITY_VERTICAL_HIGH   0x03
>> +
>>   typedef struct S390TopoSocket {
>>       int active_count;
>>       uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
>> @@ -26,6 +31,7 @@ struct S390Topology {
>>       uint32_t nr_cpus;
>>       uint32_t nr_sockets;
>>       S390TopoSocket *socket;
>> +    bool topology_needed;
>>   };
>>   #define TYPE_S390_CPU_TOPOLOGY "s390-topology"
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index c9066b2496..69a7523146 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>> @@ -567,6 +567,81 @@ typedef union SysIB {
>>   } SysIB;
>>   QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>> +/*
>> + * CPU Topology List provided by STSI with fc=15 provides a list
>> + * of two different Topology List Entries (TLE) types to specify
>> + * the topology hierarchy.
>> + *
>> + * - Container Topology List Entry
>> + *   Defines a container to contain other Topology List Entries
>> + *   of any type, nested containers or CPU.
>> + * - CPU Topology List Entry
>> + *   Specifies the CPUs position, type, entitlement and polarization
>> + *   of the CPUs contained in the last Container TLE.
>> + *
>> + * There can be theoretically up to five levels of containers, QEMU
>> + * uses only one level, the socket level.
>> + *
>> + * A container of with a nesting level (NL) greater than 1 can only
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
>> +        uint8_t nl;
>> +        uint8_t reserved[6];
>> +        uint8_t id;
>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
>> +
>> +/* CPU type Topology List Entry */
>> +typedef struct SysIBTl_cpu {
>> +        uint8_t nl;
>> +        uint8_t reserved0[3];
>> +        uint8_t reserved1:5;
>> +        uint8_t dedicated:1;
>> +        uint8_t polarity:2;
>> +        uint8_t type;
>> +        uint16_t origin;
>> +        uint64_t mask;
>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_cpu;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
>> +
>> +#define S390_TOPOLOGY_MAG  6
>> +#define S390_TOPOLOGY_MAG6 0
>> +#define S390_TOPOLOGY_MAG5 1
>> +#define S390_TOPOLOGY_MAG4 2
>> +#define S390_TOPOLOGY_MAG3 3
>> +#define S390_TOPOLOGY_MAG2 4
>> +#define S390_TOPOLOGY_MAG1 5
>> +/* Configuration topology */
>> +typedef struct SysIB_151x {
>> +    uint8_t  reserved0[2];
>> +    uint16_t length;
>> +    uint8_t  mag[S390_TOPOLOGY_MAG];
>> +    uint8_t  reserved1;
>> +    uint8_t  mnest;
>> +    uint32_t reserved2;
>> +    char tle[0];
>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
>> +
>> +/* Max size of a SYSIB structure is when all CPU are alone in a 
>> container */
>> +#define S390_TOPOLOGY_SYSIB_SIZE (sizeof(SysIB_151x) 
>> +                         \
>> +                                  S390_MAX_CPUS * 
>> (sizeof(SysIBTl_container) + \
>> +                                                   sizeof(SysIBTl_cpu)))
>> +
>> +
>>   /* MMU defines */
>>   #define ASCE_ORIGIN           (~0xfffULL) /* segment table 
>> origin             */
>>   #define ASCE_SUBSPACE         0x200       /* subspace group 
>> control           */
>> @@ -845,4 +920,6 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
>>   #include "exec/cpu-all.h"
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
>> +
>>   #endif
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index 6af41d3d7b..9fa8ca1261 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -44,7 +44,6 @@ void s390_topology_new_cpu(S390CPU *cpu)
>>       int socket_id;
>>       socket_id = core_id / topo->nr_cpus;
>> -
>>       /*
>>        * At the core level, each CPU is represented by a bit in a 64bit
>>        * uint64_t which represent the presence of a CPU.
>> diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
>> new file mode 100644
>> index 0000000000..a1179d8e95
>> --- /dev/null
>> +++ b/target/s390x/cpu_topology.c
>> @@ -0,0 +1,100 @@
>> +/*
>> + * QEMU S390x CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or 
>> (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
>> +#include "qemu/osdep.h"
>> +#include "cpu.h"
>> +#include "hw/s390x/pv.h"
>> +#include "hw/sysbus.h"
>> +#include "hw/s390x/cpu-topology.h"
>> +#include "hw/s390x/sclp.h"
>> +
>> +static char *fill_container(char *p, int level, int id)
>> +{
>> +    SysIBTl_container *tle = (SysIBTl_container *)p;
>> +
>> +    tle->nl = level;
>> +    tle->id = id;
>> +    return p + sizeof(*tle);
>> +}
>> +
>> +static char *fill_tle_cpu(char *p, uint64_t mask, int origin)
>> +{
>> +    SysIBTl_cpu *tle = (SysIBTl_cpu *)p;
>> +
>> +    tle->nl = 0;
>> +    tle->dedicated = 1;
>> +    tle->polarity = S390_TOPOLOGY_POLARITY_HORIZONTAL;
>> +    tle->type = S390_TOPOLOGY_CPU_IFL;
>> +    tle->origin = cpu_to_be64(origin * 64);
>> +    tle->mask = cpu_to_be64(mask);
>> +    return p + sizeof(*tle);
>> +}
>> +
>> +static char *s390_top_set_level2(S390Topology *topo, char *p)
>> +{
>> +    int i, origin;
>> +
>> +    for (i = 0; i < topo->nr_sockets; i++) {
>> +        if (!topo->socket[i].active_count) {
>> +            continue;
>> +        }
>> +        p = fill_container(p, 1, i);
>> +        for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; origin++) {
>> +            uint64_t mask = 0L;
>> +
>> +            mask = topo->socket[i].mask[origin];
>> +            if (mask) {
>> +                p = fill_tle_cpu(p, mask, origin);
>> +            }
>> +        }
>> +    }
>> +    return p;
>> +}
> 
> Why is it not possible to compute this topo information at "runtime",
> when stsi is called, without maintaining state in an extra S390Topology
> object ? Couldn't we loop on the CPU list to gather the topology bits
> for the same result ?
> 
> It would greatly simplify the feature.
> 
> C.
> 

The vCPU are not stored in order of creation in the CPU list and not in 
a topology order.
To be able to build the SYSIB we need an intermediate structure to 
reorder the CPUs per container.

We can do this re-ordering during the STSI interception but the idea was 
to keep this instruction as fast as possible.

The second reason is to have a structure ready for the QEMU migration 
when we introduce vCPU migration from a socket to another socket, having 
then a different internal representation of the topology.


However, if as discussed yesterday we use a new cpu flag we would not 
need any special migration structure in the current series.

So it only stays the first reason to do the re-ordering preparation 
during the plugging of a vCPU, to optimize the STSI instruction.

If we think the optimization is not worth it or do not bring enough to 
be consider, we can do everything during the STSI interception.

Regards,
Pierre

>> +static int setup_stsi(S390CPU *cpu, SysIB_151x *sysib, int level)
>> +{
>> +    S390Topology *topo = (S390Topology *)cpu->topology;
>> +    char *p = sysib->tle;
>> +
>> +    sysib->mnest = level;
>> +    switch (level) {
>> +    case 2:
>> +        sysib->mag[S390_TOPOLOGY_MAG2] = topo->nr_sockets;
>> +        sysib->mag[S390_TOPOLOGY_MAG1] = topo->nr_cpus;
>> +        p = s390_top_set_level2(topo, p);
>> +        break;
>> +    }
>> +
>> +    return p - (char *)sysib;
>> +}
>> +
>> +#define S390_TOPOLOGY_MAX_MNEST 2
>> +
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>> +{
>> +    union {
>> +        char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
>> +        SysIB_151x sysib;
>> +    } buffer QEMU_ALIGNED(8);
>> +    int len;
>> +
>> +    if (s390_is_pv() || !s390_has_topology() ||
>> +        sel2 < 2 || sel2 > S390_TOPOLOGY_MAX_MNEST) {
>> +        setcc(cpu, 3);
>> +        return;
>> +    }
>> +
>> +    len = setup_stsi(cpu, &buffer.sysib, sel2);
>> +
>> +    buffer.sysib.length = cpu_to_be16(len);
>> +    s390_cpu_virt_mem_write(cpu, addr, ar, &buffer.sysib, len);
>> +    setcc(cpu, 0);
>> +}
>> +
>> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
>> index 3ac7ec9acf..7dc96f3663 100644
>> --- a/target/s390x/kvm/kvm.c
>> +++ b/target/s390x/kvm/kvm.c
>> @@ -51,6 +51,7 @@
>>   #include "hw/s390x/s390-virtio-ccw.h"
>>   #include "hw/s390x/s390-virtio-hcall.h"
>>   #include "hw/s390x/pv.h"
>> +#include "hw/s390x/cpu-topology.h"
>>   #ifndef DEBUG_KVM
>>   #define DEBUG_KVM  0
>> @@ -1919,9 +1920,12 @@ static int handle_stsi(S390CPU *cpu)
>>           if (run->s390_stsi.sel1 != 2 || run->s390_stsi.sel2 != 2) {
>>               return 0;
>>           }
>> -        /* Only sysib 3.2.2 needs post-handling for now. */
>>           insert_stsi_3_2_2(cpu, run->s390_stsi.addr, run->s390_stsi.ar);
>>           return 0;
>> +    case 15:
>> +        insert_stsi_15_1_x(cpu, run->s390_stsi.sel2, 
>> run->s390_stsi.addr,
>> +                           run->s390_stsi.ar);
>> +        return 0;
>>       default:
>>           return 0;
>>       }
>> diff --git a/target/s390x/meson.build b/target/s390x/meson.build
>> index 84c1402a6a..890ccfa789 100644
>> --- a/target/s390x/meson.build
>> +++ b/target/s390x/meson.build
>> @@ -29,6 +29,7 @@ s390x_softmmu_ss.add(files(
>>     'sigp.c',
>>     'cpu-sysemu.c',
>>     'cpu_models_sysemu.c',
>> +  'cpu_topology.c',
>>   ))
>>   s390x_user_ss = ss.source_set()
> 

-- 
Pierre Morel
IBM Lab Boeblingen
