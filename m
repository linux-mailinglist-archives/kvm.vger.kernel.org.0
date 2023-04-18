Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A856E67AC
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 16:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjDRO6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 10:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjDRO63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 10:58:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB131BD6
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 07:58:28 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IDntSN028422;
        Tue, 18 Apr 2023 14:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=v7QTnITa0/AgbHvGJF+PH1OdcwcVOTzymizEsRAOQjA=;
 b=FQnpq41v1CFbjQWTi1fx2pr2895M6SH7kGYqf59P+Lve1H81QDw1BAt6NUW+Ahaqs6v4
 4Ll0CaYB4z7hnU1TYr+sKa3nqEMMCNxN8YJt+6S4Oi4raEpUuL0pOSs2pdwAEiuPK3xf
 /o3GVvwpGxan//bui99kpCPsE/E70VsiGMKG96mHBi4T0XvdupTbcCNqfe3mq8KbMfsq
 YBAyTKlXf4Ar/By46zK+HNJIEVlCjgcLthWZ+Sg3TGJBT1lm0hT9PUeNDoIqLELBRCIR
 zg1a+OV0V6u2+hlwbxilguwBfQjgO8VWQnhiGdAuwh7EXm5HgfDBvIqsRD7UQfdOFpxH vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1pkwdfdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 14:58:14 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33IEii1u005866;
        Tue, 18 Apr 2023 14:58:14 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1pkwdfcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 14:58:13 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33I1HZjX011187;
        Tue, 18 Apr 2023 14:58:11 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pyk6fj4bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 14:58:11 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33IEw7dA10093146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 14:58:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AE3A20049;
        Tue, 18 Apr 2023 14:58:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96B0620043;
        Tue, 18 Apr 2023 14:58:06 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.197.137])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Apr 2023 14:58:06 +0000 (GMT)
Message-ID: <2868ef0d75fd8472c128bd15d0aa53c16cfabf3c.camel@linux.ibm.com>
Subject: Re: [PATCH v19 01/21] s390x/cpu topology: add s390 specifics to CPU
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
Date:   Tue, 18 Apr 2023 16:58:06 +0200
In-Reply-To: <9874d48f-dd04-6636-fd36-96a62ad01551@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
         <20230403162905.17703-2-pmorel@linux.ibm.com>
         <e96e60dade206cb970b55bfc9d2a77643bd14d98.camel@linux.ibm.com>
         <d7a0263f-4b27-387d-bf6c-fde71df3feb4@linux.ibm.com>
         <872b2cba2d76b2c635c65a1d2b301dab80866e30.camel@linux.ibm.com>
         <9874d48f-dd04-6636-fd36-96a62ad01551@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P95Wml1SYdVuS3L_lFbdTfE6X_Zsdjnj
X-Proofpoint-ORIG-GUID: hZOch3Vwy9JzKvIDmSL3CJqkhNOfvXpU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_11,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180126
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On 4/18/23 14:38, Nina Schoetterl-Glausch wrote:
> > On Tue, 2023-04-18 at 12:01 +0200, Pierre Morel wrote:
> > > On 4/18/23 10:53, Nina Schoetterl-Glausch wrote:
> > > > On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
> > > > > S390 adds two new SMP levels, drawers and books to the CPU
> > > > > topology.
> > > > > The S390 CPU have specific topology features like dedication
> > > > > and entitlement to give to the guest indications on the host
> > > > > vCPUs scheduling and help the guest take the best decisions
> > > > > on the scheduling of threads on the vCPUs.
> > > > >=20
> > > > > Let us provide the SMP properties with books and drawers levels
> > > > > and S390 CPU with dedication and entitlement,
> > > > >=20
> > > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > > Reviewed-by: Thomas Huth <thuth@redhat.com>
> > > > > ---
> > [...]
> > > > > diff --git a/qapi/machine-common.json b/qapi/machine-common.json
> > > > > new file mode 100644
> > > > > index 0000000000..73ea38d976
> > > > > --- /dev/null
> > > > > +++ b/qapi/machine-common.json
> > > > > @@ -0,0 +1,22 @@
> > > > > +# -*- Mode: Python -*-
> > > > > +# vim: filetype=3Dpython
> > > > > +#
> > > > > +# This work is licensed under the terms of the GNU GPL, version =
2 or later.
> > > > > +# See the COPYING file in the top-level directory.
> > > > > +
> > > > > +##
> > > > > +# =3D Machines S390 data types
> > > > > +##
> > > > > +
> > > > > +##
> > > > > +# @CpuS390Entitlement:
> > > > > +#
> > > > > +# An enumeration of cpu entitlements that can be assumed by a vi=
rtual
> > > > > +# S390 CPU
> > > > > +#
> > > > > +# Since: 8.1
> > > > > +##
> > > > > +{ 'enum': 'CpuS390Entitlement',
> > > > > +  'prefix': 'S390_CPU_ENTITLEMENT',
> > > > > +  'data': [ 'horizontal', 'low', 'medium', 'high' ] }
> > > > You can get rid of the horizontal value now that the entitlement is=
 ignored if the
