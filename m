Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8A3731929
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 14:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245128AbjFOMqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 08:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243609AbjFOMqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 08:46:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA1F2125;
        Thu, 15 Jun 2023 05:46:49 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FCjj40021900;
        Thu, 15 Jun 2023 12:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=Ue23MMS/KLhfTkpn9HlmWTPika0I59eD8vRkzpnGfns=;
 b=EriS5gAWOQdmSf6EESkwcN8lTUgl5S3VEo4o2eb37WFOLm+oIJJ4hIi/9Nv4hph5FqYd
 /hZjKyj0is/PoakjKeKZas2g0YvYnlmdns9LfLRjnWAnbHjHQatNeO9NyS/YRLPeA2bQ
 zux7lGfvd/F44ydyLIi6eL12NfIKcxpyISUn7RoPkCVq06l6B+wKLb2aXfcXY/9JA4EW
 43YDRlKpwADnDl15ofZB+I4jY2b/khqFYG6c7LM8cMC1wB+ie9UmtEynS0AdjfBXSKSz
 yTn12S3+GBMFbMb9c8SEQPlo8+AbuLoVuuPMZSyvw5ZNZpsQMqTd3GZU3sYpnwqv0YQO 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r828799ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 12:46:45 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35FCjqCM022462;
        Thu, 15 Jun 2023 12:45:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r828796g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 12:45:46 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35F3jd2m020984;
        Thu, 15 Jun 2023 12:44:44 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3r4gt53kxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 12:44:44 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35FCieLA58720684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 12:44:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EC972004D;
        Thu, 15 Jun 2023 12:44:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E6352004B;
        Thu, 15 Jun 2023 12:44:40 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.73.29])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jun 2023 12:44:40 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e9be6bfb-344c-efb5-9019-355ecb54b5aa@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com> <20230601070202.152094-3-nrb@linux.ibm.com> <e9be6bfb-344c-efb5-9019-355ecb54b5aa@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 2/6] s390x: add function to set DAT mode for all interrupts
Message-ID: <168683308001.207611.15662962385387383765@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 15 Jun 2023 14:44:40 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R56rRYlu5ZnXZ22E4aAA_853qpcGLKAq
X-Proofpoint-GUID: 4mCdi3GQFJ-NOQzK4t5NQYM2XUBrMhk7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-15_08,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-06-05 10:42:40)
> On 6/1/23 09:01, Nico Boehr wrote:
> > When toggling DAT or switch address space modes, it is likely that
>=20
> s/switch/switching/

Done=20

[...]
> > diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> > index 3f993a363ae2..d97b5a3a7e97 100644
> > --- a/lib/s390x/interrupt.c
> > +++ b/lib/s390x/interrupt.c
> > @@ -9,6 +9,7 @@
> >    */
> >   #include <libcflat.h>
> >   #include <asm/barrier.h>
> > +#include <asm/mem.h>
> >   #include <asm/asm-offsets.h>
> >   #include <sclp.h>
> >   #include <interrupt.h>
> > @@ -104,6 +105,40 @@ void register_ext_cleanup_func(void (*f)(struct st=
ack_frame_int *))
> >       THIS_CPU->ext_cleanup_func =3D f;
> >   }
> >  =20
> > +/**
> > + * irq_set_dat_mode - Set the DAT mode of all interrupt handlers, exce=
pt for
> > + * restart.
> > + * This will update the DAT mode and address space mode of all interru=
pt new
> > + * PSWs.
> > + *
> > + * Since enabling DAT needs initalized CRs and the restart new PSW is =
often used
>=20
> s/initalized/initialized/

fixed

> > +void irq_set_dat_mode(bool dat, uint64_t as)
> > +{
> > +     struct psw* irq_psws[] =3D {
> > +             OPAQUE_PTR(GEN_LC_EXT_NEW_PSW),
> > +             OPAQUE_PTR(GEN_LC_SVC_NEW_PSW),
> > +             OPAQUE_PTR(GEN_LC_PGM_NEW_PSW),
> > +             OPAQUE_PTR(GEN_LC_MCCK_NEW_PSW),
> > +             OPAQUE_PTR(GEN_LC_IO_NEW_PSW),
> > +             NULL /* sentinel */
> > +     };
> > +
> > +     assert(as =3D=3D AS_PRIM || as =3D=3D AS_ACCR || as =3D=3D AS_SEC=
N || as =3D=3D AS_HOME);
>=20
> /* There are only 4 spaces */
> assert(as < 4); ?

Well you won't find that when when grepping for any of the AS_*, so no I do=
n't
think that's better.

> > +
> > +     for (struct psw *psw =3D irq_psws[0]; psw !=3D NULL; psw++) {
>=20
> While this is ok in gnu99/c99 I generally prefer declaring the variable=20
> outside of the loop since it's more readable when using structs and union=
s.

OK.

>=20
> > +             psw->dat =3D dat;
> > +             if (dat)
> > +                     psw->as =3D as;
>=20
> Does that check even matter?

Well, when DAT is off, AS bacially becomes a don't care. I thought it's a g=
ood
idea to preserve the AS in this case, but this can certainly be argued abou=
t.

I updated the comment and clarified that AS is only touched if DAT is on. L=
et me
know if you prefer removal of the if.
