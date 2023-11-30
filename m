Return-Path: <kvm+bounces-2982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F3D7FF858
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AD792817FC
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA3CD58104;
	Thu, 30 Nov 2023 17:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jc5I9awe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDF110D1
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701365597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utEKCvi3Mxs8/wKWs/wFnw+4sKW1Lht1FkWRA71th2s=;
	b=Jc5I9aweA5cDWNIujOsETsBH3XMrhQyuFkhpFadOmH4vxH7vjcTsCeq2Yr6Wp9ksK32B0z
	jbjJwDlYMqXlUUZAMIasgaSSrQ606z4vVkfECWbcZ0Ncke2Jr24WB850DxbluuXar9nuWu
	KiibSvBs1BaT1byoYDcSN6ktxrhZbnM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-EG2I6RdOMd2fQ5K4LpN-eQ-1; Thu, 30 Nov 2023 12:33:16 -0500
X-MC-Unique: EG2I6RdOMd2fQ5K4LpN-eQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a18768e26a1so100199066b.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:33:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701365595; x=1701970395;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=utEKCvi3Mxs8/wKWs/wFnw+4sKW1Lht1FkWRA71th2s=;
        b=GDIvqwapGhPMWRv4JfHU/WQwSDkICj3YVPBKRQsFW9B8RLvJ/9+p4fMj2uMPY/FA3a
         zWeUp1nIXYnMTrs/tUuzK1NVqXdDbAI6wBbaEesQJpLGpFDSAwz6a07ANPR+OydDEcxL
         ssQ7+ckwCcusvHQdmbdSJdTbMv4hACWXEbLP/Y1+QzunzAVbmJfJjUo5jXzds3SYs5IY
         UAQdo5tTR7sbqTSM5fmOv68hpkwo60U/hoKVb60QXLOpleIZGvCt333lsjQ0/VleipiA
         5HB8LYNKED/O9+CklIRfF6rvaBs+TmG8rTRrIPo0+nAcGd+oJyEXKW570zvjcCPamVZR
         bn/g==
X-Gm-Message-State: AOJu0Yy4TT3LnkRzjveBfJZzLidgh4RxwZOcQjC/J2KmF1UPGgskbluO
	Y2xU+r/IiYharfqFlxHnT5W8jD+EXK7KZVlkaimpAt8x7m/cCZxKZJFGjtjpUluPx31h+QRFOp2
	lyd4Mi1VzWtsioXDWGhEA
X-Received: by 2002:a17:906:118:b0:a11:2ad2:6563 with SMTP id 24-20020a170906011800b00a112ad26563mr168eje.26.1701365594879;
        Thu, 30 Nov 2023 09:33:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpy3Gr5M3fCLKDTAd83unfhlFE0DziiM+WQGw754XRPWR2jJ3oNb5aPpzgpNBXdcE2CgCWYg==
X-Received: by 2002:a05:6512:3b1f:b0:509:8fbf:7af0 with SMTP id f31-20020a0565123b1f00b005098fbf7af0mr42056lfv.69.1701365231787;
        Thu, 30 Nov 2023 09:27:11 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056512350400b0050aa8c0dfc3sm210133lfs.31.2023.11.30.09.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:27:11 -0800 (PST)
