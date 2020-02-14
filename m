Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA5A15F5CD
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 19:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbgBNSjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 13:39:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50905 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729906AbgBNSji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 13:39:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581705575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=a9L7X7lu3Zm+B9R/kuIAndsV1kZyiBjybeJtrjbnD+U=;
        b=iEeiK4RqhiORuxIE2T7+xj3LHiXzzRoxbfB2GaoqHEETksUc4tsZQ+UfoEuCFUNW77Ume4
        0TPGeEQJK20FpmQCgeMpiH8gq/Na8B/1yNA8AI6fI1yJkGHnsxSz9Mr0KVSNyxQ8au7mxZ
        FOb8e0MuuHbXqa6IAw6SELVEydXZWlk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-TAYbWqI-OpKhL7eLJ4CpAg-1; Fri, 14 Feb 2020 13:39:30 -0500
X-MC-Unique: TAYbWqI-OpKhL7eLJ4CpAg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C680D100550E;
        Fri, 14 Feb 2020 18:39:28 +0000 (UTC)
Received: from [10.36.118.137] (unknown [10.36.118.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 253C360BF1;
        Fri, 14 Feb 2020 18:39:25 +0000 (UTC)
Subject: Re: [PATCH 08/35] KVM: s390: protvirt: Add initial lifecycle handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-9-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <e627e0a6-b27a-7e3a-05cd-056eb49ed16e@redhat.com>
Date:   Fri, 14 Feb 2020 19:39:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-9-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.02.20 12:39, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> This contains 3 main changes:
> 1. changes in SIE control block handling for secure guests
> 2. helper functions for create/destroy/unpack secure guests
> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
> machines
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  24 ++-
>  arch/s390/include/asm/uv.h       |  69 +++++++++
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/kvm-s390.c         | 191 +++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.h         |  27 ++++
>  arch/s390/kvm/pv.c               | 244 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  33 +++++
>  7 files changed, 586 insertions(+), 4 deletions(-)
>  create mode 100644 arch/s390/kvm/pv.c
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 884503e05424..3ed31c5f80e1 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -160,7 +160,13 @@ struct kvm_s390_sie_block {
>  	__u8	reserved08[4];		/* 0x0008 */
>  #define PROG_IN_SIE (1<<0)
>  	__u32	prog0c;			/* 0x000c */
> -	__u8	reserved10[16];		/* 0x0010 */
> +	union {
> +		__u8	reserved10[16];		/* 0x0010 */
> +		struct {
> +			__u64	pv_handle_cpu;
> +			__u64	pv_handle_config;
> +		};
> +	};
>  #define PROG_BLOCK_SIE	(1<<0)
>  #define PROG_REQUEST	(1<<1)
>  	atomic_t prog20;		/* 0x0020 */
> @@ -233,7 +239,7 @@ struct kvm_s390_sie_block {
>  #define ECB3_RI  0x01
>  	__u8    ecb3;			/* 0x0063 */
>  	__u32	scaol;			/* 0x0064 */
> -	__u8	reserved68;		/* 0x0068 */
> +	__u8	sdf;			/* 0x0068 */
>  	__u8    epdx;			/* 0x0069 */
>  	__u8    reserved6a[2];		/* 0x006a */
>  	__u32	todpr;			/* 0x006c */
> @@ -645,6 +651,11 @@ struct kvm_guestdbg_info_arch {
>  	unsigned long last_bp;
>  };
>  
> +struct kvm_s390_pv_vcpu {
> +	u64 handle;
> +	unsigned long stor_base;
> +};
> +
>  struct kvm_vcpu_arch {
>  	struct kvm_s390_sie_block *sie_block;
>  	/* if vsie is active, currently executed shadow sie control block */
> @@ -673,6 +684,7 @@ struct kvm_vcpu_arch {
>  	__u64 cputm_start;
>  	bool gs_enabled;
>  	bool skey_enabled;
> +	struct kvm_s390_pv_vcpu pv;
>  };
>  
>  struct kvm_vm_stat {
> @@ -846,6 +858,13 @@ struct kvm_s390_gisa_interrupt {
>  	DECLARE_BITMAP(kicked_mask, KVM_MAX_VCPUS);
>  };
>  
> +struct kvm_s390_pv {
> +	u64 handle;
> +	u64 guest_len;
> +	unsigned long stor_base;
> +	void *stor_var;
> +};
> +
>  struct kvm_arch{
>  	void *sca;
>  	int use_esca;
> @@ -881,6 +900,7 @@ struct kvm_arch{
>  	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
>  	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
>  	struct kvm_s390_gisa_interrupt gisa_int;
> +	struct kvm_s390_pv pv;
>  };
>  
>  #define KVM_HVA_ERR_BAD		(-1UL)
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index e1cef772fde1..7c21d55d2e49 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -23,11 +23,19 @@
>  #define UVC_RC_INV_STATE	0x0003
>  #define UVC_RC_INV_LEN		0x0005
>  #define UVC_RC_NO_RESUME	0x0007
> +#define UVC_RC_NEED_DESTROY	0x8000
>  
>  #define UVC_CMD_QUI			0x0001
>  #define UVC_CMD_INIT_UV			0x000f
> +#define UVC_CMD_CREATE_SEC_CONF		0x0100
> +#define UVC_CMD_DESTROY_SEC_CONF	0x0101
> +#define UVC_CMD_CREATE_SEC_CPU		0x0120
> +#define UVC_CMD_DESTROY_SEC_CPU		0x0121
>  #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
>  #define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
> +#define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
> +#define UVC_CMD_UNPACK_IMG		0x0301
> +#define UVC_CMD_VERIFY_IMG		0x0302
>  #define UVC_CMD_PIN_PAGE_SHARED		0x0341
>  #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
>  #define UVC_CMD_SET_SHARED_ACCESS	0x1000
> @@ -37,10 +45,17 @@
>  enum uv_cmds_inst {
>  	BIT_UVC_CMD_QUI = 0,
>  	BIT_UVC_CMD_INIT_UV = 1,
> +	BIT_UVC_CMD_CREATE_SEC_CONF = 2,
> +	BIT_UVC_CMD_DESTROY_SEC_CONF = 3,
> +	BIT_UVC_CMD_CREATE_SEC_CPU = 4,
> +	BIT_UVC_CMD_DESTROY_SEC_CPU = 5,
>  	BIT_UVC_CMD_CONV_TO_SEC_STOR = 6,
>  	BIT_UVC_CMD_CONV_FROM_SEC_STOR = 7,
>  	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
>  	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
> +	BIT_UVC_CMD_SET_SEC_PARMS = 11,
> +	BIT_UVC_CMD_UNPACK_IMG = 13,
> +	BIT_UVC_CMD_VERIFY_IMG = 14,
>  	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
>  	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
>  };
> @@ -52,6 +67,7 @@ struct uv_cb_header {
>  	u16 rrc;	/* Return Reason Code */
>  } __packed __aligned(8);
>  
> +/* Query Ultravisor Information */
>  struct uv_cb_qui {
>  	struct uv_cb_header header;
>  	u64 reserved08;
> @@ -71,6 +87,7 @@ struct uv_cb_qui {
>  	u64 reserveda0;
>  } __packed __aligned(8);
>  
> +/* Initialize Ultravisor */
>  struct uv_cb_init {
>  	struct uv_cb_header header;
>  	u64 reserved08[2];
> @@ -79,6 +96,35 @@ struct uv_cb_init {
>  	u64 reserved28[4];
>  } __packed __aligned(8);
>  
> +/* Create Guest Configuration */
> +struct uv_cb_cgc {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 guest_handle;
> +	u64 conf_base_stor_origin;
> +	u64 conf_virt_stor_origin;
> +	u64 reserved30;
> +	u64 guest_stor_origin;
> +	u64 guest_stor_len;
> +	u64 guest_sca;
> +	u64 guest_asce;
> +	u64 reserved58[5];
> +} __packed __aligned(8);
> +
> +/* Create Secure CPU */
> +struct uv_cb_csc {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 cpu_handle;
> +	u64 guest_handle;
> +	u64 stor_origin;
> +	u8  reserved30[6];
> +	u16 num;
> +	u64 state_origin;
> +	u64 reserved40[4];
> +} __packed __aligned(8);
> +
> +/* Convert to Secure */
>  struct uv_cb_cts {
>  	struct uv_cb_header header;
>  	u64 reserved08[2];
> @@ -86,12 +132,34 @@ struct uv_cb_cts {
>  	u64 gaddr;
>  } __packed __aligned(8);
>  
> +/* Convert from Secure / Pin Page Shared */
>  struct uv_cb_cfs {
>  	struct uv_cb_header header;
>  	u64 reserved08[2];
>  	u64 paddr;
>  } __packed __aligned(8);
>  
> +/* Set Secure Config Parameter */
> +struct uv_cb_ssc {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 guest_handle;
> +	u64 sec_header_origin;
> +	u32 sec_header_len;
> +	u32 reserved2c;
> +	u64 reserved30[4];
> +} __packed __aligned(8);
> +
> +/* Unpack */
> +struct uv_cb_unp {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 guest_handle;
> +	u64 gaddr;
> +	u64 tweak[2];
> +	u64 reserved38[3];
> +} __packed __aligned(8);
> +
>  /*
>   * A common UV call struct for calls that take no payload
>   * Examples:
> @@ -105,6 +173,7 @@ struct uv_cb_nodata {
>  	u64 reserved20[4];
>  } __packed __aligned(8);
>  
> +/* Set Shared Access */
>  struct uv_cb_share {
>  	struct uv_cb_header header;
>  	u64 reserved08[3];
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index 05ee90a5ea08..12decca22e7c 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -9,6 +9,6 @@ common-objs = $(KVM)/kvm_main.o $(KVM)/eventfd.o  $(KVM)/async_pf.o $(KVM)/irqch
>  ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>  
>  kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
> -kvm-objs += diag.o gaccess.o guestdbg.o vsie.o
> +kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
>  
>  obj-$(CONFIG_KVM) += kvm.o
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1a48214ac507..e1bccbb41fdd 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -44,6 +44,7 @@
>  #include <asm/cpacf.h>
>  #include <asm/timex.h>
>  #include <asm/ap.h>
> +#include <asm/uv.h>
>  #include "kvm-s390.h"
>  #include "gaccess.h"
>  
> @@ -236,6 +237,7 @@ int kvm_arch_check_processor_compat(void)
>  
>  static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
>  			      unsigned long end);
> +static int sca_switch_to_extended(struct kvm *kvm);
>  
>  static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
>  {
> @@ -568,6 +570,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_BPB:
>  		r = test_facility(82);
>  		break;
> +	case KVM_CAP_S390_PROTECTED:
> +		r = is_prot_virt_host();
> +		break;
>  	default:
>  		r = 0;
>  	}
> @@ -2162,6 +2167,115 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
>  	return r;
>  }
>  
> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> +{
> +	int r = 0;
> +	void __user *argp = (void __user *)cmd->data;
> +
> +	switch (cmd->cmd) {
> +	case KVM_PV_VM_CREATE: {
> +		r = -EINVAL;
> +		if (kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r = kvm_s390_pv_alloc_vm(kvm);
> +		if (r)
> +			break;
> +
> +		mutex_lock(&kvm->lock);
> +		kvm_s390_vcpu_block_all(kvm);
> +		/* FMT 4 SIE needs esca */
> +		r = sca_switch_to_extended(kvm);
> +		if (r) {
> +			kvm_s390_pv_dealloc_vm(kvm);
> +			kvm_s390_vcpu_unblock_all(kvm);
> +			mutex_unlock(&kvm->lock);
> +			break;
> +		}
> +		r = kvm_s390_pv_create_vm(kvm);
> +		kvm_s390_vcpu_unblock_all(kvm);
> +		mutex_unlock(&kvm->lock);
> +		break;
> +	}
> +	case KVM_PV_VM_DESTROY: {
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		/* All VCPUs have to be destroyed before this call. */
> +		mutex_lock(&kvm->lock);
> +		kvm_s390_vcpu_block_all(kvm);
> +		r = kvm_s390_pv_destroy_vm(kvm);
> +		if (!r)
> +			kvm_s390_pv_dealloc_vm(kvm);
> +		kvm_s390_vcpu_unblock_all(kvm);
> +		mutex_unlock(&kvm->lock);
> +		break;
> +	}
> +	case KVM_PV_VM_SET_SEC_PARMS: {
> +		struct kvm_s390_pv_sec_parm parms = {};
> +		void *hdr;
> +
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&parms, argp, sizeof(parms)))
> +			break;
> +
> +		/* Currently restricted to 8KB */
> +		r = -EINVAL;
> +		if (parms.length > PAGE_SIZE * 2)
> +			break;
> +
> +		r = -ENOMEM;
> +		hdr = vmalloc(parms.length);
> +		if (!hdr)
> +			break;
> +
> +		r = -EFAULT;
> +		if (!copy_from_user(hdr, (void __user *)parms.origin,
> +				   parms.length))
> +			r = kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length);
> +
> +		vfree(hdr);
> +		break;
> +	}
> +	case KVM_PV_VM_UNPACK: {
> +		struct kvm_s390_pv_unp unp = {};
> +
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&unp, argp, sizeof(unp)))
> +			break;
> +
> +		r = kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak);
> +		break;
> +	}
> +	case KVM_PV_VM_VERIFY: {
> +		u32 ret;
> +
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
> +				  UVC_CMD_VERIFY_IMG,
> +				  &ret);
> +		VM_EVENT(kvm, 3, "PROTVIRT VERIFY: rc %x rrc %x",
> +			 ret >> 16, ret & 0x0000ffff);
> +		break;
> +	}
> +	default:
> +		return -ENOTTY;
> +	}
> +	return r;
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> @@ -2259,6 +2373,20 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		mutex_unlock(&kvm->slots_lock);
>  		break;
>  	}
> +	case KVM_S390_PV_COMMAND: {
> +		struct kvm_pv_cmd args;
> +
> +		r = -EINVAL;
> +		if (!is_prot_virt_host())
> +			break;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&args, argp, sizeof(args)))
> +			break;
> +
> +		r = kvm_s390_handle_pv(kvm, &args);
> +		break;
> +	}
>  	default:
>  		r = -ENOTTY;
>  	}
> @@ -2534,6 +2662,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  
>  	if (vcpu->kvm->arch.use_cmma)
>  		kvm_s390_vcpu_unsetup_cmma(vcpu);
> +	if (kvm_s390_pv_handle_cpu(vcpu))
> +		kvm_s390_pv_destroy_cpu(vcpu);
>  	free_page((unsigned long)(vcpu->arch.sie_block));
>  
>  	kvm_vcpu_uninit(vcpu);
> @@ -2560,8 +2690,12 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
>  	kvm_free_vcpus(kvm);
>  	sca_dispose(kvm);
> -	debug_unregister(kvm->arch.dbf);
>  	kvm_s390_gisa_destroy(kvm);
> +	if (kvm_s390_pv_is_protected(kvm)) {
> +		kvm_s390_pv_destroy_vm(kvm);
> +		kvm_s390_pv_dealloc_vm(kvm);
> +	}
> +	debug_unregister(kvm->arch.dbf);
>  	free_page((unsigned long)kvm->arch.sie_page2);
>  	if (!kvm_is_ucontrol(kvm))
>  		gmap_remove(kvm->arch.gmap);
> @@ -2657,6 +2791,9 @@ static int sca_switch_to_extended(struct kvm *kvm)
>  	unsigned int vcpu_idx;
>  	u32 scaol, scaoh;
>  
> +	if (kvm->arch.use_esca)
> +		return 0;
> +
>  	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO);
>  	if (!new_sca)
>  		return -ENOMEM;
> @@ -3049,6 +3186,15 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  	rc = kvm_vcpu_init(vcpu, kvm, id);
>  	if (rc)
>  		goto out_free_sie_block;
> +
> +	if (kvm_s390_pv_is_protected(kvm)) {
> +		rc = kvm_s390_pv_create_cpu(vcpu);
> +		if (rc) {
> +			kvm_vcpu_uninit(vcpu);
> +			goto out_free_sie_block;
> +		}
> +	}
> +
>  	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
>  		 vcpu->arch.sie_block);
>  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
> @@ -4357,6 +4503,35 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>  	return -ENOIOCTLCMD;
>  }
>  
> +static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
> +				   struct kvm_pv_cmd *cmd)
> +{
> +	int r = 0;
> +
> +	if (!kvm_s390_pv_is_protected(vcpu->kvm))
> +		return -EINVAL;
> +
> +	switch (cmd->cmd) {
> +	case KVM_PV_VCPU_CREATE: {
> +		if (kvm_s390_pv_handle_cpu(vcpu))
> +			return -EINVAL;
> +
> +		r = kvm_s390_pv_create_cpu(vcpu);
> +		break;
> +	}
> +	case KVM_PV_VCPU_DESTROY: {
> +		if (!kvm_s390_pv_handle_cpu(vcpu))
> +			return -EINVAL;
> +
> +		r = kvm_s390_pv_destroy_cpu(vcpu);
> +		break;
> +	}

I feel like my review comments for this patch were lost, so not
repeating them.


-- 
Thanks,

David / dhildenb

