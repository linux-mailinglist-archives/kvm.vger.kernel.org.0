Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2B670E22B
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 18:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237422AbjEWQeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 12:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbjEWQeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 12:34:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C0DC2;
        Tue, 23 May 2023 09:34:05 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NFpH8E029591;
        Tue, 23 May 2023 16:33:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=yLQUjASuD0Wzz5ADqgfqMAhs+2Y8p1wr3eeG8IYvX74=;
 b=s/X/T9RNu/ayUnMW5BVA8OU8elWdAQGYll0z9DZ3STopDBIazbSn8f7LKgsjy8SwQxuO
 SPrKM4B7Vm4FqHD8WdOwn28a2+fPoaUX2BrM/49gSfBXbVs4kcvYGEabULqmKJJ/Uukk
 Jc6RlnGAiItAOFcGH8MnMW0Jg6ggmwxI/U0AJL6QdJa5dl63/zIuMcNncld5bv/lqI2a
 DPdUiKozejevP32CMZiVt53j91U39WvGLMWrEeNXLkGzZOgGuUozD1GBq21Vxoxs+hs3
 74/6C0fRnIsqiwkzPC0ec9xyXpu0+YTuQck78Devw0IADWi22eAullhm62rx73wRTQHm aA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qs0gc0ypc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 16:33:58 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34NEHcAH030404;
        Tue, 23 May 2023 16:33:58 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3qppcd3y7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 16:33:57 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34NGXt1E63439306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 16:33:56 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC78A58056;
        Tue, 23 May 2023 16:33:55 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC3EF58052;
        Tue, 23 May 2023 16:33:54 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.95.28])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 23 May 2023 16:33:54 +0000 (GMT)
Message-ID: <fa2905e329f2e723228eb4750b305ae54be2a1ad.camel@linux.ibm.com>
Subject: Re: [PATCH 1/2][next] vfio/ccw: Replace one-element array with
 flexible-array member
From:   Eric Farman <farman@linux.ibm.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Tue, 23 May 2023 12:33:54 -0400
In-Reply-To: <3c10549ebe1564eade68a2515bde233527376971.1684805398.git.gustavoars@kernel.org>
References: <cover.1684805398.git.gustavoars@kernel.org>
         <3c10549ebe1564eade68a2515bde233527376971.1684805398.git.gustavoars@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0Ei0tlkdwj_V9c4MJxUtPHDu7Z6hbHnT
X-Proofpoint-GUID: 0Ei0tlkdwj_V9c4MJxUtPHDu7Z6hbHnT
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_10,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=763 priorityscore=1501 impostorscore=0
 mlxscore=0 spamscore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-05-22 at 19:35 -0600, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with
> flexible
> array members instead. So, replace one-element array with flexible-
> array
> member in struct vfio_ccw_parent and refactor the the rest of the

s/the the/the/

> code
> accordingly.
>=20
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/297
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
> =C2=A0drivers/s390/cio/vfio_ccw_drv.c=C2=A0=C2=A0=C2=A0=C2=A0 | 3 ++-
> =C2=A0drivers/s390/cio/vfio_ccw_private.h | 2 +-
> =C2=A02 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> b/drivers/s390/cio/vfio_ccw_drv.c
> index ff538a086fc7..57906a9c6324 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -171,7 +171,8 @@ static int vfio_ccw_sch_probe(struct subchannel
> *sch)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -ENODEV;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0parent =3D kzalloc(sizeof(*par=
ent), GFP_KERNEL);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0parent =3D kzalloc(sizeof(*par=
ent) + sizeof(struct mdev_type
> *),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GFP_KERN=
EL);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!parent)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -ENOMEM;
> =C2=A0
> diff --git a/drivers/s390/cio/vfio_ccw_private.h
> b/drivers/s390/cio/vfio_ccw_private.h
> index b441ae6700fd..b62bbc5c6376 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -79,7 +79,7 @@ struct vfio_ccw_parent {
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mdev_parent=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0parent;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mdev_type=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mdev_type;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mdev_type=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*mdev_types[1];
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mdev_type=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*mdev_types[];
> =C2=A0};
> =C2=A0
> =C2=A0/**

