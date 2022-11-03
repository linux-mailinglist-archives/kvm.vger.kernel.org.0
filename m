Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E1E618CB5
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 00:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiKCXWe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 19:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKCXWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 19:22:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392F995A3;
        Thu,  3 Nov 2022 16:22:32 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3MfvSt013713;
        Thu, 3 Nov 2022 23:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=H7/0dxTRsY+BvOv7mnTdafwbpTIq0fx1293cZ4rn3Es=;
 b=ppZOBId8j+HiGvBdI6Xi60SGXrr4CmWep799g2XPrCWg4fWGuOGnOTBgnhdRXTb1+5sn
 Tz1+R3j56n6tUGAB4bnXoATTBf8rAXP2K8DBwJALDIjV7ZcUsycYSHdth2YvpZbhX8d/
 3cPdn7RuZ7ri3wRfTb3I7TMOK+Fr9AVeY8VNW25PG3X0bZGzekqrN6CA2HxsPyIK/D7q
 32pxoDj6pSPNJZI+UIA+/7IyjOnxIXNHlV5VPgkZh+y+zL/WCneiH3Yg+A2QihjHQipH
 YaKMtlu3VXDEz6zqOn3RfG3UsbwIY2p8gsl96EuWm03eo1FTItay+32J4zwSoZCzNaU0 Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmphcs8b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 23:22:25 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3NMO0m014764;
        Thu, 3 Nov 2022 23:22:24 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmphcs8aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 23:22:24 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3NKsKh022775;
        Thu, 3 Nov 2022 23:22:23 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 3kgutawq2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 23:22:22 +0000
Received: from smtpav03.wdc07v.mail.ibm.com ([9.208.128.112])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3NMLZD7995984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 23:22:21 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E84E458066;
        Thu,  3 Nov 2022 23:22:20 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4826F5805D;
        Thu,  3 Nov 2022 23:22:13 +0000 (GMT)
Received: from [9.65.206.126] (unknown [9.65.206.126])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  3 Nov 2022 23:22:13 +0000 (GMT)
Message-ID: <19ded86a-9574-23d7-8bbc-7dd94c95c144@linux.ibm.com>
Date:   Thu, 3 Nov 2022 19:22:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 4/7] vfio/ccw: move private to mdev lifecycle
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
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
References: <20221102150152.2521475-1-farman@linux.ibm.com>
 <20221102150152.2521475-5-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221102150152.2521475-5-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x5N-d4cZNnBUWP-lDMwXiz7A-m9H4abG
X-Proofpoint-ORIG-GUID: 4Cg71VdChMUA4LvQ86_qecf-7JOz8pHU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030158
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/2/22 11:01 AM, Eric Farman wrote:
> Now that the mdev parent data is split out into its own struct,
> it is safe to move the remaining private data to follow the
> mdev probe/remove lifecycle. The mdev parent data will remain
> where it is, and follow the subchannel and the css driver
> interfaces.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c     | 15 +--------------
>  drivers/s390/cio/vfio_ccw_ops.c     | 26 +++++++++++++-------------
>  drivers/s390/cio/vfio_ccw_private.h |  2 ++
>  3 files changed, 16 insertions(+), 27 deletions(-)
> 

...

> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index eb0b8cc210bb..e45d4acb109b 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -100,15 +100,20 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>  {
>  	struct subchannel *sch = to_subchannel(mdev->dev.parent);
>  	struct vfio_ccw_parent *parent = dev_get_drvdata(&sch->dev);
> -	struct vfio_ccw_private *private = dev_get_drvdata(&parent->dev);
> +	struct vfio_ccw_private *private;
>  	int ret;
>  
> -	if (private->state == VFIO_CCW_STATE_NOT_OPER)
> -		return -ENODEV;
> +	private = kzalloc(sizeof(*private), GFP_KERNEL);
> +	if (!private)
> +		return -ENOMEM;

Ha, looks like you time traveled and took my advice :)

In fact it looks like some of my other comments from patch 1 get cleaned up here too -- but would still be good to make those changes in patch 1 for completeness/bisect.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

