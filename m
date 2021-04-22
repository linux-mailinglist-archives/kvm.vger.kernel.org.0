Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830193677B4
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhDVDGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbhDVDGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:06:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125AAC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e8-20020a2587480000b02904e5857564e2so18362124ybn.16
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/hPihdfDLlJWXy3VwGT97nXrafoTQe+XsLxpHyUwmm0=;
        b=RlQGgr8PUsUZg6eknFtouf441XPTLk08Wzs0I9AceK0k0Aufd3Gxwanh0Cqgx7yLKL
         tOcCpnDuxqLspLHy6u3OvM6z1JH8atO8gbdgIJtVYS4SOITsySY6dEH/xufxl/3PocpR
         9cFoUV/36GTzYmKYU0SXrVxcFydHocYk6sAthm8pQb3ScB8yRpQBS0v49On/9L5kcrKK
         +gGsQ9o7/f7v0SVb5o0yjQ/hGJA/7PHIul00HQQP4pwrI+6CA3FvKOHdHOdrWyTX37/v
         W2MKei0FPl8AuW8NMGNlauEQAqU/ZgaCGB3STuM7sJVxNPBZxuIgskZp07Yr7Ac+lrO1
         H4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/hPihdfDLlJWXy3VwGT97nXrafoTQe+XsLxpHyUwmm0=;
        b=KTnSmVGioxIF9/bsh5Ll7xP0swi3yYdwZITTSpTkc1ZjOf2rdC+EEfwNBmwuiT9mN/
         jQurxPLMq8HNvtmXYYnI4xd7An+CKWYnc2ukGvdpEl7Ma97tDrWMId/eU2INQWuu3WSI
         F6sVYO8ByLAY9nJCayvu6ZWL/okZo+psS7yDNNxG+WlEWLT/5noXCFPO3ysG5sCLn8su
         z/lIk3B/UEnEyXmFHW3GDhJ3t0lrTAAC3eG1NuDnUXnKDx3rvROKTMH429++ejeRMyJg
         IgsP2dese2XsKnHD/dA8GE9pINFQ/XYcDJgFyjYMbXh21vbH5ihBrXKdU3uaXjFjqDAD
         pXVQ==
X-Gm-Message-State: AOAM531GpS02/F8V7+RhLbPT2j+7E5EpJVpzc9S+ejbDrTZDlzHh5Au8
        u1zBokx4WRPdddn3tNB+5IqXKV4AAlA=
