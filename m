Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C5F4E55A1
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 16:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiCWPtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 11:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiCWPtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 11:49:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBAA70F70;
        Wed, 23 Mar 2022 08:47:43 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NFg2EY021676;
        Wed, 23 Mar 2022 15:47:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UhzFUbcuGI/+y/LiaprpiH5BDe/vR4kN0Z184NRcGZk=;
 b=f3mM6+E9oW+MpnWjI6F9bZFh5neAY2BbGEAaiRSL7LR7pNdo9ffpsS08kqByM/1vM9LA
 ogMp6nU6OncqUU0NBBiHZxW6792zVUh3qS7cXWxnxcHNDWvCt971kOy50RLqIpm68Vc7
 mSojNdiCTKnfjr2alwrhTd+S3WpvUIs4tlXHkKgABpmOKV0gkvs5M2KUuWBZ/qIn0YHo
 Z03tN7Z6hqDO0aW8R2P9bu0iAFIXTkfTgzNrTmfhWYv/OcAvAzW3rY68BJ8SId0YCfIl
 dD9YBxjoFP3uWwjC2rqs9QgHjcCJP9OuytFxNCH1iLq622XMLEs089k305tzF2SbLRjx gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f06drg4gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 15:47:42 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NFhnQG030012;
        Wed, 23 Mar 2022 15:47:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f06drg4fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 15:47:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NFN6dj030104;
        Wed, 23 Mar 2022 15:47:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3ew6t90w9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 15:47:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NFlaeN23986546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 15:47:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7A68AE056;
        Wed, 23 Mar 2022 15:47:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 469F1AE053;
        Wed, 23 Mar 2022 15:47:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.232])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 15:47:36 +0000 (GMT)
Date:   Wed, 23 Mar 2022 16:47:33 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 4/9] s390x: smp: add test for
 SIGP_STORE_ADTL_STATUS order
Message-ID: <20220323164733.4f36eb20@p-imbrenda>
In-Reply-To: <1d1fa70ec01e7a3284d997dc05272fe144288fa0.camel@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
        <20220321101904.387640-5-nrb@linux.ibm.com>
        <20220321155900.77bd89d8@p-imbrenda>
        <1d1fa70ec01e7a3284d997dc05272fe144288fa0.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vewUwdP4u_hlzwvZgzulUmYAvnzph37B
X-Proofpoint-ORIG-GUID: EBdGWF8LemN-B66shHW4IYIuDBgEZp19
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203230084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Mar 2022 15:19:33 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Mon, 2022-03-21 at 15:59 +0100, Claudio Imbrenda wrote:
> > On Mon, 21 Mar 2022 11:18:59 +0100
> > Nico Boehr <nrb@linux.ibm.com> wrote: =20
> > > diff --git a/s390x/smp.c b/s390x/smp.c
> > > index e5a16eb5a46a..5d3265f6be64 100644
> > > --- a/s390x/smp.c =20
> [...]
> > > +/*
> > > + * We keep two structs, one for comparing when we want to assert
> > > it's not
> > > + * touched.
> > > + */
> > > +static uint8_t adtl_status[2][4096]
> > > __attribute__((aligned(4096))); =20
> >=20
> > it's a little bit ugly. maybe define a struct, with small buffers
> > inside
> > for the vector and gs areas? that way we would not need ugly magic
> > numbers below (see below) =20
>=20
> OK, will do.
>=20
> [...]
> > > +static void restart_write_vector(void)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint8_t *vec_reg;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint8_t *vec_reg_16_31 =3D=
 &expected_vec_contents[16][0]; =20
> >=20
> > add a comment to explain that vlm only handles at most 16 registers
> > at
> > a time =20
>=20
> OK will do.
>=20
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int i;
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (i =3D 0; i < NUM_VEC_=
REGISTERS; i++) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0vec_reg =3D &expected_vec_contents[i][0];
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0memset(vec_reg, i, VEC_REGISTER_SIZE);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} =20
> >=20
> > this way vector register 0 stays 0.
> > either special case it (e.g. 16, or whatever), or put a magic value
> > somewhere in every register =20
>=20
> adtl_status is initalized with 0xff. Are you OK with i + 1 so we avoid
> zero?

that is fine

