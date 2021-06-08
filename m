Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310FB39F8A9
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhFHOOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:14:44 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:55295 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbhFHOOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:14:42 -0400
Received: by mail-qt1-f202.google.com with SMTP id d12-20020ac8668c0000b0290246e35b30f8so3258063qtp.21
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JXESWIRrg65Jst8XI7PkCsZKq0ZtOHhtcll5+7kJZvQ=;
        b=EZZZOs/wJaLpc4iV8fhIWCgKJcms1Zc85BNtnQggUPKXLstvhiF1Jeh4Z5mKQORV1x
         rFVJ1253JOz+Ny3hILPyxJN25otv0qA72R77AxNIg/sjMzYAn95LC9YrROnTMPnB9hJL
         5w1ejcaPtilYK6h/+gIJNqCjIPpGrtK+wn1lEvXmeLuxuc0ZTXgQICCE9UdsRrPtEtap
         u0tTuPG5/p/s5OYny9dy7K5wOHk7JRHis7NI28wlQNOg37qO8VQhe8xTtU2PYPK0oQyF
         RRdHjhmCR1EpJ5PkNy57QB3dBgQVQzyUdGqtHQDFUy/huC8jMWOlrPjcuFbQBqn+PDIN
         FJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JXESWIRrg65Jst8XI7PkCsZKq0ZtOHhtcll5+7kJZvQ=;
        b=f5Xte7hxlFrHzyqq/neNgpldkG+zN4aaeZYnrn8sdfDm6zh6uoRWJbpD9/pJuEh2wd
         3wPzJg7qq1JKRBszj7BuCeW5WbH3GSsb36DPZJFTTY+jOpeWoxbc/Er/7hv8wlMaXugC
         9uk7a4VtMrA+/jCy4RLPQoQFhRu8CXAmn/TSCG+sN4vIEH+jaKZ5Az2KchJ6BEIOewWz
         xSJMW94Xy0cGAJZUKPEcWGMsvEcvrm2kp6sLMj/ruoqND68l+oIhH1BzbgtKKvfyuA1P
         OCnDmhdGXbhnZry1QdI39q/Q9f0VVvR0TEhGi5/11n46SLhRNM+4I+0tenAGH6YMnPMA
         IAfw==
X-Gm-Message-State: AOAM531rnsHyaWlnYddCI6aC0ak0OgnGo0qtm1S+AtN8A3eurlosMh95
        YfZcaJSSnDtOEo0QGDpoYSmPcfufRA==
X-Google-Smtp-Source: ABdhPJzFZhBxwNe7fGP0rKm32SNqUOu/zZzV1SJv34ne7YfRjjA0JDJ8WQ4OdDzl/uUfpzc+v515ENBpag==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:f982:: with SMTP id t2mr327420qvn.28.1623161509479;
 Tue, 08 Jun 2021 07:11:49 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:31 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-4-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 03/13] KVM: arm64: Fix name of HCR_TACR to match the spec
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Makes it easier to grep and to cross-check with the Arm Architecture
Reference Manual.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 25d8a61888e4..d140e3c4c34f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -33,7 +33,7 @@
 #define HCR_TPU		(UL(1) << 24)
 #define HCR_TPC		(UL(1) << 23)
 #define HCR_TSW		(UL(1) << 22)
-#define HCR_TAC		(UL(1) << 21)
+#define HCR_TACR	(UL(1) << 21)
 #define HCR_TIDCP	(UL(1) << 20)
 #define HCR_TSC		(UL(1) << 19)
 #define HCR_TID3	(UL(1) << 18)
@@ -60,7 +60,7 @@
  * The bits we set in HCR:
  * TLOR:	Trap LORegion register accesses
  * RW:		64bit by default, can be overridden for 32bit VMs
- * TAC:		Trap ACTLR
+ * TACR:	Trap ACTLR
  * TSC:		Trap SMC
  * TSW:		Trap cache operations by set/way
  * TWE:		Trap WFE
@@ -75,7 +75,7 @@
  * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
-			 HCR_BSU_IS | HCR_FB | HCR_TAC | \
+			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW )
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
-- 
2.32.0.rc1.229.g3e70b5a671-goog

