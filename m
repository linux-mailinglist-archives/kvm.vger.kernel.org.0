Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8326B9DBC
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 19:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjCNSAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 14:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjCNSAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 14:00:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69C4580E2;
        Tue, 14 Mar 2023 11:00:00 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EGvIJ6019637;
        Tue, 14 Mar 2023 18:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=o/uokCfmjiNpAwenodUnKUEoNjkXefiEagmLlW92Nck=;
 b=ZfZYChcORARrOFJTxfeApfxEG5e8D1D6y/4AdZtD1NaBwyWw5VdAV6TK5cm3h6JQXAvf
 7uFuuuS2QSvJipdQHotRntpzxscFmhFhnNNxfzEjjjS+IzPG5+7xAU8j6aeOvXNuIJK/
 tgsbC39RZeoo48qTTHhEuywYecHGTJvfSob5aXPWgPVTVe7ul3md7+0vgpSoMCaZdLgo
 yA/7zVLSms0fpYQTwl3C7XxqAO3p4hvFIG7STB3LEMA8yjh+H2SXTticeysZ1+1X/A9J
 EbYfsuxmEQw0vBo+8lGVsoCqoWZBbID4iCzwESnJPAwh/V842tvEdKQt+8+cblB3GrT6 zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pavw9hpk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 18:00:00 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32EGx6R3029994;
        Tue, 14 Mar 2023 17:59:59 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pavw9hpj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 17:59:59 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32E8vT26013644;
        Tue, 14 Mar 2023 17:59:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3p8h96c49q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 17:59:57 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32EHxrIR17236562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 17:59:54 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEC3920043;
        Tue, 14 Mar 2023 17:59:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4A872004B;
        Tue, 14 Mar 2023 17:59:53 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.152.224.238])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Mar 2023 17:59:53 +0000 (GMT)
Message-ID: <bfac125f07863a22ed3a267785560a2a0b4c8358.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x/spec_ex: Add test of
 EXECUTE with odd target address
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 14 Mar 2023 18:59:53 +0100
In-Reply-To: <20230314181221.6df1e4bd@p-imbrenda>
References: <20230221174822.1378667-1-nsg@linux.ibm.com>
         <20230221174822.1378667-4-nsg@linux.ibm.com>
         <20230314162526.519364c5@p-imbrenda>
         <3976942b40bfb2c2a222d251db1629df7b6819c2.camel@linux.ibm.com>
         <20230314181221.6df1e4bd@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tUpNdLfRNhpb3KBfVYoMOXY_n1cBLUXa
X-Proofpoint-ORIG-GUID: Al2YosQHUMzo8-Z07l2WSXKdEyIl0lsc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_10,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-03-14 at 18:12 +0100, Claudio Imbrenda wrote:
> On Tue, 14 Mar 2023 17:41:24 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > On Tue, 2023-03-14 at 16:25 +0100, Claudio Imbrenda wrote:
> > > On Tue, 21 Feb 2023 18:48:22 +0100
> > > Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> > >  =20
> > > > The EXECUTE instruction executes the instruction at the given targe=
t
> > > > address. This address must be halfword aligned, otherwise a
> > > > specification exception occurs.
> > > > Add a test for this.
> > > >=20
> > > > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > > > ---
> > > >  s390x/spec_ex.c | 25 +++++++++++++++++++++++++
> > > >  1 file changed, 25 insertions(+)
> > > >=20
> > > > diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> > > > index a26c56aa..dd097f9b 100644
> > > > --- a/s390x/spec_ex.c
> > > > +++ b/s390x/spec_ex.c
> > > > @@ -177,6 +177,30 @@ static int short_psw_bit_12_is_0(void)
> > > >  	return 0;
> > > >  }
> > > > =20
> > > > +static int odd_ex_target(void)
> > > > +{
> > > > +	uint64_t pre_target_addr;
> > > > +	int to =3D 0, from =3D 0x0dd;
> > > > +
> > > > +	asm volatile ( ".pushsection .rodata\n" =20
> > >=20
> > > and this should go in a .text.something subsection, as we discussed
> > > offline =20
> >=20
> > Yes.
> > >  =20
> > > > +		"pre_odd_ex_target:\n" =20
> > >=20
> > > shouldn't the label be after the align? =20
> >=20
> > No, larl needs an aligned address, and the ex below adds 1.
> > That's why it has the pre_ prefix, it's not the ex target itself.
>=20
> I understand that, but=20
> > >  =20
> > > > +		"	.balign	2\n" =20
>=20
> doesn't the address get aligned here?
> so the label here would be aligned to 2

Uh, yeah, sorry.
>=20
> > >=20
> > > (i.e. here)
> > >  =20
> > > > +		"	. =3D . + 1\n"
>=20
> and here it gets the +1?
>=20
> > > > +		"	lr	%[to],%[from]\n"
> > > > +		"	.popsection\n"
> > > > +
> > > > +		"	larl	%[pre_target_addr],pre_odd_ex_target\n"
> > > > +		"	ex	0,1(%[pre_target_addr])\n"
> > > > +		: [pre_target_addr] "=3D&a" (pre_target_addr),
> > > > +		  [to] "+d" (to)
> > > > +		: [from] "d" (from)
> > > > +	);
> > > > +
> > > > +	assert((pre_target_addr + 1) & 1);
> > > > +	report(to !=3D from, "did not perform ex with odd target");
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  static int bad_alignment(void)
> > > >  {
> > > >  	uint32_t words[5] __attribute__((aligned(16)));
> > > > @@ -218,6 +242,7 @@ static const struct spec_ex_trigger spec_ex_tri=
ggers[] =3D {
> > > >  	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw =
},
> > > >  	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_=
invalid_psw },
> > > >  	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw =
},
> > > > +	{ "odd_ex_target", &odd_ex_target, true, NULL },
> > > >  	{ "bad_alignment", &bad_alignment, true, NULL },
> > > >  	{ "not_even", &not_even, true, NULL },
> > > >  	{ NULL, NULL, false, NULL }, =20
> > >  =20
> >=20
>=20

