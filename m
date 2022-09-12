Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E648A5B5D4B
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 17:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiILPfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 11:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiILPfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 11:35:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9860413E2E
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 08:34:59 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CF2vX1032193;
        Mon, 12 Sep 2022 15:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UCl2KrvjzUOvhrdldEudBRE0bLp3rQfKH78JbhwjYDs=;
 b=CjD4C4kwU8+IzDh/Y6EOec2qmgzrPNLRhUS7LLAyiUNEtEe40WBKRVaK5Vt6Msk+FPp2
 /fodXptkFo5C0qoENuPYl7osiHr5QQc5xLfaaqrrMMd8FqhLN8lCu0FhaPn/e3WPXmOq
 Z12k4U3tcZvqoqHC9Ye7aIO62Ql3LjuwEUpAlpaAOrkVJZDA9N7jJesugT7aRWSiETCX
 MfiYljPnoNLq4YSjc0eBR17Mn+d7duWVgHq05aB+VZlz4VRFFvgrOdurlIGstWu/In6f
 X4fpijHuxpv4/Sm19SSuo4z7tkAqQvZOLRzoHEkOJ3+aKNC0mfbNL8yGn+jUPIyMLM8y Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jj6593c9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 15:34:51 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CFDtJS024423;
        Mon, 12 Sep 2022 15:34:51 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jj6593c84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 15:34:50 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28CFL6LI017465;
        Mon, 12 Sep 2022 15:34:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3jgj78swbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 15:34:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28CFYjS639256538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 15:34:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C6D45204E;
        Mon, 12 Sep 2022 15:34:45 +0000 (GMT)
Received: from [9.171.67.163] (unknown [9.171.67.163])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4335B52050;
        Mon, 12 Sep 2022 15:34:44 +0000 (GMT)
Message-ID: <9d967888-72f4-ac2a-0464-8806a64148d3@linux.ibm.com>
Date:   Mon, 12 Sep 2022 17:34:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 02/10] s390x/cpu topology: core_id sets s390x CPU
 topology
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-3-pmorel@linux.ibm.com>
 <bac31c028a713c32130b397189552f17b43a9485.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <bac31c028a713c32130b397189552f17b43a9485.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3FPwIttPH8bczKOMnDXcbqRc0tCrp_pT
X-Proofpoint-ORIG-GUID: KzAHRcjhhv9X-7wV1iEF6rJWnT39nqZV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_10,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120052
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/5/22 20:11, Janis Schoetterl-Glausch wrote:
> On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
>> In the S390x CPU topology the core_id specifies the CPU address
>> and the position of the core withing the topology.
>>
>> Let's build the topology based on the core_id.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/s390x/cpu-topology.c         | 135 ++++++++++++++++++++++++++++++++
>>   hw/s390x/meson.build            |   1 +
>>   hw/s390x/s390-virtio-ccw.c      |  10 +++
>>   include/hw/s390x/cpu-topology.h |  42 ++++++++++
>>   4 files changed, 188 insertions(+)
>>   create mode 100644 hw/s390x/cpu-topology.c
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>>
> [...]
> 
>> +/**
>> + * s390_topology_realize:
>> + * @dev: the device state
>> + * @errp: the error pointer (not used)
>> + *
>> + * During realize the machine CPU topology is initialized with the
>> + * QEMU -smp parameters.
>> + * The maximum count of CPU TLE in the all Topology can not be greater
>> + * than the maximum CPUs.
>> + */
>> +static void s390_topology_realize(DeviceState *dev, Error **errp)
>> +{
>> +    MachineState *ms = MACHINE(qdev_get_machine());
>> +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
>> +    int n;
>> +
>> +    topo->sockets = ms->smp.sockets;
>> +    topo->cores = ms->smp.cores;
>> +    topo->tles = ms->smp.max_cpus;
>> +
>> +    n = topo->sockets;
>> +    topo->socket = g_malloc0(n * sizeof(S390TopoContainer));
>> +    topo->tle = g_malloc0(topo->tles * sizeof(S390TopoTLE));
> 
> Seems like a good use case for g_new0.

Yes


> 
> [...]
>>
>> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
>> new file mode 100644
>> index 0000000000..6911f975f4
>> --- /dev/null
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -0,0 +1,42 @@
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright 2022 IBM Corp.
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
>> +#ifndef HW_S390X_CPU_TOPOLOGY_H
>> +#define HW_S390X_CPU_TOPOLOGY_H
> 
> Is there a reason this is before the includes?
>> +
>> +typedef struct S390TopoContainer {
>> +    int active_count;
>> +} S390TopoContainer;
>> +
>> +#define S390_TOPOLOGY_MAX_ORIGIN (1 + S390_MAX_CPUS / 64)
> 
> This is correct because cpu_id == core_id for s390, right?
> So the cpu limit also applies to the core id.
> You could do ((S390_MAX_CPUS + 63) / 64) instead.
> But if you chose this for simplicity's sake, I'm fine with it.

hum, I think your proposition is right and mine is false.
If S390_MAX_CPUS is 64 we have only 1 origin.
I count 2 but you count 1.

So I change this.

> 
>> +typedef struct S390TopoTLE {
>> +    int active_count;
> 
> Do you use (read) this field somewhere?
> Is this in anticipation of there being multiple TLE arrays, for
> different polarizations, etc? If so I would defer this for later.

OK

> 
>> +    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
>> +} S390TopoTLE;
>> +
>> +#include "hw/qdev-core.h"
>> +#include "qom/object.h"
>> +
>> +struct S390Topology {
>> +    SysBusDevice parent_obj;
>> +    int sockets;
>> +    int cores;
> 
> These are just cached values from machine_state.smp, right?
> Not sure if I like the redundancy, it doesn't aid in comprehension.
> 
>> +    int tles;
>> +    S390TopoContainer *socket;
>> +    S390TopoTLE *tle;
>> +};
>> +typedef struct S390Topology S390Topology;
> 
> The DECLARE macro takes care of this typedef.

right

> 
>> +
>> +#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
>> +OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
>> +
>> +S390Topology *s390_get_topology(void);
>> +void s390_topology_new_cpu(int core_id);
>> +
>> +#endif
> 

-- 
Pierre Morel
IBM Lab Boeblingen
