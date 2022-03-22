Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAADB4E3E0F
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 13:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiCVMGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 08:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiCVMGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 08:06:53 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3065433BB
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 05:05:25 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v130-20020a1cac88000000b00389d0a5c511so1963062wme.5
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 05:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsogzIW20PFbxNVUsODKUNH/SwjRh3rmWCB3ikdFeq8=;
        b=LNuU/fRaR5WkXZ8+KarznGMNy6S5Sn0lf0qOij6gVQfMzGs6HWGARVSb4Fa3rpv/Ef
         wUDqxkDuoTiY7YhLRFbll+aGhgyzIZfja8j4tpidxMyHwxI4I+SH4Kh0p+J/UjxE6zbo
         sKzd5ay5ymu0E7JLzDcYT5JX6rOZYJWrSK87IsDqB6Bpx4+nl8EGc9IaJBh6O+xR+y49
         FcErGEus8P91TWOkmU5VG4RL2ZkNujDHhlcwSrfEreqte70svS9qlOaVXC6EKdMVrzcK
         S+8MwTpSnK9iTlyjNYK5xrEW2PNAxxoReIYvh1QT/0f1ngGsxaCV6An9R+1uq15pEO7T
         Zmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsogzIW20PFbxNVUsODKUNH/SwjRh3rmWCB3ikdFeq8=;
        b=uDhN9GV42ueUGa09bEhykjttGxx/UespzGDCNnQXgGKeL+XCLOtgUSuBu0KKHc6kM7
         ymF99cUQPY0ifa+IbhpgTckSnCZQmUB7GAezYcMDBOylon+jAejz5HigOkJ35a8Wk12V
         tt6K9vUz/JjdlHnVfRCYku7/SL3P+r286YPxvyrxAxFSGqUt3QsM5h9ij1M28Vh9y9tf
         ecPdBmO+6FVk7FG1+2ueJz+6nQComiSYnki4RQgompYh6l7AYHNOWVF5TS0oQBmwyhA4
         UYoLUV0Nn65zUYQJANhHSoyii9BjJ+eamITXIRKZcs2Uxn9GYmb4s8BHDp4HYl+XApwX
         ZYAA==
X-Gm-Message-State: AOAM532BhjpL+krUblxszizGN9xdAEsnq70g4ExBVFLPiCBzNu0GnaKm
        c9yA6mTTkvVRjt+fmPpRbM4VZFZ4XpY=
X-Google-Smtp-Source: ABdhPJwpGb8MYLFgQMP5JIu70aj+GrxjBxenjonIHryZ3l2jiFc0vhUI6qyrJHXnBszicHTyorRoUg==
X-Received: by 2002:a7b:c14d:0:b0:38c:801a:a8b3 with SMTP id z13-20020a7bc14d000000b0038c801aa8b3mr3352236wmi.40.1647950724424;
        Tue, 22 Mar 2022 05:05:24 -0700 (PDT)
Received: from localhost.localdomain (198.red-83-50-65.dynamicip.rima-tde.net. [83.50.65.198])
        by smtp.gmail.com with ESMTPSA id r13-20020adfbb0d000000b00203e0efdd3bsm15376668wrg.107.2022.03.22.05.05.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 22 Mar 2022 05:05:24 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Mark Kanda <mark.kanda@oracle.com>
Subject: [RFC PATCH-for-7.0 v4] target/i386/kvm: Free xsave_buf when destroying vCPU
Date:   Tue, 22 Mar 2022 13:05:22 +0100
Message-Id: <20220322120522.26200-1-philippe.mathieu.daude@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <f4bug@amsat.org>

Fix vCPU hot-unplug related leak reported by Valgrind:

  ==132362== 4,096 bytes in 1 blocks are definitely lost in loss record 8,440 of 8,549
  ==132362==    at 0x4C3B15F: memalign (vg_replace_malloc.c:1265)
  ==132362==    by 0x4C3B288: posix_memalign (vg_replace_malloc.c:1429)
  ==132362==    by 0xB41195: qemu_try_memalign (memalign.c:53)
  ==132362==    by 0xB41204: qemu_memalign (memalign.c:73)
  ==132362==    by 0x7131CB: kvm_init_xsave (kvm.c:1601)
  ==132362==    by 0x7148ED: kvm_arch_init_vcpu (kvm.c:2031)
  ==132362==    by 0x91D224: kvm_init_vcpu (kvm-all.c:516)
  ==132362==    by 0x9242C9: kvm_vcpu_thread_fn (kvm-accel-ops.c:40)
  ==132362==    by 0xB2EB26: qemu_thread_start (qemu-thread-posix.c:556)
  ==132362==    by 0x7EB2159: start_thread (in /usr/lib64/libpthread-2.28.so)
  ==132362==    by 0x9D45DD2: clone (in /usr/lib64/libc-2.28.so)

Reported-by: Mark Kanda <mark.kanda@oracle.com>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
Based on a series from Mark:
https://lore.kernel.org/qemu-devel/20220321141409.3112932-1-mark.kanda@oracle.com/

RFC because currently no time to test
---
 target/i386/kvm/kvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ef2c68a6f4..e93440e774 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2072,6 +2072,8 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
 
+    g_free(env->xsave_buf);
+
     if (cpu->kvm_msr_buf) {
         g_free(cpu->kvm_msr_buf);
         cpu->kvm_msr_buf = NULL;
-- 
2.35.1

