Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BCA2F5910
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 04:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbhANDOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 22:14:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52148 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbhANDOw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 22:14:52 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10E38jeC194556;
        Wed, 13 Jan 2021 22:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=AUdx+12ga3TEUXFPGIZu4do3NK2k8Qhq2jcM5SwG22Y=;
 b=Wvs5JbtVzEKVl/eOfp9qzxxdl68xzUdCMftLPVRbZLAwEQ7bLvb8TZURUHU2MjoyY+Dw
 Lv+eO3RdxBKlikA7qQiQ1dMGBuFL22nMK7IF1f8XBRW9nUZVfq+x871LOqd6B4T0kn+g
 Y/nPNGpjt2vqCAfuUZxXoKSwnHsnaqpmqWTlmB//ADRjBei0sraSEmqKPVAeSckjG3Ku
 uPWXc9nyovMmOMA8isqMZn22SEKzw5O+b2dkN+twZP5H1LFNI4Hk01Q6QTORF9zf0jOJ
 Hxfj/kf0WFDmB48+W9y2Ws1SUYpL9ZJSscnC7Jd2PHfSQfcO0ymoZ2QAZPvG41CXRUYw Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362d70gq3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 22:14:07 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10E3966E194998;
        Wed, 13 Jan 2021 22:14:07 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362d70gq25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 22:14:07 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10E3DL2b005472;
        Thu, 14 Jan 2021 03:14:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 361wgq8jwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 03:14:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10E3E02526345892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 03:14:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5A5A52051;
        Thu, 14 Jan 2021 03:14:00 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.21.203])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id EA84D5205A;
        Thu, 14 Jan 2021 03:13:59 +0000 (GMT)
Date:   Thu, 14 Jan 2021 04:13:57 +0100
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
Message-ID: <20210114041357.04ed5d78.pasic@linux.ibm.com>
In-Reply-To: <520071f6-e5d1-25cf-e5eb-b6655adad404@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-3-akrowiak@linux.ibm.com>
        <20210111173206.27808b79.pasic@linux.ibm.com>
        <ed9eb852-5046-bcfc-be2c-3bb67323ec8a@linux.ibm.com>
        <20210113222107.527693df.pasic@linux.ibm.com>
        <520071f6-e5d1-25cf-e5eb-b6655adad404@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_01:2021-01-13,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140014
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Jan 2021 19:46:03 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 1/13/21 4:21 PM, Halil Pasic wrote:
> > On Wed, 13 Jan 2021 12:06:28 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> On 1/11/21 11:32 AM, Halil Pasic wrote:  
> >>> On Tue, 22 Dec 2020 20:15:53 -0500
> >>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >>>     
> >>>> The queues assigned to a matrix mediated device are currently reset when:
> >>>>
> >>>> * The VFIO_DEVICE_RESET ioctl is invoked
> >>>> * The mdev fd is closed by userspace (QEMU)
> >>>> * The mdev is removed from sysfs.
> >>>>
> >>>> Immediately after the reset of a queue, a call is made to disable
> >>>> interrupts for the queue. This is entirely unnecessary because the reset of
> >>>> a queue disables interrupts, so this will be removed.
> >>>>
> >>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >>>> ---
> >>>>    drivers/s390/crypto/vfio_ap_drv.c     |  1 -
> >>>>    drivers/s390/crypto/vfio_ap_ops.c     | 40 +++++++++++++++++----------
> >>>>    drivers/s390/crypto/vfio_ap_private.h |  1 -
> >>>>    3 files changed, 26 insertions(+), 16 deletions(-)
> >>>>
> >>>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> >>>> index be2520cc010b..ca18c91afec9 100644
> >>>> --- a/drivers/s390/crypto/vfio_ap_drv.c
> >>>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> >>>> @@ -79,7 +79,6 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
> >>>>    	apid = AP_QID_CARD(q->apqn);
> >>>>    	apqi = AP_QID_QUEUE(q->apqn);
> >>>>    	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> >>>> -	vfio_ap_irq_disable(q);
> >>>>    	kfree(q);
> >>>>    	mutex_unlock(&matrix_dev->lock);
> >>>>    }
> >>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> >>>> index 7339043906cf..052f61391ec7 100644
> >>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
> >>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> >>>> @@ -25,6 +25,7 @@
> >>>>    #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
> >>>>    
> >>>>    static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
> >>>> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
> >>>>    
> >>>>    static int match_apqn(struct device *dev, const void *data)
> >>>>    {
> >>>> @@ -49,20 +50,15 @@ static struct vfio_ap_queue *(
> >>>>    					int apqn)
> >>>>    {
> >>>>    	struct vfio_ap_queue *q;
> >>>> -	struct device *dev;
> >>>>    
> >>>>    	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
> >>>>    		return NULL;
> >>>>    	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
> >>>>    		return NULL;
> >>>>    
> >>>> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> >>>> -				 &apqn, match_apqn);
> >>>> -	if (!dev)
> >>>> -		return NULL;
> >>>> -	q = dev_get_drvdata(dev);
> >>>> -	q->matrix_mdev = matrix_mdev;
> >>>> -	put_device(dev);
> >>>> +	q = vfio_ap_find_queue(apqn);
> >>>> +	if (q)
> >>>> +		q->matrix_mdev = matrix_mdev;
> >>>>    
> >>>>    	return q;
> >>>>    }
> >>>> @@ -1126,24 +1122,27 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> >>>>    	return notify_rc;
> >>>>    }
> >>>>    
> >>>> -static void (int apqn)
> >>>> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
> >>>>    {
> >>>>    	struct device *dev;
> >>>> -	struct vfio_ap_queue *q;
> >>>> +	struct vfio_ap_queue *q = NULL;
> >>>>    
> >>>>    	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> >>>>    				 &apqn, match_apqn);
> >>>>    	if (dev) {
> >>>>    		q = dev_get_drvdata(dev);
> >>>> -		vfio_ap_irq_disable(q);
> >>>>    		put_device(dev);
> >>>>    	}
> >>>> +
> >>>> +	return q;
> >>>>    }  
> >>> This hunk and the previous one are a rewrite of vfio_ap_get_queue() and
> >>> have next to nothing to do with the patch's objective. If we were at an
> >>> earlier stage, I would ask to split it up.  
> >> The rewrite of vfio_ap_get_queue() definitely is related to this
> >> patch's objective.  
> > Definitively loosely related.  
> 
> A matter of opinion I suppose and I respect yours.
> 
> >  
> >> Below, in the vfio_ap_mdev_reset_queue()
> >> function, there is the label 'free_aqic_resources' which is where
> >> the call to vfio_ap_free_aqic_resources() function is called.
> >> That function takes a struct vfio_ap_queue as an argument,
> >> so the object needs to be retrieved prior to calling the function.
> >> We can't use the vfio_ap_get_queue() function for two reasons:
> >> 1. The vfio_ap_get_queue() function takes a struct ap_matrix_mdev
> >>       as a parameter and we do not have a pointer to such at the time.
> >> 2. The vfio_ap_get_queue() function is used to link the mdev to the
> >>       vfio_ap_queue object with the specified APQN.
> >> So, we needed a way to retrieve the vfio_ap_queue object by its
> >> APQN only, Rather than creating a function that retrieves the
> >> vfio_ap_queue object which duplicates the retrieval code in
> >> vfio_ap_get_queue(), I created the vfio_ap_find_queue()
> >> function to do just that and modified the vfio_ap_get_queue()
> >> function to call it (i.e., code reuse).  
> > Please tell me what prevented you from doing a doing the splitting out
> > vfio_ap_find_queue() from vfio_ap_get_queue() in a separate patch, that
> > precedes this patch? It would have resulted in simpler diffs, because
> > the split out wouldn't be intermingled with other stuff, i.e. getting
> > rid of vfio_ap_irq_disable_apqn(). Don't you see that the two are
> > intermingled in this diff?  
> 
> I included this here for the reasons I stated above.
> If I was reviewing these patches and saw this in a separate
> patch I would wonder why it was being done since it would
> be an isolated change requiring examination of subsequent
> patches to figure out why it was done.  Since you have
> taken the time to bring this up again I'll go ahead and do it
> since I have no major objections and it is a fairly simple change.
> 

