Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B022F6D4F
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbhANVfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:35:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726729AbhANVfu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 16:35:50 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10ELWLH8106930;
        Thu, 14 Jan 2021 16:35:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0xlsKXjwk99squno4VH+VrcvLyBZOH7ZSXcQj3fBfVQ=;
 b=qPAWHLaRP9VsKzjxf4lc5f6w/h+SH+E5XpFRRxrw9oQVfM2y2jsNDta87rlcmk2fxno2
 PaQujZhrNYGOiMDwRIjxHX/+G8bFaGEaoKqkxM7o02dWhrRjK24NqxJGNFAP/qlqVyWk
 EDu7Yjo1HjptUoNYHuuijgdVsBQeVoT1q+j7Y9Jso/of+nfl3AZovpMBW66/+oZ2GzKM
 S7X/ouMq7RuT0BvCaE2qvOGwdvEdx0h/pHoofMj2shJGEz0CEnOWU0sS2z+FPNI02xfz
 /B281dT83fzQDsFHKhVKEoBRavu6R1Hoi0QH5iqT+Gio7H/1Kqi9mBPvJOWh8K7rpIKW 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 362wp20g9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 16:35:07 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10ELX1wF112505;
        Thu, 14 Jan 2021 16:35:07 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 362wp20g97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 16:35:07 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10ELXRxW014586;
        Thu, 14 Jan 2021 21:35:06 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04wdc.us.ibm.com with ESMTP id 35y449g4y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 21:35:06 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10ELZ3Zp15663442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 21:35:03 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1A9D13605D;
        Thu, 14 Jan 2021 21:35:03 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 090B713604F;
        Thu, 14 Jan 2021 21:35:01 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 21:35:01 +0000 (GMT)
Subject: Re: [PATCH v13 07/15] s390/vfio-ap: introduce shadow APCB
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
 <20201223011606.5265-8-akrowiak@linux.ibm.com>
 <20210111235058.32ed94b5.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <47a353f5-e34f-db7b-65da-6fcf405959d5@linux.ibm.com>
Date:   Thu, 14 Jan 2021 16:35:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210111235058.32ed94b5.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_08:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/21 5:50 PM, Halil Pasic wrote:
> On Tue, 22 Dec 2020 20:15:58 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The APCB is a field within the CRYCB that provides the AP configuration
>> to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
>> maintain it for the lifespan of the guest.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c     | 15 +++++++++++++++
>>   drivers/s390/crypto/vfio_ap_private.h |  2 ++
>>   2 files changed, 17 insertions(+)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 2d58b39977be..44b3a81cadfb 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -293,6 +293,20 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
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
>> +	if (vfio_ap_mdev_has_crycb(matrix_mdev))
>> +		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
>> +					  matrix_mdev->shadow_apcb.apm,
>> +					  matrix_mdev->shadow_apcb.aqm,
>> +					  matrix_mdev->shadow_apcb.adm);
>> +}
>> +
>>   static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>   {
>>   	struct ap_matrix_mdev *matrix_mdev;
>> @@ -308,6 +322,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>   
>>   	matrix_mdev->mdev = mdev;
>>   	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
>> +	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
>>   	hash_init(matrix_mdev->qtable);
>>   	mdev_set_drvdata(mdev, matrix_mdev);
>>   	matrix_mdev->pqap_hook.hook = handle_pqap;
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index 4e5cc72fc0db..d2d26ba18602 100644
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
> What happened to the following hunk from v12?

That's a very good question, I'll reinstate it.

>
> @@ -1218,13 +1233,9 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>   	if (ret)
>   		return NOTIFY_DONE;
>   
> -	/* If there is no CRYCB pointer, then we can't copy the masks */
> -	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> -		return NOTIFY_DONE;
> -
> -	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
> -				  matrix_mdev->matrix.aqm,
> -				  matrix_mdev->matrix.adm);
> +	memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
> +	       sizeof(matrix_mdev->shadow_apcb));
> +	vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>   
>   	return NOTIFY_OK;
>   }

