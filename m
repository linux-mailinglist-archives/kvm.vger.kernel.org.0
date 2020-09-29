Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305EE27D34B
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 18:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgI2QEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 12:04:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbgI2QEd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 12:04:33 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TG2svp006456;
        Tue, 29 Sep 2020 12:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6fLKTysLJENbTzAVUq0nW7CiJImspYmnTpa+4cZTowE=;
 b=oG0/JBDybegyCR3XnKdnNQI/aXaZ3CpEkjM003/eyAfWA0sfPB+m3HUdlvMMHa7BNsJf
 vnI8uNFK27jPWHFo+Evaw04PA5e7cgkoz0BxhakBAjnjq7K5CEErpZPlGXvf4NbnVYue
 tzPFUWrNA3+xtWbLRPe7UG9Zqnq1nCtyip3EQZZU49L8pTJhi/7d09JhIaB2kz1IuTod
 7wd2GfviuUTM8UNCxXZl4nas5hmwIaaXglwPpgcQ+IwLzYljb1IFwuGIaxFyZ7nLoDy0
 C4MzbDFCimdAVfpLDuXm7wHBE8ZIl0cmyxJ1ZFPAspOOZpxOMEcPzxQqT839q3/OtY5J kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v7n9969f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 12:04:32 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08TG3TgW009239;
        Tue, 29 Sep 2020 12:04:31 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v7n9968x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 12:04:31 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TFl9GD025031;
        Tue, 29 Sep 2020 16:04:30 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 33sw99cx7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 16:04:30 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TG4RQq61997424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 16:04:27 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7296E136066;
        Tue, 29 Sep 2020 16:04:27 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB869136059;
        Tue, 29 Sep 2020 16:04:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.170.177])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 16:04:25 +0000 (GMT)
Subject: Re: [PATCH v10 06/16] s390/vfio-ap: introduce shadow APCB
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-7-akrowiak@linux.ibm.com>
 <20200926033808.07e9d04f.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <5cca8962-4f08-9c92-032c-9b6d1b514e33@linux.ibm.com>
Date:   Tue, 29 Sep 2020 12:04:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200926033808.07e9d04f.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_07:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/25/20 9:38 PM, Halil Pasic wrote:
> On Fri, 21 Aug 2020 15:56:06 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The APCB is a field within the CRYCB that provides the AP configuration
>> to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
>> maintain it for the lifespan of the guest.
>>
> AFAIU this is supposed to be a no change in behavior patch that lays the
> groundwork.

I suppose this is in the eyes of the beholder because this patch does
lay the groundwork for the APQN filtering and hot plug/unplug support
introduced in subsequent patches. Maybe it will be more in line with your
expectations after I make the changes I agreed to below.

>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c     | 32 ++++++++++++++++++++++-----
>>   drivers/s390/crypto/vfio_ap_private.h |  2 ++
>>   2 files changed, 29 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index fc1aa6f947eb..efb229033f9e 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -305,14 +305,35 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>>   	return 0;
>>   }
>>   
>> +static void vfio_ap_matrix_clear_masks(struct ap_matrix *matrix)
>> +{
>> +	bitmap_clear(matrix->apm, 0, AP_DEVICES);
>> +	bitmap_clear(matrix->aqm, 0, AP_DOMAINS);
>> +	bitmap_clear(matrix->adm, 0, AP_DOMAINS);
>> +}
>> +
>>   static void vfio_ap_matrix_init(struct ap_config_info *info,
>>   				struct ap_matrix *matrix)
>>   {
>> +	vfio_ap_matrix_clear_masks(matrix);
> I don't quite understand the idea behind this. The only place
> vfio_ap_matrix_init() is used, is in create right after the whole
> matrix_mdev got allocated with kzalloc.

You are correct, this does not belong here. I am going to remove
the vfio_ap_matrix_clear_masks function because that is not needed
until the filtering patch.

>
>>   	matrix->apm_max = info->apxa ? info->Na : 63;
>>   	matrix->aqm_max = info->apxa ? info->Nd : 15;
>>   	matrix->adm_max = info->apxa ? info->Nd : 15;
>>   }
>>   
>> +static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
>> +}
>> +
>> +static void vfio_ap_mdev_commit_crycb(struct ap_matrix_mdev *matrix_mdev)
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
>> @@ -1202,13 +1223,12 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
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
> A note on the thread safety of the access to matrix_mdev->matrix. I
> guess the idea is, that this is still safe because we did
> vfio_ap_mdev_set_kvm() and that is supposed to inhibit changes the
> matrix.
>
> There are two things that bother me with this:
> 1) the assign operations don't check matrix_mdev->kvm under the lock
> 2) with dynamic, this is supposed to change (So I have to be careful
> about it when reviewing the following patches. A sneak-peek at the end
> result makes me worried).

As you will see in the subsequent patches,
all operations performed within the context of the
assign/unassign interfaces are executed under the
matrix_dev->lock. This locks access to every
matrix_mdev. When an adapter, domain or control
domain are assigned, matrix_mdev-> kvm is
checked prior to assigning anything to the guest's APCB.
This occurs in between the lock/unlock of
matrix_dev->lock.

>
>> +	vfio_ap_mdev_commit_crycb(matrix_mdev);
>>   
>>   	return NOTIFY_OK;
>>   }
>> @@ -1323,6 +1343,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>>   		kvm_put_kvm(matrix_mdev->kvm);
>>   		matrix_mdev->kvm = NULL;
>>   	}
>> +
>> +	vfio_ap_matrix_clear_masks(&matrix_mdev->shadow_apcb);
> What is the idea behind this? From the above, it looks like we are going
> to overwrite matrix_mdev->shadow_apcb with matrix_mdev->matrix before
> the next commit anyway.

The clearing of the masks in the shadow_apcb is premature
and doesn't belong in this patch. There is no reason to clear
these masks at this point, so I will remove this and the
vfio_ap_matrix_clear_masks function too.

>
> I suppose this is probably about no guest unolies no resources passed
> through at the moment. If that is the case maybe we can document it
> below.

I'm not quite sure what you are saying here or what I should be
documenting below.

>   
>
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index 0c796ef11426..055bce6d45db 100644
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

