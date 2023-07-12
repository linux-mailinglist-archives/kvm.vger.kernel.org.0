Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B98C751156
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjGLTiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 15:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjGLThz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 15:37:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB721FC7
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 12:37:45 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CJHDhk001199;
        Wed, 12 Jul 2023 19:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=S8TmN3JruplAu93H9Aij54Zafnd3YvROvnSvHc0Oh9o=;
 b=WuNwk7kTaKr3HV/zSAnulBfiEXye4z9VNXgBZq+bFfeQpRMc/RxlzyiIv9b9JnxXsbiA
 S5OAtm79Y7O90W3yHazPAjIcQCY9UlCOj1s9t0eivKShyUN4uAeI9NT+FK4gUDeab2wC
 ZWPH3iLP85FyoSqx02dtMxWZKT9eY/68+hgsBbnHrqnQQZxLedthFoXuphCNNhxCA7Hd
 9KQ+b1RNlRBtH/D6rhv21FhHBcsB4SwRK2KmPI4rUHrG5699uoWSvhlOaIqBGZa9mNIT
 z+UkBLGoYFU1h4vvW5gHhZAKbSzz+3JRyFWMv/7eRfpcbitFl6EoEy5V/2aPBY+aJp68 Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rt26s0ccy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 19:37:34 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CJZriQ019582;
        Wed, 12 Jul 2023 19:37:34 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rt26s0cc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 19:37:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36CBKL8U004228;
        Wed, 12 Jul 2023 19:37:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rpy2e2vg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 19:37:31 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CJbRE145154644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 19:37:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D2FD20043;
        Wed, 12 Jul 2023 19:37:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7C5920040;
        Wed, 12 Jul 2023 19:37:26 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jul 2023 19:37:26 +0000 (GMT)
Message-ID: <aa1fbe820f23bc487752ee29ee114f5d4185352a.camel@linux.ibm.com>
Subject: Re: [PATCH v21 16/20] tests/avocado: s390x cpu topology entitlement
 tests
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Date:   Wed, 12 Jul 2023 21:37:26 +0200
In-Reply-To: <dfeeeaa1-0994-9e1e-1f10-6c6618daacff@redhat.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
         <20230630091752.67190-17-pmorel@linux.ibm.com>
         <dfeeeaa1-0994-9e1e-1f10-6c6618daacff@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5wvqs-Q5Ab3KTL8sAoyrp1cjVQSNQvKV
X-Proofpoint-GUID: -JHsTeiiiWQiRTR1UeKaNscABoezdi3j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_14,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120174
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-07-05 at 12:22 +0200, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
> > This test takes care to check the changes on different entitlements
> > when the guest requests a polarization change.
> >=20
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> > =C2=A0 tests/avocado/s390_topology.py | 47
> > ++++++++++++++++++++++++++++++++++
> > =C2=A0 1 file changed, 47 insertions(+)
> >=20
> > diff --git a/tests/avocado/s390_topology.py
> > b/tests/avocado/s390_topology.py
> > index 2cf731cb1d..4855e5d7e4 100644
> > --- a/tests/avocado/s390_topology.py
> > +++ b/tests/avocado/s390_topology.py
> > @@ -240,3 +240,50 @@ def test_polarisation(self):
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res =3D self.vm.=
qmp('query-cpu-polarization')
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.assertEqual=
(res['return']['polarization'],
> > 'horizontal')
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topol=
ogy(0, 0, 0, 0, 'medium', False)
> > +
> > +=C2=A0=C2=A0=C2=A0 def test_entitlement(self):
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 """
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 This test verifies that QEM=
U modifies the polarization
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 after a guest request.
> ...
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(0, 0, 0=
, 0, 'low', False)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(1, 0, 0=
, 0, 'medium', False)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(2, 1, 0=
, 0, 'high', False)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(3, 1, 0=
, 0, 'high', False)
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.guest_set_dispatching(=
'1');
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(0, 0, 0=
, 0, 'low', False)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(1, 0, 0=
, 0, 'medium', False)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(2, 1, 0=
, 0, 'high', False)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(3, 1, 0=
, 0, 'high', False)
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.guest_set_dispatching(=
'0');
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(0, 0, 0=
, 0, 'low', False)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(1, 0, 0=
, 0, 'medium', False)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(2, 1, 0=
, 0, 'high', False)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology(3, 1, 0=
, 0, 'high', False)
>=20
> Sorry, I think I'm too blind to see it, but what has changed after
> the guest=20
> changed the polarization?

Nothing, the values are retained, they're just not active.
The guest will see a horizontal polarization until it changes back to
vertical.

>=20
> =C2=A0 Thomas
>=20

