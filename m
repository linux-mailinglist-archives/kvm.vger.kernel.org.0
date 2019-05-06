Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FCE154F2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 22:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEFUfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 16:35:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbfEFUfl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 16:35:41 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46KCk5X005968
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 16:35:40 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2saurmguc9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 16:35:39 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Mon, 6 May 2019 21:35:38 +0100
Received: from b01cxnp23033.gho.pok.ibm.com (9.57.198.28)
        by e17.ny.us.ibm.com (146.89.104.204) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 21:35:34 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46KZW5Z28639356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 20:35:32 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21EF8AC059;
        Mon,  6 May 2019 20:35:32 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4706AC05F;
        Mon,  6 May 2019 20:35:31 +0000 (GMT)
Received: from [9.60.75.251] (unknown [9.60.75.251])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 20:35:31 +0000 (GMT)
Subject: Re: [PATCH v2 4/7] s390: vfio-ap: allow assignment of unavailable AP
 resources to mdev device
To:     pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
 <1556918073-13171-5-git-send-email-akrowiak@linux.ibm.com>
 <2ba0aa01-e043-0013-4e2e-ea17bf9eea05@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Mon, 6 May 2019 16:35:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <2ba0aa01-e043-0013-4e2e-ea17bf9eea05@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050620-0040-0000-0000-000004EC0B96
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011061; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01199555; UDB=6.00629329; IPR=6.00980431;
 MB=3.00026760; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-06 20:35:37
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050620-0041-0000-0000-000008F813B8
Message-Id: <e0ce0d24-a732-d92a-3c3c-81204425d9b7@linux.ibm.com>
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

On 5/6/19 3:05 AM, Pierre Morel wrote:
> On 03/05/2019 23:14, Tony Krowiak wrote:
>> The AP architecture does not preclude assignment of AP resources that are
>> not yet in the AP configuration (i.e., not available or not online).
>> Let's go ahead and implement this facet of the AP architecture for linux
>> guests.
>>
>> The current implementation does not allow assignment of AP resources to
>> an mdev device if the AP queue devices identified by the assignment are
>> not bound to the vfio_ap device driver. This patch allows assignment 
>> of AP
>> resources to the mdev device even if the AP queue devices are not 
>> bound to
>> the vfio_ap device driver, as long as the AP queue devices are not
>> reserved by the AP BUS for use by the zcrypt device drivers.
> 
> or another mediated device.

Right you are!!

