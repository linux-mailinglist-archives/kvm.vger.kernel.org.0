Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0A76CD998
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 14:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjC2MvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 08:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjC2Mu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 08:50:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530459B;
        Wed, 29 Mar 2023 05:50:58 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TCFn2e027584;
        Wed, 29 Mar 2023 12:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=USFq2lQN74Y/qA6U39R0O55vGLsRZIsNK0XXSujqFOQ=;
 b=Ujs8O/UQfUqAr+s03+Lj5Qb7DwGNbjbxhzWhEkHsEAb/jpBrn8LVLZeswz99QzV5qxmF
 lQHufJHAlffhOP5/YPpVJyw2py4KisWeCwCXm01ROdc0/XMKEXw+xu14EWtdu1sOlSxx
 2vZxXAoDg/2RmymLBDZGzj8i8YKEEBcPVjyNtmDO5OelDAD2OegSnK1qRa9vUbHawsnD
 pzQNJ2+7C3/nYVVde4rYrweDOmp2dsZhRP1U7TBjQXfClkhME85f2bdMg21JuIKEWjal
 4IdjsS6rpzCy4/G+9uzffIRqhI4W8Do/VOGmZqOdiVi789LXcRqcWy9IraMoq3XVtsOO sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmn6crwnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 12:50:57 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32TCV3a7021667;
        Wed, 29 Mar 2023 12:50:57 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmn6crwmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 12:50:57 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32SLQc0W028881;
        Wed, 29 Mar 2023 12:50:55 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3phr7fn0c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 12:50:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32TCopaj56688964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 12:50:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EFA420043;
        Wed, 29 Mar 2023 12:50:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DF5E20040;
        Wed, 29 Mar 2023 12:50:51 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.2.202])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 29 Mar 2023 12:50:51 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <afcf5186-c3f2-d777-be5f-408318039f2d@linux.ibm.com>
References: <20230327082118.2177-1-nrb@linux.ibm.com> <20230327082118.2177-2-nrb@linux.ibm.com> <afcf5186-c3f2-d777-be5f-408318039f2d@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 1/4] s390x: sie: switch to home space mode before entering SIE
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Message-ID: <168009425098.295696.4253423899606982653@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 29 Mar 2023 14:50:50 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2q97NzQgK9c0A7gHlOyVYlelwYLiqet0
X-Proofpoint-GUID: AYmRxUK3BIgaqQjEBAsqCJFAEhAis1Tm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_06,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290102
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-28 16:13:04)
> On 3/27/23 10:21, Nico Boehr wrote:
> > This is to prepare for running guests without MSO/MSL, which is
> > currently not possible.
> >=20
> > We already have code in sie64a to setup a guest primary ASCE before
> > entering SIE, so we can in theory switch to the page tables which
> > translate gpa to hpa.
> >=20
> > But the host is running in primary space mode already, so changing the
> > primary ASCE before entering SIE will also affect the host's code and
> > data.
> >=20
> > To make this switch useful, the host should run in a different address
> > space mode. Hence, set up and change to home address space mode before
> > installing the guest ASCE.
> >=20
> > The home space ASCE is just copied over from the primary space ASCE, so
> > no functional change is intended, also for tests that want to use
> > MSO/MSL. If a test intends to use a different primary space ASCE, it can
> > now just set the guest.asce in the save_area.
> >=20
> [...]
> > +     /* set up home address space to match primary space */
> > +     old_cr13 =3D stctg(13);
> > +     lctlg(13, stctg(1));
> > +
> > +     /* switch to home space so guest tables can be different from hos=
t */
> > +     psw_mask_set_bits(PSW_MASK_HOME);
> > +
> > +     /* also handle all interruptions in home space while in SIE */
> > +     lowcore.pgm_new_psw.mask |=3D PSW_MASK_DAT_HOME;
>=20
> > +     lowcore.ext_new_psw.mask |=3D PSW_MASK_DAT_HOME;
> > +     lowcore.io_new_psw.mask |=3D PSW_MASK_DAT_HOME;
> We didn't enable DAT in these two cases as far as I can see so this is=20
> superfluous or we should change the mmu code. Also it's missing the svc=20
> and machine check.

Right. Is there a particular reason why we only run DAT on for PGM ints?

> The whole bit manipulation thing looks a bit crude. It might make more=20
> sense to drop into real mode for a few instructions and have a dedicated =

> storage location for an extended PSW mask and an interrupt ASCE as part=20
> of the interrupt call code instead.
>=20
> Opinions?

Maybe I don't get it, but I personally don't quite see the advantage. It se=
ems
to me this would make things much more complicated just to avoid a few simp=
le
bitops.

It maybe also depends on how many new_psws we have to touch. If it's really=
 just
the PGM, the current solution seems simple enough.

But if others also prefer Janosch's suggestion, I am happy to implement it.
