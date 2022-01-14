Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B8148EA7A
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241189AbiANNTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:19:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbiANNTn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 08:19:43 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20E9rPNJ017316;
        Fri, 14 Jan 2022 13:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mGyy2zButlsgnRo+hUd/UFmZ2O/1MYSILLQk4XEIJ0M=;
 b=dEpw9bHsRumDoPwmxkT2DRuOtLy2b0UsUInN8NbzWS+Y2wEsn9YSBZJDSkyz+tvUK+7k
 jIC4gjsRjkGwMoGJsxK6dADz/8LfXUbXKFaK/aXc59wt9kXCy+vPxcbTnxXxlw2rTVyi
 R60zr3espoy6K5C0XUF+d5+MEPIAuuX93XTBZ3es6FKOIHcnkwg+5euzH8tHrY6yY/w4
 rfkvkIA4sk6rj6ab28g280mECe9TZvGSEHdog+KFdVPiM6/lkW9sPiLHw6mYZnrg+jBN
 zrwOYffOXHNCo9bQN+rKJ7lXAnlOMeav28o7++BDTXQAoLqJTyKX3h2b/uEWGfwZI5j0 SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk6xmkedq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:19:43 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EDBbtH025064;
        Fri, 14 Jan 2022 13:19:42 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk6xmkeda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:19:42 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EDDSQl024885;
        Fri, 14 Jan 2022 13:19:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3df28a3n2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:19:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EDJbYP39452938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 13:19:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A837A405B;
        Fri, 14 Jan 2022 13:19:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2484A4055;
        Fri, 14 Jan 2022 13:19:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 13:19:36 +0000 (GMT)
Date:   Fri, 14 Jan 2022 14:19:34 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: smp: Allocate memory in DMA31
 space
Message-ID: <20220114141934.6573d1f5@p-imbrenda>
In-Reply-To: <1106299d-e183-b4dc-5c71-d2b30a656c08@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
        <20220114100245.8643-5-frankja@linux.ibm.com>
        <f840f66aa615ce167187754842268662cd466b92.camel@linux.ibm.com>
        <20220114140123.10bf0406@p-imbrenda>
        <1106299d-e183-b4dc-5c71-d2b30a656c08@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EBbo42j8AR4T4c_XGpziXQVar9ein0tn
X-Proofpoint-ORIG-GUID: tBV_GilcTpjx6EDN3rYfpKz6NXGQ5WtU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201140088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 14:13:01 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/14/22 14:01, Claudio Imbrenda wrote:
> > On Fri, 14 Jan 2022 13:50:52 +0100
> > Nico Boehr <nrb@linux.ibm.com> wrote:
> >  =20
> >> On Fri, 2022-01-14 at 10:02 +0000, Janosch Frank wrote: =20
> >>> The store status at address order works with 31 bit addresses so
> >>> let's
> >>> use them.
> >>>
> >>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >>> ---
> >>>  =C2=A0s390x/smp.c | 4 ++--
> >>>  =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/s390x/smp.c b/s390x/smp.c
> >>> index 32f128b3..c91f170b 100644
> >>> --- a/s390x/smp.c
> >>> +++ b/s390x/smp.c =20
> >>
> >> [...]
> >> =20
> >>> @@ -244,7 +244,7 @@ static void test_func_initial(void)
> >>>  =20
> >>>  =C2=A0static void test_reset_initial(void)
> >>>  =C2=A0{
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct cpu_status *status =
=3D alloc_pages(0);
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct cpu_status *status =
=3D alloc_pages_flags(1, AREA_DMA31); =20
> >>
> >> Why do we need two pages now? =20
> >=20
> > actually, wait.....
> >=20
> >          struct cpu_status *status =3D alloc_pages_flags(1, AREA_DMA31);
> >          uint32_t r;
> >=20
> >          report_prefix_push("store status at address");
> >          memset(status, 0, PAGE_SIZE * 2);
> >=20
> > we were allocating one page, and using 2!
> >=20
> > @Janosch do we need 1 or 2 pages?
> >  =20
>=20
> Have a look at the memcmp() below those lines.
>=20
> I test if the status page has changed by doing a memcmp against the=20
> second page.

ENOCOFEE

sorry I mixed things up

we were using 2, it's the second part of the patch that only needs one


