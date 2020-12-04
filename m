Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A742CEFF5
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 15:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388133AbgLDOoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 09:44:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730305AbgLDOoo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 09:44:44 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4EcdUd072217;
        Fri, 4 Dec 2020 09:44:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=W6A48oeKkW1/exMBFLB4Ks4aBQ/6lU6DCngSIYTfzFA=;
 b=amwllr+PzdkHNyZmvpML95rbFUhcF1Jo14+R9Quo6hB4rmxdE226s3dLKaweJS+fRU+c
 GMi8m7k1ZkGggkzxy9CDJFYU86uVvnybYLlVYx5Elr3qA5dcqz3jdPDGaC83GHhJXxzb
 ATVmHUOLleymEnc2+rEcWjLq+fXsa8px4jufmPzzlSQOOgcGBsvnXlw6xoEQfDwr9Q1s
 LV7AEm19ITiZ0I2CwTV80v8PdO771o7JgVU0jVbAAK8sH0GS1YJITrWXhlBp+XxKN3+p
 8vTpCG7Z3CBUOIeO0dNOM0Q5Et7gkofltwAksKAn/Yu2ZCgKkTniSSowOAfBqz5GPvG4 pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357ps78h76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 09:44:03 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B4Ecjqe072942;
        Fri, 4 Dec 2020 09:44:02 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357ps78h6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 09:44:02 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4EhaER026535;
        Fri, 4 Dec 2020 14:44:01 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3569xuxc44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 14:44:01 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4Ei0Zp1376794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 14:44:00 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8D32B2064;
        Fri,  4 Dec 2020 14:44:00 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E93AB205F;
        Fri,  4 Dec 2020 14:44:00 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.195.249])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  4 Dec 2020 14:44:00 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM pointer
 invalidated
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
 <20201203185514.54060568.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <a8a90aed-97df-6f10-85c2-8e18dba8f085@linux.ibm.com>
Date:   Fri, 4 Dec 2020 09:43:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201203185514.54060568.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_05:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/3/20 12:55 PM, Halil Pasic wrote:
> On Wed,  2 Dec 2020 18:41:01 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The vfio_ap device driver registers a group notifier with VFIO when the
>> file descriptor for a VFIO mediated device for a KVM guest is opened to
>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
>> event). When the KVM pointer is set, the vfio_ap driver stashes the pointer
>> and calls the kvm_get_kvm() function to increment its reference counter.
>> When the notifier is called to make notification that the KVM pointer has
>> been set to NULL, the driver should clean up any resources associated with
>> the KVM pointer and decrement its reference counter. The current
>> implementation does not take care of this clean up.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Do we need a Fixes tag? Do we need this backported? In my opinion
> this is necessary since the interrupt patches.
>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 21 +++++++++++++--------
>>   1 file changed, 13 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index e0bde8518745..eeb9c9130756 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1083,6 +1083,17 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>>   	return NOTIFY_DONE;
>>   }
>>   
>> +static void vfio_ap_mdev_put_kvm(struct ap_matrix_mdev *matrix_mdev)
> I don't like the name. The function does more that put_kvm. Maybe
> something  like _disconnect_kvm()?
>
>> +{
>> +	if (matrix_mdev->kvm) {
>> +		(matrix_mdev->kvm);
>> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> Is a plain assignment to arch.crypto.pqap_hook apropriate, or do we need
> to take more care?
>
> For instance kvm_arch_crypto_set_masks() takes kvm->lock before poking
> kvm->arch.crypto.crycb.

I do not think so. The CRYCB is used by KVM to provide crypto resources
to the guest so it makes sense to protect it from changes to it while 
passing
the AP devices through to the guest. The hook is used only when an AQIC
executed on the guest is intercepted by KVM. If the notifier
is being invoked to notify vfio_ap that KVM has been set to NULL, this means
the guest is gone in which case there will be no AP instructions to 
intercept.

>
>> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>> +		kvm_put_kvm(matrix_mdev->kvm);
>> +		matrix_mdev->kvm = NULL;
>> +	}
>> +}
>> +
>>   static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   				       unsigned long action, void *data)
>>   {
>> @@ -1095,7 +1106,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>>   
>>   	if (!data) {
>> -		matrix_mdev->kvm = NULL;
>> +		vfio_ap_mdev_put_kvm(matrix_mdev);
> The lock question was already raised.
>
> What are the exact circumstances under which this branch can be taken?

Under normal circumstances (i.e., the mdev fd is closed before the guest
terminates), this notifier is not be called because the release callback
(invoked when the mdev fd is closed) unregisters the notifier. This fix is
primarily to ensure that proper cleanup is done should the notifier get
called; for example, if userspace does not close the mdev fd before
shutting the guest down.

>
>>   		return NOTIFY_OK;
>>   	}
>>   
>> @@ -1222,13 +1233,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   
>>   	mutex_lock(&matrix_dev->lock);
>> -	if (matrix_mdev->kvm) {
>> -		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>> -		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>> -		vfio_ap_mdev_reset_queues(mdev);
>> -		kvm_put_kvm(matrix_mdev->kvm);
>> -		matrix_mdev->kvm = NULL;
>> -	}
>> +	vfio_ap_mdev_put_kvm(matrix_mdev);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,

