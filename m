Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F14B2A3630
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 22:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgKBV5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 16:57:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgKBV5S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 16:57:18 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2LVTGo013877;
        Mon, 2 Nov 2020 16:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3BYDWM2X8bA/8icKlwIc+LiPD/uR6yMp6m/1i4e4jXg=;
 b=EKDVxfmKEto3bD3dRbWgWQFUqhq4c9rDzU0wthgZcpj2uP5cVRzldDYc9PdBaIlDq992
 Mm3khN901ZgTFpZnT2oTURBeTtqw3Py6QEwieTdWktmxpHXkc9huXCKdYXBHCU+qjvra
 3BYHhtSd4z6X7EzgXP34HK+z6GfTcMtakmQxKfJWk/wJFGgDVK/CR1YA8maU1vZP7NAp
 OvEKqgJ0MoIZuEMeK4ZVEgcEpIQeUPN29V1CYXdOblO0jnWGAY25PlkFL+JFiH+qrSg2
 jn3/VlQYiAsAsL9oebdrTt/HfGYxXVxdAnbDuUWC0/c1nNPCrN2tHnufrBTa2KQdOlJT JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34jrxkhrnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 16:57:12 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A2LVf7D014395;
        Mon, 2 Nov 2020 16:57:11 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34jrxkhrn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 16:57:11 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A2LvBhH006885;
        Mon, 2 Nov 2020 21:57:11 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 34h0fjg8s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 21:57:11 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A2Lv9BI9241274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Nov 2020 21:57:09 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66CE22805C;
        Mon,  2 Nov 2020 21:57:09 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5BD028058;
        Mon,  2 Nov 2020 21:57:08 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.174])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  2 Nov 2020 21:57:08 +0000 (GMT)
Subject: Re: [PATCH v11 02/14] 390/vfio-ap: use new AP bus interface to search
 for queue devices
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-3-akrowiak@linux.ibm.com>
 <20201027080158.0a4fa6b2.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <c81abca5-9831-0e50-fb29-00e841c843d8@linux.ibm.com>
Date:   Mon, 2 Nov 2020 16:57:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201027080158.0a4fa6b2.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_15:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011020161
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/27/20 3:01 AM, Halil Pasic wrote:
> On Thu, 22 Oct 2020 13:11:57 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> This patch refactors the vfio_ap device driver to use the AP bus's
>> ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
>> information about a queue that is bound to the vfio_ap device driver.
>> The bus's ap_get_qdev() function retrieves the queue device from a
>> hashtable keyed by APQN. This is much more efficient than looping over
>> the list of devices attached to the AP bus by several orders of
>> magnitude.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

Thank you for your review.

>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 35 +++++++++++++------------------
>>   1 file changed, 14 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index c471832f0a30..049b97d7444c 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -26,43 +26,36 @@
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
>> + * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
>>    * @matrix_mdev: the associated mediated matrix
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
>>   static struct vfio_ap_queue *vfio_ap_get_queue(
>>   					struct ap_matrix_mdev *matrix_mdev,
>> -					int apqn)
>> +					unsigned long apqn)
>>   {
>> -	struct vfio_ap_queue *q;
>> -	struct device *dev;
>> +	struct ap_queue *queue;
>> +	struct vfio_ap_queue *q = NULL;
>>   
>>   	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
>>   		return NULL;
>>   	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
>>   		return NULL;
>>   
>> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>> -				 &apqn, match_apqn);
>> -	if (!dev)
>> +	queue = ap_get_qdev(apqn);
>> +	if (!queue)
>>   		return NULL;
>> -	q = dev_get_drvdata(dev);
>> -	q->matrix_mdev = matrix_mdev;
>> -	put_device(dev);
>> +
>> +	if (queue->ap_dev.device.driver == &matrix_dev->vfio_ap_drv->driver)
>> +		q = dev_get_drvdata(&queue->ap_dev.device);
>> +
> Needs to be called with the vfio_ap lock held, right? Otherwise the queue could
> get unbound while we are working with it as a vfio_ap_queue... Noting
> new, but might we worth documenting.

This is always called with the vfio_ap lock held.

>
>> +	put_device(&queue->ap_dev.device);
>>   
>>   	return q;
>>   }

