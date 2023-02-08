Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8FA68F316
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 17:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjBHQW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 11:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBHQW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 11:22:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D58DBF8
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 08:22:55 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318GCFLK001784;
        Wed, 8 Feb 2023 16:22:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dO1eoTw6r5q8sY/BZO3+MUjcwgOEYcbb1h0MO883SGo=;
 b=JwM1WQGYPgpgWikiI3Qp13DA4ABV0j3TD5nPSdOnOUhxQNNC8THYzEG4NJ5mhbwHZGln
 AP544pyNwwDvzK/cbR4LtMeWmrNcUmP+sXl/tFEksi4cPfVQNFEjKtFJw+5jMSZBOuyc
 ww3GX6zp6mZNC8APFgNLyR8HNgk1iY/3KqusrMGfpnYqEKkqWFkvMZ5mrrQC5gW6X+P4
 0dES+ZQD9x+hrAHOK1NFAf/t0OF5E3D1WDwzoRGLmcCzjPrqjtPTgGEc4O0F+4kGmeBJ
 MO57+sPqnOY3Li89u+njmn7My3UuahgaHehkuVOzhB3dKYlkdHYvGvvJPs1wpNmJhKlM tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmf20ravt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 16:22:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 318GCrmV004034;
        Wed, 8 Feb 2023 16:22:46 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmf20rauv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 16:22:46 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3185t2se021050;
        Wed, 8 Feb 2023 16:22:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nhemfn587-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 16:22:43 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 318GMekT47317492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Feb 2023 16:22:40 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC8A320040;
        Wed,  8 Feb 2023 16:22:39 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F5AD2004D;
        Wed,  8 Feb 2023 16:22:39 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.183.35])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Feb 2023 16:22:39 +0000 (GMT)
Message-ID: <0d7c8c1f3c0a78faf54923274e0099f15c5cda12.camel@linux.ibm.com>
Subject: Re: [PATCH v15 11/11] docs/s390x/cpu topology: document s390x cpu
 topology
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Wed, 08 Feb 2023 17:22:39 +0100
In-Reply-To: <20230201132051.126868-12-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-12-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lWI3crC-VVHJXM1-4QQK7eUQl84Jxlld
X-Proofpoint-ORIG-GUID: _V3HXN0FAqZ6_mptKLQxzTiFNcomxnMl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302080143
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> > > > Add some basic examples for the definition of cpu topology
> > > > in s390x.
> > > >=20
> > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > ---
> > > > =C2=A0docs/system/s390x/cpu-topology.rst | 294 ++++++++++++++++++++=
+++++++++
> > > > =C2=A0docs/system/target-s390x.rst       |   1 +
> > > > =C2=A02 files changed, 295 insertions(+)
> > > > =C2=A0create mode 100644 docs/system/s390x/cpu-topology.rst
> > > >=20
> > > > diff --git a/docs/system/s390x/cpu-topology.rst b/docs/system/s390x=
/cpu-topology.rst
> > > > new file mode 100644
> > > > index 0000000000..e2190318c0
> > > > --- /dev/null
> > > > +++ b/docs/system/s390x/cpu-topology.rst
> > > > @@ -0,0 +1,294 @@
> > > > +CPU topology on s390x
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > +
> > > > +Since QEMU 8.0, CPU topology on s390x provides up to 4 levels of
> > > > +topology containers: drawers, books, sockets and cores.

Cores isn't a container itself, at least as defined by STSI.
Maybe use "nodes" instead?

> > > > +
> > > > +The first three containers define a tree hierarchy, the last one
> > > > +provides the placement of the CPUs inside the parent container and
> > > > +3 CPU attributes:

The latter half of the sentence is a bit confusing, it's too informed
by the output of STSI.
Suggestion:

The first three are containers, defining a tree shaped hierarchy.
There are three attributes associated with each core:
> > > > +
> > > > +- CPU type
> > > > +- polarity entitlement
> > > > +- dedication
> > > > +
> > > > +Note also that since 7.2 threads are no longer supported in the to=
pology
> > > > +and the ``-smp`` command line argument accepts only ``threads=3D1`=
`.
> > > > +
> > > > +Prerequisites
> > > > +-------------
> > > > +
> > > > +To use CPU topology a Linux QEMU/KVM machine providing the CPU top=
ology facility
> > > > +(STFLE bit 11) is required.
> > > > +
> > > > +However, since this facility has been enabled by default in an ear=
ly version
> > > > +of QEMU, we use a capability, ``KVM_CAP_S390_CPU_TOPOLOGY``, to no=
tify KVM
> > > > +that QEMU is supporting CPU topology.