>=20
> [...]
> > > +static void test_store_adtl_status_vector(void)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint32_t status =3D -1;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct psw psw;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int cc;
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report_prefix_push("store =
additional status vector");
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!test_facility(129)) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0report_skip("vector facility not installed");
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto out;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cpu_write_magic_to_vector_=
regs(1);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0smp_cpu_stop(1);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memset(adtl_status, 0xff, =
sizeof(adtl_status));
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cc =3D smp_sigp(1, SIGP_ST=
ORE_ADDITIONAL_STATUS,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (unsigned long)adtl_status, &status);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report(!cc, "CC =3D 0");
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report(!memcmp(adtl_status=
, expected_vec_contents,
> > > sizeof(expected_vec_contents)),
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 "additional status contents match"); =20
> >=20
> > it would be interesting to check that nothing is stored past the end
> > of
> > the buffer. =20
>=20
> I will add checks to ensure reserved fields are not modified.
>=20
> > moreover, I think you should also explicitly test with lc_10, to make
> > sure that works as well (no need to rerun the guest, just add another
> > sigp call) =20
>=20
> I will test vector with LC 0, 10, 11, 12 and guarded storage with LC 11
> and 12.
>=20
> [...]
> > > +static void restart_write_gs_regs(void)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const unsigned long gs_are=
a =3D 0x2000000;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const unsigned long gsc =
=3D 25; /* align =3D 32 M, section size
> > > =3D 512K */
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ctl_set_bit(2, CTL2_GUARDE=
D_STORAGE);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gs_cb.gsd =3D gs_area | gs=
c;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gs_cb.gssm =3D 0xfeedc0ffe;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gs_cb.gs_epl_a =3D (uint64=
_t) &gs_epl;
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0load_gs_cb(&gs_cb);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0set_flag(1);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ctl_clear_bit(2, CTL2_GUAR=
DED_STORAGE); =20
> >=20
> > what happens when the function returns? is r14 set up properly? (or
> > maybe we just don't care, since we are going to stop the CPU anyway?) =
=20
>=20
> We have an endless loop in smp_cpu_setup_state.=C2=A0So r14 will point th=
ere
> (verified with gdb).
>=20
> In the end, I think we don't care. This is in contrast to the vector
> test, where the epilogue will clean up the floating point regs.

then add a comment explaining that :)

>=20
> [...]
> > > +static void test_store_adtl_status_gs(void)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const unsigned long adtl_s=
tatus_lc_11 =3D 11;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint32_t status =3D 0;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int cc;
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report_prefix_push("store =
additional status guarded-
> > > storage");
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!test_facility(133)) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0report_skip("guarded-storage facility not
> > > installed");
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto out;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cpu_write_to_gs_regs(1);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0smp_cpu_stop(1);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memset(adtl_status, 0xff, =
sizeof(adtl_status));
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cc =3D smp_sigp(1, SIGP_ST=
ORE_ADDITIONAL_STATUS,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (unsigned long)adtl_status | adtl_status_lc_=
11,
> > > &status);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report(!cc, "CC =3D 0");
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report(!memcmp(&adtl_statu=
s[0][1024], &gs_cb,
> > > sizeof(gs_cb)), =20
> >=20
> > e.g. the 1024 is one of those "magic number" I mentioned above  =20
>=20
> OK, fixed.
>=20
> >  =20
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 "additional status contents match"); =20
> >=20
> > it would be interesting to test that nothing is stored after the end
> > of
> > the buffer (i.e. everything is still 0xff in the second half of the
> > page) =20
>=20
> Yes, done.
>=20
> [...]
> > >=20
> > > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > > index 1600e714c8b9..2d0adc503917 100644
> > > --- a/s390x/unittests.cfg
> > > +++ b/s390x/unittests.cfg
> > > @@ -77,6 +77,12 @@ extra_params=3D-name kvm-unit-test --uuid
> > > 0fb84a86-727c-11ea-bc55-0242ac130003 -sm
> > > =C2=A0[smp]
> > > =C2=A0file =3D smp.elf
> > > =C2=A0smp =3D 2
> > > +extra_params =3D -cpu host,gs=3Don,vx=3Don
> > > +
> > > +[smp-no-vec-no-gs]
> > > +file =3D smp.elf
> > > +smp =3D 2
> > > +extra_params =3D -cpu host,gs=3Doff,vx=3Doff =20
> >=20
> > using "host" will break TCG
> > (and using "qemu" will break secure execution)
> >=20
> > there are two possible solutions:
> >=20
> > use "max" and deal with the warnings, or split each testcase in two,
> > one using host cpu and "accel =3D kvm" and the other with "accel =3D tc=
g"
> > and qemu cpu. =20
>=20
> Uh, thanks for pointing out. I will split in accel =3D tcg and accel =3D
> kvm.
>=20
> > what should happen if only one of the two features is installed?
> > should
> > the buffer for the unavailable feature be stored with 0 or should it
> > be
> > left untouched? is it worth testing those scenarios? =20
>=20
> The PoP specifies: "A facility=E2=80=99s registers are only
> stored in the MCESA when the facility is installed."
>=20
> Maybe I miss something, but it doesn't seem worth it. It would mean
> adding yet another instance to the unittests.cfg. Since once needs to
> provide the memory for the registers even when the facility isn't
> there, there seems little risk for breaking something when we store if
> the facility isn't there.

I mean, technically we should check that nothing is stored for
facilities that are not present, but I guess it's not worth it=20
and that would indeed double the number of entries in unittests.cfg
