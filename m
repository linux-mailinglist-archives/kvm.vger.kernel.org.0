Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224866E125B
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 18:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjDMQeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 12:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjDMQeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 12:34:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948D74697;
        Thu, 13 Apr 2023 09:33:57 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33DFR0LM008668;
        Thu, 13 Apr 2023 16:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8UvURWjIbi3vPUJoXCnoH6bT6eHTB470TjnIbB3Us9w=;
 b=kesBamIPiXOQYd4J3Flg8QXjVPmNC9Vh8rOU1Z5Nf7oV2hiwQSkUb24b7eas/o7jbh/R
 j99TQxrQGsvhWGvLrpzkgaJ/XTDv7bG17j2o36MKJJ7Q/CkeIbGOXaIYAAGBQLs7mN69
 gWrIg4PM+2qghuKYHWaVdkBrVuc1z8pz2yxxwdP8jY/Ncxk6HRkyazj8MKg0WysfaS4C
 AVLFu3j3g+BnZhykfZTErLWy0rraX6h9GgYq4fAcPD8MdXBJeLWoshkNINlcpbobwxc4
 9RzVv4cvcdy6SNkFrqF2r29gl8eGaIdIE85nHyL1XIvScljBeBnmuq4ZS1yqMqQUBqGl Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pxmd02sqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Apr 2023 16:33:57 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33DGSxtd030658;
        Thu, 13 Apr 2023 16:33:56 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pxmd02sp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Apr 2023 16:33:56 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33D3xELG026645;
        Thu, 13 Apr 2023 16:33:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3pu0fvtncw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Apr 2023 16:33:54 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33DGXoLD27525448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 16:33:50 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8851A2004E;
        Thu, 13 Apr 2023 16:33:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E2142004B;
        Thu, 13 Apr 2023 16:33:50 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.152.224.238])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Apr 2023 16:33:50 +0000 (GMT)
Message-ID: <5b2e0a52c79122038cda60661c225e9d108e60ef.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add a test for SIE without
 MSO/MSL
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Thu, 13 Apr 2023 18:33:50 +0200
In-Reply-To: <168137900094.42330.6464555141616427645@t14-nrb>
References: <20230327082118.2177-1-nrb@linux.ibm.com>
         <20230327082118.2177-5-nrb@linux.ibm.com>
         <cfd83c1d7a74e969e6e3c922bbe5650f8e9adadd.camel@linux.ibm.com>
         <168137900094.42330.6464555141616427645@t14-nrb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vcn2Twta8rFE3I-KioUGbWEnA-JqAdWE
X-Proofpoint-ORIG-GUID: E5JQEAUTaJ5oGNTiNcihTzX245c9lCDN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-13_11,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304130147
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-04-13 at 11:43 +0200, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2023-04-05 21:55:01)
> > On Mon, 2023-03-27 at 10:21 +0200, Nico Boehr wrote:
> > > Since we now have the ability to run guests without MSO/MSL, add a te=
st
> > > to make sure this doesn't break.
> > >=20
> > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > ---
> > >  s390x/Makefile             |   2 +
> > >  s390x/sie-dat.c            | 121 +++++++++++++++++++++++++++++++++++=
++
> > >  s390x/snippets/c/sie-dat.c |  58 ++++++++++++++++++
> > >  s390x/unittests.cfg        |   3 +
> > >  4 files changed, 184 insertions(+)
> > >  create mode 100644 s390x/sie-dat.c
> > >  create mode 100644 s390x/snippets/c/sie-dat.c
> > >=20
> >=20
> > Test looks good to me. Some comments below.
> > [...]
> >=20
> > > diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> > > new file mode 100644
> > > index 000000000000..37e46386181c
> > > --- /dev/null
> > > +++ b/s390x/sie-dat.c
> > > @@ -0,0 +1,121 @@
> > >=20
> > [...]
> > > +
> > > +/* keep in sync with TOTAL_PAGE_COUNT in s390x/snippets/c/sie-dat.c =
*/
> > > +#define GUEST_TOTAL_PAGE_COUNT 256
> >=20
> > This (1M) is the maximum snippet size (see snippet_setup_guest), is thi=
s intentional?
>=20
> It is by accident the maximum snippet size. It is completely fine to stay=
 at 256 pages when we increase the maximum snippet size.
>=20
> > In that case the comment is inaccurate, since you'd want to sync it wit=
h the maximum snippet size.
> > You also know the actual snippet size SNIPPET_LEN(c, sie_dat) so I don'=
t see why you'd need a define
> > at all.
>=20
> The snippet size is not the same as the number of mapped pages in the gue=
st, no?

No, but one probably wouldn't want to map less that the snippet size.
And there probably isn't a reason to map more either.

[...]

>=20
> > > +     /* the first unmapped address */
> > > +     invalid_ptr =3D (uint8_t *)(TOTAL_PAGE_COUNT * PAGE_SIZE);
> >=20
> > Why not just use an address high enough you know it will not be mapped?
> > -1 should do just fine.
>=20
> I wanted to make sure exactly the right amount of pages is mapped and no =
more.
>=20
> -1 would defeat that purpose.

You want to touch the first page that isn't mapped?
Do you also want to map a certain number of pages?
I.e fill an entire page table and have the invalid pointer be mapped by ano=
ther segment table entry?

With a small linker script change the snippet could know it's own length.
Then you could map just the required number of pages and don't need to keep=
 those numbers in sync.