supports

> > > > +
> > > > +Enabling CPU topology
> > > > +---------------------
> > > > +
> > > > +Currently, CPU topology is only enabled in the host model by defau=
lt.
> > > > +
> > > > +Enabling CPU topology in a CPU model is done by setting the CPU fl=
ag
> > > > +``ctop`` to ``on`` like in:
> > > > +
> > > > +.. code-block:: bash
> > > > +
> > > > +   -cpu gen16b,ctop=3Don
> > > > +
> > > > +Having the topology disabled by default allows migration between
> > > > +old and new QEMU without adding new flags.
> > > > +
> > > > +Default topology usage
> > > > +----------------------
> > > > +
> > > > +The CPU topology, can be specified on the QEMU command line

Drop the comma.

> > > > +with the ``-smp`` or the ``-device`` QEMU command arguments
> > > > +without using any new attributes.

Might want to split this up for -smp and -device.

If none of the new attributes (drawers, books) are specified for the
-smp flag, <description of default>
If none of the new attributes (drawer, book, dedicated, entitlement)
are specified for the -device cpu flag, the topology will be ...

> > > > +In this case, the topology will be calculated by simply adding
> > > > +to the topology the cores based on the core-id starting with
> > > > +core-0 at position 0 of socket-0, book-0, drawer-0 with default
> > > > +modifier attributes: horizontal polarity and no dedication.
> > > > +
> > > > +In the following machine we define 8 sockets with 4 cores each.
> > > > +Note that s390x QEMU machines do not implement multithreading.

You could drop that since you already said it earlier.

> > > > +
> > > > +.. code-block:: bash
> > > > +
> > > > +  $ qemu-system-s390x -m 2G \
> > > > +    -cpu gen16b,ctop=3Don \
> > > > +    -smp cpus=3D5,sockets=3D8,cores=3D4,maxcpus=3D32 \
> > > > +    -device host-s390x-cpu,core-id=3D14 \
> > > > +
> > > > +New CPUs can be plugged using the device_add hmp command like in:

"as in" or "like so" sounds better to my non-native ears.
Applies to other instances, too.

>=20
> > > > +
> > > > +.. code-block:: bash
> > > > +
> > > > +  (qemu) device_add gen16b-s390x-cpu,core-id=3D9
> > > > +
> > > > +The core-id defines the placement of the core in the topology by
> > > > +starting with core 0 in socket 0 up to maxcpus.

Suggestion:
The same placement of the CPU is derived from the core-id as described abov=
e.

> > > > +
> > > > +In the example above:
> > > > +
> > > > +* There are 5 CPUs provided to the guest with the ``-smp`` command=
 line
> > > > +  They will take the core-ids 0,1,2,3,4
> > > > +  As we have 4 cores in a socket, we have 4 CPUs provided
> > > > +  to the guest in socket 0, with core-ids 0,1,2,3.
> > > > +  The last cpu, with core-id 4, will be on socket 1.
> > > > +
> > > > +* the core with ID 14 provided by the ``-device`` command line wil=
l
> > > > +  be placed in socket 3, with core-id 14
> > > > +
> > > > +* the core with ID 9 provided by the ``device_add`` qmp command wi=
ll

You said it's a hmp command earlier.

> > > > +  be placed in socket 2, with core-id 9
> > > > +
> > > > +Polarity and dedication

s/Polarity/Polarization, same below

> > > > +-----------------------
> > > > +
> > > > +Polarity can be of two types: horizontal or vertical.
> > > > +
> > > > +The horizontal polarization specifies that all guest's vCPUs get
> > > > +almost the same amount of provisioning of real CPU by the host.
> > > > +
> > > > +The vertical polarization specifies that guest's vCPU can get
> > > > +different real CPU provisions:
> > > > +

No reason to capitalize vertical below, is there?

> > > > +- a vCPU with Vertical high entitlement specifies that this
> > > > +  vCPU gets 100% of the real CPU provisioning.
> > > > +
> > > > +- a vCPU with Vertical medium entitlement specifies that this
> > > > +  vCPU shares the real CPU with other vCPUs.
> > > > +
> > > > +- a vCPU with Vertical low entitlement specifies that this
> > > > +  vCPU only get real CPU provisioning when no other vCPU need it.

getS, vCPUs or needS

> > > > +
> > > > +In the case a vCPU with vertical high entitlement does not use

In case

> > > > +the real CPU, the unused "slack" can be dispatched to other vCPU

vCPUs

> > > > +with medium or low entitlement.
> > > > +
> > > > +A subsystem reset puts all vCPU of the configuration into the

vCPUs

