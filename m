Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56851277DDB
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 04:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgIYCMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 22:12:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726448AbgIYCMD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 22:12:03 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P22Txd114961;
        Thu, 24 Sep 2020 22:12:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=zAcDVw98Vj/FnhkNnlJqQoD65lsuVnHuJKqqPU5HJSo=;
 b=EaGObxm59etq3VOTJQCaU++rNQRWs8Jw/0GMREnmZHus2AflF1BLptdZaMt50uqi+ZxT
 nkOX4B/4K4CIeTJvdwGlfqoG07Eim/SLJA9A9scnP1bx4TGSrUSBTvI6eO10ywnzA/SL
 vt6h4bsbDEAmxCjPLFqyLfiqMiqI1ugihlS39yy0ZvyiZwb6waemW6KFMQCTbYeeNjMl
 FkdCT1n65vTF/8MsqzLn7klLuM+ruejUd+X++O9ii4S+GHv6x04W2UN4HhEjCwxIBSu0
 l/5zRylfEDCB/diRBCdAPb4Cu+1LyjlP6yrWucBeFQQtbbWmb4Ze8pLvMn+DE50aW52j HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33s5sh25ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Sep 2020 22:12:00 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08P22SEL114880;
        Thu, 24 Sep 2020 22:12:00 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33s5sh25a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Sep 2020 22:12:00 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08P2Ae2P001088;
        Fri, 25 Sep 2020 02:11:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 33n98gu1at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 02:11:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08P2BtY330015846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 02:11:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42BB342045;
        Fri, 25 Sep 2020 02:11:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F73C42041;
        Fri, 25 Sep 2020 02:11:54 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.190.191])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Sep 2020 02:11:54 +0000 (GMT)
Date:   Fri, 25 Sep 2020 04:11:52 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
Subject: Re: [PATCH v10 02/16] s390/vfio-ap: use new AP bus interface to
 search for queue devices
Message-ID: <20200925041152.12f52141.pasic@linux.ibm.com>
In-Reply-To: <b1c6bad8-3ec6-183c-3e35-9962e9c721c7@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-3-akrowiak@linux.ibm.com>
        <20200825121334.0ff35d7a.cohuck@redhat.com>
        <b1c6bad8-3ec6-183c-3e35-9962e9c721c7@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250007
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Aug 2020 10:24:07 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 8/25/20 6:13 AM, Cornelia Huck wrote:
> > On Fri, 21 Aug 2020 15:56:02 -0400
> > Tony Krowiak<akrowiak@linux.ibm.com>  wrote:
> >
> >> This patch refactor's the vfio_ap device driver to use the AP bus's
> > s/refactor's/refactors/
> 
> Of course, what was I thinking?:)
> 
> >> ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
> >> information about a queue that is bound to the vfio_ap device driver.
> >> The bus's ap_get_qdev() function retrieves the queue device from a
> >> hashtable keyed by APQN. This is much more efficient than looping over
> >> the list of devices attached to the AP bus by several orders of
> >> magnitude.
> >>
> >> Signed-off-by: Tony Krowiak<akrowiak@linux.ibm.com>
> >> Reported-by: kernel test robot<lkp@intel.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_drv.c     | 27 ++-------
> >>   drivers/s390/crypto/vfio_ap_ops.c     | 86 +++++++++++++++------------
> >>   drivers/s390/crypto/vfio_ap_private.h |  8 ++-
> >>   3 files changed, 59 insertions(+), 62 deletions(-)
> >>
> > (...)
> >
> >> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> >> index e0bde8518745..ad3925f04f61 100644
> >> --- a/drivers/s390/crypto/vfio_ap_ops.c
> >> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> >> @@ -26,43 +26,26 @@
> >>   
> >>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
> >>   
> >> -static int match_apqn(struct device *dev, const void *data)
> >> -{
> >> -	struct vfio_ap_queue *q = dev_get_drvdata(dev);
> >> -
> >> -	return (q->apqn == *(int *)(data)) ? 1 : 0;
> >> -}
> >> -
> >>   /**
> >> - * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
> >> - * @matrix_mdev: the associated mediated matrix
> >> + * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
> >>    * @apqn: The queue APQN
> >>    *
> >> - * Retrieve a queue with a specific APQN from the list of the
> >> - * devices of the vfio_ap_drv.
> >> - * Verify that the APID and the APQI are set in the matrix.
> >> + * Retrieve a queue with a specific APQN from the AP queue devices attached to
> >> + * the AP bus.
> >>    *
> >> - * Returns the pointer to the associated vfio_ap_queue
> >> + * Returns the pointer to the vfio_ap_queue with the specified APQN, or NULL.
> >>    */
> >> -static struct vfio_ap_queue *vfio_ap_get_queue(
> >> -					struct ap_matrix_mdev *matrix_mdev,
> >> -					int apqn)
> >> +static struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
> >>   {
> >> +	struct ap_queue *queue;
> >>   	struct vfio_ap_queue *q;
> >> -	struct device *dev;
> >>   
> >> -	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
> >> -		return NULL;
> >> -	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
> > I think you should add some explanation to the patch description why
> > testing the matrix bitmasks is not needed anymore.
> 
> As a result of this comment, I took a closer look at the code to
> determine the reason for eliminating the matrix_mdev
> parameter. The reason is because the code below (i.e., find the device
> and get the driver data) was also repeated in the vfio_ap_irq_disable_apqn()
> function, so I replaced it with a call to the function above; however, the
> vfio_ap_irq_disable_apqn() function  does not have a reference to the
> matrix_mdev, so I eliminated the matrix_mdev parameter. Note that the
> vfio_ap_irq_disable_apqn() is called for each APQN assigned to a matrix
> mdev, so there is no need to test the bitmasks there.
> 
> The other place from which the function above is called is
> the handle_pqap() function which does have a reference to the
> matrix_mdev. In order to ensure the integrity of the instruction
> being intercepted - i.e., PQAP(AQIC) enable/disable IRQ for aN
> AP queue - the testing of the matrix bitmasks probably ought to
> be performed, so it will be done there instead of in the
> vfio_ap_get_queue() function above.

I'm a little confused. I do agree that in handle_pqap() we do want to
make sure that we only operate on queues that belong to the given guest
that issued the PQAP instruction.

AFAICT with this patch set applied, this is not the case any more. Does
that 'will be done there instead' refer to v11?

Another question is, can we use vfio_ap_get_mdev_queue() in
handle_pqap() (instead of vfio_ap_get_queue())?
 
> 
> 
> > +	queue = ap_get_qdev(apqn);
> > +	if (!queue)
> >   		return NULL;
> >   
> > -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> > -				 &apqn, match_apqn);
> > -	if (!dev)
> > -		return NULL;
> > -	q = dev_get_drvdata(dev);
> > -	q->matrix_mdev = matrix_mdev;
> > -	put_device(dev);
> > +	q = dev_get_drvdata(&queue->ap_dev.device);
> > +	put_device(&queue->ap_dev.device);
> >   
> >   	return q;
> >   }
> > (...)
> >
> 

