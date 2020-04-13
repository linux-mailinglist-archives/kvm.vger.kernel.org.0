Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E99B1A6395
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgDMHXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbgDMHXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:23:11 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE5EC008651;
        Mon, 13 Apr 2020 00:23:10 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id n13so4099485pgp.11;
        Mon, 13 Apr 2020 00:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qhpq41BRu/RPPwD4eaCJ5cfb9DHBcGHPYRUi0Z0GRT4=;
        b=Pm3BaaYHprds2QFeII0r9egbTq6PKvjEZ4oGWq6qQF9MHfbSZOZ42IDzZkMcHh55A+
         moc02dm11rgYAADl/KyOBMkZhgs3w0bnFOczVFoIvmTj6F8HIN1ulrRauQW5Rgo5NuId
         cXruvUf/VP0hNrJKVD2c53l6etSJ/THuMFWw6OAzl97dx6gQWKjOGJ5CKq9HOOfckpbv
         sPR1JXy3tWmtoL4udghPanl6w/nfyKA+k43Y769uyDrP2/Y+pGF5wucOFknJIetRoSPE
         9AKK2KvEpo2cl4eZXGQrK9nOL0A6VnpDNJLZ3gNDdQSWbY++e/NP/xOvBAtzahq9328R
         HV+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=qhpq41BRu/RPPwD4eaCJ5cfb9DHBcGHPYRUi0Z0GRT4=;
        b=pEkbZCJqJPkm+z+yZqL6CdZ+r2Pb5QikqHIC/luuGDB9yQZLFsDuws1N+dnubH4Y76
         z76NyMV605F61YmD5I6cMCMUTH6iZVy1B0N5LgEm6TzXWWXf2ok58PxaIV0hk1UO37OZ
         kPKqk7tUklsGbneivGcR02eiAUxsdzNCnqPqUETodETQL1QcS5f2GXf66Mhz/B8pr25w
         Yg/XmgXaJMmWiMGADxrihu0AeUY9HzuHJWGwNrqA9Sas+H3iNayCQUF6/+MA2vmBn9/M
         6MQGuU7xnA4bDQ0keWMKB3eRAYGZyettCeS6lQcqjvNv4xczSfd1u037Jswp0csi4X9D
         w+nQ==
X-Gm-Message-State: AGi0Puaf8OwYE3Xm2eOYqCMMHbyfFryuWOoPa6ktowmmNxt8HyhpM7TT
        Sb7njCGOycIHAcYjr5MHOlQ+DsY6JJo=
X-Google-Smtp-Source: APiQypJ2RWntWbbpBSM1g5kZmzP5ruORUti27kfstHoJP/pSw4ATCiAl2BtVdEXVJ1aCioNa49hX9Q==
X-Received: by 2002:a62:164d:: with SMTP id 74mr1172550pfw.52.1586762590414;
        Mon, 13 Apr 2020 00:23:10 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.23.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:23:10 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 04/15] KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
Date:   Mon, 13 Apr 2020 15:30:13 +0800
Message-Id: <1586763024-12197-5-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 based machines can have as many as 16 CPUs, and so does
memory slots, so increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 7b47a32..2258a2e 100644
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

