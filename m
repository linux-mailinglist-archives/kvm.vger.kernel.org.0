Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7A9544022
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiFHXvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbiFHXu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:50:56 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5C66462
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:45 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q1-20020a17090a1b0100b001e8884afce1so3870301pjq.7
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=LiSHKE7a+E/GY5og7JoA/S6wQmqaF/+w68WQWWmHAQE=;
        b=Pvw5APkimkYljtKivSe9I3A1gq9OD3148QlpnEeJc0XgcmRxVi2OZhQUr6SX2zutk7
         W+kiiuU44h0yqQnwY5qWQS+BUEsTpVtWw+aOCJiNy85DP7s30y1RTckoJzOd2nHn+3lA
         nO46NP5nquS79nye8zTxJL5LOF/Mi6Q40FSJ+5RqdhIUk3SHnibGbgfd2jS09xuNCQq2
         AWpMtBdkyeMH67Xyj73111lcnMRPhAaIsBVuiUEGdWE/KlXB+yGjKJMlaf+cHGtOclpm
         Hsax28pErUWTKmIlMt/y0iNVdR2p2V+y35+YHKolV56Ms4BtUWU8dphf0Ppnmr10rqxm
         wsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=LiSHKE7a+E/GY5og7JoA/S6wQmqaF/+w68WQWWmHAQE=;
        b=SUcxExD/lP6R/3vktmYCIgqtUNUdWnQSIc2rfpt1EccWnf1cM5v1yvdbjLrd9wBvvP
         BhV7t4YZU83rdxULdWGaoGZEyXP7M0h5aUUUDCrQbYQfMw0IgvjKNpWlfJYQh5Bq0XXe
         63rdRXXZnRKE7u7QwD61faqAkVV4oGuBFBcw73DgwT05oqov5BSLsOJtj/Yh9jkFm6Kr
         RV+uF3ObIPGb1PS2rPKq0ey+WEQ86bA1f10BJeZslzPTHfOvorcXVaCu5+sVHY6uk0XA
         pQ+6jF9v1iBdtXkFr0TUPFHtr4gvqaevgKo79+/aJ3L1JHIA8DDHTR2RAk7g2TX7hj1E
         G9TA==
X-Gm-Message-State: AOAM531pJ0m9BChFfph1Cr49Qp9knCvzC4Cku+ZcYg2xHOXJae0hfjus
        krKXNxEYMnO/3e9u7xtfNsXee3xe88k=
X-Google-Smtp-Source: ABdhPJyYv3CLt/q6okOXFgnGZ0Fgi71wa+n2S5u9zrxB4Rh32Qmr5+RxLgHxbGnYi6vF+h8CBemMhgnGAX0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ed53:b0:166:3e43:7522 with SMTP id
 y19-20020a170902ed5300b001663e437522mr35820215plb.170.1654732364734; Wed, 08
 Jun 2022 16:52:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:30 +0000
In-Reply-To: <20220608235238.3881916-1-seanjc@google.com>
Message-Id: <20220608235238.3881916-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220608235238.3881916-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 02/10] x86: Replace spaces with tables in processor.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the myriad instances of using spaces instead of tabs in processor.h.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 250 ++++++++++++++++++++++----------------------
 1 file changed, 125 insertions(+), 125 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 1dfd5285..13d9d9bb 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -7,7 +7,7 @@
 #include <bitops.h>
 #include <stdint.h>
 
-#define NONCANONICAL            0xaaaaaaaaaaaaaaaaull
+#define NONCANONICAL	0xaaaaaaaaaaaaaaaaull
 
 #ifdef __x86_64__
 #  define R "r"
