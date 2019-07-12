Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30254667DE
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 09:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfGLHjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 03:39:05 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39724 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfGLHjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 03:39:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so3936533pfe.6;
        Fri, 12 Jul 2019 00:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=teO2U84Y0voCyxdSkIrBITdgvhHGO6vzIDrKZreXFsk=;
        b=GnRWe55YvavMDKXf0njvqlg2i7FUvCAaKARYduAp+6M9/fXNfqcQ/ntAOFjC94tDUg
         tf3onm4gz92vB2FRidojYb52sob3cxRCowMc145Hgf2wiL10/OzPtym+qJ5fZk/0/4Hz
         bvCfAps7wobm7tyihtK8eStjrxlTE+qZEOhTXw0hQS30XvNElqfHsnkLkaKAT+CBMXBu
         25aP9oMnyxx7/PXaRnikKe6Gz5VAcxXaXW51Zz/jUKp5W1jrtUPJdHN3NLt/s1x6L4OE
         QNkO2nZZqhZqkMuIrJfEMXXQMO89mOTHOD6PPdu1puZLLjO7GA+UQ1XfjfGGYCQY1vit
         nBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=teO2U84Y0voCyxdSkIrBITdgvhHGO6vzIDrKZreXFsk=;
        b=ryGPEvR9wAQivhUWyypbMAh79jJTncmxHy91E223txVgWY8i7sUr2Zp1Vu0WXsbN9X
         u79DImZ8StqjEQUe/oj1KZp1rruOIbxyearFStKDF+CEz7LBEur9c1zLcQglmJus0+xI
         7NVCsGZyI39HEU6AjHIDUUokghbmY7w6IIL6hmAfINdaqIlmxkiwjJn21OLKOzcZ8+aH
         W04cV5MPku6UKUzL2aoFIN8tBs6M69J93QjgbC+J0hFaQ0UUHxwf8p84LhW7d9voj1QC
         te35cvGSU1oYAW9HQah+LYmol1MxmNj2eSZpZK8JRtCVoS6OcNE1kZKxMb+eSePnP4An
         FGUw==
X-Gm-Message-State: APjAAAXPf+8cM4i9YIlhy4GoFZXHSO6dBs0aNjgn4KcDEBPLhJbaFKt8
        eCJcwTCmw6g8tAJFZpX/Oh6hvst2rh8=
X-Google-Smtp-Source: APXvYqyIN+0wVm42hCnwcxZvMrYJ+KRxYw3EaPyzGkI9GEM1Ksjx+nD/c9pcL02iU1BhidkzYmjJCA==
X-Received: by 2002:a63:6c02:: with SMTP id h2mr5406998pgc.61.1562917144560;
        Fri, 12 Jul 2019 00:39:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d6sm6661309pgf.55.2019.07.12.00.39.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 12 Jul 2019 00:39:04 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH RESEND 1/2] KVM: LAPIC: Add pv ipi tracepoint
Date:   Fri, 12 Jul 2019 15:38:59 +0800
Message-Id: <1562917140-12035-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Add pv ipi tracepoint.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c |  2 ++
 arch/x86/kvm/trace.h | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 42da7eb..403ae3f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -562,6 +562,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 	irq.level = (icr & APIC_INT_ASSERT) != 0;
 	irq.trig_mode = icr & APIC_INT_LEVELTRIG;
 
+	trace_kvm_pv_send_ipi(irq.vector, min, ipi_bitmap_low, ipi_bitmap_high);
+
 	if (icr & APIC_DEST_MASK)
 		return -KVM_EINVAL;
 	if (icr & APIC_SHORT_MASK)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b5c831e..ce6ee34 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1462,6 +1462,31 @@ TRACE_EVENT(kvm_hv_send_ipi_ex,
 		  __entry->vector, __entry->format,
 		  __entry->valid_bank_mask)
 );
+
+/*
+ * Tracepoints for kvm_pv_send_ipi.
+ */
+TRACE_EVENT(kvm_pv_send_ipi,
+	TP_PROTO(u32 vector, u32 min, unsigned long ipi_bitmap_low, unsigned long ipi_bitmap_high),
+	TP_ARGS(vector, min, ipi_bitmap_low, ipi_bitmap_high),
+
+	TP_STRUCT__entry(
+		__field(u32, vector)
+		__field(u32, min)
+		__field(unsigned long, ipi_bitmap_low)
+		__field(unsigned long, ipi_bitmap_high)
+	),
+
+	TP_fast_assign(
+		__entry->vector = vector;
+		__entry->min = min;
+		__entry->ipi_bitmap_low = ipi_bitmap_low;
+		__entry->ipi_bitmap_high = ipi_bitmap_high;
+	),
+
+	TP_printk("vector %d min 0x%x ipi_bitmap_low 0x%lx ipi_bitmap_high 0x%lx",
+		  __entry->vector, __entry->min, __entry->ipi_bitmap_low, __entry->ipi_bitmap_high)
+);
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.7.4

