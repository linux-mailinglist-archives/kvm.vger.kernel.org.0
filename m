Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04431C2B24
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 12:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgECKJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 06:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727892AbgECKJp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 06:09:45 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01961C061A0C;
        Sun,  3 May 2020 03:09:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b6so2318076plz.13;
        Sun, 03 May 2020 03:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oXmStsagWliYLkyg0XA1gqk4mbLGloO7btJZBgB6zp0=;
        b=tmvji8xyRdqsUB+mJaeyiIe7c4z0UB7U8rXiPb2bKbGmPdMhrnasUqxi90hmQpFHdx
         ruXEq6E7s3FrcYF+ISN5c77wEr9RBYzYTmP1RD0xIaGlPht/HHovqxEmDuoDqBgJiOIt
         K6dA4KGRbluVamiZ3dIot1sTu8x1ClLGwy7FzMXJlz/vQfTunKIQHMr+Xgh9mXTawD12
         +ErNrPUwLIpFnmjaioKv1oXoaVIM/5PPySIy/dzMI6V2TJN/j/gkmMC0VJezv8yg/+sb
         I4LUv45ywoLmhAcXymKOjLb/NOa9Z6M7x7Df3h7YyHL3790lUWizZzZ73D16oGS92CMD
         iyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=oXmStsagWliYLkyg0XA1gqk4mbLGloO7btJZBgB6zp0=;
        b=S1b2ly+ADGTp6OKgGRblsju4WmRoba9qB5uYBPTgGTd/dFWLUkJcwvvQtB2lN1E78+
         ogfcbzsKaJtUB+zfvgH0M3eJSsufKNrzOuMU+eS4l8+cAWYK8r2EcdYtnYcp7R9jLdAD
         TJMEm2Vevpoh3C5q0I9MoZSdA0YhIULE08Gboyre7HHv7Qp56mtejpyul62K9AkSPCCs
         5bj3wlO1w5DpE0yGPOR2RBOKjY4TEHtStEEpYP1EspM4V/ZyKH6TYiiLOAxiFmAla7WH
         xP7/IAM1XRUo0URhySqaqwuZO8mxyh3zFs2+Jtc36tYIm7nZtKVMlDhk3AqlZ2HGwEaS
         Be2A==
X-Gm-Message-State: AGi0PuaGyPkntWSQarQ1y9AYWQTh9hjS3X4PLGbjl8CiJX3pKHUuDCtL
        +bQm9z0w5ZQJPAi8sp2e9c8=
X-Google-Smtp-Source: APiQypLHfD0TtiMXhXxN0eKY+t8XWTg7Jg8VyjEMHD9kmgl9RZx16BaBjW9teT007N/oQXqBBejFFg==
X-Received: by 2002:a17:902:7203:: with SMTP id ba3mr12506149plb.202.1588500583620;
        Sun, 03 May 2020 03:09:43 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.09.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:09:43 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V3 04/14] KVM: MIPS: Add EVENTFD support which is needed by VHOST
Date:   Sun,  3 May 2020 18:05:57 +0800
Message-Id: <1588500367-1056-5-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add EVENTFD support for KVM/MIPS, which is needed by VHOST. Tested on
Loongson-3 platform.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/Kconfig     | 1 +
 arch/mips/kvm/Makefile    | 2 +-
 arch/mips/kvm/trap_emul.c | 3 +++
 arch/mips/kvm/vz.c        | 3 +++
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index b91d145..d697752 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -22,6 +22,7 @@ config KVM
 	select EXPORT_UASM
 	select PREEMPT_NOTIFIERS
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_MMIO
 	select MMU_NOTIFIER
diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 01affc1..0a3cef6 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for KVM support for MIPS
 #
 
-common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
+common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o eventfd.o)
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/mips/kvm
 
diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
index 5a11e83..f464506b 100644
--- a/arch/mips/kvm/trap_emul.c
+++ b/arch/mips/kvm/trap_emul.c
@@ -529,6 +529,9 @@ static int kvm_trap_emul_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MIPS_TE:
 		r = 1;
 		break;
+	case KVM_CAP_IOEVENTFD:
+		r = 1;
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index dde2088..17932ab 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2927,6 +2927,9 @@ static int kvm_vz_check_extension(struct kvm *kvm, long ext)
 		r = 2;
 		break;
 #endif
+	case KVM_CAP_IOEVENTFD:
+		r = 1;
+		break;
 	default:
 		r = 0;
 		break;
-- 
2.7.0

