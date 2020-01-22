Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28111458F0
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 16:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgAVPo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 10:44:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54797 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725836AbgAVPo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 10:44:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579707894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zv+bCnNOl3qjnstEYa92uxa3f6bv0jFexwgAKSb/Wgw=;
        b=ZLixP1Z6FdGKiUYFt5lLeQJteMCiqrBeSE1jjFzKrfl2HKsGPF89nAzjSY9RCUzasSiYfl
        tvvOhM3G77cRgSpyuKZ1CNv3o8L31+ROfTdbTjEQy5vfvVmWiWiAuVoPXTUkcp8XSYWn8Q
        1GzUXPC9Rwo2KcHjVl5kTOMGifvfho8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-AKdGaOEXMLCpUTW3f_DUDA-1; Wed, 22 Jan 2020 10:44:52 -0500
X-MC-Unique: AKdGaOEXMLCpUTW3f_DUDA-1
Received: by mail-wr1-f70.google.com with SMTP id k18so3275419wrw.9
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 07:44:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zv+bCnNOl3qjnstEYa92uxa3f6bv0jFexwgAKSb/Wgw=;
        b=RLLqhNGn3VwR+UugLlhjoi0ssfei01ReTla3ZXK0pWrsABlcmqvPbQEXQwghHNYhn4
         BNcIFLD4k83MRjGcpDVvKgr3M38Nv/Qcdrrw5GoPQhl0+3J1J7VNXXdtXkm3rer0j00s
         cbFLCcA0DNP411wFVR2A6OnzlH9GpLJAyfNI7AGZa+nC62ocGj5DnOwp2k5BFktokS4l
         OliwGqmXFt/SEojAsTVuA6/qI7R3emxeN58D/8bK6mNxngRxgKxaNKjp1Wr6hzHOLHKG
         FxAB9briL64P1F11EhElemC1AEcZRvyA+KaNcn5khWaQs1atWS1OkJpgWUK+ZuMt7YYY
         SSyA==
X-Gm-Message-State: APjAAAWNkCl+SM8clOIT4z+HfIn0SQd0fRFuiZbtZO6JYfwT1FjBwl7m
        z2Pme0hKl/Yv9XvGeh3IQevBuXaraXSrp+mvMdiMEduLjuagSEFCS33jd+uV76CUMW3QlPOv14L
        btN4+aWe8+HaI
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr3608530wmf.60.1579707890545;
        Wed, 22 Jan 2020 07:44:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqzf+zGrSWPw3ihUGr7p4vlyzpMTPSct3QELlX5YtRHHUGB/lGQLmBvKenlxYxVN83lyYY0RNQ==
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr3608506wmf.60.1579707890287;
        Wed, 22 Jan 2020 07:44:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id q3sm4358926wmj.38.2020.01.22.07.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 07:44:49 -0800 (PST)
Subject: Re: [PATCH] svm/avic: iommu/amd: Flush IOMMU IRT after update all
 entries
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Cc:     "joro@8bytes.org" <joro@8bytes.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
References: <20190320081432.2606-1-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d599b411-3f1e-c67e-dd39-ad4ef42764e7@redhat.com>
Date:   Wed, 22 Jan 2020 16:44:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190320081432.2606-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/19 09:14, Suthikulpanit, Suravee wrote:
> When AVIC is enabled and the VM has discrete device assignment,
> the interrupt remapping table (IRT) is used to keep track of which
> destination APIC ID the IOMMU will inject the device interrput to.
> 
> This means every time a vcpu is blocked or context-switched (i.e.
> vcpu_blocking/unblocking() and vcpu_load/put()), the information
> in IRT must be updated and the IOMMU IRT flush command must be
> issued.
> 
> The current implementation flushes IOMMU IRT every time an entry
> is modified. If the assigned device has large number of interrupts
> (hence large number of entries), this would add large amount of
> overhead to vcpu context-switch. Instead, this can be optmized by
> only flush IRT once per vcpu context-switch per device after all
> IRT entries are modified.
> 
> The function amd_iommu_update_ga() is refactored to only update
> IRT entry, while the amd_iommu_sync_ga() is introduced to allow
> IRT flushing to be done separately.
> 
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm.c        | 35 ++++++++++++++++++++++++++++++++++-
>  drivers/iommu/amd_iommu.c | 20 +++++++++++++++++---
>  include/linux/amd-iommu.h | 13 ++++++++++---
>  3 files changed, 61 insertions(+), 7 deletions(-)

I found this patch in my inbox...  I'd rather avoid allocating 8k of RAM
per vCPU.  Can you make it per-VM?

Paolo

