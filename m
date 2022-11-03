Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C955618CCB
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 00:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiKCXca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 19:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKCXc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 19:32:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1B9201A0;
        Thu,  3 Nov 2022 16:32:27 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3MfvV6013809;
        Thu, 3 Nov 2022 23:32:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Hd8lSwxwlK7HM4IzVeypMmGfqjcH+u9Jg5Zy3uC3Adk=;
 b=gJo5g4kJk5v04at/s20eY4wLwJeSGjKEzo2lMxbUvpQ87WuAmeApBQCK0074YVYq59pD
 AfdLKOYNitQvG8jSGA9jW06Xtl7Nnx8f8LA2sEgsMArBDM9wS4/bJwqplmeCL4KfUVlJ
 +v2J4lpSr96xRo4CbVUENpu8twxqdRPEiQhlnjBm4yG8vCeb2J8U37Kz1HMLP6uiK4DX
 1jpC7r273GiVHobkEv6z8pr3gv0kf6OTglBebuIyJOjtufyDFXSr9NVsW2GgvGBkWFz/
 i+V/4Il1lP90Ki0gpuYRFw2So3L0UUNzTr+8XZTVPVpbuNpl0dYSeXy8RxN5k7ymZVRB 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmphcse98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 23:32:20 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3NMr2t019167;
        Thu, 3 Nov 2022 23:32:20 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmphcse8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 23:32:19 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3NKFeq013896;
        Thu, 3 Nov 2022 23:32:18 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 3kguta4qmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 23:32:18 +0000
Received: from smtpav03.wdc07v.mail.ibm.com ([9.208.128.112])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3NWGkl7799416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 23:32:17 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A01C458058;
        Thu,  3 Nov 2022 23:32:16 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B7B95805D;
        Thu,  3 Nov 2022 23:32:09 +0000 (GMT)
Received: from [9.65.206.126] (unknown [9.65.206.126])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  3 Nov 2022 23:32:09 +0000 (GMT)
Message-ID: <01901cda-ec1d-bdd2-4b0f-95ee372136b8@linux.ibm.com>
Date:   Thu, 3 Nov 2022 19:32:08 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 6/7] vfio/ccw: replace vfio_init_device with _alloc_
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
 <20221102150152.2521475-7-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221102150152.2521475-7-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VQwyVYCNSljC-7wAYhpPYTtdNnyaivAb
X-Proofpoint-ORIG-GUID: -oovFYQTH-gFlxW1Bo6bX3QfSC7EXS1O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030161
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/2/22 11:01 AM, Eric Farman wrote:
> Now that we have a reasonable separation of structs that follow
> the subchannel and mdev lifecycles, there's no reason we can't
> call the official vfio_alloc_device routine for our private data,
> and behave like everyone else.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c     | 18 ------------------
>  drivers/s390/cio/vfio_ccw_ops.c     | 28 ++++++++++++++++++----------
>  drivers/s390/cio/vfio_ccw_private.h |  2 --
>  drivers/vfio/vfio_main.c            | 10 +++++-----
>  include/linux/vfio.h                |  2 --
>  5 files changed, 23 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 041cc0860f0e..fd58c0f4f8cc 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -151,24 +151,6 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
>  	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_INTERRUPT);
>  }
>  
> -void vfio_ccw_free_private(struct vfio_ccw_private *private)
> -{
> -	struct vfio_ccw_crw *crw, *temp;
> -
> -	list_for_each_entry_safe(crw, temp, &private->crw, next) {
> -		list_del(&crw->next);
> -		kfree(crw);
> -	}
> -
> -	kmem_cache_free(vfio_ccw_crw_region, private->crw_region);
> -	kmem_cache_free(vfio_ccw_schib_region, private->schib_region);
> -	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
> -	kmem_cache_free(vfio_ccw_io_region, private->io_region);
> -	kfree(private->cp.guest_cp);
> -	mutex_destroy(&private->io_mutex);
> -	kfree(private);
> -}
> -
>  static void vfio_ccw_free_parent(struct device *dev)
>  {
>  	struct vfio_ccw_parent *parent = container_of(dev, struct vfio_ccw_parent, dev);
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 8a929a9cf3c6..1155f8bcedd9 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -102,15 +102,10 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>  	struct vfio_ccw_private *private;
>  	int ret;
>  
> -	private = kzalloc(sizeof(*private), GFP_KERNEL);
> -	if (!private)
> -		return -ENOMEM;
> -
> -	ret = vfio_init_device(&private->vdev, &mdev->dev, &vfio_ccw_dev_ops);
> -	if (ret) {
> -		kfree(private);
> -		return ret;
> -	}
> +	private = vfio_alloc_device(vfio_ccw_private, vdev, &mdev->dev,
> +				    &vfio_ccw_dev_ops);
> +	if (IS_ERR(private))
> +		return PTR_ERR(private);

OK, and now it makes sense to switch to IS_ERR since _vfio_alloc_device uses ERR_PTR.  

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

