Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCF1672590
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjARRxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjARRxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:53:09 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3504ED35
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:08 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4c8e781bc0aso322282387b3.22
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y/aQGEWhRuKhdU97tjUDWVkirnC+I4AXp7DO2Wsa4lo=;
        b=XB/p1AALtI3X6uMMPvWkOozCAOCgk7D+y2dD88nHIrKGVLH7+GMDLhpuw20+r46Chw
         XpVFNY0K+3PpyjWpDh0HP4zveVwARtmDS/SLUyWSlOiSB6ZbtSqnk9iWxmCdSk7UVUzM
         +nJXXTMQp+MCiX9f7kEBr/3FP/opoGzUpmuxS7lGih51URv7jFRJNyeRaDMx6OYa62E/
         AM4Pm6VHuS/QLdkkSSKihT/Ap/YWJNBdOICM+OQdr2ENnshLtyRbIZuHj3F+RmQOKdxp
         kNfTIHXhEtnOCGrN9CcCWMQa/TFn08Yot6EN5L/89Zh/6fPTNt8Mv/3WaPVJh1Rv7Vi/
         K3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y/aQGEWhRuKhdU97tjUDWVkirnC+I4AXp7DO2Wsa4lo=;
        b=VrMEWpLLtoeK+M2Op3AndXW0oprARiR4pjmMSdh45xtagKwrrYgxmTRem/k5KjppJ/
         56+G1Y3NzVh20gN4Fz9ZLo9judC2fqa92m505JuiwbU7bIJHlnW/oZX+FJKjFD4QNbeS
         ntp5zQDgHTSA+saBL1FSoxuT6qwGrWZ6VZMlavZabxvTQSWZYmVObyt1NB3HSwcT36Wu
         Q+CKuLPPcLjj+g9GPB5iEXN8kY4YDg8kW2Q3KcggLoufXy798GRkbOL8TUVQTEmXHdF8
         EC9TKylCCAtC0dUHPIBKUzJKFs/limNAp2khlWDmu/mjG0zDc1RcldKgD1hYuF8KJ3zB
         cgSA==
X-Gm-Message-State: AFqh2kpo8fVP6y2YbbfvnQ00a2e3uPoldLVkYWWsV+jifREqU2PDUzpS
        f6OlI0GVk8coeOkDvgfERtMc4TYS42AJnw==
X-Google-Smtp-Source: AMrXdXupYn9/EOVE+uCqOkz9ARFLJbZM9eXjDoFO9rf0yqlHYPP6TuDXjwwLqlNKNkjlHAAz2w2agcziAZDptA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:dd88:0:b0:391:4ea8:d99 with SMTP id
 g130-20020a0ddd88000000b003914ea80d99mr1026327ywe.441.1674064387874; Wed, 18
 Jan 2023 09:53:07 -0800 (PST)
Date:   Wed, 18 Jan 2023 09:52:57 -0800
In-Reply-To: <20230118175300.790835-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230118175300.790835-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230118175300.790835-3-dmatlack@google.com>
Subject: [PATCH 2/5] KVM: Spell out parameter names in stats macros
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Spell out the parameter names in the various KVM stats macros. This
increases readability (e.g. _bucket_size vs. bsz).

Opportunistically add an underscore to all the macro parameter names for
consistency. Since these macros generate designated initializers, the
underscores are important to avoid clashing with field names.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 134 +++++++++++++++++++++------------------
 1 file changed, 73 insertions(+), 61 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e0f21bf8ff72..7ce196d69f64 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1744,101 +1744,113 @@ struct _kvm_stats_desc {
 	char name[KVM_STATS_NAME_SIZE];
 };
 
