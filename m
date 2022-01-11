Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0FA48B936
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 22:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiAKVNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 16:13:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234600AbiAKVNc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 16:13:32 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BLB3B9014325;
        Tue, 11 Jan 2022 21:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+mMdwi/ElSdFTnLrT5wjC9bkaG34xvE3IR/RNY9GEhk=;
 b=UN9L9kbsebvLEXglUkJYlg2sp4mxCg5KwSaswmLH/vYRo5qwz2oWwK/dwjs6vEX8giv5
 POnnzZo3QNmN6ClWBgB4xfpYoJ1Ynh1QxYOrc0GcuKKt8xLfgnPQMmNwJy61ns71b8i0
 XV/QvjV+zR/LIQKk+2iF/xhF7Q9ioAaMGtVvG1+kBWr1ARtecHraegmi5z5fx7VauPPZ
 vnh+4C7sEl7J7PZmJ+fQfbTvUwG4MLIDAQTY89IYLtX7eF2aE7RsDgMFQjRLTuZCDr+g
 fTO+ben2bfmnmVMBQwXWRkOwMvIuPr4sEJ/boj4QRpOI4hMvWFNl4p8NqqVDArQOHef8 zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhb7ut6sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:13:28 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BLDS3q023346;
        Tue, 11 Jan 2022 21:13:28 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhb7ut6sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:13:27 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BLCMZm005723;
        Tue, 11 Jan 2022 21:13:27 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 3df28anqp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:13:27 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BLDQJo8716646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 21:13:26 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50F2828059;
        Tue, 11 Jan 2022 21:13:26 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DC122805A;
        Tue, 11 Jan 2022 21:13:25 +0000 (GMT)
Received: from [9.65.85.237] (unknown [9.65.85.237])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 21:13:24 +0000 (GMT)
Message-ID: <706ddc62-4be7-9af7-03ef-dd4095124618@linux.ibm.com>
Date:   Tue, 11 Jan 2022 16:13:24 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v17 01/15] s390/vfio-ap: Set pqap hook when vfio_ap module
 is loaded
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-2-akrowiak@linux.ibm.com>
 <20211227092154.69059cac.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20211227092154.69059cac.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ApI6kOC8I7Cmh3GulxmJPvvWFf3lsVJq
X-Proofpoint-GUID: 1OmIpJdtwc2RRFj8mdHb_FIX1OV74IKi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201110108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/27/21 03:21, Halil Pasic wrote:
> On Thu, 21 Oct 2021 11:23:18 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Rather than storing the function pointer to the PQAP(AQIC) instruction
>> interception handler with the mediated device (struct ap_matrix_mdev) when
>> the vfio_ap device driver is notified that the KVM point is being set,
>> let's store it once in a global variable when the vfio_ap module is
>> loaded.
> This is a global variable of the kvm module, right? I'm not sure this
> makes sense from a 'bigger picture' perspective!. Imagine a situation
> where we have two drivers doing some sort of a vfio-ap like thing. Only
> one of the drivers would be able to register the callback. I do
> understand that we are unlikely to see another driver that needs to
> register a pqap callback in the foreseeable future, but this till looks
> like a very questionable design. The old design where the AP
> pass-through and/or virtualization is done by exactly one driver for one
> guest, but different guests may use different drivers looks preferable
> to me.

This patch was developed due to lockdep errors I could not get rid of
using the previous model. I reverted back to that model and tested
with an SE guest again and verified that there were no lockdep
splats. Maybe it was inadvertently fixed with the subsequent patches,
so I'm going to run with the previous design.

