Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC246884B3
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 17:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjBBQmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 11:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjBBQmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 11:42:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FC66D5F8
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 08:42:43 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312Gg6QG029608;
        Thu, 2 Feb 2023 16:42:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ClMm1h/+sSPJhNszDIMbPvEm4HyjMtEoOluvPI99aWY=;
 b=p8xxJD4GetrTMdkjf4lhBy6Hv5e9MDbm9YvIR5WwmHZdUspZyUqxx/JASG4yzo7Hqlqd
 G4v8BJCy4T9ERbw68xiqEPfyO7Qig3MqpQTkIU/m4O/D+7o26U8TuUi8TI4m/sTM5sYk
 4nkByF3vkcfWiaLFNxPDb20ftDXnMvNTTyVSKwpw4SWWIlU13to1ZtKC5aWqeuZwFFLm
 zZS5PNPX81fwVlDqupGalNUSLYg4EQr9ybld41cmcvJlJBzJL137cIZgZPf1ZDVIGnP5
 aRLcNgsFiYYOw05ZQ3MY6RrmfrwbSJvf2ImCC9dSY5liafAUQbUl2XCBXu1U0gdypY// CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngdvmvvad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 16:42:31 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 312GgVio032621;
        Thu, 2 Feb 2023 16:42:31 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngdvmvv8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 16:42:31 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3123Amp6028153;
        Thu, 2 Feb 2023 16:42:29 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3ncvuqvkws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 16:42:29 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 312GgPO330802200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Feb 2023 16:42:25 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 352CA20040;
        Thu,  2 Feb 2023 16:42:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0DEB20043;
        Thu,  2 Feb 2023 16:42:24 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.142.89])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  2 Feb 2023 16:42:24 +0000 (GMT)
