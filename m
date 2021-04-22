Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FFD3677B1
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhDVDF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbhDVDF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:05:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C94C06138B
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f7-20020a5b0c070000b02904e9a56ee7e7so18283295ybq.9
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oqXnB18Ax7b6aAuAH2aihu2SiLN86gXq87hlcE6md0Y=;
        b=ZSsaE9wLdrwdJaQgqY4AwfoH5qCEJkPX/kiWTYVFS5Pp18DFEe/oYS5pHWw9XjZN48
         9Hm2SE1y6ndCmEF30oavTB3tQKJILwpqNvV7XQLUn36Wz65DC3eRbEQTRq/YhSZCj22z
         GnkCrC6KXR/jt/p7n+qwuXh8ydSLwESQxoYiFeUxGXs5A4A+PaaXrPv8uMqioxbeDGht
         5orYv34OUU86JAx6TG9AK1qADlxvQe6IRqL7x98oWbU8KlQ5hXUZOUxXvsbNb1FffyYl
         RnaSxLgPoJHUFaBMtQAdH0e2eUFBGQv3l/LWf3ACac0ISUHZZuOZsdtOJ1st2ncZD3Fx
         zQ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oqXnB18Ax7b6aAuAH2aihu2SiLN86gXq87hlcE6md0Y=;
        b=PbuN0lw166eWfqeyjkgoLfnFsdpXBE4RjesypT8IVSxHT+jyMmCnVQwKoKjRd6g59a
         nAJnjjgm3fp9XEEtTXIxjYiEtVS4MQ4VFRH86Y2uXtMzA2g7nREqksDwg2qqVD2S13FK
         0798142oSguV1Jccj+LH96l9J9BB0VZz7g5GitkPi17ZdrPu5DDaOgtclT9pcYEwXz/k
         aT5oXXK4W0HW8ogJY2q1QTE4j5RKTZAKbteHGeCu9sILGGAWTyMjPeZNhE24XXuDoa+C
         r0btHOm2eydReYwM6c/e5VbbSXonDv/f2xufpm1EZE49nckuBg95a36cPTmnbvrCJSWe
         1Zbg==
X-Gm-Message-State: AOAM532RsKYFKqA2981T7LSciRDuvVWSNy3yJe70Zg6MdwvzTfU69Qtq
        BePXAqSV5ROx7BW087gcwRCgohQ/xYM=
X-Google-Smtp-Source: ABdhPJzWOYk0HRj/pAVSEYAcRpOxb28ToHI6Bb5QDAW0IPuULmctDVc8C8sdd6jhw+mVuV3Y229i96uEPCc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:9b46:: with SMTP id u6mr1652057ybo.218.1619060722249;
 Wed, 21 Apr 2021 20:05:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:04:56 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 06/14] x86: msr: Replace spaces with tabs in
 all of msr.c
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bulk of msr.c is about to get rewritten, replace spaces with tabs so
the upcoming changes don't have to propagate the existing indentation,
which is a royal pain for folks whose setup assumes kernel coding style.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 167 +++++++++++++++++++++++++++---------------------------
 1 file changed, 83 insertions(+), 84 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 5a3f1c3..1589b3b 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -5,13 +5,13 @@
 #include "msr.h"
 
 struct msr_info {
-    int index;
-    const char *name;
-    struct tc {
-        int valid;
-        unsigned long long value;
-        unsigned long long expected;
-    } val_pairs[20];
+	int index;
+	const char *name;
+	struct tc {
+		int valid;
+		unsigned long long value;
+		unsigned long long expected;
+	} val_pairs[20];
 };
 
 
