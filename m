Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5368153BE7C
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbiFBTPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238453AbiFBTO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:14:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B831EC69;
        Thu,  2 Jun 2022 12:14:57 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252IO3QO015097;
        Thu, 2 Jun 2022 19:14:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nHFm4Nav9eqAVL9BNaL8wZk4GYLKZe3WesQWtByWBYk=;
 b=YRFn9bFByqMftRkKQbDLCfhMDvevG9CE6dec3SmiEMpkSedtL727YckwlqrPl6DrvJNE
 xORNySVb8uYqxnQ+XVj5SIdbvMjlNsykx5NEA8ZwuqjExvgIVsy+pMVxI47xYDOv1x33
 tywW/JYD2fIVYmHll0S+fiOSTP18ic00vBN9PT6kR8TE8GR9mOgIQlrTviuGU74Wllp5
 lIS3IzeinmjEaW6bevRZKohTztBr74jeROg91eUtb+g53ucSABfwivAtE63LRshr5bQB
 M/R4RlUCXSo+aGPM5Ey9WRp8jkAQztXd8FoJ5TC9Rz5KcyAq0SV8RXOvqcp0egt95UJH yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gevu4r38b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:14:54 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252IwEKU014352;
        Thu, 2 Jun 2022 19:14:54 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gevu4r37v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:14:54 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252J5uEf028191;
        Thu, 2 Jun 2022 19:14:53 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03wdc.us.ibm.com with ESMTP id 3gbc9vvftg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:14:53 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252JEqmO27984322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 19:14:52 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FFE26A057;
        Thu,  2 Jun 2022 19:14:52 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 948EC6A04D;
        Thu,  2 Jun 2022 19:14:51 +0000 (GMT)
Received: from [9.211.104.178] (unknown [9.211.104.178])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Jun 2022 19:14:51 +0000 (GMT)
Message-ID: <22bf0a16-9949-ff8d-955a-4b97cfb37207@linux.ibm.com>
Date:   Thu, 2 Jun 2022 15:14:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v1 07/18] vfio/ccw: Flatten MDEV device (un)register
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-8-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220602171948.2790690-8-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PHMNZdVki6hWtSK2iE0onZ58iCeA5Xig
X-Proofpoint-GUID: cvNtNqdN6I3aWpAVUj3CgEN3myfFoAF3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206020081
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/22 1:19 PM, Eric Farman wrote:
> The vfio_ccw_mdev_(un)reg routines are merely vfio-ccw routines that
> pass control to mdev_(un)register_device. Since there's only one
> caller of each, let's just call the mdev routines directly.

I'd reword slightly to reference the ops extern

".. caller of each, externalize vfio_ccw_mdev_ops and call..."

regardless,

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_drv.c     |  4 ++--
>   drivers/s390/cio/vfio_ccw_ops.c     | 12 +-----------
>   drivers/s390/cio/vfio_ccw_private.h |  4 +---
>   3 files changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 9d817aa2f1c4..3784eb4cda85 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -239,7 +239,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>   
>   	private->state = VFIO_CCW_STATE_STANDBY;
>   
> -	ret = vfio_ccw_mdev_reg(sch);
> +	ret = mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
>   	if (ret)
>   		goto out_disable;
>   
> @@ -261,7 +261,7 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
>   	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
>   
>   	vfio_ccw_sch_quiesce(sch);
> -	vfio_ccw_mdev_unreg(sch);
> +	mdev_unregister_device(&sch->dev);
>   
>   	dev_set_drvdata(&sch->dev, NULL);
>   
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 4a64c176facb..497e1b7ffd61 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -656,18 +656,8 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>   	.remove = vfio_ccw_mdev_remove,
>   };
>   
> -static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
> +const struct mdev_parent_ops vfio_ccw_mdev_ops = {
>   	.owner			= THIS_MODULE,
>   	.device_driver		= &vfio_ccw_mdev_driver,
>   	.supported_type_groups  = mdev_type_groups,
>   };
> -
> -int vfio_ccw_mdev_reg(struct subchannel *sch)
> -{
> -	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
> -}
> -
> -void vfio_ccw_mdev_unreg(struct subchannel *sch)
> -{
> -	mdev_unregister_device(&sch->dev);
> -}
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index 5c128eec596b..2e0744ac6492 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -117,12 +117,10 @@ struct vfio_ccw_private {
>   	struct work_struct	crw_work;
>   } __aligned(8);
>   
> -extern int vfio_ccw_mdev_reg(struct subchannel *sch);
> -extern void vfio_ccw_mdev_unreg(struct subchannel *sch);
> -
>   extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
>   
>   extern struct mdev_driver vfio_ccw_mdev_driver;
> +extern const struct mdev_parent_ops vfio_ccw_mdev_ops;
>   
>   /*
>    * States of the device statemachine.

