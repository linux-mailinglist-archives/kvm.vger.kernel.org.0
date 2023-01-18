Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CDD671F6E
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjAROYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjAROXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:23:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685DE53B05
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:07:03 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IDO163026802;
        Wed, 18 Jan 2023 14:06:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=e1q0YL2w0vrRYY+zoVr7rU4wn8RKlbzst0+o3KjPILE=;
 b=b5JF/5sVlwLtxx0Ke7SZGTRV560IoNvCimU89BhCZUhUoN3+GsHw1AAGZ+pAElrce/bW
 sWNE2E4eaGxYMIhxLGsjwjduGKZnMgXA5u+PpMBuI3bFI6nivm611/CJXkeIBnFKcjAi
 nKpqgDOtKxoz/eHBW7vO9aMdcBfLDNz/hNdo/uLM+aNnyB5LzWa2SzDexJvTFOkGURFP
 JTh1wd4Q36Q+M0GxslTUlR3ZVGmCpp7Pz0S5VyoLO+uwntiVcPPb81HIn1BD8Dk4cnZF
 jGe56DhsQsaaisGOWEXn81KbwHX08P4HPEGoaAxxhwRDQwv9ogNzAm3kHA+8M/t7vqrK EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f91vjha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:06:50 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30ID01V1011381;
        Wed, 18 Jan 2023 14:06:49 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f91vjgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:06:49 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IATgVo014427;
        Wed, 18 Jan 2023 14:06:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n3m16bx0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:06:46 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IE6hMH52756866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 14:06:43 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2966C20043;
        Wed, 18 Jan 2023 14:06:43 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 355F420040;
        Wed, 18 Jan 2023 14:06:42 +0000 (GMT)
Received: from [9.171.39.117] (unknown [9.171.39.117])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 14:06:42 +0000 (GMT)
Message-ID: <927bead0-8427-a281-ed12-f36d6df13aa9@linux.ibm.com>
Date:   Wed, 18 Jan 2023 15:06:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology: change-topology monitor
 command
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-9-pmorel@linux.ibm.com>
 <72baa5b42abe557cdf123889b33b845b405cc86c.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <72baa5b42abe557cdf123889b33b845b405cc86c.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gYncx7jPhtEmqr4wXEeY0D26bUdpChes