@@ -112,31 +112,31 @@ struct cpuid { u32 a, b, c, d; };
 
 static inline struct cpuid raw_cpuid(u32 function, u32 index)
 {
-    struct cpuid r;
-    asm volatile ("cpuid"
-                  : "=a"(r.a), "=b"(r.b), "=c"(r.c), "=d"(r.d)
-                  : "0"(function), "2"(index));
-    return r;
+	struct cpuid r;
+	asm volatile ("cpuid"
+		      : "=a"(r.a), "=b"(r.b), "=c"(r.c), "=d"(r.d)
+		      : "0"(function), "2"(index));
+	return r;
 }
 
 static inline struct cpuid cpuid_indexed(u32 function, u32 index)
 {
-    u32 level = raw_cpuid(function & 0xf0000000, 0).a;
-    if (level < function)
-        return (struct cpuid) { 0, 0, 0, 0 };
-    return raw_cpuid(function, index);
+	u32 level = raw_cpuid(function & 0xf0000000, 0).a;
+	if (level < function)
+	return (struct cpuid) { 0, 0, 0, 0 };
+	return raw_cpuid(function, index);
 }
 
 static inline struct cpuid cpuid(u32 function)
 {
-    return cpuid_indexed(function, 0);
+	return cpuid_indexed(function, 0);
 }
 
 static inline u8 cpuid_maxphyaddr(void)
 {
-    if (raw_cpuid(0x80000000, 0).a < 0x80000008)
-        return 36;
-    return raw_cpuid(0x80000008, 0).a & 0xff;
+	if (raw_cpuid(0x80000000, 0).a < 0x80000008)
+	return 36;
+	return raw_cpuid(0x80000008, 0).a & 0xff;
 }
 
 static inline bool is_intel(void)
@@ -178,7 +178,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_XMM2		(CPUID(0x1, 0, EDX, 26))
 #define	X86_FEATURE_TSC_ADJUST		(CPUID(0x7, 0, EBX, 1))
 #define	X86_FEATURE_HLE			(CPUID(0x7, 0, EBX, 4))
-#define	X86_FEATURE_SMEP	        (CPUID(0x7, 0, EBX, 7))
+#define	X86_FEATURE_SMEP		(CPUID(0x7, 0, EBX, 7))
 #define	X86_FEATURE_INVPCID		(CPUID(0x7, 0, EBX, 10))
 #define	X86_FEATURE_RTM			(CPUID(0x7, 0, EBX, 11))
 #define	X86_FEATURE_SMAP		(CPUID(0x7, 0, EBX, 20))
@@ -208,9 +208,9 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
 #define	X86_FEATURE_LBRV		(CPUID(0x8000000A, 0, EDX, 1))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
-#define X86_FEATURE_TSCRATEMSR  (CPUID(0x8000000A, 0, EDX, 4))
-#define X86_FEATURE_PAUSEFILTER     (CPUID(0x8000000A, 0, EDX, 10))
-#define X86_FEATURE_PFTHRESHOLD     (CPUID(0x8000000A, 0, EDX, 12))
+#define X86_FEATURE_TSCRATEMSR		(CPUID(0x8000000A, 0, EDX, 4))
+#define X86_FEATURE_PAUSEFILTER		(CPUID(0x8000000A, 0, EDX, 10))
+#define X86_FEATURE_PFTHRESHOLD		(CPUID(0x8000000A, 0, EDX, 12))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
 
 
@@ -235,66 +235,66 @@ struct far_pointer32 {
 } __attribute__((packed));
 
 struct descriptor_table_ptr {
-    u16 limit;
-    ulong base;
+	u16 limit;
+	ulong base;
 } __attribute__((packed));
 
 static inline void clac(void)
 {
-    asm volatile (".byte 0x0f, 0x01, 0xca" : : : "memory");
+	asm volatile (".byte 0x0f, 0x01, 0xca" : : : "memory");
 }
 
 static inline void stac(void)
 {
-    asm volatile (".byte 0x0f, 0x01, 0xcb" : : : "memory");
+	asm volatile (".byte 0x0f, 0x01, 0xcb" : : : "memory");
 }
 
 static inline u16 read_cs(void)
 {
-    unsigned val;
+	unsigned val;
 
-    asm volatile ("mov %%cs, %0" : "=mr"(val));
-    return val;
+	asm volatile ("mov %%cs, %0" : "=mr"(val));
+	return val;
 }
 
 static inline u16 read_ds(void)
 {
-    unsigned val;
+	unsigned val;
 
-    asm volatile ("mov %%ds, %0" : "=mr"(val));
-    return val;
+	asm volatile ("mov %%ds, %0" : "=mr"(val));
+	return val;
 }
 
 static inline u16 read_es(void)
 {
-    unsigned val;
+	unsigned val;
 
-    asm volatile ("mov %%es, %0" : "=mr"(val));
-    return val;
+	asm volatile ("mov %%es, %0" : "=mr"(val));
+	return val;
 }
 
 static inline u16 read_ss(void)
 {
-    unsigned val;
+	unsigned val;
 
-    asm volatile ("mov %%ss, %0" : "=mr"(val));
-    return val;
+	asm volatile ("mov %%ss, %0" : "=mr"(val));
+	return val;
 }
 
 static inline u16 read_fs(void)
 {
-    unsigned val;
+	unsigned val;
 
-    asm volatile ("mov %%fs, %0" : "=mr"(val));
-    return val;
+	asm volatile ("mov %%fs, %0" : "=mr"(val));
+	return val;
 }
 
 static inline u16 read_gs(void)
 {
-    unsigned val;
+	unsigned val;
 
-    asm volatile ("mov %%gs, %0" : "=mr"(val));
-    return val;
+	asm volatile ("mov %%gs, %0" : "=mr"(val));
+	return val;
 }
 
 static inline unsigned long read_rflags(void)