> > > > +horizontal polarization.
> > > > +
> > > > +The admin specifies the dedicated bit when the vCPU is dedicated
> > > > +to a single real CPU.
> > > > +
> > > > +As for the Linux admin, the dedicated bit is an indication on the

Drop everything before the comma. indication of

> > > > +affinity of a vCPU for a real CPU while the entitlement indicates =
the

affinity of a vCPU to a real CPU, while

> > > > +sharing or exclusivity of use.
> > > > +
> > > > +Defining the topology on command line

on the command line

> > > > +-------------------------------------
> > > > +
> > > > +The topology can be defined entirely during the CPU definition,

The topology can entirely be defined using -device cpu statements,

> > > > +with the exception of CPU 0 which must be defined with the -smp
> > > > +argument.
> > > > +
> > > > +For example, here we set the position of the cores 1,2,3 on

position ... to

> > > > +drawer 1, book 1, socket 2 and cores 0,9 and 14 on drawer 0,

same here, s/on/to

> > > > +book 0, socket 0 with all horizontal polarity and not dedicated.
> > > > +The core 4, will be set on its default position on socket 1

set to ... in socket 1

> > > > +(since we have 4 core per socket) and we define it with dedication=
 and
> > > > +vertical high entitlement.
> > > > +
> > > > +.. code-block:: bash
> > > > +
> > > > +  $ qemu-system-s390x -m 2G \
> > > > +    -cpu gen16b,ctop=3Don \
> > > > +    -smp cpus=3D1,sockets=3D8,cores=3D4,maxcpus=3D32 \
> > > > +    \
> > > > +    -device gen16b-s390x-cpu,drawer-id=3D1,book-id=3D1,socket-id=
=3D2,core-id=3D1 \
> > > > +    -device gen16b-s390x-cpu,drawer-id=3D1,book-id=3D1,socket-id=
=3D2,core-id=3D2 \
> > > > +    -device gen16b-s390x-cpu,drawer-id=3D1,book-id=3D1,socket-id=
=3D2,core-id=3D3 \
> > > > +    \
> > > > +    -device gen16b-s390x-cpu,drawer-id=3D0,book-id=3D0,socket-id=
=3D0,core-id=3D9 \
> > > > +    -device gen16b-s390x-cpu,drawer-id=3D0,book-id=3D0,socket-id=
=3D0,core-id=3D14 \
> > > > +    \
> > > > +    -device gen16b-s390x-cpu,core-id=3D4,dedicated=3Don,polarity=
=3D3 \
> > > > +
> > > > +QAPI interface for topology
> > > > +---------------------------
> > > > +
> > > > +Let's start QEMU with the following command:
> > > > +
> > > > +.. code-block:: bash
> > > > +
> > > > + sudo /usr/local/bin/qemu-system-s390x \
> > > > +    -enable-kvm \
> > > > +    -cpu z14,ctop=3Don \
> > > > +    -smp 1,drawers=3D3,books=3D3,sockets=3D2,cores=3D2,maxcpus=3D3=
6 \
> > > > +    \
> > > > +    -device z14-s390x-cpu,core-id=3D19,polarity=3D3 \
> > > > +    -device z14-s390x-cpu,core-id=3D11,polarity=3D1 \
> > > > +    -device z14-s390x-cpu,core-id=3D112,polarity=3D3 \
> > > > +   ...
> > > > +
> > > > +and see the result when using of the QAPI interface.

s/of//

> > > > +
> > > > +addons to query-cpus-fast
> > > > ++++++++++++++++++++++++++
> > > > +
> > > > +The command query-cpus-fast allows the admin to query the topology
> > > > +tree and modifiers for all configured vCPU.

vCPUs

