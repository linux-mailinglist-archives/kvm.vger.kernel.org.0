Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F4C68B969
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 11:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBFKHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 05:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBFKHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 05:07:23 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EA25BAF
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 02:07:09 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3168I87C024747;
        Mon, 6 Feb 2023 10:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gjm+E47Uf4evzqjCsLQTKxWww0U9VnihNEhRNdaKyns=;
 b=Ixt186DdJG1vJHF6u7mgHyaMSwrKICg3p6B6qv1gi3t5qgQB7/4tGy9Icdmkyr18ohKx
 Yi+luacrAjmszOCSi2dVrgsQ9mZg8LpXHjtElO8NziLCki4Zox0gw+gjBqA9hwdKWajv
 WqSZvdBdMBBH+8wr2d8iu+WJpiTP+5EogzjynekNb3FxwIlm2jtoxlJgMdjmiT35NTP4
 WEQbIjwWs1FSxNBNax8seK5KeKfcaqHl+oImJ/sHWdazjHbX9az7edV5HBHpbmHRaiyo
 BzEltbPKk4lpI4Ct/9NV49B2F0egLo6IMdCUf/qLtreybBmKEmfh55daSObWUopoll9w 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3njwwvtj4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:06:55 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3169vkOZ016687;
        Mon, 6 Feb 2023 10:06:54 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3njwwvtj3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:06:54 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3158MIMq017584;
        Mon, 6 Feb 2023 10:06:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3nhemfhkws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:06:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316A6mOo40305122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 10:06:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC1B020077;
        Mon,  6 Feb 2023 10:06:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EA3620076;
        Mon,  6 Feb 2023 10:06:47 +0000 (GMT)
