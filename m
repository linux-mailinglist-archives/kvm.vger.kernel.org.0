Return-Path: <kvm+bounces-6071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D3482ABAA
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 11:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87B2A1F244A0
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 10:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E90414AB9;
	Thu, 11 Jan 2024 10:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hfg53jTl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8701401C
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 10:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704968000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ldnyq6EPpzLG7h736KFOi2wOevyG8A+Ngm+5TTm+rYA=;
	b=hfg53jTlizXR+C1eEVG2Nv0vX3SFq37IxiOL95rQntmtOWx78LU1yGK3HOqKAS7djpIHvA
	8BRYlBWZR63XYodrX4r3PgDOAawOc3vemRKrZEbJj83EEBXtkGnyqqp3JWLB4ifS1arhZ5
	y8V+gsCusLx5pRfgFTvar4sNGHUQ3MY=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-kwWRF4WnPJSTsH0c-ntzeA-1; Thu, 11 Jan 2024 05:13:16 -0500
X-MC-Unique: kwWRF4WnPJSTsH0c-ntzeA-1
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-4b7197b3defso787431e0c.0
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 02:13:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704967996; x=1705572796;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ldnyq6EPpzLG7h736KFOi2wOevyG8A+Ngm+5TTm+rYA=;
        b=mYJIYyXbcUDPJ1jlZU7RycqCIOJIKQOCQ8bMGSW2AAaWZ17Zk8U1JIMyuOVW7ag2A+
         J7KCWGPTEln1mPOMn4JEJvmzwmI3H1YhxcEikkhogo1/LUF4y7aLdLg/1LveeQeBxgrC
         9DMta+k9aUso8KMG2TA0UF8EkbtC1YV12tDEs0QfM8SpMT5Reqm2b2rwpGL/ScwV6rxK
         PK+IwhTrfLTqYZQsAiQ3Foae0U/2XB8bKdjlEpdiWTjYybwbcicwFP2QWUOawQBj+6w8
         STCIrOchI+YduKT2rca9Yf8azL1MMP0cA3nu2+N99u665rAO7AoCmwL58ris0HR9tYUq
         8MQA==
X-Gm-Message-State: AOJu0YxprAuCcL3ZNUpdRI9dqnRAP6d3TTI3lgd1aDm7/bw/pyZhjYKw
	mTI0PMAX/HUfFTZQjxg3NzAxAlucjbOZfy5gbIL0PnN+KWA4uIX7BH9n4KK0viuO40m9gMU1+7d
	aCGVtWfeovAYzGqC9epHcvH70korctwV3tyQg
X-Received: by 2002:ac5:c1c7:0:b0:4b7:440f:604e with SMTP id g7-20020ac5c1c7000000b004b7440f604emr114146vkk.25.1704967996348;
        Thu, 11 Jan 2024 02:13:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQveUhpuYoemuVfCSD5ZoMn1XJr7GEhpzsdWjfgve6dVnamtFz3DAV4pWDKDfFXCRuidGoxe7giOqFtU6JTMQ=
X-Received: by 2002:ac5:c1c7:0:b0:4b7:440f:604e with SMTP id
 g7-20020ac5c1c7000000b004b7440f604emr114139vkk.25.1704967996098; Thu, 11 Jan
 2024 02:13:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240110002340.485595-1-seanjc@google.com>
In-Reply-To: <20240110002340.485595-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 11 Jan 2024 11:13:04 +0100
Message-ID: <CABgObfYqDsFGf4nm_g9Kfbe7heupnLLDWRsnrhh=LNSjFAmqmQ@mail.gmail.com>
Subject: Re: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support
 to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yi Lai <yi1.lai@intel.com>, 
	Tao Su <tao1.su@linux.intel.com>, Xudong Hao <xudong.hao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 10, 2024 at 1:23=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
> whether or not the CPU supports 5-level EPT paging.

I think this is a good idea independent of the selftests issue.

For selftests, we could get similar info from the feature MSR
mechanism, i.e. KVM_GET_MSRS(MSR_IA32_VMX_EPT_VPID_CAP), but only on
Intel and only if nested virtualization is enabled, so that's
inferior.

A better idea for selftests is to add a new KVM_CAP_PHYS_ADDR_SIZE,
which could be implemented by all architectures and especially by both
x86 vendors. However, I am not sure for example if different VM types
(read: TDX?) could have different maximum physical addresses, and that
would have to be taken into consideration when designing the API.

Paolo

> tip-tree folks, this is obviously not technically KVM code, but I'd like =
to
> take this through the KVM tree so that we can use the information to fix
> KVM selftests (hopefully this cycle).
>
>  arch/x86/include/asm/vmxfeatures.h | 1 +
>  arch/x86/kernel/cpu/feat_ctl.c     | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vm=
xfeatures.h
> index c6a7eed03914..266daf5b5b84 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -25,6 +25,7 @@
>  #define VMX_FEATURE_EPT_EXECUTE_ONLY   ( 0*32+ 17) /* "ept_x_only" EPT e=
ntries can be execute only */
>  #define VMX_FEATURE_EPT_AD             ( 0*32+ 18) /* EPT Accessed/Dirty=
 bits */
>  #define VMX_FEATURE_EPT_1GB            ( 0*32+ 19) /* 1GB EPT pages */
> +#define VMX_FEATURE_EPT_5LEVEL         ( 0*32+ 20) /* 5-level EPT paging=
 */
>
>  /* Aggregated APIC features 24-27 */
>  #define VMX_FEATURE_FLEXPRIORITY       ( 0*32+ 24) /* TPR shadow + virt =
APIC */
> diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ct=
l.c
> index 03851240c3e3..1640ae76548f 100644
> --- a/arch/x86/kernel/cpu/feat_ctl.c
> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> @@ -72,6 +72,8 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c=
)
>                 c->vmx_capability[MISC_FEATURES] |=3D VMX_F(EPT_AD);
>         if (ept & VMX_EPT_1GB_PAGE_BIT)
>                 c->vmx_capability[MISC_FEATURES] |=3D VMX_F(EPT_1GB);
> +       if (ept & VMX_EPT_PAGE_WALK_5_BIT)
> +               c->vmx_capability[MISC_FEATURES] |=3D VMX_F(EPT_5LEVEL);
>
>         /* Synthetic APIC features that are aggregates of multiple featur=
es. */
>         if ((c->vmx_capability[PRIMARY_CTLS] & VMX_F(VIRTUAL_TPR)) &&
>
> base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
> --
> 2.43.0.472.g3155946c3a-goog


