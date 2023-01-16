Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE19C66CEE8
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbjAPSgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbjAPSfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:35:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5B422DC8
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 10:24:58 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHj6IR018732;
        Mon, 16 Jan 2023 18:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KQNG2dLI6Mmw4UQeZKmJaXmrVP+4cIWMvHne29F1ZmA=;
 b=FmwjhqwJsIuerWQqC0m/QOCfMs4EqrhSKtfGs0eCoP4k4M/GE+suStL4LfKRrPjSV8JM
 4pmQZSZ9b6f33uMnS5ItJPU3GlfzWS4cx/PidOvdwecoof1iO/u81BfNBozJ+B2CvXSU
 0RJjFuziRJXWmhKAbts8bHC6XWTzBUcwfIOhF9X/K1QsNWNowu00ys4GNLNdCaKf73nP
 mswTEZS+KbglDCJtSclCksEoEKfmppGGDX5FPPmRCR8H4fwceoi71To8khtYKffFWL0V
 AlC2oEgcOi7RGF7jT473piEjP2Xk9kXofVPehQkVVvT2/tdGviBCavR/IZBir7j8K0Pu SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5b8erp5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:24:51 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GILgSg027862;
        Mon, 16 Jan 2023 18:24:50 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5b8erp5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:24:50 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30G8tqgF030354;
        Mon, 16 Jan 2023 18:24:48 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n3m16j0vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:24:48 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GIOiuP45547818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:24:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4D7B20043;
        Mon, 16 Jan 2023 18:24:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85F6A20040;
        Mon, 16 Jan 2023 18:24:43 +0000 (GMT)
Received: from [9.179.28.129] (unknown [9.179.28.129])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 18:24:43 +0000 (GMT)
Message-ID: <d46a54e4-802b-27ba-6d90-571b1a6156dd@linux.ibm.com>
Date:   Mon, 16 Jan 2023 19:24:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 02/11] s390x/cpu topology: add topology entries on CPU
 hotplug
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-3-pmorel@linux.ibm.com>
 <5c8a22bb-5a35-d71e-9e5a-39675fa04e66@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5c8a22bb-5a35-d71e-9e5a-39675fa04e66@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I_5jyvXMtozVWiryM9Mt-xKBGbpa60EL
X-Proofpoint-ORIG-GUID: lII5-JYkb_X8axfcr9pNtOJ1UBp-aXjT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxscore=0 impostorscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160135
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/10/23 14:00, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> The topology information are attributes of the CPU and are
>> specified during the CPU device creation.
>>
>> On hot plug, we gather the topology information on the core,
>> creates a list of topology entries, each entry contains a single
>> core mask of each core with identical topology and finaly we
>> orders the list in topological order.
>> The topological order is, from higher to lower priority:
>> - physical topology
>>      - drawer
>>      - book
>>      - socket
>>      - core origin, offset in 64bit increment from core 0.
>> - modifier attributes
>>      - CPU type
>>      - polarization entitlement
>>      - dedication
>>
>> The possibility to insert a CPU in a mask is dependent on the
>> number of cores allowed in a socket, a book or a drawer, the
>> checking is done during the hot plug of the CPU to have an
>> immediate answer.
>>
>> If the complete topology is not specified, the core is added
>> in the physical topology based on its core ID and it gets
>> defaults values for the modifier attributes.
>>
>> This way, starting QEMU without specifying the topology can
>> still get some adventage of the CPU topology.
> 
> s/adventage/advantage/
> 
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h |  48 ++++++
>>   hw/s390x/cpu-topology.c         | 293 ++++++++++++++++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c      |  10 ++
>>   hw/s390x/meson.build            |   1 +
>>   4 files changed, 352 insertions(+)
>>   create mode 100644 hw/s390x/cpu-topology.c
>>
>> diff --git a/include/hw/s390x/cpu-topology.h 
>> b/include/hw/s390x/cpu-topology.h
>> index d945b57fc3..b3fd752d8d 100644
>> --- a/include/hw/s390x/cpu-topology.h
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -10,7 +10,11 @@
>>   #ifndef HW_S390X_CPU_TOPOLOGY_H
>>   #define HW_S390X_CPU_TOPOLOGY_H
>> +#include "qemu/queue.h"
>> +#include "hw/boards.h"
>> +
>>   #define S390_TOPOLOGY_CPU_IFL   0x03
>> +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
>>   #define S390_TOPOLOGY_POLARITY_HORIZONTAL      0x00
>>   #define S390_TOPOLOGY_POLARITY_VERTICAL_LOW    0x01
>> @@ -20,4 +24,48 @@
>>   #define S390_TOPOLOGY_SHARED    0x00
>>   #define S390_TOPOLOGY_DEDICATED 0x01
>> +typedef union s390_topology_id {
>> +    uint64_t id;
>> +    struct {
>> +        uint64_t level_6:8; /* byte 0 BE */
>> +        uint64_t level_5:8; /* byte 1 BE */
>> +        uint64_t drawer:8;  /* byte 2 BE */
>> +        uint64_t book:8;    /* byte 3 BE */
>> +        uint64_t socket:8;  /* byte 4 BE */
>> +        uint64_t rsrv:5;
>> +        uint64_t d:1;
>> +        uint64_t p:2;       /* byte 5 BE */
>> +        uint64_t type:8;    /* byte 6 BE */
>> +        uint64_t origin:2;
>> +        uint64_t core:6;    /* byte 7 BE */
>> +    };
>> +} s390_topology_id;
> 
> Bitmasks are OK for code that will definitely only ever work with KVM 
> ... but this will certainly fail completely if we ever try to get it 
> running with TCG later. Do we care? ... if so, you should certainly 
> avoid a bitfield here. Especially since most of the fields are 8-bit 
> anyway and could easily be represented by a "uint8_t" variable. 
> Otherwise, just ignore my comment.

