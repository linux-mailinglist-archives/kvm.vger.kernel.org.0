Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CC666BF4E
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 14:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjAPNPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 08:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjAPNOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 08:14:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF26423C5E
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 05:11:44 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GCpMkm019339;
        Mon, 16 Jan 2023 13:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zb+leUfWeLfjVKf/1vrXktEd/nb28mXCIoYaNpPH9y0=;
 b=LmIFJnMTgYHZ3BnbIFoW12YWCxgCzZFyGHiHCZVm3yKjfxglI9xFG8Lsmu5ylHWnprkb
 GzZFn5PxCpG4gW82J/sbUi49EhaHeAkpl6bRe1HXJJotpeq5oMvv5cMr0vNkWoaCqSvs
 RDT6JX15t0tMK7Za2x6rttzfuS5+yrn+prVVXP+rotpF1JG9PCgz35nbYgvts1bP31hW
 VweRxcfai7UhVlzS0UqkiPVvpyUG6AxBqWSw4m4DzXj7HvijTkgtD/PlDqUP/lK5dHdU
 8HbND8ysbsB9/E2Ay9xhWdfH65mSYfkmXNOkJ5BBks+eqYble0FtY0wnvf7FOZiEmsTQ EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n56y20erw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 13:11:35 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GCs2Lu012309;
        Mon, 16 Jan 2023 13:11:34 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n56y20er9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 13:11:34 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30FGnq3F028466;
        Mon, 16 Jan 2023 13:11:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n3m16hsdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 13:11:31 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GDBSPl44171652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 13:11:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1570320043;
        Mon, 16 Jan 2023 13:11:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AB832004D;
        Mon, 16 Jan 2023 13:11:27 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.176.214])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 13:11:27 +0000 (GMT)
Message-ID: <270af9ebb128c7fe576895b2e204d901dae77c5e.camel@linux.ibm.com>
Subject: Re: [PATCH v14 03/11] target/s390x/cpu topology: handle STSI(15)
 and build the SYSIB
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 16 Jan 2023 14:11:27 +0100
In-Reply-To: <20230105145313.168489-4-pmorel@linux.ibm.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
         <20230105145313.168489-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sceBu--vecAeHtgYRLMIHAvTeWJLikkf
