Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC12F32B5C7
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449369AbhCCHUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238045AbhCCCLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 21:11:00 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546B1C061224;
        Tue,  2 Mar 2021 18:09:58 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id e9so3371051pjj.0;
        Tue, 02 Mar 2021 18:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y4CDZC0XRtdxRyUu6upw3DY8PzyuYgSy6jHykMMCFTY=;
        b=M+m8+IeTn56qvibEzZaBaLzICwpFnGw1QTeozL3il7ZPPhlofSUc32Pqvf9KvcU4Co
         1ksSTP9mOLQXpmxuFfe5B09ISx2/2c/OngpINTk7OQwqJa1uM2INoScqO7W+suxk4wUk
         Dnf3XfWuePpDh1JhqHSdaqT7pvw2FBEc3DgiyoI3eWW0Uwc/qAZw7OeSX8si9cTtjm4H
         GJXE4NeRLSFyXODVCe1WuRWokDjwtp1eKeEQ8AL5q6hxdP2Rc32Zpns9eWBXIey91Xev
         A1kRVKb5KOiaCEi8ZmsmmtLmon/o8vAHRBnh3k3E0tVbnI9zTZa8vXSOp15y+PMHolJX
         FgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y4CDZC0XRtdxRyUu6upw3DY8PzyuYgSy6jHykMMCFTY=;
        b=a2oiwdicy+VnrOBNxqEg8JyYkKc2h5cjvjff+zPwnzOsO4xCyUoiouzPJux9BbCm4+
         KFnUeNZvejO2foRCDWqpXKqbbo9lrnkrW6aM7K3zifT8C2tVUwfiQnXJvkmhXKkiulOk
         bTkrF2YbmXQbplNsjJn8q+xps+zV3qdKDDww6g0TIUZvASyjwlUrSQNWooVuvyUuC1rx
         tx83zzEdPEtBc95i4bV7zyAqpz/RcGMi7/vOHhjP8zdx9DPQ6YlU0dyqbv0Rcr9iBX32
         Qn2HlK0gvPLYM0oVjE7AM4bcl+3ujvW991I7IKXBnHsJFHAlYXJKbaa9hQFos7035Af0
         Ebsw==
X-Gm-Message-State: AOAM5319bW+TbCC+4h+68G2dRcXPR4mDWeon1T3gB21yFM65DxxRyf8u
        Bw2TxSXKFcRsHcrNL9ThBQx5n9CyHg==
X-Google-Smtp-Source: ABdhPJyJ/vLG5EM+mwDq6WrvjKVvipezABEQ4XAsfkBAlmEkSCpxAjE03uaEyDFwX9tlOqQIXfIKjg==
X-Received: by 2002:a17:90a:7344:: with SMTP id j4mr7575058pjs.216.1614737397602;
        Tue, 02 Mar 2021 18:09:57 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id f20sm280415pfa.10.2021.03.02.18.09.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Mar 2021 18:09:57 -0800 (PST)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH] kvm: lapic: add module parameters for LAPIC_TIMER_ADVANCE_ADJUST_MAX/MIN
Date:   Wed,  3 Mar 2021 10:09:46 +0800
Message-Id: <20210303020946.26083-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

In my test environment, advance_expire_delta is frequently greater than
the fixed LAPIC_TIMER_ADVANCE_ADJUST_MAX. And this will hinder the
adjustment.

Adding module parameters for LAPIC_TIMER_ADVANCE_ADJUST_MAX/MIN, so they
can be dynamically adjusted.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
 arch/x86/kvm/lapic.c | 6 ++----
 arch/x86/kvm/x86.c   | 8 ++++++++
 arch/x86/kvm/x86.h   | 3 +++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 45d40bf..730c657 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -61,8 +61,6 @@
 #define APIC_VECTORS_PER_REG		32
 
 static bool lapic_timer_advance_dynamic __read_mostly;
-#define LAPIC_TIMER_ADVANCE_ADJUST_MIN	100	/* clock cycles */
-#define LAPIC_TIMER_ADVANCE_ADJUST_MAX	10000	/* clock cycles */
 #define LAPIC_TIMER_ADVANCE_NS_INIT	1000
 #define LAPIC_TIMER_ADVANCE_NS_MAX     5000
 /* step-by-step approximation to mitigate fluctuation */
@@ -1563,8 +1561,8 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	u64 ns;
 
 	/* Do not adjust for tiny fluctuations or large random spikes. */
-	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_ADJUST_MAX ||
-	    abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_MIN)
+	if (abs(advance_expire_delta) > lapic_timer_advance_adjust_cycles_max ||
+	    abs(advance_expire_delta) < lapic_timer_advance_adjust_cycles_min)
 		return;
 
 	/* too early */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 828de7d..3bd8d19 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -176,6 +176,14 @@
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+u64 __read_mostly lapic_timer_advance_adjust_cycles_max = 10000;
+module_param(lapic_timer_advance_adjust_cycles_max, ullong, S_IRUGO | S_IWUSR);
+EXPORT_SYMBOL_GPL(lapic_timer_advance_adjust_cycles_max);
+
+u64 __read_mostly lapic_timer_advance_adjust_cycles_min = 100;
+module_param(lapic_timer_advance_adjust_cycles_min, ullong, S_IRUGO | S_IWUSR);
+EXPORT_SYMBOL_GPL(lapic_timer_advance_adjust_cycles_min);
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ee6e010..3f7eca0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -305,6 +305,9 @@ static inline bool kvm_mpx_supported(void)
 
 extern int pi_inject_timer;
 
+extern u64 lapic_timer_advance_adjust_cycles_max;
+extern u64 lapic_timer_advance_adjust_cycles_min;
+
 extern struct static_key kvm_no_apic_vcpu;
 
 extern bool report_ignored_msrs;
-- 
1.8.3.1