The goal of using a bit mask here is not to use it with KVM but to have 
an easy way to order the TLE using the natural order of the placement of 
the fields in the uint64_t
However, if I remove the two unused levels 5 and 6 I can use uint8_t for 
all the entries.

I doubt we use the levels 5 and 6 in a short future.

So I switch on 1 uint8_t for each entry.

...

>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> new file mode 100644
>> index 0000000000..438055c612
>> --- /dev/null
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -0,0 +1,293 @@
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
> 
> Want to update to 2023 now?
> 
>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
>> +
>> + * This work is licensed under the terms of the GNU GPL, version 2 or 
>> (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qapi/error.h"
>> +#include "qemu/error-report.h"
>> +#include "hw/qdev-properties.h"
>> +#include "hw/boards.h"
>> +#include "qemu/typedefs.h"
>> +#include "target/s390x/cpu.h"
>> +#include "hw/s390x/s390-virtio-ccw.h"
>> +#include "hw/s390x/cpu-topology.h"
>> +
>> +/*
>> + * s390_topology is used to keep the topology information.
>> + * .list: queue the topology entries inside which
>> + *        we keep the information on the CPU topology.
>> + *
>> + * .smp: keeps track of the machine topology.
>> + *
>> + * .socket: tracks information on the count of cores per socket.
>> + *
>> + */
>> +S390Topology s390_topology = {
>> +    .list = QTAILQ_HEAD_INITIALIZER(s390_topology.list),
>> +    .sockets = NULL, /* will be initialized after the cpu model is 
>> realized */
>> +};
>> +
>> +/**
>> + * s390_socket_nb:
>> + * @id: s390_topology_id
>> + *
>> + * Returns the socket number used inside the socket array.
>> + */
>> +static int s390_socket_nb(s390_topology_id id)
>> +{
>> +    return (id.socket + 1) * (id.book + 1) * (id.drawer + 1); > +}
> I think there might be an off-by-one error in here - you likely need a 
> "- 1" at the very end.
> 
> For example, assume that we have one socket, one book and one drawer, so 
> id.socket, id.book and id.drawer would all be 0. The function then 
> returns 1 ...

hum, I fear it is even more false than that but thanks for pointing this 
error.

  /o\

     return (id.drawer * s390_topology.smp.books + id.book) *
            s390_topology.smp.sockets + id.socket;


> 
>> +static void s390_topology_init(MachineState *ms)
>> +{
>> +    CpuTopology *smp = &ms->smp;
>> +
>> +    s390_topology.smp = smp;
>> +    if (!s390_topology.sockets) {
>> +        s390_topology.sockets = g_new0(uint8_t, smp->sockets *
>> +                                       smp->books * smp->drawers);
> 
> ... but here you only allocated one byte. So you later access 
> s390_topology.sockets[s390_socket_nb(id)], i.e. s390_topology.sockets[1] 
> which is out of bounds.

Yes, thanks.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
