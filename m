Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C160B2F55B5
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbhANBFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:05:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726428AbhANBEA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 20:04:00 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10E0Xbma150231;
        Wed, 13 Jan 2021 19:46:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1SwTKU/Sk4+wgxFcrmJc9tdUnpnyZkYvCrbZHt73Ys0=;
 b=JRZhUqT3usJwbxcaPIR8mxLgL4zozqrbhpjC7sOJuSL7kp055Dl9/ymZrGBftTi6e2CC
 E/4kd7ptYc8JRSGzl2Mh2rj0HdtVDLGwUwOhdfYvt59+/EwrcJaWq3M8ddp2Lti42uR8
 +qDBf4MDIUdegMrpJFaxEDT0Wq3AFrrHo3zH0tUlELL7kaB8JX/C2oViHRXuWR7k7qzS
 aaSqo/p3rUpBUPV6V9IZL4FMKqFTE5HL6caKJym1uODajEB2wy7kfrImE0O+wRQMIsx5
 TLYNOBTONtfm3JyNzXOvXLmkwYHeFwANHAm1QnolS+RbrSoAvbWbbm7Qd3Sj9UPVfWe5 eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362axns3sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 19:46:11 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10E0YxHb156414;
        Wed, 13 Jan 2021 19:46:10 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362axns3sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 19:46:10 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10E0RMtu015092;
        Thu, 14 Jan 2021 00:46:09 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 35y4499gt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 00:46:09 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10E0k68I27066808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 00:46:06 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5069EC6057;
        Thu, 14 Jan 2021 00:46:06 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73D67C6055;
        Thu, 14 Jan 2021 00:46:04 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 00:46:04 +0000 (GMT)
Subject: Re: [PATCH v13 02/15] s390/vfio-ap: No need to disable IRQ after
 queue reset
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
 <20201223011606.5265-3-akrowiak@linux.ibm.com>
 <20210111173206.27808b79.pasic@linux.ibm.com>
 <ed9eb852-5046-bcfc-be2c-3bb67323ec8a@linux.ibm.com>
 <20210113222107.527693df.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <520071f6-e5d1-25cf-e5eb-b6655adad404@linux.ibm.com>
Date:   Wed, 13 Jan 2021 19:46:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210113222107.527693df.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_14:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140000
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/13/21 4:21 PM, Halil Pasic wrote:
> On Wed, 13 Jan 2021 12:06:28 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 1/11/21 11:32 AM, Halil Pasic wrote:
>>> On Tue, 22 Dec 2020 20:15:53 -0500
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> The queues assigned to a matrix mediated device are currently reset when:
>>>>
>>>> * The VFIO_DEVICE_RESET ioctl is invoked
>>>> * The mdev fd is closed by userspace (QEMU)
>>>> * The mdev is removed from sysfs.
>>>>
>>>> Immediately after the reset of a queue, a call is made to disable
>>>> interrupts for the queue. This is entirely unnecessary because the reset of
>>>> a queue disables interrupts, so this will be removed.
>>>>
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>> ---
>>>>    drivers/s390/crypto/vfio_ap_drv.c     |  1 -
>>>>    drivers/s390/crypto/vfio_ap_ops.c     | 40 +++++++++++++++++----------
>>>>    drivers/s390/crypto/vfio_ap_private.h |  1 -
>>>>    3 files changed, 26 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
>>>> index be2520cc010b..ca18c91afec9 100644
>>>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>>>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>>>> @@ -79,7 +79,6 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>>>>    	apid = AP_QID_CARD(q->apqn);
>>>>    	apqi = AP_QID_QUEUE(q->apqn);
>>>>    	vfio_ap_mdev_reset_queue(apid, apqi, 1);
>>>> -	vfio_ap_irq_disable(q);
>>>>    	kfree(q);
>>>>    	mutex_unlock(&matrix_dev->lock);
>>>>    }
>>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>>> index 7339043906cf..052f61391ec7 100644
>>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>>> @@ -25,6 +25,7 @@
>>>>    #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
>>>>    
>>>>    static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>>>> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>>>>    
>>>>    static int match_apqn(struct device *dev, const void *data)
>>>>    {
>>>> @@ -49,20 +50,15 @@ static struct vfio_ap_queue *(
>>>>    					int apqn)
>>>>    {
>>>>    	struct vfio_ap_queue *q;
>>>> -	struct device *dev;
>>>>    
>>>>    	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
>>>>    		return NULL;
>>>>    	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
>>>>    		return NULL;
>>>>    
>>>> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>>>> -				 &apqn, match_apqn);
>>>> -	if (!dev)
>>>> -		return NULL;
>>>> -	q = dev_get_drvdata(dev);
>>>> -	q->matrix_mdev = matrix_mdev;
>>>> -	put_device(dev);
>>>> +	q = vfio_ap_find_queue(apqn);
>>>> +	if (q)
>>>> +		q->matrix_mdev = matrix_mdev;
>>>>    
>>>>    	return q;
>>>>    }
>>>> @@ -1126,24 +1122,27 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>>>    	return notify_rc;
>>>>    }
>>>>    
>>>> -static void (int apqn)
>>>> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>>>>    {
>>>>    	struct device *dev;
>>>> -	struct vfio_ap_queue *q;
>>>> +	struct vfio_ap_queue *q = NULL;
>>>>    
>>>>    	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>>>>    				 &apqn, match_apqn);
>>>>    	if (dev) {
>>>>    		q = dev_get_drvdata(dev);
>>>> -		vfio_ap_irq_disable(q);
>>>>    		put_device(dev);
>>>>    	}
>>>> +
>>>> +	return q;
>>>>    }
>>> This hunk and the previous one are a rewrite of vfio_ap_get_queue() and
>>> have next to nothing to do with the patch's objective. If we were at an
>>> earlier stage, I would ask to split it up.
>> The rewrite of vfio_ap_get_queue() definitely is related to this
>> patch's objective.
> Definitively loosely related.

