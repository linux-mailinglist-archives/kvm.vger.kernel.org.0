Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A2564402B
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 10:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbiLFJtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 04:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiLFJtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 04:49:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F59140AA
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 01:48:20 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B699ZYx003505;
        Tue, 6 Dec 2022 09:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hsM5hb4bHQBZFZZb8SrjZvzWEJC1JLdhxWExqjxlppE=;
 b=Z9CO6uLQnPHwY8djC49+NAzQz7ZxTDrCe0UZMFSwcC0JQJTsQVIRDlhqd+R9ODOiGAnM
 MIpAKMnXemP4dzufFFde2pXK4av6j9gUZJ//zCjMhfvRUvHfpG2J5RD8eWr5xOU4HMow
 n+fs1aQ5FC80WAscFeij7MUd+60T5GjgqcHvBB0VWtRhBcJ3ACUMrkbjI9kw4FsGCEE1
 lXAJr1Ks+FvFcgk90pOPyUEqdyDmN7k8HhxCGvK3gNux5z6XCJlGcXeAbBr1Ex1EqILe
 F+zuEuJ0jhUgEjkcPSvc1cLqtWfdiCNlobxe4ya5w1krbPV0qF2Fr6tKQEErLc4x3vdw jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8gbkycrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 09:48:12 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B69Y8eP022526;
        Tue, 6 Dec 2022 09:48:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8gbkycr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 09:48:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B69FxF9008325;
        Tue, 6 Dec 2022 09:48:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3m9m5y14v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 09:48:09 +0000
Received: from d06av24.portsmouth.uk.ibm.com ([9.149.105.60])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B69m6OE14287494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 09:48:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B86F42045;
        Tue,  6 Dec 2022 09:48:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4394E4204C;
        Tue,  6 Dec 2022 09:48:05 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.52.73])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 09:48:05 +0000 (GMT)
Message-ID: <be6e4c3a2a3b1b4a944ce0558d3e852f78bd9645.camel@linux.ibm.com>
Subject: Re: [PATCH v12 2/7] s390x/cpu topology: reporting the CPU topology
 to the guest
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Tue, 06 Dec 2022 10:48:05 +0100
In-Reply-To: <20221129174206.84882-3-pmorel@linux.ibm.com>
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
         <20221129174206.84882-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T-nde6C_EbN4WBMCYPQTzaW3jLbdXoW9
X-Proofpoint-ORIG-GUID: eH5jY8DbPLIL42H6esfZRKz1AymnTfMU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_05,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 spamscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-11-29 at 18:42 +0100, Pierre Morel wrote:
> The guest uses the STSI instruction to get information on the
> CPU topology.
>=20
> Let us implement the STSI instruction for the basis CPU topology
> level, level 2.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  target/s390x/cpu.h          |  77 +++++++++++++++
>  hw/s390x/s390-virtio-ccw.c  |  12 +--
>  target/s390x/cpu_topology.c | 186 ++++++++++++++++++++++++++++++++++++
>  target/s390x/kvm/kvm.c      |   6 +-
>  target/s390x/meson.build    |   1 +
>  5 files changed, 274 insertions(+), 8 deletions(-)
>  create mode 100644 target/s390x/cpu_topology.c
>=20
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index 7d6d01325b..dd878ac916 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
>=20
[...]

> +/* Configuration topology */
> +typedef struct SysIB_151x {
> +    uint8_t  reserved0[2];
> +    uint16_t length;
> +    uint8_t  mag[S390_TOPOLOGY_MAG];
> +    uint8_t  reserved1;
> +    uint8_t  mnest;
> +    uint32_t reserved2;
> +    char tle[0];

AFAIK [] is preferred over [0].

> +} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) !=3D 16);

[...]
>=20
> +/*
> + * s390_topology_add_cpu:
> + * @topo: pointer to the topology
> + * @cpu : pointer to the new CPU
> + *
> + * The topology pointed by S390CPU, gives us the CPU topology
> + * established by the -smp QEMU aruments.
> + * The core-id is used to calculate the position of the CPU inside
> + * the topology:
> + *  - the socket, container TLE, containing the CPU, we have one socket
> + *    for every num_cores cores.
> + *  - the CPU TLE inside the socket, we have potentionly up to 4 CPU TLE
> + *    in a container TLE with the assumption that all CPU are identical
> + *    with the same polarity and entitlement because we have maximum 256
> + *    CPUs and each TLE can hold up to 64 identical CPUs.
> + *  - the bit in the 64 bit CPU TLE core mask
> + */
> +static void s390_topology_add_cpu(S390Topology *topo, S390CPU *cpu)
> +{
> +    int core_id =3D cpu->env.core_id;
> +    int bit, origin;
> +    int socket_id;
> +
> +    cpu->machine_data =3D topo;
> +    socket_id =3D core_id / topo->num_cores;
> +    /*
> +     * At the core level, each CPU is represented by a bit in a 64bit
> +     * uint64_t which represent the presence of a CPU.
> +     * The firmware assume that all CPU in a CPU TLE have the same
> +     * type, polarization and are all dedicated or shared.
> +     * In that case the origin variable represents the offset of the fir=
st
> +     * CPU in the CPU container.
> +     * More than 64 CPUs per socket are represented in several CPU conta=
iners
> +     * inside the socket container.
> +     * The only reason to have several S390TopologyCores inside a socket=
 is
> +     * to have more than 64 CPUs.
> +     * In that case the origin variable represents the offset of the fir=
st CPU
> +     * in the CPU container. More than 64 CPUs per socket are represente=
d in
> +     * several CPU containers inside the socket container.
> +     */

This comment still contains redundant sentences.
Did you have a look at my suggestion in v10 patch 1?

> +    bit =3D core_id;
> +    origin =3D bit / 64;
> +    bit %=3D 64;
> +    bit =3D 63 - bit;
> +
> +    topo->socket[socket_id].active_count++;
> +    set_bit(bit, &topo->socket[socket_id].mask[origin]);
> +}
> +
> +/*
> + * s390_prepare_topology:
> + * @s390ms : pointer to the S390CcwMachite State
> + *
> + * Calls s390_topology_add_cpu to organize the topology
> + * inside the topology device before writing the SYSIB.
> + *
> + * The topology is currently fixed on boot and do not change

does not change

> + * even on migration.
> + */
> +static void s390_prepare_topology(S390CcwMachineState *s390ms)
> +{
> +    const MachineState *ms =3D MACHINE(s390ms);
> +    static bool done;
> +    int i;
> +
> +    if (done) {
> +        return;
> +    }
> +
> +    for (i =3D 0; i < ms->possible_cpus->len; i++) {
> +        if (ms->possible_cpus->cpus[i].cpu) {
> +            s390_topology_add_cpu(S390_CPU_TOPOLOGY(s390ms->topology),
> +                                  S390_CPU(ms->possible_cpus->cpus[i].cp=
u));
> +        }
> +    }
> +
> +    done =3D true;
> +}
> +
>=20
[...]

