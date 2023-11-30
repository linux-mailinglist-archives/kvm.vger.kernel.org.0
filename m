Return-Path: <kvm+bounces-3001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E3C7FF94D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:27:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB9131C20DF7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F7225917C;
	Thu, 30 Nov 2023 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IuUsKMTI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45307D6C
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701368830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3AqnBDxV2gEvZjzBaw7nkpO0oqJkea/7sHU3mX1Py/Y=;
	b=IuUsKMTIt+e6BIOccte2uSA76H6YhBjPFSMMs2QFAe+pnVMgjO31HWnozalf14v0PytEtL
	JtJlBHdwzHJmXx4eF7tESoYQOT6LIdXSZc67BhU/ZmrqE/7DAtXDdJW+jJ1L+g+1puhpwx
	wZbY/Kp5DBEjFIcFupqDExihhtK2vl4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-Nj3QZ7RdPAeKILAakU3JrA-1; Thu, 30 Nov 2023 13:27:08 -0500
X-MC-Unique: Nj3QZ7RdPAeKILAakU3JrA-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-54af5527a17so1007148a12.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:27:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701368827; x=1701973627;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3AqnBDxV2gEvZjzBaw7nkpO0oqJkea/7sHU3mX1Py/Y=;
        b=eekZbO2mfr/2MekATbvicn+vnIfIe73zHHKx9Td3ucWic3ZSUdFBVMVrxCbLCKotyH
         jubxCANP22r3lSuQD6RvMaDb3qGdgjGc/4Ls/Abvy1Ijarv0QLYOGQZyfjjrvcwESrxl
         ucw+Tsbass+zLmdcSrhx6cgWDrbperubnOVkgfLZNNSoFGEJVY1GPMh76T5IfSdwpGEc
         HYbtAXkfkU+DfuiZOSutobK9fTec0wZv7vojoR3Q4KQC6PgzovVAESILCdNsHVr2ju5w
         WyASqb8etuSsZLlvzVPLWoD6lLxiFunAnEi+3cwl7OppZbGnBlaYywmXlzYZwk/4x9mg
         P2SQ==
X-Gm-Message-State: AOJu0YwBNKzv1YUcf1nhjG6drbi8bWL7sgbatwgCESU0MkVfCbVV4s2m
	MGxVj6lBi7n7caIKxLdRisPkSO+huPyksQkHzvGyv6Cr5OnkwhP1pt1qr91UAJo0X8vwKzAtdIr
	63EXyS1z3bZAijg6L4NwR
X-Received: by 2002:a05:6512:2316:b0:50b:d764:804f with SMTP id o22-20020a056512231600b0050bd764804fmr10073lfu.130.1701368668651;
        Thu, 30 Nov 2023 10:24:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7a9itJvIEBQTtAwvdJ4UOEQ6akN1jXEG3duLT0l8cpKuXcZyunVpYem1b18Tq7sXOcp/qtA==
X-Received: by 2002:a05:6512:3a91:b0:50b:c043:6285 with SMTP id q17-20020a0565123a9100b0050bc0436285mr19553lfu.49.1701365370778;
        Thu, 30 Nov 2023 09:29:30 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id r25-20020ac25f99000000b0050bc7a7a491sm209983lfe.191.2023.11.30.09.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:29:30 -0800 (PST)
