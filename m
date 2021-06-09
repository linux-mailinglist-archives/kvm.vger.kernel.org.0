Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA693A1CAD
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFISZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:25:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21798 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229782AbhFISZr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 14:25:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 159I3NE4163251;
        Wed, 9 Jun 2021 14:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CVnLcPck4luc+7ow1AQPmNX/cTnKh7ymvw2EU+meJFw=;
 b=VLbD6XsY4+HHrYpezZjkMr5/PhRSnvP91DQfzEuo0P12edMg89gSY/d0Qlp33wi8k+Xz
 v4GfR6Pw4Jb9aBLoPl/jVu5jDkYWKfFkFUqZSnVgOdooKA4hh0wEqWce45hXJqc0FF12
 0M30kPKVcRbC/M/bEayjbqDEgpmRKOJmwmoArFSo27Jc4JiWM75dWHtwgmxhpny/L63i
 jGkrZlYKlqHoPPt6q5z5yMdUz/NlaPL99vE6grYvTGyZfLIdmsVN229ioyEvxUtl7e4g
 8NV2SLGeirRNVMVaDXdTloEfeBqeI0QfT8kuQouU+6N3J49py3YwgTdk4NRhBZqBUouG 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39311buqsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 14:23:51 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 159I5MX3174412;
        Wed, 9 Jun 2021 14:23:50 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39311buqs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 14:23:50 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 159IIppA002306;
        Wed, 9 Jun 2021 18:23:49 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3900w9stev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 18:23:49 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 159INlrI26345752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Jun 2021 18:23:47 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9993136060;
        Wed,  9 Jun 2021 18:23:46 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A210D136055;
        Wed,  9 Jun 2021 18:23:45 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.129.35])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  9 Jun 2021 18:23:45 +0000 (GMT)
Subject: Re: [PATCH v16 02/14] s390/vfio-ap: use new AP bus interface to
 search for queue devices
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
 <20210510164423.346858-3-akrowiak@linux.ibm.com>
 <06270f45-898b-5869-874d-008e3410c0de@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <1c4d2554-956b-e507-a4f2-bf1a68384652@linux.ibm.com>
Date:   Wed, 9 Jun 2021 14:23:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <06270f45-898b-5869-874d-008e3410c0de@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EMlGJZBOK4yBkTU6a6ZqdP2rnvm5jm7w
X-Proofpoint-ORIG-GUID: l36Cp-5wB5aqxwuBjIhqjYIR3kX49Nr3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_07:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/9/21 9:52 AM, Jason J. Herne wrote:
> On 5/10/21 12:44 PM, Tony Krowiak wrote:
>> This patch refactors the vfio_ap device driver to use the AP bus's
>> ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
>> information about a queue that is bound to the vfio_ap device driver.
>> The bus's ap_get_qdev() function retrieves the queue device from a
>> hashtable keyed by APQN. This is much more efficient than looping over
>> the list of devices attached to the AP bus by several orders of
>> magnitude.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 23 +++++++++--------------
>>   1 file changed, 9 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 757166da947e..8a50aa650b65 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -27,13 +27,6 @@
>>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>>   -static int match_apqn(struct device *dev, const void *data)
>> -{
>> -    struct vfio_ap_queue *q = dev_get_drvdata(dev);
>> -
>> -    return (q->apqn == *(int *)(data)) ? 1 : 0;
>> -}
>> -
>>   /**
>>    * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a 
>> list
>>    * @matrix_mdev: the associated mediated matrix
>> @@ -1253,15 +1246,17 @@ static int vfio_ap_mdev_group_notifier(struct 
>> notifier_block *nb,
>>     static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>>   {
>> -    struct device *dev;
>> +    struct ap_queue *queue;
>>       struct vfio_ap_queue *q = NULL;
>
> The use of q and queue as variable names was a little confusing to me 
> at first. I tried renaming them a few times, the best I could come up 
> with was this:

I am (was) not a fan of the naming convention, but using 'q' to name a 
struct vfio_ap_queue
was introduced (not by me) quite some time ago, so rather than 
introducing a variable name
change at this juncture, I stuck with it to be consistent with the other 
places it is used.

>
> struct ap_queue *queue;
> struct vfio_ap_queue *vfio_queue = NULL;
>
> Take it or leave it :) Other than that, LGTM.
> Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

Thanks for your review.

>
>
>> -    dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>> -                 &apqn, match_apqn);
>> -    if (dev) {
>> -        q = dev_get_drvdata(dev);
>> -        put_device(dev);
>> -    }
>> +    queue = ap_get_qdev(apqn);
>> +    if (!queue)
>> +        return NULL;
>> +
>> +    if (queue->ap_dev.device.driver == 
>> &matrix_dev->vfio_ap_drv->driver)
>> +        q = dev_get_drvdata(&queue->ap_dev.device);
>> +
>> +    put_device(&queue->ap_dev.device);
>>         return q;
>>   }
>>
>
>

