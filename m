Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EF35A5175
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 18:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiH2QUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 12:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiH2QUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 12:20:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB11917072
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 09:20:01 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id i7-20020a17090adc0700b001fd7ccbec3cso5211195pjv.0
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 09:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=FaF8cDfiIEJisn/AmWCWKjm0dO325nGwFjqll5mbmjA=;
        b=OS6ic46l8D4uNiEVr/X8tV2FhAGXLD/f1tTZvMhzPTPjuzjkb6/kYWvQLqxgSuHgWo
         BZLZB/qULOS2aXpqU6/Vge34NxesNVEAb+946u7Hw3LK8e2NwWtpxRo20syutwrguoy8
         9/1TQ9QZLvNQqsFlionV3ONdolopTJYlEyyWyG56u/Y06TdiDssJgSpiwAsAs/KE+SAD
         uUxwdJJVj6zJG0h4AaL6zOlEEvP2cuMpfdhOMxiF+RKZnWoM4dhq1beZCOwxx+urHWh9
         Gp7q+mPTqhv3L8bisvKrqFHKXZyAB5PYcrckZa2QCDlAmarhG7tsEbkjES0A4Nr8zZwF
         tjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=FaF8cDfiIEJisn/AmWCWKjm0dO325nGwFjqll5mbmjA=;
        b=0ZQSMz1T/ywK3/3HeEfv85NNEK3gjEdHhAspyKg1Dl32L5uUjREicVH54zqNDSK9Ew
         YUl/xyvaYEBjO2bWBRkyPNo+hwNygbBdJJRLMgWbbcmudUY7Ssr0c/e1ytwJX02dT3FA
         dJEfiyjA+tyHXl/xZTMYUMLiMhVXvFjc89Q96YKHWSkamkIwU/7X10UNTEpU+63XhnoH
         2uaBdItCfwEXdjjW/9mcsHCtcj03Da5zD9a1RBhpCIZ4x8SW8/P/3ZQW85FT5SySM9oU
         GtaNBEIBvmuCzTRCviz+ism1in2O/sr5E429tWs/F1aQBxz2grNtKks5TqRNPFJ4YbAQ
         SwSQ==
X-Gm-Message-State: ACgBeo0nyFzPRiWTwO2f1MyaexQ7aTXdGGs18caLJkmW6a68ktgiYZob
        SK7CRppYgXci8GGej07jA56G8uWJDFGmBw==
X-Google-Smtp-Source: AA6agR50y1NDfmhFc7eilJSiD4MLdOpCZAPKYRil0z/0Vc/bKiNB0fMw/YcHd4BiKuQtGehqKeo4Gg==
X-Received: by 2002:a17:90b:2c11:b0:1fd:e56c:79de with SMTP id rv17-20020a17090b2c1100b001fde56c79demr3414927pjb.201.1661790001240;
        Mon, 29 Aug 2022 09:20:01 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 195-20020a6217cc000000b005365aee486bsm7396796pfx.192.2022.08.29.09.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 09:20:00 -0700 (PDT)
Date:   Mon, 29 Aug 2022 16:19:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 3/4] KVM: selftests: Add support for posted interrupt
 handling in L2
Message-ID: <YwznLAqRb2i4lHiH@google.com>
References: <20220828222544.1964917-1-mizhang@google.com>
 <20220828222544.1964917-4-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220828222544.1964917-4-mizhang@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 28, 2022, Mingwei Zhang wrote:
> Add support for posted interrupt handling in L2. This is done by adding
> needed data structures in vmx_pages and APIs to allow an L2 receive posted
> interrupts.
> 
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/vmx.h | 10 ++++++++++
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c     | 14 ++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> index 99fa1410964c..69784fc71bce 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -577,6 +577,14 @@ struct vmx_pages {
>  	void *apic_access_hva;
>  	uint64_t apic_access_gpa;
>  	void *apic_access;
> +
> +	void *virtual_apic_hva;
> +	uint64_t virtual_apic_gpa;
> +	void *virtual_apic;
> +
> +	void *posted_intr_desc_hva;
> +	uint64_t posted_intr_desc_gpa;
> +	void *posted_intr_desc;

Can you add a prep patch to dedup the absurd amount of copy-paste code related to
vmx_pages?

I.e. take this and give all the other triplets the same treatment.

---
 tools/testing/selftests/kvm/include/x86_64/vmx.h | 10 +++++++---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c     | 15 ++++++++++-----
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 99fa1410964c..ecc66d65acc1 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -537,10 +537,14 @@ static inline uint32_t vmcs_revision(void)
 	return rdmsr(MSR_IA32_VMX_BASIC);
 }

+struct vmx_page {
+	void *gva;
+	uint64_t gpa;
+	void *hva;
+};
+
 struct vmx_pages {
-	void *vmxon_hva;
-	uint64_t vmxon_gpa;
-	void *vmxon;
+	struct vmx_page vmxon;

 	void *vmcs_hva;
 	uint64_t vmcs_gpa;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 80a568c439b8..e4eeab85741a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -58,6 +58,13 @@ int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 	return evmcs_ver;
 }

+static void vcpu_alloc_vmx_page(struct kvm_vm *vm, struct vmx_page *page)
+{
+	page->gva = (void *)vm_vaddr_alloc_page(vm);
+	page->hva = addr_gva2hva(vm, (uintptr_t)page->gva);
+	page->gpa = addr_gva2gpa(vm, (uintptr_t)page->gva);
+}
+
 /* Allocate memory regions for nested VMX tests.
  *
  * Input Args:
@@ -76,9 +83,7 @@ vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva)
 	struct vmx_pages *vmx = addr_gva2hva(vm, vmx_gva);

 	/* Setup of a region of guest memory for the vmxon region. */
-	vmx->vmxon = (void *)vm_vaddr_alloc_page(vm);
-	vmx->vmxon_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmxon);
-	vmx->vmxon_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmxon);
+	vcpu_alloc_vmx_page(vm, &vmx->vmxon);

 	/* Setup of a region of guest memory for a vmcs. */
 	vmx->vmcs = (void *)vm_vaddr_alloc_page(vm);
@@ -160,8 +165,8 @@ bool prepare_for_vmx_operation(struct vmx_pages *vmx)
 		wrmsr(MSR_IA32_FEAT_CTL, feature_control | required);

 	/* Enter VMX root operation. */
-	*(uint32_t *)(vmx->vmxon) = vmcs_revision();
-	if (vmxon(vmx->vmxon_gpa))
+	*(uint32_t *)(vmx->vmxon.gva) = vmcs_revision();
+	if (vmxon(vmx->vmxon.gpa))
 		return false;

 	return true;

base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
--

