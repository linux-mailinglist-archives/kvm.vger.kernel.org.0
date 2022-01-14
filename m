Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA7A48EA3B
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 13:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241158AbiANM5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 07:57:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235107AbiANM5V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 07:57:21 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ECLWDf031586;
        Fri, 14 Jan 2022 12:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/w2AsGJU3pvaEaSADVB3+oeiCSnJECaY0YEloaUwah4=;
 b=ACxGkztAiX5bok1rSCh0E1Pqmehe0rW/vv3G+cTibt16x4BVIE8H2MLGdjZPZW6RP91s
 4TybyytP19OJYsTp0kccHo61QSJzFTHN6uv48KSpVi/sM0VvbyJmJVWutY3DJ6RzUEyb
 VUXlYE4WUax3/KjDOsNKdoFmFlD4wFHF7ACpOEo/MyF50BM0xzQi+k8Lcc6/cZLHge2A
 UBlsBTZiFLoj+ROX0DVbVFE2Ca3awCAkxBPXrFQgrZ7b5BauFIzwhd12ttT8Uwbkyy/O
 tkQ3Kw/rGNQ4BDX+zjw9iwvz8/2e9hdEH0m/GA6U64mpLIvyGc+w2UWoX6vGE1Tcdl8f 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk9420jtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:57:21 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ECiaf6003993;
        Fri, 14 Jan 2022 12:57:21 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk9420jt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:57:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ECux2m000622;
        Fri, 14 Jan 2022 12:57:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vjxeqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:57:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ECvEGp45089136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 12:57:14 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DCA011C066;
        Fri, 14 Jan 2022 12:57:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33F4A11C052;
        Fri, 14 Jan 2022 12:57:14 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 12:57:14 +0000 (GMT)
Date:   Fri, 14 Jan 2022 13:57:12 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: smp: Allocate memory in DMA31
 space
Message-ID: <20220114135712.6473723a@p-imbrenda>
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
X-Proofpoint-GUID: 0uqzGAInqQqW02dU5TongbZv2nnYrRz7
X-Proofpoint-ORIG-GUID: uRz5bCgI7WlmViKnaKoA8UB3PeM3_7-x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201140083
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

oh, good catch

the next patch has the same issue

I can fix them up when I queue them
