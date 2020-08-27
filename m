Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C3F2546BE
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 16:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgH0OZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 10:25:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727793AbgH0OYS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 10:24:18 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07RE2VUc064531;
        Thu, 27 Aug 2020 10:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FTRLjuVSGLLDtNNu6/bc57ixywQRqLJ/pzpYQqt7L3Y=;
 b=EocTlq0ObfGvEZigSQuK/GZpMAWhRrsX0ntZ37O4xtHkVEY49/4RLDMi0aPbq7URtCYt
 uzFdcHYtXUJUiwbqBv/o2TfqceI81RyekrudvWLm3YUhhLVog1zkBQclqvm8gP7aNeNC
 7Tih7RUM6l7FyU7ZuL+vmrZrz2b0LDrVZ7NehP6AihP8dHp5xf7TxlgqaLzm8X5LY0ey
 R8/KIADzD4RSc1c5WTb8TNh3pzENxPiAc1K9b1NZpCxd5Uid1Ak33g0GZ4b4xRElgLZ3
 mhjh2GmiprZ0c+Yhf0nPjc0F+tQ3DsIgHj5nerbL4LCYghgKpOtH4qkhnj1b+2Crlcja yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 336dy2hdpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 10:24:14 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07RE41OF073832;
        Thu, 27 Aug 2020 10:24:13 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 336dy2hdpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 10:24:13 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07REN8i7004383;
        Thu, 27 Aug 2020 14:24:13 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 332uwatjrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 14:24:13 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07REO5rt41746780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 14:24:05 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E48BE051;
        Thu, 27 Aug 2020 14:24:09 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D251BE04F;
        Thu, 27 Aug 2020 14:24:08 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.170.64])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 14:24:08 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH v10 02/16] s390/vfio-ap: use new AP bus interface to
 search for queue devices
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kernel test robot <lkp@intel.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-3-akrowiak@linux.ibm.com>
 <20200825121334.0ff35d7a.cohuck@redhat.com>
Message-ID: <b1c6bad8-3ec6-183c-3e35-9962e9c721c7@linux.ibm.com>
Date:   Thu, 27 Aug 2020 10:24:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200825121334.0ff35d7a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_07:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 suspectscore=3 lowpriorityscore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/25/20 6:13 AM, Cornelia Huck wrote:
> On Fri, 21 Aug 2020 15:56:02 -0400
> Tony Krowiak<akrowiak@linux.ibm.com>  wrote:
>
>> This patch refactor's the vfio_ap device driver to use the AP bus's
> s/refactor's/refactors/

Of course, what was I thinking?:)

>> ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
>> information about a queue that is bound to the vfio_ap device driver.
>> The bus's ap_get_qdev() function retrieves the queue device from a
>> hashtable keyed by APQN. This is much more efficient than looping over
>> the list of devices attached to the AP bus by several orders of
>> magnitude.
>>
>> Signed-off-by: Tony Krowiak<akrowiak@linux.ibm.com>
>> Reported-by: kernel test robot<lkp@intel.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     | 27 ++-------
>>   drivers/s390/crypto/vfio_ap_ops.c     | 86 +++++++++++++++------------
>>   drivers/s390/crypto/vfio_ap_private.h |  8 ++-
>>   3 files changed, 59 insertions(+), 62 deletions(-)
>>
> (...)
>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index e0bde8518745..ad3925f04f61 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -26,43 +26,26 @@
>>   
>>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>>   
>> -static int match_apqn(struct device *dev, const void *data)
>> -{
>> -	struct vfio_ap_queue *q = dev_get_drvdata(dev);
>> -
>> -	return (q->apqn == *(int *)(data)) ? 1 : 0;
>> -}
>> -
>>   /**
>> - * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
>> - * @matrix_mdev: the associated mediated matrix
>> + * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
>>    * @apqn: The queue APQN
>>    *
>> - * Retrieve a queue with a specific APQN from the list of the
>> - * devices of the vfio_ap_drv.
>> - * Verify that the APID and the APQI are set in the matrix.
>> + * Retrieve a queue with a specific APQN from the AP queue devices attached to
>> + * the AP bus.
>>    *
>> - * Returns the pointer to the associated vfio_ap_queue
>> + * Returns the pointer to the vfio_ap_queue with the specified APQN, or NULL.
>>    */
>> -static struct vfio_ap_queue *vfio_ap_get_queue(
>> -					struct ap_matrix_mdev *matrix_mdev,
>> -					int apqn)
>> +static struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
>>   {
>> +	struct ap_queue *queue;
>>   	struct vfio_ap_queue *q;
>> -	struct device *dev;
>>   
>> -	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
>> -		return NULL;
>> -	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
> I think you should add some explanation to the patch description why
> testing the matrix bitmasks is not needed anymore.

As a result of this comment, I took a closer look at the code to
determine the reason for eliminating the matrix_mdev
parameter. The reason is because the code below (i.e., find the device
and get the driver data) was also repeated in the vfio_ap_irq_disable_apqn()
function, so I replaced it with a call to the function above; however, the
vfio_ap_irq_disable_apqn() function  does not have a reference to the
matrix_mdev, so I eliminated the matrix_mdev parameter. Note that the
vfio_ap_irq_disable_apqn() is called for each APQN assigned to a matrix
mdev, so there is no need to test the bitmasks there.

The other place from which the function above is called is
the handle_pqap() function which does have a reference to the
matrix_mdev. In order to ensure the integrity of the instruction
being intercepted - i.e., PQAP(AQIC) enable/disable IRQ for aN
AP queue - the testing of the matrix bitmasks probably ought to
be performed, so it will be done there instead of in the
vfio_ap_get_queue() function above.


> +	queue = ap_get_qdev(apqn);
> +	if (!queue)
>   		return NULL;
>   
> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				 &apqn, match_apqn);
> -	if (!dev)
> -		return NULL;
> -	q = dev_get_drvdata(dev);
> -	q->matrix_mdev = matrix_mdev;
> -	put_device(dev);
> +	q = dev_get_drvdata(&queue->ap_dev.device);
> +	put_device(&queue->ap_dev.device);
>   
>   	return q;
>   }
> (...)
>