X-Proofpoint-GUID: ngcwY31qFPcBXvjMPVKate_W8r5plJoS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_10,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
> On interception of STSI(15.1.x) the System Information Block
> (SYSIB) is built from the list of pre-ordered topology entries.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  include/hw/s390x/cpu-topology.h |   3 +
>  include/hw/s390x/sclp.h         |   1 +
>  target/s390x/cpu.h              |  78 ++++++++++++++++++
>  target/s390x/kvm/cpu_topology.c | 136 ++++++++++++++++++++++++++++++++
>  target/s390x/kvm/kvm.c          |   5 +-
>  target/s390x/kvm/meson.build    |   3 +-
>  6 files changed, 224 insertions(+), 2 deletions(-)
>  create mode 100644 target/s390x/kvm/cpu_topology.c
>=20
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topol=
ogy.h
> index b3fd752d8d..9571aa70e5 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -41,6 +41,9 @@ typedef union s390_topology_id {
>      };
>  } s390_topology_id;
>  #define TOPO_CPU_MASK       0x000000000000003fUL
> +#define TOPO_SOCKET_MASK    0x0000ffffff000000UL
> +#define TOPO_BOOK_MASK      0x0000ffff00000000UL
> +#define TOPO_DRAWER_MASK    0x0000ff0000000000UL
> =20
>  typedef struct S390TopologyEntry {
>      s390_topology_id id;
> diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
> index d3ade40a5a..712fd68123 100644
> --- a/include/hw/s390x/sclp.h
> +++ b/include/hw/s390x/sclp.h
> @@ -112,6 +112,7 @@ typedef struct CPUEntry {
>  } QEMU_PACKED CPUEntry;
> =20
>  #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
> +#define SCLP_READ_SCP_INFO_MNEST                2
>  typedef struct ReadInfo {
>      SCCBHeader h;
>      uint16_t rnmax;
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index 39ea63a416..78988048dd 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -561,6 +561,25 @@ typedef struct SysIB_322 {
>  } SysIB_322;
>  QEMU_BUILD_BUG_ON(sizeof(SysIB_322) !=3D 4096);
> =20
> +#define S390_TOPOLOGY_MAG  6
> +#define S390_TOPOLOGY_MAG6 0
> +#define S390_TOPOLOGY_MAG5 1
> +#define S390_TOPOLOGY_MAG4 2
> +#define S390_TOPOLOGY_MAG3 3
> +#define S390_TOPOLOGY_MAG2 4
> +#define S390_TOPOLOGY_MAG1 5
> +/* Configuration topology */
> +typedef struct SysIB_151x {
> +    uint8_t  reserved0[2];
> +    uint16_t length;
> +    uint8_t  mag[S390_TOPOLOGY_MAG];
> +    uint8_t  reserved1;
> +    uint8_t  mnest;
> +    uint32_t reserved2;
> +    char tle[];
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) !=3D 16);
> +
>  typedef union SysIB {
>      SysIB_111 sysib_111;
>      SysIB_121 sysib_121;
> @@ -568,9 +587,68 @@ typedef union SysIB {
>      SysIB_221 sysib_221;
>      SysIB_222 sysib_222;
>      SysIB_322 sysib_322;
> +    SysIB_151x sysib_151x;
>  } SysIB;
>  QEMU_BUILD_BUG_ON(sizeof(SysIB) !=3D 4096);
> =20
> +/*
> + * CPU Topology List provided by STSI with fc=3D15 provides a list
> + * of two different Topology List Entries (TLE) types to specify
> + * the topology hierarchy.
> + *
> + * - Container Topology List Entry
> + *   Defines a container to contain other Topology List Entries
> + *   of any type, nested containers or CPU.
> + * - CPU Topology List Entry
> + *   Specifies the CPUs position, type, entitlement and polarization
> + *   of the CPUs contained in the last Container TLE.
> + *
> + * There can be theoretically up to five levels of containers, QEMU
> + * uses only one level, the socket level.
> + *
> + * A container of with a nesting level (NL) greater than 1 can only
> + * contain another container of nesting level NL-1.
> + *
> + * A container of nesting level 1 (socket), contains as many CPU TLE
> + * as needed to describe the position and qualities of all CPUs inside
> + * the container.
> + * The qualities of a CPU are polarization, entitlement and type.
> + *
> + * The CPU TLE defines the position of the CPUs of identical qualities
> + * using a 64bits mask which first bit has its offset defined by
> + * the CPU address orgin field of the CPU TLE like in:
> + * CPU address =3D origin * 64 + bit position within the mask
> + *
> + */
> +/* Container type Topology List Entry */
> +/* Container type Topology List Entry */
> +typedef struct SysIBTl_container {
> +        uint8_t nl;
> +        uint8_t reserved[6];
> +        uint8_t id;
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) !=3D 8);
> +
> +/* CPU type Topology List Entry */
> +typedef struct SysIBTl_cpu {
> +        uint8_t nl;
> +        uint8_t reserved0[3];
> +        uint8_t reserved1:5;
> +        uint8_t dedicated:1;
> +        uint8_t polarity:2;
> +        uint8_t type;
> +        uint16_t origin;
> +        uint64_t mask;
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_cpu;
> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) !=3D 16);
> +
> +/* Max size of a SYSIB structure is when all CPU are alone in a containe=
r */
> +#define S390_TOPOLOGY_SYSIB_SIZE (sizeof(SysIB_151x) +                  =
       \
> +                                  S390_MAX_CPUS * (sizeof(SysIBTl_contai=
ner) + \
> +                                                   sizeof(SysIBTl_cpu)))

I don't think this is accurate anymore, if you have drawers and books.
In that case you could have 3 containers per 1 cpu.
You could also use the maxcpus number at runtime instead of S390_MAX_CPUS.
I also think you could do sizeof(SysIB) + sizeof(SysIBTl_cpu) if you check
if the sysib overflows 4k while building it.

> +
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
> +
>  /* MMU defines */
>  #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin       =
      */
>  #define ASCE_SUBSPACE         0x200       /* subspace group control     =
      */
