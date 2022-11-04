Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF22619635
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 13:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiKDM2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 08:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiKDM2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 08:28:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839E12AC63;
        Fri,  4 Nov 2022 05:28:18 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Aealw012853;
        Fri, 4 Nov 2022 12:28:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RpfopL9GvWC6BKuueYK3XkrSlHu3oZj4DUYKz7LYdbc=;
 b=inixn5kaWfd0sR5Q3BvmIJ0daAZArrpNDVV9IO4rjFT8hRhihn5Qh2TCX7Au9nN7PuVE
 tI5l7hzW3MhcuOp0Ngufj1xOUv8cGtBdDxjaf+Uis0tAH8UHOdrRBETnC8ObtYVgFj+2
 EgES6cw60OaMtzrLu8oNUzURTid4amls9BQgg6MtJ9tW75/0J8L5WkvQZ61FScU7BOvo
 ThwtjazRRuoI3YTLP8kANUwnv+7BGe8ms0VmJSFPC4lEBaK1LLK3mtg6uPxaxFgtdBM2
 7dzITiXM1TH1TPKlxB6BGRUoUy8HtUij0hP3D14d1WWcPh57uernETSc66aFW+sbc72P Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmpt14vdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 12:28:05 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A4AYULx023135;
        Fri, 4 Nov 2022 12:28:04 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmpt14vd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 12:28:04 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A4CKkHC008853;
        Fri, 4 Nov 2022 12:28:03 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 3kgutb1ykc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 12:28:03 +0000
Received: from smtpav06.dal12v.mail.ibm.com ([9.208.128.130])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A4CS39l25100648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Nov 2022 12:28:03 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F0E458055;
        Fri,  4 Nov 2022 12:28:01 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA32158043;
        Fri,  4 Nov 2022 12:27:58 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.225.56])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  4 Nov 2022 12:27:58 +0000 (GMT)
Message-ID: <b050a219f9066dc61d894bc768cf4641054be8ed.camel@linux.ibm.com>
Subject: Re: [PATCH v2 4/7] vfio/ccw: move private to mdev lifecycle
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 04 Nov 2022 08:27:58 -0400
In-Reply-To: <19ded86a-9574-23d7-8bbc-7dd94c95c144@linux.ibm.com>
References: <20221102150152.2521475-1-farman@linux.ibm.com>
         <20221102150152.2521475-5-farman@linux.ibm.com>
         <19ded86a-9574-23d7-8bbc-7dd94c95c144@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pU_nA-I-JhlPc6jY1rBRLPpMxJsu9xnc
X-Proofpoint-ORIG-GUID: p4pJcAzXB-Uhoh3KM52yU4W3FYgPeLMB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_07,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211040081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-03 at 19:22 -0400, Matthew Rosato wrote:
> On 11/2/22 11:01 AM, Eric Farman wrote:
> > Now that the mdev parent data is split out into its own struct,
> > it is safe to move the remaining private data to follow the
> > mdev probe/remove lifecycle. The mdev parent data will remain
> > where it is, and follow the subchannel and the css driver
> > interfaces.
> >=20
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> > =C2=A0drivers/s390/cio/vfio_ccw_drv.c=C2=A0=C2=A0=C2=A0=C2=A0 | 15 +---=
-----------
> > =C2=A0drivers/s390/cio/vfio_ccw_ops.c=C2=A0=C2=A0=C2=A0=C2=A0 | 26 ++++=
+++++++++------------
> > -
> > =C2=A0drivers/s390/cio/vfio_ccw_private.h |=C2=A0 2 ++
> > =C2=A03 files changed, 16 insertions(+), 27 deletions(-)
> >=20
>=20
> ...
>=20
> > diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> > b/drivers/s390/cio/vfio_ccw_ops.c
> > index eb0b8cc210bb..e45d4acb109b 100644
> > --- a/drivers/s390/cio/vfio_ccw_ops.c
> > +++ b/drivers/s390/cio/vfio_ccw_ops.c
> > @@ -100,15 +100,20 @@ static int vfio_ccw_mdev_probe(struct
> > mdev_device *mdev)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct subchannel *sch =
=3D to_subchannel(mdev->dev.parent);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct vfio_ccw_parent =
*parent =3D dev_get_drvdata(&sch-
> > >dev);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct vfio_ccw_private *pri=
vate =3D dev_get_drvdata(&parent-
> > >dev);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct vfio_ccw_private *pri=
vate;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (private->state =3D=3D VF=
IO_CCW_STATE_NOT_OPER)
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -ENODEV;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0private =3D kzalloc(sizeof(*=
private), GFP_KERNEL);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!private)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -ENOMEM;
>=20
> Ha, looks like you time traveled and took my advice :)

Ha, I forgot I did this in the future. :)

>=20
> In fact it looks like some of my other comments from patch 1 get
> cleaned up here too -- but would still be good to make those changes
> in patch 1 for completeness/bisect.

Agreed, I'll pull those down to patch 1; thanks.

>=20
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
>=20