Message-ID: <13aaf1272737737c29ab1de22438695637944d24.camel@redhat.com>
Subject: Re: [PATCH v7 03/26] x86/fpu/xstate: Add CET supervisor mode state
 support
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:27:09 +0200
In-Reply-To: <20231124055330.138870-4-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-4-weijiang.yang@intel.com>
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
> Add supervisor mode state support within FPU xstate management framework.
> Although supervisor shadow stack is not enabled/used today in kernel,KVM
> requires the support because when KVM advertises shadow stack feature to
> guest, architecturally it claims the support for both user and supervisor
> modes for guest OSes(Linux or non-Linux).
> 
> CET supervisor states not only includes PL{0,1,2}_SSP but also IA32_S_CET
> MSR, but the latter is not xsave-managed. In virtualization world, guest
> IA32_S_CET is saved/stored into/from VM control structure. With supervisor
> xstate support, guest supervisor mode shadow stack state can be properly
> saved/restored when 1) guest/host FPU context is swapped 2) vCPU
> thread is sched out/in.
> 
> The alternative is to enable it in KVM domain, but KVM maintainers NAKed
> the solution. The external discussion can be found at [*], it ended up
> with adding the support in kernel instead of KVM domain.
> 
> Note, in KVM case, guest CET supervisor state i.e., IA32_PL{0,1,2}_MSRs,
> are preserved after VM-Exit until host/guest fpstates are swapped, but
> since host supervisor shadow stack is disabled, the preserved MSRs won't
> hurt host.
> 
> [*]: https://lore.kernel.org/all/806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com/
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/fpu/types.h  | 14 ++++++++++++--
>  arch/x86/include/asm/fpu/xstate.h |  6 +++---
>  arch/x86/kernel/fpu/xstate.c      |  6 +++++-
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
> index eb810074f1e7..c6fd13a17205 100644
> --- a/arch/x86/include/asm/fpu/types.h
> +++ b/arch/x86/include/asm/fpu/types.h
> @@ -116,7 +116,7 @@ enum xfeature {
>  	XFEATURE_PKRU,
>  	XFEATURE_PASID,
>  	XFEATURE_CET_USER,
> -	XFEATURE_CET_KERNEL_UNUSED,
> +	XFEATURE_CET_KERNEL,
>  	XFEATURE_RSRVD_COMP_13,
>  	XFEATURE_RSRVD_COMP_14,
>  	XFEATURE_LBR,
> @@ -139,7 +139,7 @@ enum xfeature {
>  #define XFEATURE_MASK_PKRU		(1 << XFEATURE_PKRU)
>  #define XFEATURE_MASK_PASID		(1 << XFEATURE_PASID)
>  #define XFEATURE_MASK_CET_USER		(1 << XFEATURE_CET_USER)
> -#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL_UNUSED)
> +#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL)
>  #define XFEATURE_MASK_LBR		(1 << XFEATURE_LBR)
>  #define XFEATURE_MASK_XTILE_CFG		(1 << XFEATURE_XTILE_CFG)
>  #define XFEATURE_MASK_XTILE_DATA	(1 << XFEATURE_XTILE_DATA)
> @@ -264,6 +264,16 @@ struct cet_user_state {
>  	u64 user_ssp;
>  };
>  
> +/*
> + * State component 12 is Control-flow Enforcement supervisor states
> + */
> +struct cet_supervisor_state {
> +	/* supervisor ssp pointers  */
> +	u64 pl0_ssp;
> +	u64 pl1_ssp;
> +	u64 pl2_ssp;
> +};
> +
>  /*
>   * State component 15: Architectural LBR configuration state.
>   * The size of Arch LBR state depends on the number of LBRs (lbr_depth).
> diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
> index d4427b88ee12..3b4a038d3c57 100644
> --- a/arch/x86/include/asm/fpu/xstate.h
> +++ b/arch/x86/include/asm/fpu/xstate.h
> @@ -51,7 +51,8 @@
>  
>  /* All currently supported supervisor features */
>  #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
> -					    XFEATURE_MASK_CET_USER)
> +					    XFEATURE_MASK_CET_USER | \
> +					    XFEATURE_MASK_CET_KERNEL)
>  
>  /*
>   * A supervisor state component may not always contain valuable information,
> @@ -78,8 +79,7 @@
>   * Unsupported supervisor features. When a supervisor feature in this mask is
>   * supported in the future, move it to the supported supervisor feature mask.
>   */
> -#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT | \
> -					      XFEATURE_MASK_CET_KERNEL)
> +#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT)
>  
>  /* All supervisor states including supported and unsupported states. */
>  #define XFEATURE_MASK_SUPERVISOR_ALL (XFEATURE_MASK_SUPERVISOR_SUPPORTED | \
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index 6e50a4251e2b..b57d909facca 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -51,7 +51,7 @@ static const char *xfeature_names[] =
>  	"Protection Keys User registers",
>  	"PASID state",
>  	"Control-flow User registers",
> -	"Control-flow Kernel registers (unused)",
> +	"Control-flow Kernel registers",
>  	"unknown xstate feature",
>  	"unknown xstate feature",
>  	"unknown xstate feature",
> @@ -73,6 +73,7 @@ static unsigned short xsave_cpuid_features[] __initdata = {
>  	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
>  	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
>  	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
> +	[XFEATURE_CET_KERNEL]			= X86_FEATURE_SHSTK,
>  	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
>  	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
>  };
> @@ -277,6 +278,7 @@ static void __init print_xstate_features(void)
>  	print_xstate_feature(XFEATURE_MASK_PKRU);
>  	print_xstate_feature(XFEATURE_MASK_PASID);
>  	print_xstate_feature(XFEATURE_MASK_CET_USER);
> +	print_xstate_feature(XFEATURE_MASK_CET_KERNEL);
>  	print_xstate_feature(XFEATURE_MASK_XTILE_CFG);
>  	print_xstate_feature(XFEATURE_MASK_XTILE_DATA);
>  }
> @@ -346,6 +348,7 @@ static __init void os_xrstor_booting(struct xregs_state *xstate)
>  	 XFEATURE_MASK_BNDCSR |			\
>  	 XFEATURE_MASK_PASID |			\
>  	 XFEATURE_MASK_CET_USER |		\
> +	 XFEATURE_MASK_CET_KERNEL |		\
>  	 XFEATURE_MASK_XTILE)
>  
>  /*
> @@ -546,6 +549,7 @@ static bool __init check_xstate_against_struct(int nr)
>  	case XFEATURE_PASID:	  return XCHECK_SZ(sz, nr, struct ia32_pasid_state);
>  	case XFEATURE_XTILE_CFG:  return XCHECK_SZ(sz, nr, struct xtile_cfg);
>  	case XFEATURE_CET_USER:	  return XCHECK_SZ(sz, nr, struct cet_user_state);
> +	case XFEATURE_CET_KERNEL: return XCHECK_SZ(sz, nr, struct cet_supervisor_state);
>  	case XFEATURE_XTILE_DATA: check_xtile_data_against_struct(sz); return true;
>  	default:
>  		XSTATE_WARN_ON(1, "No structure for xstate: %d\n", nr);

Any reason why my reviewed-by was not added to this patch?

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



