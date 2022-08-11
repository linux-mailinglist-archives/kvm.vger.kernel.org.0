Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BC959052B
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 18:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbiHKQxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 12:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237470AbiHKQxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 12:53:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226989E2E7;
        Thu, 11 Aug 2022 09:26:21 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BGE3l1014989;
        Thu, 11 Aug 2022 16:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SFlVbS90omRHBLRLji06Rx42Q4sZsdRil5fV5fjkLbU=;
 b=TesQV3BWhlzFDrAC1XEQJFgXkeCOu22KsNd+k2upSqFsGCfZNGjq8l7zKcoOGB5r5/um
 NezHXV7YxLsfol8/3pLGn6KZFsO2OdDu56U3SyF4oCXwyZtXvG4T76Pdv8S53RCsmo6N
 NeluHzj+xTsEIsExB3sF9WoWpL9AIB8jeQ5OyaauHjaw/3AkZiXrlWv780jqXRgDCV0z
 fH5hK+P3tUbPqXl3hz8W4l/tk4Oms5uf+ICsqoctEyz8rJUinas8RFcRP2sSpPB4eAL0
 CBoTToRptjlNqqzE60z5qJwASbuW5DXRTLXfZ+dm7I+D9+A93XFADFCusWUIYNih7wMU ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw54189f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 16:26:21 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27BGKa5U000737;
        Thu, 11 Aug 2022 16:26:20 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw54189ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 16:26:20 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27BG7KVQ009330;
        Thu, 11 Aug 2022 16:26:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3huww0swee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 16:26:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27BGNfXx29622676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 16:23:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87F88A4053;
        Thu, 11 Aug 2022 16:26:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDD90A4051;
        Thu, 11 Aug 2022 16:26:13 +0000 (GMT)
Received: from [9.145.33.87] (unknown [9.145.33.87])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Aug 2022 16:26:13 +0000 (GMT)
Message-ID: <b726199f-6c07-fd9a-fd1e-016e6d98971e@linux.ibm.com>
Date:   Thu, 11 Aug 2022 18:26:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220810125625.45295-1-imbrenda@linux.ibm.com>
 <20220810125625.45295-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v13 1/6] KVM: s390: pv: asynchronous destroy for reboot
In-Reply-To: <20220810125625.45295-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: foBfjiDHAXAD8-11JS0YzDUsQZHOeirF
X-Proofpoint-GUID: qzYc72jM9zm4sWbeSD9P1Z4SgHSXSZ9m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_11,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208110054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/22 14:56, Claudio Imbrenda wrote:
> Until now, destroying a protected guest was an entirely synchronous
> operation that could potentially take a very long time, depending on
> the size of the guest, due to the time needed to clean up the address
> space from protected pages.
> 
> This patch implements an asynchronous destroy mechanism, that allows a
> protected guest to reboot significantly faster than previously.
> 
> This is achieved by clearing the pages of the old guest in background.
> In case of reboot, the new guest will be able to run in the same
> address space almost immediately.
> 
> The old protected guest is then only destroyed when all of its memory has
> been destroyed or otherwise made non protected.
> 
> Two new PV commands are added for the KVM_S390_PV_COMMAND ioctl:
> 
> KVM_PV_ASYNC_CLEANUP_PREPARE: prepares the current protected VM for
> asynchronous teardown. The current VM will then continue immediately
> as non-protected. If a protected VM had already been set aside without
> starting the teardown process, this call will fail. There can be at
> most one prepared VM at any time.
> 
> KVM_PV_ASYNC_CLEANUP_PERFORM: tears down the protected VM previously
> set aside for asynchronous teardown. This PV command should ideally be
> issued by userspace from a separate thread. If a fatal signal is
> received (or the process terminates naturally), the command will
> terminate immediately without completing. The rest of the normal KVM
> teardown process will take care of properly cleaning up all remaining
> protected VMs.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |   2 +
>   arch/s390/kvm/kvm-s390.c         |  46 ++++-
>   arch/s390/kvm/kvm-s390.h         |   3 +
>   arch/s390/kvm/pv.c               | 290 +++++++++++++++++++++++++++++--
>   include/uapi/linux/kvm.h         |   2 +
>   5 files changed, 325 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index f39092e0ceaa..38558e5f554e 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -942,6 +942,8 @@ struct kvm_s390_pv {
>   	unsigned long stor_base;
>   	void *stor_var;
>   	bool dumping;
> +	void *set_aside;
> +	struct list_head need_cleanup;
>   	struct mmu_notifier mmu_notifier;
>   };
>   
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index edfd4bbd0cba..96ec6ecb6b74 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -209,6 +209,8 @@ unsigned int diag9c_forwarding_hz;
>   module_param(diag9c_forwarding_hz, uint, 0644);
>   MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
>   
> +static int async_destroy;
> +
>   /*
>    * For now we handle at most 16 double words as this is what the s390 base
>    * kernel handles and stores in the prefix page. If we ever need to go beyond
> @@ -2504,9 +2506,13 @@ static int kvm_s390_pv_dmp(struct kvm *kvm, struct kvm_pv_cmd *cmd,
>   
>   static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>   {
> +	const bool needslock = (cmd->cmd != KVM_PV_ASYNC_CLEANUP_PERFORM);
> +	void __user *argp = (void __user *)cmd->data;
>   	int r = 0;
>   	u16 dummy;
> -	void __user *argp = (void __user *)cmd->data;
> +
> +	if (needslock)
> +		mutex_lock(&kvm->lock);
>   
>   	switch (cmd->cmd) {
>   	case KVM_PV_ENABLE: {
> @@ -2540,6 +2546,28 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>   		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
>   		break;
>   	}
> +	case KVM_PV_ASYNC_CLEANUP_PREPARE:
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm) || !async_destroy)
> +			break;
> +
> +		r = kvm_s390_cpus_from_pv(kvm, &cmd->rc, &cmd->rrc);
> +		/*
> +		 * If a CPU could not be destroyed, destroy VM will also fail.
> +		 * There is no point in trying to destroy it. Instead return
> +		 * the rc and rrc from the first CPU that failed destroying.
> +		 */
> +		if (r)
> +			break;
> +		r = kvm_s390_pv_set_aside(kvm, &cmd->rc, &cmd->rrc);
> +
> +		/* no need to block service interrupts any more */
> +		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
> +		break;
> +	case KVM_PV_ASYNC_CLEANUP_PERFORM:
> +		/* This must not be called while holding kvm->lock */