As stated in my first comment, I don't insist. I made the comment
with future patches in mind. Splitting out prep work isn't unusual
at all, but you are right, the motivation should be stated in the
commit message. 

> >  
> >>  
> >>>     
> >>>>    
> >>>>    int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> >>>>    			     unsigned int retry)
> >>>>    {
> >>>>    	struct ap_queue_status status;
> >>>> +	struct vfio_ap_queue *q;
> >>>> +	int ret;
> >>>>    	int retry2 = 2;
> >>>>    	int apqn = AP_MKQID(apid, apqi);
> >>>>    
> >>>> @@ -1156,18 +1155,32 @@ int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> >>>>    				status = ap_tapq(apqn, NULL);
> >>>>    			}
> >>>>    			WARN_ON_ONCE(retry2 <= 0);
> >>>> -			return 0;
> >>>> +			ret = 0;
> >>>> +			goto free_aqic_resources;
> >>>>    		case AP_RESPONSE_RESET_IN_PROGRESS:
> >>>>    		case AP_RESPONSE_BUSY:
> >>>>    			msleep(20);
> >>>>    			break;
> >>>>    		default:
> >>>>    			/* things are really broken, give up */
> >>>> -			return -EIO;
> >>>> +			ret = -EIO;
> >>>> +			goto free_aqic_resources;  
> >>> Do we really want the unpin here? I mean the reset did not work and
> >>> we are giving up. So the irqs are potentially still enabled.
> >>>
> >>> Without this patch we try to disable the interrupts using AQIC, and
> >>> do the cleanup after that.  
> >> If the reset failure lands here, then a subsequent AQIC will
> >> also fail, so I see no reason to expend processing time for
> >> something that will ultimately fail anyways.
> >>  
> >>> I'm aware, the comment says we should not take the default branch,
> >>> but if that's really the case we should IMHO log an error and leak the
> >>> page.  
> >> I do not see a good reason to leak the page, what purpose would
> >> it serve?  
> > Well, the thing is we don't have a case for AP_RESPONSE_CHECKSTOPPED,
> > which is, AFAIK a valid outcome. I don't remember what is the exact
> > deal with checkstopped regarding interrupts.  
> 
> The AP_RESPONSE_CHECKSTOPPED response code is set
> when the AP function can not be performed due to a
> machine failure resulting in loss of connectivity to the
> queue. I find it hard to believe that interrupts would
> continue to be signaled in that case. I will check with
> the architecture folks for verification.
> 
> >
> > If we take the default with something different
> > than AP_RESPONSE_CHECKSTOPPED, that is AFAICT a bug of the underlying
> > machine.  
> 
> I think AP_RESPONSE_CHECKSTOPPED indicates a problem with
> the machine also.
> 

