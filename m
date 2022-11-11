Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD26626135
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 19:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbiKKSe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 13:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiKKSe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 13:34:58 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F1F178A6
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 10:34:57 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id j15so7549921wrq.3
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 10:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjvcD/bUb6v85GBYMsY2wRda3lPUntOnEJ8cQndopVc=;
        b=j07ZcctBaiVRR4dHoUX9jCUfu4N4o7HNNO6oPYNq/GaPjeAsFFnZJfoBUGtZa7iaVC
         q7Tk8wIPIr3lqDUZ/U9GgOVskORuQJhX2zf3JXG98i1S58y29kCb7N+62SW+0myhkOtD
         QVqjnwVU8Hbe6zEOhXf/wVIJW3kZmpxtnHDeFJAvao/pPWbSHgAtY+tHi3oNMubkT0ai
         nIGN8RERXD+MGSz1CQTDUPYbIngyaiSRAHT0SucBRJNeS6/MCbvLg97iJTEbGPF27foP
         3euQevj5rwR32v2a/X8vycNPPui7dx2sG4u5N9cozpWDNekiDzJ4y1b0Ej5lURnLsFq2
         hfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KjvcD/bUb6v85GBYMsY2wRda3lPUntOnEJ8cQndopVc=;
        b=q5gywP+2rIl4+FRQxDBjUhPdFiOw365mSoiCE6EFnyvQq341dfiVBQhkuCBs/ESq/E
         fD34so5K2KXDkV3hdtuzPUWS+JArYlLYkp6ObbBBane++7vBl8NZVRKfUEcwZ+YlwfS3
         hMBcxZi1rq+vE+FPoDgJP/Eu5E80O2326hN/FYzIEE8XgG9Gvij3ulVL5EyRt3xl99kQ
         HeZkezfwfeVsI353DfCpc2yZqb83kgDJbQFMUGm+ZhI7FhnpsroTLBB1krwMl/HCCdWy
         yHrBZ7HMHCCKDEj/K/tLUh0LoC7v7oBg4i/9Cj5Gx+7J8OJslj7MPFOa5nBtVPHWFhUZ
         SsqA==
X-Gm-Message-State: ANoB5pkq/U4R4177+zh2Mx8JC9rs3t7/+D5kqCrtdXc6Vk8ctNULTf22
        JKWkk/2CSXDRl368XhvKj7jUNaIB6CVoKw==
X-Google-Smtp-Source: AA0mqf4jHdXwT+07aSV3JQymPXLBWFlFBOCfyq7XM6J/G1XScEyOZkpznnYp/Nm7WZcPlAxOogtz+A==
X-Received: by 2002:a5d:68c1:0:b0:236:84b5:c0d8 with SMTP id p1-20020a5d68c1000000b0023684b5c0d8mr2071393wrw.342.1668191695330;
        Fri, 11 Nov 2022 10:34:55 -0800 (PST)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id u17-20020a05600c4d1100b003cfb7c02542sm3505512wmp.11.2022.11.11.10.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 10:34:51 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id F38891FFB8;
        Fri, 11 Nov 2022 18:25:36 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     f4bug@amsat.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        haxm-team@intel.com (open list:X86 HAXM CPUs),
        kvm@vger.kernel.org (open list:X86 KVM CPUs)
Subject: [PATCH  v5 13/20] target/i386: add explicit initialisation for MexTxAttrs
Date:   Fri, 11 Nov 2022 18:25:28 +0000
Message-Id: <20221111182535.64844-14-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221111182535.64844-1-alex.bennee@linaro.org>
References: <20221111182535.64844-1-alex.bennee@linaro.org>
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

Where appropriate initialise with MEMTXATTRS_CPU otherwise use
MEMTXATTRS_UNSPECIFIED instead of the null initialiser.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 target/i386/cpu.h           | 4 +++-
 target/i386/hax/hax-all.c   | 2 +-
 target/i386/nvmm/nvmm-all.c | 2 +-
 target/i386/sev.c           | 2 +-
 target/i386/whpx/whpx-all.c | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d4bc19577a..04ab96b076 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2246,7 +2246,9 @@ static inline uint32_t cpu_compute_eflags(CPUX86State *env)
 
 static inline MemTxAttrs cpu_get_mem_attrs(CPUX86State *env)
 {
-    return ((MemTxAttrs) { .secure = (env->hflags & HF_SMM_MASK) != 0 });
+    MemTxAttrs attrs = MEMTXATTRS_CPU(env_cpu(env));
+    attrs.secure = (env->hflags & HF_SMM_MASK) != 0;
+    return attrs;
 }
 
 static inline int32_t x86_get_a20_mask(CPUX86State *env)
diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index b185ee8de4..337090e16f 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -385,7 +385,7 @@ static int hax_handle_io(CPUArchState *env, uint32_t df, uint16_t port,
 {
     uint8_t *ptr;
     int i;
-    MemTxAttrs attrs = { 0 };
+    MemTxAttrs attrs = MEMTXATTRS_UNSPECIFIED;
 
     if (!df) {
         ptr = (uint8_t *) buffer;
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index b75738ee9c..cb0720a6fa 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -502,7 +502,7 @@ nvmm_vcpu_post_run(CPUState *cpu, struct nvmm_vcpu_exit *exit)
 static void
 nvmm_io_callback(struct nvmm_io *io)
 {
-    MemTxAttrs attrs = { 0 };
+    MemTxAttrs attrs = MEMTXATTRS_UNSPECIFIED;
     int ret;
 
     ret = address_space_rw(&address_space_io, io->port, attrs, io->data,
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 32f7dbac4e..292cbcdd92 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1274,7 +1274,7 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     uint8_t *hashp;
     size_t hash_len = HASH_SIZE;
     hwaddr mapped_len = sizeof(*padded_ht);
-    MemTxAttrs attrs = { 0 };
+    MemTxAttrs attrs = MEMTXATTRS_UNSPECIFIED;
     bool ret = true;
 
     /*
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index e738d83e81..42846144dd 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -791,7 +791,7 @@ static HRESULT CALLBACK whpx_emu_ioport_callback(
     void *ctx,
     WHV_EMULATOR_IO_ACCESS_INFO *IoAccess)
 {
-    MemTxAttrs attrs = { 0 };
+    MemTxAttrs attrs = MEMTXATTRS_UNSPECIFIED;
     address_space_rw(&address_space_io, IoAccess->Port, attrs,
                      &IoAccess->Data, IoAccess->AccessSize,
                      IoAccess->Direction);
-- 
2.34.1

