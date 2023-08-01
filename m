Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B3D76B3C1
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbjHALsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbjHALs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:48:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C76199E;
        Tue,  1 Aug 2023 04:48:16 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371BcSHp009487;
        Tue, 1 Aug 2023 11:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=YeFhAJn5JrzdQnaeXngFMgQVEHf9AbbuNFn7v9q5Gvs=;
 b=godh8PsMta2XgMWTW8LMo1aClFOXY1jVi2vrDljiQ67AnxSnsZPD+XC6jfx+Q0iWKMWc
 sASl1+I40IkCmJU2y7wrxC48SlyhmAv7+9d9LXXEbrOFOx3fghhUH2KnrovgXl1aq5ea
 a61ukZ5uWKcMDSNqNidnXvutOaHK2EjD0hYI2cJ8guHW5T0xWiAD4mbSMLaVzWt9VxOl
 2tFa4vdvjl5KAa6e2zsQvzN9EMrbYv+lFuj+GoG86T0sMY4hcwqi0bbbXo43tHAXQc+/
 wYNdo5h0IHYDqm2/pb70HwA0fURxHiuDDAHJaPvI2RCGwUV9LCrpg44evDsIulf1tFrC Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s7111gspy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Aug 2023 11:48:14 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 371BcXAB009861;
        Tue, 1 Aug 2023 11:48:14 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s7111gspq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Aug 2023 11:48:14 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 371ACK7i006057;
        Tue, 1 Aug 2023 11:48:13 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s5d3sbxuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Aug 2023 11:48:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 371BmBRL11993638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Aug 2023 11:48:11 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F33952004E;
        Tue,  1 Aug 2023 11:48:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9CE32004B;
        Tue,  1 Aug 2023 11:48:10 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.36.136])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  1 Aug 2023 11:48:10 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e0b2195a-6f60-6a49-cf3f-4a528eb2df43@redhat.com>
References: <20230510121822.546629-1-nrb@linux.ibm.com> <20230510121822.546629-2-nrb@linux.ibm.com> <e0b2195a-6f60-6a49-cf3f-4a528eb2df43@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [PATCH v2 1/2] KVM: s390: add stat counter for shadow gmap events
Message-ID: <169089049005.9734.15826596498609647664@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 01 Aug 2023 13:48:10 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ep6Kg7Cn1ZWQjvd6VDrlqIwP8opHco0C
X-Proofpoint-GUID: Y_37DqLjX2f1GfvezUrvFfbqG2j0TN6P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_06,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308010105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting David Hildenbrand (2023-07-27 09:37:21)
[...]
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/k=
vm_host.h
> > index 2bbc3d54959d..d35e03e82d3d 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -777,6 +777,12 @@ struct kvm_vm_stat {
> >       u64 inject_service_signal;
> >       u64 inject_virtio;
> >       u64 aen_forward;
> > +     u64 gmap_shadow_acquire;
> > +     u64 gmap_shadow_r1_te;
> > +     u64 gmap_shadow_r2_te;
> > +     u64 gmap_shadow_r3_te;
> > +     u64 gmap_shadow_sg_te;
> > +     u64 gmap_shadow_pg_te;
>=20
> Is "te" supposed to stand for "table entry" ?

Yes.

> If so, I'd suggest to just call this gmap_shadow_pg_entry etc.

Janosch, since you suggested the current naming, are you OK with _entry?

[...]
> > diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> > index 8d6b765abf29..beb3be037722 100644
> > --- a/arch/s390/kvm/vsie.c
> > +++ b/arch/s390/kvm/vsie.c
> > @@ -1221,6 +1221,7 @@ static int acquire_gmap_shadow(struct kvm_vcpu *v=
cpu,
> >       if (IS_ERR(gmap))
> >               return PTR_ERR(gmap);
> >       gmap->private =3D vcpu->kvm;
> > +     vcpu->kvm->stat.gmap_shadow_acquire++;
>=20
>=20
> Do you rather want to have events for
>=20
> gmap_shadow_reuse (if gmap_shadow_valid() succeeded in that function)
> gmap_shadow_create (if we have to create a new one via gmap_shadow)
>=20
> ?

Yeah, good suggestion. I'll add that.