Received: from [9.171.30.242] (unknown [9.171.30.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 10:06:47 +0000 (GMT)
Message-ID: <91372a70-660e-8b30-4062-ccbb50226c99@linux.ibm.com>
Date:   Mon, 6 Feb 2023 11:06:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 03/11] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-4-pmorel@linux.ibm.com>
 <7785ea2cb7530647fcc38321d81745ce16f8055f.camel@linux.ibm.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <7785ea2cb7530647fcc38321d81745ce16f8055f.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kR6wUVwy1CDNQ92vMkRcfyCuyub7R7kv
X-Proofpoint-ORIG-GUID: 4Kmg_1-AKr3UHZ7PFwfkApRtGtwq8xc7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_05,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060087
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/3/23 18:36, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
>>> On interception of STSI(15.1.x) the System Information Block
>>> (SYSIB) is built from the list of pre-ordered topology entries.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   include/hw/s390x/cpu-topology.h |  22 +++
>>>   include/hw/s390x/sclp.h         |   1 +
>>>   target/s390x/cpu.h              |  72 +++++++
>>>   hw/s390x/cpu-topology.c         |  10 +
>>>   target/s390x/kvm/cpu_topology.c | 335 ++++++++++++++++++++++++++++++++
>>>   target/s390x/kvm/kvm.c          |   5 +-
>>>   target/s390x/kvm/meson.build    |   3 +-
>>>   7 files changed, 446 insertions(+), 2 deletions(-)
>>>   create mode 100644 target/s390x/kvm/cpu_topology.c
>>>
> [...]
>>>
>>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>>> index d654267a71..e1f6925856 100644
>>> --- a/target/s390x/cpu.h
>>> +++ b/target/s390x/cpu.h
> [...]
>>> +
>>> +/* CPU type Topology List Entry */
>>> +typedef struct SysIBTl_cpu {
>>> +        uint8_t nl;
>>> +        uint8_t reserved0[3];
>>> +#define SYSIB_TLE_POLARITY_MASK 0x03
>>> +#define SYSIB_TLE_DEDICATED     0x04
>>> +        uint8_t entitlement;
> 
> I would just call this flags, since it's multiple fields.

OK

> 
>>> +        uint8_t type;
>>> +        uint16_t origin;
>>> +        uint64_t mask;
>>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_cpu;
>>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
>>>
>>> +
>>>
> [...]
>>>   /**
>>> diff --git a/target/s390x/kvm/cpu_topology.c b/target/s390x/kvm/cpu_topology.c
>>> new file mode 100644
>>> index 0000000000..aba141fb66
>>> --- /dev/null
>>> +++ b/target/s390x/kvm/cpu_topology.c
>>>
> [...]
>>> +
>>> +/*
>>> + * Macro to check that the size of data after increment
>>> + * will not get bigger than the size of the SysIB.
>>> + */
>>> +#define SYSIB_GUARD(data, x) do {       \
>>> +        data += x;                      \
>>> +        if (data  > sizeof(SysIB)) {    \
>>> +            return -ENOSPC;             \
> 
> I would go with ENOMEM here.

Considering your comment of the length in insert_stsi_15_1_x(), I think 
the best would be to return 0.
Because:
- We do not need to report any error reason.
- The value will be forwarded to insert_stsi_15_1_x() as the length of 
the SYSIB to write
- On error we do not write the SYSIB (len = 0)
- In normal case the return value is always non zero and positive.

> 
>>> +        }                               \
>>> +    } while (0)
>>> +
>>> +/**
>>> + * stsi_set_tle:
>>> + * @p: A pointer to the position of the first TLE
>>> + * @level: The nested level wanted by the guest
>>> + *
>>> + * Loop inside the s390_topology.list until the sentinelle entry
> 
> s/sentinelle/sentinel/

OK, thx,

> 
>>> + * is found and for each entry:
>>> + *   - Check using SYSIB_GUARD() that the size of the SysIB is not
>>> + *     reached.
>>> + *   - Add all the container TLE needed for the level
>>> + *   - Add the CPU TLE.
> 
> I'd focus more on *what* the function does instead of *how*.

Right.

> 
> Fill the SYSIB with the topology information as described in the PoP,
> nesting containers as appropriate, with the maximum nesting limited by @level.
> 
> Or something similar.

Thanks, looks good to me .

> 
>>> + *
>>> + * Return value:
>>> + * s390_top_set_level returns the size of the SysIB_15x after being
> 
> You forgot to rename the function here, right?
> How about stsi_fill_topology_sysib or stsi_topology_fill_sysib, instead?


OK with stsi_topology_fill_sysib()

> 
>>> + * filled with TLE on success.
>>> + * It returns -ENOSPC in the case we would overrun the end of the SysIB.
> 
> You would have to change to ENOMEM here than also.

As discussed above, it seems to me that return 0 is even better.

> 
>>> + */
>>> +static int stsi_set_tle(char *p, int level)
>>> +{
>>> +    S390TopologyEntry *entry;
>>> +    int last_drawer = -1;
>>> +    int last_book = -1;
>>> +    int last_socket = -1;
>>> +    int drawer_id = 0;
>>> +    int book_id = 0;
>>> +    int socket_id = 0;
>>> +    int n = sizeof(SysIB_151x);
>>> +
>>> +    QTAILQ_FOREACH(entry, &s390_topology.list, next) {
>>> +        int current_drawer = entry->id.drawer;
>>> +        int current_book = entry->id.book;
>>> +        int current_socket = entry->id.socket;
> 
> This only saves two characters, so you could just use entry->id. ...

OK

> 
>>> +        bool drawer_change = last_drawer != current_drawer;
>>> +        bool book_change = drawer_change || last_book != current_book;
>>> +        bool socket_change = book_change || last_socket != current_socket;
> 
> ... but keep it if it would make this line too long.

it is OK

> You could also rename entry, to current or cur, if you want to emphasize that.
> 
>>> +
>>> +        /* If we reach the guard get out */
>>> +        if (entry->id.level5) {
>>> +            break;
>>> +        }
>>> +
>>> +        if (level > 3 && drawer_change) {
>>> +            SYSIB_GUARD(n, sizeof(SysIBTl_container));
>>> +            p = fill_container(p, 3, drawer_id++);
>>> +            book_id = 0;
>>> +        }
>>> +        if (level > 2 && book_change) {
>>> +            SYSIB_GUARD(n, sizeof(SysIBTl_container));
>>> +            p = fill_container(p, 2, book_id++);
>>> +            socket_id = 0;
>>> +        }
>>> +        if (socket_change) {
>>> +            SYSIB_GUARD(n, sizeof(SysIBTl_container));
>>> +            p = fill_container(p, 1, socket_id++);
>>> +        }
>>> +
>>> +        SYSIB_GUARD(n, sizeof(SysIBTl_cpu));
>>> +        p = fill_tle_cpu(p, entry);
>>> +        last_drawer = entry->id.drawer;
>>> +        last_book = entry->id.book;
>>> +        last_socket = entry->id.socket;
>>> +    }
>>> +
>>> +    return n;
>>> +}
>>> +
>>> +/**
>>> + * setup_stsi:
>>> + * sysib: pointer to a SysIB to be filled with SysIB_151x data
>>> + * level: Nested level specified by the guest
>>> + *
>>> + * Setup the SysIB_151x header before calling stsi_set_tle with
>>> + * a pointer to the first TLE entry.
> 
> Same thing here with regards to describing the what.
> 
> Setup the SYSIB for STSI 15.1, the header as well as the description
> of the topology.


OK, thx

> 
>>> + */
>>> +static int setup_stsi(SysIB_151x *sysib, int level)
>>> +{
>>> +    sysib->mnest = level;
>>> +    switch (level) {
>>> +    case 4:
>>> +        sysib->mag[S390_TOPOLOGY_MAG4] = current_machine->smp.drawers;
>>> +        sysib->mag[S390_TOPOLOGY_MAG3] = current_machine->smp.books;
>>> +        sysib->mag[S390_TOPOLOGY_MAG2] = current_machine->smp.sockets;
>>> +        sysib->mag[S390_TOPOLOGY_MAG1] = current_machine->smp.cores;
>>> +        break;
>>> +    case 3:
>>> +        sysib->mag[S390_TOPOLOGY_MAG3] = current_machine->smp.drawers *
>>> +                                         current_machine->smp.books;
>>> +        sysib->mag[S390_TOPOLOGY_MAG2] = current_machine->smp.sockets;
>>> +        sysib->mag[S390_TOPOLOGY_MAG1] = current_machine->smp.cores;
>>> +        break;
>>> +    case 2:
>>> +        sysib->mag[S390_TOPOLOGY_MAG2] = current_machine->smp.drawers *
>>> +                                         current_machine->smp.books *
>>> +                                         current_machine->smp.sockets;
>>> +        sysib->mag[S390_TOPOLOGY_MAG1] = current_machine->smp.cores;
>>> +        break;
>>> +    }
>>> +
>>> +    return stsi_set_tle(sysib->tle, level);
>>> +}
>>> +
>>> +/**
>>> + * s390_topology_add_cpu_to_entry:
>>> + * @entry: Topology entry to setup
>>> + * @cpu: the S390CPU to add
>>> + *
>>> + * Set the core bit inside the topology mask and
>>> + * increments the number of cores for the socket.
>>> + */
>>> +static void s390_topology_add_cpu_to_entry(S390TopologyEntry *entry,
>>> +                                           S390CPU *cpu)
>>> +{
>>> +    set_bit(63 - (cpu->env.core_id % 64), &entry->mask);
>>> +}
>>> +
>>> +/**
>>> + * s390_topology_new_entry:
>>> + * @id: s390_topology_id to add
>>> + * @cpu: the S390CPU to add
>>> + *
>>> + * Allocate a new entry and initialize it.
>>> + *
>>> + * returns the newly allocated entry.
>>> + */
>>> +static S390TopologyEntry *s390_topology_new_entry(s390_topology_id id,
>>> +                                                  S390CPU *cpu)
> 
> This is used only once, right?
> I think I'd go ahead and inline it into s390_topology_insert, since I had
> to go back and check if new_entry calls add_cpu when reading s390_topology_insert.

OK

> 
>>> +{
>>> +    S390TopologyEntry *entry;
>>> +
>>> +    entry = g_malloc0(sizeof(S390TopologyEntry));
>>> +    entry->id.id = id.id;
>>> +    s390_topology_add_cpu_to_entry(entry, cpu);
>>> +
>>> +    return entry;
>>> +}
>>> +
>>> +/**
>>> + * s390_topology_from_cpu:
>>> + * @cpu: The S390CPU
>>> + *
>>> + * Initialize the topology id from the CPU environment.
>>> + */
>>> +static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
>>> +{
>>> +    s390_topology_id topology_id = {0};
>>> +
>>> +    topology_id.drawer = cpu->env.drawer_id;
>>> +    topology_id.book = cpu->env.book_id;
>>> +    topology_id.socket = cpu->env.socket_id;
>>> +    topology_id.origin = cpu->env.core_id / 64;
>>> +    topology_id.type = S390_TOPOLOGY_CPU_IFL;
>>> +    topology_id.dedicated = cpu->env.dedicated;
>>> +
>>> +    if (s390_topology.polarity == POLARITY_VERTICAL) {
>>> +        /*
>>> +         * Vertical polarity with dedicated CPU implies
>>> +         * vertical high entitlement.
>>> +         */
>>> +        if (topology_id.dedicated) {
>>> +            topology_id.polarity |= POLARITY_VERTICAL_HIGH;
>>> +        } else {
>>> +            topology_id.polarity |= cpu->env.entitlement;
>>> +        }
>>> +    }
>>> +
>>> +    return topology_id;
>>> +}
>>> +
>>> +/**
>>> + * s390_topology_insert:
>>> + * @cpu: s390CPU insert.
>>> + *
>>> + * Parse the topology list to find if the entry already
>>> + * exist and add the core in it.
>>> + * If it does not exist, allocate a new entry and insert
>>> + * it in the queue from lower id to greater id.
>>> + */
>>> +static void s390_topology_insert(S390CPU *cpu)
>>> +{
>>> +    s390_topology_id id = s390_topology_from_cpu(cpu);
>>> +    S390TopologyEntry *entry = NULL;
>>> +    S390TopologyEntry *tmp = NULL;
>>> +
>>> +    QTAILQ_FOREACH(tmp, &s390_topology.list, next) {
>>> +        if (id.id == tmp->id.id) {
>>> +            s390_topology_add_cpu_to_entry(tmp, cpu);
>>> +            return;
>>> +        } else if (id.id < tmp->id.id) {
>>> +            entry = s390_topology_new_entry(id, cpu);
>>> +            QTAILQ_INSERT_BEFORE(tmp, entry, next);
>>> +            return;
>>> +        }
>>> +    }
>>> +}
>>> +
>>> +/**
>>> + * s390_order_tle:
>>> + *
>>> + * Loop over all CPU and insert it at the right place
>>> + * inside the TLE entry list.
>>> + */
> 
> Suggestion:
> 
> s390_topology_fill_list_sorted
> 
> Fill the S390Topology list with entries according to the order specified
> by the PoP.

OK

> 
>>> +static void s390_order_tle(void)
>>> +{
>>> +    CPUState *cs;
>>> +
>>> +    CPU_FOREACH(cs) {
>>> +        s390_topology_insert(S390_CPU(cs));
>>> +    }
>>> +}
>>> +
>>> +/**
>>> + * s390_free_tle:
>>> + *
>>> + * Loop over all TLE entries and free them.
>>> + * Keep the sentinelle which is the only one with level5 != 0
> 
> s/sentinelle/sentinel/

yes, thx

> 
>>> + */
> 
> Suggestion:
> s390_topology_empty_list
> 
> Clear all entries in the S390Topology list except the sentinel.
> 
>>> +static void s390_free_tle(void)
>>> +{
>>> +    S390TopologyEntry *entry = NULL;
>>> +    S390TopologyEntry *tmp = NULL;
>>> +
>>> +    QTAILQ_FOREACH_SAFE(entry, &s390_topology.list, next, tmp) {
>>> +        if (!entry->id.level5) {
>>> +            QTAILQ_REMOVE(&s390_topology.list, entry, next);
>>> +            g_free(entry);
>>> +        }
>>> +    }
>>> +}
>>> +
>>> +/**
>>> + * insert_stsi_15_1_x:
>>> + * cpu: the CPU doing the call for which we set CC
>>> + * sel2: the selector 2, containing the nested level
>>> + * addr: Guest logical address of the guest SysIB
>>> + * ar: the access register number
>>> + *
>>> + * Reserve a zeroed SysIB, let setup_stsi to fill it and
>>> + * copy the SysIB to the guest memory.
>>> + *
>>> + * In case of overflow set CC(3) and no copy is done.
> 
> Suggestion:
> 
> Emulate STSI 15.1.x, that is, perform all necessary checks and fill the SYSIB.
> In case the topology description is too long to fit into the SYSIB,
> set CC=3 and abort without writing the SYSIB.

OK, better thanks.

>   
>>> + */
>>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>>> +{
>>> +    SysIB sysib = {0};
>>> +    int len;
>>> +
>>> +    if (!s390_has_topology() || sel2 < 2 || sel2 > SCLP_READ_SCP_INFO_MNEST) {
>>> +        setcc(cpu, 3);
>>> +        return;
>>> +    }
>>> +
>>> +    s390_order_tle();
>>> +
>>> +    len = setup_stsi(&sysib.sysib_151x, sel2);
>>> +
>>> +    if (len < 0) {
> 
> I stumbled a bit over this, maybe rename len to r.

Why ? it is the length used to fill the length field of the SYSIB.

May be it would be clearer if we give back the length to write and 0 on 
error then we have here:

	if (!len) {
		setcc(cpu, 3);
		return;
	}

> 
>>> +        setcc(cpu, 3);
>>> +        return;
>>> +    }
>>> +
>>> +    sysib.sysib_151x.length = cpu_to_be16(len);
>>> +    s390_cpu_virt_mem_write(cpu, addr, ar, &sysib, len);
>>> +    setcc(cpu, 0);
>>> +
>>> +    s390_free_tle();
>>> +}

Thanks for the comments.
If there are only comments and cosmetic changes will I get your RB if I 
change them according to your wishes?

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
