Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD9E6E6343
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 14:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbjDRMjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 08:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbjDRMjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 08:39:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAE213F88
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 05:39:08 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IBad8Q013022;
        Tue, 18 Apr 2023 12:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=6FzgblBaagHm9Yqvs2fR6byEuIuYX+r6IDd/WWGjPPE=;
 b=f1V4S/0llVUn4VAHlk6rNMlPHl81J6QYtbz4+9EsQw9b/zDRS3UwHjZbFysaYq8kO8BK
 4c3ZQrfzO2vOXL42auuToBtvpWlyxsS7/Tls+VbsvUu4Ip5oc9RGphWLjpEr5xMngdPb
 kTp1JdR6YVptIalh81A/oYFBEIlAZuNEfz2sMGlAc9wih/8/n6rESu7Ysc51UtO7Kv6K
 W+WiZzbbYNx00D3m16Gpsav143neRQDucvn+IKUbtAmY8hrTxhbjan45lqDZPnYtILG0
 Z5yrdCWjegTV4l21XGhVJlPJQ1Q8PeXFbwGct+UppDZVwjMSRpkk4gXFSPYLgzhDFa01 mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1q35866a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 12:38:56 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33ICS5NH019883;
        Tue, 18 Apr 2023 12:38:56 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1q35864u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 12:38:56 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33HMQQc6006292;
        Tue, 18 Apr 2023 12:38:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pyk6fj1hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 12:38:53 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33ICcn9025231920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 12:38:49 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB4F92004F;
        Tue, 18 Apr 2023 12:38:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4490520040;
        Tue, 18 Apr 2023 12:38:49 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.197.137])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Apr 2023 12:38:49 +0000 (GMT)
Message-ID: <872b2cba2d76b2c635c65a1d2b301dab80866e30.camel@linux.ibm.com>
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
Date:   Tue, 18 Apr 2023 14:38:49 +0200
In-Reply-To: <d7a0263f-4b27-387d-bf6c-fde71df3feb4@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
         <20230403162905.17703-2-pmorel@linux.ibm.com>
         <e96e60dade206cb970b55bfc9d2a77643bd14d98.camel@linux.ibm.com>
         <d7a0263f-4b27-387d-bf6c-fde71df3feb4@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ak_HlwVYrD9Nh1wSUsBjqnmQVGGDq-Or
X-Proofpoint-ORIG-GUID: 7LvO7PUFUgAeiQQ9qHkarvDsy1QL4TrS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_09,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304180109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-18 at 12:01 +0200, Pierre Morel wrote:
> On 4/18/23 10:53, Nina Schoetterl-Glausch wrote:
> > On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
> > > S390 adds two new SMP levels, drawers and books to the CPU
> > > topology.
> > > The S390 CPU have specific topology features like dedication
> > > and entitlement to give to the guest indications on the host
> > > vCPUs scheduling and help the guest take the best decisions
> > > on the scheduling of threads on the vCPUs.
> > >=20
> > > Let us provide the SMP properties with books and drawers levels
> > > and S390 CPU with dedication and entitlement,
> > >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > Reviewed-by: Thomas Huth <thuth@redhat.com>
> > > ---
[...]
> >=20
> > > diff --git a/qapi/machine-common.json b/qapi/machine-common.json
> > > new file mode 100644
> > > index 0000000000..73ea38d976
> > > --- /dev/null
> > > +++ b/qapi/machine-common.json
> > > @@ -0,0 +1,22 @@
> > > +# -*- Mode: Python -*-
> > > +# vim: filetype=3Dpython
> > > +#
> > > +# This work is licensed under the terms of the GNU GPL, version 2 or=
 later.
