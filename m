Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418F55ECCF6
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 21:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiI0Tdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 15:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbiI0Tdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 15:33:45 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA25B106A08
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 12:33:43 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 9so10531406pfz.12
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 12:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=C0YiAmeNTTNxK+azYDy9ceezEE12O9c/kiyByUf7kiQ=;
        b=N2FwtrrkDpWOGA8NQIrGQgCp1qRdCJGtP22Q0PpRnDGn8XQ0bB1mpcIc32OwJuA5Z9
         UF8gdmVGd4AjRFJ9HgM0svO6QFUC4tEuk2jRvYv8fkUAfjU5j8TZJCEFtzVZVg9mIIjV
         RO6qmj4gN/Hs+D9iNaDSODegN7ONAxOFXTLvDh5wiLc3sEh3UtBqQ6jQ/om1p1aHs/Og
         CbB1pLuiNIlvNGVZU4SZA6YCHOeHAsOZk2Y8dbSVcgriVZfEOE/Df/4r1MkUNVbuoGPD
         wv1dtMziwe8r3fW9/lNZtxIJl6XVFASuMjyOkBRc/bkjqfJWG8Dn8GMGQr7zrbIX8Lwm
         IXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=C0YiAmeNTTNxK+azYDy9ceezEE12O9c/kiyByUf7kiQ=;
        b=dXL9Qj8aMdUZDTpRD+TpK6w7VMhavWUnbp1jXtcR+W6XXxLv0Xin/55N5FNELwOn5x
         ux0mpGbhe66569mKIi1P0rXp11ljbm0J7TnNPK92R9Z7k0+2WDBcDoevGhaeU3dVrmju
         jKfUdb/R6Dr5WfZDWx6RiZEv+guAauZGx7PoL4XbeTvvIotewIBwQJ1hTsb20WgulF77
         rD1/KJuMOvaYRThLAg2R/G9OSR/gMhNI447V9U8DaIqQPieSnri6oFuxZuASUsMRNNn/
         tfUMZrPWUx95fSAH+qXvtLsa9RrTKWFrxJT3iU6CJIoX5RuD7f7McSwiJrUb7u5vLUKu
         V8uw==
X-Gm-Message-State: ACrzQf2BKlPdHxG0RbkvZ9nwWJ+fHbEhBkWmHnF8NE4J0vXgJU6QHpJi
        t0JCs3E9Pdq7V+GusZbrBWPXBQ==
X-Google-Smtp-Source: AMsMyM5Ka9IqP6PrO7ZeKW5jtFyBd76piy2y5YyhNoUBxOJJUmqcusVkm6nPmLvqLqJA7NYiMiJSJA==
X-Received: by 2002:a63:88c3:0:b0:43c:5561:839 with SMTP id l186-20020a6388c3000000b0043c55610839mr20658329pgd.393.1664307222943;
        Tue, 27 Sep 2022 12:33:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a12-20020aa78e8c000000b0053e61633057sm2176249pfr.132.2022.09.27.12.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 12:33:42 -0700 (PDT)
Date:   Tue, 27 Sep 2022 19:33:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] Documentation: KVM: Describe guest CPUID.15H settings
 for in-kernel APIC
Message-ID: <YzNQEgDk/K2gBcgs@google.com>
References: <20220921204402.29183-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921204402.29183-1-jmattson@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Jim Mattson wrote:
> KVM_GET_SUPPORTED_CPUID must not populate guest CPUID.15H, because KVM
> has no way of knowing the base frequency of the local APIC emulated in
> userspace.
> 
> However, in reality, the in-kernel APIC emulation is in prevalent
> use. Document how KVM_GET_SUPPORTED_CPUID would populate CPUID.15H if
> the in-kernel APIC were the default.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index abd7c32126ce..1e09ac9d48e9 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1786,6 +1786,16 @@ support.  Instead it is reported via::
>  if that returns true and you use KVM_CREATE_IRQCHIP, or if you emulate the
>  feature in userspace, then you can enable the feature for KVM_SET_CPUID2.
>  
> +Similarly, CPUID leaf 0x15 always returns zeroes, because the core
> +crystal clock frequency must match the local APIC base frequency, and
> +the default configuration leaves the local APIC emulation to
> +userspace.
> +
> +If KVM_CREATE_IRQCHIP is used to enable the in-kernel local APIC
> +emulation, CPUID.15H:ECX can be set to 1000000000 (0x3b9aca00). For
> +the default guest TSC frequency, CPUID.15H:EBX can be set to tsc_khz
> +and CPUID.15H:ECX can be set to 1000000 (0xf4240).  The fraction can
> +be simplified if desired.

It would be helpful to explain what these numbers mean and where they come from.

That said, unlike 16H, I think we can actually "solve" this case, we just need a
way to force an in-kernel local APIC, i.e. add a module param or Kconfig.

I'm tempted to make it a Kconfig so that KVM can start moving toward removing
"support" for a userspace local APIC entirely, e.g. x2APIC is basically unusable
without an in-kernel APIC, so KVM is already quite far down that path anyways.

E.g.

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ffdc28684cb7..b67135a53edf 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1061,6 +1061,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
                                goto out;
                }
                break;
+#ifdef CONFIG_KVM_REQUIRE_IN_KERNEL_LOCAL_APIC
+       case 0x15:
+               <fill in magic values>
+               break;
+#endif
        /* Intel AMX TILE */
        case 0x1d:
                if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index a5ac4a5a5179..5abaa09ec5aa 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -181,8 +181,10 @@ DECLARE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
 
 static inline bool lapic_in_kernel(struct kvm_vcpu *vcpu)
 {
+#ifndef CONFIG_KVM_REQUIRE_IN_KERNEL_LOCAL_APIC
        if (static_branch_unlikely(&kvm_has_noapic_vcpu))
                return vcpu->arch.apic;
+#endif
        return true;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb412f9f03ea..8ea6f0175c1c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11763,6 +11763,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
        struct page *page;
        int r;
 
+       if (IS_ENABLED(CONFIG_KVM_REQUIRE_IN_KERNEL_LOCAL_APIC) &&
+           !irqchip_in_kernel(vcpu->kvm))
+               return -EINVAL;
+
        vcpu->arch.last_vmentry_cpu = -1;
        vcpu->arch.regs_avail = ~0;
        vcpu->arch.regs_dirty = ~0;




