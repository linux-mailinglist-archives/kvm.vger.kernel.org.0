Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A5E6ABD60
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 11:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjCFKwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 05:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCFKwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 05:52:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8812A2687C;
        Mon,  6 Mar 2023 02:51:40 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3269lLbt007017;
        Mon, 6 Mar 2023 10:50:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=8lhZdOvnrjlCXmIF/zhQJYkCQscn7IlklVhYPKqKZ8M=;
 b=KzCwGGiV/XbgooYrbVg7Qe6IvxjHTiYOqqV/vqANUbyw5Ve0x3Cx7l90KjCXofFGO20D
 W9YGGmRVxZkvE2CkvDf3yHUiNZTrmYPLxgfy77i6Jv3rALUgvtsSKI1NtQsvR/qBdomy
 weOqA0Rlu1RZyHLQfSsyKm+oUmOq0NFIx9VxptOyLMyfz/2vMT+CAqTmM2ZNWZTkNpHi
 8vBQlUYKUmpnn17uCltAwqTukbRLYLSNNWiZFH4YhFipM0YaTO3DTnlWE8ZiiVohfRd+
 EfK5YjFn2jet+Obi962porKwnPaM9ou42Q+O/K1RTr6ZDD/odpb7qXnPLWGYhJ0IiQo7 xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p4ysdh5bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:50:39 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 326AFoMK020999;
        Mon, 6 Mar 2023 10:50:39 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p4ysdh5ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:50:39 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3265dcts003621;
        Mon, 6 Mar 2023 10:50:36 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3p41b0t2dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:50:36 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 326AoXu126411556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Mar 2023 10:50:33 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AA372004E;
        Mon,  6 Mar 2023 10:50:33 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D237E2004B;
        Mon,  6 Mar 2023 10:50:32 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.46.225])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Mar 2023 10:50:32 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230228181633.1bd8efde@p-imbrenda>
References: <20230224140908.75208-1-nrb@linux.ibm.com> <20230224140908.75208-2-nrb@linux.ibm.com> <20230228181633.1bd8efde@p-imbrenda>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        mimu@linux.ibm.com, agordeev@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] KVM: s390: interrupt: fix virtual-physical confusion for next alert GISA
Message-ID: <167809983224.10483.9560033030008953399@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Mon, 06 Mar 2023 11:50:32 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YUZUaPEW6WwtmoE-BVmYTRGW0EAZSHDa
X-Proofpoint-GUID: 5evzX31cDgPHfbNFoBIKnoDn-zDwcI-5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_03,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303060091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-02-28 18:16:33)
> On Fri, 24 Feb 2023 15:09:08 +0100
> Nico Boehr <nrb@linux.ibm.com> wrote:
>=20
> > The gisa next alert address is defined as a host absolute address so
> > let's use virt_to_phys() to make sure we always write an absolute
> > address to this hardware structure.
> >=20
> > This is not a bug and currently works, because virtual and physical
> > addresses are the same.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >  arch/s390/kvm/interrupt.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> > index ab26aa53ee37..20743c5b000a 100644
> > --- a/arch/s390/kvm/interrupt.c
> > +++ b/arch/s390/kvm/interrupt.c
> > @@ -305,7 +305,7 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct=
 kvm_s390_gisa_interrupt *gi)
> > =20
> >  static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
> >  {
> > -     return READ_ONCE(gisa->next_alert) !=3D (u32)(u64)gisa;
> > +     return READ_ONCE(gisa->next_alert) !=3D (u32)virt_to_phys(gisa);
>=20
> is gisa always allocated below 4G? (I assume 2G actually)
>
> should we check if things are proper?
> the cast to (u32) might hide bugs if gisa is above 4G (which it
> shouldn't be, obviously)
>=20
> or do we not care?

Yes, the gisa is always below 2 GB since it's part of the sie_page2.

I don't mind getting rid of the u32 cast really, but if it is allocated abo=
ve 2 GB, it already is broken as it is and I didn't want to introduce unrel=
ated changes. Also note that there is a few other places where we currently=
 don't verify things really are below 2 GB, so you already need to be caref=
ul when allocating.

Also not sure if this is the right place to do this check, since we've alre=
ady given the address to firmware/hardware anyways in the CHSC SGIB call, i=
n the sie_block etc... so if we want to check this we should maybe look for=
 a better place to check this...