@@ -306,32 +306,32 @@ static inline unsigned long read_rflags(void)
 
 static inline void write_ds(unsigned val)
 {
-    asm volatile ("mov %0, %%ds" : : "rm"(val) : "memory");
+	asm volatile ("mov %0, %%ds" : : "rm"(val) : "memory");
 }
 
 static inline void write_es(unsigned val)
 {
-    asm volatile ("mov %0, %%es" : : "rm"(val) : "memory");
+	asm volatile ("mov %0, %%es" : : "rm"(val) : "memory");
 }
 
 static inline void write_ss(unsigned val)
 {
-    asm volatile ("mov %0, %%ss" : : "rm"(val) : "memory");
+	asm volatile ("mov %0, %%ss" : : "rm"(val) : "memory");
 }
 
 static inline void write_fs(unsigned val)
 {
-    asm volatile ("mov %0, %%fs" : : "rm"(val) : "memory");
+	asm volatile ("mov %0, %%fs" : : "rm"(val) : "memory");
 }
 
 static inline void write_gs(unsigned val)
 {
-    asm volatile ("mov %0, %%gs" : : "rm"(val) : "memory");
+	asm volatile ("mov %0, %%gs" : : "rm"(val) : "memory");
 }
 
 static inline void write_rflags(unsigned long f)
 {
-    asm volatile ("push %0; popf\n\t" : : "rm"(f));
+	asm volatile ("push %0; popf\n\t" : : "rm"(f));
 }
 
 static inline void set_iopl(int iopl)
@@ -343,15 +343,15 @@ static inline void set_iopl(int iopl)
 
 static inline u64 rdmsr(u32 index)
 {
-    u32 a, d;
-    asm volatile ("rdmsr" : "=a"(a), "=d"(d) : "c"(index) : "memory");
-    return a | ((u64)d << 32);
+	u32 a, d;
+	asm volatile ("rdmsr" : "=a"(a), "=d"(d) : "c"(index) : "memory");
+	return a | ((u64)d << 32);
 }
 
 static inline void wrmsr(u32 index, u64 val)
 {
-    u32 a = val, d = val >> 32;
-    asm volatile ("wrmsr" : : "a"(a), "d"(d), "c"(index) : "memory");
+	u32 a = val, d = val >> 32;
+	asm volatile ("wrmsr" : : "a"(a), "d"(d), "c"(index) : "memory");
 }
 
 static inline int rdmsr_checking(u32 index)
