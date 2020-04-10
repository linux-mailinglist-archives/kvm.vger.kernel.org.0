Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207471A47DF
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 17:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDJPc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 11:32:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbgDJPc0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Apr 2020 11:32:26 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03AFVkZd131564;
        Fri, 10 Apr 2020 11:32:25 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30920cu32d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Apr 2020 11:32:24 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03AFWOK2133283;
        Fri, 10 Apr 2020 11:32:24 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30920cu31r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Apr 2020 11:32:24 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03AFW6JP002700;
        Fri, 10 Apr 2020 15:32:23 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 3091mejt6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Apr 2020 15:32:23 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03AFWL9B8585720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 15:32:21 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A07D6AE068;
        Fri, 10 Apr 2020 15:32:21 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05DADAE063;
        Fri, 10 Apr 2020 15:32:21 +0000 (GMT)
Received: from cpe-172-100-173-215.stny.res.rr.com (unknown [9.85.170.119])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 10 Apr 2020 15:32:20 +0000 (GMT)
Subject: Re: [PATCH v7 02/15] s390/vfio-ap: manage link between queue struct
 and matrix mdev
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-3-akrowiak@linux.ibm.com>
 <20200409170602.4440be0f.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <4bebfddc-9897-b56a-59cf-84f391df57d5@linux.ibm.com>
Date:   Fri, 10 Apr 2020 11:32:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200409170602.4440be0f.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_05:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=3 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/9/20 11:06 AM, Cornelia Huck wrote:
> On Tue,  7 Apr 2020 15:20:02 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> A vfio_ap_queue structure is created for each queue device probed. To
>> ensure that the matrix mdev to which a queue's APQN is assigned is linked
>> to the queue structure as long as the queue device is bound to the vfio_ap
>> device driver, let's go ahead and manage these links when the queue device
>> is probed and removed as well as whenever an adapter or domain is assigned
>> to or unassigned from the matrix mdev.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 75 ++++++++++++++++++++++++++++---
>>   1 file changed, 70 insertions(+), 5 deletions(-)
> (...)
>
>> @@ -536,6 +531,31 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>>   	return 0;
>>   }
>>   
>> +/**
>> + * vfio_ap_mdev_qlinks_for_apid
> Hm... maybe the function name should express that there's some actual
> (un)linking going on?
>
> vfio_ap_mdev_link_by_apid?
>
> Or make this vfio_ap_mdev_link_queues() and pass in an indicator whether
> the passed value is an apid or an aqid? Both function names look so
> very similar to be easily confused (at least to me).

I like this idea, how about vfio_ap_link_mdev_to_queues()?


>
>> + *
>> + * @matrix_mdev: a matrix mediated device
>> + * @apqi:	 the APID of one or more APQNs assigned to @matrix_mdev
>> + *
>> + * Set the link to @matrix_mdev for each queue device bound to the vfio_ap
>> + * device driver with an APQN assigned to @matrix_mdev with the specified @apid.
>> + *
>> + * Note: If @matrix_mdev is NULL, the link to @matrix_mdev will be severed.
>> + */
>> +static void vfio_ap_mdev_qlinks_for_apid(struct ap_matrix_mdev *matrix_mdev,
>> +					 unsigned long apid)
>> +{
>> +	unsigned long apqi;
>> +	struct vfio_ap_queue *q;
>> +
>> +	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>> +			     matrix_mdev->matrix.aqm_max + 1) {
>> +		q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
>> +		if (q)
>> +			q->matrix_mdev = matrix_mdev;
>> +	}
>> +}
>> +
>>   /**
>>    * assign_adapter_store
>>    *
> (...)
>
>> @@ -682,6 +704,31 @@ vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
>>   	return 0;
>>   }
>>   
>> +/**
>> + * vfio_ap_mdev_qlinks_for_apqi
> See my comment above.
>
>> + *
>> + * @matrix_mdev: a matrix mediated device
>> + * @apqi:	 the APQI of one or more APQNs assigned to @matrix_mdev
>> + *
>> + * Set the link to @matrix_mdev for each queue device bound to the vfio_ap
>> + * device driver with an APQN assigned to @matrix_mdev with the specified @apqi.
>> + *
>> + * Note: If @matrix_mdev is NULL, the link to @matrix_mdev will be severed.
>> + */
>> +static void vfio_ap_mdev_qlinks_for_apqi(struct ap_matrix_mdev *matrix_mdev,
>> +					 unsigned long apqi)
>> +{
>> +	unsigned long apid;
>> +	struct vfio_ap_queue *q;
>> +
>> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
>> +			     matrix_mdev->matrix.apm_max + 1) {
>> +		q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
>> +		if (q)
>> +			q->matrix_mdev = matrix_mdev;
>> +	}
>> +}
>> +
>>   /**
>>    * assign_domain_store
>>    *
> (...)
>
>> @@ -1270,6 +1319,21 @@ void vfio_ap_mdev_unregister(void)
>>   	mdev_unregister_device(&matrix_dev->device);
>>   }
>>   
>> +static void vfio_ap_mdev_for_queue(struct vfio_ap_queue *q)
> vfio_ap_queue_link_mdev()? It is the other direction from the linking
> above.

How about vfio_ap_link_queue_to_mdevs()?

>
>> +{
>> +	unsigned long apid = AP_QID_CARD(q->apqn);
>> +	unsigned long apqi = AP_QID_QUEUE(q->apqn);
>> +	struct ap_matrix_mdev *matrix_mdev;
>> +
>> +	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
>> +		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
>> +		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
>> +			q->matrix_mdev = matrix_mdev;
>> +			break;
>> +		}
>> +	}
>> +}
>> +
>>   int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
>>   {
>>   	struct vfio_ap_queue *q;
>> @@ -1282,6 +1346,7 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
>>   	dev_set_drvdata(&queue->ap_dev.device, q);
>>   	q->apqn = queue->qid;
>>   	q->saved_isc = VFIO_AP_ISC_INVALID;
>> +	vfio_ap_mdev_for_queue(q);
>>   	hash_add(matrix_dev->qtable, &q->qnode, q->apqn);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
> In general, looks sane.
>

