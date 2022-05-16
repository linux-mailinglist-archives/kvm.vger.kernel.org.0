Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272AD5289E1
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244349AbiEPQLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 12:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236231AbiEPQLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 12:11:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C8D381BD;
        Mon, 16 May 2022 09:11:43 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GFlWun022190;
        Mon, 16 May 2022 16:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=GOINm4iGy/8EjlIRjqhfX+GsqOsUpwjHjDIg/ubaWJw=;
 b=E7tEH4vLcR/QjisobGo/RhKqL2AEPkejPA/o29qCJHeoXh/D0Sh89YLMK7MX63utMWIM
 RPvni98sBuCqC/m9VF0nKVDH1hEsOuZFM8Evl7OqqvB63/ecq9KzsDCUVgVIZlHqMPk0
 2OVA910TyZZKaSBd2sLoZ4o3xAZUkXTxU5mNvESZcMDLRHU+UU8K+7wZV42c66nqsZLx
 ABaPMjRmItK1MklCvQyub12XeqSL36kmzjQwlIbHJlzZj4zqi9wnJeUci00obTDqYYiv
 0mkE3bGMUKRQP2VW/UAT+sh0dBt1inSMQdUDwvlt5KLYLKd4HsgGDLuCxWOHWlXlcJxz 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3sjm8gnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:11:42 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GFmEEO023860;
        Mon, 16 May 2022 16:11:42 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3sjm8gmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:11:41 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GGAwqj020663;
        Mon, 16 May 2022 16:11:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3g2428tbhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:11:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GFvnds47317278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 15:57:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05E9D42042;
        Mon, 16 May 2022 16:11:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6969342041;
        Mon, 16 May 2022 16:11:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.224])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 16:11:36 +0000 (GMT)
Date:   Mon, 16 May 2022 18:11:34 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v10 04/19] KVM: s390: pv: refactor s390_reset_acc
Message-ID: <20220516181134.40652725@p-imbrenda>
In-Reply-To: <6948806da404fd5822b59fd65b8a5a948e6bb317.camel@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
        <20220414080311.1084834-5-imbrenda@linux.ibm.com>
        <6948806da404fd5822b59fd65b8a5a948e6bb317.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xqKXHyI9NazAQAfp8LMS6545uOYZmnws
X-Proofpoint-GUID: Lh0EaJdRO2M_bF5FKhpID_MGuCTBWhgp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_14,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 May 2022 10:04:54 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Thu, 2022-04-14 at 10:02 +0200, Claudio Imbrenda wrote:
> > Refactor s390_reset_acc so that it can be reused in upcoming patches.
> >=20
> > We don't want to hold all the locks used in a walk_page_range for too
> > long, and the destroy page UVC does take some time to complete.
> > Therefore we quickly gather the pages to destroy, and then destroy
> > them
> > without holding all the locks.
> >=20
> > The new refactored function optionally allows to return early without
> > completing if a fatal signal is pending (and return and appropriate
> > error code). Two wrappers are provided to call the new function.
> >=20
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Reviewed-by: Janosch Frank <frankja@linux.ibm.com> =20
>=20
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>=20
> But see below with one naming suggestion you might want to take into
> account.
>=20
> [...]
> > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > index e8904cb9dc38..a3a1f90f6ec1 100644
> > --- a/arch/s390/mm/gmap.c
> > +++ b/arch/s390/mm/gmap.c
> > @@ -2676,44 +2676,81 @@ void s390_reset_cmma(struct mm_struct *mm)
> > =C2=A0}
> > =C2=A0EXPORT_SYMBOL_GPL(s390_reset_cmma);
> > =C2=A0
> > -/*
> > - * make inaccessible pages accessible again
> > - */
> > -static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 unsigned long next, struct mm_walk *walk)
> > +#define DESTROY_LOOP_THRESHOLD 32 =20
>=20
> maybe GATHER_NUM_PAGE_REFS_TO_TAKE?

what about GATHER_GET_PAGES ?
