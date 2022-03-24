Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB004E63D8
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 14:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344952AbiCXNFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 09:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240451AbiCXNE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 09:04:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EDD1D309;
        Thu, 24 Mar 2022 06:03:27 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22OBSvM9001910;
        Thu, 24 Mar 2022 13:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Eb+WaqPqa3qboWhTqB+pb8M09dkEarLaC5/qd0nW5OY=;
 b=WQLCKV2gDUSDJrLijkaB/9vKyM9Ex3xfe8GPjTvsi0ObI5vODcYLVHC5Z4avU0Mr3Tgy
 umFKTrOIahkKUWuQ70fKX7CtHQ9hLGkJBpxtH5Xu8G6oRJYT0764dDJ3OaWLpFmZNXIk
 KfBlquyFucEvUzVEVA3mkqi22SWxqbS8qt5G5gFpyNIAhIbz7LQnPfrn/CozH725CZf2
 l17GrLCSrVFNklHRwM31gZnu5yl/3dgvS6upstYZtrqHuR3f3Q0aqS7HMqInQcA8WPco
 vxTRZrWkdf3U2AlnP4FWSR/fvgkgaceh9dy/xgLX9Cu0/lPLo2Vm9KNgv8qRGL+1x+te WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0mwte6he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 13:03:27 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22OCDJU2015978;
        Thu, 24 Mar 2022 13:03:26 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0mwte6g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 13:03:26 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22OCxpls004279;
        Thu, 24 Mar 2022 13:03:23 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3ew6t8sbcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 13:03:23 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22OCpYxh49218024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 12:51:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97773A4055;
        Thu, 24 Mar 2022 13:03:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BE3CA404D;
        Thu, 24 Mar 2022 13:03:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.72])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Mar 2022 13:03:20 +0000 (GMT)
Date:   Thu, 24 Mar 2022 14:03:17 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/9] s390x: smp: add test for
 SIGP_STORE_ADTL_STATUS order
Message-ID: <20220324140317.49a86cdd@p-imbrenda>
In-Reply-To: <7a624f37d23d8095e56a6ecc6b872b8b933b58bb.camel@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
        <20220323170325.220848-5-nrb@linux.ibm.com>
        <20220323184512.192f878b@p-imbrenda>
        <7a624f37d23d8095e56a6ecc6b872b8b933b58bb.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wBVrOe85zcRXMt88h4wfOIHtV-6MqBra
X-Proofpoint-ORIG-GUID: wjEPIudvwesDUMXa0dcdc5rFSY_axg2v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_04,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203240075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Mar 2022 08:39:29 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Wed, 2022-03-23 at 18:45 +0100, Claudio Imbrenda wrote:
> > On Wed, 23 Mar 2022 18:03:20 +0100
> > Nico Boehr <nrb@linux.ibm.com> wrote:
> >  =20
> [...]
> > > +
> > > +static int memisset(void *s, int c, size_t n) =20
> >=20
> > function should return bool.. =20
>=20
> Sure, changed.
>=20
> [...]
> > > +static void test_store_adtl_status(void)
> > > +{
> > >  =20
> [...]
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report_prefix_push("unalig=
ned");
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0smp_cpu_stop(1);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cc =3D smp_sigp(1, SIGP_ST=
ORE_ADDITIONAL_STATUS,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (unsigned long)&adtl_status + 256, &status);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report(cc =3D=3D 1, "CC =
=3D 1");
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report(status =3D=3D SIGP_=
STATUS_INVALID_PARAMETER, "status =3D
> > > INVALID_PARAMETER"); =20
> >=20
> > and check again that nothing has been written to =20
>=20
> Oh, thanks. Fixed.
>=20
> [...]
> > > +static void test_store_adtl_status_unavail(void)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint32_t status =3D 0;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int cc;
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report_prefix_push("store =
additional status unvailable");
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (have_adtl_status()) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0report_skip("guarded-storage or vector facility
> > > installed");
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto out;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report_prefix_push("not ac=
cepted");
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0smp_cpu_stop(1);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cc =3D smp_sigp(1, SIGP_ST=
ORE_ADDITIONAL_STATUS,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (unsigned long)&adtl_status, &status);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report(cc =3D=3D 1, "CC =
=3D 1");
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report(status =3D=3D SIGP_=
STATUS_INVALID_ORDER,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 "status =3D INVALID_ORDER");
> > > + =20
> >=20
> > I would still check that nothing is written even when the order is
> > rejected =20
>=20
> Won't hurt, added.
>=20
> [...]
> > > +static void restart_write_vector(void)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint8_t *vec_reg;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * vlm handles at most 16 =
registers at a time
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */ =20
> >=20
> > this comment can /* go on a single line */ =20
>=20
> OK
>=20
> [...]
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/*
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * i+1 to avoid zero content
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 */ =20
> >=20
> > same /* here */ =20
>=20
> OK, changed.
>=20
> [...]
> > > +static void __store_adtl_status_vector_lc(unsigned long lc)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint32_t status =3D -1;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct psw psw;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int cc;
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report_prefix_pushf("LC %l=
u", lc);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!test_facility(133) &&=
 lc) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0report_skip("not supported, no guarded-storage
> > > facility");
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto out;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} =20
> >=20
> > I think this ^ should not be there at all =20
>=20
> It must be. If we don't have guarded-storage only LC 0 is allowed:
>=20
> "When the guarded-storage facility is not installed, the
> length and alignment of the MCESA is 1024 bytes.
> When the guarded-storage facility is installed, the
> length characteristic (LC) in bits 60-63 of the
> MCESAD specifies the length and alignment of the
> MCESA as a power of two"

hmm, it seems like that without guarded storage LC is ignored, and the
size is hardcoded to 1024.

this is getting a little out of hand now

I think you should make this into a separate test

>=20
> See below for the reason why we don't have gs here.
>=20
> [...]
> > > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > > index 1600e714c8b9..843fd323bce9 100644
> > > --- a/s390x/unittests.cfg
> > > +++ b/s390x/unittests.cfg
> > > @@ -74,9 +74,29 @@ extra_params=3D-device diag288,id=3Dwatchdog0 --
> > > watchdog-action inject-nmi
> > > =C2=A0file =3D stsi.elf
> > > =C2=A0extra_params=3D-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc=
55-
> > > 0242ac130003 -smp 1,maxcpus=3D8
> > > =C2=A0
> > > -[smp]
> > > +[smp-kvm]
> > > =C2=A0file =3D smp.elf
> > > =C2=A0smp =3D 2
> > > +accel =3D kvm
> > > +extra_params =3D -cpu host,gs=3Don,vx=3Don
> > > +
> > > +[smp-no-vec-no-gs-kvm]
> > > +file =3D smp.elf
> > > +smp =3D 2
> > > +accel =3D kvm
> > > +extra_params =3D -cpu host,gs=3Doff,vx=3Doff
> > > +
> > > +[smp-tcg]
> > > +file =3D smp.elf
> > > +smp =3D 2
> > > +accel =3D tcg
> > > +extra_params =3D -cpu qemu,vx=3Don =20
> >=20
> > why not gs=3Don as well? =20
>=20
> I am not an expert in QEMU CPU model, but it seems to me TCG doesn't
> support it.

it seems indeed so. maybe add a comment to explain

>=20