-#define STATS_DESC_COMMON(type, unit, base, exp, sz, bsz)		       \
-	.flags = type | unit | base |					       \
-		 BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |	       \
-		 BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |	       \
-		 BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),	       \
-	.exponent = exp,						       \
-	.size = sz,							       \
-	.bucket_size = bsz
-
-#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
+#define STATS_DESC_COMMON(_type, _unit, _base, _exponent, _size, _bucket_size) \
+	.flags = _type | _unit | _base |				       \
+		 BUILD_BUG_ON_ZERO(_type & ~KVM_STATS_TYPE_MASK) |	       \
+		 BUILD_BUG_ON_ZERO(_unit & ~KVM_STATS_UNIT_MASK) |	       \
+		 BUILD_BUG_ON_ZERO(_base & ~KVM_STATS_BASE_MASK),	       \
+	.exponent = _exponent,						       \
+	.size = _size,							       \
+	.bucket_size = _bucket_size
+
+#define VM_GENERIC_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,    \
+			      _bucket_size)				       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vm_stat, generic.stat)   \
+			STATS_DESC_COMMON(_type, _unit, _base, _exponent,      \
+					  _size, _bucket_size),		       \
+			.offset = offsetof(struct kvm_vm_stat, generic._stat)  \
 		},							       \
-		.name = #stat,						       \
+		.name = #_stat,						       \
 	}
-#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
+#define VCPU_GENERIC_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,  \
+				_bucket_size)				       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vcpu_stat, generic.stat) \
+			STATS_DESC_COMMON(_type, _unit, _base, _exponent,      \
+					  _size, _bucket_size),		       \
+			.offset =					       \
+				offsetof(struct kvm_vcpu_stat, generic._stat)  \
 		},							       \
-		.name = #stat,						       \
+		.name = #_stat,						       \
 	}
-#define VM_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
+#define VM_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,	       \
+		      _bucket_size)					       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vm_stat, stat)	       \
+			STATS_DESC_COMMON(_type, _unit, _base, _exponent,      \
+					  _size, _bucket_size),		       \
+			.offset = offsetof(struct kvm_vm_stat, _stat)	       \
 		},							       \
-		.name = #stat,						       \
+		.name = #_stat,						       \
 	}
-#define VCPU_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
+#define VCPU_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,	       \
+			_bucket_size)					       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vcpu_stat, stat)	       \
+			STATS_DESC_COMMON(_type, _unit, _base, _exponent,      \
+					  _size, _bucket_size),		       \
+			.offset = offsetof(struct kvm_vcpu_stat, _stat)	       \
 		},							       \
-		.name = #stat,						       \
+		.name = #_stat,						       \
 	}
 /* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
-#define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, bsz)		       \
-	SCOPE##_STATS_DESC(stat, type, unit, base, exp, sz, bsz)
-
-#define STATS_DESC_CUMULATIVE(SCOPE, stat, unit, base, exponent)	       \
-	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_CUMULATIVE,		       \
-		unit, base, exponent, 1, 0)
-#define STATS_DESC_INSTANT(SCOPE, stat, unit, base, exponent)		       \
-	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_INSTANT,			       \
-		unit, base, exponent, 1, 0)
-#define STATS_DESC_PEAK(SCOPE, stat, unit, base, exponent)		       \
-	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_PEAK,			       \
-		unit, base, exponent, 1, 0)
-#define STATS_DESC_LINEAR_HIST(SCOPE, stat, unit, base, exponent, sz, bsz)     \
-	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_LINEAR_HIST,		       \
-		unit, base, exponent, sz, bsz)
-#define STATS_DESC_LOG_HIST(SCOPE, stat, unit, base, exponent, sz)	       \
-	STATS_DESC(SCOPE, stat, KVM_STATS_TYPE_LOG_HIST,		       \
-		unit, base, exponent, sz, 0)
+#define STATS_DESC(SCOPE, _stat, _type, _unit, _base, _exponent, _size,        \
+		   _bucket_size)					       \
+	SCOPE##_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,       \
+			   _bucket_size)
+
+#define STATS_DESC_CUMULATIVE(SCOPE, _stat, _unit, _base, exponent)	       \
+	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_CUMULATIVE,		       \
+		_unit, _base, exponent, 1, 0)
+#define STATS_DESC_INSTANT(SCOPE, _stat, _unit, _base, exponent)	       \
+	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_INSTANT,		       \
+		_unit, _base, exponent, 1, 0)
+#define STATS_DESC_PEAK(SCOPE, _stat, _unit, _base, exponent)		       \
+	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_PEAK,			       \
+		_unit, _base, exponent, 1, 0)
+#define STATS_DESC_LINEAR_HIST(SCOPE, _stat, _unit, _base, exponent, _size,    \
+			       _bucket_size)				       \
+	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_LINEAR_HIST,		       \
+		_unit, _base, exponent, _size, _bucket_size)
+#define STATS_DESC_LOG_HIST(SCOPE, _stat, _unit, _base, exponent, _size)       \
+	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_LOG_HIST,		       \
+		_unit, _base, exponent, _size, 0)
 
 /* Cumulative counter, read/write */