@@ -20,98 +20,97 @@ struct msr_info {
 
 struct msr_info msr_info[] =
 {
-    { .index = 0x00000174, .name = "IA32_SYSENTER_CS",
-      .val_pairs = {{ .valid = 1, .value = 0x1234, .expected = 0x1234}}
-    },
-    { .index = 0x00000175, .name = "MSR_IA32_SYSENTER_ESP",
-      .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
-    },
-    { .index = 0x00000176, .name = "IA32_SYSENTER_EIP",
-      .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
-    },
-    { .index = 0x000001a0, .name = "MSR_IA32_MISC_ENABLE",
-      // reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
-      .val_pairs = {{ .valid = 1, .value = 0x400c51889, .expected = 0x400c51889}}
-    },
-    { .index = 0x00000277, .name = "MSR_IA32_CR_PAT",
-      .val_pairs = {{ .valid = 1, .value = 0x07070707, .expected = 0x07070707}}
-    },
+	{ .index = 0x00000174, .name = "IA32_SYSENTER_CS",
+	  .val_pairs = {{ .valid = 1, .value = 0x1234, .expected = 0x1234}}
+	},
+	{ .index = 0x00000175, .name = "MSR_IA32_SYSENTER_ESP",
+	  .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
+	},
+	{ .index = 0x00000176, .name = "IA32_SYSENTER_EIP",
+	  .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
+	},
+	{ .index = 0x000001a0, .name = "MSR_IA32_MISC_ENABLE",
+	  // reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
+	  .val_pairs = {{ .valid = 1, .value = 0x400c51889, .expected = 0x400c51889}}
+	},
+	{ .index = 0x00000277, .name = "MSR_IA32_CR_PAT",
+	  .val_pairs = {{ .valid = 1, .value = 0x07070707, .expected = 0x07070707}}
+	},
 #ifdef __x86_64__
-    { .index = 0xc0000100, .name = "MSR_FS_BASE",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
-    },
-    { .index = 0xc0000101, .name = "MSR_GS_BASE",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
-    },
-    { .index = 0xc0000102, .name = "MSR_KERNEL_GS_BASE",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
-    },
-    { .index = 0xc0000080, .name = "MSR_EFER",
-      .val_pairs = {{ .valid = 1, .value = 0xD00, .expected = 0xD00}}
-    },
-    { .index = 0xc0000082, .name = "MSR_LSTAR",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
-    },
-    { .index = 0xc0000083, .name = "MSR_CSTAR",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
-    },
-    { .index = 0xc0000084, .name = "MSR_SYSCALL_MASK",
-      .val_pairs = {{ .valid = 1, .value = 0xffffffff, .expected = 0xffffffff}}
-    },
+	{ .index = 0xc0000100, .name = "MSR_FS_BASE",
+	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+	},
+	{ .index = 0xc0000101, .name = "MSR_GS_BASE",
+	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+	},
+	{ .index = 0xc0000102, .name = "MSR_KERNEL_GS_BASE",
+	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+	},
+	{ .index = 0xc0000080, .name = "MSR_EFER",
+	  .val_pairs = {{ .valid = 1, .value = 0xD00, .expected = 0xD00}}
+	},
+	{ .index = 0xc0000082, .name = "MSR_LSTAR",
+	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+	},
+	{ .index = 0xc0000083, .name = "MSR_CSTAR",
+	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+	},
+	{ .index = 0xc0000084, .name = "MSR_SYSCALL_MASK",
+	  .val_pairs = {{ .valid = 1, .value = 0xffffffff, .expected = 0xffffffff}}
+	},
 #endif
 
-//    MSR_IA32_DEBUGCTLMSR needs svm feature LBRV
-//    MSR_VM_HSAVE_PA only AMD host
+//	MSR_IA32_DEBUGCTLMSR needs svm feature LBRV
+//	MSR_VM_HSAVE_PA only AMD host
 };
 
 static int find_msr_info(int msr_index)
 {
-    int i;
-    for (i = 0; i < sizeof(msr_info)/sizeof(msr_info[0]) ; i++) {
-        if (msr_info[i].index == msr_index) {
-            return i;
-        }
-    }
-    return -1;
+	int i;
+
+	for (i = 0; i < sizeof(msr_info)/sizeof(msr_info[0]) ; i++) {
+		if (msr_info[i].index == msr_index)
+			return i;
+	}
+	return -1;
 }
 
 static void test_msr_rw(int msr_index, unsigned long long input, unsigned long long expected)
 {
-    unsigned long long r, orig;
-    int index;
-    const char *sptr;
-    if ((index = find_msr_info(msr_index)) != -1) {
-        sptr = msr_info[index].name;
-    } else {
-        printf("couldn't find name for msr # %#x, skipping\n", msr_index);
-        return;
-    }
+	unsigned long long r, orig;
+	int index;
+	const char *sptr;
 
-    orig = rdmsr(msr_index);
-    wrmsr(msr_index, input);
-    r = rdmsr(msr_index);
-    wrmsr(msr_index, orig);
-    if (expected != r) {
-        printf("testing %s: output = %#" PRIx32 ":%#" PRIx32
-	       " expected = %#" PRIx32 ":%#" PRIx32 "\n", sptr,
-               (u32)(r >> 32), (u32)r, (u32)(expected >> 32), (u32)expected);
-    }
-    report(expected == r, "%s", sptr);
+	if ((index = find_msr_info(msr_index)) != -1) {
+		sptr = msr_info[index].name;
+	} else {
+		printf("couldn't find name for msr # %#x, skipping\n", msr_index);
+		return;
+	}
+	orig = rdmsr(msr_index);
+	wrmsr(msr_index, input);
+	r = rdmsr(msr_index);
+	wrmsr(msr_index, orig);
+	if (expected != r) {
+		printf("testing %s: output = %#" PRIx32 ":%#" PRIx32
+		       " expected = %#" PRIx32 ":%#" PRIx32 "\n", sptr,
+		       (u32)(r >> 32), (u32)r, (u32)(expected >> 32), (u32)expected);
+	}
+	report(expected == r, "%s", sptr);
 }
 
 int main(int ac, char **av)
 {
-    int i, j;
-    for (i = 0 ; i < sizeof(msr_info) / sizeof(msr_info[0]); i++) {
-        for (j = 0; j < sizeof(msr_info[i].val_pairs) / sizeof(msr_info[i].val_pairs[0]); j++) {
-            if (msr_info[i].val_pairs[j].valid) {
-                test_msr_rw(msr_info[i].index, msr_info[i].val_pairs[j].value, msr_info[i].val_pairs[j].expected);
-            } else {
-                break;
-            }
-        }
-    }
+	int i, j;
+	for (i = 0 ; i < sizeof(msr_info) / sizeof(msr_info[0]); i++) {
+		for (j = 0; j < sizeof(msr_info[i].val_pairs) / sizeof(msr_info[i].val_pairs[0]); j++) {
+			if (msr_info[i].val_pairs[j].valid) {
+				test_msr_rw(msr_info[i].index, msr_info[i].val_pairs[j].value, msr_info[i].val_pairs[j].expected);
+			} else {
+				break;
+			}
+		}
+	}
 
-    return report_summary();
+	return report_summary();
 }
-
-- 
2.31.1.498.g6c1eba8ee3d-goog

