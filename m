Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAA86FC994
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbjEIOxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbjEIOxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:53:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465981737;
        Tue,  9 May 2023 07:53:21 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349EpEaB017762;
        Tue, 9 May 2023 14:53:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=wHQqvb2hvYU6ONJkNyjQHXD5OTtIjVrMie7vflaFqeU=;
 b=aadsydQqXA+YWoCjKUQS+i0wLDvCpDTZOXn7+Ng5dNnvR5njdO7jWYJp5ujwNLesDqQz
 LT9pNQw7CFv0LtflU9P6l8jYNf07fZqCvRzl/Akc+y3/AuIeMozxkqz72Mp7vR3ZFynW
 /3ocYveZpGxOhrC9GKC2007ydavcl67qlHn+idHDC5dYwNXBqHHKG8nAMOiF/blLeNRA
 rGL6glT9AROG6i4/gredvT2Y2QbfzVxUzySOjOYyE1amOf0TnUMMB5HLad1GGyiVNi3o
 nxcEECQnmAjL4xe/e4vGoz6gIQ0PIpt8XDKY83dIp2TCP0gvAwz8g/lf7d1Y4GygTRdc IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfra7r2fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 14:53:20 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349EpIcG018078;
        Tue, 9 May 2023 14:53:19 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfra7r2et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 14:53:19 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34996Ps9022442;
        Tue, 9 May 2023 14:53:18 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3qf7dg0e57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 14:53:17 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349ErEO149021220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 14:53:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4170A20043;
        Tue,  9 May 2023 14:53:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1542320040;
        Tue,  9 May 2023 14:53:14 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.4.21])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 14:53:14 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230509134351.1ac4ea63@p-imbrenda>
References: <20230509111202.333714-1-nrb@linux.ibm.com> <20230509111202.333714-3-nrb@linux.ibm.com> <20230509134351.1ac4ea63@p-imbrenda>
Subject: Re: [PATCH v1 2/3] KVM: s390: add stat counter for shadow gmap events
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <168364399371.331309.5908202452338432368@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 09 May 2023 16:53:13 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QryHfYTRCyhlqXFikI9szfboQoat5nQs
X-Proofpoint-GUID: VRdr9T1AauUqXn059Pynra130IvxH0uD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305090119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-05-09 13:43:51)
[...]
> > diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> > index 3eb85f254881..8348a0095f3a 100644
> > --- a/arch/s390/kvm/gaccess.c
> > +++ b/arch/s390/kvm/gaccess.c
> > @@ -1382,6 +1382,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg=
, unsigned long saddr,
> >                                 unsigned long *pgt, int *dat_protection,
> >                                 int *fake)
> >  {
> > +     struct kvm *kvm;
> >       struct gmap *parent;
> >       union asce asce;
> >       union vaddress vaddr;
> > @@ -1390,6 +1391,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg=
, unsigned long saddr,
> > =20
> >       *fake =3D 0;
> >       *dat_protection =3D 0;
> > +     kvm =3D sg->private;
> >       parent =3D sg->parent;
> >       vaddr.addr =3D saddr;
> >       asce.val =3D sg->orig_asce;
> > @@ -1450,6 +1452,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg=
, unsigned long saddr,
> >               rc =3D gmap_shadow_r2t(sg, saddr, rfte.val, *fake);
> >               if (rc)
> >                       return rc;
> > +             kvm->stat.gmap_shadow_r2++;
> >       }
> >               fallthrough;
> >       case ASCE_TYPE_REGION2: {
> > @@ -1478,6 +1481,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg=
, unsigned long saddr,
> >               rc =3D gmap_shadow_r3t(sg, saddr, rste.val, *fake);
> >               if (rc)
> >                       return rc;
> > +             kvm->stat.gmap_shadow_r3++;
> >       }
> >               fallthrough;
> >       case ASCE_TYPE_REGION3: {
> > @@ -1515,6 +1519,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg=
, unsigned long saddr,
> >               rc =3D gmap_shadow_sgt(sg, saddr, rtte.val, *fake);
> >               if (rc)
> >                       return rc;
> > +             kvm->stat.gmap_shadow_segment++;
> >       }
> >               fallthrough;
> >       case ASCE_TYPE_SEGMENT: {
> > @@ -1548,6 +1553,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg=
, unsigned long saddr,
> >               rc =3D gmap_shadow_pgt(sg, saddr, ste.val, *fake);
> >               if (rc)
> >                       return rc;
> > +             kvm->stat.gmap_shadow_page++;
>=20
> do I understand correctly that, if several levels need to be shadowed
> at the same time, you will increment every affected counter, and not
> just the highest or lowest level?
>=20
> if so, please add a brief explanation to the patch description

Yes, that seemed like the simplest thing to do.

Will add a explanation.

Or should I add a flag and only increment the top level?
