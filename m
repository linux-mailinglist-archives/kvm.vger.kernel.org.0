Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18C32B21E2
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 18:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKMRSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 12:18:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726057AbgKMRR6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 12:17:58 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADH0jih057941;
        Fri, 13 Nov 2020 12:18:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C8or84N4MPEUYqAl/Wp0oMglM7HkDK6irhblA0wCnKQ=;
 b=SGZWfwbvu8LkUQ870h6QQscjpDV62yhCsvvhO56bFj/2hEY9NLkaKc7iOf84LZYW4Qh7
 WtSKWLuOpFBFWH4vA0B8qzWu3LTuVESZtLveP8Zt1nyNZtrVjtuNUdTK1qsmm54ZZ6kU
 DRm7hEKwpoAeSHyvdEexr77WL70BrsQrBpfBmLzsBLKFBro3Df4Cf18aPiTTAaUSU3BF
 W9otGflr38iJwCk2JenEV1aOaFj+ajfTJBbkJfaG9B/0F4+59F4w3ksM7GLeOsnLE9M2
 FS2u81/3g0VA/j7xfFCWFQ469CHDF+4K83jTx9FCMYW5ki+wkUO/wAxN4Uw9qjE0GCDv wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34sx480jr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 12:18:09 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ADH0vlH058884;
        Fri, 13 Nov 2020 12:18:08 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34sx480jqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 12:18:08 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADHCpke026141;
        Fri, 13 Nov 2020 17:18:08 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 34nk79v8rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 17:18:08 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ADHI4lM59638092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 17:18:05 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0F2D6A047;
        Fri, 13 Nov 2020 17:18:04 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7108C6A05A;
        Fri, 13 Nov 2020 17:18:03 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.152.80])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 13 Nov 2020 17:18:03 +0000 (GMT)
Subject: Re: [PATCH v11 06/14] s390/vfio-ap: introduce shadow APCB
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-7-akrowiak@linux.ibm.com>
 <20201028091121.0db418cf.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <a4d0be28-3f92-0bc4-c461-c8f6151f7b66@linux.ibm.com>
Date:   Fri, 13 Nov 2020 12:18:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201028091121.0db418cf.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=3 adultscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/28/20 4:11 AM, Halil Pasic wrote:
> On Thu, 22 Oct 2020 13:12:01 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The APCB is a field within the CRYCB that provides the AP configuration
>> to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
>> maintain it for the lifespan of the guest.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c     | 24 +++++++++++++++++++-----
>>   drivers/s390/crypto/vfio_ap_private.h |  2 ++
>>   2 files changed, 21 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 9e9fad560859..9791761aa7fd 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -320,6 +320,19 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>>   	matrix->adm_max = info->apxa ? info->Nd : 15;
>>   }
>>   
>> +static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
>> +}
>> +
>> +static void vfio_ap_mdev_commit_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	kvm_arch_crypto_set_masks(matrix_mdev->kvm,
>> +				  matrix_mdev->shadow_apcb.apm,
>> +				  matrix_mdev->shadow_apcb.aqm,
>> +				  matrix_mdev->shadow_apcb.adm);
>> +}
>> +
>>   static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>   {
>>   	struct ap_matrix_mdev *matrix_mdev;
>> @@ -335,6 +348,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>   
>>   	matrix_mdev->mdev = mdev;
>>   	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
>> +	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
>>   	hash_init(matrix_mdev->qtable);
>>   	mdev_set_drvdata(mdev, matrix_mdev);
>>   	matrix_mdev->pqap_hook.hook = handle_pqap;
>> @@ -1213,13 +1227,12 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   	if (ret)
>>   		return NOTIFY_DONE;
>>   
>> -	/* If there is no CRYCB pointer, then we can't copy the masks */
>> -	if (!matrix_mdev->kvm->arch.crypto.crycbd)
>> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>>   		return NOTIFY_DONE;
>>   
>> -	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
>> -				  matrix_mdev->matrix.aqm,
>> -				  matrix_mdev->matrix.adm);
>> +	memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
>> +	       sizeof(matrix_mdev->shadow_apcb));
>> +	vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>>   
>>   	return NOTIFY_OK;
>>   }
>> @@ -1329,6 +1342,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>>   		kvm_put_kvm(matrix_mdev->kvm);
>>   		matrix_mdev->kvm = NULL;
>>   	}
>> +
> Unrelated change.
>
> Otherwise patch looks OK.
>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

I'll fix it. Thanks for your review.

>
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index c1d8b5507610..fc8634cee485 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -75,6 +75,7 @@ struct ap_matrix {
>>    * @list:	allows the ap_matrix_mdev struct to be added to a list
>>    * @matrix:	the adapters, usage domains and control domains assigned to the
>>    *		mediated matrix device.
>> + * @shadow_apcb:    the shadow copy of the APCB field of the KVM guest's CRYCB
>>    * @group_notifier: notifier block used for specifying callback function for
>>    *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
>>    * @kvm:	the struct holding guest's state
>> @@ -82,6 +83,7 @@ struct ap_matrix {
>>   struct ap_matrix_mdev {
>>   	struct list_head node;
>>   	struct ap_matrix matrix;
>> +	struct ap_matrix shadow_apcb;
>>   	struct notifier_block group_notifier;
>>   	struct notifier_block iommu_notifier;
>>   	struct kvm *kvm;