Message-ID: <533fd2330aa6a854b61eea6828dbeff9f6e3ffb4.camel@redhat.com>
Subject: Re: [PATCH v7 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:29:28 +0200
In-Reply-To: <20231124055330.138870-6-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-6-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> Define new fpu_guest_cfg to hold all guest FPU settings so that it can
> differ from generic kernel FPU settings, e.g., enabling CET supervisor
> xstate by default for guest fpstate while it's remained disabled in
> kernel FPU config.
> 
> The kernel dynamic xfeatures are specifically used by guest fpstate now,
> add the mask for guest fpstate so that guest_perm.__state_permit ==
> (fpu_kernel_cfg.default_xfeature | XFEATURE_MASK_KERNEL_DYNAMIC). And
> if guest fpstate is re-allocated to hold user dynamic xfeatures, the
> resulting permissions are consumed before calculate new guest fpstate.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/fpu/types.h |  2 +-
>  arch/x86/kernel/fpu/core.c       | 14 +++++++++++---
>  arch/x86/kernel/fpu/xstate.c     | 10 ++++++++++
>  3 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
> index c6fd13a17205..306825ad6bc0 100644
> --- a/arch/x86/include/asm/fpu/types.h
> +++ b/arch/x86/include/asm/fpu/types.h
> @@ -602,6 +602,6 @@ struct fpu_state_config {
>  };
>  
>  /* FPU state configuration information */
> -extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
> +extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg, fpu_guest_cfg;
>  
>  #endif /* _ASM_X86_FPU_H */
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index a21a4d0ecc34..516af626bf6a 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -33,9 +33,10 @@ DEFINE_STATIC_KEY_FALSE(__fpu_state_size_dynamic);
>  DEFINE_PER_CPU(u64, xfd_state);
>  #endif
>  
> -/* The FPU state configuration data for kernel and user space */
> +/* The FPU state configuration data for kernel, user space and guest. */
>  struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
>  struct fpu_state_config fpu_user_cfg __ro_after_init;
> +struct fpu_state_config fpu_guest_cfg __ro_after_init;
>  
>  /*
>   * Represents the initial FPU state. It's mostly (but not completely) zeroes,
> @@ -536,8 +537,15 @@ void fpstate_reset(struct fpu *fpu)
>  	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
>  	fpu->perm.__state_size		= fpu_kernel_cfg.default_size;
>  	fpu->perm.__user_state_size	= fpu_user_cfg.default_size;
> -	/* Same defaults for guests */
> -	fpu->guest_perm = fpu->perm;
> +
> +	/* Guest permission settings */
> +	fpu->guest_perm.__state_perm	= fpu_guest_cfg.default_features;
> +	fpu->guest_perm.__state_size	= fpu_guest_cfg.default_size;
> +	/*
> +	 * Set guest's __user_state_size to fpu_user_cfg.default_size so that
> +	 * existing uAPIs can still work.
> +	 */
> +	fpu->guest_perm.__user_state_size = fpu_user_cfg.default_size;
>  }
>  
>  static inline void fpu_inherit_perms(struct fpu *dst_fpu)
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index ba4172172afd..aa8f8595cd41 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -681,6 +681,7 @@ static int __init init_xstate_size(void)
>  {
>  	/* Recompute the context size for enabled features: */
>  	unsigned int user_size, kernel_size, kernel_default_size;
> +	unsigned int guest_default_size;
>  	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
>  
>  	/* Uncompacted user space size */
> @@ -702,13 +703,18 @@ static int __init init_xstate_size(void)
>  	kernel_default_size =
>  		xstate_calculate_size(fpu_kernel_cfg.default_features, compacted);
>  
> +	guest_default_size =
> +		xstate_calculate_size(fpu_guest_cfg.default_features, compacted);
> +
>  	if (!paranoid_xstate_size_valid(kernel_size))
>  		return -EINVAL;
>  
>  	fpu_kernel_cfg.max_size = kernel_size;
>  	fpu_user_cfg.max_size = user_size;
> +	fpu_guest_cfg.max_size = kernel_size;
>  
>  	fpu_kernel_cfg.default_size = kernel_default_size;
> +	fpu_guest_cfg.default_size = guest_default_size;
>  	fpu_user_cfg.default_size =
>  		xstate_calculate_size(fpu_user_cfg.default_features, false);
>  
> @@ -829,6 +835,10 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>  	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
>  	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>  
> +	fpu_guest_cfg.max_features = fpu_kernel_cfg.max_features;
> +	fpu_guest_cfg.default_features = fpu_guest_cfg.max_features;
> +	fpu_guest_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> +
>  	/* Store it for paranoia check at the end */
>  	xfeatures = fpu_kernel_cfg.max_features;
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


