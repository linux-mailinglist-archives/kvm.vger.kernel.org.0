Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED48E6A2058
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjBXRPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBXRPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:15:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC5014485
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:15:41 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OGxHrL025604;
        Fri, 24 Feb 2023 17:15:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8SRgXNPyo2+5FW/U2Oj4JjqI8gDbHdhUjOb+LSqa7aI=;
 b=KEyNlNC4ZWrC2brTxt3s+EwcWFzJcQOVYezB59BB9K8cN8GLsnQGLhmgK/ZDpWPnO9PX
 m8VKKJ2unhoncTRufVEV8wjJwludHGGaPq2Lb5UhR3XXta3cQ0tSkgwHJf+dVV73gaPD
 YFAqUb6IT3BJ1QmhceCJfIMSHY9PQtKkT1A0grGF8ulUsHK2glDVmuee4bIjkL2KB5ja
 dIurA+PXKmMcvsuVc898M+0ONyulbcnWSTuHAVbJhD8zNus4SQGnYYUja8GopBhfyuzD
 1+bDa+fSmCGnHB/jpP8vfCDim9M97jMGh8qnmopAkDWYUa8nF8pm28XVSTraVYEQtOQP WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxuqb0wxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 17:15:31 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31OHBIMn000915;
        Fri, 24 Feb 2023 17:15:31 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxuqb0wwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 17:15:30 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31O2g4M2018694;
        Fri, 24 Feb 2023 17:15:28 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3ntnxf67cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 17:15:28 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31OHFOSv28836220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:15:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EC7520043;
        Fri, 24 Feb 2023 17:15:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 275822004B;
        Fri, 24 Feb 2023 17:15:24 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.191.48])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Feb 2023 17:15:24 +0000 (GMT)
Message-ID: <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
Subject: Re: [PATCH v16 08/11] qapi/s390x/cpu topology: set-cpu-topology
 monitor command
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Fri, 24 Feb 2023 18:15:23 +0100
In-Reply-To: <20230222142105.84700-9-pmorel@linux.ibm.com>
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
         <20230222142105.84700-9-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KusDLbSoGzkG3OsC79WYknxvV_q_n7sm
