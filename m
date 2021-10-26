Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD89643A932
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 02:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhJZAZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 20:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbhJZAZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 20:25:20 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79C6C061745
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 17:22:57 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id v1-20020a17090a088100b001a21156830bso765906pjc.1
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 17:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8MJkxFXnTdTQg1tWaJuynFwFllV0sR389qKLE8Dsarc=;
        b=PUXIQcIHk+jqVydEXxeKJqmADEQwKao3vRNOlHO1VeCSAwoWNHdO80o2C2C35x6GmE
         NFbxyjcvZ+d9aIhNJGCEm8TgvAlS+f7w6/oVu8/UbPUYQ5VrXCJCmeUK7fqcMlBgG9CU
         alOI4bkOJp0JT669FKwRgZEaDFQtZHJ8ckAlzO+TjkU0R9yErwJ/gkpD0vySn935+cLY
         m4lZi6avlIwI5SPm/fRAxwujnhe+cAcK+cKfpB2u5KIIKgbAQ/a/eFtk9Rat8MmJI4m8
         0Y63+y+voTofRsQD0vMRGN1hgbmdw+xEwfqknPzfsLT5xJD4o2GqnIY7Hd9jhQnp7/xX
         KJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8MJkxFXnTdTQg1tWaJuynFwFllV0sR389qKLE8Dsarc=;
        b=X8yJ0/YLUgbDZKIgD3mZ305qK3BufcQGCCDj7I+9SUI7yqxFQueLDMpNCoGCRAHFbj
         A5CEBFvKAN6ACkxHbKxti9FjDWLkXetbXjmb8XwFxRnlA+qqV61X/UFTt4lx0DDbtDdi
         ATug3z87hXiryqdffWU3LDpPHbc2MkycXjxShEBP6Q6ACWpAnpof4rhD1V3F77cQoN3B
         J507yuT/GvAzyBAqLoL5cWFsLBXyTeen10OitzaE6IfzZMJpksr6kYamNt+y8f7jW0L7
         ub3vB5RzcnQuuGImPOK2M5sNgwzTLsrYEl2YQBxaM7LaiyeA+Q720v3h6TAHgyYwud6s
         hELQ==
X-Gm-Message-State: AOAM533slquPGs6M6nE9N6UQru7Uqji6enXxH4TqvxQkRvC1QtyabOFz
        HnL3GO6ospacoYAtnVBpvjqnp1HFN2k=
X-Google-Smtp-Source: ABdhPJxpPsgEcP3OiMOJDlH56vwfYLXOOQwpNdFGEk6uvXEvaNoeoFp8p+mWu1+VhGCjltiDfCOD/g==
X-Received: by 2002:a17:903:22d1:b0:140:53fb:e546 with SMTP id y17-20020a17090322d100b0014053fbe546mr9131273plg.25.1635207777095;
        Mon, 25 Oct 2021 17:22:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lr3sm2086610pjb.3.2021.10.25.17.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 17:22:56 -0700 (PDT)
Date:   Tue, 26 Oct 2021 00:22:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ajay Garg <ajaygargnsit@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: (64-bit x86_64 machine) : fix
 -frame-larger-than warnings/errors.
Message-ID: <YXdKXOfWZNAHCQkS@google.com>
References: <1631894159-10146-1-git-send-email-ajaygargnsit@gmail.com>
 <YWcswAD9dmYun+sI@google.com>
 <CAHP4M8XwS-4W6gWga5C=AgipJntR3X944kJ3v4CXkZ+BTTUZbg@mail.gmail.com>
 <CAHP4M8VzjPgzBmfn2DAdGD0P9OBF7_cafPP8nrjvTampGLoxyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHP4M8VzjPgzBmfn2DAdGD0P9OBF7_cafPP8nrjvTampGLoxyA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 24, 2021, Ajay Garg wrote:
> Hi Sean.
> 
> Today I enabled a debug-build, and the compilation broke again.
> 
> 1.
> Please find attached the .config  file.

