Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5C36D4ED2
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 19:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjDCRV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 13:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjDCRV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 13:21:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3DCF9
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 10:21:56 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333Gb1gq013995;
        Mon, 3 Apr 2023 17:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=H0oefgXSG7DE3vdSEPC1b/O39uL6ndd946x5sZ0C8yk=;
 b=R6rX7kDmE1b/ZLN1Z5BFcd8ptPbCQtY1QNksbZ7NcSX4Ju9YpG5g3pZpR5/CFgEzYG43
 WMlvKsSTvW/3S9dbU7+Cgr7PKTtEE5+5fIEhBy1k7FpByB0HMF0F3479H49xQEamwtQR
 18fdcSEQd+WddXui20+1hXMGfF25LsGK195EtvHW7CxAmvNW7q4lh//9Z9SMbnl9o9tf
 +SJ57AWDLG/45kkzyMM7CylRwAu5d5SCK6NdC626FW8ACB76rHRCQx5QKP2C6VS3ofYK
 OnxcU13XX4JAzyRUVv3n0MrvshPYTguMZ49tzn7G7f0na9Y+zrGdEbuKD39rRCayJbY9 BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pqy2dqyr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 17:21:40 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 333Gr9P8016714;
        Mon, 3 Apr 2023 17:21:40 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pqy2dqyqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 17:21:39 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 332NLXrC015014;
        Mon, 3 Apr 2023 17:21:38 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3ppc86sdvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 17:21:38 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 333HLYN843778630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 17:21:34 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70C062004B;
        Mon,  3 Apr 2023 17:21:34 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17F5B20040;
        Mon,  3 Apr 2023 17:21:33 +0000 (GMT)
Received: from [9.179.22.128] (unknown [9.179.22.128])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  3 Apr 2023 17:21:33 +0000 (GMT)
Message-ID: <b4aeaad7-8e32-5dfe-1bb5-7341df7786fb@linux.ibm.com>
Date:   Mon, 3 Apr 2023 19:21:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 13/21] docs/s390x/cpu topology: document s390x cpu
 topology
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-14-pmorel@linux.ibm.com>
 <6541fc8a-9c57-ecbf-d25f-ddb0808e3ae7@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <6541fc8a-9c57-ecbf-d25f-ddb0808e3ae7@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cH6EmzgRGquHQoG9p-xN3kVoqsQwe8By
