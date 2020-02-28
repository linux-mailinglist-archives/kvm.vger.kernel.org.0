Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD86E1734A0
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 10:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgB1J4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 04:56:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50758 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgB1J4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 04:56:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so2543118wmb.0;
        Fri, 28 Feb 2020 01:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=zKGXK9SAs0Ecacz7HFCrkRE8+zApqJ5J3A2oMtz1fqU=;
        b=AjGi9oKXYefDfw5yebzDzw4qIkTe3S/U2jkj5sanwnGoPZKDcclQeuZ+7tC2KDV73Z
         x2M0soNYFSdHwsQNzRbtFt+ukkVKkkqKGo/wxqaze688veIAJLqslmFLLwZ6nxm7IjVZ
         w34vMJLgBC5R9ESLI35r8CT2b7X5PfnJyq1L7G1VZvgN7tXI6sLOaK5aayN/mfKZyVoy
         XHCNIHcBfMHqbqUISLmm0aBO/e80qaEKZvyuOuezzy2KmdVhcKPkj/IRVRP2t+5ClFV6
         PX7vqfHU2pI6SWmbrbAXQRp6fYmcTtQb0USv32sArRPGt/S9BVPyve4GpULxers20YS/
         P1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=zKGXK9SAs0Ecacz7HFCrkRE8+zApqJ5J3A2oMtz1fqU=;
        b=s+GGq6qVcSCY/Q55VxrRWarLJ+ZvzQWcDENL1x0tJvgaK5SfAZc+OfzFqy0yNG9RYm
         ACqejSY3jO0+2a2LijvUyxpwaMQP3mI/ggZVUxmp4s8eM6yIlsFcXqMwwXgJG2/i16TF
         lZzwCGdzZupp/yBvKE21WK3mimde1CTFXAzrwhWPbd7BHXsNFA0MLeXJ5N7A4HjiQgbL
         4sDMGZcLPGTeyDTj+zo3Yw9iJPPVbkaAzsACpFi/X6CelDyq5M9E5XxdbKr1vpaHv8YX
         ZlzzX8bLNUz3rYIMCtDm1jkGaGZISc6eiKZk4vSKh4tyVW/3sznD6h6eeeOO/kG56Aee
         aW+w==
X-Gm-Message-State: APjAAAV4lJZ+tRAeQzj/4ZFZsBPLN4pCmY8OpGras2N1AkW7NEX9pR30
        nAfXDwq2+KtGOHmwxrCsWH/XnE/A
X-Google-Smtp-Source: APXvYqxwIh2KTYZXXyArYgBQzV4t5qeE+7xhHbRZR6CI30Br31D4xn9E18Gc7TX0/GIk1PDqBEnUIQ==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr4150009wmi.116.1582883766312;
        Fri, 28 Feb 2020 01:56:06 -0800 (PST)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t3sm11664565wrx.38.2020.02.28.01.56.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Feb 2020 01:56:05 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH] KVM: allow disabling -Werror
Date:   Fri, 28 Feb 2020 10:56:03 +0100
Message-Id: <1582883764-26125-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrict -Werror to well-tested configurations and allow disabling it
via Kconfig.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Kconfig  | 13 +++++++++++++
 arch/x86/kvm/Makefile |  2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 991019d5eee1..1bb4927030af 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -59,6 +59,19 @@ config KVM
 
 	  If unsure, say N.
 
+config KVM_WERROR
+	bool "Compile KVM with -Werror"
+	# KASAN may cause the build to fail due to larger frames
+	default y if X86_64 && !KASAN
+	# We use the dependency on !COMPILE_TEST to not be enabled
+	# blindly in allmodconfig or allyesconfig configurations
+	depends on (X86_64 && !KASAN) || !COMPILE_TEST
+	depends on EXPERT
+	help
+	  Add -Werror to the build flags for (and only for) i915.ko.
+
+	  If in doubt, say "N".
+
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4654e97a05cc..e553f0fdd87d 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ccflags-y += -Iarch/x86/kvm
-ccflags-y += -Werror
+ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
 KVM := ../../../virt/kvm
 
-- 
1.8.3.1

