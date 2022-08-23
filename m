Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A26359EAA3
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 20:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbiHWSMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 14:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiHWSLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 14:11:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199EA9A994;
        Tue, 23 Aug 2022 09:23:27 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NFtXH7015155;
        Tue, 23 Aug 2022 16:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y+D/nptw5cAg0ZpaT4pCciDGydAT/YKp9U9O+u9Tc6g=;
 b=pRWm/NWm7a6s9hPNmE33Gahf3dY5MlGgayetrA+75C7aqBxxCmyapT7IUoo6LVIUm7PM
 6Bt9RB94XiNsV5/1BomEoOwiE4uTLFWJpi10wFskBtW/JGRFF31AO/vksCZc40jvNx1g
 wG0FjfqqrQDXZLwwhLrYBoZtA/FhK9GEsaPe2wz8DC7G+vK8lrYYsj1xPNo8odjMlRbM
 HXn1I5C7AhZyxL1wZZki+48C0mjkUGqgIQsjmWpVTuvZRCtbj/vXMIM1nzfgTH9C3kez
 0kc5pxDW19QCyXQo/XK6qNUKW+r2LohHPxZbvkLnn18nkmU1rSUiofibz/YZfpkx595N 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j51yb8xkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 16:23:08 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NFuJC9017430;
        Tue, 23 Aug 2022 16:23:08 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j51yb8xkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 16:23:08 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NG70hV032088;
        Tue, 23 Aug 2022 16:23:07 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 3j2q8a103m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 16:23:07 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NGN6H312583514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 16:23:06 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D30128059;
        Tue, 23 Aug 2022 16:23:06 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87E232805A;
        Tue, 23 Aug 2022 16:23:05 +0000 (GMT)
Received: from [9.160.64.167] (unknown [9.160.64.167])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 16:23:05 +0000 (GMT)
Message-ID: <51ebcc15-4690-a93d-bf04-93ff9f6da482@linux.ibm.com>
Date:   Tue, 23 Aug 2022 12:23:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 11/14] vfio/mdev: consolidate all the name sysfs into the
 core code
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
References: <20220822062208.152745-1-hch@lst.de>
 <20220822062208.152745-12-hch@lst.de>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220822062208.152745-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nrlNwaZsntmuT8-8WETzQLAFab4cfcwn
X-Proofpoint-ORIG-GUID: ZGMrYkvV20rNu2p6MZExqnOHiZxclSy2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208230065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/22/22 2:22 AM, Christoph Hellwig wrote:
> Every driver just emits a static string, simply add a field to the
> mdev_type for the driver to fill out or fall back to the sysfs name and
> provide a standard sysfs show function.


What am I missing? I can not find where the the driver sets the 
mdev_type.pretty_name field by the vfio_ap device driver.


