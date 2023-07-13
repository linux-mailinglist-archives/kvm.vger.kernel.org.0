Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7818F752720
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 17:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjGMPce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 11:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjGMPcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 11:32:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021EF2707;
        Thu, 13 Jul 2023 08:31:48 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DFH5XX012668;
        Thu, 13 Jul 2023 15:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=M7bR/AAwcrIHtmLFDAbS3L59wYDPg1gKiTx7XoppcMk=;
 b=oIgR/9s0d64lh2+i06y2sKDCxaKPmRw82VVIPTwfXNKFunYfFDjpi5KJ+gCftsNFLaZE
 7ocp8nsccBVmm58TanQL361N8sebOGvGjn8zoAidaIbdVJZUunP4DTUiW1mWKLksg5yl
 UifqMOhpiKDzJN0jiGd4O1KUG5/as5mbAwGzjuwA6cr64YlQ8MzGbFsRfN7CVEvRYGKV
 2oO+gSNKLgohP/IYG1LCn6l+quN0XDsDwZjKGuk2qYJV6GWi38aokgvNqUrlIs0Wu9ns
 lwhUKsgXVs51HIwtq5OS3w81vn0U43eW86MrjsOURZtxr2SeErr9E87WeyE6Jy0q4BR4 Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtksagbga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 15:30:53 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36DFHpYd013705;
        Thu, 13 Jul 2023 15:30:52 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtksagbg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 15:30:52 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36DDtoEZ005042;
        Thu, 13 Jul 2023 15:30:51 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rqj4rr8ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 15:30:51 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36DFUmu526346134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 15:30:49 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3E0A20043;
        Thu, 13 Jul 2023 15:30:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4DB720040;
        Thu, 13 Jul 2023 15:30:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.87.199])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jul 2023 15:30:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <9b2cdc37-0b93-ff00-d077-397b8c0c2950@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com> <20230712114149.1291580-3-nrb@linux.ibm.com> <9b2cdc37-0b93-ff00-d077-397b8c0c2950@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 2/6] s390x: add function to set DAT mode for all interrupts
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Message-ID: <168926224829.12187.2957278869966216471@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 13 Jul 2023 17:30:48 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vGonXpMmOoyNlYEuwQvo-EubDH5Zqz97
X-Proofpoint-ORIG-GUID: 6IS-QsscQ9uUxl3I8e91_JrujoJpkcdn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_05,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-07-13 09:17:28)
> On 12/07/2023 13.41, Nico Boehr wrote:
> > When toggling DAT or switch address space modes, it is likely that
> > interrupts should be handled in the same DAT or address space mode.
> >=20
> > Add a function which toggles DAT and address space mode for all
> > interruptions, except restart interrupts.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   lib/s390x/asm/interrupt.h |  4 ++++
> >   lib/s390x/interrupt.c     | 36 ++++++++++++++++++++++++++++++++++++
> >   lib/s390x/mmu.c           |  5 +++--
> >   3 files changed, 43 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> > index 35c1145f0349..55759002dce2 100644
> > --- a/lib/s390x/asm/interrupt.h
> > +++ b/lib/s390x/asm/interrupt.h
> > @@ -83,6 +83,10 @@ void expect_ext_int(void);
> >   uint16_t clear_pgm_int(void);
> >   void check_pgm_int_code(uint16_t code);
> >  =20
> > +#define IRQ_DAT_ON   true
> > +#define IRQ_DAT_OFF  false
>=20
> Just a matter of taste, but IMHO having defines like this for just using =

> them as boolean parameter to one function is a little bit overkill alread=
y.=20
> I'd rather rename the "bool dat" below into "bool use_dat" and then use=20
> "true" and "false" directly as a parameter for that function instead.=20
> Anyway, just my 0.02 \u20ac.

The point of having these defines was to convey the meaning of the paramete=
r to my reader.

When I read

    irq_set_dat_mode(true, AS_HOME);

it's less clear to me that the first parameter toggles the DAT mode compare=
d to this:

    irq_set_dat_mode(IRQ_DAT_ON, AS_HOME);

That being said, here it's pretty clear from the function name what the fir=
st parameter is, so what's the preferred opinion?

[...]
> > diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> > index 3f993a363ae2..9b1bc6ce819d 100644
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
> > @@ -104,6 +105,41 @@ void register_ext_cleanup_func(void (*f)(struct st=
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

Argh, thanks.

*reprioritizes task to look for a spell checker*

>=20
> > + * to initalize CRs, the restart new PSW is never touched to avoid the=
 chicken
>=20
> dito
>=20
> > + * and egg situation.
> > + *
> > + * @dat specifies whether to use DAT or not
> > + * @as specifies the address space mode to use - one of AS_PRIM, AS_AC=
CR,
> > + * AS_SECN or AS_HOME.
> > + */
> > +void irq_set_dat_mode(bool dat, uint64_t as)
>=20
> why uint64_t for "as" ? "int" should be enough?
>=20
> (alternatively, you could turn the AS_* defines into a properly named enu=
m=20
> and use that type here instead)

Yes, let's just do that.
