Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D41F2F582A
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 04:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbhANCPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 21:15:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729088AbhAMVWR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 16:22:17 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10DL1hs8069526;
        Wed, 13 Jan 2021 16:21:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OprZRs1XFVBeryiWoY+XZ78Zwt7zdLwQVuTlLYqt6cg=;
 b=MfPnTzTAl+pjnGdFKfNHWfLJiQ0Cu60p5PVw2uPgYi5rCN4G2HLx+bb8wOcarPBHdlhF
 j8MxaLBRjQLbIVKuMkYA+dvab/2P1nBurFjWeEU5dxkp/gQLBxxdfMB/8+BNMbZgCIF7
 rNUur/sWZHlXtSJqmM1lADuUE/qX/x9xN3d5uRxYWgskQiFGqxdHZhSj65pFoOs/a0JZ
 JdPtv4U+HIsfrN0mjWLIjMjSxrgTIvlRYQLsziW04u3TDtq0pv1SvdirzwQ+H7ayP6lz
 1wfMjwyBBKHy4oYxBsxA51C990YV6AHGFtU0/QdnCGVRvlwtW9f28brzVCoZiSgPZCPx 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36285n0uwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 16:21:15 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10DL3OXL080663;
        Wed, 13 Jan 2021 16:21:15 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36285n0uw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 16:21:15 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10DLECEh013167;
        Wed, 13 Jan 2021 21:21:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3604h9a5tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 21:21:13 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10DLL5DY32965046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 21:21:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D99F42041;
        Wed, 13 Jan 2021 21:21:10 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 522D642045;
        Wed, 13 Jan 2021 21:21:09 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.83.174])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 13 Jan 2021 21:21:09 +0000 (GMT)
Date:   Wed, 13 Jan 2021 22:21:07 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 02/15] s390/vfio-ap: No need to disable IRQ after
 queue reset
Message-ID: <20210113222107.527693df.pasic@linux.ibm.com>
In-Reply-To: <ed9eb852-5046-bcfc-be2c-3bb67323ec8a@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-3-akrowiak@linux.ibm.com>
        <20210111173206.27808b79.pasic@linux.ibm.com>
        <ed9eb852-5046-bcfc-be2c-3bb67323ec8a@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_11:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Jan 2021 12:06:28 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 1/11/21 11:32 AM, Halil Pasic wrote:
> > On Tue, 22 Dec 2020 20:15:53 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> The queues assigned to a matrix mediated device are currently reset when:
> >>
> >> * The VFIO_DEVICE_RESET ioctl is invoked
> >> * The mdev fd is closed by userspace (QEMU)
> >> * The mdev is removed from sysfs.
> >>
> >> Immediately after the reset of a queue, a call is made to disable
> >> interrupts for the queue. This is entirely unnecessary because the reset of
> >> a queue disables interrupts, so this will be removed.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_drv.c     |  1 -
> >>   drivers/s390/crypto/vfio_ap_ops.c     | 40 +++++++++++++++++----------
> >>   drivers/s390/crypto/vfio_ap_private.h |  1 -
> >>   3 files changed, 26 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> >> index be2520cc010b..ca18c91afec9 100644
> >> --- a/drivers/s390/crypto/vfio_ap_drv.c
> >> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> >> @@ -79,7 +79,6 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
> >>   	apid = AP_QID_CARD(q->apqn);
> >>   	apqi = AP_QID_QUEUE(q->apqn);
> >>   	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> >> -	vfio_ap_irq_disable(q);
> >>   	kfree(q);
> >>   	mutex_unlock(&matrix_dev->lock);
> >>   }
> >> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> >> index 7339043906cf..052f61391ec7 100644
> >> --- a/drivers/s390/crypto/vfio_ap_ops.c
> >> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> >> @@ -25,6 +25,7 @@
> >>   #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
> >>   
> >>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
> >> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
> >>   
> >>   static int match_apqn(struct device *dev, const void *data)
> >>   {
> >> @@ -49,20 +50,15 @@ static struct vfio_ap_queue *(
> >>   					int apqn)
> >>   {
> >>   	struct vfio_ap_queue *q;
> >> -	struct device *dev;
> >>   
> >>   	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
> >>   		return NULL;
> >>   	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
> >>   		return NULL;
> >>   
> >> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> >> -				 &apqn, match_apqn);
> >> -	if (!dev)
> >> -		return NULL;
> >> -	q = dev_get_drvdata(dev);
> >> -	q->matrix_mdev = matrix_mdev;
> >> -	put_device(dev);
> >> +	q = vfio_ap_find_queue(apqn);
> >> +	if (q)
> >> +		q->matrix_mdev = matrix_mdev;
> >>   
> >>   	return q;
> >>   }
> >> @@ -1126,24 +1122,27 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> >>   	return notify_rc;
> >>   }
> >>   
> >> -static void (int apqn)
> >> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
> >>   {
> >>   	struct device *dev;
> >> -	struct vfio_ap_queue *q;
> >> +	struct vfio_ap_queue *q = NULL;
> >>   
> >>   	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> >>   				 &apqn, match_apqn);
> >>   	if (dev) {
> >>   		q = dev_get_drvdata(dev);
> >> -		vfio_ap_irq_disable(q);
> >>   		put_device(dev);
> >>   	}
> >> +
> >> +	return q;
> >>   }  
> > This hunk and the previous one are a rewrite of vfio_ap_get_queue() and
> > have next to nothing to do with the patch's objective. If we were at an
> > earlier stage, I would ask to split it up.  
> 
> The rewrite of vfio_ap_get_queue() definitely is related to this
> patch's objective. 