I think it indicates a problem with a queue, i.e. an IO device. It
is not the same as the machine is doing stuff it should never do.

> >  
> >> I don't have a problem with logging an error, do you think
> >> it should just be a log message or a WARN_ON type of thing?
> >>  
> > Seeing an outcome we don't expect to see, due to a bug in the underlying
> > machine is in my book worth an error message. Furthermore we may not
> > assume that the interrupts where shut down for the queue. So the only
> > way we can protect the host is by leaking the page.  
> 
> I won't assume anything - although I seriously doubt interrupts
> will continue with a broken device - so I will get input from the
> architecture folks regarding interrupts after a non-zero response
> code.
> 

I tend to agree, I just didn't re-read the stuff, and I don't remember
all the details. But what I do seem to remember is that, if the
checkstopped queue ever becomes operational again, it will come back
clean (i.e. as if reset). So if we are sure, there won't be any surprise
interrupts after some point (e.g. we observe the reason code for
checkstopped), we could just say the reset was OK because there in
no need to reset.

So maybe on AP_RESPONSE_CHECKSTOPPED we should do thesame as on
AP_RESPONSE_NORMAL, or?


> >  
> >>> It's up to you if you want to change this. I don't want to delay the
> >>> series any further than absolutely necessary.
> >>>
> >>> Acked-by: Halil Pasic <pasic@linux.ibm.com>
> >>>     
> >>>>    		}
> >>>>    	} while (retry--);
> >>>>    
> >>>>    	return -EBUSY;
> >>>> +
> >>>> +free_aqic_resources:
> >>>> +	/*
> >>>> +	 * In order to free the aqic resources, the queue must be linked to
> >>>> +	 * the matrix_mdev to which its APQN is assigned and the KVM pointer
> >>>> +	 * must be available.
> >>>> +	 */
> >>>> +	q = vfio_ap_find_queue(apqn);
> >>>> +	if (q && q->matrix_mdev && q->matrix_mdev->kvm)  
> >>> Is this of the type "we know there are no aqic resources to be freed" if
> >>> precondition is false?  
> >> Yes
> >>  
> >>> vfio_ap_free_aqic_resources() checks the matrix_mdev pointer but not the
> >>> kvm pointer. Could we just check the kvm pointer in
> >>> vfio_ap_free_aqic_resources()?  
> >> A while back I posted a patch that did just that and someone pushed back
> >> because they could not see how the vfio_ap_free_aqic_resources()
> >> function would ever be called with a NULL kvm pointer which is
> >> why I implemented the above check. The reset is called
> >> when the mdev is removed which can happen only when there
> >> is no kvm pointer, so I agree it would be better to check the kvm
> >> pointer in the vfio_ap_free_aqic_resources() function.
> >>  
> > I don't remember. Sorry if it was me.
> >  
> >>> At the end of the series, is seeing q! indicating a bug, or is it
> >>> something we expect to see under certain circumstances?  
> >> I'm not quite sure to what you are referring regarding "the
> >> end of the series", but we can expect to see a NULL pointer
> >> for q if a queue is manually unbound from the driver.  
> > By at the end of the series, I mean with all 15 patches applied.
> >
> > Regarding the case where the queue is manually unbound form the
> > driver, this is exactly one of the scenarios I was latently concerned
> > about. Let me explain. The manually unbound queue was already reset
> > in vfio_ap_mdev_remove_queue() if necessary, so we don't need to reset
> > it again. And more importantly it is not bound to the vfio_ap driver,
> > so vfio_ap is not allowed to reset it. (It could in theory belong to
> > and be in use by another non-default driver).
> >
> > I've just checked out vfio_ap_mdev_reset_queues() and it resets all
> > queues in the matrix. The in use mechanism does ensure that zcrypt
> > can't use these queues (together with a[pq]mask), but resetting a
> > queue that does not belong to us is going beyond our authority.  
> 
> I agree which is why in the next version I am only resetting a queue if
> it is bound at the time of the reset.
> 


Sounds good. Please keep my ack unless, the changes turn out
extensive. I will have a look at the new stuff again, and hopefully
upgrade to r-b. But I'm also fine with merging this patch as is
and addressing the stuff discussed later (hence the ack). It's up
to you.

Regards,
Halil

[..]