> > > > polarization is vertical.
> > >=20
> > > Right, horizontal is not used, but what would you like?
> > >=20
> > > - replace horizontal with 'none' ?
> > >=20
> > > - add or substract 1 when we do the conversion between enum string an=
d
> > > value ?
> > Yeah, I would completely drop it because it is a meaningless value
> > and adjust the conversion to the cpu value accordingly.
> > > frankly I prefer to keep horizontal here which is exactly what is giv=
en
> > > in the documentation for entitlement =3D 0
> > Not sure what you mean with this.
>=20
> I mean: Extract from the PoP:
>=20
> ----
>=20
> The following values are used:
> PP Meaning
> 0 The one or more CPUs represented by the TLE are
> horizontally polarized.
> 1 The one or more CPUs represented by the TLE are
> vertically polarized. Entitlement is low.
> 2 The one or more CPUs represented by the TLE are
> vertically polarized. Entitlement is medium.
> 3 The one or more CPUs represented by the TLE are
> vertically polarized. Entitlement is high.
>=20
> ----
>=20
> Also I find that using an enum to systematically add/subtract a value is=
=20
> for me weird.

It is, I'd do:

+static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
+{
+    struct S390CcwMachineState *s390ms =3D S390_CCW_MACHINE(current_machin=
e);
+    s390_topology_id topology_id =3D {0};
+
+    topology_id.drawer =3D cpu->env.drawer_id;
+    topology_id.book =3D cpu->env.book_id;
+    topology_id.socket =3D cpu->env.socket_id;
+    topology_id.origin =3D cpu->env.core_id / 64;
+    topology_id.type =3D S390_TOPOLOGY_CPU_IFL;
+    topology_id.dedicated =3D cpu->env.dedicated;
+
+    if (s390ms->vertical_polarization) {
+        uint8_t to_polarization[] =3D {
+            [S390_CPU_ENTITLEMENT_LOW] =3D 1,
+            [S390_CPU_ENTITLEMENT_MEDIUM] =3D 2,
+            [S390_CPU_ENTITLEMENT_HIGH] =3D 3,
+        };
+        topology_id.entitlement =3D to_polarization[cpu->env.entitlement];
+    }
+
+    return topology_id;
+}

You can also use a switch of course.
I'd also rename s390_topology_id.entitlement to polarization.

>=20
> so I really prefer to keep "horizontal", "low", "medium", "high" event=
=20
> "horizontal" will never appear.
>=20
> A mater of taste, it does not change anything to the functionality or=20
> the API.

Well, it does change the API a bit, namely which values mean what,
currently there is a value 0 that you're not supposed to use, that would go=
 away.