Definitively loosely related.

> Below, in the vfio_ap_mdev_reset_queue()
> function, there is the label 'free_aqic_resources' which is where
> the call to vfio_ap_free_aqic_resources() function is called.
> That function takes a struct vfio_ap_queue as an argument,
> so the object needs to be retrieved prior to calling the function.
> We can't use the vfio_ap_get_queue() function for two reasons:
> 1. The vfio_ap_get_queue() function takes a struct ap_matrix_mdev
>      as a parameter and we do not have a pointer to such at the time.
> 2. The vfio_ap_get_queue() function is used to link the mdev to the
>      vfio_ap_queue object with the specified APQN.
> So, we needed a way to retrieve the vfio_ap_queue object by its
> APQN only, Rather than creating a function that retrieves the
> vfio_ap_queue object which duplicates the retrieval code in
> vfio_ap_get_queue(), I created the vfio_ap_find_queue()
> function to do just that and modified the vfio_ap_get_queue()
> function to call it (i.e., code reuse).

Please tell me what prevented you from doing a doing the splitting out
vfio_ap_find_queue() from vfio_ap_get_queue() in a separate patch, that
precedes this patch? It would have resulted in simpler diffs, because
the split out wouldn't be intermingled with other stuff, i.e. getting
rid of vfio_ap_irq_disable_apqn(). Don't you see that the two are
intermingled in this diff?

> 
> 
> >  
> >>   
> >>   int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> >>   			     unsigned int retry)
> >>   {
> >>   	struct ap_queue_status status;
> >> +	struct vfio_ap_queue *q;
> >> +	int ret;
> >>   	int retry2 = 2;
> >>   	int apqn = AP_MKQID(apid, apqi);
> >>   
> >> @@ -1156,18 +1155,32 @@ int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> >>   				status = ap_tapq(apqn, NULL);
> >>   			}
> >>   			WARN_ON_ONCE(retry2 <= 0);
> >> -			return 0;
> >> +			ret = 0;
> >> +			goto free_aqic_resources;
> >>   		case AP_RESPONSE_RESET_IN_PROGRESS:
> >>   		case AP_RESPONSE_BUSY:
> >>   			msleep(20);
> >>   			break;
> >>   		default:
> >>   			/* things are really broken, give up */
> >> -			return -EIO;
> >> +			ret = -EIO;
> >> +			goto free_aqic_resources;  
> > Do we really want the unpin here? I mean the reset did not work and
> > we are giving up. So the irqs are potentially still enabled.
> >
> > Without this patch we try to disable the interrupts using AQIC, and
> > do the cleanup after that.  
> 
> If the reset failure lands here, then a subsequent AQIC will
> also fail, so I see no reason to expend processing time for
> something that will ultimately fail anyways.
> 
> >
> > I'm aware, the comment says we should not take the default branch,
> > but if that's really the case we should IMHO log an error and leak the
> > page.  
> 
> I do not see a good reason to leak the page, what purpose would
> it serve? 