@@ -365,7 +365,7 @@ static inline int rdmsr_checking(u32 index)
 
 static inline int wrmsr_checking(u32 index, u64 val)
 {
-        u32 a = val, d = val >> 32;
+	u32 a = val, d = val >> 32;
 
 	asm volatile (ASM_TRY("1f")
 		      "wrmsr\n\t"
@@ -376,177 +376,177 @@ static inline int wrmsr_checking(u32 index, u64 val)
 
 static inline uint64_t rdpmc(uint32_t index)
 {
-    uint32_t a, d;
-    asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
-    return a | ((uint64_t)d << 32);
+	uint32_t a, d;
+	asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
+	return a | ((uint64_t)d << 32);
 }
 
 static inline void write_cr0(ulong val)
 {
-    asm volatile ("mov %0, %%cr0" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%cr0" : : "r"(val) : "memory");
 }
 
 static inline ulong read_cr0(void)
 {
-    ulong val;
-    asm volatile ("mov %%cr0, %0" : "=r"(val) : : "memory");
-    return val;
+	ulong val;
+	asm volatile ("mov %%cr0, %0" : "=r"(val) : : "memory");
+	return val;
 }
 
 static inline void write_cr2(ulong val)
 {
-    asm volatile ("mov %0, %%cr2" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%cr2" : : "r"(val) : "memory");
 }
 
 static inline ulong read_cr2(void)
 {
-    ulong val;
-    asm volatile ("mov %%cr2, %0" : "=r"(val) : : "memory");
-    return val;
+	ulong val;
+	asm volatile ("mov %%cr2, %0" : "=r"(val) : : "memory");
+	return val;
 }
 
 static inline void write_cr3(ulong val)
 {
-    asm volatile ("mov %0, %%cr3" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%cr3" : : "r"(val) : "memory");
 }
 
 static inline ulong read_cr3(void)
 {
-    ulong val;
-    asm volatile ("mov %%cr3, %0" : "=r"(val) : : "memory");
-    return val;
+	ulong val;
+	asm volatile ("mov %%cr3, %0" : "=r"(val) : : "memory");
+	return val;
 }
 
 static inline void update_cr3(void *cr3)
 {
-    write_cr3((ulong)cr3);
+	write_cr3((ulong)cr3);
 }
 
 static inline void write_cr4(ulong val)
 {
-    asm volatile ("mov %0, %%cr4" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%cr4" : : "r"(val) : "memory");
 }
 
 static inline ulong read_cr4(void)
 {
-    ulong val;
-    asm volatile ("mov %%cr4, %0" : "=r"(val) : : "memory");
-    return val;
+	ulong val;
+	asm volatile ("mov %%cr4, %0" : "=r"(val) : : "memory");
+	return val;
 }
 
 static inline void write_cr8(ulong val)
 {
-    asm volatile ("mov %0, %%cr8" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%cr8" : : "r"(val) : "memory");
 }
 
 static inline ulong read_cr8(void)
 {
-    ulong val;
-    asm volatile ("mov %%cr8, %0" : "=r"(val) : : "memory");
-    return val;
+	ulong val;
+	asm volatile ("mov %%cr8, %0" : "=r"(val) : : "memory");
+	return val;
 }
 
 static inline void lgdt(const struct descriptor_table_ptr *ptr)
 {
-    asm volatile ("lgdt %0" : : "m"(*ptr));
+	asm volatile ("lgdt %0" : : "m"(*ptr));
 }
 
 static inline void sgdt(struct descriptor_table_ptr *ptr)
 {
-    asm volatile ("sgdt %0" : "=m"(*ptr));
+	asm volatile ("sgdt %0" : "=m"(*ptr));
 }
 
 static inline void lidt(const struct descriptor_table_ptr *ptr)
 {
-    asm volatile ("lidt %0" : : "m"(*ptr));
+	asm volatile ("lidt %0" : : "m"(*ptr));
 }
 
 static inline void sidt(struct descriptor_table_ptr *ptr)
 {
-    asm volatile ("sidt %0" : "=m"(*ptr));
+	asm volatile ("sidt %0" : "=m"(*ptr));
 }
 
 static inline void lldt(u16 val)
 {
-    asm volatile ("lldt %0" : : "rm"(val));
+	asm volatile ("lldt %0" : : "rm"(val));
 }
 
 static inline u16 sldt(void)
 {
-    u16 val;
-    asm volatile ("sldt %0" : "=rm"(val));
-    return val;
+	u16 val;
+	asm volatile ("sldt %0" : "=rm"(val));
+	return val;
 }
 
 static inline void ltr(u16 val)
 {
-    asm volatile ("ltr %0" : : "rm"(val));
+	asm volatile ("ltr %0" : : "rm"(val));
 }
 
 static inline u16 str(void)
 {
-    u16 val;
-    asm volatile ("str %0" : "=rm"(val));
-    return val;
+	u16 val;
+	asm volatile ("str %0" : "=rm"(val));
+	return val;
 }
 
 static inline void write_dr0(void *val)
 {
-    asm volatile ("mov %0, %%dr0" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%dr0" : : "r"(val) : "memory");
 }
 
 static inline void write_dr1(void *val)
 {
-    asm volatile ("mov %0, %%dr1" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%dr1" : : "r"(val) : "memory");
 }
 
 static inline void write_dr2(void *val)
 {
-    asm volatile ("mov %0, %%dr2" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%dr2" : : "r"(val) : "memory");
 }
 
 static inline void write_dr3(void *val)
 {
-    asm volatile ("mov %0, %%dr3" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%dr3" : : "r"(val) : "memory");
 }
 
 static inline void write_dr6(ulong val)
 {
-    asm volatile ("mov %0, %%dr6" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%dr6" : : "r"(val) : "memory");
 }
 
 static inline ulong read_dr6(void)
 {
-    ulong val;
-    asm volatile ("mov %%dr6, %0" : "=r"(val));
-    return val;
+	ulong val;
+	asm volatile ("mov %%dr6, %0" : "=r"(val));
+	return val;
 }
 
 static inline void write_dr7(ulong val)
 {
-    asm volatile ("mov %0, %%dr7" : : "r"(val) : "memory");
+	asm volatile ("mov %0, %%dr7" : : "r"(val) : "memory");
 }
 
 static inline ulong read_dr7(void)
 {
-    ulong val;
-    asm volatile ("mov %%dr7, %0" : "=r"(val));
-    return val;
+	ulong val;
+	asm volatile ("mov %%dr7, %0" : "=r"(val));
+	return val;
 }
 
 static inline void pause(void)
 {
-    asm volatile ("pause");
+	asm volatile ("pause");
 }
 
 static inline void cli(void)
 {
-    asm volatile ("cli");
+	asm volatile ("cli");
 }
 
 static inline void sti(void)
 {
-    asm volatile ("sti");
+	asm volatile ("sti");
 }
 
 static inline unsigned long long rdrand(void)
@@ -600,17 +600,17 @@ static inline unsigned long long fenced_rdtsc(void)
 
 static inline unsigned long long rdtscp(u32 *aux)
 {
-       long long r;
+	long long r;
 
 #ifdef __x86_64__
-       unsigned a, d;
+	unsigned a, d;
 
-       asm volatile ("rdtscp" : "=a"(a), "=d"(d), "=c"(*aux));
-       r = a | ((long long)d << 32);
+	asm volatile ("rdtscp" : "=a"(a), "=d"(d), "=c"(*aux));
+	r = a | ((long long)d << 32);
 #else
-       asm volatile ("rdtscp" : "=A"(r), "=c"(*aux));
+	asm volatile ("rdtscp" : "=A"(r), "=c"(*aux));
 #endif
-       return r;
+	return r;
 }
 
 static inline void wrtsc(u64 tsc)
@@ -620,7 +620,7 @@ static inline void wrtsc(u64 tsc)
 
 static inline void irq_disable(void)
 {
-    asm volatile("cli");
+	asm volatile("cli");
 }
 
 /* Note that irq_enable() does not ensure an interrupt shadow due
@@ -629,7 +629,7 @@ static inline void irq_disable(void)
  */
 static inline void irq_enable(void)
 {
-    asm volatile("sti");
+	asm volatile("sti");
 }
 
 static inline void invlpg(volatile void *va)
@@ -644,25 +644,25 @@ static inline void safe_halt(void)
 
 static inline u32 read_pkru(void)
 {
-    unsigned int eax, edx;
-    unsigned int ecx = 0;
-    unsigned int pkru;
+	unsigned int eax, edx;
+	unsigned int ecx = 0;
+	unsigned int pkru;
 
-    asm volatile(".byte 0x0f,0x01,0xee\n\t"
-                 : "=a" (eax), "=d" (edx)
-                 : "c" (ecx));
-    pkru = eax;
-    return pkru;
+	asm volatile(".byte 0x0f,0x01,0xee\n\t"
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (ecx));
+	pkru = eax;
+	return pkru;
 }
 
 static inline void write_pkru(u32 pkru)
 {
-    unsigned int eax = pkru;
-    unsigned int ecx = 0;
-    unsigned int edx = 0;
+	unsigned int eax = pkru;
+	unsigned int ecx = 0;
+	unsigned int edx = 0;
 
-    asm volatile(".byte 0x0f,0x01,0xef\n\t"
-        : : "a" (eax), "c" (ecx), "d" (edx));
+	asm volatile(".byte 0x0f,0x01,0xef\n\t"
+		     : : "a" (eax), "c" (ecx), "d" (edx));
 }
 
 static inline bool is_canonical(u64 addr)
@@ -696,7 +696,7 @@ static inline void flush_tlb(void)
 
 static inline int has_spec_ctrl(void)
 {
-    return !!(this_cpu_has(X86_FEATURE_SPEC_CTRL));
+	return !!(this_cpu_has(X86_FEATURE_SPEC_CTRL));
 }
 
 static inline int cpu_has_efer_nx(void)
-- 
2.36.1.255.ge46751e96f-goog