X-Proofpoint-GUID: L2BrJC4ri3ewYiV61q_WflwvAMLhzq-1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240134
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-22 at 15:21 +0100, Pierre Morel wrote:
> The modification of the CPU attributes are done through a monitor
> command.
>=20
> It allows to move the core inside the topology tree to optimize
> the cache usage in the case the host's hypervisor previously
> moved the CPU.
>=20
> The same command allows to modify the CPU attributes modifiers
> like polarization entitlement and the dedicated attribute to notify
> the guest if the host admin modified scheduling or dedication of a vCPU.
>=20
> With this knowledge the guest has the possibility to optimize the
> usage of the vCPUs.
>=20
> The command has a feature unstable for the moment.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  qapi/machine-target.json |  35 +++++++++
>  include/monitor/hmp.h    |   1 +
>  hw/s390x/cpu-topology.c  | 154 +++++++++++++++++++++++++++++++++++++++
>  hmp-commands.hx          |  17 +++++
>  4 files changed, 207 insertions(+)
>=20
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index a52cc32f09..baa9d273cf 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -354,3 +354,38 @@
>  { 'enum': 'CpuS390Polarization',
>    'prefix': 'S390_CPU_POLARIZATION',
>    'data': [ 'horizontal', 'vertical' ] }
> +
> +##
> +# @set-cpu-topology:
> +#
> +# @core-id: the vCPU ID to be moved
> +# @socket-id: optional destination socket where to move the vCPU
> +# @book-id: optional destination book where to move the vCPU
> +# @drawer-id: optional destination drawer where to move the vCPU
> +# @entitlement: optional entitlement
> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
> +#
> +# Features:
> +# @unstable: This command may still be modified.
> +#
> +# Modifies the topology by moving the CPU inside the topology
> +# tree or by changing a modifier attribute of a CPU.
> +# Default value for optional parameter is the current value
> +# used by the CPU.
> +#
> +# Returns: Nothing on success, the reason on failure.
> +#
> +# Since: 8.0
> +##
> +{ 'command': 'set-cpu-topology',
> +  'data': {
> +      'core-id': 'uint16',
> +      '*socket-id': 'uint16',
> +      '*book-id': 'uint16',
> +      '*drawer-id': 'uint16',
> +      '*entitlement': 'str',

How about you add a machine-common.json and define CpuS390Entitlement there=
,
and then include it from both machine.json and machine-target.json?

Then you can declare it as CpuS390Entitlement and don't need to do the pars=
ing
manually.

You could also put it in common.json, but that seems a bit too generic.

Anyone have objections?

> +      '*dedicated': 'bool'
> +  },
> +  'features': [ 'unstable' ],
> +  'if': { 'all': [ 'TARGET_S390X' ] }
> +}
> diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
> index 2220f14fc9..4e65e6d08e 100644
> --- a/include/monitor/hmp.h
> +++ b/include/monitor/hmp.h
> @@ -178,5 +178,6 @@ void hmp_ioport_read(Monitor *mon, const QDict *qdict=
);
>  void hmp_ioport_write(Monitor *mon, const QDict *qdict);
>  void hmp_boot_set(Monitor *mon, const QDict *qdict);
>  void hmp_info_mtree(Monitor *mon, const QDict *qdict);
> +void hmp_set_cpu_topology(Monitor *mon, const QDict *qdict);
> =20
>  #endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index ed5fc75381..3a7eb441a3 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -19,6 +19,12 @@
>  #include "hw/s390x/s390-virtio-ccw.h"
>  #include "hw/s390x/cpu-topology.h"
>  #include "qapi/qapi-types-machine-target.h"
> +#include "qapi/qapi-types-machine.h"
> +#include "qapi/qapi-commands-machine-target.h"
> +#include "qapi/qmp/qdict.h"
> +#include "monitor/hmp.h"
> +#include "monitor/monitor.h"
> +
>  /*
>   * s390_topology is used to keep the topology information.
>   * .cores_per_socket: tracks information on the count of cores
> @@ -310,6 +316,26 @@ static void s390_topology_add_core_to_socket(S390CPU=
 *cpu, int drawer_id,
>      }
>  }
> =20
> +/**
> + * s390_topology_need_report
> + * @cpu: Current cpu
> + * @drawer_id: future drawer ID
> + * @book_id: future book ID
> + * @socket_id: future socket ID
> + *
> + * A modified topology change report is needed if the
> + */
> +static int s390_topology_need_report(S390CPU *cpu, int drawer_id,
> +                                   int book_id, int socket_id,
> +                                   uint16_t entitlement, bool dedicated)
> +{
> +    return cpu->env.drawer_id !=3D drawer_id ||
> +           cpu->env.book_id !=3D book_id ||
> +           cpu->env.socket_id !=3D socket_id ||
> +           cpu->env.entitlement !=3D entitlement ||
> +           cpu->env.dedicated !=3D dedicated;
> +}
> +
>  /**
>   * s390_update_cpu_props:
>   * @ms: the machine state
> @@ -376,3 +402,131 @@ void s390_topology_setup_cpu(MachineState *ms, S390=
CPU *cpu, Error **errp)
>      /* topology tree is reflected in props */
>      s390_update_cpu_props(ms, cpu);
>  }
> +
> +/*
> + * qmp and hmp implementations
> + */
> +
> +#define TOPOLOGY_SET(n) do {                                \
> +                            if (has_ ## n) {                \
> +                                calc_ ## n =3D n;             \
> +                            } else {                        \
> +                                calc_ ## n =3D cpu->env.n;    \
> +                            }                               \
> +                        } while (0)
> +
> +static void s390_change_topology(uint16_t core_id,
> +                                 bool has_socket_id, uint16_t socket_id,
> +                                 bool has_book_id, uint16_t book_id,
> +                                 bool has_drawer_id, uint16_t drawer_id,
> +                                 bool has_entitlement, uint16_t entitlem=
ent,
> +                                 bool has_dedicated, bool dedicated,
> +                                 Error **errp)
> +{
> +    MachineState *ms =3D current_machine;
> +    uint16_t calc_dedicated, calc_entitlement;
> +    uint16_t calc_socket_id, calc_book_id, calc_drawer_id;
> +    S390CPU *cpu;
> +    int report_needed;
> +    ERRP_GUARD();
> +
> +    if (core_id >=3D ms->smp.max_cpus) {
> +        error_setg(errp, "Core-id %d out of range!", core_id);
> +        return;
> +    }
> +
> +    cpu =3D (S390CPU *)ms->possible_cpus->cpus[core_id].cpu;
> +    if (!cpu) {
> +        error_setg(errp, "Core-id %d does not exist!", core_id);
> +        return;
> +    }
> +
> +    /* Get unprovided attributes from cpu and verify the new topology */

Get attributes not provided...

> +    TOPOLOGY_SET(entitlement);
> +    TOPOLOGY_SET(dedicated);
> +    TOPOLOGY_SET(socket_id);
> +    TOPOLOGY_SET(book_id);
> +    TOPOLOGY_SET(drawer_id);

You could also just assign to the arguments, i.e.

if (!has_socket_id)
    socket_id =3D cpu->env.socket_id;

> +
> +    s390_topology_check(calc_socket_id, calc_book_id, calc_drawer_id,
> +                        calc_entitlement, calc_dedicated, errp);
> +    if (*errp) {
> +        return;
> +    }
> +
> +    /* Move the CPU into its new socket */
> +    s390_topology_add_core_to_socket(cpu, calc_drawer_id, calc_book_id,
> +                                     calc_socket_id, false, errp);
> +    if (*errp) {
> +        return;
> +    }
> +
> +    /* Check if we need to report the modified topology */
> +    report_needed =3D s390_topology_need_report(cpu, calc_drawer_id, cal=
c_book_id,
> +                                              calc_socket_id, calc_entit=
lement,
> +                                              calc_dedicated);
> +
> +    /* All checks done, report new topology into the vCPU */
> +    cpu->env.drawer_id =3D calc_drawer_id;
> +    cpu->env.book_id =3D calc_book_id;
> +    cpu->env.socket_id =3D calc_socket_id;
> +    cpu->env.dedicated =3D calc_dedicated;
> +    cpu->env.entitlement =3D calc_entitlement;
> +
> +    /* topology tree is reflected in props */
> +    s390_update_cpu_props(ms, cpu);
> +
> +    /* Advertise the topology change */
> +    if (report_needed) {
> +        s390_cpu_topology_set_changed(true);
> +    }
> +}
> +
> +void qmp_set_cpu_topology(uint16_t core,
> +                         bool has_socket, uint16_t socket,
> +                         bool has_book, uint16_t book,
> +                         bool has_drawer, uint16_t drawer,
> +                         const char *entitlement_str,
> +                         bool has_dedicated, bool dedicated,
> +                         Error **errp)
> +{
> +    bool has_entitlement =3D false;
> +    int entitlement;
> +    ERRP_GUARD();
> +
> +    if (!s390_has_topology()) {
> +        error_setg(errp, "This machine doesn't support topology");
> +        return;
> +    }
> +
> +    entitlement =3D qapi_enum_parse(&CpuS390Entitlement_lookup, entitlem=
ent_str,
> +                                  -1, errp);
> +    if (*errp) {
> +        return;
> +    }
> +    has_entitlement =3D entitlement >=3D 0;

Doesn't this allow setting horizontal entitlement? Which shouldn't be possi=
ble,
only the guest can do it.

> +
> +    s390_change_topology(core, has_socket, socket, has_book, book,
> +                         has_drawer, drawer, has_entitlement, entitlemen=
t,
> +                         has_dedicated, dedicated, errp);
> +}
> +
> +void hmp_set_cpu_topology(Monitor *mon, const QDict *qdict)
> +{
> +    const uint16_t core =3D qdict_get_int(qdict, "core-id");
> +    bool has_socket    =3D qdict_haskey(qdict, "socket-id");
> +    const uint16_t socket =3D qdict_get_try_int(qdict, "socket-id", 0);
> +    bool has_book    =3D qdict_haskey(qdict, "book-id");
> +    const uint16_t book =3D qdict_get_try_int(qdict, "book-id", 0);
> +    bool has_drawer    =3D qdict_haskey(qdict, "drawer-id");
> +    const uint16_t drawer =3D qdict_get_try_int(qdict, "drawer-id", 0);

The names here don't match the definition below, leading to a crash,
because core-id is a mandatory argument.

> +    const char *entitlement =3D qdict_get_try_str(qdict, "entitlement");
> +    bool has_dedicated    =3D qdict_haskey(qdict, "dedicated");
> +    const bool dedicated =3D qdict_get_try_bool(qdict, "dedicated", fals=
e);
> +    Error *local_err =3D NULL;
> +
> +    qmp_set_cpu_topology(core, has_socket, socket, has_book, book,
> +                           has_drawer, drawer, entitlement,
> +                           has_dedicated, dedicated, &local_err);
> +    hmp_handle_error(mon, local_err);
> +}
> diff --git a/hmp-commands.hx b/hmp-commands.hx
> index fbb5daf09b..d8c37808c7 100644
> --- a/hmp-commands.hx
> +++ b/hmp-commands.hx
> @@ -1815,3 +1815,20 @@ SRST
>    Dump the FDT in dtb format to *filename*.
>  ERST
>  #endif
> +
> +#if defined(TARGET_S390X)
> +    {
> +        .name       =3D "set-cpu-topology",
> +        .args_type  =3D "core:l,socket:l?,book:l?,drawer:l?,entitlement:=
s?,dedicated:b?",

Can you use ":O" for the ids? It would allow for some more flexibility.

> +        .params     =3D "core [socket] [book] [drawer] [entitlement] [de=
dicated]",
> +        .help       =3D "Move CPU 'core' to 'socket/book/drawer' "
> +                      "optionally modifies entitlement and dedication",
> +        .cmd        =3D hmp_set_cpu_topology,
> +    },
> +
> +SRST
> +``set-cpu-topology`` *core* *socket* *book* *drawer* *entitlement* *dedi=
cated*
> +  Modify CPU topology for the CPU *core* to move on *socket* *book* *dra=
wer*
> +  with topology attributes *entitlement* *dedicated*.
> +ERST
> +#endif

