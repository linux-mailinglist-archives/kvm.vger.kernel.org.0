Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EBD574ACF
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 12:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbiGNKiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 06:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiGNKio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 06:38:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF8DBC15
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 03:38:42 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EAHgfR012169;
        Thu, 14 Jul 2022 10:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=c89MAotbpP7mjF1epLU+aLmU1IY6LwLuqqJtSPn1gAE=;
 b=USGyc9xpdjlQEDodf2dZ3C9KeKhYuoT5fVDQgEkspv+TDcJpXNS02Bm0TzxuZRtLqfeL
 1nBfaz3D2E+jJF0GFm4zd1xy+EnZl0nnr9Bv9l+GScwM7UEFmMmnKgabkIbnuBhvb6uP
 nq7VxU4NyNM25XKtHXjWuwk1juUCYTlEdmMk/ODrVkfQcq7hSHps/2FJVTvrXA+3uCLi
 bU4u+twv/l4xpkyWMELhI+pTADJarb62ikthmyJfi6h2B9WaDJUmfNy4Vyn0rw7K0DfY
 UZ7/wCru5QdBB2R/btUbDU1xo8Z5bP2xJcPMD9rwJDQbBZrs6uMo1KVDXvFp0kg4Z3Gg sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hag372jk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 10:38:34 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26EAc58Z022646;
        Thu, 14 Jul 2022 10:38:34 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hag372jj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 10:38:34 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26EAb16L001650;
        Thu, 14 Jul 2022 10:38:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3h71a8n83m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 10:38:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26EAatRg19071360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 10:36:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 250614C059;
        Thu, 14 Jul 2022 10:38:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61D1D4C052;
        Thu, 14 Jul 2022 10:38:27 +0000 (GMT)
Received: from [9.171.83.159] (unknown [9.171.83.159])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 10:38:25 +0000 (GMT)
Message-ID: <53698be8-0eab-8dc2-2d54-df2a89e1092f@linux.ibm.com>
Date:   Thu, 14 Jul 2022 12:38:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v8 02/12] s390x/cpu_topology: CPU topology objects and
 structures
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-3-pmorel@linux.ibm.com>
 <de92ef17-3a17-df44-97aa-19e67d1d5b3d@linux.ibm.com>
 <5215ca74-e71c-73df-69c9-d2522e082706@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <5215ca74-e71c-73df-69c9-d2522e082706@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LJtljS1SePpbEbLskks8qTd6anDqdpBm
X-Proofpoint-ORIG-GUID: 5EDr__c9F7_eNmz-BK1V4j_J3Y0nmfSR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_08,2022-07-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207140044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/22 16:59, Pierre Morel wrote:
> 
> 
> On 7/12/22 17:40, Janis Schoetterl-Glausch wrote:
>> On 6/20/22 16:03, Pierre Morel wrote:
>>> We use new objects to have a dynamic administration of the CPU topology.
>>> The highest level object in this implementation is the s390 book and
>>> in this first implementation of CPU topology for S390 we have a single
>>> book.
>>> The book is built as a SYSBUS bridge during the CPU initialization.
>>> Other objects, sockets and core will be built after the parsing
>>> of the QEMU -smp argument.
>>>
>>> Every object under this single book will be build dynamically
>>> immediately after a CPU has be realized if it is needed.
>>> The CPU will fill the sockets once after the other, according to the
>>> number of core per socket defined during the smp parsing.
>>>
>>> Each CPU inside a socket will be represented by a bit in a 64bit
>>> unsigned long. Set on plug and clear on unplug of a CPU.
>>>
>>> For the S390 CPU topology, thread and cores are merged into
>>> topology cores and the number of topology cores is the multiplication
>>> of cores by the numbers of threads.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   hw/s390x/cpu-topology.c         | 391 ++++++++++++++++++++++++++++++++
>>>   hw/s390x/meson.build            |   1 +
>>>   hw/s390x/s390-virtio-ccw.c      |   6 +
>>>   include/hw/s390x/cpu-topology.h |  74 ++++++
>>>   target/s390x/cpu.h              |  47 ++++
>>>   5 files changed, 519 insertions(+)
>>>   create mode 100644 hw/s390x/cpu-topology.c
>>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>>

