Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9C56E802B
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 19:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjDSRPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 13:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjDSRPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 13:15:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B163580
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 10:15:52 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JH50T7019706;
        Wed, 19 Apr 2023 17:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=4gV0GoQLrJl2ZFnnMEFd9bbiphossF2Dno9N80IH9ew=;
 b=Z9wNeR8J4d6yyJeliPq2VEUrhlBACE4B+PTvZHzVXoHAhSLChQUki9Fc2OWdix6lvf6I
 ZZI8iQ2HqVmapAGcgOPHApZDT9Bi9UdDzxYjgjHJjE0Jg8XXEli8Uj/FMuZsU7MaDiaf
 IWdFuhSJr8vRfcHGldIhhB5zs/fWG93fXSHm77/gVOXEU4J0Ny6HG3IiEWmoZle5FJtl
 Forthr+9zWpYKqOabQhRPPIPnLi/HZHsQl2bGfbC8rPzLxPreqG94y5bL/CQ53Kmr88x
 TzlvNRkQxnzPiXToTrbsl37rF71/ByM8zkw9FGO8rueIlOrY4rNI7rWXF+rrJa1ZGfKp ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1pkxq6hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 17:15:36 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33JH17BG029592;
        Wed, 19 Apr 2023 17:15:35 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1pkxq6fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 17:15:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33J5wYPD009299;
        Wed, 19 Apr 2023 17:15:32 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6jvn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 17:15:32 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33JHFR2f64356828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 17:15:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08DC220043;
        Wed, 19 Apr 2023 17:15:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A18D520040;
        Wed, 19 Apr 2023 17:15:26 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.152.224.238])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 19 Apr 2023 17:15:26 +0000 (GMT)
Message-ID: <bf769e0a6dfec2869b03d81ad10070fb4d5b3946.camel@linux.ibm.com>
Subject: Re: [PATCH v19 02/21] s390x/cpu topology: add topology entries on
 CPU hotplug
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     =?ISO-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com
Date:   Wed, 19 Apr 2023 19:15:26 +0200
In-Reply-To: <7affffef-8d04-ac9f-0920-f765d362d60d@kaod.org>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
         <20230403162905.17703-3-pmorel@linux.ibm.com>
         <7affffef-8d04-ac9f-0920-f765d362d60d@kaod.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V1iij10uQf0Ty6gOu3ekbOZpGx3h1T7E
X-Proofpoint-ORIG-GUID: OiPKC7Sfvd6BZaUboEAG_Ml6z92ojTeT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_11,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190153
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-04 at 09:31 +0200, C=C3=A9dric Le Goater wrote:
> On 4/3/23 18:28, Pierre Morel wrote:
> > The topology information are attributes of the CPU and are
> > specified during the CPU device creation.
> >=20
> > On hot plug we:
> > - calculate the default values for the topology for drawers,
> >    books and sockets in the case they are not specified.
> > - verify the CPU attributes
> > - check that we have still room on the desired socket
> >=20
> > The possibility to insert a CPU in a mask is dependent on the
> > number of cores allowed in a socket, a book or a drawer, the
> > checking is done during the hot plug of the CPU to have an
> > immediate answer.
> >=20
> > If the complete topology is not specified, the core is added
> > in the physical topology based on its core ID and it gets
> > defaults values for the modifier attributes.
> >=20
> > This way, starting QEMU without specifying the topology can
> > still get some advantage of the CPU topology.
> >=20
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >   MAINTAINERS                        |   1 +
> >   include/hw/s390x/cpu-topology.h    |  44 +++++
> >   include/hw/s390x/s390-virtio-ccw.h |   1 +
> >   hw/s390x/cpu-topology.c            | 282 ++++++++++++++++++++++++++++=
+
> >   hw/s390x/s390-virtio-ccw.c         |  22 ++-
> >   hw/s390x/meson.build               |   1 +
> >   6 files changed, 349 insertions(+), 2 deletions(-)
> >   create mode 100644 hw/s390x/cpu-topology.c

[...]

> > +
> > +/**
> > + * s390_socket_nb:
> > + * @cpu: s390x CPU
> > + *
> > + * Returns the socket number used inside the cores_per_socket array
> > + * for a cpu.
> > + */
> > +int s390_socket_nb(S390CPU *cpu)
>=20
> s390_socket_nb() doesn't seem to be used anywhere else than in
> hw/s390x/cpu-topology.c. It should be static.
>=20
>=20
> > +{
> > +    return (cpu->env.drawer_id * s390_topology.smp->books + cpu->env.b=
ook_id) *
> > +           s390_topology.smp->sockets + cpu->env.socket_id;
> > +}

[...]

> > +/**
> > + * s390_topology_add_core_to_socket:
> > + * @cpu: the new S390CPU to insert in the topology structure
> > + * @drawer_id: new drawer_id
> > + * @book_id: new book_id
> > + * @socket_id: new socket_id
> > + * @creation: if is true the CPU is a new CPU and there is no old sock=
et
> > + *            to handle.
> > + *            if is false, this is a moving the CPU and old socket cou=
nt
> > + *            must be decremented.
> > + * @errp: the error pointer
> > + *
> > + */
> > +static void s390_topology_add_core_to_socket(S390CPU *cpu, int drawer_=
id,
> > +                                             int book_id, int socket_i=
d,
> > +                                             bool creation, Error **er=
rp)
> > +{
>=20
> Since this routine is called twice, in s390_topology_setup_cpu() for
> creation, and in s390_change_topology() for socket migration, we could
> duplicate the code in two distinct routines.
>=20
> I think this would simplify a bit each code path and avoid the 'creation'
> parameter which is confusing.
>=20
>=20
> > +    int old_socket_entry =3D s390_socket_nb(cpu);
> > +    int new_socket_entry;
> > +
> > +    if (creation) {
> > +        new_socket_entry =3D old_socket_entry;
> > +    } else {
> > +        new_socket_entry =3D (drawer_id * s390_topology.smp->books + b=
ook_id) *
> > +                            s390_topology.smp->sockets + socket_id;
>=20
> A helper common routine that s390_socket_nb() could use also would be a p=
lus.

An alternative to consider would be to define a

struct topology_pos {
    int socket;
    int book;
    int drawer;
};

or similar so you can do

old_socket_entry =3D s390_socket_nb(cpu->env.topology_pos, smp);

struct topology_pos topology_pos =3D { socket_id, book_id, drawer_id };
new_socket_entry =3D s390_socket_nb(topology_pos, smp);

It might also make sense to pass a topology_pos around instead of three ids=
,
since that is quite common.

>=20
> > +    }
> > +
> > +    /* Check for space on new socket */
> > +    if ((new_socket_entry !=3D old_socket_entry) &&
> > +        (s390_topology.cores_per_socket[new_socket_entry] >=3D
> > +         s390_topology.smp->cores)) {
> > +        error_setg(errp, "No more space on this socket");
> > +        return;
> > +    }
> > +
> > +    /* Update the count of cores in sockets */
> > +    s390_topology.cores_per_socket[new_socket_entry] +=3D 1;
> > +    if (!creation) {
> > +        s390_topology.cores_per_socket[old_socket_entry] -=3D 1;
> > +    }
> > +}

[...]