X-Proofpoint-ORIG-GUID: Emluvr-56ehHVH9LLaTkpoCsVpFdFSL7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_14,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 clxscore=1015 adultscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030123
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/3/23 19:00, Cédric Le Goater wrote:
> On 4/3/23 18:28, Pierre Morel wrote:
>> Add some basic examples for the definition of cpu topology
>> in s390x.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   MAINTAINERS                        |   2 +
>>   docs/devel/index-internals.rst     |   1 +
>>   docs/devel/s390-cpu-topology.rst   | 161 +++++++++++++++++++
>>   docs/system/s390x/cpu-topology.rst | 238 +++++++++++++++++++++++++++++
>>   docs/system/target-s390x.rst       |   1 +
>>   5 files changed, 403 insertions(+)
>>   create mode 100644 docs/devel/s390-cpu-topology.rst
>>   create mode 100644 docs/system/s390x/cpu-topology.rst
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index de9052f753..fe5638e31d 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1660,6 +1660,8 @@ S: Supported
>>   F: include/hw/s390x/cpu-topology.h
>>   F: hw/s390x/cpu-topology.c
>>   F: target/s390x/kvm/cpu_topology.c
>> +F: docs/devel/s390-cpu-topology.rst
>> +F: docs/system/s390x/cpu-topology.rst
>>     X86 Machines
>>   ------------
>> diff --git a/docs/devel/index-internals.rst 
>> b/docs/devel/index-internals.rst
>> index e1a93df263..6f81df92bc 100644
>> --- a/docs/devel/index-internals.rst
>> +++ b/docs/devel/index-internals.rst
>> @@ -14,6 +14,7 @@ Details about QEMU's various subsystems including 
>> how to add features to them.
>>      migration
>>      multi-process
>>      reset
>> +   s390-cpu-topology
>>      s390-dasd-ipl
>>      tracing
>>      vfio-migration
>> diff --git a/docs/devel/s390-cpu-topology.rst 
>> b/docs/devel/s390-cpu-topology.rst
>> new file mode 100644
>> index 0000000000..0b7bb42079
>> --- /dev/null
>> +++ b/docs/devel/s390-cpu-topology.rst
>> @@ -0,0 +1,161 @@
>> +QAPI interface for S390 CPU topology
>> +====================================
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
>> +Addons to query-cpus-fast
>> +-------------------------
>> +
>> +The command query-cpus-fast allows to query the topology tree and
>> +modifiers for all configured vCPUs.
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
>> +QAPI command: set-cpu-topology
>> +------------------------------
>> +
>> +The command set-cpu-topology allows to modify the topology tree
>> +or the topology modifiers of a vCPU in the configuration.
>> +
>> +.. code-block:: QMP
>> +
>> +    { "execute": "set-cpu-topology",
>> +      "arguments": {
>> +         "core-id": 11,
>> +         "socket-id": 0,
>> +         "book-id": 0,
>> +         "drawer-id": 0,
>> +         "entitlement": "low",
>> +         "dedicated": false
>> +      }
>> +    }
>> +    {"return": {}}
>> +
>> +The core-id parameter is the only non optional parameter and every
>> +unspecified parameter keeps its previous value.
>> +
>> +QAPI event CPU_POLARIZATION_CHANGE
>> +----------------------------------
>> +
>> +When a guest is requests a modification of the polarization,
>> +QEMU sends a CPU_POLARIZATION_CHANGE event.
>> +
>> +When requesting the change, the guest only specifies horizontal or
>> +vertical polarization.
>> +It is the job of the upper layer to set the dedication and fine grained
>> +vertical entitlement in response to this event.
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
>> +    { "event": "CPU_POLARIZATION_CHANGE",
>> +      "data": { "polarization": 0 },
>> +      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
>> +
>> +QAPI query command: query-cpu-polarization
>> +------------------------------
>
> Some dashes are missing from this line. No need to resend, it's easy 
> to fix.
>
> Thanks,
>
> C.

grrr stupido.

Thanks Cédric

Pierre



>
>> +
>> +The query command query-cpu-polarization returns the current
>> +CPU polarization of the machine.
>> +
>> +.. code-block:: QMP
>> +
>> +    { "execute": "query-cpu-polarization" }
>> +    {
>> +        "return": {
>> +          "polarization": "vertical"
>> +        }
>> +    }
>> diff --git a/docs/system/s390x/cpu-topology.rst 
>> b/docs/system/s390x/cpu-topology.rst
>> new file mode 100644
>> index 0000000000..c1fe3da51c
>> --- /dev/null
>> +++ b/docs/system/s390x/cpu-topology.rst
>> @@ -0,0 +1,238 @@
>> +CPU topology on s390x
>> +=====================
>> +
>> +Since QEMU 8.1, CPU topology on s390x provides up to 3 levels of
>> +topology containers: drawers, books, sockets, defining a tree shaped
>> +hierarchy.
>> +
>> +The socket container contains one or more CPU entries.
>> +Each of these CPU entries consists of a bitmap and three CPU 
>> attributes:
>> +
>> +- CPU type
>> +- polarization entitlement
>> +- dedication
>> +
>> +Each bit set in the bitmap correspond to the core-id of a vCPU with
>> +matching the three attribute.
>> +
>> +This documentation provide general information on S390 CPU topology,
>> +how to enable it and on the new CPU attributes.
>> +For information on how to modify the S390 CPU topology and on how to
>> +monitor the polarization change see ``Developer Information``.
>> +
>> +Prerequisites
>> +-------------
>> +
>> +To use the CPU topology, you need to run with KVM on a s390x host that
>> +uses the Linux kernel v6.0 or newer (which provide the so-called
>> +``KVM_CAP_S390_CPU_TOPOLOGY`` capability that allows QEMU to signal the
>> +CPU topology facility via the so-called STFLE bit 11 to the VM).
>> +
>> +Enabling CPU topology
>> +---------------------
>> +
>> +Currently, CPU topology is only enabled in the host model by default.
>> +
>> +Enabling CPU topology in a CPU model is done by setting the CPU flag
>> +``ctop`` to ``on`` like in:
>> +
>> +.. code-block:: bash
>> +
>> +   -cpu gen16b,ctop=on
>> +
>> +Having the topology disabled by default allows migration between
>> +old and new QEMU without adding new flags.
>> +
>> +Default topology usage
>> +----------------------
>> +
>> +The CPU topology can be specified on the QEMU command line
>> +with the ``-smp`` or the ``-device`` QEMU command arguments.
>> +
>> +Note also that since 7.2 threads are no longer supported in the 
>> topology
>> +and the ``-smp`` command line argument accepts only ``threads=1``.
>> +
>> +If none of the containers attributes (drawers, books, sockets) are
>> +specified for the ``-smp`` flag, the number of these containers
>> +is ``1`` .
>> +
>> +.. code-block:: bash
>> +
>> +    -smp cpus=5,drawer=1,books=1,sockets=8,cores=4,maxcpus=32
>> +
>> +or
>> +
>> +.. code-block:: bash
>> +
>> +    -smp cpus=5,sockets=8,cores=4,maxcpus=32
>> +
>> +When a CPU is defined by the ``-smp`` command argument, its position
>> +inside the topology is calculated by adding the CPUs to the topology
>> +based on the core-id starting with core-0 at position 0 of socket-0,
>> +book-0, drawer-0 and filling all CPUs of socket-0 before to fill 
>> socket-1
>> +of book-0 and so on up to the last socket of the last book of the last
>> +drawer.
>> +
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
>> +for the ``-device`` argument, as for all CPUs defined with the ``-smp``
>> +command argument the topology tree attributes will be set by simply
>> +adding the CPUs to the topology based on the core-id starting with
>> +core-0 at position 0 of socket-0, book-0, drawer-0.
>> +
>> +QEMU will not try to solve collisions and will report an error if the
>> +CPU topology, explicitly or implicitly defined on a ``-device``
>> +argument collides with the definition of a CPU implicitely defined
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
>> +The vertical polarization specifies that the guest's vCPU can get
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
>> +The upper level specifies a vCPU as ``dedicated`` when the vCPU is
>> +fully dedicated to a single real CPU.
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
>> diff --git a/docs/system/target-s390x.rst b/docs/system/target-s390x.rst
>> index f6f11433c7..94c981e732 100644
>> --- a/docs/system/target-s390x.rst
>> +++ b/docs/system/target-s390x.rst
>> @@ -34,3 +34,4 @@ Architectural features
>>   .. toctree::
>>      s390x/bootdevices
>>      s390x/protvirt
>> +   s390x/cpu-topology
>
