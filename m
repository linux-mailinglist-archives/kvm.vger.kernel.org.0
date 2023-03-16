Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70AA56BD3FA
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 16:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjCPPiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 11:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjCPPiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 11:38:03 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B80E1FC7;
        Thu, 16 Mar 2023 08:35:56 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id k2so2147224pll.8;
        Thu, 16 Mar 2023 08:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678980892;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4bM5/JtpRliV+DO/9It3j6B+Tv8+ycHcYeGrXnd9x84=;
        b=ll4qK5qhYpzRFAf3gi4hD7q+UjsHH7QKtLTNKm3hODQ+T/H3M/XuhHaV6Fs5Kunv/P
         hIJ0wKQyxHpPjzrH+jLTgJGZU2+vc4d6dR9mTXDKbvmw4NiBmiGJt6h40whLNJaANhyB
         iA3qPccq6HOrbeH0neHIBbzV65jeiyWeLcycor9uNcxAlOgyBKsCp+PIhvABNaC9C4Y6
         nV/FAdwEAjlZsULp3tjxPvyImUNwOPxRhYMEhQuJYCffcObWe0kdq7PYY54k3SCXRpfd
         SzAhveOzLyeQQBeM7fqIvK7120bTXoQma4LTtTumQanNtIKWQbCwYVg6C7f6ucUUfeqc
         Y/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980892;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4bM5/JtpRliV+DO/9It3j6B+Tv8+ycHcYeGrXnd9x84=;
        b=tUbu9ZMzc254lHmjLirUsRe0aFnLPxU2NdGjlkx3cT4Orby5xqN1mUoBTqBCjrSAND
         VoN/71bPtQpKyjm3BfkzUJHWwio120LTOXp0XQpAbkOtIZFFazzgFin8S9Kx4LcEqOM7
         aPcShqyPYx4ICBl8BYAApWq/ttU1dP7v3wCFJxLu7gXNdIkb+2o1D6CE2IpF6GxeVZfT
         3hGBmG174C7IJzWtiQe/cq72vnNkfWPe2pNnT3xfTPRL8uWTSuWh1P+fY39a6TAyRXyZ
         TCNj/5oo7hL8uOdH2pvXXERF+qvGSJkp7+j8g6Q47H9b0teMOmubxumH/dpcMYCzZi6e
         /62w==
X-Gm-Message-State: AO0yUKXcckoSBPyyCdsKX6lQhNOdgXYPnZuVeVQs2Cc53Sjw1YFtNSDJ
        SPcf9HKMcnVclq9GZRvGB7ddWfUlq0dd6A==
X-Google-Smtp-Source: AK7set/EukbAFprZsXkZJj2AwgWisEIryVjS8nlmZi5looK76yFnWaH6p1RFkX4mB1oSCDtN6HcTjg==
X-Received: by 2002:a05:6a20:548f:b0:d5:10ca:5264 with SMTP id i15-20020a056a20548f00b000d510ca5264mr5169184pzk.59.1678980892339;
        Thu, 16 Mar 2023 08:34:52 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id h35-20020a631223000000b0050301521335sm5265312pgl.11.2023.03.16.08.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 08:34:51 -0700 (PDT)
Date:   Thu, 16 Mar 2023 08:34:50 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v13 006/113] KVM: x86: Introduce vm_type to differentiate
 default VMs from confidential VMs
Message-ID: <20230316153450.GB259042@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <78dac4d2133a7c48b2da21a8f9e0922ad38c3f7b.1678643052.git.isaku.yamahata@intel.com>
 <c3bc88055c6610c2d0102fd3e70ade61fb4e1a32.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3bc88055c6610c2d0102fd3e70ade61fb4e1a32.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 10:44:57AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sun, 2023-03-12 at 10:55 -0700, isaku.yamahata@intel.com wrote:
> >  
> > -static bool kvm_is_vm_type_supported(unsigned long type)
> > +bool __kvm_is_vm_type_supported(unsigned long type)
> >  {
> >  	return type == KVM_X86_DEFAULT_VM ||
> >  	       (type == KVM_X86_PROTECTED_VM &&
> >  	        IS_ENABLED(CONFIG_KVM_PROTECTED_VM) && tdp_enabled);
> >  }
> > +EXPORT_SYMBOL_GPL(__kvm_is_vm_type_supported);
> 
> Where is CONFIG_KVM_PROTECTED_VM introduced?

UPM patch series.

    KVM: x86: Add support for "protected VMs" that can utilize private memory

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fa195797461e..e8f334b0ff2c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1245,6 +1245,7 @@ enum kvm_apicv_inhibit {
 };
 
 struct kvm_arch {
+       unsigned long vm_type;
        unsigned long n_used_mmu_pages;
        unsigned long n_requested_mmu_pages;
        unsigned long n_max_mmu_pages;
@@ -2049,6 +2050,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
                       int tdp_max_root_level, int tdp_huge_page_level);
 
+#ifdef CONFIG_KVM_PRIVATE_MEM
+#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.vm_type != KVM_X86_DEFAULT_VM)
+#else
+#define kvm_arch_has_private_mem(kvm) false
+#endif
+
 static inline u16 kvm_read_ldt(void)
 {
        u16 ldt;
...
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7f467fe05d42..6afbfbb32d56 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -559,4 +559,7 @@ struct kvm_pmu_event_filter {
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
+#define KVM_X86_DEFAULT_VM     0
+#define KVM_X86_PROTECTED_VM   1
+
 #endif /* _ASM_X86_KVM_H */
...
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ed84bb3cd82d..718010600956 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -78,6 +78,17 @@ config KVM_WERROR
 
          If in doubt, say "N".
 
+config KVM_PROTECTED_VM
+       bool "Enable support for KVM-protected VMs"
+       depends on EXPERT
+       depends on X86_64
+       select KVM_GENERIC_PRIVATE_MEM
+       help
+         Enable support KVM-protected VMs.  Currently 'protected' means the VM
+         can be backed with restricted/private memory.
+
+         If unsure, say "N".
+
 config KVM_INTEL
        tristate "KVM for Intel (and compatible) processo

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
