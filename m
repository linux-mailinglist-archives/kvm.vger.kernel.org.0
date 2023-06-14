Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A7F7301B8
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 16:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245590AbjFNOYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 10:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbjFNOYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 10:24:31 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB451FC2;
        Wed, 14 Jun 2023 07:24:29 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-66665b66dbaso515537b3a.1;
        Wed, 14 Jun 2023 07:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686752669; x=1689344669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OeHuGk36iAi9FOib4LSEuZFMwIiKSgOuCZrmCC6ygDM=;
        b=QFVWHvQ4FVT4k/YpETceISLCQLKSRQLGXyiPykxrKYX7KOYnDwTGAVh15Gr7cN4Gvo
         8G7VeSRCWGuCAFZphJp9YUsMGb2LYzbA+o7fD/pXjmdiN2Wvm5Wb9Ol13xQhIw3e2ucM
         LAI4NEIJ6/d60vVlv0qvKzX53o+BS/wDAIZFmLy49cFFPGFABrjrbAxZTjP8B+LCOhQ/
         Ang+dAMFLtN5MMv7n/hhb1w4iNGBIVfmCB33E9zius7nO3FsETszUVg5DIzIBeYeEWmA
         dbsDDwoSoejiXKpS9l7wTDaflW30K+KejUncLBeBeaUfYLXYeqvalqjrReooPKPYFjDe
         RL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686752669; x=1689344669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OeHuGk36iAi9FOib4LSEuZFMwIiKSgOuCZrmCC6ygDM=;
        b=c83IBT3P+c0/eyMmjR4diduO0pGv8tZ1ijGmus6hCl/l/H6thY/ZMXOMzADfh977ka
         /Gy9wcYqMMk+ZAq2LTWvwGey8SI2pBXoS+Ty9qKauDAXsrR0ibeIIdiAIXYDFCp2X2IH
         atnkUleiMHGHgEzqsox97x8XucPtbAYgbxFz8kn1Rw1N8GmBWVSqoBMuMwFW40jrq3a4
         fmTNhek/bZY4/QB8UcT0ARbdksIX38NL47SysUh4pJ2bM57s0lLaHDAgUdPi1tkw45vW
         6eLUDvjBYZTjgCHt6pc3WEhHFgJuuv0j55HybnNMkjLH02Re6LtorONTvEzf4p+Lk+WA
         0eTQ==
X-Gm-Message-State: AC+VfDxc1NIwbrACWV8GvEtHqt+1PVBemRr64NU2rEfmBgLpY8XMEyRh
        vTRgklo53i6R6sbgKR1FCmQ=
X-Google-Smtp-Source: ACHHUZ5XuSVorTt0n5Kbv+qYZgeGRCldqLkkmHj+Fft0QsEK+SkVoy/Fm/1ZGl+VFauor6vJg0+xCw==
X-Received: by 2002:a05:6a20:72ac:b0:10c:2349:459d with SMTP id o44-20020a056a2072ac00b0010c2349459dmr2242690pzk.11.1686752668433;
        Wed, 14 Jun 2023 07:24:28 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id l7-20020a62be07000000b0063b7f3250e9sm10418609pff.7.2023.06.14.07.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 07:24:27 -0700 (PDT)
Date:   Wed, 14 Jun 2023 07:24:26 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH RFC v9 03/51] KVM: x86: Use full 64-bit error code for
 kvm_mmu_do_page_fault
Message-ID: <20230614142426.GQ2244082@ls.amr.corp.intel.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-4-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230612042559.375660-4-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 11:25:11PM -0500,
Michael Roth <michael.roth@amd.com> wrote:

