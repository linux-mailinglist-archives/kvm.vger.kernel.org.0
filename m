Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A4B64F3B6
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 23:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiLPWH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 17:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiLPWHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 17:07:54 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF2418B27
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 14:07:53 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bj12so9182615ejb.13
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 14:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BuvOmgloso2e5NXgsHUei7ptWD2NT1t6KV+3QRSZobI=;
        b=zYWAixXwjDLNsWkPsxwYHCwaJXcbQ/fM/AV4tyCO8jMgSiMySrs25voDToqac55f+X
         eY8QmqBEs837n22ZpNqfdVJkIIOJFxGhqg7oO74Zw3FkXPGDFAzVUgSkLpIw/n9XTZkd
         FKrJRELYL1jYUpS+AXb9iglMUzGmaKlt8bu3wkIngl3sdTHIrjIEh3i8BN0Jzi5nudZR
         /NzUBroaPW4+1SXEOFxPlluDvyZS32fiMOZ2sKWIFT469I6iNSRNlqNJ2Fhrno3HpAMG
         cZzDQasTuyJ3YLqheuj2txiYkShpEWmbHpKCK6rQZko6ywz58IBwXGeOnkLxr721wptF
         hfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BuvOmgloso2e5NXgsHUei7ptWD2NT1t6KV+3QRSZobI=;
        b=mLLwwbr4Hh9DYq2frNxrHpghYFtBSayKIE9aoHULrJNnyWTohcKVb//L9+I7LBkZDx
         SqaMfB5AJH5XhKu1tOeUDpMqyZTMjTwfpj8SWrUJ8M5uLH/CWnl6BDYN5Fz8AhuQ2MQF
         1Xy/hNYN60jX8D7YJsl9OURmFpHKij5sq50RrjOWLqTbZNtg5jo0rJLnu+fBEWyHEmo9
         C+0+p32KAhGu5vFMvhLD0uVngb0U1n9UsZDNXqRP6IZ/Og1bP0jP0StBbAjAoU/egwe0
         HEq4ZXb6/UHqRbjkQjI10izMFY1GR7JV83CtxpO+YpyJEG3mGG2QEbnNJx+zg0qVwiBi
         5juA==
X-Gm-Message-State: ANoB5pnJu+TDjqYskWOWKLhCilJMlm552Lun+KwvuIJkgUSHCXOpONTM
        r9KXiDT5S+nU2vM5ugh8YQBscg==
X-Google-Smtp-Source: AA0mqf43lrvqoVp9kw/H2TDq+nbYIW8SaiNj0yMyvD09B1QPt4yyMI9jDe29obq2nfKAPcYMH8R43w==
X-Received: by 2002:a17:906:4ec3:b0:7c1:5169:3ed6 with SMTP id i3-20020a1709064ec300b007c151693ed6mr22045996ejv.48.1671228471882;
        Fri, 16 Dec 2022 14:07:51 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id va15-20020a17090711cf00b007c0dacbe00bsm1289082ejb.115.2022.12.16.14.07.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Dec 2022 14:07:51 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 2/2] sysemu/kvm: Reduce target-specific declarations
Date:   Fri, 16 Dec 2022 23:07:38 +0100
Message-Id: <20221216220738.7355-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221216220738.7355-1-philmd@linaro.org>
References: <20221216220738.7355-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only the declarations using the target_ulong type are
target specific.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index c8281c07a7..a53d6dab49 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -242,9 +242,6 @@ bool kvm_arm_supports_user_irq(void);
 int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 int kvm_on_sigbus(int code, void *addr);
 
-#ifdef NEED_CPU_H
-#include "cpu.h"
-
 void kvm_flush_coalesced_mmio_buffer(void);
 
 /**
@@ -410,6 +407,9 @@ void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
 struct kvm_guest_debug;
 struct kvm_debug_exit_arch;
 
+#ifdef NEED_CPU_H
+#include "cpu.h"
+
 struct kvm_sw_breakpoint {
     target_ulong pc;
     target_ulong saved_insn;
@@ -436,6 +436,15 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg);
 
 bool kvm_arch_stop_on_emulation_error(CPUState *cpu);
 
+uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
+                                      uint32_t index, int reg);
+uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
+
+int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
+                                       hwaddr *phys_addr);
+
+#endif /* NEED_CPU_H */
+
 int kvm_check_extension(KVMState *s, unsigned int extension);
 
 int kvm_vm_check_extension(KVMState *s, unsigned int extension);
@@ -464,18 +473,8 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension);
         kvm_vcpu_ioctl(cpu, KVM_ENABLE_CAP, &cap);                   \
     })
 
-uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
-                                      uint32_t index, int reg);
-uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
-
-
 void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len);
 
-int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
-                                       hwaddr *phys_addr);
-
-#endif /* NEED_CPU_H */
-
 void kvm_cpu_synchronize_state(CPUState *cpu);
 
 void kvm_init_cpu_signals(CPUState *cpu);
-- 
2.38.1

