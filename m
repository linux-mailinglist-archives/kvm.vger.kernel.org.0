Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92F915506
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 22:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfEFUnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 16:43:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56376 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726602AbfEFUnx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 16:43:53 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46KCXEs055497
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 16:43:52 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sauje1n0p-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 16:43:51 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Mon, 6 May 2019 21:43:50 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e17.ny.us.ibm.com (146.89.104.204) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 21:43:47 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46KhjiQ36241492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 20:43:45 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5727FAC05E;
        Mon,  6 May 2019 20:43:45 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0248AC059;
        Mon,  6 May 2019 20:43:44 +0000 (GMT)
Received: from [9.60.75.251] (unknown [9.60.75.251])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 20:43:44 +0000 (GMT)
Subject: Re: [PATCH v2 6/7] s390: vfio-ap: handle bind and unbind of AP queue
 device
To:     pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
 <1556918073-13171-7-git-send-email-akrowiak@linux.ibm.com>
 <acf4e2fe-7b91-718c-f1f7-f4678eda52e0@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Mon, 6 May 2019 16:43:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <acf4e2fe-7b91-718c-f1f7-f4678eda52e0@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050620-0040-0000-0000-000004EC0CA3
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011061; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01199558; UDB=6.00629330; IPR=6.00980434;
 MB=3.00026760; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-06 20:43:50
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050620-0041-0000-0000-000008F814C7
Message-Id: <33201b9c-0479-d675-e265-c09b24695f1c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/19 6:55 AM, Pierre Morel wrote:
> On 03/05/2019 23:14, Tony Krowiak wrote:
>> There is nothing preventing a root user from inadvertently unbinding an
>> AP queue device that is in use by a guest from the vfio_ap device driver
>> and binding it to a zcrypt driver. This can result in a queue being
>> accessible from both the host and a guest.
>>
>> This patch introduces safeguards that prevent sharing of an AP queue
>> between the host when a queue device is unbound from the vfio_ap device
>> driver. In addition, this patch restores guest access to AP queue devices
>> bound to the vfio_ap driver if the queue's APQN is assigned to an mdev
>> device in use by a guest.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     |  12 +++-
>>   drivers/s390/crypto/vfio_ap_ops.c     | 100 
>> +++++++++++++++++++++++++++++++++-
>>   drivers/s390/crypto/vfio_ap_private.h |   2 +
>>   3 files changed, 111 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c 
>> b/drivers/s390/crypto/vfio_ap_drv.c
>> index e9824c35c34f..c215978daf39 100644
>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>> @@ -42,12 +42,22 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
>>   static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>>   {
>> +    struct ap_queue *queue = to_ap_queue(&apdev->device);
>> +
>> +    mutex_lock(&matrix_dev->lock);
>> +    vfio_ap_mdev_probe_queue(queue);
>> +    mutex_unlock(&matrix_dev->lock);
>> +
>>       return 0;
>>   }
>>   static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>>   {
>> -    /* Nothing to do yet */
>> +    struct ap_queue *queue = to_ap_queue(&apdev->device);
>> +
>> +    mutex_lock(&matrix_dev->lock);
>> +    vfio_ap_mdev_remove_queue(queue);
>> +    mutex_unlock(&matrix_dev->lock);
>>   }
>>   static void vfio_ap_matrix_dev_release(struct device *dev)
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index ede45184eb67..40324951bd37 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -226,8 +226,6 @@ static struct device 
>> *vfio_ap_get_queue_dev(unsigned long apid,
>>                     &apqn, match_apqn);
>>   }
>> -
>> -
>>   static int vfio_ap_mdev_validate_masks(unsigned long *apm, unsigned 
>> long *aqm)
>>   {
>>       int ret;
>> @@ -259,6 +257,27 @@ static bool vfio_ap_queues_on_drv(unsigned long 
>> *apm, unsigned long *aqm)
>>       return true;
>>   }
>> +static bool vfio_ap_card_on_drv(struct ap_queue *queue, unsigned long 
>> *aqm)
>> +{
>> +    unsigned long apid, apqi;
>> +    struct device *dev;
>> +
>> +    apid = AP_QID_CARD(queue->qid);
>> +
>> +    for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
>> +        if (queue->qid == AP_MKQID(apid, apqi))
>> +            continue;
>> +
>> +        dev = vfio_ap_get_queue_dev(apid, apqi);
>> +        if (!dev)
>> +            return false;
>> +
>> +        put_device(dev);
>> +    }
>> +
>> +    return true;
>> +}
>> +
>>   /**
>>    * assign_adapter_store
>>    *
>> @@ -1017,3 +1036,80 @@ void vfio_ap_mdev_unregister(void)
>>   {
>>       mdev_unregister_device(&matrix_dev->device);
>>   }
>> +
>> +static struct ap_matrix_mdev *vfio_ap_mdev_find_matrix_mdev(unsigned 
>> long apid,
>> +                                unsigned long apqi)
>> +{
>> +    struct ap_matrix_mdev *matrix_mdev;
>> +
>> +    list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
>> +        if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
>> +            test_bit_inv(apqi, matrix_mdev->matrix.aqm))
>> +            return matrix_mdev;
>> +    }
>> +
>> +    return NULL;
>> +}
>> +
>> +void vfio_ap_mdev_probe_queue(struct ap_queue *queue)
>> +{
>> +    struct ap_matrix_mdev *matrix_mdev;
>> +    unsigned long *shadow_apm, *shadow_aqm;
>> +    unsigned long apid = AP_QID_CARD(queue->qid);
>> +    unsigned long apqi = AP_QID_QUEUE(queue->qid);
>> +
>> +    /*
>> +     * Find the mdev device to which the APQN of the queue device being
>> +     * probed is assigned
>> +     */
>> +    matrix_mdev = vfio_ap_mdev_find_matrix_mdev(apid, apqi);
>> +
>> +    /* Check whether we found an mdev device and it is in use by a 
>> guest */
>> +    if (matrix_mdev && matrix_mdev->kvm) {
>> +        shadow_apm = matrix_mdev->shadow_crycb->apm;
>> +        shadow_aqm = matrix_mdev->shadow_crycb->aqm;
>> +        /*
>> +         * If the guest already has access to the adapter card
>> +         * referenced by APID or does not have access to the queues
>> +         * referenced by APQI, there is nothing to do here.
>> +         */
>> +        if (test_bit_inv(apid, shadow_apm) ||
>> +            !test_bit_inv(apqi, shadow_aqm))
>> +            return;
>> +
>> +        /*
>> +         * If each APQN with the APID of the queue being probed and an
>> +         * APQI in the shadow CRYCB references a queue device that is
>> +         * bound to the vfio_ap driver, then plug the adapter into the
>> +         * guest.
>> +         */
>> +        if (vfio_ap_card_on_drv(queue, shadow_aqm)) {
>> +            set_bit_inv(apid, shadow_apm);
>> +            vfio_ap_mdev_update_crycb(matrix_mdev);
>> +        }
>> +    }
>> +}
>> +
>> +void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
>> +{
>> +    struct ap_matrix_mdev *matrix_mdev;
>> +    unsigned long apid = AP_QID_CARD(queue->qid);
>> +    unsigned long apqi = AP_QID_QUEUE(queue->qid);
>> +
>> +    matrix_mdev = vfio_ap_mdev_find_matrix_mdev(apid, apqi);
>> +
>> +    /*
>> +     * If the queue is assigned to the mdev device and the mdev device
>> +     * is in use by a guest, unplug the adapter referred to by the APID
>> +     * of the APQN of the queue being removed.
>> +     */
>> +    if (matrix_mdev && matrix_mdev->kvm) {
>> +        if (!test_bit_inv(apid, matrix_mdev->shadow_crycb->apm))
>> +            return;
>> +
>> +        clear_bit_inv(apid, matrix_mdev->shadow_crycb->apm);
>> +        vfio_ap_mdev_update_crycb(matrix_mdev);
>> +    }
>> +
>> +    vfio_ap_mdev_reset_queue(apid, apqi);
>> +}
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h 
>> b/drivers/s390/crypto/vfio_ap_private.h
>> index e8457aa61976..6b1f7df5b979 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -87,5 +87,7 @@ struct ap_matrix_mdev {
>>   extern int vfio_ap_mdev_register(void);
>>   extern void vfio_ap_mdev_unregister(void);
>> +void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
>> +void vfio_ap_mdev_probe_queue(struct ap_queue *queue);
>>   #endif /* _VFIO_AP_PRIVATE_H_ */
>>
> 
> 
> AFAIU the apmask/aqmask of the AP_BUS are replacing bind/unbind for the 
> admin. Don't they?

Yes, these interfaces are used to bind/unbind.

> Then why not suppress bind/unbind for ap_queues?

I did suppress them in a previous version, but I believe Harald
objected. I don't recall the reason. If any other maintainers
agree with this, I can reinstate that change. I personally would
prefer that. I think leaving the bind/unbind interfaces confuses
the issue.

> 
> Otherwise, it seems to me to handle correctly the disappearance of a 
> card, which is the only thing that can happen from out of the firmware 
> queue change requires configuration change and re-IPL.

You are correct.

> 
> Even still need testing, LGTM

I would welcome and appreciate additional testing, thanks in advance.

> 
> 