> > > > +
> > > > +.. code-block:: QMP
> > > > +
> > > > + -> { "execute": "query-cpus-fast" }
> > > > + {
> > > > +  "return": [
> > > > +    {
> > > > +      "dedicated": false,
> > > > +      "thread-id": 3631238,
> > > > +      "props": {
> > > > +        "core-id": 0,
> > > > +        "socket-id": 0,
> > > > +        "drawer-id": 0,
> > > > +        "book-id": 0
> > > > +      },
> > > > +      "cpu-state": "operating",
> > > > +      "qom-path": "/machine/unattached/device[0]",
> > > > +      "polarity": 2,
> > > > +      "cpu-index": 0,
> > > > +      "target": "s390x"
> > > > +    },
> > > > +    {
> > > > +      "dedicated": false,
> > > > +      "thread-id": 3631248,
> > > > +      "props": {
> > > > +        "core-id": 19,
> > > > +        "socket-id": 9,
> > > > +        "drawer-id": 0,
> > > > +        "book-id": 2
> > > > +      },
> > > > +      "cpu-state": "operating",
> > > > +      "qom-path": "/machine/peripheral-anon/device[0]",
> > > > +      "polarity": 3,
> > > > +      "cpu-index": 19,
> > > > +      "target": "s390x"
> > > > +    },
> > > > +    {
> > > > +      "dedicated": false,
> > > > +      "thread-id": 3631249,
> > > > +      "props": {
> > > > +        "core-id": 11,
> > > > +        "socket-id": 5,
> > > > +        "drawer-id": 0,
> > > > +        "book-id": 1
> > > > +      },
> > > > +      "cpu-state": "operating",
> > > > +      "qom-path": "/machine/peripheral-anon/device[1]",
> > > > +      "polarity": 1,
> > > > +      "cpu-index": 11,
> > > > +      "target": "s390x"
> > > > +    },
> > > > +    {
> > > > +      "dedicated": true,
> > > > +      "thread-id": 3631250,
> > > > +      "props": {
> > > > +        "core-id": 112,
> > > > +        "socket-id": 56,
> > > > +        "drawer-id": 3,
> > > > +        "book-id": 14
> > > > +      },
> > > > +      "cpu-state": "operating",
> > > > +      "qom-path": "/machine/peripheral-anon/device[2]",
> > > > +      "polarity": 3,
> > > > +      "cpu-index": 112,
> > > > +      "target": "s390x"
> > > > +    }
> > > > +  ]
> > > > + }
> > > > +
> > > > +x-set-cpu-topology
> > > > +++++++++++++++++++
> > > > +
> > > > +The command x-set-cpu-topology allows the admin to modify the topo=
logy
> > > > +tree or the topology modifiers of a vCPU in the configuration.
> > > > +
> > > > +.. code-block:: QMP
> > > > +
> > > > + -> { "execute": "x-set-cpu-topology",
> > > > +      "arguments": {
> > > > +         "core": 11,
> > > > +         "socket": 0,
> > > > +         "book": 0,
> > > > +         "drawer": 0,
> > > > +         "polarity": 0,
> > > > +         "dedicated": false
> > > > +      }
> > > > +    }
> > > > + <- {"return": {}}
> > > > +
> > > > +
> > > > +event CPU_POLARITY_CHANGE
> > > > ++++++++++++++++++++++++++
> > > > +
> > > > +When a guest is requesting a modification of the polarity,

requests

> > > > +QEMU sends a CPU_POLARITY_CHANGE event.
> > > > +
> > > > +When requesting the change, the guest only specifies horizontal or
> > > > +vertical polarity.
> > > > +The dedication and fine grain vertical entitlement depends on admi=
n
> > > > +to set according to its response to this event.

It is the job of the admin to set the dedication and fine grained vertical =
entitlement
in response to this event.

> > > > +
> > > > +Note that a vertical polarized dedicated vCPU can only have a high
> > > > +entitlement, this gives 6 possibilities for a vCPU polarity:

for vCPU polarization.

> > > > +
> > > > +- Horizontal
> > > > +- Horizontal dedicated
> > > > +- Vertical low
> > > > +- Vertical medium
> > > > +- Vertical high
> > > > +- Vertical high dedicated
> > > > +
> > > > +Example of the event received when the guest issues the CPU instru=
ction
> > > > +Perform Topology Function PTF(0) to request an horizontal polarity=
:
> > > > +
> > > > +.. code-block:: QMP
> > > > +
> > > > + <- { "event": "CPU_POLARITY_CHANGE",
> > > > +      "data": { "polarity": 0 },
> > > > +      "timestamp": { "seconds": 1401385907, "microseconds": 422329=
 } }
> > > > +
> > > > +
> > > > diff --git a/docs/system/target-s390x.rst b/docs/system/target-s390=
x.rst
> > > > index c636f64113..ff0ffe04f3 100644
> > > > --- a/docs/system/target-s390x.rst
> > > > +++ b/docs/system/target-s390x.rst
> > > > @@ -33,3 +33,4 @@ Architectural features
> > > > =C2=A0.. toctree::
> > > > =C2=A0=C2=A0=C2=A0=C2=A0s390x/bootdevices
> > > > =C2=A0=C2=A0=C2=A0=C2=A0s390x/protvirt
> > > > +   s390x/cpu-topology


I'm not too big a fan of using "admin", I guess in reality it's mostly goin=
g to be libvirt
adjusting things. Maybe reformulate sentences to get rid of it or use
"outside administrative entity" or something similar. But in the end it's n=
ot too important.


