Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3641D8BA02
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbfHMNXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:23:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728713AbfHMNXe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Aug 2019 09:23:34 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7DDMJxx090997;
        Tue, 13 Aug 2019 09:23:28 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ubwduhwjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Aug 2019 09:23:28 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DDMJct091083;
        Tue, 13 Aug 2019 09:23:28 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ubwduhwj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Aug 2019 09:23:28 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7DDJoUI000337;
        Tue, 13 Aug 2019 13:23:27 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 2u9nj63ctf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Aug 2019 13:23:27 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7DDNMnd40305086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 13:23:23 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8077136072;
        Tue, 13 Aug 2019 13:23:22 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BA6B13607D;
        Tue, 13 Aug 2019 13:23:20 +0000 (GMT)
Received: from [9.85.180.3] (unknown [9.85.180.3])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 13 Aug 2019 13:23:20 +0000 (GMT)
Subject: Re: [PATCH] s390: vfio-ap: remove unnecessary calls to disable queue
 interrupts
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1565642829-20157-1-git-send-email-akrowiak@linux.ibm.com>
 <20190813132957.7fafad2d.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <0d5b92ea-a16b-c38c-da15-0de150b28adf@linux.ibm.com>
Date:   Tue, 13 Aug 2019 09:23:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190813132957.7fafad2d.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130143
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/13/19 7:29 AM, Cornelia Huck wrote:
> On Mon, 12 Aug 2019 16:47:09 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> When an AP queue is reset (zeroized), interrupts are disabled. The queue
>> reset function currently tries to disable interrupts unnecessarily. This patch
>> removes the unnecessary calls to disable interrupts after queue reset.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 0604b49a4d32..407c2f0f25f9 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1114,18 +1114,19 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   	return NOTIFY_OK;
>>   }
>>   
>> -static void vfio_ap_irq_disable_apqn(int apqn)
>> +static struct vfio_ap_queue *vfio_ap_find_qdev(int apqn)
>>   {
>>   	struct device *dev;
>> -	struct vfio_ap_queue *q;
>> +	struct vfio_ap_queue *q = NULL;
>>   
>>   	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>>   				 &apqn, match_apqn);
>>   	if (dev) {
>>   		q = dev_get_drvdata(dev);
>> -		vfio_ap_irq_disable(q);
>>   		put_device(dev);
>>   	}
>> +
>> +	return q;
>>   }
>>   
>>   int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>> @@ -1164,6 +1165,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>   	int rc = 0;
>>   	unsigned long apid, apqi;
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>> +	struct vfio_ap_queue *q;
>>   
>>   	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
>>   			     matrix_mdev->matrix.apm_max + 1) {
>> @@ -1177,7 +1179,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>   			 */
>>   			if (ret)
>>   				rc = ret;
>> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
> 
> Might be useful to stick a comment in this function that resetting the
> queue has also disabled the interrupts, as the architecture
> documentation for that is not publicly available.

Will do.

> 
>> +
>> +			q = vfio_ap_find_qdev(AP_MKQID(apid, apqi));
>> +			if (q)
>> +				vfio_ap_free_aqic_resources(q);
>>   		}
>>   	}
>>   
> 
> Trusting your reading of the architecture,
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

