Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B366444B5
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiLFNgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiLFNgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:36:12 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2287B25EB2
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 05:36:12 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6BxfER026167;
        Tue, 6 Dec 2022 13:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Vs6aG2t3dHz0F0i1JAmmTMOaG9kc9ITMFfrriJqGHxQ=;
 b=V4CNDlzRUF/DOXCA7BAkk17ImYlIBHOx8iKX67D7yr5CLL7nf61npHv1c4wynln/2yNZ
 +b7q9KnNElOtAd9fkGnjb4tjRJuypBy5JmQx2swNeRfpB3F7B9z+kxTGQ8GzwZOgSpT+
 M7kY+YcZQV4clCPN8AvpwsbXToUS09e1tTxofbnRcPHW5pSZS+SSZOWTkb34qoxuDSJt
 pgejjKhu6UwMdmxX6zjQRrYRQzXn6Fb5FjrypaaDgbIkyChjuzMjQNkZmMFQOnzZkRCZ
 2KF0ueZjKj5aTcEzS/TAcJEKqKHx0afG3x4nEShz8QX28t3ukD31C7QZEaCPlyV4YVE9 dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8g4kmc1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 13:36:00 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6DGMkt017483;
        Tue, 6 Dec 2022 13:35:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8g4kmc0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 13:35:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B69TMgO008321;
        Tue, 6 Dec 2022 13:35:57 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3m9m5y1f84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 13:35:57 +0000
Received: from d06av21.portsmouth.uk.ibm.com ([9.149.105.232])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6DZrAN13238572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 13:35:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 455815204F;
        Tue,  6 Dec 2022 13:35:53 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.46.71])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6E24C5204E;
        Tue,  6 Dec 2022 13:35:52 +0000 (GMT)
Message-ID: <3f6f1ab828c9608fabf7ad855098cd6cae1874c4.camel@linux.ibm.com>
Subject: Re: [PATCH v12 1/7] s390x/cpu topology: Creating CPU topology device
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Tue, 06 Dec 2022 14:35:52 +0100
In-Reply-To: <cb4abea1-b585-2753-12e9-6b75999d7d2e@linux.ibm.com>
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
         <20221129174206.84882-2-pmorel@linux.ibm.com>
         <92e30cf1f091329b2076195e9c159be16c13f7f9.camel@linux.ibm.com>
         <cb4abea1-b585-2753-12e9-6b75999d7d2e@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m_7BTofUSoGef7PC6vn5nhbNFCoDNOOP
X-Proofpoint-ORIG-GUID: 4wXaBQXyrC6rd_u0cLcSnIImu9i8ztct
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_08,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-12-06 at 11:32 +0100, Pierre Morel wrote:
>=20
> On 12/6/22 10:31, Janis Schoetterl-Glausch wrote:
> > On Tue, 2022-11-29 at 18:42 +0100, Pierre Morel wrote:
> > > We will need a Topology device to transfer the topology
> > > during migration and to implement machine reset.
> > >=20
> > > The device creation is fenced by s390_has_topology().
> > >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   include/hw/s390x/cpu-topology.h    | 44 +++++++++++++++
> > >   include/hw/s390x/s390-virtio-ccw.h |  1 +
> > >   hw/s390x/cpu-topology.c            | 87 +++++++++++++++++++++++++++=
+++
> > >   hw/s390x/s390-virtio-ccw.c         | 25 +++++++++
> > >   hw/s390x/meson.build               |  1 +
> > >   5 files changed, 158 insertions(+)
> > >   create mode 100644 include/hw/s390x/cpu-topology.h
> > >   create mode 100644 hw/s390x/cpu-topology.c
> > >=20
> > [...]
> >=20
> > > diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s3=
90-virtio-ccw.h
> > > index 9bba21a916..47ce0aa6fa 100644
> > > --- a/include/hw/s390x/s390-virtio-ccw.h
> > > +++ b/include/hw/s390x/s390-virtio-ccw.h
> > > @@ -28,6 +28,7 @@ struct S390CcwMachineState {
> > >       bool dea_key_wrap;
> > >       bool pv;
> > >       uint8_t loadparm[8];
> > > +    DeviceState *topology;
> >=20
> > Why is this a DeviceState, not S390Topology?
> > It *has* to be a S390Topology, right? Since you cast it to one in patch=
 2.
>=20
> Yes, currently it is the S390Topology.
> The idea of Cedric was to have something more generic for future use.

But it still needs to be a S390Topology otherwise you cannot cast it to one=
, can you?
>=20
> >=20
> > >   };
> > >  =20
> > >   struct S390CcwMachineClass {
> > > diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> > > new file mode 100644
> > > index 0000000000..bbf97cd66a
> > > --- /dev/null
> > > +++ b/hw/s390x/cpu-topology.c
> > >=20
> > [...]
> > >  =20
> > > +static DeviceState *s390_init_topology(MachineState *machine, Error =
**errp)
> > > +{
> > > +    DeviceState *dev;
> > > +
> > > +    dev =3D qdev_new(TYPE_S390_CPU_TOPOLOGY);
> > > +
> > > +    object_property_add_child(&machine->parent_obj,
> > > +                              TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
> >=20
> > Why set this property, and why on the machine parent?
>=20
> For what I understood setting the num_cores and num_sockets as=20
> properties of the CPU Topology object allows to have them better=20
> integrated in the QEMU object framework.

That I understand.
>=20
> The topology is added to the S390CcwmachineState, it is the parent of=20
> the machine.

But why? And is it added to the S390CcwMachineState, or its parent?
>=20
>=20
> >=20
> > > +    object_property_set_int(OBJECT(dev), "num-cores",
> > > +                            machine->smp.cores * machine->smp.thread=
s, errp);
> > > +    object_property_set_int(OBJECT(dev), "num-sockets",
> > > +                            machine->smp.sockets, errp);
> > > +
> > > +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
> >=20
> > I must admit that I haven't fully grokked qemu's memory management yet.
> > Is the topology devices now owned by the sysbus?
>=20
> Yes it is so we see it on the qtree with its properties.
>=20
>=20
> > If so, is it fine to have a pointer to it S390CcwMachineState?
>=20
> Why not?

If it's owned by the sysbus and the object is not explicitly referenced
for the pointer, it might be deallocated and then you'd have a dangling poi=
nter.

> It seems logical to me that the sysbus belong to the virtual machine.
> But sometime the way of QEMU are not very transparent for me :)
> so I can be wrong.
>=20
> Regards,
> Pierre
>=20
> > > +
> > > +    return dev;
> > > +}
> > > +
> > [...]
>=20

