Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A216A1D0B11
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732384AbgEMIoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732346AbgEMIoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:44:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8507DC061A0C;
        Wed, 13 May 2020 01:44:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n18so214518pfa.2;
        Wed, 13 May 2020 01:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p7gcKiXZHRnvuvHPL32ueIkTT7PTkn2ALsQ2li3G5xk=;
        b=hqCRiEHKKFPIJiyC2OUzgVldS2IwC86OrcsRHRNgu6c75LI1+ho+jPW71cRpBg9rrt
         ULNYOfg4tpCjOdS8zGKL30DsN5vSjKx7v8Kt+/WqNKBv60AgqaftUDcgtx2D30NIjDKg
         /czl6pBFHeqM/qOHgi6mf9ruXf6pGj7tkAWFVwfMYy0Msi6qYrFOwACvf/Zaqtgc3fBJ
         H+gGigOfzj2MBd8/4/o08PpUQWvf1Ml8jSCfLlJPDrUhLtSwTI3ofLbd+TWFYmt7FNfM
         vQ3c9i6YBehJb8J6WzCGmWfOkgFTTWEXOgF00B2pqCK0EoqlEW70vXPGwP118VNWMyhf
         CEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=p7gcKiXZHRnvuvHPL32ueIkTT7PTkn2ALsQ2li3G5xk=;
        b=ebJpjdp6OC1jGAs4DdqmWNzw0+fGHjof1On7h8VSKWqqEQOgK03HfBbVhQCR6RZ0R7
         yPZ1pSwn12EIRsRdcCN15Ojbsvz/mhp5Ma4/+42l3JerpurOdqXoMsbKOilbIKcQsJ2S
         ySufbexVUBm+ZK07fo14kEyJcjRcca9OPi7/38qzsT27D8ex19sLCOY3YVLVIQZPKhjO
         zI5Y3bPGr9oFM22BVclErSQqWk5A9pqGSfp7Iyf4+sDOOMBwxTUZS+j6rrl56/gNvjqs
         /9p/D4WH9qwIRD3XHTgRMPjNy/oWAbSrap+eMXnCC4XGaytnQS7Lg/qwxBaqrZu4SFKs
         012Q==
X-Gm-Message-State: AGi0PuZ50y5zNKz94fJYOkYyoJnN2ckWGF+Lx3rG2qD1onxFR8jwR4vW
        rx91fk3jidHmVr7/D56oPQg=
X-Google-Smtp-Source: APiQypJMHzr3Zl+nTE/vq8iC/1VmoZ7dDPBNboG4JGYAYTTi9Z+g1gNiTzAA4Fw8ZoRlUCS2a+8QuA==
X-Received: by 2002:a63:2943:: with SMTP id p64mr23078962pgp.36.1589359443168;
        Wed, 13 May 2020 01:44:03 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.44.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:44:02 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 03/15] KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
Date:   Wed, 13 May 2020 16:42:34 +0800
Message-Id: <1589359366-1669-4-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 based machines can have as many as 16 CPUs, and so does
memory slots, so increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index caa2b936..a7758c0 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -78,8 +78,8 @@
 #define KVM_REG_MIPS_CP0_KSCRATCH6	MIPS_CP0_64(31, 7)
 
 
-#define KVM_MAX_VCPUS		8
-#define KVM_USER_MEM_SLOTS	8
+#define KVM_MAX_VCPUS		16
+#define KVM_USER_MEM_SLOTS	16
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS	0
 
-- 
2.7.0

