Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B516EDF49
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 11:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbjDYJcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 05:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbjDYJb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 05:31:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947B346B0
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 02:31:57 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33P9VYLp007483;
        Tue, 25 Apr 2023 09:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=yiWGhxS/cgXVl9G3omsaGmF+kN2Fj4x5nFZbOJlqUKg=;
 b=A/RLztxU8INDUC0adzoOPt8GP9Jwwhx5112QQqTNzbgo+4LQ4Mb+6xIdmGwAQhg5QoEl
 DPsMEjRUaeIP1SHFyjNqC43bqPuie0MJ1bjXmdFAXRfhZEAZlZ/6qEmtDxvk6r375VeO
 nMpAbWU9lNDDQa1tu/zEDrBRzyOIE4avhaB2ZjcePatRe7uoUapU/TmjBGTKPJmcjAOh
 TM2yafwsUZwr3H5mPNl/qb69HZHDyqCkSjypVvjNi1AiTjDmbEB1ukWkh8MIxXv40+aK
 F/UfZ3Ov6eWiRMQyP/3wVBaXgnSeEqUMaEveh0gU5h9tscGn5qehNKqOPZZbe7x1jAQk Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6axgb2xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 09:31:49 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33P9Vmpn009117;
        Tue, 25 Apr 2023 09:31:48 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6axgb2t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 09:31:47 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33ONbbff026564;
        Tue, 25 Apr 2023 09:27:18 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47771n3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 09:27:18 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33P9RCr420185720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 09:27:12 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C8B22004B;
        Tue, 25 Apr 2023 09:27:12 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE24E20043;
        Tue, 25 Apr 2023 09:27:11 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.152.224.238])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Apr 2023 09:27:11 +0000 (GMT)
Message-ID: <92a76767620a8e4bb12b7164b271d7172545cd0b.camel@linux.ibm.com>
Subject: Re: [PATCH v19 02/21] s390x/cpu topology: add topology entries on
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
Date:   Tue, 25 Apr 2023 11:27:11 +0200
In-Reply-To: <9c2cb730-d307-f344-35e8-82017681816a@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
         <20230403162905.17703-3-pmorel@linux.ibm.com>
         <66d9ba0e9904f035326aca609a767976b94547cf.camel@linux.ibm.com>
         <4ddd3177-58a8-c9f0-a9a8-ee71baf0511b@linux.ibm.com>
         <60aafc95dd0293ba8d5b4dbdc59fcda5e6c64f3e.camel@linux.ibm.com>
         <9c2cb730-d307-f344-35e8-82017681816a@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K1pdCph8v8QayANu9f555rHaUMH8Acps
X-Proofpoint-ORIG-GUID: fLbNm37JvOCwELOJGZILaZBncHPRGdj-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_03,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304250068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-25 at 10:45 +0200, Pierre Morel wrote:
> On 4/24/23 17:32, Nina Schoetterl-Glausch wrote:
> > On Fri, 2023-04-21 at 12:20 +0200, Pierre Morel wrote:
> > > > On 4/20/23 10:59, Nina Schoetterl-Glausch wrote:
> > > > > > On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
> [..]
> > > > In the next version with entitlement being an enum it is right.
> > > >=20
> > > > However, deleting this means that the default value for entitlement
> > > > depends on dedication.
> > > >=20
> > > > If we have only low, medium, high and default for entitlement is me=
dium.
> > > >=20
> > > > If the user specifies the dedication true without specifying entitl=
ement
> > > > we could force entitlement to high.
> > > >=20
> > > > But we can not distinguish this from the user specifying dedication=
 true
> > > > with a medium entitlement, which is wrong.
> > > >=20
> > > > So three solution:
> > > >=20
> > > > 1) We ignore what the user say if dedication is specified as true
> > > >=20
> > > > 2) We specify that both dedication and entitlement must be specifie=
d if
> > > > dedication is true
> > > >=20
> > > > 3) We set an impossible default to distinguish default from medium
> > > > entitlement
> > > >=20
> > > >=20
> > > > For me the solution 3 is the best one, it is more flexible for the =
user.
> > > >=20
> > > > Solution 1 is obviously bad.
> > > >=20
> > > > Solution 2 forces the user to specify entitlement high and only hig=
h if
> > > > it specifies dedication true.
> > > >=20
> > > > AFAIU, you prefer the solution 2, forcing user to specify both
> > > > dedication and entitlement to suppress a default value in the enum.
> > > > Why is it bad to have a default value in the enum that we do not us=
e to
> > > > specify that the value must be calculated?
> > Yes, I'd prefer solution 2. I don't like adapting the internal state wh=
ere only
> > the three values make sense for the user interface.
> > It also keeps things simple and requires less code.
> > I also don't think it's a bad thing for the user, as it's not a thing d=
one manually often.
> > I'm also not a fan of a value being implicitly being changed even thoug=
h it doesn't look
> > like it from the command.
> >=20
> > However, what I really don't like is the additional state and naming it=
 "horizontal",
