Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417C3604F3A
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 19:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiJSR7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 13:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiJSR7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 13:59:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3273C1CC744;
        Wed, 19 Oct 2022 10:58:59 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JHK4BW028697;
        Wed, 19 Oct 2022 17:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wZzMm1jtxHr+WaUIZ4Y63cRmn37N5D0/4CBTCQveU6w=;
 b=JQ0O+II8QvaXO/4UtzqTF9r2/eJEwZi3jPXrE0+cM1KIUMAEfri6XVkVJz3CV8iRP4y8
 UALFzbQKJnMvm9c6XjWgoOFC6M2xc1ko7LZwRJrxL0ZfQpC316Pl40lL4wyNaFKjye6p
 FqX/jXIlsGlUzyC1l7xvHuty2oWEnfQuBgjh1B5m2P1au9wXxv3X9ttkdEn/wc8pDjib
 PGpvRRICt6dp2NyNMhWmIabXJqtAtj1CD8VD0LRyP7rKIsgk3v4mDl/bAOykROAfgH7T
 MwOAQwsroTrLYFsUQVSUrivlCTFSn6MWJ1KpHbU67MqQ0BRyCPZCL9KP2B3naNGD8XpB qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kan7e1gqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 17:57:50 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JHf5U1015979;
        Wed, 19 Oct 2022 17:57:49 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kan7e1gqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 17:57:49 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JHtl61002643;
        Wed, 19 Oct 2022 17:57:48 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 3k7mga7v7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 17:57:48 +0000
Received: from smtpav04.wdc07v.mail.ibm.com ([9.208.128.116])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JHvlT46619706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 17:57:47 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67B6158063;
        Wed, 19 Oct 2022 17:57:46 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 389EB58052;
        Wed, 19 Oct 2022 17:57:42 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.160.41.243])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 17:57:42 +0000 (GMT)
Message-ID: <44b6c9d164b1ba02483ed23a89ec843f18f1cd63.camel@linux.ibm.com>
Subject: Re: [PATCH v1 6/7] vfio/ccw: replace vfio_init_device with _alloc_
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
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
Date:   Wed, 19 Oct 2022 13:57:41 -0400
In-Reply-To: <Y1Awsh56Ur/cDrHh@nvidia.com>
References: <20221019162135.798901-1-farman@linux.ibm.com>
         <20221019162135.798901-7-farman@linux.ibm.com>
         <Y1Awsh56Ur/cDrHh@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q2mvKpVcdgQlwFBaW1mfglcq_AZETqcy
X-Proofpoint-ORIG-GUID: g1ueXzvxe0ge2ZRClxxJJQOvrPAfn-Qw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_10,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 suspectscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-10-19 at 14:15 -0300, Jason Gunthorpe wrote:
> On Wed, Oct 19, 2022 at 06:21:34PM +0200, Eric Farman wrote:
>=20
> > =C2=A0/*
> > =C2=A0 * Initialize a vfio_device so it can be registered to vfio core.
> > - *
> > - * Only vfio-ccw driver should call this interface.
> > =C2=A0 */
> > =C2=A0int vfio_init_device(struct vfio_device *device, struct device
> > *dev,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct vfio_devic=
e_ops *ops)
> > @@ -422,7 +420,6 @@ int vfio_init_device(struct vfio_device
> > *device, struct device *dev,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ida_free(&vfio.device_i=
da, device->index);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ret;
> > =C2=A0}
> > -EXPORT_SYMBOL_GPL(vfio_init_device);
>=20
> Should be made static as well

Agreed. Only reason I didn't was there's a prototype in
include/linux/vfio.h to satisfy the call to vfio_init_device from
_vfio_alloc_device, and I didn't want to get into moving things around
if I didn't need to. I can do that on top, if you'd like.

Eric
