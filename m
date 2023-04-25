Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C136EE1BB
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 14:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbjDYMQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 08:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbjDYMQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 08:16:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF85768A;
        Tue, 25 Apr 2023 05:16:54 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PC8dTQ013661;
        Tue, 25 Apr 2023 12:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=wXMZBWEMyAjQ9rbqELa7u8zq65unSCwS3T+NYtYjWzY=;
 b=SpTjSPrZECSTn6FgFj0PtodlLnEBo+iGBy6KdUkdTdwkC4c4t0ufAsAUR5Yz5WKLrzqD
 rjRPWmRTKnBWzvH21PfxA0mglXWS1v/r2iEoV0l0nD8Mmf4OTgWiPIHiW8k31TBdUexK
 UZeOtSokYzmSj+xkk7SNWbE4D5hbdDvdDjrE7dmIffkUwbTc8y1PngI4Hqz4lRKtMYRF
 5FOM3jd1okUzDRmkWFkytKKizlXLi6EkmN1FDMRk3xdAcT+SVcaJAluidh3mE4PYTRd4
 ZRBKmvce1uFUQhMT88APOWyLt3VsSmbW7kwOHUJmvAl4t4ltOlGzvuod87TMAScEffQj dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6d30uyan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 12:16:53 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33PC8ZWD013540;
        Tue, 25 Apr 2023 12:16:48 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6d30uy49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 12:16:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33P6ZxgT012461;
        Tue, 25 Apr 2023 12:16:40 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3q47771e63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 12:16:40 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33PCGbHi27722160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 12:16:37 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1551A20043;
        Tue, 25 Apr 2023 12:16:37 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD5192004B;
        Tue, 25 Apr 2023 12:16:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Apr 2023 12:16:36 +0000 (GMT)
Date:   Tue, 25 Apr 2023 14:16:34 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        thuth@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: sclp: consider monoprocessor
 on read_info error
Message-ID: <20230425141634.1e18b172@p-imbrenda>
In-Reply-To: <bc3cf8c5-1aa9-0db3-c212-9c09554d4ab2@linux.ibm.com>
References: <20230424174218.64145-1-pmorel@linux.ibm.com>
        <20230424174218.64145-2-pmorel@linux.ibm.com>
        <20230425102606.4e9bc606@p-imbrenda>
        <5572f655-4cc8-500f-97fd-068c9f06a90b@linux.ibm.com>
        <738a8001-a651-8e69-7985-511c28fb0485@linux.ibm.com>
        <bc3cf8c5-1aa9-0db3-c212-9c09554d4ab2@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JlIRDY5ymaOEmCAOKATgjSUl7eSKEd-D
X-Proofpoint-GUID: Unpxum76un1HKrLHsS9Z6OxGnKqFUA8_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_05,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 malwarescore=0 bulkscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Apr 2023 13:45:13 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 4/25/23 13:33, Janosch Frank wrote:
> > On 4/25/23 12:53, Pierre Morel wrote: =20
> >>
> >> On 4/25/23 10:26, Claudio Imbrenda wrote: =20
> >>> On Mon, 24 Apr 2023 19:42:18 +0200
> >>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> >>> =20
> >
> > How is this considered to be a fix and not a workaround?
> >
> >
> > Set the variable response bit in the control mask and vary the length=20
> > based on stfle 140. See __init sclp_early_read_info() in=20
> > drivers/s390/char/sclp_early_core.c =20

I agree that the SCLP needs to be fixed

>=20
>=20
> Yes it is something to do anyway.
>=20
> Still in case of error we will need this fix or workaround.

and I agree that we need this fix anyway

therefore the comment should be more generic and just mention the fact
that the test would hang if an abort happens before SCLP Read SCP
Information has completed.

>=20
>=20
> >
> > =20
> >>> =20
> >>>> Fixes: 52076a63d569 ("s390x: Consolidate sclp read info")
> >>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >>>> ---
> >>>> =C2=A0=C2=A0 lib/s390x/sclp.c | 5 +++--
> >>>> =C2=A0=C2=A0 1 file changed, 3 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> >>>> index acdc8a9..c09360d 100644
> >>>> --- a/lib/s390x/sclp.c
> >>>> +++ b/lib/s390x/sclp.c
> >>>> @@ -119,8 +119,9 @@ void sclp_read_info(void)
> >>>> =C2=A0=C2=A0 =C2=A0=C2=A0 int sclp_get_cpu_num(void)
> >>>> =C2=A0=C2=A0 {
> >>>> -=C2=A0=C2=A0=C2=A0 assert(read_info);
> >>>> -=C2=A0=C2=A0=C2=A0 return read_info->entries_cpu;
> >>>> +=C2=A0=C2=A0=C2=A0 if (read_info)
> >>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return read_info->entrie=
s_cpu;
> >>>> +=C2=A0=C2=A0=C2=A0 return 1;
> >>>> =C2=A0=C2=A0 }
> >>>> =C2=A0=C2=A0 =C2=A0=C2=A0 CPUEntry *sclp_get_cpu_entries(void) =20
> > =20

