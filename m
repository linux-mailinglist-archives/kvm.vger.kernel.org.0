Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1253E1B31FE
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 23:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgDUVjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 17:39:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2088 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726055AbgDUVjy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 17:39:54 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LLWfiV111746;
        Tue, 21 Apr 2020 17:39:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gj244hpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 17:39:52 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03LLX6D9113710;
        Tue, 21 Apr 2020 17:39:52 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gj244hnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 17:39:52 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03LLUo6d017009;
        Tue, 21 Apr 2020 21:39:51 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 30fs66uk68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 21:39:51 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03LLdlVv62521814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 21:39:47 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C845B6E058;
        Tue, 21 Apr 2020 21:39:47 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 476306E054;
        Tue, 21 Apr 2020 21:39:46 +0000 (GMT)
Received: from cpe-172-100-170-99.stny.res.rr.com (unknown [9.85.174.54])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Apr 2020 21:39:46 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH v7 05/15] s390/vfio-ap: introduce shadow CRYCB
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-6-akrowiak@linux.ibm.com>
 <20200416135815.0ec6e0b3.cohuck@redhat.com>
Message-ID: <d8df1a4d-5b6a-bb62-558f-1609b5f767df@linux.ibm.com>
Date:   Tue, 21 Apr 2020 17:39:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200416135815.0ec6e0b3.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_09:2020-04-21,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 mlxscore=0 suspectscore=3 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/16/20 7:58 AM, Cornelia Huck wrote:
> On Tue,  7 Apr 2020 15:20:05 -0400
> Tony Krowiak<akrowiak@linux.ibm.com>  wrote:
>
>> Let's introduce a shadow copy of the KVM guest's CRYCB and maintain it for
>> the lifespan of the guest. The shadow CRYCB will be used to provide the
>> AP configuration for a KVM guest.
> 'shadow CRYCB' seems to be a bit of a misnomer, as the real CRYCB has a
> different format (for starters, it also contains key wrapping stuff).
> It seems to be more of a 'shadow matrix'.

You make a valid point; however in reality, matrix - as it is used
throughout vfio ap - is a misnomer. The
matrix is actually comprised of the assigned APIDs and APQIs
(i.e., APQNs) and does not include the control domain assignments.
In reality, the APM, AQM and ADM are fields within the AP control
block (APCB) which is embedded within the CRYCB, so a more
accurate name might be 'shadow_apcb'. I think I'll go with that.

>> Signed-off-by: Tony Krowiak<akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c     | 31 +++++++++++++++++++++------
>>   drivers/s390/crypto/vfio_ap_private.h |  1 +
>>   2 files changed, 25 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 8ece0d52ff4c..b8b678032ab7 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -280,14 +280,32 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>>   	return 0;
>>   }
>>   
>> +static void vfio_ap_matrix_clear(struct ap_matrix *matrix)
> vfio_ap_matrix_clear_masks()?

Sure, that works.

>
>> +{
>> +	bitmap_clear(matrix->apm, 0, AP_DEVICES);
>> +	bitmap_clear(matrix->aqm, 0, AP_DOMAINS);
>> +	bitmap_clear(matrix->adm, 0, AP_DOMAINS);
>> +}
>> +
>>   static void vfio_ap_matrix_init(struct ap_config_info *info,
>>   				struct ap_matrix *matrix)
>>   {
>> +	vfio_ap_matrix_clear(matrix);
>>   	matrix->apm_max = info->apxa ? info->Na : 63;
>>   	matrix->aqm_max = info->apxa ? info->Nd : 15;
>>   	matrix->adm_max = info->apxa ? info->Nd : 15;
>>   }
>>   
>> +static bool vfio_ap_mdev_commit_crycb(struct ap_matrix_mdev *matrix_mdev)
> vfio_ap_mdev_commit_masks()?

Since I am changing the name of shadow_crycb to shadow_apcb,
it probably makes more sense to rename this to
vfio_ap_mdev_commit_apcb().

>
> And it does not seem to return anything? (Maybe it should, to be
> consumed below?)

In patch 7, the check at the beginning of this function (for a CRYCB)
is moved into the vfio_ap_mdev_has_crycb() function, so there is
no need to return anything from this function. I will introduce the
vfio_ap_mdev_has_crycb() function in this patch instead for the
next submission.

>
>> +{
>> +	if (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd) {
>> +		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
>> +					  matrix_mdev->shadow_crycb.apm,
>> +					  matrix_mdev->shadow_crycb.aqm,
>> +					  matrix_mdev->shadow_crycb.adm);
>> +	}
>> +}
>> +
>>   static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>   {
>>   	struct ap_matrix_mdev *matrix_mdev;
>> @@ -303,6 +321,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>   
>>   	matrix_mdev->mdev = mdev;
>>   	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
>> +	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_crycb);
>>   	mdev_set_drvdata(mdev, matrix_mdev);
>>   	matrix_mdev->pqap_hook.hook = handle_pqap;
>>   	matrix_mdev->pqap_hook.owner = THIS_MODULE;
>> @@ -1126,13 +1145,9 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   	if (ret)
>>   		return NOTIFY_DONE;
>>   
>> -	/* If there is no CRYCB pointer, then we can't copy the masks */
>> -	if (!matrix_mdev->kvm->arch.crypto.crycbd)
>> -		return NOTIFY_DONE;
>> -
>> -	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
>> -				  matrix_mdev->matrix.aqm,
>> -				  matrix_mdev->matrix.adm);
>> +	memcpy(&matrix_mdev->shadow_crycb, &matrix_mdev->matrix,
>> +	       sizeof(matrix_mdev->shadow_crycb));
>> +	vfio_ap_mdev_commit_crycb(matrix_mdev);
> You are changing the return code for !crycb; maybe that's where a good
> return code for vfio_ap_mdev_commit_crycb() would come in handy :)

See my comments above regarding moving the introduction of the
vfio_ap_mdev_has_crycb() function from patch 7 to this patch.
In that case, that function will be called here before committing.

>
>>   
>>   	return NOTIFY_OK;
>>   }
>> @@ -1247,6 +1262,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>>   		kvm_put_kvm(matrix_mdev->kvm);
>>   		matrix_mdev->kvm = NULL;
>>   	}
>> +
>> +	vfio_ap_matrix_clear(&matrix_mdev->shadow_crycb);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index 4b6e144bab17..87cc270c3212 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -83,6 +83,7 @@ struct ap_matrix {
>>   struct ap_matrix_mdev {
>>   	struct list_head node;
>>   	struct ap_matrix matrix;
>> +	struct ap_matrix shadow_crycb;
> I think shadow_matrix would be a better name.

Changing to shadow_apcb as per comments above.

>
>>   	struct notifier_block group_notifier;
>>   	struct notifier_block iommu_notifier;
>>   	struct kvm *kvm;