> The upper bits will be needed in some cases to distinguish between
> nested page faults for private/shared pages, so pass along the full
> 64-bit value.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 3 +--
>  arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c54672ad6cbc..0d3983b9aa7e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5829,8 +5829,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  	}
>  
>  	if (r == RET_PF_INVALID) {
> -		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
> -					  lower_32_bits(error_code), false,
> +		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
>  					  &emulation_type);
>  		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
>  			return -EIO;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index f1786698ae00..780b91e1da9f 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -283,11 +283,11 @@ enum {
>  };
>  
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -					u32 err, bool prefetch, int *emulation_type)
> +					u64 err, bool prefetch, int *emulation_type)
>  {
>  	struct kvm_page_fault fault = {
>  		.addr = cr2_or_gpa,
> -		.error_code = err,
> +		.error_code = lower_32_bits(err),
>  		.exec = err & PFERR_FETCH_MASK,
>  		.write = err & PFERR_WRITE_MASK,
>  		.present = err & PFERR_PRESENT_MASK,
> -- 
> 2.25.1

Hi. I'd like to pass around 64bit for TDX and come up with the following one.
Does it work for you?

From 53273b67e9be09129d35ac00cf9ce739d3fb4e2c Mon Sep 17 00:00:00 2001
Message-Id: <53273b67e9be09129d35ac00cf9ce739d3fb4e2c.1686752340.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Fri, 17 Mar 2023 12:58:42 -0700
Subject: [PATCH] KVM: x86/mmu: Pass round full 64-bit error code for the KVM
 page fault

In some cases the full 64-bit error code for the KVM page fault will be
needed to make this determination, so also update kvm_mmu_do_page_fault()
to accept the full 64-bit value so it can be plumbed through to the
callback.

The upper 32 bits of error code is discarded at kvm_mmu_page_fault()
by lower_32_bits().  Now it's passed down as full 64 bits. It turns out
that only FNAME(page_fault) depends on it.  Move lower_32_bits() into
FNAME(page_fault).

The accesses of fault->error_code are as follows
- FNAME(page_fault): change to explicitly use lower_32_bits()
- kvm_tdp_page_fault(): explicit mask with PFERR_LEVEL_MASK
- kvm_mmu_page_fault(): explicit mask with PFERR_RSVD_MASK,
                        PFERR_NESTED_GUEST_PAGE
- mmutrace: changed u32 -> u64
- pgprintk(): change %x -> %llx

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h              | 2 +-
 arch/x86/kvm/mmu/mmu.c          | 7 +++----
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 arch/x86/kvm/mmu/mmutrace.h     | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  | 4 ++--
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6cc2558e977d..b6c9c2e27d0b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -176,7 +176,7 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 }
 
 kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
-			       u32 error_code, int max_level);
+			       u64 error_code, int max_level);
 
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2c6d9d8d2c10..e4457eaa10a9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4941,7 +4941,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault)
 {
-	pgprintk("%s: gva %llx error %x\n", __func__, fault->addr, fault->error_code);
+	pgprintk("%s: gva %llx error %llx\n", __func__, fault->addr, fault->error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	fault->max_level = PG_LEVEL_2M;
@@ -5062,7 +5062,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 }
 
 kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
-			       u32 error_code, int max_level)
+			       u64 error_code, int max_level)
 {
 	int r;
 	struct kvm_page_fault fault = (struct kvm_page_fault) {
@@ -6317,8 +6317,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false,
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 2d8a5df56f20..979fd7c26610 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -342,7 +342,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 struct kvm_page_fault {
 	/* arguments to kvm_mmu_do_page_fault.  */
 	const gpa_t addr;
-	const u32 error_code;
+	const u64 error_code;
 	const bool prefetch;
 
 	/* Derived from error_code.  */
@@ -437,7 +437,7 @@ enum {
 };
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch, int *emulation_type)
+					u64 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 2d7555381955..2e77883c92f6 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -261,7 +261,7 @@ TRACE_EVENT(
 	TP_STRUCT__entry(
 		__field(int, vcpu_id)
 		__field(gpa_t, cr2_or_gpa)
-		__field(u32, error_code)
+		__field(u64, error_code)
 		__field(u64 *, sptep)
 		__field(u64, old_spte)
 		__field(u64, new_spte)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index d87f95245ee9..8aeafd9178ac 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -758,7 +758,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	struct guest_walker walker;
 	int r;
 
-	pgprintk("%s: addr %llx err %x\n", __func__, fault->addr, fault->error_code);
+	pgprintk("%s: addr %llx err %llx\n", __func__, fault->addr, fault->error_code);
 	WARN_ON_ONCE(fault->is_tdp);
 
 	/*
@@ -767,7 +767,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * The bit needs to be cleared before walking guest page tables.
 	 */
 	r = FNAME(walk_addr)(&walker, vcpu, fault->addr,
-			     fault->error_code & ~PFERR_RSVD_MASK);
+			     lower_32_bits(fault->error_code) & ~PFERR_RSVD_MASK);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
-- 
2.25.1




-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
