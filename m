Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673BD4B894
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 14:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732056AbfFSMcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 08:32:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732058AbfFSMcJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jun 2019 08:32:09 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5JCMadV167833
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 08:32:08 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t7mm71jb8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 08:32:08 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Wed, 19 Jun 2019 13:32:05 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 19 Jun 2019 13:32:03 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5JCW01u37880254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 12:32:00 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 190DE28059;
        Wed, 19 Jun 2019 12:32:00 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32DA12805C;
        Wed, 19 Jun 2019 12:31:59 +0000 (GMT)
Received: from [9.85.194.193] (unknown [9.85.194.193])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jun 2019 12:31:59 +0000 (GMT)
Subject: Re: [PATCH v4 1/7] s390: vfio-ap: Refactor vfio_ap driver probe and
 remove callbacks
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
 <1560454780-20359-2-git-send-email-akrowiak@linux.ibm.com>
 <20190618181456.0252227b.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Wed, 19 Jun 2019 08:31:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190618181456.0252227b.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061912-0072-0000-0000-0000043E66E3
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011290; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01220214; UDB=6.00641882; IPR=6.01001356;
 MB=3.00027374; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-19 12:32:05
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061912-0073-0000-0000-00004CAE71A3
Message-Id: <b4a77364-3924-20d7-42cd-e011106e0301@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/18/19 12:14 PM, Cornelia Huck wrote:
> On Thu, 13 Jun 2019 15:39:34 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> In order to limit the number of private mdev functions called from the
>> vfio_ap device driver as well as to provide a landing spot for dynamic
>> configuration code related to binding/unbinding AP queue devices to/from
>> the vfio_ap driver, the following changes are being introduced:
>>
>> * Move code from the vfio_ap driver's probe callback into a function
>>    defined in the mdev private operations file.
>>
>> * Move code from the vfio_ap driver's remove callback into a function
>>    defined in the mdev private operations file.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     | 27 ++++++++++-----------------
>>   drivers/s390/crypto/vfio_ap_ops.c     | 28 ++++++++++++++++++++++++++++
>>   drivers/s390/crypto/vfio_ap_private.h |  6 +++---
>>   3 files changed, 41 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
>> index 003662aa8060..3c60df70891b 100644
>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>> @@ -49,15 +49,15 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
>>    */
>>   static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>>   {
>> -	struct vfio_ap_queue *q;
>> -
>> -	q = kzalloc(sizeof(*q), GFP_KERNEL);
>> -	if (!q)
>> -		return -ENOMEM;
>> -	dev_set_drvdata(&apdev->device, q);
>> -	q->apqn = to_ap_queue(&apdev->device)->qid;
>> -	q->saved_isc = VFIO_AP_ISC_INVALID;
>> +	int ret;
>> +	struct ap_queue *queue = to_ap_queue(&apdev->device);
>> +
>> +	ret = vfio_ap_mdev_probe_queue(queue);
>> +	if (ret)
>> +		return ret;
>> +
>>   	return 0;
>> +
> 
> Maybe you could even condense this into a simple
> 
> return vfio_ap_mdev_probe_queue(to_ap_queue(&apdev->device));
> 
> (Unless you plan to do more things with queue in a future patch, of
> course.)

Consider it done.

> 
>>   }
>>   
>>   /**
> 
> (...)
> 
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index f46dde56b464..5cc3c2ebf151 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -90,8 +90,6 @@ struct ap_matrix_mdev {
>>   
>>   extern int vfio_ap_mdev_register(void);
>>   extern void vfio_ap_mdev_unregister(void);
>> -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>> -			     unsigned int retry);
> 
> If you don't need that function across files anymore, you probably want
> to make it static.

Yes.

> 
>>   
>>   struct vfio_ap_queue {
>>   	struct ap_matrix_mdev *matrix_mdev;
>> @@ -100,5 +98,7 @@ struct vfio_ap_queue {
>>   #define VFIO_AP_ISC_INVALID 0xff
>>   	unsigned char saved_isc;
>>   };
>> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
> 
> Same here.

Yes again.

> 
>> +int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
>> +void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
>> +
>>   #endif /* _VFIO_AP_PRIVATE_H_ */
> 