Message-ID: <6345131acfb04e353ca2eba620bf27609bfeb535.camel@linux.ibm.com>
Subject: Re: [PATCH v15 02/11] s390x/cpu topology: add topology entries on
 CPU hotplug
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Thu, 02 Feb 2023 17:42:24 +0100
In-Reply-To: <20230201132051.126868-3-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Jc0TnAmFt6pvH6Cj13-ZlkF0RlrcGJHf
X-Proofpoint-GUID: _T3ArDBbIxfJ0LiQ9X-DZ1jRMbs8U2kI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_10,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> The topology information are attributes of the CPU and are
> specified during the CPU device creation.
>=20
> On hot plug we:
> - calculate the default values for the topology for drawers,
>   books and sockets in the case they are not specified.
> - verify the CPU attributes
> - check that we have still room on the desired socket
>=20
> The possibility to insert a CPU in a mask is dependent on the
> number of cores allowed in a socket, a book or a drawer, the
> checking is done during the hot plug of the CPU to have an
> immediate answer.
>=20
> If the complete topology is not specified, the core is added
> in the physical topology based on its core ID and it gets
> defaults values for the modifier attributes.
>=20
> This way, starting QEMU without specifying the topology can
> still get some advantage of the CPU topology.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  include/hw/s390x/cpu-topology.h |  24 +++
>  hw/s390x/cpu-topology.c         | 256 ++++++++++++++++++++++++++++++++
>  hw/s390x/s390-virtio-ccw.c      |  23 ++-
>  hw/s390x/meson.build            |   1 +
>  4 files changed, 302 insertions(+), 2 deletions(-)
>  create mode 100644 hw/s390x/cpu-topology.c
>=20
[...]
>=20
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..12df4eca6c
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,256 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> +
> + * This work is licensed under the terms of the GNU GPL, version 2 or (a=
t
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/boards.h"
> +#include "qemu/typedefs.h"
> +#include "target/s390x/cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
> +#include "hw/s390x/cpu-topology.h"
> +
> +/*
> + * s390_topology is used to keep the topology information.
> + * .list: queue the topology entries inside which
> + *        we keep the information on the CPU topology.

.list doesn't exist yet.

> + * .socket: tracks information on the count of cores per socket.
> + * .smp: keeps track of the machine topology.
> + *
> + */
> +S390Topology s390_topology =3D {
> +    /* will be initialized after the cpu model is realized */
> +    .cores_per_socket =3D NULL,
> +    .smp =3D NULL,
> +};
>=20
[...]
> +
> +/**
> + * s390_topology_cpu_default:
> + * @cpu: pointer to a S390CPU
> + * @errp: Error pointer
> + *
> + * Setup the default topology for unset attributes.

My suggestion:
Setup the default topology if no attributes are already set.
Passing a CPU with some, but not all, attributes set is considered an error=
.

> + *
> + * The function accept only all all default values or all set values
> + * for the geometry topology.

acceptS, all all
If you take my suggestion, you can just drop this sentence.

> + *
> + * The function calculates the (drawer_id, book_id, socket_id)
> + * topology by filling the cores starting from the first socket
> + * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
> + *
> + * CPU type, polarity and dedication have defaults values set in the
> + * s390x_cpu_properties.
> + */
> +static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
> +{
> +    CpuTopology *smp =3D s390_topology.smp;
> +    CPUS390XState *env =3D &cpu->env;
> +
> +    /* All geometry topology attributes must be set or all unset */
> +    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer_id < 0) &=
&
> +        (env->socket_id >=3D 0 || env->book_id >=3D 0 || env->drawer_id =
>=3D 0)) {
> +        error_setg(errp,
> +                   "Please define all or none of the topology geometry a=
ttributes");
> +        return;
> +    }
> +
> +    /* Check if one of the geometry topology is unset */
> +    if (env->socket_id < 0) {
> +        /* Calculate default geometry topology attributes */
> +        env->socket_id =3D (env->core_id / smp->cores) % smp->sockets;
> +        env->book_id =3D (env->core_id / (smp->sockets * smp->cores)) %
> +                       smp->books;
> +        env->drawer_id =3D (env->core_id /
> +                          (smp->books * smp->sockets * smp->cores)) %
> +                         smp->drawers;
> +    }
> +}
>=20
[...]
> +
> +/**
> + * s390_set_core_in_socket:
> + * @cpu: the new S390CPU to insert in the topology structure
> + * @drawer_id: new drawer_id
> + * @book_id: new book_id
> + * @socket_id: new socket_id
> + * @creation: if is true the CPU is a new CPU and there is no old socket
> + *            to handle.
> + *            if is false, this is a moving the CPU and old socket count
> + *            must be decremented.
> + * @errp: the error pointer
> + *
> + */
> +static void s390_set_core_in_socket(S390CPU *cpu, int drawer_id, int boo=
k_id,

Maybe name it s390_(topology_)?add_core_to_socket instead.

> +                                    int socket_id, bool creation, Error =
**errp)
> +{
> +    int old_socket =3D s390_socket_nb(cpu);
> +    int new_socket;
> +
> +    if (creation) {
> +        new_socket =3D old_socket;
> +    } else {

You need parentheses here.

> +        new_socket =3D drawer_id * s390_topology.smp->books +
                       (
> +                     book_id * s390_topology.smp->sockets +
                               )
> +                     socket_id;
> +    }
> +
> +    /* Check for space on new socket */
> +    if ((new_socket !=3D old_socket) &&
> +        (s390_topology.cores_per_socket[new_socket] >=3D
> +         s390_topology.smp->cores)) {
> +        error_setg(errp, "No more space on this socket");
> +        return;
> +    }
> +
> +    /* Update the count of cores in sockets */
> +    s390_topology.cores_per_socket[new_socket] +=3D 1;
> +    if (!creation) {
> +        s390_topology.cores_per_socket[old_socket] -=3D 1;
> +    }
> +}
>=20
[...]

> +/**
> + * s390_topology_set_cpu:
> + * @ms: MachineState used to initialize the topology structure on
> + *      first call.
> + * @cpu: the new S390CPU to insert in the topology structure
> + * @errp: the error pointer
> + *
> + * Called from CPU Hotplug to check and setup the CPU attributes
> + * before to insert the CPU in the topology.
> + */
> +void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)

