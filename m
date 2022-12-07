Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98713645923
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 12:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLGLjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 06:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiLGLjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 06:39:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5908B49B77
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 03:39:00 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7BLc3t027535;
        Wed, 7 Dec 2022 11:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=TCxTfcanPg331gYbavOms1Mqqd4yhtMFlGUDtT8kMkw=;
 b=LfwKMFi5w6JWBuiQH5H0N8n0wofGyN6/JL054agGihmND3BaEqGINbzbH6p3Di2lAKMO
 8zpq1BToMJiw1maJbiHvO09NrNeWtKNwCRpj9ojGWemH009JyPspn9LlmQnOPhI73Sbu
 BJNv0NTZ1tBrzWLK3T2PxZr6QDojob2N9U2rUFXZOz5XLKbvMRnLx3m1mYuMOPG1M4j6
 Mmn5B0Rqet53u9Td0txXN5QAaCWk1oTdsGKIyQWD0yerCMk7HojPaM14mQ/QFK2vP7dd
 fH2vLhucurfZQ6OvdTW8OO4NHhqNSuif+aCvXnuE9fkiH3h9lKv5q1AfHUdUEwjhe9+X pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3masvurckq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 11:38:50 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B7BN7Yj001427;
        Wed, 7 Dec 2022 11:38:50 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3masvurck4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 11:38:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LrrOL010345;
        Wed, 7 Dec 2022 11:38:48 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3m9ks42ve2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 11:38:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B7Bcix043254188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Dec 2022 11:38:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5855A20049;
        Wed,  7 Dec 2022 11:38:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D122D20040;
        Wed,  7 Dec 2022 11:38:43 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.152.224.238])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Dec 2022 11:38:43 +0000 (GMT)
Message-ID: <b0055a81c8266a77843eead531c0b188ceea0abf.camel@linux.ibm.com>
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
Date:   Wed, 07 Dec 2022 12:38:43 +0100
In-Reply-To: <1c63d7e3-008b-5347-02eb-538e091f3639@linux.ibm.com>
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
         <20221129174206.84882-2-pmorel@linux.ibm.com>
         <92e30cf1f091329b2076195e9c159be16c13f7f9.camel@linux.ibm.com>
         <cb4abea1-b585-2753-12e9-6b75999d7d2e@linux.ibm.com>
         <3f6f1ab828c9608fabf7ad855098cd6cae1874c4.camel@linux.ibm.com>
         <ffb9b474-e29d-c790-611e-549846b939e4@linux.ibm.com>
         <34e774fc372e41f352ccf03761a78eff22728f89.camel@linux.ibm.com>
         <1c63d7e3-008b-5347-02eb-538e091f3639@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: apNjLNNbZr6uy94U8iHx7FRSd4rRwZL-
X-Proofpoint-GUID: Y97sy1EDmCXhbneRKJDqnEX0KXMMSAx0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_05,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212070099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 * On Wed, 2022-12-07 at 11:00 +0100, Pierre Morel wrote:
>=20
> On 12/6/22 22:06, Janis Schoetterl-Glausch wrote:
> > On Tue, 2022-12-06 at 15:35 +0100, Pierre Morel wrote:
> > >=20
> > > On 12/6/22 14:35, Janis Schoetterl-Glausch wrote:
> > > > On Tue, 2022-12-06 at 11:32 +0100, Pierre Morel wrote:
> > > > >=20
> > > > > On 12/6/22 10:31, Janis Schoetterl-Glausch wrote:
> > > > > > On Tue, 2022-11-29 at 18:42 +0100, Pierre Morel wrote:
> > > > > > > We will need a Topology device to transfer the topology
> > > > > > > during migration and to implement machine reset.
> > > > > > >=20
> > > > > > > The device creation is fenced by s390_has_topology().
> > > > > > >=20
> > > > > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > > > > ---
> > > > > > >  include/hw/s390x/cpu-topology.h | 44 +++++++++++++++
> > > > > > >  include/hw/s390x/s390-virtio-ccw.h | 1 +
> > > > > > >  hw/s390x/cpu-topology.c | 87 ++++++++++++++++++++++++++++++
> > > > > > >  hw/s390x/s390-virtio-ccw.c | 25 +++++++++
> > > > > > >  hw/s390x/meson.build | 1 +
> > > > > > >  5 files changed, 158 insertions(+)
> > > > > > >  create mode 100644 include/hw/s390x/cpu-topology.h
> > > > > > >  create mode 100644 hw/s390x/cpu-topology.c
> > > > > >=20
[...]

> > > > > > > + object_property_set_int(OBJECT(dev), "num-cores",
> > > > > > > + machine->smp.cores * machine->smp.threads, errp);
> > > > > > > + object_property_set_int(OBJECT(dev), "num-sockets",
> > > > > > > + machine->smp.sockets, errp);
> > > > > > > +
> > > > > > > + sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
> > > > > >=20
> > > > > > I must admit that I haven't fully grokked qemu's memory managem=
ent yet.
> > > > > > Is the topology devices now owned by the sysbus?
> > > > >=20
> > > > > Yes it is so we see it on the qtree with its properties.
> > > > >=20
> > > > >=20
> > > > > > If so, is it fine to have a pointer to it S390CcwMachineState?
> > > > >=20
> > > > > Why not?
> > > >=20
> > > > If it's owned by the sysbus and the object is not explicitly refere=
nced
> > > > for the pointer, it might be deallocated and then you'd have a dang=
ling pointer.
> > >=20
> > > Why would it be deallocated ?
> >=20
> > That's beside the point, if you transfer ownership, you have no control=
 over when
> > the deallocation happens.
> > It's going to be fine in practice, but I don't think you should rely on=
 it.
> > I think you could just do sysbus_realize instead of ..._and_unref,
> > but like I said, I haven't fully understood qemu memory management.
> > (It would also leak in a sense, but since the machine exists forever th=
at should be fine)
>=20
> If I understand correctly:
>=20
> - qdev_new adds a reference count to the new created object, dev.
>=20
> - object_property_add_child adds a reference count to the child also=20
> here the new created device dev so the ref count of dev is 2 .
>=20
> after the unref on dev, the ref count of dev get down to 1
>=20
> then it seems OK. Did I miss something?

The properties ref belongs to the property, if the property were removed,
it would be unref'ed. There is no extra ref for the pointer in S390CcwMachi=
neState.
I'm coming from a clean code perspective, I don't think we'd run into this =
problem in practice.
>=20
> Regards,
> Pierre
>=20
> >=20
> > > as long it is not unrealized it belongs to the sysbus doesn't it?
> > >=20
> > > Regards,
> > > Pierre
> > >=20
> >=20
>=20

