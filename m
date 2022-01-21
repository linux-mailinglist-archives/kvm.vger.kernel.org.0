Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B086049682E
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 00:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiAUXTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 18:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiAUXTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 18:19:06 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA36C06173D
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:06 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id i2-20020a17090a4b8200b001b426d8be4eso7079985pjh.4
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VJZaz+QGM32pSa2XuqbI3TWt4qDEfVE7S1BE3eBPgUM=;
        b=sBRVFlpPqJj7LmBXXynP6I1+Hda3weYH2ZlcEKelioiMEVBYQMsJBaqZfTdK3lZtqx
         MHt24zEWsK9A0qpY3n8GrZWbrp8aGrbmvfcjepgmsM688UvHcOB8XsbLu1j3B0o1m2NT
         3Kg6mmRZG4afGHx9fqjCEIoxBDYYV9MI9aYQrOC4XqVYq/nr4MsI1i89rO2ehlzLstdQ
         agKN+GEXioQy9e6AJKBFIpRsVk7OmRRdE8CLILpo0OmzFGxzYPIGINaP+Sz1xxD87z/r
         9HODOx19MqEnHIqXZLLK3ys9jnoiNQZaiX0QLWwnGyqkjXF88bdTOKjhaungcfkfxwhj
         Xwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VJZaz+QGM32pSa2XuqbI3TWt4qDEfVE7S1BE3eBPgUM=;
        b=7zs7td3UMI2UQHi+dn67+IVdniw2G/nu4o2aNbbJxqjLTaBKpv0Vt0LNlUl/sDSp+x
         zpFlaPAGKT4JU2fSD/nIBeCxgrXJ0CknsFxXNWTgvfdB3+4kjcJoikymwDwG7CTq0NFq
         n/7qA3io9kgOT7Mn5ShHe93ZjLGs+eNhQ5SOlDJtItyUOV99evilUFH/KFNITx84Dg/Z
         rrzE50X2v8HvxViteO68T9AD8B7SVTwe7dxRxBrHkMi3ecGqY4QyG9bhd+rK5oeHhxhN
         ybgjVO+jxlWVBa2hcL6bPJetCSjX54UhY4V0Se7Rf24iwgzniVf4/PZBjKty2rl+di+m
         cphA==
X-Gm-Message-State: AOAM531t4xlWLSnkRW9tMVdLD1Cz0k4aVx7m3cJ4z95XfhmY6FURqUmF
        /FuUc99Z0qKhCUhPqC/0wX1CKwdK8z4=
X-Google-Smtp-Source: ABdhPJyvic21FCLBK/ef9smw4+vAOxTuoLmMfKf7pN1qMGs9SVUar/LoistRj1vx5pJcZTlk+q/p5P3hX4s=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:9408:0:b0:4c7:f5bb:7bea with SMTP id
 x8-20020aa79408000000b004c7f5bb7beamr253444pfo.80.1642807146030; Fri, 21 Jan
 2022 15:19:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jan 2022 23:18:50 +0000
In-Reply-To: <20220121231852.1439917-1-seanjc@google.com>
Message-Id: <20220121231852.1439917-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220121231852.1439917-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH 6/8] x86: apic: Replace spaces with tabs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace spaces with tabs in apic.c.  No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/apic.c | 138 ++++++++++++++++++++++++-------------------------
 1 file changed, 69 insertions(+), 69 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index b404d580..44a6ad38 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -9,43 +9,43 @@ void *g_ioapic = (void *)0xfec00000;
 u8 id_map[MAX_TEST_CPUS];
 
 struct apic_ops {
-    u32 (*reg_read)(unsigned reg);
-    void (*reg_write)(unsigned reg, u32 val);
-    void (*icr_write)(u32 val, u32 dest);
-    u32 (*id)(void);
+	u32 (*reg_read)(unsigned reg);
+	void (*reg_write)(unsigned reg, u32 val);
+	void (*icr_write)(u32 val, u32 dest);
+	u32 (*id)(void);
 };
 
 static void outb(unsigned char data, unsigned short port)
 {
-    asm volatile ("out %0, %1" : : "a"(data), "d"(port));
+	asm volatile ("out %0, %1" : : "a"(data), "d"(port));
 }
 
 void eoi(void)
 {
-    apic_write(APIC_EOI, 0);
+	apic_write(APIC_EOI, 0);
 }
 
 static u32 xapic_read(unsigned reg)
 {
-    return *(volatile u32 *)(g_apic + reg);
+	return *(volatile u32 *)(g_apic + reg);
 }
 
 static void xapic_write(unsigned reg, u32 val)
 {
-    *(volatile u32 *)(g_apic + reg) = val;
+	*(volatile u32 *)(g_apic + reg) = val;
 }
 
 static void xapic_icr_write(u32 val, u32 dest)
 {
-    while (xapic_read(APIC_ICR) & APIC_ICR_BUSY)
-        ;
-    xapic_write(APIC_ICR2, dest << 24);
-    xapic_write(APIC_ICR, val);
+	while (xapic_read(APIC_ICR) & APIC_ICR_BUSY)
+		;
+	xapic_write(APIC_ICR2, dest << 24);
+	xapic_write(APIC_ICR, val);
 }
 
 static uint32_t xapic_id(void)
 {
-    return xapic_read(APIC_ID) >> 24;
+	return xapic_read(APIC_ID) >> 24;
 }
 
 uint32_t pre_boot_apic_id(void)
