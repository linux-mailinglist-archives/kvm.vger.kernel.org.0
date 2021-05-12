Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40CE37BB55
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 12:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhELKz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 06:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhELKzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 06:55:54 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA38DC061761
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 03:54:44 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id c22so26502615edn.7
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 03:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NPXzGpmso8Te8IRLGmmznTWDVnaW8I7l+0F2ZmGTikk=;
        b=WBwhP4kSQeL/Rzy5eduUceKcWKhU7XRl9kE6Hsqnt7EkH3iNZy2hFCTGDpUjAsZZ/7
         VcEoKdDQuztgQNI0Fl9E34PwAzunDLxEcqemp6V2TNC1cf7v0d+M5VBt3hwqJgRvG1vH
         SAqckcUAGLG4W46IYiWG6fvaKoJ44/SR/dAtFYSM3d52ZT93om1YAZmuQR2kye74wByk
         WHm8CBcfJpCLT/8swpPIaUrtmssl++SDIwmb09UBNcYn/5GRMHwY38Ucxk29bOI340Cr
         pnxjM5AeY2epGNHTXfj8Tl+ZYCMadgtC5RE+ZTYzi0FP6xKlseXKwdm8NzkT2CjofX/Y
         eENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=NPXzGpmso8Te8IRLGmmznTWDVnaW8I7l+0F2ZmGTikk=;
        b=uBCpNtqlNpFhzkDhnQ48ggHr8yeGtNqSedWcrwl6iha7/A5ebeNUVYdBwDlhjejgDL
         psvoeTjdEdRgsKlo0vwtnv1w3nVJV6VmUI8X3tqdJLdtdKZxTWTdHmKwOXBSvBQuJQKd
         fJx4Qzyq9XysS5vLwCoZiMbzoFGKFd7XW03nSZx8okOp+DSwGmdkecPTuCedAxm8oqtY
         GsgA3kC4cX6SrkOqZSeeDH3WLsx6hhuJMioo0i5hk5Yks0ct0+TKDYdGEzDrGSe8ofLw
         6iH3EGFnuyiC8QqYbCCr26019kHQSgItiOVDAyKd6vUnEkx8B9R2YA03iYQcY/IbOOB1
         kOEA==
X-Gm-Message-State: AOAM532zr4Fv99ccnoSnaq0YHa0vVP+f9WHP3DQi2AqfnyUCWWv8hqtV
        Zje2OFjNZJj62xPwVHS1/Ef0c3WiC4E=
X-Google-Smtp-Source: ABdhPJxx1vATkhTNvJOlK9tTb/FsDaxl+CQ55MaKjd7u6oOtMjk488IFc6dxRkqtfm3+mQovFFKVzQ==
X-Received: by 2002:aa7:c30c:: with SMTP id l12mr42319992edq.217.1620816883622;
        Wed, 12 May 2021 03:54:43 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b19sm16829624edd.66.2021.05.12.03.54.43
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 03:54:43 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH v2 kvm-unit-tests 2/2] arm: add eabi version of 64-bit division functions
Date:   Wed, 12 May 2021 12:54:40 +0200
Message-Id: <20210512105440.748153-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512105440.748153-1-pbonzini@redhat.com>
References: <20210512105440.748153-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

eabi prescribes different entry points for 64-bit division on
32-bit platforms.  Implement a wrapper for the GCC-style __divmoddi4
and __udivmoddi4 functions.

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