> diff --git a/target/s390x/kvm/cpu_topology.c b/target/s390x/kvm/cpu_topol=
ogy.c
> new file mode 100644
> index 0000000000..3831a3264c
> --- /dev/null
> +++ b/target/s390x/kvm/cpu_topology.c
> @@ -0,0 +1,136 @@
> +/*
> + * QEMU S390x CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (a=
t
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +#include "qemu/osdep.h"
> +#include "cpu.h"
> +#include "hw/s390x/pv.h"
> +#include "hw/sysbus.h"
> +#include "hw/s390x/sclp.h"
> +#include "hw/s390x/cpu-topology.h"
> +
> +static char *fill_container(char *p, int level, int id)
> +{
> +    SysIBTl_container *tle =3D (SysIBTl_container *)p;
> +
> +    tle->nl =3D level;
> +    tle->id =3D id;
> +    return p + sizeof(*tle);
> +}
> +
> +static char *fill_tle_cpu(char *p, S390TopologyEntry *entry)
> +{
> +    SysIBTl_cpu *tle =3D (SysIBTl_cpu *)p;
> +    s390_topology_id topology_id =3D entry->id;
> +
> +    tle->nl =3D 0;
> +    tle->dedicated =3D topology_id.d;
> +    tle->polarity =3D topology_id.p;
> +    tle->type =3D topology_id.type;
> +    tle->origin =3D topology_id.origin;

You need to multiply that value by 64, no?
And convert it to BE.

> +    tle->mask =3D cpu_to_be64(entry->mask);
> +    return p + sizeof(*tle);
> +}
> +
> +static char *s390_top_set_level(char *p, int level)
> +{
> +    S390TopologyEntry *entry;
> +    uint64_t last_socket =3D -1UL;
> +    uint64_t last_book =3D -1UL;
> +    uint64_t last_drawer =3D -1UL;

-1UL looks funny to me, but there is nothing wrong with it.
But I don't see a reason not to use int and initialize it with -1.

> +    int drawer_cnt =3D 0;
> +    int book_cnt =3D 0;
> +    int socket_cnt =3D 0;
> +
> +    QTAILQ_FOREACH(entry, &s390_topology.list, next) {
> +
> +        if (level > 3 && (last_drawer !=3D entry->id.drawer)) {
> +            book_cnt =3D 0;
> +            socket_cnt =3D 0;
> +            p =3D fill_container(p, 3, drawer_cnt++);
> +            last_drawer =3D entry->id.id & TOPO_DRAWER_MASK;
> +            p =3D fill_container(p, 2, book_cnt++);
> +            last_book =3D entry->id.id & TOPO_BOOK_MASK;
> +            p =3D fill_container(p, 1, socket_cnt++);
> +            last_socket =3D entry->id.id & TOPO_SOCKET_MASK;
> +            p =3D fill_tle_cpu(p, entry);
> +        } else if (level > 2 && (last_book !=3D
> +                                 (entry->id.id & TOPO_BOOK_MASK))) {
> +            socket_cnt =3D 0;
> +            p =3D fill_container(p, 2, book_cnt++);
> +            last_book =3D entry->id.id & TOPO_BOOK_MASK;
> +            p =3D fill_container(p, 1, socket_cnt++);
> +            last_socket =3D entry->id.id & TOPO_SOCKET_MASK;
> +            p =3D fill_tle_cpu(p, entry);
> +        } else if (last_socket !=3D (entry->id.id & TOPO_SOCKET_MASK)) {
> +            p =3D fill_container(p, 1, socket_cnt++);
> +            last_socket =3D entry->id.id & TOPO_SOCKET_MASK;
> +            p =3D fill_tle_cpu(p, entry);
> +        } else {
> +            p =3D fill_tle_cpu(p, entry);
> +        }
> +    }
> +
> +    return p;
> +}

I think you can do this a bit more readable and reduce redundancy.
Pseudo code:

foreach entry:
	bool drawer_change =3D last_drawer !=3D current_drawer
	bool book_change =3D drawer_change || last_book !=3D current_book
	bool socket_change =3D book_change || last_socket !=3D current_socket

	if (level > 3 && drawer_change)
		reset book id
		fill drawer container
		drawer id++
	if (level > 2 && book_change)
		reset socket id
		fill book container
		book id++
	if (socket_change)
		fill socket container
		socket id++
	fill cpu entry

	update last_drawer, _book, _socket

You can also check after after every fill if the buffer has been overflowed=
,
that is if the function wrote more than sizeof(SysIB) - sizeof(SysIB_151x) =
bytes.
Or you check it once at the end if you increase the size of the buffer a bi=
t.
Then you don't need to allocate the absolute maximum.

I think you could also use global ids for the containers.
So directly use the drawer id from the entry,
use (drawer id * smp.books) + book id, and so on.
If you update last_* after setting *_changed you don't need to maintain ids=
,
you can just use last_*.


[...]
