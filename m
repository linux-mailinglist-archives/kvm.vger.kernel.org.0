Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006DA6A4419
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 15:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjB0OR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 09:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjB0ORz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 09:17:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2489630F7
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 06:17:53 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RD3fb9026915;
        Mon, 27 Feb 2023 14:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=im2RqyXMRRAkvjnJ5M0Hht+XGquluuk+iCq4W9kW/7U=;
 b=P/0gWJsBOKdwDsPkxFPeo11Tf1EnT2lVMqQHSvelZIcOJRfwPUI7duY0X41oDRR2SD/D
 1W4o7APrD+a+pwgIw5ocJWAMlSBATA/hH52jP3r7fOhBAl0orKjwf0Ukwdjy8BhkVbp2
 anSdc153yknxix1ne5OY21tf3RSFeivMSI6LuFrpVEssZa68EeSZtePs4AzlrwQBtOQr
 tSXAiArvu32VKjrAMm35/7nNfzBAYsKuUdW6ygBhWQAA7qOMJsRHnD1jYdCbb84W9O35
 fFi9kug7L5i47J5imP/euK7y8YtHyiEJMS3jXRJrGuuZ0nh1EQgabTTB3Kf+iT36bya9 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0u1r5j66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:17:45 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31REH9Mq011287;
        Mon, 27 Feb 2023 14:17:45 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0u1r5j4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:17:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31R6V20P013689;
        Mon, 27 Feb 2023 14:17:42 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3nybdfsga7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:17:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31REHccw64487694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 14:17:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA9AB20043;
        Mon, 27 Feb 2023 14:17:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB7BF20040;
        Mon, 27 Feb 2023 14:17:36 +0000 (GMT)
