Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3579F53796E
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiE3KuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 06:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiE3KuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 06:50:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BCE6315;
        Mon, 30 May 2022 03:50:19 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UAhmKo028193;
        Mon, 30 May 2022 10:50:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=MutWBFgdQajv4cWl9VGj1cWcw0zh5nSYFbv2tC6k2kw=;
 b=qsk865PlVIaJxPgFBlYBs2jdCALuA/sd51eFqT95lM+YN/C3rBHAcPeTiScy3xpKDobz
 DNcmstijbE9qd4/RglIAtGUwNcdzx4zVADZK9bZsI6gNRoAv5Fk1grecbARYs0ChNFG0
 vduxF6zA9R+8vUoLlZfsX5ijfeNUEAPLsu1AQIqsnzSSFGC9aPOdl0OzOqA2H4e800aO
 FoAy+B3F0R49HdVxqyTq/lrtNuZ4ASE7JCJvgI5Lp1gDb16u+QSvVPfzcIqsdSN8FVHU
 HaGCbnPMge1pwGuSvxQ+5nxkR25X1rLR7FC/Kj2Zfc8bOcJtKLiPKzTXDtFd0oWp6fSi 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcve00322-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:50:18 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24UAng2X013762;
        Mon, 30 May 2022 10:50:17 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcve0031f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:50:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24UAZ5Ul017153;
        Mon, 30 May 2022 10:50:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3gbcae2k9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:50:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24UAoC8F50528652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 10:50:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A492111C054;
        Mon, 30 May 2022 10:50:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BD2E11C04A;
        Mon, 30 May 2022 10:50:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.149])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 10:50:11 +0000 (GMT)
Date:   Mon, 30 May 2022 12:50:09 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v10 04/19] KVM: s390: pv: refactor s390_reset_acc
Message-ID: <20220530125009.6107ae54@p-imbrenda>
In-Reply-To: <4aa518425958496e763294023ac950837ff8eac3.camel@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
        <20220414080311.1084834-5-imbrenda@linux.ibm.com>
        <6948806da404fd5822b59fd65b8a5a948e6bb317.camel@linux.ibm.com>
        <20220516181134.40652725@p-imbrenda>
        <4aa518425958496e763294023ac950837ff8eac3.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ytfN2_eZs0az-ZLtWkX0GOftsqK0Es1o
X-Proofpoint-ORIG-GUID: X0H5mNPvGxyIeufqncLbtEqIyQyfBz8g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 adultscore=0 malwarescore=0 mlxlogscore=975
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205300055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 May 2022 09:40:43 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Mon, 2022-05-16 at 18:11 +0200, Claudio Imbrenda wrote:
> [...]
> > > [...] =20
> > > > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > > > index e8904cb9dc38..a3a1f90f6ec1 100644
> > > > --- a/arch/s390/mm/gmap.c
> > > > +++ b/arch/s390/mm/gmap.c
> > > > @@ -2676,44 +2676,81 @@ void s390_reset_cmma(struct mm_struct
> > > > *mm)
> > > > =C2=A0}
> > > > =C2=A0EXPORT_SYMBOL_GPL(s390_reset_cmma);
> > > > =C2=A0
> > > > -/*
> > > > - * make inaccessible pages accessible again
> > > > - */
> > > > -static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 unsigned long next, struct mm_walk
> > > > *walk)
> > > > +#define DESTROY_LOOP_THRESHOLD 32=C2=A0  =20
> > >=20
> > > maybe GATHER_NUM_PAGE_REFS_TO_TAKE? =20
> >=20
> > what about GATHER_GET_PAGES ? =20
>=20
> Yes, that's good as well.

will be fixed
