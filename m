Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EB4571907
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 13:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbiGLLws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 07:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiGLLw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 07:52:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C78C6B521A
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657626714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lJt34wYL23qHhqMiKTsYFaw21Mxmb1U5E0uo3Jh2TRY=;
        b=IeqRz1kidAbKZlyqQuS7sSYd0va4uK/p8dDT7Aftm311qDywGZEYWMsg5HAaiYRaTmpW3b
        7ipwEu+Sk1bY5RV/g+0vUE9j2vGSt77I8U1kJ7yMOcXBBkALwSQmH3Y4EVguon1WPfmKsG
        CS1kFpRxNsGXVfj1ezAX85J6srPS86o=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-LSU7B_CqP5SUJyd_KeeK8Q-1; Tue, 12 Jul 2022 07:51:50 -0400
X-MC-Unique: LSU7B_CqP5SUJyd_KeeK8Q-1
Received: by mail-qk1-f199.google.com with SMTP id bk12-20020a05620a1a0c00b006b194656099so7582435qkb.5
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:51:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lJt34wYL23qHhqMiKTsYFaw21Mxmb1U5E0uo3Jh2TRY=;
        b=FL2vnXYlTnVRSMapyrV1sw7qXTMkF3Yjq0M6I3VzSVNn9gvpcIIwGe+ZZm9qdEu8Kt
         kvpidi3wL7liV+Dr/evgWZ4wtbuzKdS9PbzalutKqYsoBgbZZSNzEeYGnkPsZ4MA+Jdw
         uZ1a28ZuYszAFREs75IaQ1kqmSiFJ9jUJujuTViighLeuZPgrZnWsPPhUWvgxnLFBdCM
         cEKpZ7CxjWI0EXbml2Z5fs//MMOQqN4AgdKufTA22/EJQZMNIN2Xd2Xol9WXaO0SVZur
         e3gBFArilhJSJvkTY93jtiDtGV+ZhmdKL1tLK4i10Ceq97zuiNwFH1fPvg+jga7FzGpR
         T2kA==
X-Gm-Message-State: AJIora9EZgwZWD0n/8qYPXXaYVD/wstf0ZSlLcX17CQibhJ2mYEKnFXb
        LXHEksJMIw6C3NSYuateo1S4XwDmZ7EK6D4XOkVVwWyt3gTZiyTvaAzymkTyoQ1g0T0SubOIGyA
        kAKEfM6Apc7+a
X-Received: by 2002:ac8:580f:0:b0:31d:403e:9dd2 with SMTP id g15-20020ac8580f000000b0031d403e9dd2mr17810848qtg.245.1657626709038;
        Tue, 12 Jul 2022 04:51:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sfzW/HS+DgXkouauxFV7OY0AYI78cdEPBP3JoT8e1O8OBxPAfrh2D4NWntWrbLwzxZqv5+sQ==
X-Received: by 2002:ac8:580f:0:b0:31d:403e:9dd2 with SMTP id g15-20020ac8580f000000b0031d403e9dd2mr17810830qtg.245.1657626708795;
        Tue, 12 Jul 2022 04:51:48 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id k143-20020a37a195000000b006b1fe4a103dsm8666859qke.51.2022.07.12.04.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:51:48 -0700 (PDT)
Message-ID: <26e7784ff4ee91a8d41d217dcb5f3e0e0ce6e470.camel@redhat.com>
Subject: Re: [PATCH v3 06/25] KVM: x86: hyper-v: Cache
 HYPERV_CPUID_NESTED_FEATURES CPUID leaf
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 14:51:44 +0300
In-Reply-To: <20220708144223.610080-7-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
         <20220708144223.610080-7-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
> KVM has to check guest visible HYPERV_CPUID_NESTED_FEATURES.EBX CPUID
> leaf to know with Enlightened VMCS definition to use (original or 2022
> update). Cache the leaf along with other Hyper-V CPUID feature leaves
> to make the check quick.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  arch/x86/kvm/hyperv.c           | 9 +++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index de5a149d0971..077ec9cf3169 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -616,6 +616,8 @@ struct kvm_vcpu_hv {
>  		u32 enlightenments_eax; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
>  		u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
>  		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
> +		u32 nested_eax; /* HYPERV_CPUID_NESTED_FEATURES.EAX */
> +		u32 nested_ebx; /* HYPERV_CPUID_NESTED_FEATURES.EBX */
>  	} cpuid_cache;
>  };
>  
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index e08189211d9a..b666902da4d9 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2030,6 +2030,15 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
>  		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
>  	else
>  		hv_vcpu->cpuid_cache.syndbg_cap_eax = 0;
> +
> +	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_NESTED_FEATURES, 0);
> +	if (entry) {
> +		hv_vcpu->cpuid_cache.nested_eax = entry->eax;
> +		hv_vcpu->cpuid_cache.nested_ebx = entry->ebx;
> +	} else {
> +		hv_vcpu->cpuid_cache.nested_eax = 0;
> +		hv_vcpu->cpuid_cache.nested_ebx = 0;
> +	}
>  }
>  
>  int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)


Small Nitpick:

If I understand correctly, the kvm_find_cpuid_entry can fail if the userspace didn't provide the
cpuid entry.

Since the code that deals with failback is now repeated 3 times, how about some wrapper function that
will return all zeros for a non present cpuid entry?

That can be done later of course, so

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

