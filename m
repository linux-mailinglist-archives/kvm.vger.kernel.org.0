Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E517F751D1B
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjGMJZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjGMJZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:25:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8854C211F;
        Thu, 13 Jul 2023 02:25:48 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36D9HAr0008323;
        Thu, 13 Jul 2023 09:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=RQrwUJQCIX3AGQexJSBLh4onsMYx0LTKFLr4ipeMdS8=;
 b=DvdEXOUu8lAnOKUt+OYdtML8lmoVZZx/ZuP0Pd6qqqnPiV11ARXu/KBsl0I/84oMFwQp
 GihcEZ/8Ec0hAlbk7gsGZ7c0WXTiYhuAxK6oHD4F5SL9CTUB4B3BbLYz/Wc3s/aXZ1Z1
 a229HOOEYl9CPheo93pBX24XcdD16Ps/eZYlhf4Y2jZox2ZVx3rnezZO3l9GLi6NL7ZM
 J2F8I3UZrx9b3tO/6EQISxf6xrfOtNr7DenRuhjAV+ePITzsktkNHLzoH/wybP+jUsel
 6vy4oKkRlGzQaEfuhWO+7NN9rsrajnLr70KNS/rBwp1xwaAxnrsCq6yjWi5lOHHSdDG7 xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtegf073a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 09:25:47 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36D9IGrq011802;
        Thu, 13 Jul 2023 09:25:46 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtegf072t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 09:25:46 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36D9PjuR001058;
        Thu, 13 Jul 2023 09:25:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rpye5a9vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 09:25:44 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36D9Pf9d50397494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 09:25:41 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DCC020040;
        Thu, 13 Jul 2023 09:25:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B5262004B;
        Thu, 13 Jul 2023 09:25:40 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.40.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jul 2023 09:25:40 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <53d9d63f-e207-23a6-faea-8bad8b22a375@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com> <20230712114149.1291580-2-nrb@linux.ibm.com> <53d9d63f-e207-23a6-faea-8bad8b22a375@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 1/6] lib: s390x: introduce bitfield for PSW mask
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Message-ID: <168924033930.12187.7570757062532399357@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 13 Jul 2023 11:25:39 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XlUO4s_eBYGLrEETeaoPze2g-z8WG7rM
X-Proofpoint-ORIG-GUID: 8y5_E4dstqoFZZumEGuV3N-W4QJyxur_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_04,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=784 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307130078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-07-13 08:56:41)
> On 12/07/2023 13.41, Nico Boehr wrote:
> > Changing the PSW mask is currently little clumsy, since there is only t=
he
> > PSW_MASK_* defines. This makes it hard to change e.g. only the address
> > space in the current PSW without a lot of bit fiddling.
> >=20
> > Introduce a bitfield for the PSW mask. This makes this kind of
> > modifications much simpler and easier to read.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   lib/s390x/asm/arch_def.h | 26 +++++++++++++++++++++++++-
> >   s390x/selftest.c         | 40 ++++++++++++++++++++++++++++++++++++++++
> >   2 files changed, 65 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> > index bb26e008cc68..53279572a9ee 100644
> > --- a/lib/s390x/asm/arch_def.h
> > +++ b/lib/s390x/asm/arch_def.h
> > @@ -37,12 +37,36 @@ struct stack_frame_int {
> >   };
> >  =20
> >   struct psw {
> > -     uint64_t        mask;
> > +     union {
> > +             uint64_t        mask;
> > +             struct {
> > +                     uint8_t reserved00:1;
> > +                     uint8_t per:1;
> > +                     uint8_t reserved02:3;
> > +                     uint8_t dat:1;
> > +                     uint8_t io:1;
> > +                     uint8_t ext:1;
> > +                     uint8_t key:4;
> > +                     uint8_t reserved12:1;
> > +                     uint8_t mchk:1;
> > +                     uint8_t wait:1;
> > +                     uint8_t pstate:1;
> > +                     uint8_t as:2;
> > +                     uint8_t cc:2;
> > +                     uint8_t prg_mask:4;
> > +                     uint8_t reserved24:7;
> > +                     uint8_t ea:1;
> > +                     uint8_t ba:1;
> > +                     uint32_t reserved33:31;
> > +             };
> > +     };
> >       uint64_t        addr;
> >   };
> > +_Static_assert(sizeof(struct psw) =3D=3D 16, "PSW size");
> >  =20
> >   #define PSW(m, a) ((struct psw){ .mask =3D (m), .addr =3D (uint64_t)(=
a) })
> >  =20
> > +
> >   struct short_psw {
> >       uint32_t        mask;
> >       uint32_t        addr;
> > diff --git a/s390x/selftest.c b/s390x/selftest.c
> > index 13fd36bc06f8..8d81ba312279 100644
> > --- a/s390x/selftest.c
> > +++ b/s390x/selftest.c
> > @@ -74,6 +74,45 @@ static void test_malloc(void)
> >       report_prefix_pop();
> >   }
> >  =20
> > +static void test_psw_mask(void)
> > +{
> > +     uint64_t expected_key =3D 0xF;
> > +     struct psw test_psw =3D PSW(0, 0);
> > +
> > +     report_prefix_push("PSW mask");
> > +     test_psw.dat =3D 1;
> > +     report(test_psw.mask =3D=3D PSW_MASK_DAT, "DAT matches expected=
=3D0x%016lx actual=3D0x%016lx", PSW_MASK_DAT, test_psw.mask);
> > +
> > +     test_psw.mask =3D 0;
> > +     test_psw.io =3D 1;
> > +     report(test_psw.mask =3D=3D PSW_MASK_IO, "IO matches expected=3D0=
x%016lx actual=3D0x%016lx", PSW_MASK_IO, test_psw.mask);
> > +
> > +     test_psw.mask =3D 0;
> > +     test_psw.ext =3D 1;
> > +     report(test_psw.mask =3D=3D PSW_MASK_EXT, "EXT matches expected=
=3D0x%016lx actual=3D0x%016lx", PSW_MASK_EXT, test_psw.mask);
> > +
> > +     test_psw.mask =3D expected_key << (63 - 11);
> > +     report(test_psw.key =3D=3D expected_key, "PSW Key matches expecte=
d=3D0x%lx actual=3D0x%x", expected_key, test_psw.key);
>=20
> Patch looks basically fine to me, but here my mind stumbled a little bit.=
=20
> This test is written the other way round than the others. Nothing wrong w=
ith=20
> that, it just feels a little bit inconsistent. I'd suggest to either do:
>=20
>         test_psw.mask =3D 0;
>         test_psw.key =3D expected_key;
>         report(test_psw.mask =3D=3D expected_key << (63 - 11), ...);
>=20
> or maybe even switch all the other tests around instead, so you could get=
=20
> rid of the "test_psw.mask =3D 0" lines, e.g. :
>=20
>         test_psw.mask =3D=3D PSW_MASK_IO;
>         report(test_psw.io, "IO matches ...");
>=20
> etc.

I like the latter option, thanks.
