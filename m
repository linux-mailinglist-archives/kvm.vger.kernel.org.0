Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7194C3ECBFF
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhHPANZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhHPANY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:13:24 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B77AC061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:53 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id o8-20020a0566021248b029058d0f91164eso8322919iou.1
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YJQeH9eyrSgJZU9Ny2rMLZs6xbXaCD7Zl6TzBg6qTrQ=;
        b=QBMsWHju9a6N+AbW89GmYdTgiBjk6UEl6el06NXKbSnD/SJP4/ber/VEgzS2HXX5Kj
         lKnWBahIGpHLQvIMq3MgmQJCZdMZ7GiQ70KEiB2eiD9Z7TGlj1IS1LHDXXfJ8r5GUc1o
         7YcLqyYv6N5Zk4T/u0wOxe5nNhpzheWhRoEKSHugBtHqvwwCnDp2x8CSAjrhOHlg1EDk
         1zQXEW+DZdwb6xPs6sI1b8y45xX7CHu2YWcfM+CUJSxALs7c8Rw5hTsborgHaYr2Num2
         MePMXtK1VhYMdiZBVGIgFKlPkGPvrOXSv8QE6glINoaIiUU2KtB/R3v0XFQWTjv2ymTE
         uxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YJQeH9eyrSgJZU9Ny2rMLZs6xbXaCD7Zl6TzBg6qTrQ=;
        b=fe93tccr6u4ixxK6JiKU0iD4VrSd4edYiR9dlVKCxaqec698E3atVS7ndhzhsFnGqz
         hZ1ICiAieH91ZwlvS3H6CxdlvrkqbXujyNfv+9EkDGbUgo18SiLhozenw3ljZNsu95EK
         2yhFX2mDUNmYHHyzv6ICbtFRz2Vir9or8kRLpbVroNvjoJh36bqH7CO/+yFyLJRf0CWK
         J88hWUoncsXiKZZiJkedyT5obrpCHJZBzW6jAEjlyiIDsxzVckNi/BNJEima0SdoxB8k
         h9IYrs/dxC729NWQhDg3jzZ7ORQEdlrw46Z0YVbMVuruY+//Eh2ZCaaI3nllAQc7J5UK
         x9TA==
X-Gm-Message-State: AOAM531IcI0Jt0d0iojEndwHTah827JyV9VGAdGdpaiXu7Wr7NtE8Z+b
        vKjg+oJ6SKEIu9wOazoAuGZuMilXmMzkweFQ/k0ITSIfto6CJ4LkKaqq5NeKrBfV0XNyIrVYF1H
        YWkDPQ/2QRmENuMuVxqQQXyCUNnqG3o9ISdNSoCgW969UB1LNZ216Vv8xyw==
X-Google-Smtp-Source: ABdhPJya89o9o+hYP9pk3oEvzHiKDZnr7pJgl1dCt3ghsTzbqdn2mwULPHS4J2TPUwLa5Qo4IQqicNKlkFs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:a490:: with SMTP id d16mr13519859jam.42.1629072772915;
 Sun, 15 Aug 2021 17:12:52 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:38 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-2-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 1/9] tools: arch: x86: pull in pvclock headers
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Copy over approximately clean versions of the pvclock headers into
tools. Reconcile headers/symbols missing in tools that are unneeded.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/arch/x86/include/asm/pvclock-abi.h |  48 +++++++++++
 tools/arch/x86/include/asm/pvclock.h     | 103 +++++++++++++++++++++++
 2 files changed, 151 insertions(+)
 create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
 create mode 100644 tools/arch/x86/include/asm/pvclock.h

