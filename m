Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B0B17B78
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfEHOYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:24:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726830AbfEHOYI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 10:24:08 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48EGjG8025689
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 10:24:03 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sbxxhpsgq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 10:24:02 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 8 May 2019 15:24:01 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 15:23:57 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48ENtgn41877740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 14:23:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01AF842041;
        Wed,  8 May 2019 14:23:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F66442047;
        Wed,  8 May 2019 14:23:54 +0000 (GMT)
Received: from [9.145.42.10] (unknown [9.145.42.10])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 14:23:54 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 06/10] s390/cio: add basic protected virtualization
 support
To:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-7-pasic@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 8 May 2019 16:23:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426183245.37939-7-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050814-4275-0000-0000-00000332A99D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050814-4276-0000-0000-00003842191F
Message-Id: <eec134d9-115c-4bdb-f028-3faaa46a7c58@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/2019 20:32, Halil Pasic wrote:
> As virtio-ccw devices are channel devices, we need to use the dma area
> for any communication with the hypervisor.
> 
> This patch addresses the most basic stuff (mostly what is required for
> virtio-ccw), and does take care of QDIO or any devices.
> 
> An interesting side effect is that virtio structures are now going to
> get allocated in 31 bit addressable storage.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>   arch/s390/include/asm/ccwdev.h   |  4 +++
>   drivers/s390/cio/ccwreq.c        |  8 ++---
>   drivers/s390/cio/device.c        | 65 +++++++++++++++++++++++++++++++++-------
>   drivers/s390/cio/device_fsm.c    | 40 ++++++++++++-------------
>   drivers/s390/cio/device_id.c     | 18 +++++------
>   drivers/s390/cio/device_ops.c    | 21 +++++++++++--
>   drivers/s390/cio/device_pgid.c   | 20 ++++++-------
>   drivers/s390/cio/device_status.c | 24 +++++++--------
>   drivers/s390/cio/io_sch.h        | 21 +++++++++----
>   drivers/s390/virtio/virtio_ccw.c | 10 -------
>   10 files changed, 148 insertions(+), 83 deletions(-)
> 
> diff --git a/arch/s390/include/asm/ccwdev.h b/arch/s390/include/asm/ccwdev.h
> index a29dd430fb40..865ce1cb86d5 100644
> --- a/arch/s390/include/asm/ccwdev.h
> +++ b/arch/s390/include/asm/ccwdev.h
> @@ -226,6 +226,10 @@ extern int ccw_device_enable_console(struct ccw_device *);
>   extern void ccw_device_wait_idle(struct ccw_device *);
>   extern int ccw_device_force_console(struct ccw_device *);
> 
> +extern void *ccw_device_dma_zalloc(struct ccw_device *cdev, size_t size);
> +extern void ccw_device_dma_free(struct ccw_device *cdev,
> +				void *cpu_addr, size_t size);
> +
>   int ccw_device_siosl(struct ccw_device *);
> 
>   extern void ccw_device_get_schid(struct ccw_device *, struct subchannel_id *);
> diff --git a/drivers/s390/cio/ccwreq.c b/drivers/s390/cio/ccwreq.c
> index 603268a33ea1..dafbceb311b3 100644
> --- a/drivers/s390/cio/ccwreq.c
> +++ b/drivers/s390/cio/ccwreq.c
> @@ -63,7 +63,7 @@ static void ccwreq_stop(struct ccw_device *cdev, int rc)
>   		return;
>   	req->done = 1;
>   	ccw_device_set_timeout(cdev, 0);
> -	memset(&cdev->private->irb, 0, sizeof(struct irb));
> +	memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
>   	if (rc && rc != -ENODEV && req->drc)
>   		rc = req->drc;
>   	req->callback(cdev, req->data, rc);
> @@ -86,7 +86,7 @@ static void ccwreq_do(struct ccw_device *cdev)
>   			continue;
>   		}
>   		/* Perform start function. */
> -		memset(&cdev->private->irb, 0, sizeof(struct irb));
> +		memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
>   		rc = cio_start(sch, cp, (u8) req->mask);
>   		if (rc == 0) {
>   			/* I/O started successfully. */
> @@ -169,7 +169,7 @@ int ccw_request_cancel(struct ccw_device *cdev)
>    */
>   static enum io_status ccwreq_status(struct ccw_device *cdev, struct irb *lcirb)
>   {
> -	struct irb *irb = &cdev->private->irb;
> +	struct irb *irb = &cdev->private->dma_area->irb;
>   	struct cmd_scsw *scsw = &irb->scsw.cmd;
>   	enum uc_todo todo;
> 
> @@ -187,7 +187,7 @@ static enum io_status ccwreq_status(struct ccw_device *cdev, struct irb *lcirb)
>   		CIO_TRACE_EVENT(2, "sensedata");
>   		CIO_HEX_EVENT(2, &cdev->private->dev_id,
>   			      sizeof(struct ccw_dev_id));
> -		CIO_HEX_EVENT(2, &cdev->private->irb.ecw, SENSE_MAX_COUNT);
> +		CIO_HEX_EVENT(2, &cdev->private->dma_area->irb.ecw, SENSE_MAX_COUNT);
>   		/* Check for command reject. */
>   		if (irb->ecw[0] & SNS0_CMD_REJECT)
>   			return IO_REJECTED;
> diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
> index 1540229a37bb..a3310ee14a4a 100644
> --- a/drivers/s390/cio/device.c
> +++ b/drivers/s390/cio/device.c
> @@ -24,6 +24,7 @@
>   #include <linux/timer.h>
>   #include <linux/kernel_stat.h>
>   #include <linux/sched/signal.h>
> +#include <linux/dma-mapping.h>
> 
>   #include <asm/ccwdev.h>
>   #include <asm/cio.h>
> @@ -687,6 +688,9 @@ ccw_device_release(struct device *dev)
>   	struct ccw_device *cdev;
> 
>   	cdev = to_ccwdev(dev);
> +	cio_gp_dma_free(cdev->private->dma_pool, cdev->private->dma_area,
> +			sizeof(*cdev->private->dma_area));
> +	cio_gp_dma_destroy(cdev->private->dma_pool, &cdev->dev);
>   	/* Release reference of parent subchannel. */
>   	put_device(cdev->dev.parent);
>   	kfree(cdev->private);
> @@ -696,15 +700,31 @@ ccw_device_release(struct device *dev)
>   static struct ccw_device * io_subchannel_allocate_dev(struct subchannel *sch)
>   {
>   	struct ccw_device *cdev;
> +	struct gen_pool *dma_pool;
> 
>   	cdev  = kzalloc(sizeof(*cdev), GFP_KERNEL);
> -	if (cdev) {
> -		cdev->private = kzalloc(sizeof(struct ccw_device_private),
> -					GFP_KERNEL | GFP_DMA);
> -		if (cdev->private)
> -			return cdev;
> -	}
> +	if (!cdev)
> +		goto err_cdev;
> +	cdev->private = kzalloc(sizeof(struct ccw_device_private),
> +				GFP_KERNEL | GFP_DMA);
> +	if (!cdev->private)
> +		goto err_priv;
> +	cdev->dev.dma_mask = &cdev->private->dma_mask;
> +	*cdev->dev.dma_mask = *sch->dev.dma_mask;
> +	cdev->dev.coherent_dma_mask = sch->dev.coherent_dma_mask;
> +	dma_pool = cio_gp_dma_create(&cdev->dev, 1);
> +	cdev->private->dma_pool = dma_pool;
> +	cdev->private->dma_area = cio_gp_dma_zalloc(dma_pool, &cdev->dev,
> +					sizeof(*cdev->private->dma_area));
> +	if (!cdev->private->dma_area)
> +		goto err_dma_area;
> +	return cdev;
> +err_dma_area:
> +	cio_gp_dma_destroy(dma_pool, &cdev->dev);
> +	kfree(cdev->private);
> +err_priv:
>   	kfree(cdev);
> +err_cdev:
>   	return ERR_PTR(-ENOMEM);
>   }
> 
> @@ -884,7 +904,7 @@ io_subchannel_recog_done(struct ccw_device *cdev)
>   			wake_up(&ccw_device_init_wq);
>   		break;
>   	case DEV_STATE_OFFLINE:
> -		/*
> +		/*
>   		 * We can't register the device in interrupt context so
>   		 * we schedule a work item.
>   		 */
> @@ -1062,6 +1082,14 @@ static int io_subchannel_probe(struct subchannel *sch)
>   	if (!io_priv)
>   		goto out_schedule;
> 
> +	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
> +				sizeof(*io_priv->dma_area),
> +				&io_priv->dma_area_dma, GFP_KERNEL);
> +	if (!io_priv->dma_area) {
> +		kfree(io_priv);
> +		goto out_schedule;
> +	}
> +
>   	set_io_private(sch, io_priv);
>   	css_schedule_eval(sch->schid);
>   	return 0;
> @@ -1088,6 +1116,8 @@ static int io_subchannel_remove(struct subchannel *sch)
>   	set_io_private(sch, NULL);
>   	spin_unlock_irq(sch->lock);
>   out_free:
> +	dma_free_coherent(&sch->dev, sizeof(*io_priv->dma_area),
> +			  io_priv->dma_area, io_priv->dma_area_dma);
>   	kfree(io_priv);
>   	sysfs_remove_group(&sch->dev.kobj, &io_subchannel_attr_group);
>   	return 0;
> @@ -1593,20 +1623,31 @@ struct ccw_device * __init ccw_device_create_console(struct ccw_driver *drv)
>   		return ERR_CAST(sch);
> 
>   	io_priv = kzalloc(sizeof(*io_priv), GFP_KERNEL | GFP_DMA);
> -	if (!io_priv) {
> -		put_device(&sch->dev);
> -		return ERR_PTR(-ENOMEM);
> -	}
> +	if (!io_priv)
> +		goto err_priv;
> +	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
> +				sizeof(*io_priv->dma_area),
> +				&io_priv->dma_area_dma, GFP_KERNEL);
> +	if (!io_priv->dma_area)
> +		goto err_dma_area;
>   	set_io_private(sch, io_priv);
>   	cdev = io_subchannel_create_ccwdev(sch);
>   	if (IS_ERR(cdev)) {
>   		put_device(&sch->dev);
> +		dma_free_coherent(&sch->dev, sizeof(*io_priv->dma_area),
> +				  io_priv->dma_area, io_priv->dma_area_dma);
>   		kfree(io_priv);
>   		return cdev;
>   	}
>   	cdev->drv = drv;
>   	ccw_device_set_int_class(cdev);
>   	return cdev;
> +
> +err_dma_area:
> +		kfree(io_priv);
> +err_priv:
> +	put_device(&sch->dev);
> +	return ERR_PTR(-ENOMEM);
>   }
> 
>   void __init ccw_device_destroy_console(struct ccw_device *cdev)
> @@ -1617,6 +1658,8 @@ void __init ccw_device_destroy_console(struct ccw_device *cdev)
>   	set_io_private(sch, NULL);
>   	put_device(&sch->dev);
>   	put_device(&cdev->dev);
> +	dma_free_coherent(&sch->dev, sizeof(*io_priv->dma_area),
> +			  io_priv->dma_area, io_priv->dma_area_dma);
>   	kfree(io_priv);
>   }
> 
> diff --git a/drivers/s390/cio/device_fsm.c b/drivers/s390/cio/device_fsm.c
> index 9169af7dbb43..fea23b44795b 100644
> --- a/drivers/s390/cio/device_fsm.c
> +++ b/drivers/s390/cio/device_fsm.c
> @@ -67,8 +67,8 @@ static void ccw_timeout_log(struct ccw_device *cdev)
>   			       sizeof(struct tcw), 0);
>   	} else {
>   		printk(KERN_WARNING "cio: orb indicates command mode\n");
> -		if ((void *)(addr_t)orb->cmd.cpa == &private->sense_ccw ||
> -		    (void *)(addr_t)orb->cmd.cpa == cdev->private->iccws)
> +		if ((void *)(addr_t)orb->cmd.cpa == &private->dma_area->sense_ccw ||
> +		    (void *)(addr_t)orb->cmd.cpa == cdev->private->dma_area->iccws)
>   			printk(KERN_WARNING "cio: last channel program "
>   			       "(intern):\n");
>   		else
> @@ -143,18 +143,18 @@ ccw_device_cancel_halt_clear(struct ccw_device *cdev)
>   void ccw_device_update_sense_data(struct ccw_device *cdev)
>   {
>   	memset(&cdev->id, 0, sizeof(cdev->id));
> -	cdev->id.cu_type   = cdev->private->senseid.cu_type;
> -	cdev->id.cu_model  = cdev->private->senseid.cu_model;
> -	cdev->id.dev_type  = cdev->private->senseid.dev_type;
> -	cdev->id.dev_model = cdev->private->senseid.dev_model;
> +	cdev->id.cu_type   = cdev->private->dma_area->senseid.cu_type;
> +	cdev->id.cu_model  = cdev->private->dma_area->senseid.cu_model;
> +	cdev->id.dev_type  = cdev->private->dma_area->senseid.dev_type;
> +	cdev->id.dev_model = cdev->private->dma_area->senseid.dev_model;
>   }
> 
>   int ccw_device_test_sense_data(struct ccw_device *cdev)
>   {
> -	return cdev->id.cu_type == cdev->private->senseid.cu_type &&
> -		cdev->id.cu_model == cdev->private->senseid.cu_model &&
> -		cdev->id.dev_type == cdev->private->senseid.dev_type &&
> -		cdev->id.dev_model == cdev->private->senseid.dev_model;
> +	return cdev->id.cu_type == cdev->private->dma_area->senseid.cu_type &&
> +		cdev->id.cu_model == cdev->private->dma_area->senseid.cu_model &&
> +		cdev->id.dev_type == cdev->private->dma_area->senseid.dev_type &&
> +		cdev->id.dev_model == cdev->private->dma_area->senseid.dev_model;
>   }
> 
>   /*
> @@ -342,7 +342,7 @@ ccw_device_done(struct ccw_device *cdev, int state)
>   		cio_disable_subchannel(sch);
> 
>   	/* Reset device status. */
> -	memset(&cdev->private->irb, 0, sizeof(struct irb));
> +	memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
> 
>   	cdev->private->state = state;
> 
> @@ -509,13 +509,13 @@ void ccw_device_verify_done(struct ccw_device *cdev, int err)
>   		ccw_device_done(cdev, DEV_STATE_ONLINE);
>   		/* Deliver fake irb to device driver, if needed. */
>   		if (cdev->private->flags.fake_irb) {
> -			create_fake_irb(&cdev->private->irb,
> +			create_fake_irb(&cdev->private->dma_area->irb,
>   					cdev->private->flags.fake_irb);
>   			cdev->private->flags.fake_irb = 0;
>   			if (cdev->handler)
>   				cdev->handler(cdev, cdev->private->intparm,
> -					      &cdev->private->irb);
> -			memset(&cdev->private->irb, 0, sizeof(struct irb));
> +					      &cdev->private->dma_area->irb);
> +			memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
>   		}
>   		ccw_device_report_path_events(cdev);
>   		ccw_device_handle_broken_paths(cdev);
> @@ -672,7 +672,7 @@ ccw_device_online_verify(struct ccw_device *cdev, enum dev_event dev_event)
> 
>   	if (scsw_actl(&sch->schib.scsw) != 0 ||
>   	    (scsw_stctl(&sch->schib.scsw) & SCSW_STCTL_STATUS_PEND) ||
> -	    (scsw_stctl(&cdev->private->irb.scsw) & SCSW_STCTL_STATUS_PEND)) {
> +	    (scsw_stctl(&cdev->private->dma_area->irb.scsw) & SCSW_STCTL_STATUS_PEND)) {
>   		/*
>   		 * No final status yet or final status not yet delivered
>   		 * to the device driver. Can't do path verification now,
> @@ -719,7 +719,7 @@ static int ccw_device_call_handler(struct ccw_device *cdev)
>   	 *  - fast notification was requested (primary status)
>   	 *  - unsolicited interrupts
>   	 */
> -	stctl = scsw_stctl(&cdev->private->irb.scsw);
> +	stctl = scsw_stctl(&cdev->private->dma_area->irb.scsw);
>   	ending_status = (stctl & SCSW_STCTL_SEC_STATUS) ||
>   		(stctl == (SCSW_STCTL_ALERT_STATUS | SCSW_STCTL_STATUS_PEND)) ||
>   		(stctl == SCSW_STCTL_STATUS_PEND);
> @@ -735,9 +735,9 @@ static int ccw_device_call_handler(struct ccw_device *cdev)
> 
>   	if (cdev->handler)
>   		cdev->handler(cdev, cdev->private->intparm,
> -			      &cdev->private->irb);
> +			      &cdev->private->dma_area->irb);
> 
> -	memset(&cdev->private->irb, 0, sizeof(struct irb));
> +	memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
>   	return 1;
>   }
> 
> @@ -759,7 +759,7 @@ ccw_device_irq(struct ccw_device *cdev, enum dev_event dev_event)
>   			/* Unit check but no sense data. Need basic sense. */
>   			if (ccw_device_do_sense(cdev, irb) != 0)
>   				goto call_handler_unsol;
> -			memcpy(&cdev->private->irb, irb, sizeof(struct irb));
> +			memcpy(&cdev->private->dma_area->irb, irb, sizeof(struct irb));
>   			cdev->private->state = DEV_STATE_W4SENSE;
>   			cdev->private->intparm = 0;
>   			return;
> @@ -842,7 +842,7 @@ ccw_device_w4sense(struct ccw_device *cdev, enum dev_event dev_event)
>   	if (scsw_fctl(&irb->scsw) &
>   	    (SCSW_FCTL_CLEAR_FUNC | SCSW_FCTL_HALT_FUNC)) {
>   		cdev->private->flags.dosense = 0;
> -		memset(&cdev->private->irb, 0, sizeof(struct irb));
> +		memset(&cdev->private->dma_area->irb, 0, sizeof(struct irb));
>   		ccw_device_accumulate_irb(cdev, irb);
>   		goto call_handler;
>   	}
> diff --git a/drivers/s390/cio/device_id.c b/drivers/s390/cio/device_id.c
> index f6df83a9dfbb..ea8a0fc6c0b6 100644
> --- a/drivers/s390/cio/device_id.c
> +++ b/drivers/s390/cio/device_id.c
> @@ -99,7 +99,7 @@ static int diag210_to_senseid(struct senseid *senseid, struct diag210 *diag)
>   static int diag210_get_dev_info(struct ccw_device *cdev)
>   {
>   	struct ccw_dev_id *dev_id = &cdev->private->dev_id;
> -	struct senseid *senseid = &cdev->private->senseid;
> +	struct senseid *senseid = &cdev->private->dma_area->senseid;
>   	struct diag210 diag_data;
>   	int rc;
> 
> @@ -134,8 +134,8 @@ static int diag210_get_dev_info(struct ccw_device *cdev)
>   static void snsid_init(struct ccw_device *cdev)
>   {
>   	cdev->private->flags.esid = 0;
> -	memset(&cdev->private->senseid, 0, sizeof(cdev->private->senseid));
> -	cdev->private->senseid.cu_type = 0xffff;
> +	memset(&cdev->private->dma_area->senseid, 0, sizeof(cdev->private->dma_area->senseid));
> +	cdev->private->dma_area->senseid.cu_type = 0xffff;
>   }
> 
>   /*
> @@ -143,16 +143,16 @@ static void snsid_init(struct ccw_device *cdev)
>    */
>   static int snsid_check(struct ccw_device *cdev, void *data)
>   {
> -	struct cmd_scsw *scsw = &cdev->private->irb.scsw.cmd;
> +	struct cmd_scsw *scsw = &cdev->private->dma_area->irb.scsw.cmd;
>   	int len = sizeof(struct senseid) - scsw->count;
> 
>   	/* Check for incomplete SENSE ID data. */
>   	if (len < SENSE_ID_MIN_LEN)
>   		goto out_restart;
> -	if (cdev->private->senseid.cu_type == 0xffff)
> +	if (cdev->private->dma_area->senseid.cu_type == 0xffff)
>   		goto out_restart;
>   	/* Check for incompatible SENSE ID data. */
> -	if (cdev->private->senseid.reserved != 0xff)
> +	if (cdev->private->dma_area->senseid.reserved != 0xff)
>   		return -EOPNOTSUPP;
>   	/* Check for extended-identification information. */
>   	if (len > SENSE_ID_BASIC_LEN)
> @@ -170,7 +170,7 @@ static int snsid_check(struct ccw_device *cdev, void *data)
>   static void snsid_callback(struct ccw_device *cdev, void *data, int rc)
>   {
>   	struct ccw_dev_id *id = &cdev->private->dev_id;
> -	struct senseid *senseid = &cdev->private->senseid;
> +	struct senseid *senseid = &cdev->private->dma_area->senseid;
>   	int vm = 0;
> 
>   	if (rc && MACHINE_IS_VM) {
> @@ -200,7 +200,7 @@ void ccw_device_sense_id_start(struct ccw_device *cdev)
>   {
>   	struct subchannel *sch = to_subchannel(cdev->dev.parent);
>   	struct ccw_request *req = &cdev->private->req;
> -	struct ccw1 *cp = cdev->private->iccws;
> +	struct ccw1 *cp = cdev->private->dma_area->iccws;
> 
>   	CIO_TRACE_EVENT(4, "snsid");
>   	CIO_HEX_EVENT(4, &cdev->private->dev_id, sizeof(cdev->private->dev_id));
> @@ -208,7 +208,7 @@ void ccw_device_sense_id_start(struct ccw_device *cdev)
>   	snsid_init(cdev);
>   	/* Channel program setup. */
>   	cp->cmd_code	= CCW_CMD_SENSE_ID;
> -	cp->cda		= (u32) (addr_t) &cdev->private->senseid;
> +	cp->cda		= (u32) (addr_t) &cdev->private->dma_area->senseid;
>   	cp->count	= sizeof(struct senseid);
>   	cp->flags	= CCW_FLAG_SLI;
>   	/* Request setup. */
> diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
> index 4435ae0b3027..be4acfa9265a 100644
> --- a/drivers/s390/cio/device_ops.c
> +++ b/drivers/s390/cio/device_ops.c
> @@ -429,8 +429,8 @@ struct ciw *ccw_device_get_ciw(struct ccw_device *cdev, __u32 ct)
>   	if (cdev->private->flags.esid == 0)
>   		return NULL;
>   	for (ciw_cnt = 0; ciw_cnt < MAX_CIWS; ciw_cnt++)
> -		if (cdev->private->senseid.ciw[ciw_cnt].ct == ct)
> -			return cdev->private->senseid.ciw + ciw_cnt;
> +		if (cdev->private->dma_area->senseid.ciw[ciw_cnt].ct == ct)
> +			return cdev->private->dma_area->senseid.ciw + ciw_cnt;
>   	return NULL;
>   }
> 
> @@ -699,6 +699,23 @@ void ccw_device_get_schid(struct ccw_device *cdev, struct subchannel_id *schid)
>   }
>   EXPORT_SYMBOL_GPL(ccw_device_get_schid);
> 
> +/**
> + * Allocate zeroed dma coherent 31 bit addressable memory using
> + * the subchannels dma pool. Maximal size of allocation supported
> + * is PAGE_SIZE.
> + */
> +void *ccw_device_dma_zalloc(struct ccw_device *cdev, size_t size)
> +{
> +	return cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
> +}
> +EXPORT_SYMBOL(ccw_device_dma_zalloc);
> +
> +void ccw_device_dma_free(struct ccw_device *cdev, void *cpu_addr, size_t size)
> +{
> +	cio_gp_dma_free(cdev->private->dma_pool, cpu_addr, size);
> +}
> +EXPORT_SYMBOL(ccw_device_dma_free);
> +
>   EXPORT_SYMBOL(ccw_device_set_options_mask);
>   EXPORT_SYMBOL(ccw_device_set_options);
>   EXPORT_SYMBOL(ccw_device_clear_options);
> diff --git a/drivers/s390/cio/device_pgid.c b/drivers/s390/cio/device_pgid.c
> index d30a3babf176..e97baa89cbf8 100644
> --- a/drivers/s390/cio/device_pgid.c
> +++ b/drivers/s390/cio/device_pgid.c
> @@ -57,7 +57,7 @@ static void verify_done(struct ccw_device *cdev, int rc)
>   static void nop_build_cp(struct ccw_device *cdev)
>   {
>   	struct ccw_request *req = &cdev->private->req;
> -	struct ccw1 *cp = cdev->private->iccws;
> +	struct ccw1 *cp = cdev->private->dma_area->iccws;
> 
>   	cp->cmd_code	= CCW_CMD_NOOP;
>   	cp->cda		= 0;
> @@ -134,9 +134,9 @@ static void nop_callback(struct ccw_device *cdev, void *data, int rc)
>   static void spid_build_cp(struct ccw_device *cdev, u8 fn)
>   {
>   	struct ccw_request *req = &cdev->private->req;
> -	struct ccw1 *cp = cdev->private->iccws;
> +	struct ccw1 *cp = cdev->private->dma_area->iccws;
>   	int i = pathmask_to_pos(req->lpm);
> -	struct pgid *pgid = &cdev->private->pgid[i];
> +	struct pgid *pgid = &cdev->private->dma_area->pgid[i];
> 
>   	pgid->inf.fc	= fn;
>   	cp->cmd_code	= CCW_CMD_SET_PGID;
> @@ -300,7 +300,7 @@ static int pgid_cmp(struct pgid *p1, struct pgid *p2)
>   static void pgid_analyze(struct ccw_device *cdev, struct pgid **p,
>   			 int *mismatch, u8 *reserved, u8 *reset)
>   {
> -	struct pgid *pgid = &cdev->private->pgid[0];
> +	struct pgid *pgid = &cdev->private->dma_area->pgid[0];
>   	struct pgid *first = NULL;
>   	int lpm;
>   	int i;
> @@ -342,7 +342,7 @@ static u8 pgid_to_donepm(struct ccw_device *cdev)
>   		lpm = 0x80 >> i;
>   		if ((cdev->private->pgid_valid_mask & lpm) == 0)
>   			continue;
> -		pgid = &cdev->private->pgid[i];
> +		pgid = &cdev->private->dma_area->pgid[i];
>   		if (sch->opm & lpm) {
>   			if (pgid->inf.ps.state1 != SNID_STATE1_GROUPED)
>   				continue;
> @@ -368,7 +368,7 @@ static void pgid_fill(struct ccw_device *cdev, struct pgid *pgid)
>   	int i;
> 
>   	for (i = 0; i < 8; i++)
> -		memcpy(&cdev->private->pgid[i], pgid, sizeof(struct pgid));
> +		memcpy(&cdev->private->dma_area->pgid[i], pgid, sizeof(struct pgid));
>   }
> 
>   /*
> @@ -435,12 +435,12 @@ static void snid_done(struct ccw_device *cdev, int rc)
>   static void snid_build_cp(struct ccw_device *cdev)
>   {
>   	struct ccw_request *req = &cdev->private->req;
> -	struct ccw1 *cp = cdev->private->iccws;
> +	struct ccw1 *cp = cdev->private->dma_area->iccws;
>   	int i = pathmask_to_pos(req->lpm);
> 
>   	/* Channel program setup. */
>   	cp->cmd_code	= CCW_CMD_SENSE_PGID;
> -	cp->cda		= (u32) (addr_t) &cdev->private->pgid[i];
> +	cp->cda		= (u32) (addr_t) &cdev->private->dma_area->pgid[i];
>   	cp->count	= sizeof(struct pgid);
>   	cp->flags	= CCW_FLAG_SLI;
>   	req->cp		= cp;
> @@ -516,7 +516,7 @@ static void verify_start(struct ccw_device *cdev)
>   	sch->lpm = sch->schib.pmcw.pam;
> 
>   	/* Initialize PGID data. */
> -	memset(cdev->private->pgid, 0, sizeof(cdev->private->pgid));
> +	memset(cdev->private->dma_area->pgid, 0, sizeof(cdev->private->dma_area->pgid));
>   	cdev->private->pgid_valid_mask = 0;
>   	cdev->private->pgid_todo_mask = sch->schib.pmcw.pam;
>   	cdev->private->path_notoper_mask = 0;
> @@ -626,7 +626,7 @@ struct stlck_data {
>   static void stlck_build_cp(struct ccw_device *cdev, void *buf1, void *buf2)
>   {
>   	struct ccw_request *req = &cdev->private->req;
> -	struct ccw1 *cp = cdev->private->iccws;
> +	struct ccw1 *cp = cdev->private->dma_area->iccws;
> 
>   	cp[0].cmd_code = CCW_CMD_STLCK;
>   	cp[0].cda = (u32) (addr_t) buf1;
> diff --git a/drivers/s390/cio/device_status.c b/drivers/s390/cio/device_status.c
> index 7d5c7892b2c4..a9aabde604f4 100644
> --- a/drivers/s390/cio/device_status.c
> +++ b/drivers/s390/cio/device_status.c
> @@ -79,15 +79,15 @@ ccw_device_accumulate_ecw(struct ccw_device *cdev, struct irb *irb)
>   	 * are condition that have to be met for the extended control
>   	 * bit to have meaning. Sick.
>   	 */
> -	cdev->private->irb.scsw.cmd.ectl = 0;
> +	cdev->private->dma_area->irb.scsw.cmd.ectl = 0;
>   	if ((irb->scsw.cmd.stctl & SCSW_STCTL_ALERT_STATUS) &&
>   	    !(irb->scsw.cmd.stctl & SCSW_STCTL_INTER_STATUS))
> -		cdev->private->irb.scsw.cmd.ectl = irb->scsw.cmd.ectl;
> +		cdev->private->dma_area->irb.scsw.cmd.ectl = irb->scsw.cmd.ectl;
>   	/* Check if extended control word is valid. */
> -	if (!cdev->private->irb.scsw.cmd.ectl)
> +	if (!cdev->private->dma_area->irb.scsw.cmd.ectl)
>   		return;
>   	/* Copy concurrent sense / model dependent information. */
> -	memcpy (&cdev->private->irb.ecw, irb->ecw, sizeof (irb->ecw));
> +	memcpy (&cdev->private->dma_area->irb.ecw, irb->ecw, sizeof (irb->ecw));


NIT, may be you should take  the opportunity to remove the blanc before 
the parenthesis.

NIT again, Some lines over 80 character too.

just a first check, I will go deeper later.

Regards,
Pierre

-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