>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>   .../driver-api/vfio-mediated-device.rst       |  2 +-
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |  8 -------
>   drivers/s390/cio/vfio_ccw_drv.c               |  1 +
>   drivers/s390/cio/vfio_ccw_ops.c               |  8 -------
>   drivers/s390/crypto/vfio_ap_ops.c             |  9 --------
>   drivers/vfio/mdev/mdev_sysfs.c                | 10 +++++++++
>   include/linux/mdev.h                          |  1 +
>   samples/vfio-mdev/mbochs.c                    | 20 ++++--------------
>   samples/vfio-mdev/mdpy.c                      | 21 +++++--------------
>   samples/vfio-mdev/mtty.c                      | 18 ++++------------
>   10 files changed, 26 insertions(+), 72 deletions(-)
>
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index b0c29e37f61b4..dcd1231a6fa84 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -217,7 +217,7 @@ Directories and files under the sysfs for Each Physical Device
>   
>   * name
>   
> -  This attribute should show human readable name. This is optional attribute.
> +  This attribute shows a human readable name.
>   
>   * description
>   
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 1ed99091165a4..e24e72527c9aa 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -138,20 +138,12 @@ static ssize_t description_show(struct mdev_type *mtype,
>   		       type->conf->weight);
>   }
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", mtype->sysfs_name);
> -}
> -
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   static MDEV_TYPE_ATTR_RO(description);
> -static MDEV_TYPE_ATTR_RO(name);
>   
>   static const struct attribute *gvt_type_attrs[] = {
>   	&mdev_type_attr_available_instances.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_name.attr,
>   	NULL,
>   };
>   
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 25a5de08b3902..e5f21c725326b 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -221,6 +221,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>   	dev_set_drvdata(&sch->dev, private);
>   
>   	private->mdev_type.sysfs_name = "io";
> +	private->mdev_type.pretty_name = "I/O subchannel (Non-QDIO)";
>   	private->mdev_types[0] = &private->mdev_type;
>   	ret = mdev_register_parent(&private->parent, &sch->dev,
>   				   &vfio_ccw_mdev_driver,
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 9ced2063720e6..854e0aaefc022 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -44,13 +44,6 @@ static void vfio_ccw_dma_unmap(struct vfio_device *vdev, u64 iova, u64 length)
>   	vfio_ccw_mdev_reset(private);
>   }
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "I/O subchannel (Non-QDIO)\n");
> -}
> -static MDEV_TYPE_ATTR_RO(name);
> -
>   static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
> @@ -62,7 +55,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *mdev_types_attrs[] = {
> -	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 728a0ada4928f..9dedb0db8ee84 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -784,14 +784,6 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
>   	atomic_inc(&matrix_dev->available_instances);
>   }
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_AP_MDEV_NAME_HWVIRT);
> -}
> -
> -static MDEV_TYPE_ATTR_RO(name);
> -
>   static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
> @@ -803,7 +795,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *vfio_ap_mdev_type_attrs[] = {
> -	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 89637bc85462a..0f3d0bbf36f75 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -81,9 +81,19 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(device_api);
>   
> +static ssize_t name_show(struct mdev_type *mtype,
> +			 struct mdev_type_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%s\n",
> +		mtype->pretty_name ? mtype->pretty_name : mtype->sysfs_name);
> +}
> +
> +static MDEV_TYPE_ATTR_RO(name);
> +
>   static struct attribute *mdev_types_core_attrs[] = {
>   	&mdev_type_attr_create.attr,
>   	&mdev_type_attr_device_api.attr,
> +	&mdev_type_attr_name.attr,
>   	NULL,
>   };
>   
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index af1ff0165b8d3..4bb8a58b577b3 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -26,6 +26,7 @@ struct mdev_device {
>   struct mdev_type {
>   	/* set by the driver before calling mdev_register parent: */
>   	const char *sysfs_name;
> +	const char *pretty_name;
>   
>   	/* set by the core, can be used drivers */
>   	struct mdev_parent *parent;
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 199846f01de92..c8271168a96ad 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -101,26 +101,25 @@ MODULE_PARM_DESC(mem, "megabytes available to " MBOCHS_NAME " devices");
>   
>   static struct mbochs_type {
>   	struct mdev_type type;
> -	const char *name;
>   	u32 mbytes;
>   	u32 max_x;
>   	u32 max_y;
>   } mbochs_types[] = {
>   	{
>   		.type.sysfs_name	= MBOCHS_TYPE_1,
> -		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_1,
> +		.type.pretty_name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_1,
>   		.mbytes = 4,
>   		.max_x  = 800,
>   		.max_y  = 600,
>   	}, {
>   		.type.sysfs_name	= MBOCHS_TYPE_2,
> -		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_2,
> +		.type.pretty_name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_2,
>   		.mbytes = 16,
>   		.max_x  = 1920,
>   		.max_y  = 1440,
>   	}, {
>   		.type.sysfs_name	= MBOCHS_TYPE_3,
> -		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_3,
> +		.type.pretty_name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_3,
>   		.mbytes = 64,
>   		.max_x  = 0,
>   		.max_y  = 0,
> @@ -547,7 +546,7 @@ static int mbochs_probe(struct mdev_device *mdev)
>   		goto err_mem;
>   
>   	dev_info(dev, "%s: %s, %d MB, %ld pages\n", __func__,
> -		 type->name, type->mbytes, mdev_state->pagecount);
> +		 type->type.pretty_name, type->mbytes, mdev_state->pagecount);
>   
>   	mutex_init(&mdev_state->ops_lock);
>   	mdev_state->mdev = mdev;
> @@ -1334,16 +1333,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   	NULL,
>   };
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	struct mbochs_type *type =
> -		container_of(mtype, struct mbochs_type, type);
> -
> -	return sprintf(buf, "%s\n", type->name);
> -}
> -static MDEV_TYPE_ATTR_RO(name);
> -
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> @@ -1368,7 +1357,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *mdev_types_attrs[] = {
> -	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index b8d6eeff2033d..6091c642ee102 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -53,7 +53,6 @@ MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
>   
>   static struct mdpy_type {
>   	struct mdev_type type;
> -	const char *name;
>   	u32 format;
>   	u32 bytepp;
>   	u32 width;
> @@ -61,21 +60,21 @@ static struct mdpy_type {
>   } mdpy_types[] = {
>   	{
>   		.type.sysfs_name 	= MDPY_TYPE_1,
> -		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_1,
> +		.type.pretty_name	= MDPY_CLASS_NAME "-" MDPY_TYPE_1,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
>   		.width	= 640,
>   		.height = 480,
>   	}, {
>   		.type.sysfs_name 	= MDPY_TYPE_2,
> -		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_2,
> +		.type.pretty_name	= MDPY_CLASS_NAME "-" MDPY_TYPE_2,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
>   		.width	= 1024,
>   		.height = 768,
>   	}, {
>   		.type.sysfs_name 	= MDPY_TYPE_3,
> -		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_3,
> +		.type.pretty_name	= MDPY_CLASS_NAME "-" MDPY_TYPE_3,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
>   		.width	= 1920,
> @@ -256,8 +255,8 @@ static int mdpy_probe(struct mdev_device *mdev)
>   		ret = -ENOMEM;
>   		goto err_vconfig;
>   	}
> -	dev_info(dev, "%s: %s (%dx%d)\n", __func__, type->name, type->width,
> -		 type->height);
> +	dev_info(dev, "%s: %s (%dx%d)\n", __func__, type->type.pretty_name,
> +		 type->width, type->height);
>   
>   	mutex_init(&mdev_state->ops_lock);
>   	mdev_state->mdev = mdev;
> @@ -651,15 +650,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   	NULL,
>   };
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
> -
> -	return sprintf(buf, "%s\n", type->name);
> -}
> -static MDEV_TYPE_ATTR_RO(name);
> -
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> @@ -679,7 +669,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *mdev_types_attrs[] = {
> -	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 2a470424628af..b95a4491265c5 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -146,10 +146,11 @@ struct mdev_state {
>   static struct mtty_type {
>   	struct mdev_type type;
>   	int nr_ports;
> -	const char *name;
>   } mtty_types[2] = {
> -	{ .nr_ports = 1, .type.sysfs_name = "1", .name = "Single port serial" },
> -	{ .nr_ports = 2, .type.sysfs_name = "2", .name = "Dual port serial" },
> +	{ .nr_ports = 1, .type.sysfs_name = "1",
> +	  .type.pretty_name = "Single port serial" },
> +	{ .nr_ports = 2, .type.sysfs_name = "2",
> +	  .type.pretty_name = "Dual port serial" },
>   };
>   
>   static struct mdev_type *mtty_mdev_types[] = {
> @@ -1246,16 +1247,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   	NULL,
>   };
>   
> -static ssize_t name_show(struct mdev_type *mtype,
> -			 struct mdev_type_attribute *attr, char *buf)
> -{
> -	struct mtty_type *type = container_of(mtype, struct mtty_type, type);
> -
> -	return sysfs_emit(buf, "%s\n", type->name);
> -}
> -
> -static MDEV_TYPE_ATTR_RO(name);
> -
>   static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
> @@ -1269,7 +1260,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *mdev_types_attrs[] = {
> -	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
