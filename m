Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08E027CE80
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 15:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgI2NHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 09:07:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55434 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728346AbgI2NHw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 09:07:52 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TD1lhL087243;
        Tue, 29 Sep 2020 09:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZcPwatVVGGsdrG5qoLd7oo/6QSYi4b7oVsRPZCVSCv0=;
 b=hMBciB/e/paaxMbwOcrlTziWVDhjn90lQ4Nfk0ddWI9bPQxQSwqHBNNaKAxYLc7TkR3k
 6nVG2S1qN564KFhPtGTXSySMg5wRdNjl/9T0+4hrgQ34K6xoeLrOnY9cEpgSysxFVZtq
 +BAEQBGF4GqebDLXOHIV0SeyfrahJkjmywx1iqqGGs1/KXC4SKGnWkEENVKIIOGNI+Tf
 kgfXUbma9GXJirC9xwsSnaR5/Q97QbMbU7SB3kn05TnDe75W6TPGYu18Z6sr8aGAAM0A
 /Knlf0ekf/B3hzY6vEa8YyjE0qe2t+jjBIinbJAQh8qUNr8eJUIfGKF1Cw769M/TAFHs jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v58ygs2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 09:07:48 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08TD3d1O097479;
        Tue, 29 Sep 2020 09:07:47 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v58ygs1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 09:07:47 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TCw6Xu017060;
        Tue, 29 Sep 2020 13:07:46 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 33sw99395q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 13:07:46 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TD7gTX24773098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 13:07:42 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5FC9136067;
        Tue, 29 Sep 2020 13:07:42 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A267136055;
        Tue, 29 Sep 2020 13:07:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.170.177])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 13:07:40 +0000 (GMT)
Subject: Re: [PATCH v10 02/16] s390/vfio-ap: use new AP bus interface to
 search for queue devices
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kernel test robot <lkp@intel.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-3-akrowiak@linux.ibm.com>
 <20200925042729.3b9d5704.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <ed021f29-927d-5bd6-4f2c-466f502f49f4@linux.ibm.com>
Date:   Tue, 29 Sep 2020 09:07:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200925042729.3b9d5704.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_04:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/24/20 10:27 PM, Halil Pasic wrote:
> On Fri, 21 Aug 2020 15:56:02 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
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
>> +	queue = ap_get_qdev(apqn);
>> +	if (!queue)
>>   		return NULL;
>>   
>> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>> -				 &apqn, match_apqn);
>> -	if (!dev)
>> -		return NULL;
>> -	q = dev_get_drvdata(dev);
>> -	q->matrix_mdev = matrix_mdev;
>> -	put_device(dev);
>> +	q = dev_get_drvdata(&queue->ap_dev.device);
> Is this cast here safe? (I don't think it is.)

In the probe, we execute:
dev_set_drvdata(&queue->ap_dev.device, q);

I don't get any compile nor execution errors. Why wouldn't it be safe?

>
>> +	put_device(&queue->ap_dev.device);
>>   
>>   	return q;
>>   }

