Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5105E352D35
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhDBP6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbhDBP6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:58:13 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFF1C0613E6;
        Fri,  2 Apr 2021 08:58:11 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso4517567wmq.1;
        Fri, 02 Apr 2021 08:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kre3cIsJUUiu6GfRt+z3UNvRKui0T9xc/PeVTTZr7ig=;
        b=ryhHc1JzRHdWPicwK8viSU3MOD5f0eQmm47r5hbvS+5+INAyYGM5jeUruCl/zWWXFv
         jIdoxhhJ1sZ/ijWxfQcTzuqTpapouUmlJlZtolrY1OqwmAMqf6agR6e+/YWyQlXeVCt6
         v3OtZXnYow7y0Mr9w4qsK0iTK8lSGIBMz7ZT9fW4mwxeIMwYcPTPmXRHDN3Kf/ST5XdK
         KWFpklbVNdKGx2q9Kd03pk/Z6mgiGmGexIvgr3VXf0lWDAaAgD+jFoLyCK7FygZxV3/s
         6HD/8pzAlRWBIpC8N/fIE2Vwgq5ZgXofjpB5HV385leTv90TPkPnPXyzIX50PomWFitr
         vOKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Kre3cIsJUUiu6GfRt+z3UNvRKui0T9xc/PeVTTZr7ig=;
        b=WnywaZBVkOToXt1Fq2qPbHRyE/3sOeHnV1EQhs6hf6HkdiixIzHdmgb0lL3f81WLY8
         mik+G1lfUjeeo+2lGe0stDHTAeYq0hfo9r0X3Va+z1NRN5gcwUtdNqfFZ8g9uxi9d5Cr
         1yaY5kiFJtT8SaK0u1yuSiUg+jlXVpP1UwEEGU/6bkhlXz4MGEEPFdsNwiqzcvBE8HO6
         tPODEjvBvL/IpYcOXkxLdazwKhN7eGRfvdR9nRcwFY7g0qyNTmykHk1AXaZdYc8mQWCx
         4Uc9dul53K4nwbiidrBb1RxeW3JmbeHhv7ZAEuPgOYnHnABpJYd4Mhrj/HZUuneJAfYf
         fydA==
X-Gm-Message-State: AOAM531izZb5vrf/+5aSUmDbM5BA39tbCdTlyPaU9l4J9Ko/EELku9V0
        ulaAr64CXmflWW/k+f7jC45MSrKeMG0=
X-Google-Smtp-Source: ABdhPJxkN/qm1HIJiGhdrsPZwOPx99MtS0WKuuR1c+cS3d4UmftRHekbQfkqHrzcI3HfVcNz5ZQ3bA==
X-Received: by 2002:a05:600c:1457:: with SMTP id h23mr2284614wmi.118.1617379090365;
        Fri, 02 Apr 2021 08:58:10 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w11sm2293625wmb.35.2021.04.02.08.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:58:10 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        seanjc@google.com, linux-mips@vger.kernel.org
Subject: [PATCH 1/4] KVM: constify kvm_arch_flush_remote_tlbs_memslot
Date:   Fri,  2 Apr 2021 17:58:04 +0200
Message-Id: <20210402155807.49976-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210402155807.49976-1-pbonzini@redhat.com>
References: <20210402155807.49976-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

memslots are stored in RCU and there should be no need to
change them.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/arm.c     | 2 +-
 arch/mips/kvm/mips.c     | 2 +-
 arch/x86/kvm/mmu/mmu.c   | 2 +-
 include/linux/kvm_host.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7f06ba76698d..9141730b7963 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1268,7 +1268,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					struct kvm_memory_slot *memslot)
+					const struct kvm_memory_slot *memslot)
 {
 	kvm_flush_remote_tlbs(kvm);
 }
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 58a8812e2fa5..7db8234a4407 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -997,7 +997,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					struct kvm_memory_slot *memslot)
+					const struct kvm_memory_slot *memslot)
 {
 	/* Let implementation handle TLB/GVA invalidation */
 	kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0d92a269c5fa..f75c677910c9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5616,7 +5616,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					struct kvm_memory_slot *memslot)
+					const struct kvm_memory_slot *memslot)
 {
 	/*
 	 * All current use cases for flushing the TLBs for a specific memslot
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e6d77353025c..34a974ffc882 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -894,7 +894,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
 
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					struct kvm_memory_slot *memslot);
+					const struct kvm_memory_slot *memslot);
 #else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
 int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
-- 
2.30.1