X-Google-Smtp-Source: ABdhPJyV5LcQ281d42gUiijX8MdxU0V6hftFZK7vQqp/1Y+93V8FWtIWR5uFxWIAx/hDkELVWXIxZmAxJSU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:3450:: with SMTP id b77mr1537793yba.211.1619060729041;
 Wed, 21 Apr 2021 20:05:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:04:59 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 09/14] x86: msr: Drop the explicit expected value
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the written value as the expected value.  For the vast majority of
MSRs, including all those currently tested, the expected value will
always be the last written value.  This will simplify handling EFER on
32-bit vCPUs in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 0fc7978..9031043 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -21,42 +21,42 @@ struct msr_info {
 struct msr_info msr_info[] =
 {
 	{ .index = MSR_IA32_SYSENTER_CS, .name = "MSR_IA32_SYSENTER_CS",
-	  .val_pairs = {{ .valid = 1, .value = 0x1234, .expected = 0x1234}}
+	  .val_pairs = {{ .valid = 1, .value = 0x1234 }}
 	},
 	{ .index = MSR_IA32_SYSENTER_ESP, .name = "MSR_IA32_SYSENTER_ESP",
-	  .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
+	  .val_pairs = {{ .valid = 1, .value = addr_ul }}
 	},
 	{ .index = MSR_IA32_SYSENTER_EIP, .name = "MSR_IA32_SYSENTER_EIP",
-	  .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
+	  .val_pairs = {{ .valid = 1, .value = addr_ul }}
 	},
 	{ .index = MSR_IA32_MISC_ENABLE, .name = "MSR_IA32_MISC_ENABLE",
 	  // reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
-	  .val_pairs = {{ .valid = 1, .value = 0x400c51889, .expected = 0x400c51889}}
+	  .val_pairs = {{ .valid = 1, .value = 0x400c51889 }}
 	},
 	{ .index = MSR_IA32_CR_PAT, .name = "MSR_IA32_CR_PAT",
-	  .val_pairs = {{ .valid = 1, .value = 0x07070707, .expected = 0x07070707}}
+	  .val_pairs = {{ .valid = 1, .value = 0x07070707 }}
 	},
 #ifdef __x86_64__
 	{ .index = MSR_FS_BASE, .name = "MSR_FS_BASE",
-	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+	  .val_pairs = {{ .valid = 1, .value = addr_64 }}
 	},
 	{ .index = MSR_GS_BASE, .name = "MSR_GS_BASE",
-	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+	  .val_pairs = {{ .valid = 1, .value = addr_64 }}
 	},
 	{ .index = MSR_KERNEL_GS_BASE, .name = "MSR_KERNEL_GS_BASE",
-	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+	  .val_pairs = {{ .valid = 1, .value = addr_64 }}
 	},
 	{ .index = MSR_EFER, .name = "MSR_EFER",
-	  .val_pairs = {{ .valid = 1, .value = 0xD00, .expected = 0xD00}}
+	  .val_pairs = {{ .valid = 1, .value = 0xD00 }}
 	},
 	{ .index = MSR_LSTAR, .name = "MSR_LSTAR",
-	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+	  .val_pairs = {{ .valid = 1, .value = addr_64 }}
 	},
 	{ .index = MSR_CSTAR, .name = "MSR_CSTAR",
-	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+	  .val_pairs = {{ .valid = 1, .value = addr_64 }}
 	},
 	{ .index = MSR_SYSCALL_MASK, .name = "MSR_SYSCALL_MASK",
-	  .val_pairs = {{ .valid = 1, .value = 0xffffffff, .expected = 0xffffffff}}
+	  .val_pairs = {{ .valid = 1, .value = 0xffffffff }}
 	},
 #endif
 
@@ -75,7 +75,7 @@ static int find_msr_info(int msr_index)
 	return -1;
 }
 
-static void test_msr_rw(int msr_index, unsigned long long input, unsigned long long expected)
+static void test_msr_rw(int msr_index, unsigned long long val)
 {
 	unsigned long long r, orig;
 	int index;
@@ -87,16 +87,17 @@ static void test_msr_rw(int msr_index, unsigned long long input, unsigned long l
 		printf("couldn't find name for msr # %#x, skipping\n", msr_index);
 		return;
 	}
+
 	orig = rdmsr(msr_index);
-	wrmsr(msr_index, input);
+	wrmsr(msr_index, val);
 	r = rdmsr(msr_index);
 	wrmsr(msr_index, orig);
-	if (expected != r) {
+	if (r != val) {
 		printf("testing %s: output = %#" PRIx32 ":%#" PRIx32
 		       " expected = %#" PRIx32 ":%#" PRIx32 "\n", sptr,
-		       (u32)(r >> 32), (u32)r, (u32)(expected >> 32), (u32)expected);
+		       (u32)(r >> 32), (u32)r, (u32)(val >> 32), (u32)val);
 	}
-	report(expected == r, "%s", sptr);
+	report(val == r, "%s", sptr);
 }
 
 int main(int ac, char **av)
@@ -105,7 +106,7 @@ int main(int ac, char **av)
 	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
 		for (j = 0; j < ARRAY_SIZE(msr_info[i].val_pairs); j++) {
 			if (msr_info[i].val_pairs[j].valid) {
-				test_msr_rw(msr_info[i].index, msr_info[i].val_pairs[j].value, msr_info[i].val_pairs[j].expected);
+				test_msr_rw(msr_info[i].index, msr_info[i].val_pairs[j].value);
 			} else {
 				break;
 			}
-- 
2.31.1.498.g6c1eba8ee3d-goog