It also shows up in some meta command to print qapi interfaces.
And dropping it simplifies the implementation IMO --- you don't need
to think about and prevent usage of a nonexistent state.
>=20
>=20
> > >=20
> > >=20
> > > > [...]
> > > >=20
> > > > > diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
> > > > > index b10a8541ff..57165fa3a0 100644
> > > > > --- a/target/s390x/cpu.c
> > > > > +++ b/target/s390x/cpu.c
> > > > > @@ -37,6 +37,7 @@
> > > > >    #ifndef CONFIG_USER_ONLY
> > > > >    #include "sysemu/reset.h"
> > > > >    #endif
> > > > > +#include "hw/s390x/cpu-topology.h"
> > > > >   =20
> > > > >    #define CR0_RESET       0xE0UL
> > > > >    #define CR14_RESET      0xC2000000UL;
> > > > > @@ -259,6 +260,12 @@ static gchar *s390_gdb_arch_name(CPUState *c=
s)
> > > > >    static Property s390x_cpu_properties[] =3D {
> > > > >    #if !defined(CONFIG_USER_ONLY)
> > > > >        DEFINE_PROP_UINT32("core-id", S390CPU, env.core_id, 0),
> > > > > +    DEFINE_PROP_INT32("socket-id", S390CPU, env.socket_id, -1),
> > > > > +    DEFINE_PROP_INT32("book-id", S390CPU, env.book_id, -1),
> > > > > +    DEFINE_PROP_INT32("drawer-id", S390CPU, env.drawer_id, -1),
> > > > > +    DEFINE_PROP_BOOL("dedicated", S390CPU, env.dedicated, false)=
,
> > > > > +    DEFINE_PROP_UINT8("entitlement", S390CPU, env.entitlement,
> > > > > +                      S390_CPU_ENTITLEMENT__MAX),
> > > > I would define an entitlement PropertyInfo in qdev-properties-syste=
m.[ch],
> > > > then one can use e.g.
> > > >=20
> > > > -device z14-s390x-cpu,core-id=3D11,entitlement=3Dhigh
> > >=20
> > > Don't you think it is an enhancement we can do later?
> > It's a user visible change, so no.
>=20
>=20
> We could have kept both string and integer.

That sounds harder to do, I guess you'd have to reimplement the PropertyInf=
o
getters and setters to do that.

>=20
>=20
> > But it's not complicated, should be just:
> >=20
> > const PropertyInfo qdev_prop_cpus390entitlement =3D {
> >      .name =3D "CpuS390Entitlement",
> >      .enum_table =3D &CpuS390Entitlement_lookup,
> >      .get   =3D qdev_propinfo_get_enum,
> >      .set   =3D qdev_propinfo_set_enum,
> >      .set_default_value =3D qdev_propinfo_set_default_value_enum,
> > };
> >=20
> > Plus a comment & build bug in qdev-properties-system.c
> >=20
> > and
> >=20
> > extern const PropertyInfo qdev_prop_cpus390entitlement;
> > #define DEFINE_PROP_CPUS390ENTITLEMENT(_n, _s, _f, _d) \
> >      DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_cpus390entitlement, \
> >                         CpuS390Entitlement)
> >=20
> > in qdev-properties-system.h
> >=20
> > You need to change the type of env.entitlement and set the default to 1=
 for medium
> > and that should be it.
>=20
>=20
> OK, it does not change anything to the functionality but is a little bit=
=20
> more pretty.
>=20
>=20
> > >=20
> > > > on the command line and cpu hotplug.
> > > >=20
> > > > I think setting the default entitlement to medium here should be fi=
ne.
> > > >=20
> > > > [...]
> > > right, I had medium before and should not have change it.
> > >=20
> > > Anyway what ever the default is, it must be changed later depending o=
n
> > > dedication.
> > No, you can just set it to medium and get rid of the adjustment code.
> > s390_topology_check will reject invalid changes and the default above
> > is fine since dedication is false.
>=20
>=20
> I do not want a default specification for the entitlement to depend on=
=20
> the polarization.

I don't see why we cannot just set it to medium.
>=20
> If we do as you propose, by horizontal polarization a default=20
> entitlement with dedication will be accepted but will be refused after=
=20
> the guest switched for vertical polarization.

No, your check function doesn't look the polarization at all (and shouldn't=
):

+static void s390_topology_check(uint16_t socket_id, uint16_t book_id,
+                                uint16_t drawer_id, uint16_t entitlement,
+                                bool dedicated, Error **errp)
+{

[...]

+    if (dedicated && (entitlement =3D=3D S390_CPU_ENTITLEMENT_LOW ||
+                      entitlement =3D=3D S390_CPU_ENTITLEMENT_MEDIUM)) {
+        error_setg(errp, "A dedicated cpu implies high entitlement");
+        return;
+    }
+}
>=20
> So we need adjustment before the check in both cases.

I don't see why, just always reject it.
>=20
> I find it easier and more logical if there is no default value than to=
=20
> have a default we need to overwrite.
>=20
>=20
>=20
>=20