Well, the thing is we don't have a case for AP_RESPONSE_CHECKSTOPPED,
which is, AFAIK a valid outcome. I don't remember what is the exact
deal with checkstopped regarding interrupts.

If we take the default with something different
than AP_RESPONSE_CHECKSTOPPED, that is AFAICT a bug of the underlying
machine.

> I don't have a problem with logging an error, do you think
> it should just be a log message or a WARN_ON type of thing?
> 

Seeing an outcome we don't expect to see, due to a bug in the underlying
machine is in my book worth an error message. Furthermore we may not
assume that the interrupts where shut down for the queue. So the only
way we can protect the host is by leaking the page.

> >
> > It's up to you if you want to change this. I don't want to delay the
> > series any further than absolutely necessary.
> >
> > Acked-by: Halil Pasic <pasic@linux.ibm.com>
> >  
> >>   		}
> >>   	} while (retry--);
> >>   
> >>   	return -EBUSY;
> >> +
> >> +free_aqic_resources:
> >> +	/*
> >> +	 * In order to free the aqic resources, the queue must be linked to
> >> +	 * the matrix_mdev to which its APQN is assigned and the KVM pointer
> >> +	 * must be available.
> >> +	 */
> >> +	q = vfio_ap_find_queue(apqn);
> >> +	if (q && q->matrix_mdev && q->matrix_mdev->kvm)  
> > Is this of the type "we know there are no aqic resources to be freed" if
> > precondition is false?  
> 
> Yes
> 
> >
> > vfio_ap_free_aqic_resources() checks the matrix_mdev pointer but not the
> > kvm pointer. Could we just check the kvm pointer in
> > vfio_ap_free_aqic_resources()?  
> 
> A while back I posted a patch that did just that and someone pushed back
> because they could not see how the vfio_ap_free_aqic_resources()
> function would ever be called with a NULL kvm pointer which is
> why I implemented the above check. The reset is called
> when the mdev is removed which can happen only when there
> is no kvm pointer, so I agree it would be better to check the kvm
> pointer in the vfio_ap_free_aqic_resources() function.
> 

I don't remember. Sorry if it was me.

> >
> > At the end of the series, is seeing q! indicating a bug, or is it
> > something we expect to see under certain circumstances?  
> 
> I'm not quite sure to what you are referring regarding "the
> end of the series", but we can expect to see a NULL pointer
> for q if a queue is manually unbound from the driver.

By at the end of the series, I mean with all 15 patches applied.

Regarding the case where the queue is manually unbound form the
driver, this is exactly one of the scenarios I was latently concerned
about. Let me explain. The manually unbound queue was already reset
in vfio_ap_mdev_remove_queue() if necessary, so we don't need to reset
it again. And more importantly it is not bound to the vfio_ap driver,
so vfio_ap is not allowed to reset it. (It could in theory belong to
and be in use by another non-default driver).

I've just checked out vfio_ap_mdev_reset_queues() and it resets all
queues in the matrix. The in use mechanism does ensure that zcrypt
can't use these queues (together with a[pq]mask), but resetting a
queue that does not belong to us is going beyond our authority.


Regards,
Halil

> 
> >
> >  
> >> +		vfio_ap_free_aqic_resources(q);
> >> +
> >> +	return ret;
> >>   }
> >>   
> >>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
> >> @@ -1189,7 +1202,6 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
> >>   			 */
> >>   			if (ret)
> >>   				rc = ret;
> >> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
> >>   		}
> >>   	}
> >>   
> >> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> >> index f46dde56b464..0db6fb3d56d5 100644
> >> --- a/drivers/s390/crypto/vfio_ap_private.h
> >> +++ b/drivers/s390/crypto/vfio_ap_private.h
> >> @@ -100,5 +100,4 @@ struct vfio_ap_queue {
> >>   #define VFIO_AP_ISC_INVALID 0xff
> >>   	unsigned char saved_isc;
> >>   };
> >> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
> >>   #endif /* _VFIO_AP_PRIVATE_H_ */  
> 

