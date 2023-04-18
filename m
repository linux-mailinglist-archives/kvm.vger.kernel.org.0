Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EB96E5968
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 08:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjDRG2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 02:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDRG2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 02:28:53 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1950119;
        Mon, 17 Apr 2023 23:28:51 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4edc0fb9cd0so190129e87.0;
        Mon, 17 Apr 2023 23:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681799330; x=1684391330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZOdz4WwFvClDdEK2CHpChDMbb40phaDol5nwMNd725k=;
        b=oscPqOm/ZpiUKyu7rda8U7ifmN0+hWBhp3LUTAtlMCmzHuTdo60fKpvZpRsDKJPibu
         jwBvTL3Evr2xYfT6jWBFkrTKaweJhMlzAQhS2l57au3IeUA4TEEzBAPUqBv0ibCi0nMk
         Kik7lP/FzGLr2qe6pgjtqXBPUbDsLkfyappIZSv7cIpoylMHzLYwSaI9abjdfs8iDLyM
         xlbs+YKvwQ+GcuoDjp2j52QwX3GMImBMN757RBI4lH+qqi4bw2lft7W9xM/AUvrzRAyo
         xcl6egOat5HDvf7y4OHhv4hIDaizKYZ9JP26Ik9n/yxS4l/GQg391KGjuUqe40wERxiO
         K8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681799330; x=1684391330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZOdz4WwFvClDdEK2CHpChDMbb40phaDol5nwMNd725k=;
        b=auQ4hVO91wbNcF2DKdBdQuHeuSYLPLqHzT0/eKZvu77SKZtLgXCiADIBjfga1Bvkpb
         bSyB+rG6MlnRjWniko0DxRm68xcdz+zJ4IfiJvmJAVBeZ/zctslhJA5RPOhzH2027AaD
         fAdbb1uicdy5KTUPDmAYJ2ejB3XJFglEkvuV9c8PxnFqsrBhimSg8Qh/tE+8WoZY/hq/
         rC4YpXoZzkJNgARzWQDlt3fXq8wpZHMjneTonATF2AF2rHGNjW6KI+edFwO9I/Lw7Z0J
         wX4e4/7ZvJNf9ohcqwssWMdtiLlg6o9c9okB5NB7min2NWL/pWW+AScFbGktJW7zSnV+
         d1Ng==
X-Gm-Message-State: AAQBX9eKmGlGIUErCtUI28JTq+JCUgkrDotwEN5bYgp0JwSDtA8X0+Np
        Tk4RaPW5zYJBQyjqI/Zihwg=
X-Google-Smtp-Source: AKy350bPMj9HUy7PDo/KsiNeiuDSqJaWUlCDiikfgjX9ts0d42qo+U1eLtrmwd36a7V5PnV/pcLHWg==
X-Received: by 2002:a05:651c:2111:b0:29d:6dd5:d712 with SMTP id a17-20020a05651c211100b0029d6dd5d712mr4630608ljq.2.1681799329701;
        Mon, 17 Apr 2023 23:28:49 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id 2-20020a2eb282000000b00298a8527806sm2459825ljx.93.2023.04.17.23.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 23:28:49 -0700 (PDT)
Date:   Tue, 18 Apr 2023 09:28:30 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH 3/5] KVM: TDX: Add base implementation for
 tdx_vm_move_enc_context_from
Message-ID: <20230418092830.00001bff.zhi.wang.linux@gmail.com>
In-Reply-To: <20230407201921.2703758-4-sagis@google.com>
References: <20230407201921.2703758-1-sagis@google.com>
        <20230407201921.2703758-4-sagis@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Apr 2023 20:19:19 +0000
Sagi Shahar <sagis@google.com> wrote:

Is there any reaon that TDX doesn't need .vm_copy_enc_context_from? Or it is
going to be deprecated? The patch comments needs to be refined according to
Sean's KVM x86 maintainer book.

