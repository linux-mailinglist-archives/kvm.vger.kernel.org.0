Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F3D731994
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 15:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245084AbjFONJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 09:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240221AbjFONJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 09:09:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37629269A;
        Thu, 15 Jun 2023 06:09:15 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FClO3E025824;
        Thu, 15 Jun 2023 13:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=F/UY432I0YRecA973/6P86Iv7Mzj9hyX58pHMbReSn0=;
 b=oyyTQwW0NggnZfBFY1FnQYUVhk+cEGk7Ke/efet21drZ/myXoX5LGXH/EAc+bQhLqdgA
 h8I3nteRKovRLxx7IFecvfXJ7AXw3kAttvggHZZxnUcby65BILIaNzONgIzm+XEvwvAG
 Q2SVK6gfHN2pa8vsssJ9ZARcMQt8QID5FOukhZrX4beLox245Vyite+Y51rdRaFQHPh1
 ULgzDO4nd2EOi4Ul94PLkDmDt3QY1lBxcARUgIzZDQR+ez/rtBpXejdHWI3/CSuQvHgf
 zYGeBs+0AoaYs1H505DOU0Peo0Z6k6kWaFcEQ3sm3+cT0ckvEIFWd5uQEcebRrCQ1v9I 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r82y410e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 13:09:14 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35FCltKd028325;
        Thu, 15 Jun 2023 13:09:13 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r82y410cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 13:09:13 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35F8jNk5020283;
        Thu, 15 Jun 2023 13:09:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3r4gt4tnjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 13:09:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35FD98pH65863948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 13:09:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8DD720043;
        Thu, 15 Jun 2023 13:09:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBFF12004D;
        Thu, 15 Jun 2023 13:09:07 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.73.29])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jun 2023 13:09:07 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ecbaf984-a3b7-1681-b3f9-e8ce86121f8d@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com> <20230601070202.152094-4-nrb@linux.ibm.com> <ecbaf984-a3b7-1681-b3f9-e8ce86121f8d@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/6] s390x: sie: switch to home space mode before entering SIE
Message-ID: <168683454742.207611.12082480161130966760@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 15 Jun 2023 15:09:07 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A0V-OL3nSiQsr1_pZ7-FLf3YUowUP1NQ
X-Proofpoint-GUID: F8FjBHEOUdeW8cvRbKZTyhbdcq_yudZo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-15_08,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-06-05 11:03:19)
> On 6/1/23 09:01, Nico Boehr wrote:
> > This is to prepare for running guests without MSO/MSL, which is
> > currently not possible.
>=20
> This is a preparation patch for non-MSO/MSL guest support.
>=20
> >=20
> > We already have code in sie64a to setup a guest primary ASCE before
> > entering SIE, so we can in theory switch to the page tables which
> > translate gpa to hpa.
>=20
> The important information that's missing here is that SIE always uses=20
> the prim space for guest to host translations.
>=20
> >=20
> > But the host is running in primary space mode already, so changing the
> > primary ASCE before entering SIE will also affect the host's code and
> > data.
>=20
> And that's why this is an issue.
>=20
> For the time being we'll copy the primary ASCE into the home space ASCE. =

> No functional change is intended. But if a test intends to....

Thanks, I have to following text now:

 s390x: sie: switch to home space mode before entering SIE

 This is a preparation patch for running guests without MSO/MSL.

 We already have code in sie64a to setup a guest primary ASCE before
 entering SIE. Since SIE always uses the primary ASCE to translate gpa to
 hpa we can in theory switch to seperate guest page tables.

 But the host is running in primary space mode already, so changing the
 primary ASCE before entering SIE will also affect the host's code and
 data. That's why running the host in primary space is an issue.

 To make this switch useful, the host should run in a different address
 space mode. Hence, set up and change to home address space mode before
 installing the guest ASCE.

 For the time being the primary ASCE is copied to the home space ASCE.
 No functional change is intended, but if a test intends to use a
 different primary space ASCE, it can now just set the guest.asce in the
 save_area.

> > diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> > index 9241b4b4a512..ffa8ec91a423 100644
> > --- a/lib/s390x/sie.c
> > +++ b/lib/s390x/sie.c
> > @@ -46,6 +46,8 @@ void sie_handle_validity(struct vm *vm)
> >  =20
> >   void sie(struct vm *vm)
> >   {
[...]
> > +     /* switch to home space so guest tables can be different from hos=
t */
> > +     psw_mask_set_bits(PSW_MASK_HOME);
> > +
> > +     /* also handle all interruptions in home space while in SIE */
> > +     irq_set_dat_mode(IRQ_DAT_ON, AS_HOME);
>=20
> I'm wondering why this needs to be two calls when you clearly want to=20
> have a convenience function that does a full space change.
>=20
> We could introduce:
>=20
> #define AS_REAL 4
>=20
> static void mmu_set_addr_space(uint8_t space)
> {
>         if (space < 4)
>                 psw_mask_set_bits(space);
>         irq_set_dat_mode(space);
> }
>=20
> The "addr" in the function name is optional in my opinion.
> @Claudio: What's your opinion?

I don't agree; this convenience function would just hide your intention.

With the code right now it is perfectly clear that we're running in home and
handling all interruptions in home. It is perfectly valid to handle
interruptions in a space different from the one you're currently running in;
I guess that's what every OS does for userspace ;-)
