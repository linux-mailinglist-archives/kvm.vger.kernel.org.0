Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7653777D0B0
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbjHORLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238683AbjHORLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:11:20 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA36E72
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 10:11:19 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68877dc8350so434310b3a.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 10:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692119479; x=1692724279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cv2n5WJJQIuL/aVi/GBknUHwNAlL9ubXLjVa7Ggcv7I=;
        b=juBpYIQZEyCC6Jxj3rJ8WnAzIPrIzPVj5tnkYhXpIeMCc4oO2/fQGumrrkXbGCk3g8
         89rFQ8JFJ7jAi+RKDOoGZu0lboERBLSeqj26Du2aiiZT3HUXr++j5MsFNimW/4tMY2+g
         rhai3gOe8SafhKvRJ/5b9PjsXezcxE8GcsL2AIP6DNYOol1ymPNSpzGKX4N4U2270Cds
         PN1LqsVigNzgBLwqPpwepEwsM8KimXnw2TOdhRx1KWDbFUKPeDRaFClMO9+2T2z1icRJ
         wmeoUCm00GDLdP2w0bHV7FmLWFYd4+xi5/TBn+q9x2KyZBLOZopWH3LIlJtxQ8Z+T6b0
         OarA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692119479; x=1692724279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cv2n5WJJQIuL/aVi/GBknUHwNAlL9ubXLjVa7Ggcv7I=;
        b=WM/udpj38CMH1iy98QSb3s4cwccSXvgfv4tG4FjILTYo11MFTPhnG7g6UqM7pVK2lE
         5A+cdzJHL8+UpcP4h9SgvSbESxmB+uCF0ibB1iLaF3EYV7u66StklHIwfQw3HSVGOuzF
         t+TOIq52aIjMyPfzr2PEnfYfU5CTCUGPhyMndcnuItM5KoE9K3m7bBaTMESjvzwJxCLi
         zIOOGaHLw/ummdHUYFiGNwLGo0UqfjwMHDo32KhAD+qage52h+SWGeI/Wchnuqif+V2O
         Yo+6UYQS8rF4g82qeqnWmSNbUkgIUbu2QxlOKSKsKzydxo1gRRCqgNDXetU30AxXr81Y
         9LsQ==
X-Gm-Message-State: AOJu0YzaYXjy37j8Ikh19ce+WUbRVEOSgd8HVBtY0M2fSvcrn1w1wFWW
        35Mm78X6UjssMSRnonJdxpqP9Nb6th4=
X-Google-Smtp-Source: AGHT+IHbOv08Ksb8i4GH5D8SvhTbeb288EfGwKpVHkJw1xaHbiUdJmgJiWqHwrAr1/byOS/72K0ihXyR9Hs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:398a:b0:687:5d7c:82b8 with SMTP id
 fi10-20020a056a00398a00b006875d7c82b8mr5796779pfb.2.1692119478722; Tue, 15
 Aug 2023 10:11:18 -0700 (PDT)
Date:   Tue, 15 Aug 2023 10:11:17 -0700
In-Reply-To: <20230815153537.113861-1-kyle.meyer@hpe.com>
Mime-Version: 1.0
References: <20230815153537.113861-1-kyle.meyer@hpe.com>
Message-ID: <ZNuxtU7kxnv1L88H@google.com>
Subject: Re: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 4096
From:   Sean Christopherson <seanjc@google.com>
To:     Kyle Meyer <kyle.meyer@hpe.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hasen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, dmatlack@google.com, russ.anderson@hpe.com,
        dimitri.sivanich@hpe.com, steve.wahl@hpe.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023, Kyle Meyer wrote:
> Increase KVM_MAX_VCPUS to 4096 when MAXSMP is enabled.
> 
> Notable changes (when MAXSMP is enabled):
> 
> * KMV_MAX_VCPUS will increase from 1024 to 4096.
> * KVM_MAX_VCPU_IDS will increase from 4096 to 16384.
> * KVM_HV_MAX_SPARSE_VCPU_SET_BITS will increase from 16 to 64.
> * CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (0x40000005)].EAX will now be 4096.
> 
> * struct kvm will increase from 39408 B to 39792 B.
> * struct kvm_ioapic will increase from 5240 B to 19064 B.
> 
> * The following (on-stack) bitmaps will increase from 128 B to 512 B:
> 	* dest_vcpu_bitmap in kvm_irq_delivery_to_apic.
> 	* vcpu_mask in kvm_hv_flush_tlb.
> 	* vcpu_bitmap in ioapic_write_indirect.
> 	* vp_bitmap in sparse_set_to_vcpu_mask.
> 
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
> Virtual machines with 4096 virtual CPUs have been created on 32 socket
> Cascade Lake and Sapphire Rapids systems.
> 
> 4096 is the current maximum value because of the Hyper-V TLFS. See
> BUILD_BUG_ON in arch/x86/kvm/hyperv.c, commit 79661c3, and Vitaly's
> comment on https://lore.kernel.org/all/87r136shcc.fsf@redhat.com.

Mostly out of curiosity, do you care about Hyper-V support?   If not, at some
point it'd probably be worth exploring a CONFIG_KVM_HYPERV option to allow
disabling KVM's Hyper-V support at compile time so that we're not bound by the
restrictions of the TLFS.

>  arch/x86/include/asm/kvm_host.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3bc146dfd38d..91a01fa17fa7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -39,7 +39,11 @@
>  
>  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>  
> +#ifdef CONFIG_MAXSMP
> +#define KVM_MAX_VCPUS 4096
> +#else
>  #define KVM_MAX_VCPUS 1024
> +#endif

Rather than tightly couple this to MAXSMP, what if we add a Kconfig?  I know of
at least one scenario, SVM's AVIC/x2AVIC, where it would be desirable to configure
KVM to a much smaller maximum.  The biggest downside I can think of is that KVM
selftests would need to be updated (they assume the max is >=512), and some of the
tests might be completely invalid if KVM_MAX_VCPUS is too low (<256?).

E.g.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 60d430b4650f..8704748e35d9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
-#define KVM_MAX_VCPUS 1024
+#define KVM_MAX_VCPUS CONFIG_KVM_MAX_NR_VCPUS
 
 /*
  * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ed90f148140d..b0f92eb77f78 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -151,6 +151,17 @@ config KVM_PROVE_MMU
 
          If in doubt, say "N".
 
+config KVM_MAX_NR_VCPUS
+       int "Maximum vCPUs per VM"
+       default "4096" if MAXSMP
+       default "1024"
+       range 1 4096
+       depends on KVM
+       help
+         Set the maximum number of vCPUs for a single VM.  Larger values
+         increase the memory footprint of each VM regardless of how many vCPUs
+         are actually created (though the memory increase is relatively small).
+
 config KVM_EXTERNAL_WRITE_TRACKING
        bool
 