>   
>
>
>
>> There are three reasons for doing this:
>>
>> 1. The lifetime of the interception handler function coincides with the
>>     lifetime of the vfio_ap module, so it makes little sense to tie it to
>>     the mediated device and complete sense to tie it to the module in which
>>     the function resides.
> Well, the handler lives in the vfio_ap module so this is a given anyway.
> I guess we are talking here about the callback which is registered by the
> vfio_ap module, in the old design with a specific kvm instance (guest).
>
>> 2. The setting/clearing of the function pointer is protected by a mutex
>>     lock. This increases the number of locks taken during
>>     VFIO_GROUP_NOTIFY_SET_KVM notification and increases the complexity of
>>     ensuring locking integrity and avoiding circular lock dependencies.
>>
>> 3. The lock will only be taken for writing twice: When the vfio_ap module
>>     is loaded; and, when the vfio_ap module is removed. As it stands now,
>>     the lock is taken for writing whenever a guest is started or terminated.
> What you do is basically get rid of the
>
> crypto_hook *pqap_hook;
> pointer and add the
> void *data;
> pointer instead.
>
> It is obvious why you need to add that pointer: we need a pointer to the
> matrix_mdev, and we used to obtain it via the pqap_hook pointer.
>
> But isn't the access to *data racy now? I mean you sill have concurrent
> access to a pointer that is just called differently. Yes, instead of
> accessing vcpu->kvm->arch.crypto.pqap_hook twice, we access the global
> pqap_hook in the kvm module once, and then data once, but the access to
> data does not seem to be synchronized at all. And you do not care to
> explain why that is supposed to be OK.
>
>
>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h      | 10 ++++--
>>   arch/s390/kvm/kvm-s390.c              |  1 -
>>   arch/s390/kvm/priv.c                  | 45 ++++++++++++++++++++++-----
>>   drivers/s390/crypto/vfio_ap_ops.c     | 27 ++++++++--------
>>   drivers/s390/crypto/vfio_ap_private.h |  1 -
>>   5 files changed, 58 insertions(+), 26 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index a604d51acfc8..05569d077d7f 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -799,16 +799,17 @@ struct kvm_s390_cpu_model {
>>   	unsigned short ibc;
>>   };
>>   
>> -typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
>> +struct kvm_s390_crypto_hook {
>> +	int (*fcn)(struct kvm_vcpu *vcpu);
>> +};
> I guess you do this for type safety, or?
>
>>   
>>   struct kvm_s390_crypto {
>>   	struct kvm_s390_crypto_cb *crycb;
>> -	struct rw_semaphore pqap_hook_rwsem;
>> -	crypto_hook *pqap_hook;
> One pointer set by the driver gone...
>
>>   	__u32 crycbd;
>>   	__u8 aes_kw;
>>   	__u8 dea_kw;
>>   	__u8 apie;
>> +	void *data;
> ... but another one added!
>
>>   };
>>   
>>   #define APCB0_MASK_SIZE 1
>> @@ -998,6 +999,9 @@ extern char sie_exit;
>>   extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
>>   extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
>>   
>> +extern int kvm_s390_pqap_hook_register(struct kvm_s390_crypto_hook *hook);
>> +extern int kvm_s390_pqap_hook_unregister(struct kvm_s390_crypto_hook *hook);
>> +
>>   static inline void kvm_arch_hardware_disable(void) {}
>>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>>   static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 6a6dd5e1daf6..c91981599328 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2649,7 +2649,6 @@ static void kvm_s390_crypto_init(struct kvm *kvm)
>>   {
>>   	kvm->arch.crypto.crycb = &kvm->arch.sie_page2->crycb;
>>   	kvm_s390_set_crycb_format(kvm);
>> -	init_rwsem(&kvm->arch.crypto.pqap_hook_rwsem);
>>   
>>   	if (!test_kvm_facility(kvm, 76))
>>   		return;
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 53da4ceb16a3..3d91ff934c0c 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -31,6 +31,39 @@
>>   #include "kvm-s390.h"
>>   #include "trace.h"
>>   
>> +DEFINE_MUTEX(pqap_hook_lock);
>> +static struct kvm_s390_crypto_hook *pqap_hook;
> This is the kvm global variable for the hook.
>> +
>> +int kvm_s390_pqap_hook_register(struct kvm_s390_crypto_hook *hook)
>> +{
>> +	int ret = 0;
>> +
>> +	mutex_lock(&pqap_hook_lock);
>> +	if (pqap_hook)
>> +		ret = -EACCES;
>> +	else
>> +		pqap_hook = hook;
>> +	mutex_unlock(&pqap_hook_lock);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pqap_hook_register);
>> +
>> +int kvm_s390_pqap_hook_unregister(struct kvm_s390_crypto_hook *hook)
>> +{
>> +	int ret = 0;
>> +
>> +	mutex_lock(&pqap_hook_lock);
>> +	if (hook != pqap_hook)
>> +		ret = -EACCES;
>> +	else
>> +		pqap_hook = NULL;
>> +	mutex_unlock(&pqap_hook_lock);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pqap_hook_unregister);
>> +
>>   static int handle_ri(struct kvm_vcpu *vcpu)
>>   {
>>   	vcpu->stat.instruction_ri++;
>> @@ -610,7 +643,6 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
>>   static int handle_pqap(struct kvm_vcpu *vcpu)
>>   {
>>   	struct ap_queue_status status = {};
>> -	crypto_hook pqap_hook;
>>   	unsigned long reg0;
>>   	int ret;
>>   	uint8_t fc;
>> @@ -659,16 +691,15 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>>   	 * hook function pointer in the kvm_s390_crypto structure. Lock the
>>   	 * owner, retrieve the hook function pointer and call the hook.
>>   	 */
>> -	down_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
> This used to protect any reads of vcpu->kvm->arch.crypto.pqap_hook ...
>
>> -	if (vcpu->kvm->arch.crypto.pqap_hook) {
>> -		pqap_hook = *vcpu->kvm->arch.crypto.pqap_hook;
>> -		ret = pqap_hook(vcpu);
> ... while we are executing the hook. Instead in the hook we are supposed
> to read *vcpu->kvm->arch.crypto.data but we don't care to synchronize
> that access because that one ain't protected by the new pqap_hook_lock
> mutex.
>
>> +	mutex_lock(&pqap_hook_lock);
>> +	if (pqap_hook) {
>> +		ret = pqap_hook->fcn(vcpu);
>>   		if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
>>   			kvm_s390_set_psw_cc(vcpu, 3);
>> -		up_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
>> +		mutex_unlock(&pqap_hook_lock);
>>   		return ret;
>>   	}
>> -	up_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
>> +	mutex_unlock(&pqap_hook_lock);
>>   	/*
>>   	 * A vfio_driver must register a hook.
>>   	 * No hook means no driver to enable the SIE CRYCB and no queues.
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 94c1c9bd58ad..02275d246b39 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -293,13 +293,10 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>>   	apqn = vcpu->run->s.regs.gprs[0] & 0xffff;
>>   	mutex_lock(&matrix_dev->lock);
>>   
>> -	if (!vcpu->kvm->arch.crypto.pqap_hook)
>> -		goto out_unlock;
>> -	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
>> -				   struct ap_matrix_mdev, pqap_hook);
>> +	matrix_mdev = vcpu->kvm->arch.crypto.data;
> Here is the access I'm talking about above. [1]
>
>>   
>>   	/* If the there is no guest using the mdev, there is nothing to do */
>> -	if (!matrix_mdev->kvm)
>> +	if (!matrix_mdev || !matrix_mdev->kvm)
>>   		goto out_unlock;
>>   
>>   	q = vfio_ap_get_queue(matrix_mdev, apqn);
>> @@ -348,7 +345,6 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>>   
>>   	matrix_mdev->mdev = mdev;
>>   	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
>> -	matrix_mdev->pqap_hook = handle_pqap;
>>   	mutex_lock(&matrix_dev->lock);
>>   	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>>   	mutex_unlock(&matrix_dev->lock);
>> @@ -1078,10 +1074,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>   	struct ap_matrix_mdev *m;
>>   
>>   	if (kvm->arch.crypto.crycbd) {
>> -		down_write(&kvm->arch.crypto.pqap_hook_rwsem);
>> -		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
> We used to set our old pointer in a synchronized manner...
>
>> -		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
>> -
>>   		mutex_lock(&kvm->lock);
>>   		mutex_lock(&matrix_dev->lock);
>>   
>> @@ -1095,6 +1087,7 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>   
>>   		kvm_get_kvm(kvm);
>>   		matrix_mdev->kvm = kvm;
>> +		kvm->arch.crypto.data = matrix_mdev;
> ... but not any more!
>
>>   		kvm_arch_crypto_set_masks(kvm,
>>   					  matrix_mdev->matrix.apm,
>>   					  matrix_mdev->matrix.aqm,
>> @@ -1155,16 +1148,13 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev,
>>   				   struct kvm *kvm)
>>   {
>>   	if (kvm && kvm->arch.crypto.crycbd) {
>> -		down_write(&kvm->arch.crypto.pqap_hook_rwsem);
>> -		kvm->arch.crypto.pqap_hook = NULL;
>> -		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
>> -
> Same here!
>
>>   		mutex_lock(&kvm->lock);
>>   		mutex_lock(&matrix_dev->lock);
>>   
>>   		kvm_arch_crypto_clear_masks(kvm);
>>   		vfio_ap_mdev_reset_queues(matrix_mdev);
>>   		kvm_put_kvm(kvm);
>> +		kvm->arch.crypto.data = NULL;
> And same here. So at [1] we aren't guaranteed to see this write, right?
> That does not look right to me.
>
>>   		matrix_mdev->kvm = NULL;
>>   
>>   		mutex_unlock(&kvm->lock);
>> @@ -1391,12 +1381,20 @@ static const struct mdev_parent_ops vfio_ap_matrix_ops = {
>>   	.supported_type_groups	= vfio_ap_mdev_type_groups,
>>   };
>>   
>> +static struct kvm_s390_crypto_hook pqap_hook = {
>> +	.fcn = handle_pqap,
>> +};
>> +
>>   int vfio_ap_mdev_register(void)
>>   {
>>   	int ret;
>>   
>>   	atomic_set(&matrix_dev->available_instances, MAX_ZDEV_ENTRIES_EXT);
>>   
>> +	ret = kvm_s390_pqap_hook_register(&pqap_hook);
>> +	if (ret)
>> +		return ret;
>> +
>>   	ret = mdev_register_driver(&vfio_ap_matrix_driver);
>>   	if (ret)
>>   		return ret;
>> @@ -1413,6 +1411,7 @@ int vfio_ap_mdev_register(void)
>>   
>>   void vfio_ap_mdev_unregister(void)
>>   {
>> +	WARN_ON(kvm_s390_pqap_hook_unregister(&pqap_hook));
>>   	mdev_unregister_device(&matrix_dev->device);
>>   	mdev_unregister_driver(&vfio_ap_matrix_driver);
>>   }
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index 648fcaf8104a..907f41160de7 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -97,7 +97,6 @@ struct ap_matrix_mdev {
>>   	struct notifier_block group_notifier;
>>   	struct notifier_block iommu_notifier;
>>   	struct kvm *kvm;
>> -	crypto_hook pqap_hook;
>>   	struct mdev_device *mdev;
>>   };
>>   