@@ -54,71 +54,71 @@ uint32_t pre_boot_apic_id(void)
 }
 
 static const struct apic_ops xapic_ops = {
-    .reg_read = xapic_read,
-    .reg_write = xapic_write,
-    .icr_write = xapic_icr_write,
-    .id = xapic_id,
+	.reg_read = xapic_read,
+	.reg_write = xapic_write,
+	.icr_write = xapic_icr_write,
+	.id = xapic_id,
 };
 
 static const struct apic_ops *apic_ops = &xapic_ops;
 
 static u32 x2apic_read(unsigned reg)
 {
-    unsigned a, d;
+	unsigned a, d;
 
-    asm volatile ("rdmsr" : "=a"(a), "=d"(d) : "c"(APIC_BASE_MSR + reg/16));
-    return a | (u64)d << 32;
+	asm volatile ("rdmsr" : "=a"(a), "=d"(d) : "c"(APIC_BASE_MSR + reg/16));
+	return a | (u64)d << 32;
 }
 
 static void x2apic_write(unsigned reg, u32 val)
 {
-    asm volatile ("wrmsr" : : "a"(val), "d"(0), "c"(APIC_BASE_MSR + reg/16));
+	asm volatile ("wrmsr" : : "a"(val), "d"(0), "c"(APIC_BASE_MSR + reg/16));
 }
 
 static void x2apic_icr_write(u32 val, u32 dest)
 {
-    mb();
-    asm volatile ("wrmsr" : : "a"(val), "d"(dest),
-                  "c"(APIC_BASE_MSR + APIC_ICR/16));
+	mb();
+	asm volatile ("wrmsr" : : "a"(val), "d"(dest),
+		      "c"(APIC_BASE_MSR + APIC_ICR/16));
 }
 
 static uint32_t x2apic_id(void)
 {
-    return x2apic_read(APIC_ID);
+	return x2apic_read(APIC_ID);
 }
 
 static const struct apic_ops x2apic_ops = {
-    .reg_read = x2apic_read,
-    .reg_write = x2apic_write,
-    .icr_write = x2apic_icr_write,
-    .id = x2apic_id,
+	.reg_read = x2apic_read,
+	.reg_write = x2apic_write,
+	.icr_write = x2apic_icr_write,
+	.id = x2apic_id,
 };
 
 u32 apic_read(unsigned reg)
 {
-    return apic_ops->reg_read(reg);
+	return apic_ops->reg_read(reg);
 }
 
 void apic_write(unsigned reg, u32 val)
 {
-    apic_ops->reg_write(reg, val);
+	apic_ops->reg_write(reg, val);
 }
 
 bool apic_read_bit(unsigned reg, int n)
 {
-    reg += (n >> 5) << 4;
-    n &= 31;
-    return (apic_read(reg) & (1 << n)) != 0;
+	reg += (n >> 5) << 4;
+	n &= 31;
+	return (apic_read(reg) & (1 << n)) != 0;
 }
 
 void apic_icr_write(u32 val, u32 dest)
 {
-    apic_ops->icr_write(val, dest);
+	apic_ops->icr_write(val, dest);
 }
 
 uint32_t apic_id(void)
 {
-    return apic_ops->id();
+	return apic_ops->id();
 }
 
 uint8_t apic_get_tpr(void)
