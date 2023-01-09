Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A757D663271
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbjAIVMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237981AbjAIVL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:11:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE02496C3;
        Mon,  9 Jan 2023 13:07:23 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309K9mPl026312;
        Mon, 9 Jan 2023 21:07:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jgCllVXKBovBeAakrrqrf5mxYMPBZUP00hFtFhdb/mQ=;
 b=pxgsknqa88806adoXThtybPH0KCeIosY4aVgFPG5StiL6yjUpCY8ixUi3L8cWyItD2ze
 AGuYVf1s5Pj7Gk+XT2KKIUQjv/UeKUoEXLSmJBv+MHPWPJn1o1ZYxOvqqFObGezCXnJL
 j/Y5b6fULPr3VGSuCAhCxCTgMUdy+o4GVp1fdXRyGbmZp8j9y32xR7kTIjvDAIclVXS8
 37vBz2vJd9tUogRAs3HFzrax7iUyy3elJ5KZbdlEtVdvaYOWGEsEfY3xNFddEVq8JGmS
 n7OROcA4gJJt/gAo+rBn3yOCNwm/yXRBaCspG15cgO2jjTKmsXkQqwuapQzn0ys2m/Ym Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjhtss57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 21:07:20 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 309L0IC0016057;
        Mon, 9 Jan 2023 21:07:19 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjhtss4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 21:07:19 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 309IK0VI017937;
        Mon, 9 Jan 2023 21:07:18 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3my0c7p03g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 21:07:18 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 309L7H4038142416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Jan 2023 21:07:17 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDE6858050;
        Mon,  9 Jan 2023 21:07:16 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBFFA58045;
        Mon,  9 Jan 2023 21:07:14 +0000 (GMT)
Received: from [9.160.171.221] (unknown [9.160.171.221])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Jan 2023 21:07:14 +0000 (GMT)
Message-ID: <53a8dd61-0f50-da2a-6594-2a5920af3024@linux.ibm.com>
Date:   Mon, 9 Jan 2023 16:07:14 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/2] KVM: async kvm_destroy_vm for vfio devices
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com
Cc:     jgg@nvidia.com, cohuck@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230109201037.33051-1-mjrosato@linux.ibm.com>
 <20230109201037.33051-2-mjrosato@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20230109201037.33051-2-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: opPe6bdDLiFW0dlDCj2gwRingo5DzijG
X-Proofpoint-GUID: 9m1l2zTVko2RMlVZbAV7gLXS0gf5YgCr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 clxscore=1011 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090147
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LGTM

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 1/9/23 3:10 PM, Matthew Rosato wrote:
> Currently it is possible that the final put of a KVM reference comes from
> vfio during its device close operation.  This occurs while the vfio group
> lock is held; however, if the vfio device is still in the kvm device list,
> then the following call chain could result in a deadlock:
>
> kvm_put_kvm
>   -> kvm_destroy_vm
>    -> kvm_destroy_devices
>     -> kvm_vfio_destroy
>      -> kvm_vfio_file_set_kvm
>       -> vfio_file_set_kvm
>        -> group->group_lock/group_rwsem
>
> Avoid this scenario by adding kvm_put_kvm_async which will perform the
> kvm_destroy_vm asynchronously if the refcount reaches 0.
>
> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   drivers/gpu/drm/i915/gvt/kvmgt.c  |  6 +++++-
>   drivers/s390/crypto/vfio_ap_ops.c |  7 ++++++-
>   include/linux/kvm_host.h          |  3 +++
>   virt/kvm/kvm_main.c               | 22 ++++++++++++++++++++++
>   4 files changed, 36 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 8ae7039b3683..24511c877572 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -703,7 +703,11 @@ static void intel_vgpu_close_device(struct vfio_device *vfio_dev)
>   
>   	kvm_page_track_unregister_notifier(vgpu->vfio_device.kvm,
>   					   &vgpu->track_node);
> -	kvm_put_kvm(vgpu->vfio_device.kvm);
> +	/*
> +	 * Avoid possible deadlock on any currently-held vfio lock by
> +	 * ensuring the potential kvm_destroy_vm call is done asynchronously
> +	 */
> +	kvm_put_kvm_async(vgpu->vfio_device.kvm);
>   
>   	kvmgt_protect_table_destroy(vgpu);
>   	gvt_cache_destroy(vgpu);
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e93bb9c468ce..a37b2baefb36 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1574,7 +1574,12 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>   
>   		kvm_arch_crypto_clear_masks(kvm);
>   		vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
> -		kvm_put_kvm(kvm);
> +		/*
> +		 * Avoid possible deadlock on any currently-held vfio lock by
> +		 * ensuring the potential kvm_destroy_vm call is done
> +		 * asynchronously
> +		 */
> +		kvm_put_kvm_async(kvm);
>   		matrix_mdev->kvm = NULL;
>   
>   		release_update_locks_for_kvm(kvm);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4f26b244f6d0..2ef6a5102265 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -34,6 +34,7 @@
>   #include <linux/instrumentation.h>
>   #include <linux/interval_tree.h>
>   #include <linux/rbtree.h>
> +#include <linux/workqueue.h>
>   #include <linux/xarray.h>
>   #include <asm/signal.h>
>   
> @@ -793,6 +794,7 @@ struct kvm {
>   	struct kvm_stat_data **debugfs_stat_data;
>   	struct srcu_struct srcu;
>   	struct srcu_struct irq_srcu;
> +	struct work_struct async_work;
>   	pid_t userspace_pid;
>   	bool override_halt_poll_ns;
>   	unsigned int max_halt_poll_ns;
> @@ -963,6 +965,7 @@ void kvm_exit(void);
>   void kvm_get_kvm(struct kvm *kvm);
>   bool kvm_get_kvm_safe(struct kvm *kvm);
>   void kvm_put_kvm(struct kvm *kvm);
> +void kvm_put_kvm_async(struct kvm *kvm);
>   bool file_is_kvm(struct file *file);
>   void kvm_put_kvm_no_destroy(struct kvm *kvm);
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 13e88297f999..fbe8d127028b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1353,6 +1353,28 @@ void kvm_put_kvm(struct kvm *kvm)
>   }
>   EXPORT_SYMBOL_GPL(kvm_put_kvm);
>   
> +static void kvm_put_async_fn(struct work_struct *work)
> +{
> +	struct kvm *kvm = container_of(work, struct kvm,
> +				       async_work);
> +
> +	kvm_destroy_vm(kvm);
> +}
> +
> +/*
> + * Put a reference but only destroy the vm asynchronously.  Can be used in
> + * cases where the caller holds a mutex that could cause deadlock if
> + * kvm_destroy_vm is triggered
> + */
> +void kvm_put_kvm_async(struct kvm *kvm)
> +{
> +	if (refcount_dec_and_test(&kvm->users_count)) {
> +		INIT_WORK(&kvm->async_work, kvm_put_async_fn);
> +		schedule_work(&kvm->async_work);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(kvm_put_kvm_async);
> +
>   /*
>    * Used to put a reference that was taken on behalf of an object associated
>    * with a user-visible file descriptor, e.g. a vcpu or device, if installation