-#define STATS_DESC_COUNTER(SCOPE, stat)					       \
-	STATS_DESC_CUMULATIVE(SCOPE, stat, KVM_STATS_UNIT_NONE,		       \
+#define STATS_DESC_COUNTER(SCOPE, _stat)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, _stat, KVM_STATS_UNIT_NONE,	       \
 		KVM_STATS_BASE_POW10, 0)
 /* Instantaneous counter, read only */
-#define STATS_DESC_ICOUNTER(SCOPE, stat)				       \
-	STATS_DESC_INSTANT(SCOPE, stat, KVM_STATS_UNIT_NONE,		       \
+#define STATS_DESC_ICOUNTER(SCOPE, _stat)				       \
+	STATS_DESC_INSTANT(SCOPE, _stat, KVM_STATS_UNIT_NONE,		       \
 		KVM_STATS_BASE_POW10, 0)
 /* Peak counter, read/write */
-#define STATS_DESC_PCOUNTER(SCOPE, stat)				       \
-	STATS_DESC_PEAK(SCOPE, stat, KVM_STATS_UNIT_NONE,		       \
+#define STATS_DESC_PCOUNTER(SCOPE, _stat)				       \
+	STATS_DESC_PEAK(SCOPE, _stat, KVM_STATS_UNIT_NONE,		       \
 		KVM_STATS_BASE_POW10, 0)
 
 /* Instantaneous boolean value, read only */
-#define STATS_DESC_IBOOLEAN(SCOPE, stat)				       \
-	STATS_DESC_INSTANT(SCOPE, stat, KVM_STATS_UNIT_BOOLEAN,		       \
+#define STATS_DESC_IBOOLEAN(SCOPE, _stat)				       \
+	STATS_DESC_INSTANT(SCOPE, _stat, KVM_STATS_UNIT_BOOLEAN,	       \
 		KVM_STATS_BASE_POW10, 0)
 /* Peak (sticky) boolean value, read/write */
-#define STATS_DESC_PBOOLEAN(SCOPE, stat)				       \
-	STATS_DESC_PEAK(SCOPE, stat, KVM_STATS_UNIT_BOOLEAN,		       \
+#define STATS_DESC_PBOOLEAN(SCOPE, _stat)				       \
+	STATS_DESC_PEAK(SCOPE, _stat, KVM_STATS_UNIT_BOOLEAN,		       \
 		KVM_STATS_BASE_POW10, 0)
 
 /* Cumulative time in nanosecond */
-#define STATS_DESC_TIME_NSEC(SCOPE, stat)				       \
-	STATS_DESC_CUMULATIVE(SCOPE, stat, KVM_STATS_UNIT_SECONDS,	       \
+#define STATS_DESC_TIME_NSEC(SCOPE, _stat)				       \
+	STATS_DESC_CUMULATIVE(SCOPE, _stat, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, -9)
 /* Linear histogram for time in nanosecond */
-#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, stat, sz, bsz)		       \
-	STATS_DESC_LINEAR_HIST(SCOPE, stat, KVM_STATS_UNIT_SECONDS,	       \
-		KVM_STATS_BASE_POW10, -9, sz, bsz)
+#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, _stat, _size, _bucket_size)	       \
+	STATS_DESC_LINEAR_HIST(SCOPE, _stat, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, _size, _bucket_size)
 /* Logarithmic histogram for time in nanosecond */
-#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, stat, sz)			       \
-	STATS_DESC_LOG_HIST(SCOPE, stat, KVM_STATS_UNIT_SECONDS,	       \
-		KVM_STATS_BASE_POW10, -9, sz)
+#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, _stat, _size)		       \
+	STATS_DESC_LOG_HIST(SCOPE, _stat, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, _size)
 
 #define KVM_GENERIC_VM_STATS()						       \
 	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),		       \
-- 
2.39.0.246.g2a6d74b583-goog