> 
> 
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 231 
>> ++++++++------------------------------
>>   1 file changed, 44 insertions(+), 187 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 1021466cb661..ea24caf17a16 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -113,122 +113,6 @@ static struct attribute_group 
>> *vfio_ap_mdev_type_groups[] = {
>>       NULL,
>>   };
>> -struct vfio_ap_queue_reserved {
>> -    unsigned long *apid;
>> -    unsigned long *apqi;
>> -    bool reserved;
>> -};
>> -
>> -/**
>> - * vfio_ap_has_queue
>> - *
>> - * @dev: an AP queue device
>> - * @data: a struct vfio_ap_queue_reserved reference
>> - *
>> - * Flags whether the AP queue device (@dev) has a queue ID containing 
>> the APQN,
>> - * apid or apqi specified in @data:
>> - *
>> - * - If @data contains both an apid and apqi value, then @data will 
>> be flagged
>> - *   as reserved if the APID and APQI fields for the AP queue device 
>> matches
>> - *
>> - * - If @data contains only an apid value, @data will be flagged as
>> - *   reserved if the APID field in the AP queue device matches
>> - *
>> - * - If @data contains only an apqi value, @data will be flagged as
>> - *   reserved if the APQI field in the AP queue device matches
>> - *
>> - * Returns 0 to indicate the input to function succeeded. Returns 
>> -EINVAL if
>> - * @data does not contain either an apid or apqi.
>> - */
>> -static int vfio_ap_has_queue(struct device *dev, void *data)
>> -{
>> -    struct vfio_ap_queue_reserved *qres = data;
>> -    struct ap_queue *ap_queue = to_ap_queue(dev);
>> -    ap_qid_t qid;
>> -    unsigned long id;
>> -
>> -    if (qres->apid && qres->apqi) {
>> -        qid = AP_MKQID(*qres->apid, *qres->apqi);
>> -        if (qid == ap_queue->qid)
>> -            qres->reserved = true;
>> -    } else if (qres->apid && !qres->apqi) {
>> -        id = AP_QID_CARD(ap_queue->qid);
>> -        if (id == *qres->apid)
>> -            qres->reserved = true;
>> -    } else if (!qres->apid && qres->apqi) {
>> -        id = AP_QID_QUEUE(ap_queue->qid);
>> -        if (id == *qres->apqi)
>> -            qres->reserved = true;
>> -    } else {
>> -        return -EINVAL;
>> -    }
>> -
>> -    return 0;
>> -}
>> -
>> -/**
>> - * vfio_ap_verify_queue_reserved
>> - *
>> - * @matrix_dev: a mediated matrix device
>> - * @apid: an AP adapter ID
>> - * @apqi: an AP queue index
>> - *
>> - * Verifies that the AP queue with @apid/@apqi is reserved by the 
>> VFIO AP device
>> - * driver according to the following rules:
>> - *
>> - * - If both @apid and @apqi are not NULL, then there must be an AP 
>> queue
>> - *   device bound to the vfio_ap driver with the APQN identified by 
>> @apid and
>> - *   @apqi
>> - *
>> - * - If only @apid is not NULL, then there must be an AP queue device 
>> bound
>> - *   to the vfio_ap driver with an APQN containing @apid
>> - *
>> - * - If only @apqi is not NULL, then there must be an AP queue device 
>> bound
>> - *   to the vfio_ap driver with an APQN containing @apqi
>> - *
>> - * Returns 0 if the AP queue is reserved; otherwise, returns 
>> -EADDRNOTAVAIL.
>> - */
>> -static int vfio_ap_verify_queue_reserved(unsigned long *apid,
>> -                     unsigned long *apqi)
>> -{
>> -    int ret;
>> -    struct vfio_ap_queue_reserved qres;
>> -
>> -    qres.apid = apid;
>> -    qres.apqi = apqi;
>> -    qres.reserved = false;
>> -
>> -    ret = driver_for_each_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>> -                     &qres, vfio_ap_has_queue);
>> -    if (ret)
>> -        return ret;
>> -
>> -    if (qres.reserved)
>> -        return 0;
>> -
>> -    return -EADDRNOTAVAIL;
>> -}
>> -
>> -static int
>> -vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev 
>> *matrix_mdev,
>> -                         unsigned long apid)
>> -{
>> -    int ret;
>> -    unsigned long apqi;
>> -    unsigned long nbits = matrix_mdev->matrix.aqm_max + 1;
>> -
>> -    if (find_first_bit_inv(matrix_mdev->matrix.aqm, nbits) >= nbits)
>> -        return vfio_ap_verify_queue_reserved(&apid, NULL);
>> -
>> -    for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, nbits) {
>> -        ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
>> -        if (ret)
>> -            return ret;
>> -    }
>> -
>> -    return 0;
>> -}
>> -
>>   /**
>>    * vfio_ap_mdev_verify_no_sharing
>>    *
>> @@ -236,18 +120,26 @@ 
>> vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev 
>> *matrix_mdev,
>>    * and AP queue indexes comprising the AP matrix are not configured 
>> for another
>>    * mediated device. AP queue sharing is not allowed.
>>    *
>> - * @matrix_mdev: the mediated matrix device
>> + * @mdev_apm: the mask identifying the adapters assigned to mdev
>> + * @mdev_apm: the mask identifying the adapters assigned to mdev
>>    *
>>    * Returns 0 if the APQNs are not shared, otherwise; returns 
>> -EADDRINUSE.
>>    */
>> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev 
>> *matrix_mdev)
>> +static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
>> +                      unsigned long *mdev_aqm)
>>   {
>>       struct ap_matrix_mdev *lstdev;
>>       DECLARE_BITMAP(apm, AP_DEVICES);
>>       DECLARE_BITMAP(aqm, AP_DOMAINS);
>>       list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
>> -        if (matrix_mdev == lstdev)
>> +        /*
>> +         * If either of the input masks belongs to the mdev to which an
>> +         * AP resource is being assigned, then we don't need to verify
>> +         * that mdev's masks.
>> +         */
>> +        if ((mdev_apm == lstdev->matrix.apm) ||
>> +            (mdev_aqm == lstdev->matrix.aqm))
>>               continue;
> 
> Is it possible that mdev_apm and mdev_aqm do not belong to the same 
> mediated device?

The mdev_apm and the mdev_aqm will not both belong to the same mdev
device. Either the mdev_apm OR the mdev_aqm will belong to the mdev
device to which the adapter or domain is being assigned.

When an adapter is assigned, the mdev_apm is allocated in the
assign_adapter_store function setting only the bit corresponding to
the APID of the adapter being assigned. The mdev_aqm address is the
address of the matrix_mdev->matrix.aqm.

When a domain is assigned, the mdev_aqm is allocated in the
assign_adapter_store function setting only the bit corresponding to
the APQI of the domain being assigned. The mdev_apm address is the
address of the matrix_mdev->matrix.apm.

> 
> ...snip...
> 
> 

