Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2346927CF5C
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 15:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgI2Nin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 09:38:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725306AbgI2Nin (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 09:38:43 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TDVqJp135566;
        Tue, 29 Sep 2020 09:38:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=WYe7IjikJ/8YlZXbuspNOxovIdKMAnX5gaPYajsXzg0=;
 b=BRqNYTvVStMFyYlbdFyXIPd6tloGQCfOPBizOenSi6NQyd059aDcZzYMJrGDCehddCLo
 5/VfYB9m5rMZB7MVy0mkM0q+crd8yjSK0XSH57XzH4R7Lev6uQ92Pd+EABK1MBvhvgye
 Rc3e7aUgvihzpXl74t8mVwRmQCTHUohTLE7sAR94BTpxMxJkI1Q/lQhk2ZZsa73qMWYY
 YsMa+wZmnHanXLLbafIRytsK9Qou7O9ukbZtpCQgUE5HX6rwsM+ZR55idJbqH2vu0xNk
 aVt45LYpohCYee26Rz6fGNb62J63RPWckzYtFo+BGtB8NlgPGNwoblC+NC1QnkAc7ZL8 zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33v5kvrxvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 09:38:36 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08TDWRR4139421;
        Tue, 29 Sep 2020 09:38:36 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33v5kvrxut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 09:38:35 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TDax14014807;
        Tue, 29 Sep 2020 13:38:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97ucth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 13:38:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TDcViR22544834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 13:38:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49EB34203F;
        Tue, 29 Sep 2020 13:38:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7063642042;
        Tue, 29 Sep 2020 13:38:30 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.92.67])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 13:38:30 +0000 (GMT)
Date:   Tue, 29 Sep 2020 15:37:55 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v10 02/16] s390/vfio-ap: use new AP bus interface to
 search for queue devices
Message-ID: <20200929153755.20bdd94f.pasic@linux.ibm.com>
In-Reply-To: <ed021f29-927d-5bd6-4f2c-466f502f49f4@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-3-akrowiak@linux.ibm.com>
        <20200925042729.3b9d5704.pasic@linux.ibm.com>
        <ed021f29-927d-5bd6-4f2c-466f502f49f4@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_04:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Sep 2020 09:07:40 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 9/24/20 10:27 PM, Halil Pasic wrote:
> > On Fri, 21 Aug 2020 15:56:02 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >
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
> >> +	queue = ap_get_qdev(apqn);
> >> +	if (!queue)
> >>   		return NULL;
> >>   
> >> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> >> -				 &apqn, match_apqn);
> >> -	if (!dev)
> >> -		return NULL;
> >> -	q = dev_get_drvdata(dev);
> >> -	q->matrix_mdev = matrix_mdev;
> >> -	put_device(dev);
> >> +	q = dev_get_drvdata(&queue->ap_dev.device);
> > Is this cast here safe? (I don't think it is.)
> 
> In the probe, we execute:
> dev_set_drvdata(&queue->ap_dev.device, q);
> 
> I don't get any compile nor execution errors. Why wouldn't it be safe?
> 

Because the queue may or may not be bound to the vfio_ap driver. AFAICT
this function can be called with an arbitrary APQN.

If it is bound to another driver then drvdata is not likely to hold a
struct vfio_ap_queue.


> >
> >> +	put_device(&queue->ap_dev.device);
> >>   
> >>   	return q;
> >>   }
> 