> +	/*
> +	 * Bitmap used to store PCI devid to sync
> +	 * AMD IOMMU interrupt remapping table
> +	 */
> +	unsigned long *avic_devid_sync_bitmap;
>  };
>  
>  /*
> @@ -1984,6 +1992,7 @@ static inline int
>  avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
>  {
>  	int ret = 0;
> +	int devid = 0;
>  	unsigned long flags;
>  	struct amd_svm_iommu_ir *ir;
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -2001,9 +2010,21 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
>  		goto out;
>  
>  	list_for_each_entry(ir, &svm->ir_list, node) {
> -		ret = amd_iommu_update_ga(cpu, r, ir->data);
> +		ret = amd_iommu_update_ga(cpu, r, ir->data, &devid);
>  		if (ret)
>  			break;
> +		set_bit(devid, svm->avic_devid_sync_bitmap);
> +	}
> +
> +	/* Sync AMD IOMMU interrupt remapping table changes for each device. */
> +	devid = find_next_bit(svm->avic_devid_sync_bitmap,
> +			      AVIC_DEVID_BITMAP_SIZE, 0);
> +
> +	while (devid < AVIC_DEVID_BITMAP_SIZE) {
> +		clear_bit(devid, svm->avic_devid_sync_bitmap);
> +		ret = amd_iommu_sync_ga(devid);
> +		devid = find_next_bit(svm->avic_devid_sync_bitmap,
> +				      AVIC_DEVID_BITMAP_SIZE, devid+1);
>  	}
>  out:
>  	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
> @@ -2107,6 +2128,13 @@ static int avic_init_vcpu(struct vcpu_svm *svm)
>  	INIT_LIST_HEAD(&svm->ir_list);
>  	spin_lock_init(&svm->ir_list_lock);
>  
> +	svm->avic_devid_sync_bitmap = (void *)__get_free_pages(
> +					GFP_KERNEL | __GFP_ZERO,
> +					get_order(AVIC_DEVID_BITMAP_SIZE/8));
> +	if (svm->avic_devid_sync_bitmap == NULL)
> +		ret = -ENOMEM;
> +	memset(svm->avic_devid_sync_bitmap, 0, AVIC_DEVID_BITMAP_SIZE/8);
> +
>  	return ret;
>  }
>  
> @@ -2221,6 +2249,11 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
>  	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
>  	__free_page(virt_to_page(svm->nested.hsave));
>  	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
> +
> +	free_pages((unsigned long)svm->avic_devid_sync_bitmap,
> +		   get_order(AVIC_DEVID_BITMAP_SIZE/8));
> +	svm->avic_devid_sync_bitmap = NULL;
> +
>  	kvm_vcpu_uninit(vcpu);
>  	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.guest_fpu);
>  	kmem_cache_free(kvm_vcpu_cache, svm);
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index 2a7b78bb98b4..637bcc9192e5 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -4499,7 +4499,20 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
>  	return 0;
>  }
>  
> -int amd_iommu_update_ga(int cpu, bool is_run, void *data)
> +int amd_iommu_sync_ga(int devid)
> +{
> +	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
> +
> +	if (!iommu)
> +		return -ENODEV;
> +
> +	iommu_flush_irt(iommu, devid);
> +	iommu_completion_wait(iommu);
> +	return 0;
> +}
> +EXPORT_SYMBOL(amd_iommu_sync_ga);
> +
> +int amd_iommu_update_ga(int cpu, bool is_run, void *data, int *id)
>  {
>  	unsigned long flags;
>  	struct amd_iommu *iommu;
> @@ -4521,6 +4534,9 @@ int amd_iommu_update_ga(int cpu, bool is_run, void *data)
>  	if (!table)
>  		return -ENODEV;
>  
> +	if (id)
> +		*id = devid;
> +
>  	raw_spin_lock_irqsave(&table->lock, flags);
>  
>  	if (ref->lo.fields_vapic.guest_mode) {
> @@ -4536,8 +4552,6 @@ int amd_iommu_update_ga(int cpu, bool is_run, void *data)
>  
>  	raw_spin_unlock_irqrestore(&table->lock, flags);
>  
> -	iommu_flush_irt(iommu, devid);
> -	iommu_completion_wait(iommu);
>  	return 0;
>  }
>  EXPORT_SYMBOL(amd_iommu_update_ga);
> diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
> index 09751d349963..b94d4b33dfd7 100644
> --- a/include/linux/amd-iommu.h
> +++ b/include/linux/amd-iommu.h
> @@ -193,8 +193,9 @@ static inline int amd_iommu_detect(void) { return -ENODEV; }
>  /* IOMMU AVIC Function */
>  extern int amd_iommu_register_ga_log_notifier(int (*notifier)(u32));
>  
> -extern int
> -amd_iommu_update_ga(int cpu, bool is_run, void *data);
> +extern int amd_iommu_update_ga(int cpu, bool is_run, void *data, int *devid);
> +
> +extern int amd_iommu_sync_ga(int devid);
>  
>  #else /* defined(CONFIG_AMD_IOMMU) && defined(CONFIG_IRQ_REMAP) */
>  
> @@ -205,7 +206,13 @@ amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
>  }
>  
>  static inline int
> -amd_iommu_update_ga(int cpu, bool is_run, void *data)
> +amd_iommu_update_ga(int cpu, bool is_run, void *data, int *devid)
> +{
> +	return 0;
> +}
> +
> +static inline int
> +amd_iommu_sync_ga(int devid)
>  {
>  	return 0;
>  }
> 