>=20
>=20
> No problem to use another name like "auto" as you propose later.
>=20
>=20
> > not so much the adjustment if dedication is switched to true without an=
 entitlement given.
> > For the monitor command there is no problem, you currently have:
>=20
>=20
> That is clear, the has_xxx does the job.
>=20
> [..]
>=20
>=20
> > So you can just set it if (!has_entitlement).
> > There is also ways to set the value for cpus defined on the command lin=
e, e.g.:
>=20
>=20
> Yes, thanks, I already said I find your proposition to use a=20
> DEFINE_PROP_CPUS390ENTITLEMENT good and will use it.
>=20
>=20
> >=20
> > diff --git a/include/hw/qdev-properties-system.h b/include/hw/qdev-prop=
erties-system.h
> > index 0ac327ae60..41a605c5a7 100644
> > --- a/include/hw/qdev-properties-system.h
> > +++ b/include/hw/qdev-properties-system.h
> > @@ -22,6 +22,7 @@ extern const PropertyInfo qdev_prop_audiodev;
> >   extern const PropertyInfo qdev_prop_off_auto_pcibar;
> >   extern const PropertyInfo qdev_prop_pcie_link_speed;
> >   extern const PropertyInfo qdev_prop_pcie_link_width;
> > +extern const PropertyInfo qdev_prop_cpus390entitlement;
> >  =20
> >   #define DEFINE_PROP_PCI_DEVFN(_n, _s, _f, _d)                   \
> >       DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_pci_devfn, int32_t)
> > @@ -73,5 +74,8 @@ extern const PropertyInfo qdev_prop_pcie_link_width;
> >   #define DEFINE_PROP_UUID_NODEFAULT(_name, _state, _field) \
> >       DEFINE_PROP(_name, _state, _field, qdev_prop_uuid, QemuUUID)
> >  =20
> > +#define DEFINE_PROP_CPUS390ENTITLEMENT(_n, _s, _f) \
> > +    DEFINE_PROP(_n, _s, _f, qdev_prop_cpus390entitlement, int)
> > +
> >  =20
> >   #endif
> > diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> > index 54541d2230..01308e0b94 100644
> > --- a/target/s390x/cpu.h
> > +++ b/target/s390x/cpu.h
> > @@ -135,7 +135,7 @@ struct CPUArchState {
> >       int32_t book_id;
> >       int32_t drawer_id;
> >       bool dedicated;
> > -    uint8_t entitlement;        /* Used only for vertical polarization=
 */
> > +    int entitlement;        /* Used only for vertical polarization */
>=20
>=20
> Isn't it better to use:
>=20
> +=C2=A0=C2=A0=C2=A0 CpuS390Entitlement entitlement; /* Used only for vert=
ical=20
> polarization */
>=20
>=20
> >       uint64_t cpuid;
> >   #endif
> >  =20
> > diff --git a/hw/core/qdev-properties-system.c b/hw/core/qdev-properties=
-system.c
> > index d42493f630..db5c3d4fe6 100644
> > --- a/hw/core/qdev-properties-system.c
> > +++ b/hw/core/qdev-properties-system.c
> > @@ -1143,3 +1143,14 @@ const PropertyInfo qdev_prop_uuid =3D {
> >       .set   =3D set_uuid,
> >       .set_default_value =3D set_default_uuid_auto,
> >   };
> > +
> > +/* --- s390x cpu topology entitlement --- */
> > +
> > +QEMU_BUILD_BUG_ON(sizeof(CpuS390Entitlement) !=3D sizeof(int));
> > +
> > +const PropertyInfo qdev_prop_cpus390entitlement =3D {
> > +    .name =3D "CpuS390Entitlement",
> > +    .enum_table =3D &CpuS390Entitlement_lookup,
> > +    .get   =3D qdev_propinfo_get_enum,
> > +    .set   =3D qdev_propinfo_set_enum,
> > +};
> > diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> > index b8a292340c..1b3f5c61ae 100644
> > --- a/hw/s390x/cpu-topology.c
> > +++ b/hw/s390x/cpu-topology.c
> > @@ -199,8 +199,7 @@ static void s390_topology_cpu_default(S390CPU *cpu,=
 Error **errp)
> >        * is not dedicated.
> >        * A dedicated CPU always receives a high entitlement.
> >        */
> > -    if (env->entitlement >=3D S390_CPU_ENTITLEMENT__MAX ||
> > -        env->entitlement =3D=3D S390_CPU_ENTITLEMENT_HORIZONTAL) {
> > +    if (env->entitlement < 0) {
>=20
>=20
> Here we can have:
>=20
> +    if (env->entitlement =3D=3D S390_CPU_ENTITLEMENT_AUTO) {
> ...
>=20
> >           if (env->dedicated) {
> >               env->entitlement =3D S390_CPU_ENTITLEMENT_HIGH;
> >           } else {
> > diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
> > index 57165fa3a0..dea50a3e06 100644
> > --- a/target/s390x/cpu.c
> > +++ b/target/s390x/cpu.c
> > @@ -31,6 +31,7 @@
> >   #include "qapi/qapi-types-machine.h"
> >   #include "sysemu/hw_accel.h"
> >   #include "hw/qdev-properties.h"
> > +#include "hw/qdev-properties-system.h"
> >   #include "fpu/softfloat-helpers.h"
> >   #include "disas/capstone.h"
> >   #include "sysemu/tcg.h"
> > @@ -248,6 +249,7 @@ static void s390_cpu_initfn(Object *obj)
> >       cs->exception_index =3D EXCP_HLT;
> >  =20
> >   #if !defined(CONFIG_USER_ONLY)
> > +    cpu->env.entitlement =3D -1;
>=20
>=20
> Then we do not need this initialization if here under we define=20
> DEFINE_PROP_CPUS390ENTITLEMENT differently
>=20
>=20
> >       s390_cpu_init_sysemu(obj);
> >   #endif
> >   }
> > @@ -264,8 +266,7 @@ static Property s390x_cpu_properties[] =3D {
> >       DEFINE_PROP_INT32("book-id", S390CPU, env.book_id, -1),
> >       DEFINE_PROP_INT32("drawer-id", S390CPU, env.drawer_id, -1),
> >       DEFINE_PROP_BOOL("dedicated", S390CPU, env.dedicated, false),
> > -    DEFINE_PROP_UINT8("entitlement", S390CPU, env.entitlement,
> > -                      S390_CPU_ENTITLEMENT__MAX),
> > +    DEFINE_PROP_CPUS390ENTITLEMENT("entitlement", S390CPU, env.entitle=
ment),
>=20
>=20
> +=C2=A0=C2=A0=C2=A0 DEFINE_PROP_CPUS390ENTITLEMENT("entitlement", S390CPU=
, env.entitlement,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 S390_CPU_ENTITLEM=
ENT_AUTO),
>=20
> >   #endif
> >       DEFINE_PROP_END_OF_LIST()
> >   };
> >=20
> > There are other ways to achieve the same, you could also
> > implement get, set and set_default_value so that there is an additional
> > "auto"/"uninitialized" value that is not in the enum.
> > If you insist on having an additional state in the enum, name it "auto"=
.
>=20
> Yes, I think it is a better name.

IMO using entitlement=3Dauto doesn't make too much sense with the set-cpu-t=
opology command,
because you can just leave if off or specify the entitlement you want direc=
tly.
So there is no actual need to have a user visible auto value and no need to=
 have it in the enum.
Then the only problem is adjusting the entitlement when doing dedicated=3Do=
n on the command line.
(If you want that)
So with my proposal there are only the low, medium and high values in the e=
num.
In order to set the entitlement automatically when using the command line I=
 initialize
the entitlement to -1, so we later know if it has been set via the command =
line or not.
But you cannot set -1 via the property because qdev_propinfo_get_enum expec=
ts a string,
which is why I do it in s390_cpu_initfn.

I'm not sure if you can define entitlement as CpuS390Entitlement.
I think I changed it to int when I was exploring different solutions
and had to change it because of a type check. But what I proposed above doe=
sn't cause the same issue.
DEFINE_PROP_CPUS390ENTITLEMENT could then also use CpuS390Entitlement.

So there are three possible solutions now:
1. My proposal above, which as automatic adjustment, but only the three req=
uired values in the enum.
2. Don't do automatic adjustment, three enum values.
3. Automatic adjustment with auto value in the enum.

I still favor 2. but the other ones aren't terrible.
