Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB9B2F58AB
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 04:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbhANCvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 21:51:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbhANCu7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 21:50:59 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10E2XGTr152273;
        Wed, 13 Jan 2021 21:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZHjSEQUGF80zTY5Flc6RKur4SkWcncx5Bovo3CHVGlg=;
 b=BKKkGuhdV+rnmqZD6CY0nWPAiQ1icplOsCTTNppnbN88EgJ+9ftfKJH8cbGNEPUUVUTT
 thxXrg5+Tf7Ze51THjZ2jWr1V+N6x77I4xchJyz0HE9ijP13wrmj4pQCOkGtJUpNcW4/
 uexW3sTqnrwlxh4z+S9799TkhfNIoSqV5n76wwxiwF84E9ugIJrgDrPGDrxrcuiwR8E+
 vxUGAsA8eOEfLc1achbDDcCGBvgZnb7KE6LhVx9yUcAAEsZLhq2SCDWMzDKJ4i849piu
 l743IFmiHenYeywTM/yw/LoBmnpsFrhW2ZpIZzckXS9cORdLYZZnjiRAYHnPuGoG2lYu SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362d040qbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 21:50:18 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10E2YPdK157618;
        Wed, 13 Jan 2021 21:50:18 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362d040qba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 21:50:17 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10E2mH91011374;
        Thu, 14 Jan 2021 02:50:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448dwc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 02:50:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10E2oCG438011154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 02:50:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 083C311C04C;
        Thu, 14 Jan 2021 02:50:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D0CF11C05B;
        Thu, 14 Jan 2021 02:50:11 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.21.203])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 14 Jan 2021 02:50:11 +0000 (GMT)
Date:   Thu, 14 Jan 2021 03:50:09 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 05/15] s390/vfio-ap: manage link between queue
 struct and matrix mdev
Message-ID: <20210114035009.375c5496.pasic@linux.ibm.com>
In-Reply-To: <8c701a5c-39f8-0c22-c936-aebbc3c8f60e@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-6-akrowiak@linux.ibm.com>
        <20210111201752.21a41db4.pasic@linux.ibm.com>
        <8c701a5c-39f8-0c22-c936-aebbc3c8f60e@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_14:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxlogscore=919
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140010
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Jan 2021 16:41:27 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 1/11/21 2:17 PM, Halil Pasic wrote:
> > On Tue, 22 Dec 2020 20:15:56 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> Let's create links between each queue device bound to the vfio_ap device
> >> driver and the matrix mdev to which the queue's APQN is assigned. The idea
> >> is to facilitate efficient retrieval of the objects representing the queue
> >> devices and matrix mdevs as well as to verify that a queue assigned to
> >> a matrix mdev is bound to the driver.
> >>
> >> The links will be created as follows:
> >>
> >>     * When the queue device is probed, if its APQN is assigned to a matrix
> >>       mdev, the structures representing the queue device and the matrix mdev
> >>       will be linked.
> >>
> >>     * When an adapter or domain is assigned to a matrix mdev, for each new
> >>       APQN assigned that references a queue device bound to the vfio_ap
> >>       device driver, the structures representing the queue device and the
> >>       matrix mdev will be linked.
> >>
> >> The links will be removed as follows:
> >>
> >>     * When the queue device is removed, if its APQN is assigned to a matrix
> >>       mdev, the structures representing the queue device and the matrix mdev
> >>       will be unlinked.
> >>
> >>     * When an adapter or domain is unassigned from a matrix mdev, for each
> >>       APQN unassigned that references a queue device bound to the vfio_ap
> >>       device driver, the structures representing the queue device and the
> >>       matrix mdev will be unlinked.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>  
> > Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> >  

[..]

> >> +
> >>   int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
> >>   {
> >>   	struct vfio_ap_queue *q;
> >> @@ -1324,9 +1404,13 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
> >>   	q = kzalloc(sizeof(*q), GFP_KERNEL);
> >>   	if (!q)
> >>   		return -ENOMEM;
> >> +	mutex_lock(&matrix_dev->lock);
> >>   	dev_set_drvdata(&apdev->device, q);
> >>   	q->apqn = to_ap_queue(&apdev->device)->qid;
> >>   	q->saved_isc = VFIO_AP_ISC_INVALID;
> >> +	vfio_ap_queue_link_mdev(q);
> >> +	mutex_unlock(&matrix_dev->lock);
> >> +  
> > Does the critical section have to include more than just
> > vfio_ap_queue_link_mdev()? Did we need the critical section
> > before this patch?  
> 
> We did not need the critical section before this patch because
> the only function that retrieved the vfio_ap_queue via the queue
> device's drvdata was the remove callback. I included the initialization
> of the vfio_ap_queue object under lock because the
> vfio_ap_find_queue() function retrieves the vfio_ap_queue object from
> the queue device's drvdata so it might be advantageous to initialize
> it under the mdev lock. On the other hand, I can't come up with a good
> argument to change this.
> 
> 

I was asking out of curiosity, not because I want it changed. I was
also wondering if somebody could see a partially initialized device:
we even first call dev_set_drvdata() and only then finish the
initialization. Before 's390/vfio-ap: use new AP bus interface to search
for queue devices', which is the previous patch, we had the klist code
in between, which uses spinlocks, which I think ensure, that all
effects of probe are seen when we get the queue from
vfio_ap_find_queue(). But with patch 4 in place that is not the case any
more. Or am I wrong?

Regards,
Halil