> This should mostly match the logic in sev_vm_move_enc_context_from.
> 
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 10 +++++++
>  arch/x86/kvm/vmx/tdx.c     | 56 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h     |  2 ++
>  arch/x86/kvm/vmx/x86_ops.h |  5 ++++
>  4 files changed, 73 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 5b64fe5404958..9d5d0ac465bf6 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -979,6 +979,14 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  	return tdx_vcpu_ioctl(vcpu, argp);
>  }
>  
> +static int vt_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
> +{
> +	if (!is_td(kvm))
> +		return -ENOTTY;
> +
> +	return tdx_vm_move_enc_context_from(kvm, source_fd);
> +}
> +
>  #define VMX_REQUIRED_APICV_INHIBITS		       \
>  (						       \
>         BIT(APICV_INHIBIT_REASON_DISABLE)|	       \
> @@ -1141,6 +1149,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.dev_mem_enc_ioctl = tdx_dev_ioctl,
>  	.mem_enc_ioctl = vt_mem_enc_ioctl,
>  	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
> +
> +	.vm_move_enc_context_from = vt_move_enc_context_from,
>  };
>  
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8af7e4e81c860..0999a6d827c99 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2826,3 +2826,59 @@ int __init tdx_init(void)
>  		INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, cpu));
>  	return 0;
>  }
> +
> +static __always_inline bool tdx_guest(struct kvm *kvm)
> +{
> +	struct kvm_tdx *tdx_kvm = to_kvm_tdx(kvm);
> +
> +	return tdx_kvm->finalized;
> +}
> +
> +static int tdx_migrate_from(struct kvm *dst, struct kvm *src)
> +{
> +	return -EINVAL;
> +}
> +
> +int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
> +{
> +	struct kvm_tdx *dst_tdx = to_kvm_tdx(kvm);
> +	struct file *src_kvm_file;
> +	struct kvm_tdx *src_tdx;
> +	struct kvm *src_kvm;
> +	int ret;
> +
> +	src_kvm_file = fget(source_fd);
> +	if (!file_is_kvm(src_kvm_file)) {
> +		ret = -EBADF;
> +		goto out_fput;
> +	}
> +	src_kvm = src_kvm_file->private_data;
> +	src_tdx = to_kvm_tdx(src_kvm);
> +
> +	ret = pre_move_enc_context_from(kvm, src_kvm,
> +					&dst_tdx->migration_in_progress,
> +					&src_tdx->migration_in_progress);
> +	if (ret)
> +		goto out_fput;
> +
> +	if (tdx_guest(kvm) || !tdx_guest(src_kvm)) {
> +		ret = -EINVAL;
> +		goto out_post;
> +	}
> +
> +	ret = tdx_migrate_from(kvm, src_kvm);
> +	if (ret)
> +		goto out_post;
> +
> +	kvm_vm_dead(src_kvm);
> +	ret = 0;
> +
> +out_post:
> +	post_move_enc_context_from(kvm, src_kvm,
> +				 &dst_tdx->migration_in_progress,
> +				 &src_tdx->migration_in_progress);
> +out_fput:
> +	if (src_kvm_file)
> +		fput(src_kvm_file);
> +	return ret;
> +}
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 71818c5001862..21b7e710be1fd 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -24,6 +24,8 @@ struct kvm_tdx {
>  	atomic_t tdh_mem_track;
>  
>  	u64 tsc_offset;
> +
> +	atomic_t migration_in_progress;
>  };
>  
>  union tdx_exit_reason {
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index d049e0c72ed0c..275f5d75e9bf1 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -187,6 +187,8 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>  void tdx_flush_tlb(struct kvm_vcpu *vcpu);
>  int tdx_sept_tlb_remote_flush(struct kvm *kvm);
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
> +
> +int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
>  #else
>  static inline int tdx_init(void) { return 0; };
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
> @@ -241,6 +243,9 @@ static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { ret
>  static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
>  static inline int tdx_sept_tlb_remote_flush(struct kvm *kvm) { return 0; }
>  static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
> +
> +static inline int tdx_vm_move_enc_context_from(struct kvm *kvm, u
> +					       nsigned int source_fd) { return -EOPNOTSUPP; }
>  #endif
>  
>  #if defined(CONFIG_INTEL_TDX_HOST) && defined(CONFIG_KVM_SMM)

