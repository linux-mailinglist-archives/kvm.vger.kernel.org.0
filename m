Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1096FB6D7
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 21:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbjEHTmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 15:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjEHTmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 15:42:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B1E4209
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 12:42:45 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 348J9YiI026580;
        Mon, 8 May 2023 19:42:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/e5/pmzrF3cRemUxy5W3bLRVFYWLNIF21rRD2xLHOE4=;
 b=fmCIeN1CoXq+9cd0h/hkIVgtE+5mkvuPCUrvMnOMtfpLyWVyE3zJFgvcr5axGTCfQsMu
 /WfrQTO6WnPZ4+l22SF5PXdnYtCo7FMB80VEYG7q7G9zAEDa/fbjU75Z+uZSyFVSu/Yc
 HOVjnWCcWGkKEr3LDh+/ax4yuhHvkIrwj+NgFHwCRLKvHybjhpc+rtNcyOBkRtBTBJlK
 q4O4fDcVx/AntVsxGs2XIml05yTKdD9eF13XRkWGUC6g0n/DMb+vwQ6Q1DuxWkKONZui
 5uZRh/BZjqmw2G7Lz6/hAFY7nbHnuuumkE5wGLOPq/f48G0mFKBLnO7wjZ3RB4fbOCoq bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf6mesw0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 19:42:23 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 348JWrNR015835;
        Mon, 8 May 2023 19:42:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf6mesvyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 19:42:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3483lTsj002573;
        Mon, 8 May 2023 19:42:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qdeh6ha42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 19:42:20 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 348JgEVt19464794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 May 2023 19:42:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C58692004D;
        Mon,  8 May 2023 19:42:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC4F520040;
        Mon,  8 May 2023 19:42:13 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.71.193])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  8 May 2023 19:42:13 +0000 (GMT)
Message-ID: <e1301b4f488df0d84617685a6ee29c4c916c8068.camel@linux.ibm.com>
Subject: Re: [PATCH v20 08/21] qapi/s390x/cpu topology: set-cpu-topology qmp
 command
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 08 May 2023 21:42:13 +0200
In-Reply-To: <20230425161456.21031-9-pmorel@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
         <20230425161456.21031-9-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n1vtpEhW3Sq9avLnCid90WT2jvlUM2n8
X-Proofpoint-GUID: J6hm0gqISihF0rK5rH1Vv7YvpFnyeR5j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_13,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305080126
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
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

Logic is sound, minor stuff below.

