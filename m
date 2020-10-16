Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58886290CFA
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 22:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409680AbgJPU71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 16:59:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390548AbgJPU71 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Oct 2020 16:59:27 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09GKhn80103144;
        Fri, 16 Oct 2020 16:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=h5rJhWbeSHR2db+pm64otxxbtOCFhtGR88n80yifDrs=;
 b=QjPaJyjAeiVZKYoC0KO/KdA+0JO6bQ5mu3bdd095cYUHvtjoQYDGTD/nam63uFJRwB4O
 DPMvFnLKwG0vyyzCa7t5D+U153czMho8HbwtvQER5D6O3qOc6Z1vs/9J66QbJxq6g43Q
 JVZbJDrz4hQxGXGF7W4tVF1zyKRhP9ZUqw7cUILenSjOe0pU2tvi5kp9u/0S4sbBFpoy
 bqRnUEdFVfvCjURCZNQc3rLezpdmxsrzzZi3pYAw+LAeSKEQvKk0nK4d0lsHuL57uxe9
 FF0t9zrFVw7lG9K+bsjbqvT/A/mjrYaQJIY2882Z+rQHUz92DN7KGlbMeNuuXV1963RA 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 347jtc0b6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Oct 2020 16:59:25 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09GKjUSB107052;
        Fri, 16 Oct 2020 16:59:25 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 347jtc0b64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Oct 2020 16:59:25 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09GKptMp010567;
        Fri, 16 Oct 2020 20:59:24 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 3434k9trgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Oct 2020 20:59:24 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09GKxMcB12583664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Oct 2020 20:59:22 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB96E124053;
        Fri, 16 Oct 2020 20:59:22 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 158FA124052;
        Fri, 16 Oct 2020 20:59:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.170.177])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 16 Oct 2020 20:59:21 +0000 (GMT)
Subject: Re: [PATCH v10 02/16] s390/vfio-ap: use new AP bus interface to
 search for queue devices
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-3-akrowiak@linux.ibm.com>
 <20200825121334.0ff35d7a.cohuck@redhat.com>
 <b1c6bad8-3ec6-183c-3e35-9962e9c721c7@linux.ibm.com>
 <20200925041152.12f52141.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <ed00b2b8-2663-82f2-7a65-ed8c28125b2b@linux.ibm.com>
