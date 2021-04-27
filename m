Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635EB36CC17
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 22:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhD0UHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 16:07:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235514AbhD0UHA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 16:07:00 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13RK4RQ7182399;
        Tue, 27 Apr 2021 16:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=PZf3s/DbWLkTNVvKLoYM029m1PrWGtb6BskLemWYVJA=;
 b=iKcawfGEYG2C4UirW4PqZ29ZcJExlKWOU0dnS63A49UMF3EhaZpBnUUe2umDz+24i+bq
 0Aarbqfh39lMoojDwzcAJkTLuEItpFDQDZs3PInP44rRAoUnxHK4Cz/Fx+7tfxZvevll
 MyNuUo7B9t5n5/9oGbERGCH5MDoHJxKheqw4sbXUd1e6Enk+isyc97jYS66q3GUK0JX7
 GJ/uKqwmLPB0PL7UejMyiKxB/XXWuDmzaT3MUcmMd+n99j2EnOtbYgDJbXXM+SQW/TAX
 OEWQuPYNIks3N6MTLqFxf/pANjkaFgnkPseSiwYoix6dqVLjBhHgImrQWVnenuegSm+S Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 386s1vggxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 16:06:10 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13RK4SZX182437;
        Tue, 27 Apr 2021 16:06:10 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 386s1vggx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 16:06:10 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13RJvHrc002497;
        Tue, 27 Apr 2021 20:06:09 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 384ay95ru3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 20:06:09 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13RK68a830015820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 20:06:08 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2647A6A057;
        Tue, 27 Apr 2021 20:06:08 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A9676A054;
        Tue, 27 Apr 2021 20:06:04 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.111.105])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 27 Apr 2021 20:06:04 +0000 (GMT)
Message-ID: <5325cd47bf170b66591bc1e64bf9fa3aa9c365b5.camel@linux.ibm.com>
Subject: Re: [PATCH v2 07/13] vfio/ccw: Convert to use
 vfio_register_group_dev()
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Date:   Tue, 27 Apr 2021 16:06:04 -0400
In-Reply-To: <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Dcbi-HSp6CWG786t-C6SQXwFnmOBhSiU
X-Proofpoint-GUID: uKNJ0wwAipm3PltDWQjWhomuu2b2dyim
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_11:2021-04-27,2021-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 impostorscore=0 clxscore=1011 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270134
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-26 at 17:00 -0300, Jason Gunthorpe wrote:
> This is more complicated because vfio_ccw is sharing the vfio_device
> between both the mdev_device and its vfio_device and the css_driver.
> 
> The mdev is a singleton, and the reason for this sharing appears to
> be to
> allow the extra css_driver function callbacks to be delivered to the
> vfio_device.
> 
> This keeps things as they were, with the css_driver allocating the
> singleton, not the mdev_driver, this is pretty confusing. I'm also
> uncertain how the lifetime model for the mdev works in the css_driver
> callbacks.
> 
> At this point embed the vfio_device in the vfio_ccw_private and
> instantiate it as a vfio_device when the mdev probes. The drvdata of
> both
> the css_device and the mdev_device point at the private, and
> container_of
> is used to get it back from the vfio_device.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c     |  21 +++--
>  drivers/s390/cio/vfio_ccw_ops.c     | 135 +++++++++++++++-----------
> --
>  drivers/s390/cio/vfio_ccw_private.h |   5 ++
>  3 files changed, 94 insertions(+), 67 deletions(-)
> 
> 

...snip...

> diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> b/drivers/s390/cio/vfio_ccw_ops.c
> index 491a64c61fff1a..0fcf46031d3821 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -17,13 +17,13 @@
>  
>  #include "vfio_ccw_private.h"
>  
> -static int vfio_ccw_mdev_reset(struct mdev_device *mdev)
> +static const struct vfio_device_ops vfio_ccw_dev_ops;
> +
> +static int vfio_ccw_mdev_reset(struct vfio_ccw_private *private)
>  {
> -	struct vfio_ccw_private *private;
>  	struct subchannel *sch;
>  	int ret;
>  
> -	private = dev_get_drvdata(mdev_parent_dev(mdev));
>  	sch = private->sch;
>  	/*
>  	 * TODO:
> @@ -61,7 +61,7 @@ static int vfio_ccw_mdev_notifier(struct
> notifier_block *nb,
>  		if (!cp_iova_pinned(&private->cp, unmap->iova))
>  			return NOTIFY_OK;
>  
> -		if (vfio_ccw_mdev_reset(private->mdev))
> +		if (vfio_ccw_mdev_reset(private))
>  			return NOTIFY_BAD;
>  
>  		cp_free(&private->cp);
> @@ -113,10 +113,11 @@ static struct attribute_group
> *mdev_type_groups[] = {
>  	NULL,
>  };
>  
> -static int vfio_ccw_mdev_create(struct mdev_device *mdev)
> +static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>  {
>  	struct vfio_ccw_private *private =
>  		dev_get_drvdata(mdev_parent_dev(mdev));
> +	int ret;
>  
>  	if (private->state == VFIO_CCW_STATE_NOT_OPER)
>  		return -ENODEV;
> @@ -124,6 +125,10 @@ static int vfio_ccw_mdev_create(struct
> mdev_device *mdev)
>  	if (atomic_dec_if_positive(&private->avail) < 0)
>  		return -EPERM;
>  
> +	memset(&private->vdev, 0, sizeof(private->vdev));
> +	vfio_init_group_dev(&private->vdev, &mdev->dev,
> +			    &vfio_ccw_dev_ops);
> +
>  	private->mdev = mdev;
>  	private->state = VFIO_CCW_STATE_IDLE;
>  
> @@ -132,19 +137,28 @@ static int vfio_ccw_mdev_create(struct
> mdev_device *mdev)
>  			   private->sch->schid.ssid,
>  			   private->sch->schid.sch_no);
>  
> +	ret = vfio_register_group_dev(&private->vdev);
> +	if (ret)
> +		goto err_atomic;
> +	dev_set_drvdata(&mdev->dev, private);
>  	return 0;
> +
> +err_atomic:
> +	atomic_inc(&private->avail);

Since we're unwinding, should also do

private->mdev = NULL
private->state = VFIO_CCW_STATE_STANDBY

> +	return ret;
>  }
>  
> -static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
> +static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
>  {
> -	struct vfio_ccw_private *private =
> -		dev_get_drvdata(mdev_parent_dev(mdev));
> +	struct vfio_ccw_private *private = dev_get_drvdata(&mdev->dev);
>  
>  	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: remove\n",
>  			   mdev_uuid(mdev), private->sch->schid.cssid,
>  			   private->sch->schid.ssid,
>  			   private->sch->schid.sch_no);
>  
> +	vfio_unregister_group_dev(&private->vdev);
> +
>  	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
>  	    (private->state != VFIO_CCW_STATE_STANDBY)) {
>  		if (!vfio_ccw_sch_quiesce(private->sch))
> @@ -155,20 +169,18 @@ static int vfio_ccw_mdev_remove(struct
> mdev_device *mdev)
>  	cp_free(&private->cp);
>  	private->mdev = NULL;
>  	atomic_inc(&private->avail);
> -
> -	return 0;
>  }
>  
> -static int vfio_ccw_mdev_open(struct mdev_device *mdev)
> +static int vfio_ccw_mdev_open(struct vfio_device *vdev)
>  {
>  	struct vfio_ccw_private *private =
> -		dev_get_drvdata(mdev_parent_dev(mdev));
> +		container_of(vdev, struct vfio_ccw_private, vdev);
>  	unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
>  	int ret;
>  
>  	private->nb.notifier_call = vfio_ccw_mdev_notifier;
>  
> -	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> +	ret = vfio_register_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
>  				     &events, &private->nb);
>  	if (ret)
>  		return ret;
> @@ -189,27 +201,26 @@ static int vfio_ccw_mdev_open(struct
> mdev_device *mdev)
>  
>  out_unregister:
>  	vfio_ccw_unregister_dev_regions(private);
> -	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> +	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
>  				 &private->nb);
>  	return ret;
>  }
>  
> -static void vfio_ccw_mdev_release(struct mdev_device *mdev)
> +static void vfio_ccw_mdev_release(struct vfio_device *vdev)
>  {
>  	struct vfio_ccw_private *private =
> -		dev_get_drvdata(mdev_parent_dev(mdev));
> +		container_of(vdev, struct vfio_ccw_private, vdev);
>  
>  	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
>  	    (private->state != VFIO_CCW_STATE_STANDBY)) {
> -		if (!vfio_ccw_mdev_reset(mdev))
> +		if (!vfio_ccw_mdev_reset(private))
>  			private->state = VFIO_CCW_STATE_STANDBY;
>  		/* The state will be NOT_OPER on error. */
>  	}
>  
>  	cp_free(&private->cp);
>  	vfio_ccw_unregister_dev_regions(private);
> -	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> -				 &private->nb);
> +	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
> &private->nb);
>  }
>  
>  static ssize_t vfio_ccw_mdev_read_io_region(struct vfio_ccw_private
> *private,
> @@ -233,15 +244,14 @@ static ssize_t
> vfio_ccw_mdev_read_io_region(struct vfio_ccw_private *private,
>  	return ret;
>  }
>  
> -static ssize_t vfio_ccw_mdev_read(struct mdev_device *mdev,
> +static ssize_t vfio_ccw_mdev_read(struct vfio_device *vdev,
>  				  char __user *buf,
>  				  size_t count,
>  				  loff_t *ppos)
>  {
> +	struct vfio_ccw_private *private =
> +		container_of(vdev, struct vfio_ccw_private, vdev);
>  	unsigned int index = VFIO_CCW_OFFSET_TO_INDEX(*ppos);
> -	struct vfio_ccw_private *private;
> -
> -	private = dev_get_drvdata(mdev_parent_dev(mdev));
>  
>  	if (index >= VFIO_CCW_NUM_REGIONS + private->num_regions)
>  		return -EINVAL;
> @@ -288,15 +298,14 @@ static ssize_t
> vfio_ccw_mdev_write_io_region(struct vfio_ccw_private *private,
>  	return ret;
>  }
>  
> -static ssize_t vfio_ccw_mdev_write(struct mdev_device *mdev,
> +static ssize_t vfio_ccw_mdev_write(struct vfio_device *vdev,
>  				   const char __user *buf,
>  				   size_t count,
>  				   loff_t *ppos)
>  {
> +	struct vfio_ccw_private *private =
> +		container_of(vdev, struct vfio_ccw_private, vdev);
>  	unsigned int index = VFIO_CCW_OFFSET_TO_INDEX(*ppos);
> -	struct vfio_ccw_private *private;
> -
> -	private = dev_get_drvdata(mdev_parent_dev(mdev));
>  
>  	if (index >= VFIO_CCW_NUM_REGIONS + private->num_regions)
>  		return -EINVAL;
> @@ -313,12 +322,9 @@ static ssize_t vfio_ccw_mdev_write(struct
> mdev_device *mdev,
>  	return -EINVAL;
>  }
>  
> -static int vfio_ccw_mdev_get_device_info(struct vfio_device_info
> *info,
> -					 struct mdev_device *mdev)
> +static int vfio_ccw_mdev_get_device_info(struct vfio_ccw_private
> *private,
> +					 struct vfio_device_info *info)
>  {
> -	struct vfio_ccw_private *private;
> -
> -	private = dev_get_drvdata(mdev_parent_dev(mdev));
>  	info->flags = VFIO_DEVICE_FLAGS_CCW | VFIO_DEVICE_FLAGS_RESET;
>  	info->num_regions = VFIO_CCW_NUM_REGIONS + private-
> >num_regions;
>  	info->num_irqs = VFIO_CCW_NUM_IRQS;
> @@ -326,14 +332,12 @@ static int vfio_ccw_mdev_get_device_info(struct
> vfio_device_info *info,
>  	return 0;
>  }
>  
> -static int vfio_ccw_mdev_get_region_info(struct vfio_region_info
> *info,
> -					 struct mdev_device *mdev,
> +static int vfio_ccw_mdev_get_region_info(struct vfio_ccw_private
> *private,
> +					 struct vfio_region_info *info,
>  					 unsigned long arg)
>  {
> -	struct vfio_ccw_private *private;
>  	int i;
>  
> -	private = dev_get_drvdata(mdev_parent_dev(mdev));
>  	switch (info->index) {
>  	case VFIO_CCW_CONFIG_REGION_INDEX:
>  		info->offset = 0;
> @@ -408,19 +412,16 @@ static int vfio_ccw_mdev_get_irq_info(struct
> vfio_irq_info *info)
>  	return 0;
>  }
>  
> -static int vfio_ccw_mdev_set_irqs(struct mdev_device *mdev,
> +static int vfio_ccw_mdev_set_irqs(struct vfio_ccw_private *private,
>  				  uint32_t flags,
>  				  uint32_t index,
>  				  void __user *data)
>  {
> -	struct vfio_ccw_private *private;
>  	struct eventfd_ctx **ctx;
>  
>  	if (!(flags & VFIO_IRQ_SET_ACTION_TRIGGER))
>  		return -EINVAL;
>  
> -	private = dev_get_drvdata(mdev_parent_dev(mdev));
> -
>  	switch (index) {
>  	case VFIO_CCW_IO_IRQ_INDEX:
>  		ctx = &private->io_trigger;
> @@ -522,10 +523,12 @@ void vfio_ccw_unregister_dev_regions(struct
> vfio_ccw_private *private)
>  	private->region = NULL;
>  }
>  
> -static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
> +static ssize_t vfio_ccw_mdev_ioctl(struct vfio_device *vdev,
>  				   unsigned int cmd,
>  				   unsigned long arg)
>  {
> +	struct vfio_ccw_private *private =
> +		container_of(vdev, struct vfio_ccw_private, vdev);
>  	int ret = 0;
>  	unsigned long minsz;
>  
> @@ -542,7 +545,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct
> mdev_device *mdev,
>  		if (info.argsz < minsz)
>  			return -EINVAL;
>  
> -		ret = vfio_ccw_mdev_get_device_info(&info, mdev);
> +		ret = vfio_ccw_mdev_get_device_info(private, &info);
>  		if (ret)
>  			return ret;
>  
> @@ -560,7 +563,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct
> mdev_device *mdev,
>  		if (info.argsz < minsz)
>  			return -EINVAL;
>  
> -		ret = vfio_ccw_mdev_get_region_info(&info, mdev, arg);
> +		ret = vfio_ccw_mdev_get_region_info(private, &info,
> arg);
>  		if (ret)
>  			return ret;
>  
> @@ -605,47 +608,59 @@ static ssize_t vfio_ccw_mdev_ioctl(struct
> mdev_device *mdev,
>  			return ret;
>  
>  		data = (void __user *)(arg + minsz);
> -		return vfio_ccw_mdev_set_irqs(mdev, hdr.flags,
> hdr.index, data);
> +		return vfio_ccw_mdev_set_irqs(private, hdr.flags,
> hdr.index,
> +					      data);
>  	}
>  	case VFIO_DEVICE_RESET:
> -		return vfio_ccw_mdev_reset(mdev);
> +		return vfio_ccw_mdev_reset(private);
>  	default:
>  		return -ENOTTY;
>  	}
>  }
>  
>  /* Request removal of the device*/
> -static void vfio_ccw_mdev_request(struct mdev_device *mdev, unsigned
> int count)
> +static void vfio_ccw_mdev_request(struct vfio_device *vdev, unsigned
> int count)
>  {
> -	struct vfio_ccw_private *private =
> dev_get_drvdata(mdev_parent_dev(mdev));
> -
> -	if (!private)
> -		return;
> +	struct vfio_ccw_private *private =
> +		container_of(vdev, struct vfio_ccw_private, vdev);
> +	struct device *dev = private->vdev.dev;

This could be simply vdev->dev.
The rest seems okay.

Thanks,
Eric

>  
>  	if (private->req_trigger) {
>  		if (!(count % 10))
> -			dev_notice_ratelimited(mdev_dev(private->mdev),
> +			dev_notice_ratelimited(dev,
>  					       "Relaying device request
> to user (#%u)\n",
>  					       count);
>  
>  		eventfd_signal(private->req_trigger, 1);
>  	} else if (count == 0) {
> -		dev_notice(mdev_dev(private->mdev),
> +		dev_notice(dev,
>  			   "No device request channel registered,
> blocked until released by user\n");
>  	}
>  }
>  
> +static const struct vfio_device_ops vfio_ccw_dev_ops = {
> +	.open = vfio_ccw_mdev_open,
> +	.release = vfio_ccw_mdev_release,
> +	.read = vfio_ccw_mdev_read,
> +	.write = vfio_ccw_mdev_write,
> +	.ioctl = vfio_ccw_mdev_ioctl,
> +	.request = vfio_ccw_mdev_request,
> +};
> +
> +struct mdev_driver vfio_ccw_mdev_driver = {
> +	.driver = {
> +		.name = "vfio_ccw_mdev",
> +		.owner = THIS_MODULE,
> +		.mod_name = KBUILD_MODNAME,
> +	},
> +	.probe = vfio_ccw_mdev_probe,
> +	.remove = vfio_ccw_mdev_remove,
> +};
> +
>  static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
>  	.owner			= THIS_MODULE,
> +	.device_driver		= &vfio_ccw_mdev_driver,
>  	.supported_type_groups  = mdev_type_groups,
> -	.create			= vfio_ccw_mdev_create,
> -	.remove			= vfio_ccw_mdev_remove,
> -	.open			= vfio_ccw_mdev_open,
> -	.release		= vfio_ccw_mdev_release,
> -	.read			= vfio_ccw_mdev_read,
> -	.write			= vfio_ccw_mdev_write,
> -	.ioctl			= vfio_ccw_mdev_ioctl,
> -	.request		= vfio_ccw_mdev_request,
>  };
>  
>  int vfio_ccw_mdev_reg(struct subchannel *sch)
> diff --git a/drivers/s390/cio/vfio_ccw_private.h
> b/drivers/s390/cio/vfio_ccw_private.h
> index b2c762eb42b9bb..7272eb78861244 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -17,6 +17,7 @@
>  #include <linux/eventfd.h>
>  #include <linux/workqueue.h>
>  #include <linux/vfio_ccw.h>
> +#include <linux/vfio.h>
>  #include <asm/crw.h>
>  #include <asm/debug.h>
>  
> @@ -67,6 +68,7 @@ struct vfio_ccw_crw {
>  
>  /**
>   * struct vfio_ccw_private
> + * @vdev: Embedded VFIO device
>   * @sch: pointer to the subchannel
>   * @state: internal state of the device
>   * @completion: synchronization helper of the I/O completion
> @@ -90,6 +92,7 @@ struct vfio_ccw_crw {
>   * @crw_work: work for deferral process of CRW handling
>   */
>  struct vfio_ccw_private {
> +	struct vfio_device vdev;
>  	struct subchannel	*sch;
>  	int			state;
>  	struct completion	*completion;
> @@ -121,6 +124,8 @@ extern void vfio_ccw_mdev_unreg(struct subchannel
> *sch);
>  
>  extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
>  
> +extern struct mdev_driver vfio_ccw_mdev_driver;
> +
>  /*
>   * States of the device statemachine.
>   */