diff --git a/tools/arch/x86/include/asm/pvclock-abi.h b/tools/arch/x86/include/asm/pvclock-abi.h
new file mode 100644
index 000000000000..1436226efe3e
--- /dev/null
+++ b/tools/arch/x86/include/asm/pvclock-abi.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_PVCLOCK_ABI_H
+#define _ASM_X86_PVCLOCK_ABI_H
+#ifndef __ASSEMBLY__
+
+/*
+ * These structs MUST NOT be changed.
+ * They are the ABI between hypervisor and guest OS.
+ * Both Xen and KVM are using this.
+ *
+ * pvclock_vcpu_time_info holds the system time and the tsc timestamp
+ * of the last update. So the guest can use the tsc delta to get a
+ * more precise system time.  There is one per virtual cpu.
+ *
+ * pvclock_wall_clock references the point in time when the system
+ * time was zero (usually boot time), thus the guest calculates the
+ * current wall clock by adding the system time.
+ *
+ * Protocol for the "version" fields is: hypervisor raises it (making
+ * it uneven) before it starts updating the fields and raises it again
+ * (making it even) when it is done.  Thus the guest can make sure the
+ * time values it got are consistent by checking the version before
+ * and after reading them.
+ */
+
+struct pvclock_vcpu_time_info {
+	u32   version;
+	u32   pad0;
+	u64   tsc_timestamp;
+	u64   system_time;
+	u32   tsc_to_system_mul;
+	s8    tsc_shift;
+	u8    flags;
+	u8    pad[2];
+} __attribute__((__packed__)); /* 32 bytes */
+
+struct pvclock_wall_clock {
+	u32   version;
+	u32   sec;
+	u32   nsec;
+} __attribute__((__packed__));
+
+#define PVCLOCK_TSC_STABLE_BIT	(1 << 0)
+#define PVCLOCK_GUEST_STOPPED	(1 << 1)
+/* PVCLOCK_COUNTS_FROM_ZERO broke ABI and can't be used anymore. */
+#define PVCLOCK_COUNTS_FROM_ZERO (1 << 2)
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_X86_PVCLOCK_ABI_H */
diff --git a/tools/arch/x86/include/asm/pvclock.h b/tools/arch/x86/include/asm/pvclock.h
new file mode 100644
index 000000000000..2628f9a6330b
--- /dev/null
+++ b/tools/arch/x86/include/asm/pvclock.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_PVCLOCK_H
+#define _ASM_X86_PVCLOCK_H
+
+#include <asm/barrier.h>
+#include <asm/pvclock-abi.h>
+
+/* some helper functions for xen and kvm pv clock sources */
+u64 pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
+u8 pvclock_read_flags(struct pvclock_vcpu_time_info *src);
+void pvclock_set_flags(u8 flags);
+unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
+void pvclock_resume(void);
+
+void pvclock_touch_watchdogs(void);
+
+static __always_inline
+unsigned pvclock_read_begin(const struct pvclock_vcpu_time_info *src)
+{
+	unsigned version = src->version & ~1;
+	/* Make sure that the version is read before the data. */
+	rmb();
+	return version;
+}
+
+static __always_inline
+bool pvclock_read_retry(const struct pvclock_vcpu_time_info *src,
+			unsigned version)
+{
+	/* Make sure that the version is re-read after the data. */
+	rmb();
+	return version != src->version;
+}
+
+/*
+ * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
+ * yielding a 64-bit result.
+ */
+static inline u64 pvclock_scale_delta(u64 delta, u32 mul_frac, int shift)
+{
+	u64 product;
+#ifdef __i386__
+	u32 tmp1, tmp2;
+#else
+	unsigned long tmp;
+#endif
+
+	if (shift < 0)
+		delta >>= -shift;
+	else
+		delta <<= shift;
+
+#ifdef __i386__
+	__asm__ (
+		"mul  %5       ; "
+		"mov  %4,%%eax ; "
+		"mov  %%edx,%4 ; "
+		"mul  %5       ; "
+		"xor  %5,%5    ; "
+		"add  %4,%%eax ; "
+		"adc  %5,%%edx ; "
+		: "=A" (product), "=r" (tmp1), "=r" (tmp2)
+		: "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
+#elif defined(__x86_64__)
+	__asm__ (
+		"mulq %[mul_frac] ; shrd $32, %[hi], %[lo]"
+		: [lo]"=a"(product),
+		  [hi]"=d"(tmp)
+		: "0"(delta),
+		  [mul_frac]"rm"((u64)mul_frac));
+#else
+#error implement me!
+#endif
+
+	return product;
+}
+
+static __always_inline
+u64 __pvclock_read_cycles(const struct pvclock_vcpu_time_info *src, u64 tsc)
+{
+	u64 delta = tsc - src->tsc_timestamp;
+	u64 offset = pvclock_scale_delta(delta, src->tsc_to_system_mul,
+					     src->tsc_shift);
+	return src->system_time + offset;
+}
+
+struct pvclock_vsyscall_time_info {
+	struct pvclock_vcpu_time_info pvti;
+} __attribute__((__aligned__(64)));
+
+#define PVTI_SIZE sizeof(struct pvclock_vsyscall_time_info)
+
+#ifdef CONFIG_PARAVIRT_CLOCK
+void pvclock_set_pvti_cpu0_va(struct pvclock_vsyscall_time_info *pvti);
+struct pvclock_vsyscall_time_info *pvclock_get_pvti_cpu0_va(void);
+#else
+static inline struct pvclock_vsyscall_time_info *pvclock_get_pvti_cpu0_va(void)
+{
+	return NULL;
+}
+#endif
+
+#endif /* _ASM_X86_PVCLOCK_H */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