@@ -144,59 +144,59 @@ void apic_set_tpr(uint8_t tpr)
 
 int enable_x2apic(void)
 {
-    unsigned a, b, c, d;
+	unsigned a, b, c, d;
 
-    asm ("cpuid" : "=a"(a), "=b"(b), "=c"(c), "=d"(d) : "0"(1));
+	asm ("cpuid" : "=a"(a), "=b"(b), "=c"(c), "=d"(d) : "0"(1));
 
-    if (c & (1 << 21)) {
-        asm ("rdmsr" : "=a"(a), "=d"(d) : "c"(MSR_IA32_APICBASE));
-        a |= 1 << 10;
-        asm ("wrmsr" : : "a"(a), "d"(d), "c"(MSR_IA32_APICBASE));
-        apic_ops = &x2apic_ops;
-        return 1;
-    } else {
-        return 0;
-    }
+	if (c & (1 << 21)) {
+		asm ("rdmsr" : "=a"(a), "=d"(d) : "c"(MSR_IA32_APICBASE));
+		a |= 1 << 10;
+		asm ("wrmsr" : : "a"(a), "d"(d), "c"(MSR_IA32_APICBASE));
+		apic_ops = &x2apic_ops;
+		return 1;
+	} else {
+		return 0;
+	}
 }
 
 void disable_apic(void)
 {
-    wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) & ~(APIC_EN | APIC_EXTD));
-    apic_ops = &xapic_ops;
+	wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) & ~(APIC_EN | APIC_EXTD));
+	apic_ops = &xapic_ops;
 }
 
 void reset_apic(void)
 {
-    disable_apic();
-    wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) | APIC_EN);
-    xapic_write(APIC_SPIV, 0x1ff);
+	disable_apic();
+	wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) | APIC_EN);
+	xapic_write(APIC_SPIV, 0x1ff);
 }
 
 u32 ioapic_read_reg(unsigned reg)
 {
-    *(volatile u32 *)g_ioapic = reg;
-    return *(volatile u32 *)(g_ioapic + 0x10);
+	*(volatile u32 *)g_ioapic = reg;
+	return *(volatile u32 *)(g_ioapic + 0x10);
 }
 
 void ioapic_write_reg(unsigned reg, u32 value)
 {
-    *(volatile u32 *)g_ioapic = reg;
-    *(volatile u32 *)(g_ioapic + 0x10) = value;
+	*(volatile u32 *)g_ioapic = reg;
+	*(volatile u32 *)(g_ioapic + 0x10) = value;
 }
 
 void ioapic_write_redir(unsigned line, ioapic_redir_entry_t e)
 {
-    ioapic_write_reg(0x10 + line * 2 + 0, ((u32 *)&e)[0]);
-    ioapic_write_reg(0x10 + line * 2 + 1, ((u32 *)&e)[1]);
+	ioapic_write_reg(0x10 + line * 2 + 0, ((u32 *)&e)[0]);
+	ioapic_write_reg(0x10 + line * 2 + 1, ((u32 *)&e)[1]);
 }
 
 ioapic_redir_entry_t ioapic_read_redir(unsigned line)
 {
-    ioapic_redir_entry_t e;
+	ioapic_redir_entry_t e;
 
-    ((u32 *)&e)[0] = ioapic_read_reg(0x10 + line * 2 + 0);
-    ((u32 *)&e)[1] = ioapic_read_reg(0x10 + line * 2 + 1);
-    return e;
+	((u32 *)&e)[0] = ioapic_read_reg(0x10 + line * 2 + 0);
+	((u32 *)&e)[1] = ioapic_read_reg(0x10 + line * 2 + 1);
+	return e;
 
 }
 
@@ -214,10 +214,10 @@ void ioapic_set_redir(unsigned line, unsigned vec,
 
 void set_mask(unsigned line, int mask)
 {
-    ioapic_redir_entry_t e = ioapic_read_redir(line);
+	ioapic_redir_entry_t e = ioapic_read_redir(line);
 
-    e.mask = mask;
-    ioapic_write_redir(line, e);
+	e.mask = mask;
+	ioapic_write_redir(line, e);
 }
 
 void set_irq_line(unsigned line, int val)
@@ -227,14 +227,14 @@ void set_irq_line(unsigned line, int val)
 
 void enable_apic(void)
 {
-    printf("enabling apic\n");
-    xapic_write(APIC_SPIV, 0x1ff);
+	printf("enabling apic\n");
+	xapic_write(APIC_SPIV, 0x1ff);
 }
 
 void mask_pic_interrupts(void)
 {
-    outb(0xff, 0x21);
-    outb(0xff, 0xa1);
+	outb(0xff, 0x21);
+	outb(0xff, 0xa1);
 }
 
 extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
-- 
2.35.0.rc0.227.g00780c9af4-goog

