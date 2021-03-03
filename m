Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19B432C5F5
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346188AbhCDA1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234114AbhCCLmu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 06:42:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614771622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r/j20RVofkj/hPK0Wo3xRPO9YBuymSE3SUYDVG+qh8o=;
        b=LZ7zBmqmD3uCrih3m5/N7teNpl1B0EfKewFFn3Bl7j0BqzG7QzzlN/jqhP8rNe7cqNOcbX
        7z+x3zBI4xwcWUpUCsBhq6v1PHSZ/VLO9XdoNGe2galTL7vF+3/5Du6PfZ+24D3filCG7c
        LEpb+lXxMRP3lhIIUAbQLTKdghVdEdk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-Y-poX2VJMOGmUo7TFfWoAQ-1; Wed, 03 Mar 2021 04:36:43 -0500
X-MC-Unique: Y-poX2VJMOGmUo7TFfWoAQ-1
Received: by mail-ej1-f69.google.com with SMTP id au15so4521321ejc.8
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 01:36:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=r/j20RVofkj/hPK0Wo3xRPO9YBuymSE3SUYDVG+qh8o=;
        b=OZXkH4dZUbySJ5NELXlVLNSQKn3pGYgxZo/hduSyVVA7yKf1t6ka6xrNQDx3uT0UKU
         fGnfKg2Nis5XDFNrLSp5+m263ul1oml+owNwotuc/1xnYkr1KgziXKyG0FZk47WOpneq
         GQrfTLcFI8vj4afH23PsQaIwl8OTmYdtgK1Ac8GPslZHNDI3AZMicB/Nt1dvkAGVnC+H
         MzHusnnWf02x+lKoVBOQsbkFsffRVSvzGZBpyTJ7XTD8CYlk13Ro1rLYM2MOR7QHPUdD
         zX6lC80WlRbzui2ZGecLJFH8v6CSNOaqY7KlK6fZCOcJrV1+vIrokKCWRQUt/pVDhpDb
         moyA==
X-Gm-Message-State: AOAM532lSt+3oDFSUSBeDCAxFz8C0PvIatfCk89gByO4AbYH5BLSeJrd
        vEyFbHG692cS6aIb6SnVVEwGxIxmXwZEPfxJM1MxrvyIZ18eOQwGXl2wP+07URq9E63R/PiSDTa
        drnCyynY9okP7
X-Received: by 2002:a17:906:33d9:: with SMTP id w25mr24858485eja.413.1614764201999;
        Wed, 03 Mar 2021 01:36:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9srdPqz0s4q1Xe5kvp25flWERjZA9N812PYdPFVO6+9MmFpJ6/Ozf7O8+uFN1+d2OxMxUQw==
X-Received: by 2002:a17:906:33d9:: with SMTP id w25mr24858472eja.413.1614764201828;
        Wed, 03 Mar 2021 01:36:41 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o6sm2602785edw.24.2021.03.03.01.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 01:36:41 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Add CET entry/exit load bits to evmcs
 unsupported list
In-Reply-To: <20210303060435.8158-1-weijiang.yang@intel.com>
References: <20210303060435.8158-1-weijiang.yang@intel.com>
Date:   Wed, 03 Mar 2021 10:36:40 +0100
Message-ID: <87h7lsefyv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yang Weijiang <weijiang.yang@intel.com> writes:

> CET in nested guest over Hyper-V is not supported for now. Relevant
> enabling patches will be posted as a separate patch series.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/evmcs.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index bd41d9462355..25588694eb04 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -59,8 +59,10 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>  	 SECONDARY_EXEC_SHADOW_VMCS |					\
>  	 SECONDARY_EXEC_TSC_SCALING |					\
>  	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
> -#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> -#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
> +#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | \
> +					VM_EXIT_LOAD_CET_STATE)
> +#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | \
> +					 VM_ENTRY_LOAD_CET_STATE)
>  #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
>  
>  #if IS_ENABLED(CONFIG_HYPERV)

This should be enough when we run KVM on Hyper-V using eVMCS, however,
it may not suffice when we run Hyper-V on KVM using eVMCS: there's still
no corresponding eVMCS fields so CET can't be used. In case Hyper-V is
smart enough it won't use the feature, however, it was proven to be 'not
very smart' in the past, see nested_evmcs_filter_control_msr(). I'm
wondering if we should also do

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 41f24661af04..9f81db51fd8b 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -351,11 +351,11 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
        switch (msr_index) {
        case MSR_IA32_VMX_EXIT_CTLS:
        case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-               ctl_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+               ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
                break;
        case MSR_IA32_VMX_ENTRY_CTLS:
        case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-               ctl_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+               ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
                break;
        case MSR_IA32_VMX_PROCBASED_CTLS2:
                ctl_high &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;

to be on the safe side.

-- 
Vitaly

