Return-Path: <kvm+bounces-2830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 150487FE64F
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 02:42:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75925B20FF9
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 01:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9DE79EB;
	Thu, 30 Nov 2023 01:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xuow30fC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71476198
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:42:06 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5cdde93973aso7975287b3.1
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701308525; x=1701913325; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UJiTexEo/V1fShNskSxIf2XvNn8+cQRjMRJWxCEEnB0=;
        b=Xuow30fC4+Knlna+BI56y8gbSenRSlpZVD6YUtEJ0Bcy5gYa4m3X59VO9eXe+/hE4M
         JhzppL9O8gqLmm0sW4OmozLA3zhQUYHkvew7tPSNJ2J5t8nG6vy6w6NG4hha1OrcNnSz
         F5D/NlAyMR+1fDbgOMsM4iuUub6VxDC614Uhc5LwE7g31SBMh1ib76PjdY4K1yu1PKPk
         l30H6z1knSNwGa8RnJkBSGZMsNuRWn2chYE7SAc0Cy3AyspIg+ruEYiV1xGcKATYKiyE
         MZ1lYwdbITG7aeAcZYW3PYSL35rBsAsBEugFSsrtsbr67YCYRUvkwSCDE3Eqtr8Pa+3K
         2kMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701308525; x=1701913325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UJiTexEo/V1fShNskSxIf2XvNn8+cQRjMRJWxCEEnB0=;
        b=UJWjLXsAL6TaLop7QnnQwJ7IGG4XBZYr0DSDH1TTpJ7vMln9AFKPOwgBdIz6mDnTrk
         A45dPBiF2tVGkOtAS9+/CiHaHq8G1id8ZVeJQcdL9PKge5LHcc+SNDFgG7Wcvk7sG7km
         iAHx8Tfb2Pge1EhIDS0kSdxdGcRz1TSoFT1mpMRWVdZGDmBSRXQy6cMewiT5UuoGt8GP
         9LL75OYTA+vwHPng+ReK9KNYbKVpl2OtImil0ubPN/GnQjUS0yrULayCNdpbytPF0LvF
         jR/AxvL0pS2uege8ZW4s3b7tnUqyvke0intxb/ihfyIDo//W3gcXEt3Kd8BQFgZlL5Bs
         kWIw==
X-Gm-Message-State: AOJu0YwD2mR+rvAaVD7tibCdvMQd/EVm94ksayBpwkb686Qa/ZhuWZxJ
	4L3EXYcM1BTttlaBA0jr2YumNftomJw=
X-Google-Smtp-Source: AGHT+IG8Xv0X2KGQHPvRQOHcUbtzsQsthfYCxiRlfbVLaRRLFYnmSFC8z2XlvUktMdkOuzt9IB2Q97PT6sg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:98d:b0:5cd:c47d:d8a0 with SMTP id
 ce13-20020a05690c098d00b005cdc47dd8a0mr650442ywb.7.1701308525670; Wed, 29 Nov
 2023 17:42:05 -0800 (PST)
Date: Wed, 29 Nov 2023 17:42:04 -0800
In-Reply-To: <20231025152406.1879274-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231025152406.1879274-1-vkuznets@redhat.com>
Message-ID: <ZWfobPuhnXZYaAVj@google.com>
Subject: Re: [PATCH 00/14] KVM: x86: Make Hyper-V emulation optional
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 25, 2023, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov (14):
>   KVM: x86: xen: Remove unneeded xen context from struct kvm_arch when
>     !CONFIG_KVM_XEN
>   KVM: x86: hyper-v: Move Hyper-V partition assist page out of Hyper-V
>     emulation context
>   KVM: VMX: Split off vmx_onhyperv.{ch} from hyperv.{ch}
>   KVM: x86: hyper-v: Introduce kvm_hv_synic_auto_eoi_set()
>   KVM: x86: hyper-v: Introduce kvm_hv_synic_has_vector()
>   KVM: VMX: Split off hyperv_evmcs.{ch}
>   KVM: x86: hyper-v: Introduce kvm_hv_nested_transtion_tlb_flush()
>     helper
>   KVM: selftests: Make all Hyper-V tests explicitly dependent on Hyper-V
>     emulation support in KVM
>   KVM: selftests: Fix vmxon_pa == vmcs12_pa == -1ull
>     vmx_set_nested_state_test for !eVMCS case
>   KVM: x86: Make Hyper-V emulation optional
>   KVM: nVMX: hyper-v: Introduce nested_vmx_evmptr12() and
>     nested_vmx_is_evmptr12_valid() helpers
>   KVM: nVMX: hyper-v: Introduce nested_vmx_evmcs() accessor
>   KVM: nVMX: hyper-v: Hide more stuff under CONFIG_KVM_HYPERV
>   KVM: nSVM: hyper-v: Hide more stuff under
>     CONFIG_KVM_HYPERV/CONFIG_HYPERV

No major complaints.  If it hadn't been for the build failure, I likely wouldn't
have even bothered with most of my nits ;-)

I'll wait for v2 though, trying to fixup as I go will be a bit risky.