Two things:
I know that we don't need to check async_destroy since it will find 
nothing to cleanup because the command above is fenced. But I'd still 
appreciate the same check here.

Consider adding this to the comment:
", this is asserted inside the function."

> +		r = kvm_s390_pv_deinit_aside_vm(kvm, &cmd->rc, &cmd->rrc);
> +		break;
>   	case KVM_PV_DISABLE: {
>   		r = -EINVAL;
>   		if (!kvm_s390_pv_is_protected(kvm))
> @@ -2553,7 +2581,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>   		 */
>   		if (r)
>   			break;
> -		r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
> +		r = kvm_s390_pv_deinit_cleanup_all(kvm, &cmd->rc, &cmd->rrc);
>   
>   		/* no need to block service interrupts any more */
>   		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
> @@ -2703,6 +2731,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>   	default:
>   		r = -ENOTTY;
>   	}
> +	if (needslock)
> +		mutex_unlock(&kvm->lock);
> +
>   	return r;
>   }
>   
> @@ -2907,9 +2938,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   			r = -EINVAL;
>   			break;
>   		}
> -		mutex_lock(&kvm->lock);
> +		/* must be called without kvm->lock */

...as it will acquire and release it by itself.

>   		r = kvm_s390_handle_pv(kvm, &args);
> -		mutex_unlock(&kvm->lock);
>   		if (copy_to_user(argp, &args, sizeof(args))) {
>   			r = -EFAULT;
>   			break;
> @@ -3228,6 +3258,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm_s390_vsie_init(kvm);
>   	if (use_gisa)
>   		kvm_s390_gisa_init(kvm);
> +	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
> +	kvm->arch.pv.set_aside = NULL;
>   	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
>   
>   	return 0;
> @@ -3272,11 +3304,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	/*
>   	 * We are already at the end of life and kvm->lock is not taken.
>   	 * This is ok as the file descriptor is closed by now and nobody
> -	 * can mess with the pv state. To avoid lockdep_assert_held from
> -	 * complaining we do not use kvm_s390_pv_is_protected.
> +	 * can mess with the pv state.
>   	 */
> -	if (kvm_s390_pv_get_handle(kvm))
> -		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
> +	kvm_s390_pv_deinit_cleanup_all(kvm, &rc, &rrc);
>   	/*
>   	 * Remove the mmu notifier only when the whole KVM VM is torn down,
>   	 * and only if one was registered to begin with. If the VM is
[...]
> +
> +/**
> + * kvm_s390_pv_set_aside - Set aside a protected VM for later teardown.
> + * @kvm: the VM
> + * @rc: return value for the RC field of the UVCB
> + * @rrc: return value for the RRC field of the UVCB
> + *
> + * Set aside the protected VM for a subsequent teardown. The VM will be able
> + * to continue immediately as a non-secure VM, and the information needed to
> + * properly tear down the protected VM is set aside. If another protected VM
> + * was already set aside without starting its teardown, this function will
> + * fail.
> + * The CPUs of the protected VM need to be destroyed beforehand.
> + *
> + * Context: kvm->lock needs to be held
> + *
> + * Return: 0 in case of success, -EINVAL if another protected VM was already set
> + * aside, -ENOMEM if the system ran out of memory.
> + */
> +int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
> +{
> +	struct pv_vm_to_be_destroyed *priv;
> +
> +	/*
> +	 * If another protected VM was already prepared, refuse.

s/prepared/set aside/
or
prepared for teardown

> +	 * A normal deinitialization has to be performed instead.
> +	 */
> +	if (kvm->arch.pv.set_aside)
> +		return -EINVAL;
> +	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);

kzalloc()?

> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->stor_var = kvm->arch.pv.stor_var;
> +	priv->stor_base = kvm->arch.pv.stor_base;
> +	priv->handle = kvm_s390_pv_get_handle(kvm);
> +	priv->old_gmap_table = (unsigned long)kvm->arch.gmap->table;
> +	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> +	if (s390_replace_asce(kvm->arch.gmap)) {
> +		kfree(priv);
> +		return -ENOMEM;
>   	}
>   
> +	kvm_s390_destroy_lower_2g(kvm);
> +	kvm_s390_clear_pv_state(kvm);
> +	kvm->arch.pv.set_aside = priv;
> +
> +	*rc = 1;

UVC_RC_EXECUTED	

> +	*rrc = 42;

I'd prefer setting the rrc to 0.

> +	return 0;
> +}
