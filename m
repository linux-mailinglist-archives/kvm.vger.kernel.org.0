Return-Path: <kvm+bounces-436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B737DF9A2
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D2FF281D21
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9593D21114;
	Thu,  2 Nov 2023 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IELG1Wxv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5BA21346
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:11:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7E310F7
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lf4sz5zgZjW4weKtr+Yg6TBcTzSfkwSHJbmSokVskxk=;
	b=IELG1WxvlYH15fozsGVH5K0ChkbviYaA3GqWmbe17HaEQunFbjOgP4eG1omoddug3nDnHI
	XpwP4U0Qsm5mp0ZJ2b2/cv2rwA1ziTsxUW+oIczLnzt+JYaQFgdCcyA8N/0m0Ko28pOynu
	XGO9W1wfGDMID6no/p3xqyg1U1rwP6A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-zPan7N-4N8m5vUZ8e88UeA-1; Thu, 02 Nov 2023 14:11:02 -0400
X-MC-Unique: zPan7N-4N8m5vUZ8e88UeA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4084e4ce543so7751635e9.3
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:11:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948661; x=1699553461;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lf4sz5zgZjW4weKtr+Yg6TBcTzSfkwSHJbmSokVskxk=;
        b=xLfNiFIHw/6gZJ5pfzVVKtJZQJXh+36JJsLRq4miiYs+O5JRyXV0Fcx8lnS2Odzcpf
         m7+fgkktAKnT8YBtDWNIrZEWvlQedbdN8Mbq43DJMoM3ARTOQqhNLT48KHUsW7d8BwR6
         WM86Rmd/kSjkczR4CHkSbX9vCdiK+y4Ak/f4L0mBcewv/TupTJlRhn7uhUOQut7B7LVr
         l60wdt6SLjtKmD9TO0naOApbjGFlS5YK94HpdHFubdg6ORh7APzQztY0wQuxmZoXMJuH
         OzyfaUSyoC8XPrlcVcn7Wmo/6XEQCRtJ+Kb7Vxj7CNab8AslJadzy0Tjnc2WL23EO9xR
         zIgg==
X-Gm-Message-State: AOJu0YwNbOWqV435KwssnXpMWdfJSxF7tn7SQt3pg870/GayRpzq8EJK
	nVvBAwkyU8dkHVmmhYDJcc2zJBRmm2EpP3d4ew4mG9yUGKql0Ll10N5CUdpDDVYe2US13SBFr9d
	p5yHoZBQLvTXW
X-Received: by 2002:a5d:68c1:0:b0:32d:a022:8559 with SMTP id p1-20020a5d68c1000000b0032da0228559mr15550164wrw.47.1698948661350;
        Thu, 02 Nov 2023 11:11:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSqw020mjK/6PHY7CTNXu4NxTqG4uDaXHOXROR0+xwiATkC32fBes5AQyH3J5aI9Lka800LA==
X-Received: by 2002:a5d:68c1:0:b0:32d:a022:8559 with SMTP id p1-20020a5d68c1000000b0032da0228559mr15550151wrw.47.1698948660999;
        Thu, 02 Nov 2023 11:11:00 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id k15-20020a056000004f00b00323287186aasm3028866wrx.32.2023.11.02.11.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:11:00 -0700 (PDT)
Message-ID: <5e413e05de559971cdc2d1a9281a8a271590f62b.camel@redhat.com>
Subject: Re: [PATCH 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
From: Maxim Levitsky <mlevitsk@redhat.com>
To: John Allen <john.allen@amd.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 weijiang.yang@intel.com,  rick.p.edgecombe@intel.com, seanjc@google.com,
 x86@kernel.org,  thomas.lendacky@amd.com, bp@alien8.de
Date: Thu, 02 Nov 2023 20:10:58 +0200
In-Reply-To: <20231010200220.897953-7-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
	 <20231010200220.897953-7-john.allen@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> When a guest issues a cpuid instruction for Fn0000000D_x0B
> (CetUserOffset), KVM will intercept and need to access the guest
> MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
> included in the GHCB to be visible to the hypervisor.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  1 +
>  arch/x86/kvm/svm/sev.c     | 12 ++++++++++--
>  arch/x86/kvm/svm/svm.c     |  1 +
>  arch/x86/kvm/svm/svm.h     |  3 ++-
>  4 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 568d97084e44..5afc9e03379d 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -678,5 +678,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
>  DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
>  DEFINE_GHCB_ACCESSORS(sw_scratch)
>  DEFINE_GHCB_ACCESSORS(xcr0)
> +DEFINE_GHCB_ACCESSORS(xss)

I don't see anywhere in the patch adding xss to ghcb_save_area.
What kernel version/commit these patches are based on?

>  
>  #endif
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index bb4b18baa6f7..94ab7203525f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2445,8 +2445,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  
>  	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
>  
> -	if (kvm_ghcb_xcr0_is_valid(svm)) {
> -		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> +	if (kvm_ghcb_xcr0_is_valid(svm) || kvm_ghcb_xss_is_valid(svm)) {
> +		if (kvm_ghcb_xcr0_is_valid(svm))
> +			vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> +
> +		if (kvm_ghcb_xss_is_valid(svm))
> +			vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
> +
>  		kvm_update_cpuid_runtime(vcpu);
>  	}
>  
> @@ -3032,6 +3037,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
>  			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
>  	}
> +
> +	if (kvm_caps.supported_xss)
> +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);

This is not just a virtualization hole. This allows the guest to set MSR_IA32_XSS
to whatever value it wants, and thus it might allow XSAVES to access some host msrs
that guest must not be able to access.

AMD might not yet have such msrs, but on Intel side I do see various components
like 'HDC State', 'HWP state' and such.

I understand that this is needed so that #VC handler could read this msr, and trying
to read it will cause another #VC which is probably not allowed (I don't know this detail of SEV-ES)

I guess #VC handler should instead use a kernel cached value of this msr instead, or at least
KVM should only allow reads and not writes to it.

In addition to that, if we decide to open the read access to the IA32_XSS from the guest,
this IMHO should be done in a separate patch.

Best regards,
	Maxim Levitsky


>  }
>  
>  void sev_init_vmcb(struct vcpu_svm *svm)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 984e89d7a734..ee7c7d0a09ab 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -146,6 +146,7 @@ static const struct svm_direct_access_msrs {
>  	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
>  	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
>  	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
> +	{ .index = MSR_IA32_XSS,                        .always = false },
>  	{ .index = MSR_INVALID,				.always = false },
>  };
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index bdc39003b955..2011456d2e9f 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -30,7 +30,7 @@
>  #define	IOPM_SIZE PAGE_SIZE * 3
>  #define	MSRPM_SIZE PAGE_SIZE * 2
>  
> -#define MAX_DIRECT_ACCESS_MSRS	53
> +#define MAX_DIRECT_ACCESS_MSRS	54
>  #define MSRPM_OFFSETS	32
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
> @@ -720,5 +720,6 @@ DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_1)
>  DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_2)
>  DEFINE_KVM_GHCB_ACCESSORS(sw_scratch)
>  DEFINE_KVM_GHCB_ACCESSORS(xcr0)
> +DEFINE_KVM_GHCB_ACCESSORS(xss)
>  
>  #endif





