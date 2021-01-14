Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE3C2F686D
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 18:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbhANRz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 12:55:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43838 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727460AbhANRz2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 12:55:28 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EHZ3HH117738;
        Thu, 14 Jan 2021 12:54:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jbcUYmCgeuoNEf9mWlBLmm1p67fofIwRkvcLlLAvtYo=;
 b=eTvkLL3GGfOUYuLIB1mHXnUFhhxLwzackVyuknu6teBs00tYnnwCFqVNOOq5jeZuasnC
 zvZ58ZH30pn5YfPm1pkeyWo9dEVyWu/uHJ6+xbMndERvh9/slKLZIzjAivEXYlS6cW3y
 hF88W2RjJAxExnyTNzhZ+v2opJgCw1k9Q3zdA5ufKZrpAy2PhYsDxrYeuBM/l/9NdkQt
 RdRRmmTXAUVb8UyKyFaDq0BeuuUrTLKX6S6drRDo7tdfwcspIliXtfbWiced2x+7aXnW
 z9anFIWSrUErVA39082HEpSA4xxZe6V80RH350tgOl71eBy/xnofEzDM0HtY6mhxY2p+ JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362tamrsyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 12:54:47 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EHnm0r187408;
        Thu, 14 Jan 2021 12:54:46 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362tamrsyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 12:54:46 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EHqCKN032186;
        Thu, 14 Jan 2021 17:54:45 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 35y449rk2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 17:54:45 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EHsgQT26083692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 17:54:42 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AA88136051;
        Thu, 14 Jan 2021 17:54:42 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1C99136053;
        Thu, 14 Jan 2021 17:54:40 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 17:54:40 +0000 (GMT)
Subject: Re: [PATCH v13 06/15] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
 <20201223011606.5265-7-akrowiak@linux.ibm.com>
 <20210111214037.477f0f03.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <270e192b-b88d-b072-428c-6cbfc0f9a280@linux.ibm.com>
Date:   Thu, 14 Jan 2021 12:54:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210111214037.477f0f03.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_06:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/21 3:40 PM, Halil Pasic wrote:
> On Tue, 22 Dec 2020 20:15:57 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The current implementation does not allow assignment of an AP adapter or
>> domain to an mdev device if each APQN resulting from the assignment
>> does not reference an AP queue device that is bound to the vfio_ap device
>> driver. This patch allows assignment of AP resources to the matrix mdev as
>> long as the APQNs resulting from the assignment:
>>     1. Are not reserved by the AP BUS for use by the zcrypt device drivers.
>>     2. Are not assigned to another matrix mdev.
>>
>> The rationale behind this is twofold:
>>     1. The AP architecture does not preclude assignment of APQNs to an AP
>>        configuration that are not available to the system.
>>     2. APQNs that do not reference a queue device bound to the vfio_ap
>>        device driver will not be assigned to the guest's CRYCB, so the
>>        guest will not get access to queues not bound to the vfio_ap driver.
> You didn't tell us about the changed error code.

I am assuming you are talking about returning -EBUSY from
the vfio_ap_mdev_verify_no_sharing() function instead of
-EADDRINUSE. I'm going to change this back per your comments
below.

>
> Also notice that this point we don't have neither filtering nor in-use.
> This used to be patch 11, and most of that stuff used to be in place. But
> I'm going to trust you, if you say its fine to enable it this early.

The patch order was changed due to your review comments in
in Message ID <20201126165431.6ef1457a.pasic@linux.ibm.com>,
patch 07/17 in the v12 series. In order to ensure that only queues
bound to the vfio_ap driver are given to the guest, I'm going to
create a patch that will preceded this one which introduces the
filtering code currently introduced in the patch 12/17, the hot
plug patch.

>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 241 ++++++++----------------------
>>   1 file changed, 62 insertions(+), 179 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index cdcc6378b4a5..2d58b39977be 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -379,134 +379,37 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
>>   	NULL,
>>   };
>>   
>> -struct vfio_ap_queue_reserved {
>> -	unsigned long *apid;
>> -	unsigned long *apqi;
>> -	bool reserved;
>> -};
>> +#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
>> +			 "already assigned to %s"
>>   
>> -/**
>> - * vfio_ap_has_queue
>> - *
>> - * @dev: an AP queue device
>> - * @data: a struct vfio_ap_queue_reserved reference
>> - *
>> - * Flags whether the AP queue device (@dev) has a queue ID containing the APQN,
>> - * apid or apqi specified in @data:
>> - *
>> - * - If @data contains both an apid and apqi value, then @data will be flagged
>> - *   as reserved if the APID and APQI fields for the AP queue device matches
>> - *
>> - * - If @data contains only an apid value, @data will be flagged as
>> - *   reserved if the APID field in the AP queue device matches
>> - *
>> - * - If @data contains only an apqi value, @data will be flagged as
>> - *   reserved if the APQI field in the AP queue device matches
>> - *
>> - * Returns 0 to indicate the input to function succeeded. Returns -EINVAL if
>> - * @data does not contain either an apid or apqi.
>> - */
>> -static int vfio_ap_has_queue(struct device *dev, void *data)
>> +static void vfio_ap_mdev_log_sharing_err(const char *mdev_name,
>> +					 unsigned long *apm,
>> +					 unsigned long *aqm)
> [..]
>> -	return 0;
>> +	for_each_set_bit_inv(apid, apm, AP_DEVICES)
>> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
>> +			pr_warn(MDEV_SHARING_ERR, apid, apqi, mdev_name);
> I would prefer dev_warn() here. We know which device is about to get
> more queues, and this device can provide a clue regarding the initiator.