[...]

>>> +}
>>> +
>>> +/*
>>> + * s390_topology_new_cpu:
>>> + * @core_id: the core ID is machine wide
>>> + *
>>> + * We have a single book returned by s390_get_topology(),
>>> + * then we build the hierarchy on demand.
>>> + * Note that we do not destroy the hierarchy on error creating
>>> + * an entry in the topology, we just keep it empty.
>>> + * We do not need to worry about not finding a topology level
>>> + * entry this would have been caught during smp parsing.
>>> + */
>>> +bool s390_topology_new_cpu(MachineState *ms, int core_id, Error **errp)
>>> +{
>>> +    S390TopologyBook *book;
>>> +    S390TopologySocket *socket;
>>> +    S390TopologyCores *cores;
>>> +    int nb_cores_per_socket;
>>
>> num_cores_per_socket instead?
>>
>>> +    int origin, bit;
>>> +
>>> +    book = s390_get_topology();
>>> +
>>> +    nb_cores_per_socket = ms->smp.cores * ms->smp.threads;
>>
>> We don't support the multithreading facility, do we?
>> So, I think we should assert smp.threads == 1 somewhere.
>> In any case I think the correct expression would round the threads up to the next power of 2,
>> because the core_id has the thread id in the lower bits, but threads per core doesn't need to be
>> a power of 2 according to the architecture.
> 
> That is right.
> I will add that.

Add the assert?
It should probably be somewhere else.
And you can set thread > 1 today, so we'd need to handle that. (increase the number of cpus instead and print a warning?)

[...]

>>> +
>>> +/*
>>> + * Setting the first topology: 1 book, 1 socket
>>> + * This is enough for 64 cores if the topology is flat (single socket)
>>> + */
>>> +void s390_topology_setup(MachineState *ms)
>>> +{
>>> +    DeviceState *dev;
>>> +
>>> +    /* Create BOOK bridge device */
>>> +    dev = qdev_new(TYPE_S390_TOPOLOGY_BOOK);
>>> +    object_property_add_child(qdev_get_machine(),
>>> +                              TYPE_S390_TOPOLOGY_BOOK, OBJECT(dev));
>>
>> Why add it to the machine instead of directly using a static?
> 
> For my opinion it is a characteristic of the machine.
> 
>> So it's visible to the user via info qtree or something?
> 
> It is already visible to the user on info qtree.
> 
>> Would that even be the appropriate location to show that?
> 
> That is a very good question and I really appreciate if we discuss on the design before diving into details.
> 
> The idea is to have the architecture details being on qtree as object so we can plug new drawers/books/socket/cores and in the future when the infrastructure allows it unplug them.

Would it not be more accurate to say that we plug in new cpus only?
Since you need to specify the topology up front with -smp and it cannot change after.
So that all is static, books/sockets might be completely unpopulated, but they still exist in a way.
As far as I understand, STSI only allows for cpus to change, nothing above it.
> 
> There is a info numa (info cpus does not give a lot info) to give information on nodes but AFAIU, a node is more a theoritical that can be used above the virtual architecture, sockets/cores, to specify characteristics like distance and associated memory.

https://qemu.readthedocs.io/en/latest/interop/qemu-qmp-ref.html#qapidoc-2391
shows that the relevant information can be queried via qmp.
When I tried it on s390x it only showed the core_id, but we should be able to add the rest.


Am I correct in my understanding, that there are two reasons to have the hierarchy objects:
1. Caching the topology instead of computing it when STSI is called
2. So they show up in info qtree

?

> 
> As I understand it can be used above socket and for us above books or drawers too like in:
> 
> -numa cpu,node-id=0,socket-id=0
> 
> All cores in socket 0 belong to node 0
> 
> or
> -numa cpu,node-id=1,drawer-id=1
> 
> all cores from all sockets of drawer 1 belong to node 1
> 
> 
> As there is no info socket, I think that for now we do not need an info book/drawer we have everything in qtree.
> 
> 
>>

[...]

> 
>>> +    /*
>>> +     * Each CPU inside a socket will be represented by a bit in a 64bit
>>> +     * unsigned long. Set on plug and clear on unplug of a CPU.
>>> +     * All CPU inside a mask share the same dedicated, polarity and
>>> +     * cputype values.
>>> +     * The origin is the offset of the first CPU in a mask.
>>> +     */
>>> +struct S390TopologyCores {
>>> +    DeviceState parent_obj;
>>> +    int id;
>>> +    bool dedicated;
>>> +    uint8_t polarity;
>>> +    uint8_t cputype;
>>
>> Why not snake_case for cpu type?
> 
> I do not understand what you mean.

I'm suggesting s/cputype/cpu_type/
> 
>>
>>> +    uint16_t origin;
>>> +    uint64_t mask;
>>> +    int cnt;
>>
>> num_cores instead ?
> 
> I suppress this it is unused
> 
>>

[...]

>>> @@ -565,6 +565,53 @@ typedef union SysIB {
>>>   } SysIB;
>>>   QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>>>   +/* CPU type Topology List Entry */
>>> +typedef struct SysIBTl_cpu {
>>> +        uint8_t nl;
>>> +        uint8_t reserved0[3];
>>> +        uint8_t reserved1:5;
>>> +        uint8_t dedicated:1;
>>> +        uint8_t polarity:2;
>>> +        uint8_t type;
>>> +        uint16_t origin;
>>> +        uint64_t mask;
>>> +} SysIBTl_cpu;
>>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
>>> +
>>> +/* Container type Topology List Entry */
>>> +typedef struct SysIBTl_container {
>>> +        uint8_t nl;
>>> +        uint8_t reserved[6];
>>> +        uint8_t id;
>>> +} QEMU_PACKED SysIBTl_container;
>>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
>>> +
>>> +/* Generic Topology List Entry */
>>> +typedef union SysIBTl_entry {
>>> +        uint8_t nl;
>>> +        SysIBTl_container container;
>>> +        SysIBTl_cpu cpu;
>>> +} SysIBTl_entry;
>>
>> I don't like this union, it's only used in SysIB_151x below and that's misleading,
>> because the entries are packed without padding, but the union members have different
>> sizes.
> 
> the entries have different sizes 64bits and 128bits.
> I do not understand why they should be padded.

I way saying that in the SYSIB there is no padding, but the size of the union is 16,
so two container entries in the array would have padding, which is misleading.
There is no actual problem, since the array is not actually used as such.
> 
> However, the union here is useless. will remove it.
> 
>>
>>> +
>>> +#define TOPOLOGY_NR_MAG  6
>>> +#define TOPOLOGY_NR_MAG6 0
>>> +#define TOPOLOGY_NR_MAG5 1
>>> +#define TOPOLOGY_NR_MAG4 2
>>> +#define TOPOLOGY_NR_MAG3 3
>>> +#define TOPOLOGY_NR_MAG2 4
>>> +#define TOPOLOGY_NR_MAG1 5
>>> +/* Configuration topology */
>>> +typedef struct SysIB_151x {
>>> +    uint8_t  res0[2];
>>> +    uint16_t length;
>>> +    uint8_t  mag[TOPOLOGY_NR_MAG];
>>> +    uint8_t  res1;
>>> +    uint8_t  mnest;
>>> +    uint32_t res2;
>>> +    SysIBTl_entry tle[0];
>>
>> I think this should just be a uint64_t[] or uint64_t[0], whichever is QEMU style.
> 
> ok
> 
>>> +} SysIB_151x;
>>> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
>>> +
>>>   /* MMU defines */
>>>   #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
>>>   #define ASCE_SUBSPACE         0x200       /* subspace group control           */
>>
> 