X-Proofpoint-ORIG-GUID: sEYBdXlk4ycmZ4L7KkigRIhmUTsoQJCx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301180121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/16/23 22:09, Nina Schoetterl-Glausch wrote:
> On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
>> The modification of the CPU attributes are done through a monitor
>> commands.
>>
>> It allows to move the core inside the topology tree to optimise
>> the cache usage in the case the host's hypervizor previously
>> moved the CPU.
>>
>> The same command allows to modifiy the CPU attributes modifiers
>> like polarization entitlement and the dedicated attribute to notify
>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>
>> With this knowledge the guest has the possibility to optimize the
>> usage of the vCPUs.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine-target.json |  29 ++++++++
>>   include/monitor/hmp.h    |   1 +
>>   hw/s390x/cpu-topology.c  | 141 +++++++++++++++++++++++++++++++++++++++
>>   hmp-commands.hx          |  16 +++++
>>   4 files changed, 187 insertions(+)
>>
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index 2e267fa458..75b0aa254d 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -342,3 +342,32 @@
>>                      'TARGET_S390X',
>>                      'TARGET_MIPS',
>>                      'TARGET_LOONGARCH64' ] } }
>> +
>> +##
>> +# @change-topology:
>> +#
>> +# @core: the vCPU ID to be moved
>> +# @socket: the destination socket where to move the vCPU
>> +# @book: the destination book where to move the vCPU
>> +# @drawer: the destination drawer where to move the vCPU
>> +# @polarity: optional polarity, default is last polarity set by the guest
>> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
>> +#
>> +# Modifies the topology by moving the CPU inside the topology
>> +# tree or by changing a modifier attribute of a CPU.
>> +#
>> +# Returns: Nothing on success, the reason on failure.
>> +#
>> +# Since: <next qemu stable release, eg. 1.0>
>> +##
>> +{ 'command': 'change-topology',
>> +  'data': {
>> +      'core': 'int',
>> +      'socket': 'int',
>> +      'book': 'int',
>> +      'drawer': 'int',
>> +      '*polarity': 'int',
>> +      '*dedicated': 'bool'
>> +  },
>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>> +}
>> diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
>> index 27f86399f7..15c36bf549 100644
>> --- a/include/monitor/hmp.h
>> +++ b/include/monitor/hmp.h
>> @@ -144,5 +144,6 @@ void hmp_human_readable_text_helper(Monitor *mon,
>>                                       HumanReadableText *(*qmp_handler)(Error **));
>>   void hmp_info_stats(Monitor *mon, const QDict *qdict);
>>   void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
>> +void hmp_change_topology(Monitor *mon, const QDict *qdict);
>>   
>>   #endif
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index b69955a1cd..0faffe657e 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -18,6 +18,10 @@
>>   #include "target/s390x/cpu.h"
>>   #include "hw/s390x/s390-virtio-ccw.h"
>>   #include "hw/s390x/cpu-topology.h"
>> +#include "qapi/qapi-commands-machine-target.h"
>> +#include "qapi/qmp/qdict.h"
>> +#include "monitor/hmp.h"
>> +#include "monitor/monitor.h"
>>   
>>   /*
>>    * s390_topology is used to keep the topology information.
>> @@ -203,6 +207,21 @@ static void s390_topology_set_entry(S390TopologyEntry *entry,
>>       s390_topology.sockets[s390_socket_nb(id)]++;
>>   }
>>   
>> +/**
>> + * s390_topology_clear_entry:
>> + * @entry: Topology entry to setup
>> + * @id: topology id to use for the setup
>> + *
>> + * Clear the core bit inside the topology mask and
>> + * decrements the number of cores for the socket.
>> + */
>> +static void s390_topology_clear_entry(S390TopologyEntry *entry,
>> +                                      s390_topology_id id)
>> +{
>> +    clear_bit(63 - id.core, &entry->mask);
> 
> This doesn't take the origin into account.

Yes, this error has been done everywhere, I modify this.

> 
>> +    s390_topology.sockets[s390_socket_nb(id)]--;
> 
> I suppose this function cannot run concurrently, so the same CPU doesn't get removed twice.

This is only called on a change of topology and the qapi commands are 
serialized by the BQL.

> 
>> +}
>> +
>>   /**
>>    * s390_topology_new_entry:
>>    * @id: s390_topology_id to add
>> @@ -383,3 +402,125 @@ void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
>>   
>>       s390_topology_insert(id);
>>   }
>> +
>> +/*
>> + * qmp and hmp implementations
>> + */
>> +
>> +static S390TopologyEntry *s390_topology_core_to_entry(int core)
>> +{
>> +    S390TopologyEntry *entry;
>> +
>> +    QTAILQ_FOREACH(entry, &s390_topology.list, next) {
>> +        if (entry->mask & (1UL << (63 - core))) {
> 
> origin here also.

yes

> 
>> +            return entry;
>> +        }
>> +    }
>> +    return NULL;
> 
> This should not return NULL unless the core id is invalid.

yes

> Might be better to validate that somewhere else.

How?
I can use CPU_FOREACH() but it would be quite the same and I will need 
to rerun a loop for setting the topology anyway.

> 
>> +}
>> +
>> +static void s390_change_topology(Error **errp, int64_t core, int64_t socket,
>> +                                 int64_t book, int64_t drawer,
>> +                                 int64_t polarity, bool dedicated)
>> +{
>> +    S390TopologyEntry *entry;
>> +    s390_topology_id new_id;
>> +    s390_topology_id old_id;
>> +    Error *local_error = NULL;
> 
> I think you could use ERRP_GUARD here also.

You are right, I could.
Should I ?
I do not need it and find it obfuscating but if you insist I can do it.

>> +
>> +    /* Get the old entry */
>> +    entry = s390_topology_core_to_entry(core);
>> +    if (!entry) {
>> +        error_setg(errp, "No core %ld", core);
>> +        return;
>> +    }
>> +
>> +    /* Compute old topology id */
>> +    old_id = entry->id;
>> +    old_id.core = core;
>> +
>> +    /* Compute new topology id */
>> +    new_id = entry->id;
>> +    new_id.core = core;
>> +    new_id.socket = socket;
>> +    new_id.book = book;
>> +    new_id.drawer = drawer;
>> +    new_id.p = polarity;
>> +    new_id.d = dedicated;
>> +    new_id.type = S390_TOPOLOGY_CPU_IFL;
>> +
>> +    /* Same topology entry, nothing to do */
>> +    if (entry->id.id == new_id.id) {
>> +        return;
>> +    }
>> +
>> +    /* Check for space on the socket if ids are different */
>> +    if ((s390_socket_nb(old_id) != s390_socket_nb(new_id)) &&
>> +        (s390_topology.sockets[s390_socket_nb(new_id)] >=
>> +         s390_topology.smp->sockets)) {
>> +        error_setg(errp, "No more space on this socket");
>> +        return;
>> +    }
>> +
>> +    /* Verify the new topology */
>> +    s390_topology_check(&local_error, new_id);
>> +    if (local_error) {
>> +        error_propagate(errp, local_error);
>> +        return;
>> +    }
>> +
>> +    /* Clear the old topology */
>> +    s390_topology_clear_entry(entry, old_id);
>> +
>> +    /* Insert the new topology */
>> +    s390_topology_insert(new_id);
>> +
>> +    /* Remove unused entry */
>> +    if (!entry->mask) {
>> +        QTAILQ_REMOVE(&s390_topology.list, entry, next);
>> +        g_free(entry);
>> +    }
>> +
>> +    /* Advertise the topology change */
>> +    s390_cpu_topology_set();
>> +}
>> +
>> +void qmp_change_topology(int64_t core, int64_t socket,
>> +                         int64_t book, int64_t drawer,
>> +                         bool has_polarity, int64_t polarity,
>> +                         bool has_dedicated, bool dedicated,
>> +                         Error **errp)
>> +{
>> +    Error *local_err = NULL;
>> +
>> +    if (!s390_has_topology()) {
>> +        error_setg(&local_err, "This machine doesn't support topology");
>> +        return;
>> +    }
> 
> Do you really want to ignore has_polarity and has_dedicated here?
> What happens in this case?

no, seems I forgot to check it.

Thanks,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