Aha!  The problem is CONFIG_KASAN_STACK=y, which is selected (and can't be
unselected) by CONFIG_KASAN=y when compiling with gcc (clang/LLVM is a stack hog
in some cases so it's opt-in for clang).  KASAN_STACK adds a redzone around every
stack variable, which pushes the Hyper-V functions over the limit.

> Please let know if/when I should float a v2 patch.

I still don't love hoisting sparse_banks up a level, that info really shouldn't
bleed into the caller.  My alternative solution is to push vp_bitmap down into
sparse_set_to_vcpu_mask().  That doesn't "free" up as much stack, but it's enough
to get under the 1024 byte default.  It's also nice in that it hides the VP
index mismatch logic in sparse_set_to_vcpu_mask().

I'll post a proper patch tomorrow (completely untested):

---
 arch/x86/kvm/hyperv.c | 55 ++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4f15c0165c05..80018cfab5c7 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1710,31 +1710,36 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 		return kvm_hv_get_msr(vcpu, msr, pdata, host);
 }

-static __always_inline unsigned long *sparse_set_to_vcpu_mask(
-	struct kvm *kvm, u64 *sparse_banks, u64 valid_bank_mask,
-	u64 *vp_bitmap, unsigned long *vcpu_bitmap)
+static void sparse_set_to_vcpu_mask(struct kvm *kvm, u64 *sparse_banks,
+				    u64 valid_bank_mask, unsigned long *vcpu_mask)
 {
 	struct kvm_hv *hv = to_kvm_hv(kvm);
+	bool has_mismatch = atomic_read(&hv->num_mismatched_vp_indexes);
+	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	struct kvm_vcpu *vcpu;
 	int i, bank, sbank = 0;
+	u64 *bitmap;

-	memset(vp_bitmap, 0,
-	       KVM_HV_MAX_SPARSE_VCPU_SET_BITS * sizeof(*vp_bitmap));
+	BUILD_BUG_ON(sizeof(vp_bitmap) >
+		     sizeof(*vcpu_mask) * BITS_TO_LONGS(KVM_MAX_VCPUS));
+
+	/* If vp_index == vcpu_idx for all vCPUs, fill vcpu_mask directly. */
+	if (likely(!has_mismatch))
+		bitmap = (u64 *)vcpu_mask;
+
+	memset(bitmap, 0, sizeof(vp_bitmap));
 	for_each_set_bit(bank, (unsigned long *)&valid_bank_mask,
 			 KVM_HV_MAX_SPARSE_VCPU_SET_BITS)
-		vp_bitmap[bank] = sparse_banks[sbank++];
+		bitmap[bank] = sparse_banks[sbank++];

-	if (likely(!atomic_read(&hv->num_mismatched_vp_indexes))) {
-		/* for all vcpus vp_index == vcpu_idx */
-		return (unsigned long *)vp_bitmap;
-	}
+	if (likely(!has_mismatch))
+		return;

-	bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
+	bitmap_zero(vcpu_mask, KVM_MAX_VCPUS);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (test_bit(kvm_hv_get_vpindex(vcpu), (unsigned long *)vp_bitmap))
-			__set_bit(i, vcpu_bitmap);
+			__set_bit(i, vcpu_mask);
 	}
-	return vcpu_bitmap;
 }

 struct kvm_hv_hcall {
@@ -1756,9 +1761,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
-	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
-	unsigned long *vcpu_mask;
+	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	u64 valid_bank_mask;
 	u64 sparse_banks[64];
 	int sparse_banks_len;
@@ -1842,11 +1845,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	if (all_cpus) {
 		kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
 	} else {
-		vcpu_mask = sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
-						    vp_bitmap, vcpu_bitmap);
+		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);

-		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
-					    vcpu_mask);
+		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST, vcpu_mask);
 	}

 ret_success:
@@ -1879,9 +1880,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
-	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
-	unsigned long *vcpu_mask;
+	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	unsigned long valid_bank_mask;
 	u64 sparse_banks[64];
 	int sparse_banks_len;
@@ -1937,11 +1936,13 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;

-	vcpu_mask = all_cpus ? NULL :
-		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
-					vp_bitmap, vcpu_bitmap);
+	if (all_cpus) {
+		kvm_send_ipi_to_many(kvm, vector, NULL);
+	} else {
+		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);

-	kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
+		kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
+	}

 ret_success:
 	return HV_STATUS_SUCCESS;
--
2.33.0.1079.g6e70778dc9-goog