Received: from [9.171.14.212] (unknown [9.171.14.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Feb 2023 14:17:36 +0000 (GMT)
Message-ID: <dcac1561-8c91-310c-7e9f-db9fff3b00a7@linux.ibm.com>
Date:   Mon, 27 Feb 2023 15:17:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 11/11] docs/s390x/cpu topology: document s390x cpu
 topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-12-pmorel@linux.ibm.com>
 <039b5a0f-4440-324c-d5a7-54e9e1c89ea8@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <039b5a0f-4440-324c-d5a7-54e9e1c89ea8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gy_WB9XWVsrmuJ6NFAdz9qcMxh77t9nu
X-Proofpoint-ORIG-GUID: cNfaPDkWDH6pfdnz3ztFHPTomO0kC-s1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_10,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302270109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/27/23 14:58, Thomas Huth wrote:
> On 22/02/2023 15.21, Pierre Morel wrote:
>> Add some basic examples for the definition of cpu topology
>> in s390x.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   docs/system/s390x/cpu-topology.rst | 378 +++++++++++++++++++++++++++++
>>   docs/system/target-s390x.rst       |   1 +
>>   2 files changed, 379 insertions(+)
>>   create mode 100644 docs/system/s390x/cpu-topology.rst
>>
>> diff --git a/docs/system/s390x/cpu-topology.rst 
>> b/docs/system/s390x/cpu-topology.rst
>> new file mode 100644
>> index 0000000000..d470e28b97
>> --- /dev/null
>> +++ b/docs/system/s390x/cpu-topology.rst
>> @@ -0,0 +1,378 @@
>> +CPU topology on s390x
>> +=====================
>> +
>> +Since QEMU 8.0, CPU topology on s390x provides up to 3 levels of
>> +topology containers: drawers, books, sockets, defining a tree shaped
>> +hierarchy.
>> +
>> +The socket container contains one or more CPU entries consisting
>> +of a bitmap of three dentical CPU attributes:
>
> What do you mean by "dentical" here?

:D i.. dentical

I change it to identical

>
>> +- CPU type
>> +- polarization entitlement
>> +- dedication
>> +
>> +Note also that since 7.2 threads are no longer supported in the 
>> topology
>> +and the ``-smp`` command line argument accepts only ``threads=1``.
>> +
>> +Prerequisites
>> +-------------
>> +
>> +To use CPU topology a Linux QEMU/KVM machine providing the CPU 
>> topology facility
>> +(STFLE bit 11) is required.
>> +
>> +However, since this facility has been enabled by default in an early 
>> version
>> +of QEMU, we use a capability, ``KVM_CAP_S390_CPU_TOPOLOGY``, to 
>> notify KVM
>> +that QEMU supports CPU topology.
>
> This still sounds like a mix of documentation for the user and 
> documentation for developers. The normal user won't know what a KVM 
> capability is and does not need to know that QEMU does this 
> automatically under the hood.
>
> If you still want to mention it, I'd maybe rather phrase it like this:
>
> "To use the CPU topology, you need to run with KVM on a s390x host 
> that uses the Linux kernel v6.0 or newer (which provide the so-called 
> ``KVM_CAP_S390_CPU_TOPOLOGY`` capability that allows QEMU to signal 
> the CPU topology facility via the so-called STFLE bit 11 to the VM)."
>
> ... or something similar?


Yes, OK.


>
> [...]
>> +When a CPU is defined by the ``-device`` command argument, the
>> +tree topology attributes must be all defined or all not defined.
>> +
>> +.. code-block:: bash
>> +
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1
>> +
>> +or
>> +
>> +.. code-block:: bash
>> +
>> +    -device gen16b-s390x-cpu,core-id=1,dedication=true
>> +
>> +If none of the tree attributes (drawer, book, sockets), are specified
>> +for the ``-device`` argument, as for all CPUs defined on the ``-smp``
>
> s/defined on/defined with/ ?


OK


>
>> +command argument the topology tree attributes will be set by simply
>> +adding the CPUs to the topology based on the core-id starting with
>> +core-0 at position 0 of socket-0, book-0, drawer-0.
>> +
>> +QEMU will not try to solve collisions and will report an error if the
>> +CPU topology, explicitely or implicitely defined on a ``-device``
>
> explicitly or implicitly


OK


>
>> +argument collides with the definition of a CPU implicitely defined
>
> implicitly

Yes


>
>> +on the ``-smp`` argument.
>> +
>> +When the topology modifier attributes are not defined for the
>> +``-device`` command argument they takes following default values:
>> +
>> +- dedication: ``false``
>> +- entitlement: ``medium``
>> +
>> +
>> +Hot plug
>> +++++++++
>> +
>> +New CPUs can be plugged using the device_add hmp command as in:
>> +
>> +.. code-block:: bash
>> +
>> +  (qemu) device_add gen16b-s390x-cpu,core-id=9
>> +
>> +The same placement of the CPU is derived from the core-id as 
>> described above.
>> +
>> +The topology can of course be fully defined:
>> +
>> +.. code-block:: bash
>> +
>> +    (qemu) device_add 
>> gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1
>> +
>> +
>> +Examples
>> +++++++++
>> +
>> +In the following machine we define 8 sockets with 4 cores each.
>> +
>> +.. code-block:: bash
>> +
>> +  $ qemu-system-s390x -m 2G \
>> +    -cpu gen16b,ctop=on \
>> +    -smp cpus=5,sockets=8,cores=4,maxcpus=32 \
>> +    -device host-s390x-cpu,core-id=14 \
>> +
>> +A new CPUs can be plugged using the device_add hmp command as before:
>> +
>> +.. code-block:: bash
>> +
>> +  (qemu) device_add gen16b-s390x-cpu,core-id=9
>> +
>> +The core-id defines the placement of the core in the topology by
>> +starting with core 0 in socket 0 up to maxcpus.
>> +
>> +In the example above:
>> +
>> +* There are 5 CPUs provided to the guest with the ``-smp`` command line
>> +  They will take the core-ids 0,1,2,3,4
>> +  As we have 4 cores in a socket, we have 4 CPUs provided
>> +  to the guest in socket 0, with core-ids 0,1,2,3.
>> +  The last cpu, with core-id 4, will be on socket 1.
>> +
>> +* the core with ID 14 provided by the ``-device`` command line will
>> +  be placed in socket 3, with core-id 14
>> +
>> +* the core with ID 9 provided by the ``device_add`` qmp command will
>> +  be placed in socket 2, with core-id 9
>> +
>> +
>> +Polarization, entitlement and dedication
>> +----------------------------------------
>> +
>> +Polarization
>> +++++++++++++
>> +
>> +The polarization is an indication given by the ``guest`` to the host
>> +that it is able to make use of CPU provisioning information.
>> +The guest indicates the polarization by using the PTF instruction.
>> +
>> +Polarization is define two models of CPU provisioning: horizontal
>> +and vertical.
>> +
>> +The horizontal polarization is the default model on boot and after
>> +subsystem reset in which the guest considers all vCPUs being having
>> +an equal provisioning of CPUs by the host.
>> +
>> +In the vertical polarization model the guest can make use of the
>> +vCPU entitlement information provided by the host to optimize
>> +kernel thread scheduling.
>> +
>> +A subsystem reset puts all vCPU of the configuration into the
>> +horizontal polarization.
>> +
>> +Entitlement
>> ++++++++++++
>> +
>> +The vertical polarization specifies that guest's vCPU can get
>
> "that *the* guest's vCPU" ?

Yes


>
>> +different real CPU provisions:
>> +
>> +- a vCPU with vertical high entitlement specifies that this
>> +  vCPU gets 100% of the real CPU provisioning.
>> +
>> +- a vCPU with vertical medium entitlement specifies that this
>> +  vCPU shares the real CPU with other vCPUs.
>> +
>> +- a vCPU with vertical low entitlement specifies that this
>> +  vCPU only gets real CPU provisioning when no other vCPUs needs it.
>> +
>> +In the case a vCPU with vertical high entitlement does not use
>> +the real CPU, the unused "slack" can be dispatched to other vCPU
>> +with medium or low entitlement.
>> +
>> +The admin specifies a vCPU as ``dedicated`` when the vCPU is fully 
>> dedicated
>> +to a single real CPU.
>> +
>> +The dedicated bit is an indication of affinity of a vCPU for a real CPU
>> +while the entitlement indicates the sharing or exclusivity of use.
>> +
>> +Defining the topology on command line
>> +-------------------------------------
>> +
>> +The topology can entirely be defined using -device cpu statements,
>> +with the exception of CPU 0 which must be defined with the -smp
>> +argument.
>> +
>> +For example, here we set the position of the cores 1,2,3 to
>> +drawer 1, book 1, socket 2 and cores 0,9 and 14 to drawer 0,
>> +book 0, socket 0 with all horizontal polarization and not dedicated.
>> +The core 4, will be set on its default position on socket 1
>> +(since we have 4 core per socket) and we define it with dedication and
>> +vertical high entitlement.
>> +
>> +.. code-block:: bash
>> +
>> +  $ qemu-system-s390x -m 2G \
>> +    -cpu gen16b,ctop=on \
>> +    -smp cpus=1,sockets=8,cores=4,maxcpus=32 \
>> +    \
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=1 \
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=2 \
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=1,book-id=1,socket-id=2,core-id=3 \
>> +    \
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=0,book-id=0,socket-id=0,core-id=9 \
>> +    -device 
>> gen16b-s390x-cpu,drawer-id=0,book-id=0,socket-id=0,core-id=14 \
>> +    \
>> +    -device gen16b-s390x-cpu,core-id=4,dedicated=on,polarization=3 \
>> +
>> +QAPI interface for topology
>> +---------------------------
>> +
>> +Let's start QEMU with the following command:
>> +
>> +.. code-block:: bash
>> +
>> + qemu-system-s390x \
>> +    -enable-kvm \
>> +    -cpu z14,ctop=on \
>> +    -smp 1,drawers=3,books=3,sockets=2,cores=2,maxcpus=36 \
>> +    \
>> +    -device z14-s390x-cpu,core-id=19,polarization=3 \
>> +    -device z14-s390x-cpu,core-id=11,polarization=1 \
>> +    -device z14-s390x-cpu,core-id=112,polarization=3 \
>> +   ...
>> +
>> +and see the result when using the QAPI interface.
>> +
>> +addons to query-cpus-fast
>> ++++++++++++++++++++++++++
>> +
>> +The command query-cpus-fast allows the admin to query the topology
>
> I'd just say "allows to query", without "the admin".


OK


>
>> +tree and modifiers for all configured vCPUs.
>> +
>> +.. code-block:: QMP
>> +
>> + { "execute": "query-cpus-fast" }
>> + {
>> +  "return": [
>> +    {
>> +      "dedicated": false,
>> +      "thread-id": 536993,
>> +      "props": {
>> +        "core-id": 0,
>> +        "socket-id": 0,
>> +        "drawer-id": 0,
>> +        "book-id": 0
>> +      },
>> +      "cpu-state": "operating",
>> +      "entitlement": "medium",
>> +      "qom-path": "/machine/unattached/device[0]",
>> +      "cpu-index": 0,
>> +      "target": "s390x"
>> +    },
>> +    {
>> +      "dedicated": false,
>> +      "thread-id": 537003,
>> +      "props": {
>> +        "core-id": 19,
>> +        "socket-id": 1,
>> +        "drawer-id": 0,
>> +        "book-id": 2
>> +      },
>> +      "cpu-state": "operating",
>> +      "entitlement": "high",
>> +      "qom-path": "/machine/peripheral-anon/device[0]",
>> +      "cpu-index": 19,
>> +      "target": "s390x"
>> +    },
>> +    {
>> +      "dedicated": false,
>> +      "thread-id": 537004,
>> +      "props": {
>> +        "core-id": 11,
>> +        "socket-id": 1,
>> +        "drawer-id": 0,
>> +        "book-id": 1
>> +      },
>> +      "cpu-state": "operating",
>> +      "entitlement": "low",
>> +      "qom-path": "/machine/peripheral-anon/device[1]",
>> +      "cpu-index": 11,
>> +      "target": "s390x"
>> +    },
>> +    {
>> +      "dedicated": true,
>> +      "thread-id": 537005,
>> +      "props": {
>> +        "core-id": 112,
>> +        "socket-id": 0,
>> +        "drawer-id": 3,
>> +        "book-id": 2
>> +      },
>> +      "cpu-state": "operating",
>> +      "entitlement": "high",
>> +      "qom-path": "/machine/peripheral-anon/device[2]",
>> +      "cpu-index": 112,
>> +      "target": "s390x"
>> +    }
>> +  ]
>> + }
>> +
>> +
>> +set-cpu-topology
>> +++++++++++++++++
>> +
>> +The command set-cpu-topology allows the admin to modify the topology
>
> "allows to modify"

OK


>
>> +tree or the topology modifiers of a vCPU in the configuration.
>> +
>> +.. code-block:: QMP
>> +
>> + -> { "execute": "set-cpu-topology",
>> +      "arguments": {
>> +         "core-id": 11,
>> +         "socket-id": 0,
>> +         "book-id": 0,
>> +         "drawer-id": 0,
>> +         "entitlement": low,
>> +         "dedicated": false
>> +      }
>> +    }
>> + <- {"return": {}}
>> +
>> +The core-id parameter is the only non optional parameter and every
>> +unspecified parameter keeps its previous value.
>> +
>> +event CPU_POLARIZATION_CHANGE
>> ++++++++++++++++++++++++++++++
>> +
>> +When a guest is requests a modification of the polarization,
>> +QEMU sends a CPU_POLARIZATION_CHANGE event.
>> +
>> +When requesting the change, the guest only specifies horizontal or
>> +vertical polarization.
>> +It is the job of the admin to set the dedication and fine grained 
>> vertical entitlement
>> +in response to this event.
>> +
>> +Note that a vertical polarized dedicated vCPU can only have a high
>> +entitlement, this gives 6 possibilities for vCPU polarization:
>> +
>> +- Horizontal
>> +- Horizontal dedicated
>> +- Vertical low
>> +- Vertical medium
>> +- Vertical high
>> +- Vertical high dedicated
>> +
>> +Example of the event received when the guest issues the CPU instruction
>> +Perform Topology Function PTF(0) to request an horizontal polarization:
>> +
>> +.. code-block:: QMP
>> +
>> + <- { "event": "CPU_POLARIZATION_CHANGE",
>> +      "data": { "polarization": 0 },
>> +      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
>
>  Thomas
>
>
Thanks!

Regards,

Pierre

