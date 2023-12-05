Return-Path: <kvm+bounces-3453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B968049F4
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:23:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED6331F2149D
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 06:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45077DF6C;
	Tue,  5 Dec 2023 06:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wtk82fYT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CB7116;
	Mon,  4 Dec 2023 22:23:34 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1d03bcf27e9so24006235ad.0;
        Mon, 04 Dec 2023 22:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701757413; x=1702362213; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gSjayDyCBD98Wb3ZL9XCGG9UfLqRp3c6tP3XQeY4XSE=;
        b=Wtk82fYT3BplLDsGYai/DPECT0mePlg0kT79F4He3QoN5LLVeUK1fPnZRZJEK5mgKT
         2agSXSVWNiLrkTSVKeeZqJiqfdyqYmHwhVkEiB28/WBhAQvX1HSqGgG+tNRUBxwLpu4G
         Kt3/RAdif7gTNBQdi1KVfj2hVosC6rKa4HUwOWzcplcblzrW4UPxAqC/+Nd8Y0BePG6H
         yOSD15qf8uh5aP3a/591GeR+sA3Zx8z+oUjetUN/Wb5LqxjGdHmElfANJXcDZRKh6nKA
         HjWEHZz1chm1ZWA4xpcJC2ty4GhbTO7RnP+dL9pZWOKNtzA1h2AIglf/A1795YwrS5iz
         spDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701757413; x=1702362213;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gSjayDyCBD98Wb3ZL9XCGG9UfLqRp3c6tP3XQeY4XSE=;
        b=PVDL9NY3T98r2ky60vxN611+qwVvD5xVLKRnTFOZOpyiPe7jXy/Ot/ngHnSAeMrvxK
         zAvarQBLIa7etQ3xqy70uQpmOx1i1Lb04MmdKjClLt42Mc4/1SgPho2wTSxTjYBhirmH
         74pLtmYF/QeqF1P/7j/Flo2E7R/PS6UpDZ8tDOGCIwLTUBh/hr/VQcpu7buY6B0VfgfT
         SwsxGgK8pnCtfrOhF9LJFuh+HG/X+pLweGzCXp+K0vowZDu0eGyL/PQgm9eS4dXA4Tjs
         ixblM1U3XpSJFXqUVio9h9XYQGT/X8nQWqewTl9N0NQjs/xrOObTy9GoTBElOe3nyJRa
         jA7w==
X-Gm-Message-State: AOJu0YwuBIsnRQ4uWpSwdBKD0AFZLQorlZXD1KMLgTdHkuYnAyZqAMRI
	AZ9lAO766k1GJV5Iji0jhns=
X-Google-Smtp-Source: AGHT+IF+x/FK0/seASZvgBWI2PXfsm4qMWEw5JrNlNUdaiCcON9pp80SGhQP/alYw7oADQOWHquXOA==
X-Received: by 2002:a17:903:2584:b0:1d0:69ab:b0c8 with SMTP id jb4-20020a170903258400b001d069abb0c8mr3633879plb.6.1701757413434;
        Mon, 04 Dec 2023 22:23:33 -0800 (PST)
Received: from [192.168.255.10] ([43.132.98.41])
        by smtp.gmail.com with ESMTPSA id v11-20020a1709028d8b00b001cc50146b43sm9424703plo.202.2023.12.04.22.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Dec 2023 22:23:32 -0800 (PST)
Message-ID: <edbacce0-cbff-4351-be00-9cf7bf300864@gmail.com>
Date: Tue, 5 Dec 2023 14:23:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231204074535.9567-1-likexu@tencent.com>
 <ZW32geNb18p9ibrR@google.com>
Content-Language: en-US
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZW32geNb18p9ibrR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/2023 11:55 pm, Sean Christopherson wrote:
> On Mon, Dec 04, 2023, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Explicitly checking the source of external interrupt is indeed NMI and not
>> other types in the kvm_arch_pmi_in_guest(), which prevents perf-kvm false
>> positive samples generated after vm-exit but before kvm_before_interrupt()
>> from being incorrectly labelled as guest samples:
> 
> ...
> 
>> Fixes: 73cd107b9685 ("KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu variable")
> 
> The behavior is deliberate, and was added by commit dd60d217062f ("KVM: x86: Fix
> perf timer mode IP reporting").  *If* we want to undo that, then the best "fix"
> would be to effective reverting that commit by dropping the IRQ usage of
> kvm_before_interrupt() and renaming the helpers kvm_{before,after}_nmi().  But
> my understanding is that the behavior is necessary for select PMU usage.

Thanks for your comment. Yes, the commit dd60d217062f should be tracked.

We don't have to undo the commit, and we also don't want to hurt
either of the perf/core use cases (including perf NMI and timer modes).

Thanks to the introduction of "enum kvm_intr_type", we can cover both cases
instead of sacrificing one of two modes, how about:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c8c7e2475a18..5db607a564c6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1868,8 +1868,16 @@ static inline int kvm_arch_flush_remote_tlbs_range(struct 
kvm *kvm, gfn_t gfn,
  }
  #endif /* CONFIG_HYPERV */

+enum kvm_intr_type {
+	/* Values are arbitrary, but must be non-zero. */
+	KVM_HANDLING_IRQ = 1,
+	KVM_HANDLING_NMI,
+};
+
+/* Linux always use NMI for PMU. */
  #define kvm_arch_pmi_in_guest(vcpu) \
-	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
+	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
+	 (in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))

  void __init kvm_mmu_x86_module_init(void);
  int kvm_mmu_vendor_module_init(void);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2f7e19166658..4dc38092d599 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -431,12 +431,6 @@ static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
  	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
  }

-enum kvm_intr_type {
-	/* Values are arbitrary, but must be non-zero. */
-	KVM_HANDLING_IRQ = 1,
-	KVM_HANDLING_NMI,
-};
-
  static __always_inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
  						 enum kvm_intr_type intr)
  {
-- 
2.43.0

I noticed that timer mode is used when perf-record uses SW events like 
"cpu-clock" event,
with or without hw-PMU support. My side of the tests no longer show false 
positives and
the above diff does not affect the use of perf timer mode as well. Any better move ?