Date:   Fri, 16 Oct 2020 16:59:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200925041152.12f52141.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-16_11:2020-10-16,2020-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010160149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/24/20 10:11 PM, Halil Pasic wrote:
> On Thu, 27 Aug 2020 10:24:07 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>
>> On 8/25/20 6:13 AM, Cornelia Huck wrote:
>>> On Fri, 21 Aug 2020 15:56:02 -0400
>>> Tony Krowiak<akrowiak@linux.ibm.com>  wrote:
>>>
>>>> This patch refactor's the vfio_ap device driver to use the AP bus's
>>> s/refactor's/refactors/
>> Of course, what was I thinking?:)
>>
>>>> ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
>>>> information about a queue that is bound to the vfio_ap device driver.
>>>> The bus's ap_get_qdev() function retrieves the queue device from a
>>>> hashtable keyed by APQN. This is much more efficient than looping over
>>>> the list of devices attached to the AP bus by several orders of
>>>> magnitude.
>>>>
>>>> Signed-off-by: Tony Krowiak<akrowiak@linux.ibm.com>
>>>> Reported-by: kernel test robot<lkp@intel.com>
>>>> ---
>>>>    drivers/s390/crypto/vfio_ap_drv.c     | 27 ++-------
>>>>    drivers/s390/crypto/vfio_ap_ops.c     | 86 +++++++++++++++------------
>>>>    drivers/s390/crypto/vfio_ap_private.h |  8 ++-
>>>>    3 files changed, 59 insertions(+), 62 deletions(-)
>>>>
>>> (...)
>>>
>>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>>> index e0bde8518745..ad3925f04f61 100644
>>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>>> @@ -26,43 +26,26 @@vfio_ap_get_queue()
>>>>    
>>>>    static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>>>>    
>>>> -static int match_apqn(struct device *dev, const void *data)
>>>> -{
>>>> -	struct vfio_ap_queue *q = dev_get_drvdata(dev);
>>>> -
>>>> -	return (q->apqn == *(int *)(data)) ? 1 : 0;
>>>> -}
>>>> -
>>>>    /**
>>>> - * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
>>>> - * @matrix_mdev: the associated mediated matrix
>>>> + * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
>>>>     * @apqn: The queue APQN
>>>>     *
>>>> - * Retrieve a queue with a specific APQN from the list of the
>>>> - * devices of the vfio_ap_drv.
>>>> - * Verify that the APID and the APQI are set in the matrix.
>>>> + * Retrieve a queue with a specific APQN from the AP queue devices attached to
>>>> + * the AP bus.
>>>>     *
>>>> - * Returns the pointer to the associated vfio_ap_queue
>>>> + * Returns the pointer to the vfio_ap_queue with the specified APQN, or NULL.
>>>>     */
>>>> -static struct vfio_ap_queue *vfio_ap_get_queue(
>>>> -					struct ap_matrix_mdev *matrix_mdev,
>>>> -					int apqn)
>>>> +static struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
>>>>    {
>>>> +	struct ap_queue *queue;
>>>>    	struct vfio_ap_queue *q;
>>>> -	struct device *dev;
>>>>    
>>>> -	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
>>>> -		return NULL;
>>>> -	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
>>> I think you should add some explanation to the patch description why
>>> testing the matrix bitmasks is not needed anymore.
>> As a result of this comment, I took a closer look at the code to
>> determine the reason for eliminating the matrix_mdev
>> parameter. The reason is because the code below (i.e., find the device
>> and get the driver data) was also repeated in the vfio_ap_irq_disable_apqn()
>> function, so I replaced it with a call to the function above; however, the
>> vfio_ap_irq_disable_apqn() function  does not have a reference to the
>> matrix_mdev, so I eliminated the matrix_mdev parameter. Note that the
>> vfio_ap_irq_disable_apqn() is called for each APQN assigned to a matrix
>> mdev, so there is no need to test the bitmasks there.
>>
>> The other place from which the function above is called is
>> the handle_pqap() function which does have a reference to the
>> matrix_mdev. In order to ensure the integrity of the instruction
>> being intercepted - i.e., PQAP(AQIC) enable/disable IRQ for aN
>> AP queue - the testing of the matrix bitmasks probably ought to
>> be performed, so it will be done there instead of in the
>> vfio_ap_get_queue() function above.
> I'm a little confused. I do agree that in handle_pqap() we do want to
> make sure that we only operate on queues that belong to the given guest
> that issued the PQAP instruction.
>
> AFAICT with this patch set applied, this is not the case any more. Does
> that 'will be done there instead' refer to v11?

I understand your confusion, so here is what I'm going to do
to clear things up. I will leave the signature of the vfio_ap_get_queue()
function the same and leave in the bitmap checking. As per your
comment below, in patch 3 I will replace the call to
vfio_ap_get_queue() with a call to vfio_ap_get_mdev_queue().
Since the vfio_ap_get_mdev_queue() function is mdev-specific,
I can then remove the mdev parameter from the
vfio_ap_get_queue() function since it will no longer be needed.

> Another question is, can we use vfio_ap_get_mdev_queue() in
> handle_pqap() (instead of vfio_ap_get_queue())?

Yes, we can and should do that as it will eliminate both the need to
test the matrix bitmasks and several lines of code; however, that
function is not available until patch 3/16, so that change will be
made there.

>   
>>
>>> +	queue = ap_get_qdev(apqn);
>>> +	if (!queue)
>>>    		return NULL;
>>>    
>>> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>>> -				 &apqn, match_apqn);
>>> -	if (!dev)
>>> -		return NULL;
>>> -	q = dev_get_drvdata(dev);
>>> -	q->matrix_mdev = matrix_mdev;
>>> -	put_device(dev);
>>> +	q = dev_get_drvdata(&queue->ap_dev.device);
>>> +	put_device(&queue->ap_dev.device);
>>>    
>>>    	return q;
>>>    }
>>> (...)
>>>