The name is rather non informative.
s390_topology_setup_cpu ?

> +{
> +    ERRP_GUARD();
> +
> +    /*
> +     * We do not want to initialize the topology if the cpu model
> +     * does not support topology consequently, we have to wait for
                                   ^
Still think there should be a comma here.

> +     * the first CPU to be realized, which realizes the CPU model
> +     * to initialize the topology structures.
> +     *
> +     * s390_topology_set_cpu() is called from the cpu hotplug.
> +     */
> +    if (!s390_topology.cores_per_socket) {
> +        s390_topology_init(ms);
> +    }
> +
> +    s390_topology_check(cpu, errp);
> +    if (*errp) {
> +        return;
> +    }
> +
> +    /* Set the CPU inside the socket */
> +    s390_set_core_in_socket(cpu, 0, 0, 0, true, errp);
> +    if (*errp) {
> +        return;
> +    }
> +
> +    /* topology tree is reflected in props */
> +    s390_update_cpu_props(ms, cpu);
> +}
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index f3cc845d3b..9bc51a83f4 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -44,6 +44,7 @@
>  #include "hw/s390x/pv.h"
>  #include "migration/blocker.h"
>  #include "qapi/visitor.h"
> +#include "hw/s390x/cpu-topology.h"
> =20
>  static Error *pv_mig_blocker;
> =20
> @@ -310,10 +311,18 @@ static void s390_cpu_plug(HotplugHandler *hotplug_d=
ev,
>  {
>      MachineState *ms =3D MACHINE(hotplug_dev);
>      S390CPU *cpu =3D S390_CPU(dev);
> +    ERRP_GUARD();
> =20
>      g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>      ms->possible_cpus->cpus[cpu->env.core_id].cpu =3D OBJECT(dev);
> =20
> +    if (s390_has_topology()) {
> +        s390_topology_set_cpu(ms, cpu, errp);
> +        if (*errp) {
> +            return;
> +        }
> +    }
> +
>      if (dev->hotplugged) {
>          raise_irq_cpu_hotplug();
>      }
> @@ -551,11 +560,21 @@ static const CPUArchIdList *s390_possible_cpu_arch_=
ids(MachineState *ms)
>                                    sizeof(CPUArchId) * max_cpus);
>      ms->possible_cpus->len =3D max_cpus;
>      for (i =3D 0; i < ms->possible_cpus->len; i++) {
> +        CpuInstanceProperties *props =3D &ms->possible_cpus->cpus[i].pro=
ps;
> +
>          ms->possible_cpus->cpus[i].type =3D ms->cpu_type;
>          ms->possible_cpus->cpus[i].vcpus_count =3D 1;
>          ms->possible_cpus->cpus[i].arch_id =3D i;
> -        ms->possible_cpus->cpus[i].props.has_core_id =3D true;
> -        ms->possible_cpus->cpus[i].props.core_id =3D i;
> +
> +        props->has_core_id =3D true;
> +        props->core_id =3D i;
> +        props->has_socket_id =3D true;
> +        props->socket_id =3D i / ms->smp.cores;
> +        props->has_book_id =3D true;
> +        props->book_id =3D i / (ms->smp.cores * ms->smp.sockets);
> +        props->has_drawer_id =3D true;
> +        props->drawer_id =3D i /
> +                           (ms->smp.cores * ms->smp.sockets * ms->smp.bo=
oks);

You need to calculate the modulus like in s390_topology_cpu_default, right?

>      }
> =20
>      return ms->possible_cpus;
> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
> index f291016fee..58dfbdff4f 100644
> --- a/hw/s390x/meson.build
> +++ b/hw/s390x/meson.build
> @@ -24,6 +24,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
>    's390-stattrib-kvm.c',
>    'pv.c',
>    's390-pci-kvm.c',
> +  'cpu-topology.c',
>  ))
>  s390x_ss.add(when: 'CONFIG_TCG', if_true: files(
>    'tod-tcg.c',

