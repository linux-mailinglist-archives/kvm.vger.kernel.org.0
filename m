Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F36C25634D
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 01:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgH1XFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 19:05:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbgH1XFj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 19:05:39 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07SN2XVi006910;
        Fri, 28 Aug 2020 19:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wn8w9wu3HdZYhXruMb4USR6xxfiiUTh7SduUQNAtTPg=;
 b=lOK+A2CH9Fps2TQCWyEPDeG/82/NGeSBUhdiBPIzwZp1f8hcvYXPwBeTUVS6RYni3EQ0
 jndzj/GrkBKvHW9DDQFI3/nKZWqE1B9wIWZgHFNUeB9UjIYVHAH27Q/03QKugPTeMBw3
 WasQ9K/O3RNdZn0EfaeprHhv36IB2UKBTpkw+9CVQedmYgnINWEkg4DqVxyMPQslhud4
 OPmPV7cSfPD5vZ4nddogk3KCZIEoWMx4wERbfu2qteVYsu3Vo9Id/0rT7JsfoHKWQnw5
 93gxv3wksDCZ7bTWLgQANUdh+2h5iIAML1Iidnm0ua2mAPYEqWm9V8lXImIq9awPASgM 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 337a7dh877-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 19:05:38 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07SN5bvk016511;
        Fri, 28 Aug 2020 19:05:37 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 337a7dh86x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 19:05:37 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07SMwgiK004884;
        Fri, 28 Aug 2020 23:05:36 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 332ujqwd86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 23:05:36 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07SN5XcS1507864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 23:05:33 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30A837805E;
        Fri, 28 Aug 2020 23:05:33 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D41777805C;
        Fri, 28 Aug 2020 23:05:31 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.170.64])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 28 Aug 2020 23:05:31 +0000 (GMT)
Subject: Re: [PATCH v10 03/16] s390/vfio-ap: manage link between queue struct
 and matrix mdev
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-4-akrowiak@linux.ibm.com>
 <20200825122501.624474df.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <88f4061c-e609-38ee-a8c5-1f608d642158@linux.ibm.com>
Date:   Fri, 28 Aug 2020 19:05:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200825122501.624474df.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_18:2020-08-28,2020-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 suspectscore=3 malwarescore=0
 impostorscore=0 clxscore=1015 mlxscore=0 phishscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/25/20 6:25 AM, Cornelia Huck wrote:
> On Fri, 21 Aug 2020 15:56:03 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Let's create links between each queue device bound to the vfio_ap device
>> driver and the matrix mdev to which the queue is assigned. The idea is to
>> facilitate efficient retrieval of the objects representing the queue
>> devices and matrix mdevs as well as to verify that a queue assigned to
>> a matrix mdev is bound to the driver.
>>
>> The links will be created as follows:
>>
>>     * When the queue device is probed, if its APQN is assigned to a matrix
>>       mdev, the structures representing the queue device and the matrix mdev
>>       will be linked.
>>
>>     * When an adapter or domain is assigned to a matrix mdev, for each new
>>       APQN assigned that references a queue device bound to the vfio_ap
>>       device driver, the structures representing the queue device and the
>>       matrix mdev will be linked.
>>
>> The links will be removed as follows:
>>
>>     * When the queue device is removed, if its APQN is assigned to a matrix
>>       mdev, the structures representing the queue device and the matrix mdev
>>       will be unlinked.
>>
>>     * When an adapter or domain is unassigned from a matrix mdev, for each
>>       APQN unassigned that references a queue device bound to the vfio_ap
>>       device driver, the structures representing the queue device and the
>>       matrix mdev will be unlinked.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c     | 132 +++++++++++++++++++++++++-
>>   drivers/s390/crypto/vfio_ap_private.h |   2 +
>>   2 files changed, 129 insertions(+), 5 deletions(-)
>>
> (...)
>
>> @@ -548,6 +557,87 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>>   	return 0;
>>   }
>>   
>> +enum qlink_type {
> <bikeshed>I think this is less of a type, and more of an action, so
> maybe call this 'qlink_action' (and the function parameter below
> 'action'?)</bikeshed>

Sure, but what is this <bikeshed> tag?

>
>> +	LINK_APID,
>> +	LINK_APQI,
>> +	UNLINK_APID,
>> +	UNLINK_APQI,
>> +};
>> +
>> +static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
>> +				    unsigned long apid, unsigned long apqi)
>> +{
>> +	struct vfio_ap_queue *q;
>> +
>> +	q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
>> +	if (q) {
>> +		q->matrix_mdev = matrix_mdev;
>> +		hash_add(matrix_mdev->qtable,
>> +			 &q->mdev_qnode, q->apqn);
>> +	}
>> +}
>> +
>> +static void vfio_ap_mdev_unlink_queue(unsigned long apid, unsigned long apqi)
>> +{
>> +	struct vfio_ap_queue *q;
>> +
>> +	q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
>> +	if (q) {
>> +		q->matrix_mdev = NULL;
>> +		hash_del(&q->mdev_qnode);
>> +	}
>> +}
>> +
>> +/**
>> + * vfio_ap_mdev_link_queues
>> + *
>> + * @matrix_mdev: The matrix mdev to link.
>> + * @type:	 The type of @qlink_id.
>> + * @qlink_id:	 The APID or APQI of the queues to link.
>> + *
>> + * Sets or clears the links between the queues with the specified @qlink_id
>> + * and the @matrix_mdev:
>> + *     @type == LINK_APID: Set the links between the @matrix_mdev and the
>> + *                         queues with the specified @qlink_id (APID)
>> + *     @type == LINK_APQI: Set the links between the @matrix_mdev and the
>> + *                         queues with the specified @qlink_id (APQI)
>> + *     @type == UNLINK_APID: Clear the links between the @matrix_mdev and the
>> + *                           queues with the specified @qlink_id (APID)
>> + *     @type == UNLINK_APQI: Clear the links between the @matrix_mdev and the
>> + *                           queues with the specified @qlink_id (APQI)
>> + */
>> +static void vfio_ap_mdev_link_queues(struct ap_matrix_mdev *matrix_mdev,
>> +				     enum qlink_type type,
>> +				     unsigned long qlink_id)
>> +{
>> +	unsigned long id;
>> +
>> +	switch (type) {
>> +	case LINK_APID:
>> +		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
>> +				     matrix_mdev->matrix.aqm_max + 1)
>> +			vfio_ap_mdev_link_queue(matrix_mdev, qlink_id, id);
>> +		break;
>> +	case UNLINK_APID:
>> +		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
>> +				     matrix_mdev->matrix.aqm_max + 1)
>> +			vfio_ap_mdev_unlink_queue(qlink_id, id);
>> +		break;
>> +	case LINK_APQI:
>> +		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
>> +				     matrix_mdev->matrix.apm_max + 1)
>> +			vfio_ap_mdev_link_queue(matrix_mdev, id, qlink_id);
>> +		break;
>> +	case UNLINK_APQI:
>> +		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
>> +				     matrix_mdev->matrix.apm_max + 1)
>> +			vfio_ap_mdev_link_queue(matrix_mdev, id, qlink_id);
>> +		break;
>> +	default:
>> +		WARN_ON_ONCE(1);
>> +	}
>> +}
>> +
> (...)
>
> I have not reviewed this deeply, but at a glance, it seems fine.
>

