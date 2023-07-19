Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AB17597DA
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjGSONj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjGSONj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:13:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5DA8E
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 07:13:37 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JE9M72026283;
        Wed, 19 Jul 2023 14:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hPGZrcZ8eGeBU/memwqHmEeAs09UV/ebeOt/T/s9A/w=;
 b=YV+oi3jlNz8Idk/I7gew4JXGtrkq1MTDjqjhpZF5rvq3P8GldeYfL15rHZTPhxP8CLEl
 8DV9pPEbtgxXT3F6p0hD21PhxyUb47ghwRnOJlbeYni947kSQvEsdQnQGpQ1x5yIwpQs
 pN9JOg1IMRNgWaQ9ZrdNnkDu3yyoE6RL1wm5s6crpl1kz0vdpu5ImhdOBl8NsaWMmKoT
 En4vsTL4HYi23dTIRJNAqOFfu4tmgKNy/naQHSUbo09+l+CR3wad2scHQBOdZU0Utb+Z
 EszW2jXZDtZL5yN3W16OO+D8YwoqiPgTdmRXIlYvKGVcqAsbq3i+zDLP4nNclaNkf/2A eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxh5hrf4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:13:24 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36JE9SXC026760;
        Wed, 19 Jul 2023 14:13:24 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxh5hrf3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:13:24 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36JCMTWV017202;
        Wed, 19 Jul 2023 14:13:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv5srtxbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:13:22 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36JEDIVt7668230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 14:13:19 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAD5020040;
        Wed, 19 Jul 2023 14:13:18 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB46320049;
        Wed, 19 Jul 2023 14:13:15 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.3.231])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jul 2023 14:13:15 +0000 (GMT)
Message-ID: <b4f789852e124549e2b30d25ad1268ed011c7263.camel@linux.ibm.com>
Subject: Re: [PATCH v21 16/20] tests/avocado: s390x cpu topology entitlement
 tests
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Date:   Wed, 19 Jul 2023 16:13:15 +0200
In-Reply-To: <ba0767b8-0273-898e-6aaa-1e2318b09304@linux.ibm.com>
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
         <20230630091752.67190-17-pmorel@linux.ibm.com>
         <dfeeeaa1-0994-9e1e-1f10-6c6618daacff@redhat.com>
         <aa1fbe820f23bc487752ee29ee114f5d4185352a.camel@linux.ibm.com>
         <88070b30-36ea-8112-41c4-0d93fc76cf80@redhat.com>
         <dbb17fa6239774d80e697ed771514b345faf5486.camel@linux.ibm.com>
         <ba0767b8-0273-898e-6aaa-1e2318b09304@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jd8tTu-Rq6msaxM6arohCtPJqVGkfb7o
X-Proofpoint-GUID: W9xa9MO21c7qbeeJ9SDyZ-w4M9dkROpj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_09,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307190126
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-07-19 at 16:08 +0200, Pierre Morel wrote:
>=20
> On 7/14/23 18:30, Nina Schoetterl-Glausch wrote:
> > On Wed, 2023-07-12 at 22:11 +0200, Thomas Huth wrote:
> > > On 12/07/2023 21.37, Nina Schoetterl-Glausch wrote:
> > > > On Wed, 2023-07-05 at 12:22 +0200, Thomas Huth wrote:
> > > > > On 30/06/2023 11.17, Pierre Morel wrote:
> > > > > > This test takes care to check the changes on different
> > > > > > entitlements
> > > > > > when the guest requests a polarization change.
> > > > > >=20
> > > > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > > > ---
> > > > > > =C2=A0=C2=A0=C2=A0 tests/avocado/s390_topology.py | 47
> > > > > > ++++++++++++++++++++++++++++++++++
> > > > > > =C2=A0=C2=A0=C2=A0 1 file changed, 47 insertions(+)
> > > > > >=20
> > > > > > diff --git a/tests/avocado/s390_topology.py
> > > > > > b/tests/avocado/s390_topology.py
> > > > > > index 2cf731cb1d..4855e5d7e4 100644
> > > > > > --- a/tests/avocado/s390_topology.py
> > > > > > +++ b/tests/avocado/s390_topology.py
> > > > > > @@ -240,3 +240,50 @@ def test_polarisation(self):
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 res =3D self.vm.qmp('query-cpu-polarization')
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 self.assertEqual(res['return']['polarization'],
> > > > > > 'horizontal')
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 self.check_topology(0, 0, 0, 0, 'medium',
> > > > > > False)
> > > > > > +
> > > > > > +=C2=A0=C2=A0=C2=A0 def test_entitlement(self):
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 """
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 This test verifies =
that QEMU modifies the
> > > > > > polarization
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 after a guest reque=
st.
> > > > > ...
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(0, 0, 0, 0, 'low', False)
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(1, 0, 0, 0, 'medium', False)
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(2, 1, 0, 0, 'high', False)
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(3, 1, 0, 0, 'high', False)
> > > > > > +
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.guest_set_disp=
atching('1');
> > > > > > +
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(0, 0, 0, 0, 'low', False)
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(1, 0, 0, 0, 'medium', False)
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(2, 1, 0, 0, 'high', False)
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(3, 1, 0, 0, 'high', False)
> > > > > > +
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.guest_set_disp=
atching('0');
> > > > > > +
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(0, 0, 0, 0, 'low', False)
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(1, 0, 0, 0, 'medium', False)
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(2, 1, 0, 0, 'high', False)
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.check_topology=
(3, 1, 0, 0, 'high', False)
> > > > > Sorry, I think I'm too blind to see it, but what has changed
> > > > > after
> > > > > the guest
> > > > > changed the polarization?
> > > > Nothing, the values are retained, they're just not active.
> > > > The guest will see a horizontal polarization until it changes
> > > > back
> > > > to
> > > > vertical.
> > > But then the comment in front of it ("This test verifies that
> > > QEMU
> > > *modifies* the polarization...") does not quite match, does it?
> > Yeah, it tests that QEMU reports it's own state changed when using
> > set-cpu-topology.
> > I think it would be a good idea to get the guests view from the
> > sysfs,
> > also.
> >=20
> > > =C2=A0=C2=A0 Thomas
> > >=20
> > >=20
>=20
> Yes, I think you are right, I rewrite this to check the guest view of
> the changes.
>=20
> As you said the values are retained when not used by horizontal=20
> polarization so it is a non sense to check from host view.

I don't think it's bad to check the host view, you can do both.

>=20
> Thanks
>=20
> Pierre
>=20