> > > +# See the COPYING file in the top-level directory.
> > > +
> > > +##
> > > +# =3D Machines S390 data types
> > > +##
> > > +
> > > +##
> > > +# @CpuS390Entitlement:
> > > +#
> > > +# An enumeration of cpu entitlements that can be assumed by a virtua=
l
> > > +# S390 CPU
> > > +#
> > > +# Since: 8.1
> > > +##
> > > +{ 'enum': 'CpuS390Entitlement',
> > > +  'prefix': 'S390_CPU_ENTITLEMENT',
> > > +  'data': [ 'horizontal', 'low', 'medium', 'high' ] }
> > You can get rid of the horizontal value now that the entitlement is ign=
ored if the
> > polarization is vertical.
>=20
>=20
> Right, horizontal is not used, but what would you like?
>=20
> - replace horizontal with 'none' ?
>=20
> - add or substract 1 when we do the conversion between enum string and=
=20
> value ?

Yeah, I would completely drop it because it is a meaningless value
and adjust the conversion to the cpu value accordingly.
>=20
> frankly I prefer to keep horizontal here which is exactly what is given=
=20
> in the documentation for entitlement =3D 0

Not sure what you mean with this.
>=20
>=20
>=20
> >=20
> > [...]
> >=20
> > > diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
> > > index b10a8541ff..57165fa3a0 100644
> > > --- a/target/s390x/cpu.c
> > > +++ b/target/s390x/cpu.c
> > > @@ -37,6 +37,7 @@
> > >   #ifndef CONFIG_USER_ONLY
> > >   #include "sysemu/reset.h"
> > >   #endif
> > > +#include "hw/s390x/cpu-topology.h"
> > >  =20
> > >   #define CR0_RESET       0xE0UL
> > >   #define CR14_RESET      0xC2000000UL;
> > > @@ -259,6 +260,12 @@ static gchar *s390_gdb_arch_name(CPUState *cs)
> > >   static Property s390x_cpu_properties[] =3D {
> > >   #if !defined(CONFIG_USER_ONLY)
> > >       DEFINE_PROP_UINT32("core-id", S390CPU, env.core_id, 0),
> > > +    DEFINE_PROP_INT32("socket-id", S390CPU, env.socket_id, -1),
> > > +    DEFINE_PROP_INT32("book-id", S390CPU, env.book_id, -1),
> > > +    DEFINE_PROP_INT32("drawer-id", S390CPU, env.drawer_id, -1),
> > > +    DEFINE_PROP_BOOL("dedicated", S390CPU, env.dedicated, false),
> > > +    DEFINE_PROP_UINT8("entitlement", S390CPU, env.entitlement,
> > > +                      S390_CPU_ENTITLEMENT__MAX),
> > I would define an entitlement PropertyInfo in qdev-properties-system.[c=
h],
> > then one can use e.g.
> >=20
> > -device z14-s390x-cpu,core-id=3D11,entitlement=3Dhigh
>=20
>=20
> Don't you think it is an enhancement we can do later?

It's a user visible change, so no.
But it's not complicated, should be just:

const PropertyInfo qdev_prop_cpus390entitlement =3D {
    .name =3D "CpuS390Entitlement",
    .enum_table =3D &CpuS390Entitlement_lookup,
    .get   =3D qdev_propinfo_get_enum,
    .set   =3D qdev_propinfo_set_enum,
    .set_default_value =3D qdev_propinfo_set_default_value_enum,
};

Plus a comment & build bug in qdev-properties-system.c

and

extern const PropertyInfo qdev_prop_cpus390entitlement;
#define DEFINE_PROP_CPUS390ENTITLEMENT(_n, _s, _f, _d) \
    DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_cpus390entitlement, \
                       CpuS390Entitlement)

in qdev-properties-system.h

You need to change the type of env.entitlement and set the default to 1 for=
 medium
and that should be it.
>=20
>=20
> >=20
> > on the command line and cpu hotplug.
> >=20
> > I think setting the default entitlement to medium here should be fine.
> >=20
> > [...]
>=20
> right, I had medium before and should not have change it.
>=20
> Anyway what ever the default is, it must be changed later depending on=
=20
> dedication.

No, you can just set it to medium and get rid of the adjustment code.
s390_topology_check will reject invalid changes and the default above
is fine since dedication is false.
