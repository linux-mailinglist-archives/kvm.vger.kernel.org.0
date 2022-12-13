Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC8064B696
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 14:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiLMNtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 08:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbiLMNtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 08:49:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B07B71
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 05:49:17 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDD0P3t010207
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 13:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=49oBZF85hk3GFGwcvRSwPPcuKVLsFuw0jij750Yy3mY=;
 b=VkynlNr6P4DR642A1JYd/IxDwYh5BsPY6xKKB30qOI/oqufo+YfBO6Qp8uRap/J8bMpc
 cthZu3gXw1h0Vo+Ryixd4FkBITnz5r1HPEVdLUZAbmmOZ+jNGBnz7NRCYbpVbGSG3Gn6
 dmeeWqS6J7I8I01rdfMwuXsJmNyt02HGmgIu+vY5INc1b4eRlytFeimoDqPgzLIcASrk
 FHFmPmrsYhSMN3BFj1XHzUA9KIMJ7+R6Le10vGCVMbXl7X1z7QBP4bTJt5aNfKTeialF
 zLqsOf33YU3NWYuWOIXmalBUmBS0TzfCNoKiU7MkY8OCzt6sL+Qh9BsHBQRULixBj99Q PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mejre47u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 13:49:17 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDCutkT015850
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 13:49:16 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mejre47tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:49:16 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD59GAn007817;
        Tue, 13 Dec 2022 13:49:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mchcf4934-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:49:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDDnBWu43975058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 13:49:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 284AA20043;
        Tue, 13 Dec 2022 13:49:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7D5120049;
        Tue, 13 Dec 2022 13:49:10 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.179.4.88])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 13:49:10 +0000 (GMT)
Message-ID: <e1cea42fbfc22b6fc99b96e9c48a761eb14253bd.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add parallel skey
 migration test
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Date:   Tue, 13 Dec 2022 14:49:10 +0100
In-Reply-To: <20221213131416.68e0cada@p-imbrenda>
References: <20221209102122.447324-1-nrb@linux.ibm.com>
         <20221209102122.447324-2-nrb@linux.ibm.com>
         <a54eb84516a5fcb1799ae864caff6aefc31b1896.camel@linux.ibm.com>
         <167092140591.10919.7530526866489219030@t14-nrb.local>
         <7d641501865efea9a31d90e6b8dc8712067c3a13.camel@linux.ibm.com>
         <20221213131416.68e0cada@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: odE3tP41LFnNZDqSUEjpfzBe7-pRnqvu
X-Proofpoint-ORIG-GUID: _TcjWqX2hA8g0VMewLr9AT11p1ySgYZW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 mlxscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-12-13 at 13:14 +0100, Claudio Imbrenda wrote:
> On Tue, 13 Dec 2022 12:11:29 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > On Tue, 2022-12-13 at 09:50 +0100, Nico Boehr wrote:
> > > Quoting Nina Schoetterl-Glausch (2022-12-12 21:37:28) =20
> > > > On Fri, 2022-12-09 at 11:21 +0100, Nico Boehr wrote: =20
> > > > > Right now, we have a test which sets storage keys, then migrates =
the VM
> > > > > and - after migration finished - verifies the skeys are still the=
re.
> > > > >=20
> > > > > Add a new version of the test which changes storage keys while th=
e
> > > > > migration is in progress. This is achieved by adding a command li=
ne
> > > > > argument to the existing migration-skey test.
> > > > >=20
> > > > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > > > ---
> > > > >  s390x/migration-skey.c | 214 +++++++++++++++++++++++++++++++++++=
------
> > > > >  s390x/unittests.cfg    |  15 ++-
> > > > >  2 files changed, 198 insertions(+), 31 deletions(-)
> > > > >=20
> > > > > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > > > > index b7bd82581abe..9b9a45f4ad3b 100644
> > > > > --- a/s390x/migration-skey.c
> > > > > +++ b/s390x/migration-skey.c
> > > > >  =20
> > > > [...]
> > > >  =20
> > > > > +static void test_skey_migration_parallel(void)
> > > > > +{
> > > > > +     report_prefix_push("parallel");
> > > > > +
> > > > > +     if (smp_query_num_cpus() =3D=3D 1) {
> > > > > +             report_skip("need at least 2 cpus for this test");
> > > > > +             goto error;
> > > > > +     }
> > > > > +
> > > > > +     smp_cpu_setup(1, PSW_WITH_CUR_MASK(set_skeys_thread));
> > > > > +
> > > > > +     migrate_once();
> > > > > +
> > > > > +     WRITE_ONCE(thread_should_exit, 1);
> > > > > +
> > > > > +     while (!thread_exited)
> > > > > +             mb(); =20
> > > >=20
> > > > Are you doing it this way instead of while(!READ_ONCE(thread_exited=
)); so the mb() does double duty
> > > > and ensures "result" is also read from memory a couple of lines dow=
n? =20
> > >=20
> > > It is a good point, actually I just did what we already do in wait_fo=
r_flag in s390x/smp.c. :-)
> > >  =20
> > > > If so, I wonder if the compiler is allowed to arrange the control f=
low such that if the loop condition
> > > > is false on the first iteration it uses a cached value of "result" =
(I'd be guessing yes, but what do I know). =20
> > >=20
> > > I agree, but it does not matter, does it? At latest the second iterat=
ion will actually read from memory, no? =20
> >=20
> > Well, if the condition is false on the first iteration, there won't be =
a second one.
> > >  =20
> > > > In any case using a do while loop instead would eliminate the quest=
ion.
> > > > A comment might be nice, too. =20
> > >=20
> > > How about I change to
> > >   while(!READ_ONCE(thread_exited));=20
> > > and add an explicit mb() below to ensure result is read from memory? =
=20
> >=20
> > Fine by me. Could also use READ_ONCE for result. You decide.
> > Btw, doesn't checkpatch complain about mb() without comment?
>=20
> there is no checkpatch for kvm unit tests :)

Well, ok, depends what you consider part of the coding style then :)
Since k-u-t uses kernel style. I run it and then ignore what I judge reason=
able to ignore :)
>=20
> > Although I think I've ignored that before, too.
> >=20
>=20

