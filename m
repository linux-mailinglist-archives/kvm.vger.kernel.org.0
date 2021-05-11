Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4009537AD3A
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhEKRmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbhEKRmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:42:20 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8066C061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:41:10 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g14so23891373edy.6
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pc/L6ED7H2RwZMgS4Vq0ULfZJt+L6YaroAbjkFRFCkM=;
        b=U8qWcXXyPWqKrOvUNouADqOJ4zKDm/LkesdC6hSrMVUslzi6hyeKiL1FR3grirLe65
         x4WFnBPt4FiGWjGuoVLL+W8LU17/ns4WjCWy4fGv7pyl+N1AdvnW8UtlTCZ0ca5b87DV
         fzhgTUBdZI141YjqfAyZtJZFmHQ0/+uwQo68XymtgUAKFN7iBS67jarxHPVOf7awlC42
         ovD3MM+ZrE85GWfvLazBNPFGiOX7qGS/J48CNqkYia/IxAKsAMNOzz/S2cIL+YQuMqPa
         rf55O4198Q+o/qe6VhGHtVQYEgyhyDlQW6+G0aj6W4haGP/ouHZMIcxBLKRz0KUmiExb
         VXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=pc/L6ED7H2RwZMgS4Vq0ULfZJt+L6YaroAbjkFRFCkM=;
        b=GkY1UI1qjoY/7iJS5W3fZZyR2aRfFLUspdFZFYENUkjTiSbGvvs/CFWiek5lCsnh5r
         6hjYHOewaSBvOgmUxDa7Y97Ez5w8b4k+SQyZGCyohOzwNPQy+3Nq5h6+FKLh0t8QhPr2
         1lT3SGzIlUuncWSJwvC9TjVDzeqtcRIY23myjYC5SuY372lNBgWvEt0BgfzmkHN1Mswn
         k94IRvDdFkgsY+IRBqzvh2uSnqwAYgtGhnkPmUAqrQC7PleQfXi1v9/OI88uwsy0mbu0
         /uSq20/d55Ov2AgmGpaNe9e0EKsswshIHlxo5wYGzhXWI1RV3T3XR2COJirWTstbzPml
         /chg==
X-Gm-Message-State: AOAM533hv+Z08tvkivWGrixd0Nvpad+2Lr988xyHkGKsOA+eVIcqyQft
        x+f0DDPKfcaBLFedVGfFLvIjub+oVu4=
X-Google-Smtp-Source: ABdhPJxTsOCwcOqmkJUmlqKUC7+s0dEFqtklNzfXJYZCTQkGKs2Vt1Svz4KdhgivbfZIJb/3v1G8gA==
X-Received: by 2002:aa7:c789:: with SMTP id n9mr38495966eds.352.1620754868887;
        Tue, 11 May 2021 10:41:08 -0700 (PDT)
Received: from avogadro.redhat.com ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v23sm15239073eda.8.2021.05.11.10.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 10:41:08 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvm-unit-tests 2/2] arm: add eabi version of 64-bit division functions
Date:   Tue, 11 May 2021 19:41:06 +0200
Message-Id: <20210511174106.703235-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511174106.703235-1-pbonzini@redhat.com>
References: <20210511174106.703235-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

eabi prescribes different entry points for 64-bit division on
32-bit platforms.  Implement a wrapper for the GCC-style __divmoddi4
and __udivmoddi4 functions.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arm/Makefile.arm  |  1 +
 lib/arm/ldivmod.S | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)
 create mode 100644 lib/arm/ldivmod.S

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 687a8ed..3a4cc6b 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -24,6 +24,7 @@ cflatobjs += lib/arm/spinlock.o
 cflatobjs += lib/arm/processor.o
 cflatobjs += lib/arm/stack.o
 cflatobjs += lib/ldiv32.o
+cflatobjs += lib/arm/ldivmod.o
 
 # arm specific tests
 tests =
diff --git a/lib/arm/ldivmod.S b/lib/arm/ldivmod.S
new file mode 100644
index 0000000..de11ac9
--- /dev/null
+++ b/lib/arm/ldivmod.S
@@ -0,0 +1,32 @@
+// EABI ldivmod and uldivmod implementation based on libcompiler-rt
+//
+// This file is dual licensed under the MIT and the University of Illinois Open
+// Source Licenses.
+
+	.syntax unified
+	.align 2
+	.globl __aeabi_uldivmod
+	.type __aeabi_uldivmod, %function
+__aeabi_uldivmod:
+	push	{r11, lr}
+	sub	sp, sp, #16
+	add	r12, sp, #8
+	str	r12, [sp]                // third argument to __udivmoddi4
+	bl	__udivmoddi4
+	ldr	r2, [sp, #8]             // remainder returned in r2-r3
+	ldr	r3, [sp, #12]
+	add	sp, sp, #16
+	pop	{r11, pc}
+
+	.globl __aeabi_ldivmod
+	.type __aeabi_ldivmod, %function
+__aeabi_ldivmod:
+	push	{r11, lr}
+	sub	sp, sp, #16
+	add	r12, sp, #8
+	str	r12, [sp]                // third argument to __divmoddi4
+	bl	__divmoddi4
+	ldr	r2, [sp, #8]             // remainder returned in r2-r3
+	ldr	r3, [sp, #12]
+	add	sp, sp, #16
+	pop	{r11, pc}
-- 
2.31.1

