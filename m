Return-Path: <kvm+bounces-5470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C0758224C1
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 738661C22B97
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D21B4171D6;
	Tue,  2 Jan 2024 22:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UdRto9qe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C03171C3
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 22:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704234761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZWAUMBD4WpjvgME04ausubUmZEwEtd2McIzhOXVttXg=;
	b=UdRto9qeb5uIBum5iHJiCynmsK/LGPNfE6X+1yVw1EyZlsRJcYZ3N93wvRcxwgY2fF8uDA
	Y3OCPy7dGexa7WLUP7Ttf/xW6+dpVIfM9LgVYfxO+h1lypk40amUrPxI5ENorMQ50WCMuk
	6hVNqHTaEoiEhQnmSyx+xtw8h6KpAE0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-scajLnW_P9Se_mJzAFfmAQ-1; Tue, 02 Jan 2024 17:32:40 -0500
X-MC-Unique: scajLnW_P9Se_mJzAFfmAQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40d8f402742so2145855e9.1
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 14:32:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704234759; x=1704839559;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZWAUMBD4WpjvgME04ausubUmZEwEtd2McIzhOXVttXg=;
        b=tv/2jIaB4FzKg6mDLNCJ3INUJim8y0EQjKo5vB5Dl3TkSpqvJPAZAFwbV4t+MoWe8s
         +92fp6EJtJJtYlHcn43RbD04WrQWvtm+lURzqIiOFgNgrz5xrJKMMnVx7A+DYQCI9s5f
         TCOHJ2gNzVKE0GP14XdH/dFXBH8wUItZLCCGzQ2v55W/DuHZbJDm3Q8nCd3n4Yw5qHLI
         dwODuIYcc0spvdKAHSHr6515BJHg9rWFJQJKYBWBtJKbE3gzwp7Sh7syeRYUriGqBLDd
         wsTDC7QygmOQHaghI7QHDsQbiMryLl3n/Z97gG3rja3cK9iFgZNo+ucbTnCFUCqCe8Xx
         Pzcw==
X-Gm-Message-State: AOJu0YybEQuH3OU8LOxsZj2vaeH08MsZP5Yo2euHECjOWuj9FAZGxIsA
	Nif2Oxfn7iE76dfkYyXiR2aTCr7UlFR0s37tsskef5IEymM4eFuV9l7Fhqalv1riADJjZVB9PmB
	2T3JZbytLDlWnNwgrbr6g
X-Received: by 2002:a05:600c:4444:b0:40d:8392:2158 with SMTP id v4-20020a05600c444400b0040d83922158mr2680004wmn.19.1704234759250;
        Tue, 02 Jan 2024 14:32:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH9s+wrfmzvywo9XTtJmItKskqbVS4fTQvrSWIOM585yQRUhOBDQ2O5DjgLaikFkXujLFrMSQ==
X-Received: by 2002:a05:600c:4444:b0:40d:8392:2158 with SMTP id v4-20020a05600c444400b0040d83922158mr2680002wmn.19.1704234758963;
        Tue, 02 Jan 2024 14:32:38 -0800 (PST)
Received: from starship ([147.235.223.38])
        by smtp.gmail.com with ESMTPSA id hn33-20020a05600ca3a100b0040d5ae2905asm326542wmb.30.2024.01.02.14.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 14:32:38 -0800 (PST)
Message-ID: <4ba9edb3f988314637052321d339e41938dfe196.camel@redhat.com>
Subject: Re: [PATCH v8 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Wed, 03 Jan 2024 00:32:36 +0200
In-Reply-To: <20231221140239.4349-6-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-6-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-12-21 at 09:02 -0500, Yang Weijiang wrote:
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
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/fpu/types.h |  2 +-
>  arch/x86/kernel/fpu/core.c       | 70 ++++++++++++++++++++++++++++++--
>  arch/x86/kernel/fpu/xstate.c     | 10 +++++
>  3 files changed, 78 insertions(+), 4 deletions(-)
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
> index a21a4d0ecc34..976f519721e2 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -33,10 +33,67 @@ DEFINE_STATIC_KEY_FALSE(__fpu_state_size_dynamic);
>  DEFINE_PER_CPU(u64, xfd_state);
>  #endif
>  
> -/* The FPU state configuration data for kernel and user space */
> +/* The FPU state configuration data for kernel, user space and guest. */
> +/*
> + * kernel FPU config:
> + *
> + * all known and CPU supported user and supervisor features except
> + *  - independent kernel features (XFEATURE_LBR)
> + * @fpu_kernel_cfg.max_features;
> + *
> + * all known and CPU supported user and supervisor features except
> + *  - dynamic kernel features (CET_S)
> + *  - independent kernel features (XFEATURE_LBR)
> + *  - dynamic userspace features (AMX state)
> + * @fpu_kernel_cfg.default_features;
> + *
> + * size of compacted buffer with 'fpu_kernel_cfg.max_features'
> + * @fpu_kernel_cfg.max_size;
> + *
> + * size of compacted buffer with 'fpu_kernel_cfg.default_features'
> + * @fpu_kernel_cfg.default_size;
> + */
>  struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
> +
> +/*
> + * user FPU config:
> + *
> + * all known and CPU supported user features
> + * @fpu_user_cfg.max_features;
> + *
> + * all known and CPU supported user features except
> + *  - dynamic userspace features (AMX state)
> + * @fpu_user_cfg.default_features;
> + *
> + * size of non-compacted buffer with 'fpu_user_cfg.max_features'
> + * @fpu_user_cfg.max_size;
> + *
> + * size of non-compacted buffer with 'fpu_user_cfg.default_features'
> + * @fpu_user_cfg.default_size;
> + */
>  struct fpu_state_config fpu_user_cfg __ro_after_init;
>  
> +/*
> + * guest FPU config:
> + *
> + * all known and CPU supported user and supervisor features except
> + *  - independent  kernel features (XFEATURE_LBR)
> + * @fpu_guest_cfg.max_features;
> + *
> + * all known and CPU supported user and supervisor features except
> + *  - independent kernel features (XFEATURE_LBR)
> + *  - dynamic userspace features (AMX state)
> + * @fpu_guest_cfg.default_features;
> + *
> + * size of compacted buffer with 'fpu_guest_cfg.max_features'
> + * @fpu_guest_cfg.max_size;
> + *
> + * size of compacted buffer with 'fpu_guest_cfg.default_features'
> + * @fpu_guest_cfg.default_size;
> + */


IMHO this comment is too verbose. I didn't intend it to be copied verbatim,
to the kernel, but rather to explain the meaning of the fpu context fields
to both of us (I also keep on forgetting what each combination means...).

At least this comment should not include examples because xfeatures
are subject to change.


Best regards,
	Maxim Levitsky


> +
> +struct fpu_state_config fpu_guest_cfg __ro_after_init;
> +
>  /*
>   * Represents the initial FPU state. It's mostly (but not completely) zeroes,
>   * depending on the FPU hardware format:
> @@ -536,8 +593,15 @@ void fpstate_reset(struct fpu *fpu)
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
> index ca4b83c142eb..9cbdc83d1eab 100644
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



