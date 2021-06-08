Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F3939F8AC
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhFHOOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:14:50 -0400
Received: from mail-wr1-f74.google.com ([209.85.221.74]:56955 "EHLO
        mail-wr1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbhFHOOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:14:49 -0400
Received: by mail-wr1-f74.google.com with SMTP id s8-20020adff8080000b0290114e1eeb8c6so9489865wrp.23
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4Asy9TeJS64pEvGY8XEAbuolwNNbKZBoX69L3dIU+1w=;
        b=pqkh1UBwITENdBKvU99xgPAZ6Mx6QI3ILsXjKO6Uq7zCucOnSy+qzrIEiZPaZXQEKa
         cAU2XhxYOX81hN680aGEcxhGPa1HlZOb7BQ+XW7M5qWn2G8jCmt7f7Xhlx8hycAS8+Rw
         vFAIYth4ZXHQFJmTS+gHrhPYguUOT2hVxzyRQTGNbeXaz3ieVgobfOmpUhOJp7ELzepa
         +pk4HABsT0zjVO3z+nkudCEme5XhkRghb8hwDJwVvq9sMZYElPUshgVbSXE0tiLK+r+c
         gh4rH7nLfJ8NSSWcLxvyvRfmtTCXT4i9h8kdD6apYO/zYRHfRcIFZVHBJDOZXw7qobdR
         JveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4Asy9TeJS64pEvGY8XEAbuolwNNbKZBoX69L3dIU+1w=;
        b=U+RS6ThrfOuaQ4YT489Mi/9j+ZgOUx2nivcB9bPZpKTMeWN6lO4DrRlBr6geXjRQ3y
         GRIg3pfKxh4CQHe7xeLNZdpxcUZAekQjN2SQg90eh1z5KgVrSDrAkDPRd7RLcBpE7jVZ
         I+HHAYkQnErN6W7iHM5OKFla/w1Anv13t5BDII3zBW1RHbPKxOXefQZ1NvNyw3AzLSgh
         elUy5GE/sSrs0t5V7mJWLHbiCwzGe6a+Gi9HeCtoxhR4nswxPqR2vt0kbjOqZ0ck2x6i
         NmUl7QgbvWaKwvN8HpZ/50BlNAG5prNpFC7lTDkbxq0E4BciC6JsnWIryZSecXAl9U+h
         ekYQ==
X-Gm-Message-State: AOAM5310yRAmqWRJfTW7RlrHBlS0mmXo0tg3YPg0orGyAiTnZa3Si3ab
        gbulCufhXNxlz79E3BAHwhesiNmIeQ==
X-Google-Smtp-Source: ABdhPJzS+sELn7BYfrB7ptQIb0s7ygi8FymYY+xXnjkAYPENkhE5guGgsqKszr4QNxFmh8mo96FSX0OKWA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:f70d:: with SMTP id v13mr21664188wmh.183.1623161515598;
 Tue, 08 Jun 2021 07:11:55 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:34 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-7-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 06/13] KVM: arm64: Add feature register flag definitions
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

Add feature register flag definitions to clarify which features
might be toggled.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 65d15700a168..52e48b9226f6 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -789,6 +789,10 @@
 #define ID_AA64PFR0_FP_SUPPORTED	0x0
 #define ID_AA64PFR0_ASIMD_NI		0xf
 #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
+#define ID_AA64PFR0_EL3_64BIT_ONLY	0x1
+#define ID_AA64PFR0_EL3_32BIT_64BIT	0x2
+#define ID_AA64PFR0_EL2_64BIT_ONLY	0x1
+#define ID_AA64PFR0_EL2_32BIT_64BIT	0x2
 #define ID_AA64PFR0_EL1_64BIT_ONLY	0x1
 #define ID_AA64PFR0_EL1_32BIT_64BIT	0x2
 #define ID_AA64PFR0_EL0_64BIT_ONLY	0x1
@@ -854,6 +858,7 @@
 #define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN16_NI		0x0
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_PARANGE_40		0x2
 #define ID_AA64MMFR0_PARANGE_48		0x5
 #define ID_AA64MMFR0_PARANGE_52		0x6
 
@@ -901,6 +906,7 @@
 #define ID_AA64MMFR2_CNP_SHIFT		0
 
 /* id_aa64dfr0 */
+#define ID_AA64DFR0_MTPMU_SHIFT		48
 #define ID_AA64DFR0_TRBE_SHIFT		44
 #define ID_AA64DFR0_TRACE_FILT_SHIFT	40
 #define ID_AA64DFR0_DOUBLELOCK_SHIFT	36
-- 
2.32.0.rc1.229.g3e70b5a671-goog

