Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E648B16AA1E
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 16:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgBXPaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 10:30:24 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58576 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727576AbgBXPaX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 10:30:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582558221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JJxxV23y9pJ+tpbvjLr3aBKJpCVHhxptFUa2Hc5Byr4=;
        b=AT1QpX6jM6ptCfTpbXqny9orEBrDaXUVRc7Tz61r6VvY4MLx9Gw2byhrvjeRNvr3gg7Iw7
        vkdGeDbR0zuVws5WYTyjQM1Fixx0ABOXtU740F6CayckER+VkWGFmYS5FBF1isjCZQFZCd
        Ez+pZCdeW2F02oWybIPogTXYQqNHxiU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-CvnFwtyNNDyixuna1vX2pQ-1; Mon, 24 Feb 2020 10:30:19 -0500
X-MC-Unique: CvnFwtyNNDyixuna1vX2pQ-1
Received: by mail-wr1-f69.google.com with SMTP id z1so2097646wrs.9
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 07:30:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JJxxV23y9pJ+tpbvjLr3aBKJpCVHhxptFUa2Hc5Byr4=;
        b=gPgtj+LipQShXyqyNcangF2ZYPugsbSMSgixHvwjNyBZYcB6MY6KwIE1duFS89q5xg
         lpGRV6KxwDGzAKul+vlLu2ir8j31YXTudpjwTS4rQn+/qEgA2fqx0dvZj3b4xuRuFkwG
         4581WoSQ5/9SFPDAKW6xMuPZLeMlVO/giAtHwMHDbIXhyV8NUMQhPhVdB6//pmssoDIl
         YOWwb6w3kxGQCLb0F9HqL/cyd24sYmBFvwsQEH9oSpHC/FNAC0HbBWn24oQDtC9ejdl4
         vWNY3DBhhWyXzAqU+KKnrkYQpnn49oSm71ISaFx7mX5hrj3o+/YQyT4Ed9XLpFftFsUd
         uvMw==
X-Gm-Message-State: APjAAAWCZpzDKhljdqmX3KmZsyE/5p/X0Wu/+5bONfh2eTbLMTx/lp6A
        HmkSclHRe6nk9XJw3a3ovBOqzoT7B1E4Pt0Wj/sWY5z4/2eBUiO6fMYl4m6EkgY+Uk7E0oqY+Ld
        E+muAdJ53AvRj
X-Received: by 2002:a1c:bdc6:: with SMTP id n189mr23222321wmf.102.1582558218613;
        Mon, 24 Feb 2020 07:30:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqwXgTuxN3VNwlc48sTT8mfJxtoLJXm/GGABS4BXENrEAzTdbXUUhOHB6SRegFaiOCID0zHO7g==
X-Received: by 2002:a1c:bdc6:: with SMTP id n189mr23222301wmf.102.1582558218400;
        Mon, 24 Feb 2020 07:30:18 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id d9sm19458030wrx.94.2020.02.24.07.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 07:30:17 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 35/61] KVM: x86: Handle Intel PT CPUID adjustment in VMX code
In-Reply-To: <20200201185218.24473-36-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-36-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 16:30:17 +0100
Message-ID: <87pne4ngty.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the Processor Trace CPUID adjustment into VMX code to eliminate
> an instance of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
> pattern in the common CPUID handling code, and to pave the way toward
> eventually removing ->pt_supported().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c   | 3 +--
>  arch/x86/kvm/vmx/vmx.c | 3 +++
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index fc507270f3f3..f4a3655451dd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -339,7 +339,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  
>  static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  {
> -	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>  	unsigned f_la57;
>  
>  	/* cpuid 7.0.ebx */
> @@ -348,7 +347,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  		F(BMI2) | F(ERMS) | 0 /*INVPCID*/ | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
>  		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
>  		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
> -		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
> +		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | 0 /*INTEL_PT*/;
>  
>  	/* cpuid 7.0.ecx*/
>  	const u32 kvm_cpuid_7_0_ecx_x86_features =
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3990ba691d07..fcec3d8a0176 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7111,6 +7111,9 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  			cpuid_entry_set(entry, X86_FEATURE_MPX);
>  		if (boot_cpu_has(X86_FEATURE_INVPCID) && cpu_has_vmx_invpcid())
>  			cpuid_entry_set(entry, X86_FEATURE_INVPCID);
> +		if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> +		    vmx_pt_mode_is_host_guest())
> +			cpuid_entry_set(entry, X86_FEATURE_INTEL_PT);
>  		if (vmx_umip_emulated())
>  			cpuid_entry_set(entry, X86_FEATURE_UMIP);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