A matter of opinion I suppose and I respect yours.

>
>> Below, in the vfio_ap_mdev_reset_queue()
>> function, there is the label 'free_aqic_resources' which is where
>> the call to vfio_ap_free_aqic_resources() function is called.
>> That function takes a struct vfio_ap_queue as an argument,
>> so the object needs to be retrieved prior to calling the function.
>> We can't use the vfio_ap_get_queue() function for two reasons:
>> 1. The vfio_ap_get_queue() function takes a struct ap_matrix_mdev
>>       as a parameter and we do not have a pointer to such at the time.
>> 2. The vfio_ap_get_queue() function is used to link the mdev to the
>>       vfio_ap_queue object with the specified APQN.
>> So, we needed a way to retrieve the vfio_ap_queue object by its
>> APQN only, Rather than creating a function that retrieves the
>> vfio_ap_queue object which duplicates the retrieval code in
>> vfio_ap_get_queue(), I created the vfio_ap_find_queue()
>> function to do just that and modified the vfio_ap_get_queue()
>> function to call it (i.e., code reuse).
> Please tell me what prevented you from doing a doing the splitting out
> vfio_ap_find_queue() from vfio_ap_get_queue() in a separate patch, that
> precedes this patch? It would have resulted in simpler diffs, because
> the split out wouldn't be intermingled with other stuff, i.e. getting
> rid of vfio_ap_irq_disable_apqn(). Don't you see that the two are
> intermingled in this diff?

I included this here for the reasons I stated above.
If I was reviewing these patches and saw this in a separate
patch I would wonder why it was being done since it would
be an isolated change requiring examination of subsequent
patches to figure out why it was done.  Since you have
taken the time to bring this up again I'll go ahead and do it
since I have no major objections and it is a fairly simple change.

>
>>
>>>   
>>>>    
>>>>    int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>>>>    			     unsigned int retry)
>>>>    {
>>>>    	struct ap_queue_status status;
>>>> +	struct vfio_ap_queue *q;
>>>> +	int ret;
>>>>    	int retry2 = 2;
>>>>    	int apqn = AP_MKQID(apid, apqi);
>>>>    
>>>> @@ -1156,18 +1155,32 @@ int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>>>>    				status = ap_tapq(apqn, NULL);
>>>>    			}
>>>>    			WARN_ON_ONCE(retry2 <= 0);
>>>> -			return 0;
>>>> +			ret = 0;
>>>> +			goto free_aqic_resources;
>>>>    		case AP_RESPONSE_RESET_IN_PROGRESS:
>>>>    		case AP_RESPONSE_BUSY:
>>>>    			msleep(20);
>>>>    			break;
>>>>    		default:
>>>>    			/* things are really broken, give up */
>>>> -			return -EIO;
>>>> +			ret = -EIO;
>>>> +			goto free_aqic_resources;
>>> Do we really want the unpin here? I mean the reset did not work and
>>> we are giving up. So the irqs are potentially still enabled.
>>>
>>> Without this patch we try to disable the interrupts using AQIC, and
>>> do the cleanup after that.
>> If the reset failure lands here, then a subsequent AQIC will
>> also fail, so I see no reason to expend processing time for
>> something that will ultimately fail anyways.
>>
>>> I'm aware, the comment says we should not take the default branch,
>>> but if that's really the case we should IMHO log an error and leak the
>>> page.
>> I do not see a good reason to leak the page, what purpose would
>> it serve?
> Well, the thing is we don't have a case for AP_RESPONSE_CHECKSTOPPED,
> which is, AFAIK a valid outcome. I don't remember what is the exact
> deal with checkstopped regarding interrupts.

