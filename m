Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F5A81028
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 04:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfHECDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Aug 2019 22:03:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40398 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfHECDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Aug 2019 22:03:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so38765839pfp.7;
        Sun, 04 Aug 2019 19:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tRG59/5lE82m1QRtQTpYyWmXnnIcRnkPvf94Bgtr6Rs=;
        b=q9mkPyPceELpn2nS45fd46f3dkwHuqerVMaCCDQW9O7ZH/uJcjqgXNwUzHpEPO+fkV
         bhmqeoFDPFXWFV6GCKMOonq5lalU8ZX8371rKLqI8mf4AnJd/klM8/C6hx2qxoqZrsdi
         PaJyeiqaJ4a35dHkOri7RlJ0enZQfn0EG6QxmnHMv8FLtl7QojEjVj8oCt7dRcA6whay
         IttSV6Ui/sXbt3uXRuGl+5hibYOHTLWKXVVG6TNpPzrU0obWgS3MObkwqMIeD79n5QCs
         vkjgtxsl6zShlvKSAEm70dD4GU/gIMhpMBToTEbhuGNVegwWv5/sty+QGTrUaj1vIh+s
         2VKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tRG59/5lE82m1QRtQTpYyWmXnnIcRnkPvf94Bgtr6Rs=;
        b=nUxOwjVBHFucdJZNouf/lHw8kIZiodoFumF0oGGn72L1zhEJUUsqrWGKga/BUfBTQL
         HM4IBrrT6Z009oQjfP1JH6OOQdiXALHzi2b4YvNmj43OC7wO/H6FC7Adzrzf0gyi5Kz5
         N2F8Y2N0na+xdEux86gb1TcbSpJhS0jLJftGXoSP0s0/QN9Fsf5pHfJaU3YnKJfeTY+A
         QrLgry8aJZZtKXtUPkzp2sQDOKnQ7LRYkZj8DalcEdbpwFdp6Gp7mE0X6/H9zDxWzLYJ
         cszVti1EAtxQq1p56dbSx6X3ZVHkHL4e4ZMMR79O7A5NnONAedbh/4MUoatGuS02IHnx
         zgkA==
X-Gm-Message-State: APjAAAXX0+Of+grKcA2viLXwQMW+2+ASF14Ucsr5PuLk3hJ7pXvf3NnE
        PmddhFfutuswBVSCiLHEi5yJiGxn
X-Google-Smtp-Source: APXvYqwx+O2T3Y/610fDmG08ETEs/T5eFALd0i8ye3h0Jacluk6ChqZA8qzKZcGWSykIkqQbUTCC7A==
X-Received: by 2002:a63:ec13:: with SMTP id j19mr52731786pgh.369.1564970620508;
        Sun, 04 Aug 2019 19:03:40 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id o32sm14739365pje.9.2019.08.04.19.03.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 19:03:40 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v4 5/6] KVM: LAPIC: Add pv ipi tracepoint
Date:   Mon,  5 Aug 2019 10:03:23 +0800
Message-Id: <1564970604-10044-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
References: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
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
index 685d17c..df5cd07 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -570,6 +570,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
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

