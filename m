Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D46448EA43
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241148AbiANNBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:01:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28228 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235107AbiANNBf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 08:01:35 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EBvqP0020762;
        Fri, 14 Jan 2022 13:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=icOy2fM80h5sQ2FnAfa96cl17OXMQJ+rd/uso+7fqJ4=;
 b=f25H0gZogzHz7I/6QI3vUMQgFm861RfYgr1W4oqGLVe/g6evQ+r/akJMsh9tTNcVNDGx
 AmJhgBidI6tqBOzahkDfTvwvyxYXyTIsZKit4xdqTgLa0+GV8PGCUIz8xxt1Dk5PM8Dz
 Nv0iBxtCxf1votElJKYokxJdcJRzhVF8wlYcZD7xD27ooORyibsj5r+x3iIjO7JzOb9s
 aGj48wUR5+JjgHNWSwPglF6iURQOEV8sw0ZhEqI80IsQkFUW5iJbp9E2FnumBTax2cYz
 3L7dcLXgIC7BTLGwi3BYrSlTNpWcPzboIUH43mgX4Z6jd3lySNskxPS1XUXTeTUceCew lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk8rvh3vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:01:34 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ECvB43004956;
        Fri, 14 Jan 2022 13:01:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk8rvh3v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:01:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ECv0fY029711;
        Fri, 14 Jan 2022 13:01:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3df28aeb9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:01:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ED1Qhn14746030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 13:01:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CAA7A4078;
        Fri, 14 Jan 2022 13:01:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27E80A4055;
        Fri, 14 Jan 2022 13:01:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 13:01:26 +0000 (GMT)
Date:   Fri, 14 Jan 2022 14:01:23 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: smp: Allocate memory in DMA31
 space
Message-ID: <20220114140123.10bf0406@p-imbrenda>
In-Reply-To: <f840f66aa615ce167187754842268662cd466b92.camel@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
        <20220114100245.8643-5-frankja@linux.ibm.com>
        <f840f66aa615ce167187754842268662cd466b92.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e3GnnXu2voXqKzXby4m2iGiXjWaYjZrw
X-Proofpoint-ORIG-GUID: jNrdFLQ0CGtYCq8wo-cfKCo7MZVcvfT2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 13:50:52 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Fri, 2022-01-14 at 10:02 +0000, Janosch Frank wrote:
> > The store status at address order works with 31 bit addresses so
> > let's
> > use them.
> >=20
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> > =C2=A0s390x/smp.c | 4 ++--
> > =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/s390x/smp.c b/s390x/smp.c
> > index 32f128b3..c91f170b 100644
> > --- a/s390x/smp.c
> > +++ b/s390x/smp.c =20
>=20
> [...]
>=20
> > @@ -244,7 +244,7 @@ static void test_func_initial(void)
> > =C2=A0
> > =C2=A0static void test_reset_initial(void)
> > =C2=A0{
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct cpu_status *status =
=3D alloc_pages(0);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct cpu_status *status =
=3D alloc_pages_flags(1, AREA_DMA31); =20
>=20
> Why do we need two pages now?

actually, wait.....

        struct cpu_status *status =3D alloc_pages_flags(1, AREA_DMA31);
        uint32_t r;

        report_prefix_push("store status at address");
        memset(status, 0, PAGE_SIZE * 2);

we were allocating one page, and using 2!

@Janosch do we need 1 or 2 pages?
