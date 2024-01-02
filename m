Return-Path: <kvm+bounces-5471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7863C8224C4
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:33:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AA65B22207
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E9F17731;
	Tue,  2 Jan 2024 22:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hsWhkkuQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E499517725
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 22:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704234783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=292EYekmNs4JFV4FXHbDVJ2CzL6/2QZNvmkFFwcUOVs=;
	b=hsWhkkuQV3DhpSl1wKx4cvK9TaD+UqAZtiMZ12eu9uwAgr32BePtJU98u+Cfc7TdUh3k6t
	EMJdRzzQrE45SlyOQOVdpIopMxiYrgtJvw2lOPUOWwppywMkVBPCOy4vHplEGk9/pmrJ/A
	1J+ZaWttjnzMUIvbHbcySofOOym/Otg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-jcPvPNEiPtOSGQ1IRPkvOw-1; Tue, 02 Jan 2024 17:33:00 -0500
X-MC-Unique: jcPvPNEiPtOSGQ1IRPkvOw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3367c893deeso6983165f8f.2
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 14:33:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704234779; x=1704839579;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=292EYekmNs4JFV4FXHbDVJ2CzL6/2QZNvmkFFwcUOVs=;
        b=oDG7ZObr7vJWRTYFR88rAsk6VvTGclk9oCNVemFCnVkMoZESqDxiNgDq/fEeyGs6xK
         w+88QQdCXmuBVz16Rg2yEnWQP4z6Udh95ZPdCu7uEbgAb2EP08LEMBwOvcDljwh0NpqC
         J+gZdlsH4P90EZS9UMvBGWVHZJV3zr/YFsq04pGim9ZH0nq7BAX8k0Pr9FV48O2Ts6JM
         VmpYgOKW8zQe2h3adexwRXGIFWU+QraNz+taElvFEXU/2QrC3yEOH1IWQHjMIKiMNQP/
         Qjr0pKTAMnaQdI6m4HratqqbD+Aj9an0vvS9RX7gaW2gPEjVFatbiQSAmr9vn8VdxPyK
         ha0g==
X-Gm-Message-State: AOJu0YwpeqKPPdW7Vd8xQ1wJ4yD/hrnnxcZzpPGBI1/EpdrWBPlhGk91
	8lb9iHZkPNLsww2S6v18kuyZxZ9hjFhwUZsy24OZrGmhwo1oAKDvfd6vfSaW9drHKAwW36j/N3O
	QGAQ5CRiYTtp/2q34ZOg8
X-Received: by 2002:a5d:40c8:0:b0:336:6eba:b0ff with SMTP id b8-20020a5d40c8000000b003366ebab0ffmr9052064wrq.94.1704234779563;
        Tue, 02 Jan 2024 14:32:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHGnt3hTwcUmqBp3itxNA3pVpP/rkblmR2Q8SKgX/qEhxCsTHHbd5/xN8eNOIoUVll5LtIx0g==
X-Received: by 2002:a5d:40c8:0:b0:336:6eba:b0ff with SMTP id b8-20020a5d40c8000000b003366ebab0ffmr9052052wrq.94.1704234779204;
        Tue, 02 Jan 2024 14:32:59 -0800 (PST)
Received: from starship ([147.235.223.38])
        by smtp.gmail.com with ESMTPSA id q28-20020adfab1c000000b0033690139ea5sm27133785wrc.44.2024.01.02.14.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 14:32:58 -0800 (PST)
Message-ID: <a49438920b228a98ef65b6136b3cb93faf144636.camel@redhat.com>
Subject: Re: [PATCH v8 06/26] x86/fpu/xstate: Create guest fpstate with
 guest specific config
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Wed, 03 Jan 2024 00:32:57 +0200
In-Reply-To: <20231221140239.4349-7-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-7-weijiang.yang@intel.com>
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
> Use fpu_guest_cfg to calculate guest fpstate settings, open code for
> __fpstate_reset() to avoid using kernel FPU config.
> 
> Below configuration steps are currently enforced to get guest fpstate:
> 1) Kernel sets up guest FPU settings in fpu__init_system_xstate().
> 2) User space sets vCPU thread group xstate permits via arch_prctl().
> 3) User space creates guest fpstate via __fpu_alloc_init_guest_fpstate()
>    for vcpu thread.
> 4) User space enables guest dynamic xfeatures and re-allocate guest
>    fpstate.
> 
> By adding kernel dynamic xfeatures in above #1 and #2, guest xstate area
> size is expanded to hold (fpu_kernel_cfg.default_features | kernel dynamic
> xfeatures | user dynamic xfeatures), then host xsaves/xrstors can operate
> for all guest xfeatures.
> 
> The user_* fields remain unchanged for compatibility with KVM uAPIs.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kernel/fpu/core.c | 47 ++++++++++++++++++++++++++++++--------
>  1 file changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 976f519721e2..0e0bf151418f 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -250,8 +250,6 @@ void fpu_reset_from_exception_fixup(void)
>  }
>  
>  #if IS_ENABLED(CONFIG_KVM)
> -static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
> -
>  static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
>  {
>  	struct fpu_state_perm *fpuperm;
> @@ -272,25 +270,54 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
>  	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
>  }
>  
> -bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
> +static struct fpstate *__fpu_alloc_init_guest_fpstate(struct fpu_guest *gfpu)
>  {
> +	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
> +	unsigned int gfpstate_size, size;
>  	struct fpstate *fpstate;
> -	unsigned int size;
>  
> -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
> +	/*
> +	 * fpu_guest_cfg.default_size is initialized to hold all enabled
> +	 * xfeatures except the user dynamic xfeatures. If the user dynamic
> +	 * xfeatures are enabled, the guest fpstate will be re-allocated to
> +	 * hold all guest enabled xfeatures, so omit user dynamic xfeatures
> +	 * here.
> +	 */
> +	size = fpu_guest_cfg.default_size +
> +	       ALIGN(offsetof(struct fpstate, regs), 64);
> +
>  	fpstate = vzalloc(size);
>  	if (!fpstate)
> -		return false;
> +		return NULL;
> +	/*
> +	 * Initialize sizes and feature masks, use fpu_user_cfg.*
> +	 * for user_* settings for compatibility of exiting uAPIs.
> +	 */
> +	fpstate->size		= gfpstate_size;
> +	fpstate->xfeatures	= fpu_guest_cfg.default_features;
> +	fpstate->user_size	= fpu_user_cfg.default_size;
> +	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
> +	fpstate->xfd		= 0;
>  
> -	/* Leave xfd to 0 (the reset value defined by spec) */
> -	__fpstate_reset(fpstate, 0);
>  	fpstate_init_user(fpstate);
>  	fpstate->is_valloc	= true;
>  	fpstate->is_guest	= true;
>  
>  	gfpu->fpstate		= fpstate;
> -	gfpu->xfeatures		= fpu_user_cfg.default_features;
> -	gfpu->perm		= fpu_user_cfg.default_features;
> +	gfpu->xfeatures		= fpu_guest_cfg.default_features;
> +	gfpu->perm		= fpu_guest_cfg.default_features;
> +
> +	return fpstate;
> +}
> +
> +bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
> +{
> +	struct fpstate *fpstate;
> +
> +	fpstate = __fpu_alloc_init_guest_fpstate(gfpu);
> +
> +	if (!fpstate)
> +		return false;
>  
>  	/*
>  	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