The AP_RESPONSE_CHECKSTOPPED response code is set
when the AP function can not be performed due to a
machine failure resulting in loss of connectivity to the
queue. I find it hard to believe that interrupts would
continue to be signaled in that case. I will check with
the architecture folks for verification.

>
> If we take the default with something different
> than AP_RESPONSE_CHECKSTOPPED, that is AFAICT a bug of the underlying
> machine.

I think AP_RESPONSE_CHECKSTOPPED indicates a problem with
the machine also.

>
>> I don't have a problem with logging an error, do you think
>> it should just be a log message or a WARN_ON type of thing?
>>
> Seeing an outcome we don't expect to see, due to a bug in the underlying
> machine is in my book worth an error message. Furthermore we may not
> assume that the interrupts where shut down for the queue. So the only
> way we can protect the host is by leaking the page.

I won't assume anything - although I seriously doubt interrupts
will continue with a broken device - so I will get input from the
architecture folks regarding interrupts after a non-zero response
code.

>
>>> It's up to you if you want to change this. I don't want to delay the
>>> series any further than absolutely necessary.
>>>
>>> Acked-by: Halil Pasic <pasic@linux.ibm.com>
>>>   
>>>>    		}
>>>>    	} while (retry--);
>>>>    
>>>>    	return -EBUSY;
>>>> +
>>>> +free_aqic_resources:
>>>> +	/*
>>>> +	 * In order to free the aqic resources, the queue must be linked to
>>>> +	 * the matrix_mdev to which its APQN is assigned and the KVM pointer
>>>> +	 * must be available.
>>>> +	 */
>>>> +	q = vfio_ap_find_queue(apqn);
>>>> +	if (q && q->matrix_mdev && q->matrix_mdev->kvm)
>>> Is this of the type "we know there are no aqic resources to be freed" if
>>> precondition is false?
>> Yes
>>
>>> vfio_ap_free_aqic_resources() checks the matrix_mdev pointer but not the
>>> kvm pointer. Could we just check the kvm pointer in
>>> vfio_ap_free_aqic_resources()?
>> A while back I posted a patch that did just that and someone pushed back
>> because they could not see how the vfio_ap_free_aqic_resources()
>> function would ever be called with a NULL kvm pointer which is
>> why I implemented the above check. The reset is called
>> when the mdev is removed which can happen only when there
>> is no kvm pointer, so I agree it would be better to check the kvm
>> pointer in the vfio_ap_free_aqic_resources() function.
>>
> I don't remember. Sorry if it was me.
>
>>> At the end of the series, is seeing q! indicating a bug, or is it
>>> something we expect to see under certain circumstances?
>> I'm not quite sure to what you are referring regarding "the
>> end of the series", but we can expect to see a NULL pointer
>> for q if a queue is manually unbound from the driver.
> By at the end of the series, I mean with all 15 patches applied.
>
> Regarding the case where the queue is manually unbound form the
> driver, this is exactly one of the scenarios I was latently concerned
> about. Let me explain. The manually unbound queue was already reset
> in vfio_ap_mdev_remove_queue() if necessary, so we don't need to reset
> it again. And more importantly it is not bound to the vfio_ap driver,
> so vfio_ap is not allowed to reset it. (It could in theory belong to
> and be in use by another non-default driver).
>
> I've just checked out vfio_ap_mdev_reset_queues() and it resets all
> queues in the matrix. The in use mechanism does ensure that zcrypt
> can't use these queues (together with a[pq]mask), but resetting a
> queue that does not belong to us is going beyond our authority.

I agree which is why in the next version I am only resetting a queue if
it is bound at the time of the reset.

>
>
> Regards,
> Halil
>
>>>   
>>>> +		vfio_ap_free_aqic_resources(q);
>>>> +
>>>> +	return ret;
>>>>    }
>>>>    
>>>>    static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>>> @@ -1189,7 +1202,6 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>>>    			 */
>>>>    			if (ret)
>>>>    				rc = ret;
>>>> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
>>>>    		}
>>>>    	}
>>>>    
>>>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>>>> index f46dde56b464..0db6fb3d56d5 100644
>>>> --- a/drivers/s390/crypto/vfio_ap_private.h
>>>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>>>> @@ -100,5 +100,4 @@ struct vfio_ap_queue {
>>>>    #define VFIO_AP_ISC_INVALID 0xff
>>>>    	unsigned char saved_isc;
>>>>    };
>>>> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
>>>>    #endif /* _VFIO_AP_PRIVATE_H_ */