> ---
>  qapi/machine-target.json |  37 +++++++++++
>  hw/s390x/cpu-topology.c  | 136 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 173 insertions(+)
>=20
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 42a6a40333..3b7a0b77f4 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -4,6 +4,8 @@
>  # This work is licensed under the terms of the GNU GPL, version 2 or lat=
er.
>  # See the COPYING file in the top-level directory.
> =20
> +{ 'include': 'machine-common.json' }
> +
>  ##
>  # @CpuModelInfo:
>  #
> @@ -354,3 +356,38 @@
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
> +# Since: 8.1
> +##
> +{ 'command': 'set-cpu-topology',
> +  'data': {
> +      'core-id': 'uint16',
> +      '*socket-id': 'uint16',
> +      '*book-id': 'uint16',
> +      '*drawer-id': 'uint16',
> +      '*entitlement': 'CpuS390Entitlement',
> +      '*dedicated': 'bool'
> +  },
> +  'features': [ 'unstable' ],
> +  'if': { 'all': [ 'TARGET_S390X' , 'CONFIG_KVM' ] }
> +}
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index d9cd3dc3ce..e5fb976594 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -16,6 +16,7 @@
>  #include "target/s390x/cpu.h"
>  #include "hw/s390x/s390-virtio-ccw.h"
>  #include "hw/s390x/cpu-topology.h"
> +#include "qapi/qapi-commands-machine-target.h"
> =20
>  /*
>   * s390_topology is used to keep the topology information.
> @@ -261,6 +262,27 @@ static bool s390_topology_check(uint16_t socket_id, =
uint16_t book_id,
>      return true;
>  }
> =20
> +/**
> + * s390_topology_need_report
> + * @cpu: Current cpu
> + * @drawer_id: future drawer ID
> + * @book_id: future book ID
> + * @socket_id: future socket ID

Entitlement and dedicated are missing here.

> + *
> + * A modified topology change report is needed if the topology
> + * tree or the topology attributes change.
> + */
> +static int s390_topology_need_report(S390CPU *cpu, int drawer_id,

I'd prefer a bool return type.

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
> @@ -330,3 +352,117 @@ void s390_topology_setup_cpu(MachineState *ms, S390=
CPU *cpu, Error **errp)
>      /* topology tree is reflected in props */
>      s390_update_cpu_props(ms, cpu);
>  }
> +
> +static void s390_change_topology(uint16_t core_id,
> +                                 bool has_socket_id, uint16_t socket_id,
> +                                 bool has_book_id, uint16_t book_id,
> +                                 bool has_drawer_id, uint16_t drawer_id,
> +                                 bool has_entitlement, uint16_t entitlem=
ent,

I would keep the enum type for entitlement.

> +                                 bool has_dedicated, bool dedicated,
> +                                 Error **errp)
> +{
> +    MachineState *ms =3D current_machine;
> +    int old_socket_entry;
> +    int new_socket_entry;
> +    int report_needed;
> +    S390CPU *cpu;
> +    ERRP_GUARD();
> +
> +    if (core_id >=3D ms->smp.max_cpus) {
> +        error_setg(errp, "Core-id %d out of range!", core_id);
> +        return;
> +    }
> +
> +    cpu =3D (S390CPU *)ms->possible_cpus->cpus[core_id].cpu;

You can replace this with

       cpu =3D s390_cpu_addr2state(core_id);

and get rid of the if above that checks for out of range.

> +    if (!cpu) {
> +        error_setg(errp, "Core-id %d does not exist!", core_id);
> +        return;
> +    }
> +
> +    /* Get attributes not provided from cpu and verify the new topology =
*/
> +    if (!has_socket_id) {
> +        socket_id =3D cpu->env.socket_id;
> +    }
> +    if (!has_book_id) {
> +        book_id =3D cpu->env.book_id;
> +    }
> +    if (!has_drawer_id) {
> +        drawer_id =3D cpu->env.drawer_id;
> +    }
> +    if (!has_dedicated) {
> +        dedicated =3D cpu->env.dedicated;
> +    }
> +
> +    /*
> +     * When the user specifies the entitlement as 'auto' on the command =
line,
> +     * qemu will set the entitlement as:
> +     * Medium when the CPU is not dedicated.
> +     * High when dedicated is true.
> +     */
> +    if (!has_entitlement || (entitlement =3D=3D S390_CPU_ENTITLEMENT_AUT=
O)) {
> +        if (dedicated) {
> +            entitlement =3D S390_CPU_ENTITLEMENT_HIGH;
> +        } else {
> +            entitlement =3D S390_CPU_ENTITLEMENT_MEDIUM;
> +        }
> +    }
> +
> +    if (!s390_topology_check(socket_id, book_id, drawer_id,
> +                             entitlement, dedicated, errp))
> +        return;
> +
> +    /* Check for space on new socket */
> +    old_socket_entry =3D s390_socket_nb(cpu);
> +    new_socket_entry =3D __s390_socket_nb(drawer_id, book_id, socket_id)=
;
> +
> +    if (new_socket_entry !=3D old_socket_entry) {
> +        if (s390_topology.cores_per_socket[new_socket_entry] >=3D
> +            s390_topology.smp->cores) {
> +            error_setg(errp, "No more space on this socket");
> +            return;
> +        }
> +        /* Update the count of cores in sockets */
> +        s390_topology.cores_per_socket[new_socket_entry] +=3D 1;
> +        s390_topology.cores_per_socket[old_socket_entry] -=3D 1;
> +    }
> +
> +    /* Check if we will need to report the modified topology */
> +    report_needed =3D s390_topology_need_report(cpu, drawer_id, book_id,
> +                                              socket_id, entitlement,
> +                                              dedicated);
> +
> +    /* All checks done, report new topology into the vCPU */
> +    cpu->env.drawer_id =3D drawer_id;
> +    cpu->env.book_id =3D book_id;
> +    cpu->env.socket_id =3D socket_id;
> +    cpu->env.dedicated =3D dedicated;
> +    cpu->env.entitlement =3D entitlement;
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
> +                         bool has_entitlement, CpuS390Entitlement entitl=
ement,
> +                         bool has_dedicated, bool dedicated,
> +                         Error **errp)
> +{
> +    ERRP_GUARD();
> +
> +    if (!s390_has_topology()) {
> +        error_setg(errp, "This machine doesn't support topology");
> +        return;
> +    }
> +
> +    s390_change_topology(core, has_socket, socket, has_book, book,
> +                         has_drawer, drawer, has_entitlement, entitlemen=
t,
> +                         has_dedicated, dedicated, errp);
> +}