Will do.

>
> Also I believe a warning is too heavy handed here. Warnings should not
> be ignored. This is a condition that can emerge during normal operation,
> AFAIU. Or am I worng?

It can happen during normal operation, but we had this discussion
in the previous review. Both Connie and I felt it should be a warning
since this message is the only way for a user to identify the queues
in use. A message of lower severity may not get logged depriving the
user from easily determining why an adapter or domain could not
be assigned.

>
>>   }
>>   
>>   /**
>>    * vfio_ap_mdev_verify_no_sharing
>>    *
>> - * Verifies that the APQNs derived from the cross product of the AP adapter IDs
>> - * and AP queue indexes comprising the AP matrix are not configured for another
>> - * mediated device. AP queue sharing is not allowed.
>> + * Verifies that each APQN derived from the Cartesian product of the AP adapter
>> + * IDs and AP queue indexes comprising the AP matrix are not configured for
>> + * another mediated device. AP queue sharing is not allowed.
>>    *
>> - * @matrix_mdev: the mediated matrix device
>> + * @matrix_mdev: the mediated matrix device to which the APQNs being verified
>> + *		 are assigned.
>> + * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
>> + * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
>>    *
>> - * Returns 0 if the APQNs are not shared, otherwise; returns -EADDRINUSE.
>> + * Returns 0 if the APQNs are not shared, otherwise; returns -EBUSY.
>>    */
>> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>> +static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
>> +					  unsigned long *mdev_apm,
>> +					  unsigned long *mdev_aqm)
>>   {
>>   	struct ap_matrix_mdev *lstdev;
>>   	DECLARE_BITMAP(apm, AP_DEVICES);
>> @@ -523,20 +426,31 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>>   		 * We work on full longs, as we can only exclude the leftover
>>   		 * bits in non-inverse order. The leftover is all zeros.
>>   		 */
>> -		if (!bitmap_and(apm, matrix_mdev->matrix.apm,
>> -				lstdev->matrix.apm, AP_DEVICES))
>> +		if (!bitmap_and(apm, mdev_apm, lstdev->matrix.apm, AP_DEVICES))
>>   			continue;
>>   
>> -		if (!bitmap_and(aqm, matrix_mdev->matrix.aqm,
>> -				lstdev->matrix.aqm, AP_DOMAINS))
>> +		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
>>   			continue;
>>   
>> -		return -EADDRINUSE;
>> +		vfio_ap_mdev_log_sharing_err(dev_name(mdev_dev(lstdev->mdev)),
>> +					     apm, aqm);
>> +
>> +		return -EBUSY;
> Why do we change -EADDRINUSE to -EBUSY? This gets bubbled up to
> userspace, or? So a tool that checks for the other mdev has it
> condition by checking for -EADDRINUSE, would be confused...

Back in v8 of the series, Christian suggested the occurrences
of -EADDRINUSE should be replaced by the more appropriate
-EBUSY (Message ID <d7954c15-b14f-d6e5-0193-aadca61883a8@de.ibm.com>),
so I changed it here. It does get bubbled up to userspace, so you make a 
valid point. I will
change it back. I will, however, set the value returned from the
__verify_card_reservations() function in ap_bus.c to -EBUSY as
suggested by Christian.

>
>>   	}
>>   
>>   	return 0;
>>   }
>>   
>> +static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev,
>> +				       unsigned long *mdev_apm,
>> +				       unsigned long *mdev_aqm)
>> +{
>> +	if (ap_apqn_in_matrix_owned_by_def_drv(mdev_apm, mdev_aqm))
>> +		return -EADDRNOTAVAIL;
>> +
>> +	return vfio_ap_mdev_verify_no_sharing(matrix_mdev, mdev_apm, mdev_aqm);
>> +}
>> +
>>   static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
>>   				    struct vfio_ap_queue *q)
>>   {
>> @@ -608,10 +522,10 @@ static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
>>    *	   driver; or, if no APQIs have yet been assigned, the APID is not
>>    *	   contained in an APQN bound to the vfio_ap device driver.
>>    *
>> - *	4. -EADDRINUSE
>> + *	4. -EBUSY
>>    *	   An APQN derived from the cross product of the APID being assigned
>>    *	   and the APQIs previously assigned is being used by another mediated
>> - *	   matrix device
>> + *	   matrix device or the mdev lock could not be acquired.
> This is premature. We don't use try_lock yet.

Yes it is, the comment describing the -EBUSY return code will
be moved to patch 11/15 where it is the try_lock is introduced.

>
> [..]
>
>>   static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
>>   				     unsigned long apqi)
>>   {
>> @@ -774,10 +660,10 @@ static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
>>    *	   driver; or, if no APIDs have yet been assigned, the APQI is not
>>    *	   contained in an APQN bound to the vfio_ap device driver.
>>    *
>> - *	4. -EADDRINUSE
>> + *	4. -BUSY
>>    *	   An APQN derived from the cross product of the APQI being assigned
>>    *	   and the APIDs previously assigned is being used by another mediated
>> - *	   matrix device
>> + *	   matrix device or the mdev lock could not be acquired.
> Same here as above.
>
> Otherwise looks good.
>
> [..]

