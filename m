Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2872EE89C
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbhAGW1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbhAGW1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:40 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA5CC0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:59 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id r7so7121091wrc.5
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IPfFbY95vXiM+Tou5uRQMz9PmcLmcEc8idssuy0S44U=;
        b=s41E+Qhw5gaxMXS7QGjYjLRDk7HkX7vCDXovF1mBtvspQMWGigcagkiK0pEtEAXm40
         gzuhvV8LTyiRT8FC8oof61G6AOllmntzrWf89LZmHTfmIovsiGXCjGPBNP2HjpS6goXm
         o7jHufyOF26hK8Zn9KCbnnqjP2pFbg7dgLoHfJb9kRmTyt3A9pWYi/V0gWwVv/kJV0U6
         R4PpQsLHl2/17tkpEos5ao6vvR6uY7rNKFgvAyEu6u2q0xz3BsGukDua255ziaLgnWtQ
         /KvupxsMPE80xcP5xTr0VHyGNnWmopA0cEGuNdfrHZ9lMMyNltxL2pvoKXm/p0Bv93+V
         ZD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=IPfFbY95vXiM+Tou5uRQMz9PmcLmcEc8idssuy0S44U=;
        b=meqArphSNlVjWpIMnhDUv3pBIP3FeY0UuQEevgd7n2JnRVs4Nm39Jb78RFHHY3q2y+
         BhmAfWBPDqnmFyRt0FZRDxORriGzc8M2ye8E+1MkilEtN2Szt6CXTdh2XSdT5NnZ/DZU
         maPxjG4DVBNVigmMkkHBqBDXoSG/AqeF0Nl2qduHXX6UnsjgOi9rndiNyrVEKgbWeTf5
         J/IaAtYGL28QFeZQhc/41sdgWOzzcS2lHa/swQn8u2fRI06yaxEpXbubT6DyXYE+Dky6
         1lLCXZrkDDn+6Py33Sc7r3wT0Dab1ClHBNo2AwzT37tD9YBzHUI1AdxHootXixG0LySE
         b2/Q==
X-Gm-Message-State: AOAM533IFOAe0XY/LBHiRRtb3cZ7bHkQEFO1xVxwTEsETeptNfpoJrOQ
        nXbgrg/u3g8dP3LeSWL7hLY=
X-Google-Smtp-Source: ABdhPJxG0QUdwh9oqsDEqXDNua8PP9H4dfyzGB2jT3+TjfP3F+O9xKBbRHhuk2m9lYMD5rSVvIYO2w==
X-Received: by 2002:adf:9cca:: with SMTP id h10mr673793wre.77.1610058418113;
        Thu, 07 Jan 2021 14:26:58 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id c7sm11519364wro.16.2021.01.07.14.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:57 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 47/66] target/mips: Extract MSA helpers from op_helper.c
Date:   Thu,  7 Jan 2021 23:22:34 +0100
Message-Id: <20210107222253.20382-48-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have ~400 lines of MSA helpers in the generic op_helper.c,
move them with the other helpers in 'msa_helper.c'.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201123204448.3260804-5-f4bug@amsat.org>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 target/mips/msa_helper.c | 393 ++++++++++++++++++++++++++++++++++++++
 target/mips/op_helper.c  | 394 ---------------------------------------
 2 files changed, 393 insertions(+), 394 deletions(-)

diff --git a/target/mips/msa_helper.c b/target/mips/msa_helper.c
index f0d728c03f0..1298a1917ce 100644
--- a/target/mips/msa_helper.c
+++ b/target/mips/msa_helper.c
@@ -22,6 +22,7 @@
 #include "internal.h"
 #include "exec/exec-all.h"
 #include "exec/helper-proto.h"
+#include "exec/memop.h"
 #include "fpu/softfloat.h"
 #include "fpu_helper.h"
 
@@ -8202,6 +8203,398 @@ void helper_msa_ffint_u_df(CPUMIPSState *env, uint32_t df, uint32_t wd,
     msa_move_v(pwd, pwx);
 }
 
+/* Data format min and max values */
+#define DF_BITS(df) (1 << ((df) + 3))
+
+/* Element-by-element access macros */
+#define DF_ELEMENTS(df) (MSA_WRLEN / DF_BITS(df))
+
+#if !defined(CONFIG_USER_ONLY)
+#define MEMOP_IDX(DF)                                           \
+        TCGMemOpIdx oi = make_memop_idx(MO_TE | DF | MO_UNALN,  \
+                                        cpu_mmu_index(env, false));
+#else
+#define MEMOP_IDX(DF)
+#endif
+
+void helper_msa_ld_b(CPUMIPSState *env, uint32_t wd,
+                     target_ulong addr)
+{
+    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
+    MEMOP_IDX(DF_BYTE)
+#if !defined(CONFIG_USER_ONLY)
+#if !defined(HOST_WORDS_BIGENDIAN)
+    pwd->b[0]  = helper_ret_ldub_mmu(env, addr + (0  << DF_BYTE), oi, GETPC());
+    pwd->b[1]  = helper_ret_ldub_mmu(env, addr + (1  << DF_BYTE), oi, GETPC());
+    pwd->b[2]  = helper_ret_ldub_mmu(env, addr + (2  << DF_BYTE), oi, GETPC());
+    pwd->b[3]  = helper_ret_ldub_mmu(env, addr + (3  << DF_BYTE), oi, GETPC());
+    pwd->b[4]  = helper_ret_ldub_mmu(env, addr + (4  << DF_BYTE), oi, GETPC());
+    pwd->b[5]  = helper_ret_ldub_mmu(env, addr + (5  << DF_BYTE), oi, GETPC());
+    pwd->b[6]  = helper_ret_ldub_mmu(env, addr + (6  << DF_BYTE), oi, GETPC());
+    pwd->b[7]  = helper_ret_ldub_mmu(env, addr + (7  << DF_BYTE), oi, GETPC());
+    pwd->b[8]  = helper_ret_ldub_mmu(env, addr + (8  << DF_BYTE), oi, GETPC());
+    pwd->b[9]  = helper_ret_ldub_mmu(env, addr + (9  << DF_BYTE), oi, GETPC());
+    pwd->b[10] = helper_ret_ldub_mmu(env, addr + (10 << DF_BYTE), oi, GETPC());
+    pwd->b[11] = helper_ret_ldub_mmu(env, addr + (11 << DF_BYTE), oi, GETPC());
+    pwd->b[12] = helper_ret_ldub_mmu(env, addr + (12 << DF_BYTE), oi, GETPC());
+    pwd->b[13] = helper_ret_ldub_mmu(env, addr + (13 << DF_BYTE), oi, GETPC());
+    pwd->b[14] = helper_ret_ldub_mmu(env, addr + (14 << DF_BYTE), oi, GETPC());
+    pwd->b[15] = helper_ret_ldub_mmu(env, addr + (15 << DF_BYTE), oi, GETPC());
+#else
+    pwd->b[0]  = helper_ret_ldub_mmu(env, addr + (7  << DF_BYTE), oi, GETPC());
+    pwd->b[1]  = helper_ret_ldub_mmu(env, addr + (6  << DF_BYTE), oi, GETPC());
+    pwd->b[2]  = helper_ret_ldub_mmu(env, addr + (5  << DF_BYTE), oi, GETPC());
+    pwd->b[3]  = helper_ret_ldub_mmu(env, addr + (4  << DF_BYTE), oi, GETPC());
+    pwd->b[4]  = helper_ret_ldub_mmu(env, addr + (3  << DF_BYTE), oi, GETPC());
+    pwd->b[5]  = helper_ret_ldub_mmu(env, addr + (2  << DF_BYTE), oi, GETPC());
+    pwd->b[6]  = helper_ret_ldub_mmu(env, addr + (1  << DF_BYTE), oi, GETPC());
+    pwd->b[7]  = helper_ret_ldub_mmu(env, addr + (0  << DF_BYTE), oi, GETPC());
+    pwd->b[8]  = helper_ret_ldub_mmu(env, addr + (15 << DF_BYTE), oi, GETPC());
+    pwd->b[9]  = helper_ret_ldub_mmu(env, addr + (14 << DF_BYTE), oi, GETPC());
+    pwd->b[10] = helper_ret_ldub_mmu(env, addr + (13 << DF_BYTE), oi, GETPC());
+    pwd->b[11] = helper_ret_ldub_mmu(env, addr + (12 << DF_BYTE), oi, GETPC());
+    pwd->b[12] = helper_ret_ldub_mmu(env, addr + (11 << DF_BYTE), oi, GETPC());
+    pwd->b[13] = helper_ret_ldub_mmu(env, addr + (10 << DF_BYTE), oi, GETPC());
+    pwd->b[14] = helper_ret_ldub_mmu(env, addr + (9  << DF_BYTE), oi, GETPC());
+    pwd->b[15] = helper_ret_ldub_mmu(env, addr + (8  << DF_BYTE), oi, GETPC());
+#endif
+#else
+#if !defined(HOST_WORDS_BIGENDIAN)
+    pwd->b[0]  = cpu_ldub_data(env, addr + (0  << DF_BYTE));
+    pwd->b[1]  = cpu_ldub_data(env, addr + (1  << DF_BYTE));
+    pwd->b[2]  = cpu_ldub_data(env, addr + (2  << DF_BYTE));
+    pwd->b[3]  = cpu_ldub_data(env, addr + (3  << DF_BYTE));
+    pwd->b[4]  = cpu_ldub_data(env, addr + (4  << DF_BYTE));
+    pwd->b[5]  = cpu_ldub_data(env, addr + (5  << DF_BYTE));
+    pwd->b[6]  = cpu_ldub_data(env, addr + (6  << DF_BYTE));
+    pwd->b[7]  = cpu_ldub_data(env, addr + (7  << DF_BYTE));
+    pwd->b[8]  = cpu_ldub_data(env, addr + (8  << DF_BYTE));
+    pwd->b[9]  = cpu_ldub_data(env, addr + (9  << DF_BYTE));
+    pwd->b[10] = cpu_ldub_data(env, addr + (10 << DF_BYTE));
+    pwd->b[11] = cpu_ldub_data(env, addr + (11 << DF_BYTE));
+    pwd->b[12] = cpu_ldub_data(env, addr + (12 << DF_BYTE));
+    pwd->b[13] = cpu_ldub_data(env, addr + (13 << DF_BYTE));
+    pwd->b[14] = cpu_ldub_data(env, addr + (14 << DF_BYTE));
+    pwd->b[15] = cpu_ldub_data(env, addr + (15 << DF_BYTE));
+#else
+    pwd->b[0]  = cpu_ldub_data(env, addr + (7  << DF_BYTE));
+    pwd->b[1]  = cpu_ldub_data(env, addr + (6  << DF_BYTE));
+    pwd->b[2]  = cpu_ldub_data(env, addr + (5  << DF_BYTE));
+    pwd->b[3]  = cpu_ldub_data(env, addr + (4  << DF_BYTE));
+    pwd->b[4]  = cpu_ldub_data(env, addr + (3  << DF_BYTE));
+    pwd->b[5]  = cpu_ldub_data(env, addr + (2  << DF_BYTE));
+    pwd->b[6]  = cpu_ldub_data(env, addr + (1  << DF_BYTE));
+    pwd->b[7]  = cpu_ldub_data(env, addr + (0  << DF_BYTE));
+    pwd->b[8]  = cpu_ldub_data(env, addr + (15 << DF_BYTE));
+    pwd->b[9]  = cpu_ldub_data(env, addr + (14 << DF_BYTE));
+    pwd->b[10] = cpu_ldub_data(env, addr + (13 << DF_BYTE));
+    pwd->b[11] = cpu_ldub_data(env, addr + (12 << DF_BYTE));
+    pwd->b[12] = cpu_ldub_data(env, addr + (11 << DF_BYTE));
+    pwd->b[13] = cpu_ldub_data(env, addr + (10 << DF_BYTE));
+    pwd->b[14] = cpu_ldub_data(env, addr + (9 << DF_BYTE));
+    pwd->b[15] = cpu_ldub_data(env, addr + (8 << DF_BYTE));
+#endif
+#endif
+}
+
+void helper_msa_ld_h(CPUMIPSState *env, uint32_t wd,
+                     target_ulong addr)
+{
+    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
+    MEMOP_IDX(DF_HALF)
+#if !defined(CONFIG_USER_ONLY)
+#if !defined(HOST_WORDS_BIGENDIAN)
+    pwd->h[0] = helper_ret_lduw_mmu(env, addr + (0 << DF_HALF), oi, GETPC());
+    pwd->h[1] = helper_ret_lduw_mmu(env, addr + (1 << DF_HALF), oi, GETPC());
+    pwd->h[2] = helper_ret_lduw_mmu(env, addr + (2 << DF_HALF), oi, GETPC());
+    pwd->h[3] = helper_ret_lduw_mmu(env, addr + (3 << DF_HALF), oi, GETPC());
+    pwd->h[4] = helper_ret_lduw_mmu(env, addr + (4 << DF_HALF), oi, GETPC());
+    pwd->h[5] = helper_ret_lduw_mmu(env, addr + (5 << DF_HALF), oi, GETPC());
+    pwd->h[6] = helper_ret_lduw_mmu(env, addr + (6 << DF_HALF), oi, GETPC());
+    pwd->h[7] = helper_ret_lduw_mmu(env, addr + (7 << DF_HALF), oi, GETPC());
+#else
+    pwd->h[0] = helper_ret_lduw_mmu(env, addr + (3 << DF_HALF), oi, GETPC());
+    pwd->h[1] = helper_ret_lduw_mmu(env, addr + (2 << DF_HALF), oi, GETPC());
+    pwd->h[2] = helper_ret_lduw_mmu(env, addr + (1 << DF_HALF), oi, GETPC());
+    pwd->h[3] = helper_ret_lduw_mmu(env, addr + (0 << DF_HALF), oi, GETPC());
+    pwd->h[4] = helper_ret_lduw_mmu(env, addr + (7 << DF_HALF), oi, GETPC());
+    pwd->h[5] = helper_ret_lduw_mmu(env, addr + (6 << DF_HALF), oi, GETPC());
+    pwd->h[6] = helper_ret_lduw_mmu(env, addr + (5 << DF_HALF), oi, GETPC());
+    pwd->h[7] = helper_ret_lduw_mmu(env, addr + (4 << DF_HALF), oi, GETPC());
+#endif
+#else
+#if !defined(HOST_WORDS_BIGENDIAN)
+    pwd->h[0] = cpu_lduw_data(env, addr + (0 << DF_HALF));
+    pwd->h[1] = cpu_lduw_data(env, addr + (1 << DF_HALF));
+    pwd->h[2] = cpu_lduw_data(env, addr + (2 << DF_HALF));
+    pwd->h[3] = cpu_lduw_data(env, addr + (3 << DF_HALF));
+    pwd->h[4] = cpu_lduw_data(env, addr + (4 << DF_HALF));
+    pwd->h[5] = cpu_lduw_data(env, addr + (5 << DF_HALF));
+    pwd->h[6] = cpu_lduw_data(env, addr + (6 << DF_HALF));
+    pwd->h[7] = cpu_lduw_data(env, addr + (7 << DF_HALF));
+#else
+    pwd->h[0] = cpu_lduw_data(env, addr + (3 << DF_HALF));
+    pwd->h[1] = cpu_lduw_data(env, addr + (2 << DF_HALF));
+    pwd->h[2] = cpu_lduw_data(env, addr + (1 << DF_HALF));
+    pwd->h[3] = cpu_lduw_data(env, addr + (0 << DF_HALF));
+    pwd->h[4] = cpu_lduw_data(env, addr + (7 << DF_HALF));
+    pwd->h[5] = cpu_lduw_data(env, addr + (6 << DF_HALF));
+    pwd->h[6] = cpu_lduw_data(env, addr + (5 << DF_HALF));
+    pwd->h[7] = cpu_lduw_data(env, addr + (4 << DF_HALF));
+#endif
+#endif
+}
+
+void helper_msa_ld_w(CPUMIPSState *env, uint32_t wd,
+                     target_ulong addr)
+{
+    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
+    MEMOP_IDX(DF_WORD)
+#if !defined(CONFIG_USER_ONLY)
+#if !defined(HOST_WORDS_BIGENDIAN)
+    pwd->w[0] = helper_ret_ldul_mmu(env, addr + (0 << DF_WORD), oi, GETPC());
+    pwd->w[1] = helper_ret_ldul_mmu(env, addr + (1 << DF_WORD), oi, GETPC());
+    pwd->w[2] = helper_ret_ldul_mmu(env, addr + (2 << DF_WORD), oi, GETPC());
+    pwd->w[3] = helper_ret_ldul_mmu(env, addr + (3 << DF_WORD), oi, GETPC());
+#else
+    pwd->w[0] = helper_ret_ldul_mmu(env, addr + (1 << DF_WORD), oi, GETPC());
+    pwd->w[1] = helper_ret_ldul_mmu(env, addr + (0 << DF_WORD), oi, GETPC());
+    pwd->w[2] = helper_ret_ldul_mmu(env, addr + (3 << DF_WORD), oi, GETPC());
+    pwd->w[3] = helper_ret_ldul_mmu(env, addr + (2 << DF_WORD), oi, GETPC());
+#endif
+#else
+#if !defined(HOST_WORDS_BIGENDIAN)
+    pwd->w[0] = cpu_ldl_data(env, addr + (0 << DF_WORD));
+    pwd->w[1] = cpu_ldl_data(env, addr + (1 << DF_WORD));
+    pwd->w[2] = cpu_ldl_data(env, addr + (2 << DF_WORD));
+    pwd->w[3] = cpu_ldl_data(env, addr + (3 << DF_WORD));
+#else
+    pwd->w[0] = cpu_ldl_data(env, addr + (1 << DF_WORD));
+    pwd->w[1] = cpu_ldl_data(env, addr + (0 << DF_WORD));
+    pwd->w[2] = cpu_ldl_data(env, addr + (3 << DF_WORD));
+    pwd->w[3] = cpu_ldl_data(env, addr + (2 << DF_WORD));
+#endif
+#endif
+}
+
+void helper_msa_ld_d(CPUMIPSState *env, uint32_t wd,
+                     target_ulong addr)
+{
+    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
+    MEMOP_IDX(DF_DOUBLE)
+#if !defined(CONFIG_USER_ONLY)
+    pwd->d[0] = helper_ret_ldq_mmu(env, addr + (0 << DF_DOUBLE), oi, GETPC());
+    pwd->d[1] = helper_ret_ldq_mmu(env, addr + (1 << DF_DOUBLE), oi, GETPC());
+#else
+    pwd->d[0] = cpu_ldq_data(env, addr + (0 << DF_DOUBLE));
+    pwd->d[1] = cpu_ldq_data(env, addr + (1 << DF_DOUBLE));
+#endif
+}
+
+#define MSA_PAGESPAN(x) \
+        ((((x) & ~TARGET_PAGE_MASK) + MSA_WRLEN / 8 - 1) >= TARGET_PAGE_SIZE)
+
+static inline void ensure_writable_pages(CPUMIPSState *env,
+                                         target_ulong addr,
+                                         int mmu_idx,
+                                         uintptr_t retaddr)
+{
+    /* FIXME: Probe the actual accesses (pass and use a size) */
+    if (unlikely(MSA_PAGESPAN(addr))) {
+        /* first page */
+        probe_write(env, addr, 0, mmu_idx, retaddr);
+        /* second page */
+        addr = (addr & TARGET_PAGE_MASK) + TARGET_PAGE_SIZE;
+        probe_write(env, addr, 0, mmu_idx, retaddr);
+    }
+}
+
+void helper_msa_st_b(CPUMIPSState *env, uint32_t wd,
+                     target_ulong addr)
+{
+    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
+    int mmu_idx = cpu_mmu_index(env, false);
+
+    MEMOP_IDX(DF_BYTE)
+    ensure_writable_pages(env, addr, mmu_idx, GETPC());
+#if !defined(CONFIG_USER_ONLY)
+#if !defined(HOST_WORDS_BIGENDIAN)
+    helper_ret_stb_mmu(env, addr + (0  << DF_BYTE), pwd->b[0],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (1  << DF_BYTE), pwd->b[1],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (2  << DF_BYTE), pwd->b[2],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (3  << DF_BYTE), pwd->b[3],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (4  << DF_BYTE), pwd->b[4],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (5  << DF_BYTE), pwd->b[5],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (6  << DF_BYTE), pwd->b[6],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (7  << DF_BYTE), pwd->b[7],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (8  << DF_BYTE), pwd->b[8],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (9  << DF_BYTE), pwd->b[9],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (10 << DF_BYTE), pwd->b[10], oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (11 << DF_BYTE), pwd->b[11], oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (12 << DF_BYTE), pwd->b[12], oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (13 << DF_BYTE), pwd->b[13], oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (14 << DF_BYTE), pwd->b[14], oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (15 << DF_BYTE), pwd->b[15], oi, GETPC());
+#else
+    helper_ret_stb_mmu(env, addr + (7  << DF_BYTE), pwd->b[0],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (6  << DF_BYTE), pwd->b[1],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (5  << DF_BYTE), pwd->b[2],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (4  << DF_BYTE), pwd->b[3],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (3  << DF_BYTE), pwd->b[4],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (2  << DF_BYTE), pwd->b[5],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (1  << DF_BYTE), pwd->b[6],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (0  << DF_BYTE), pwd->b[7],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (15 << DF_BYTE), pwd->b[8],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (14 << DF_BYTE), pwd->b[9],  oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (13 << DF_BYTE), pwd->b[10], oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (12 << DF_BYTE), pwd->b[11], oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (11 << DF_BYTE), pwd->b[12], oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (10 << DF_BYTE), pwd->b[13], oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (9  << DF_BYTE), pwd->b[14], oi, GETPC());
+    helper_ret_stb_mmu(env, addr + (8  << DF_BYTE), pwd->b[15], oi, GETPC());
+#endif
+#else
+#if !defined(HOST_WORDS_BIGENDIAN)
+    cpu_stb_data(env, addr + (0  << DF_BYTE), pwd->b[0]);
+    cpu_stb_data(env, addr + (1  << DF_BYTE), pwd->b[1]);
+    cpu_stb_data(env, addr + (2  << DF_BYTE), pwd->b[2]);
+    cpu_stb_data(env, addr + (3  << DF_BYTE), pwd->b[3]);
+    cpu_stb_data(env, addr + (4  << DF_BYTE), pwd->b[4]);
+    cpu_stb_data(env, addr + (5  << DF_BYTE), pwd->b[5]);
+    cpu_stb_data(env, addr + (6  << DF_BYTE), pwd->b[6]);
+    cpu_stb_data(env, addr + (7  << DF_BYTE), pwd->b[7]);
+    cpu_stb_data(env, addr + (8  << DF_BYTE), pwd->b[8]);
+    cpu_stb_data(env, addr + (9  << DF_BYTE), pwd->b[9]);
+    cpu_stb_data(env, addr + (10 << DF_BYTE), pwd->b[10]);
+    cpu_stb_data(env, addr + (11 << DF_BYTE), pwd->b[11]);
+    cpu_stb_data(env, addr + (12 << DF_BYTE), pwd->b[12]);
+    cpu_stb_data(env, addr + (13 << DF_BYTE), pwd->b[13]);
+    cpu_stb_data(env, addr + (14 << DF_BYTE), pwd->b[14]);
+    cpu_stb_data(env, addr + (15 << DF_BYTE), pwd->b[15]);
+#else
+    cpu_stb_data(env, addr + (7  << DF_BYTE), pwd->b[0]);
+    cpu_stb_data(env, addr + (6  << DF_BYTE), pwd->b[1]);
+    cpu_stb_data(env, addr + (5  << DF_BYTE), pwd->b[2]);
+    cpu_stb_data(env, addr + (4  << DF_BYTE), pwd->b[3]);
+    cpu_stb_data(env, addr + (3  << DF_BYTE), pwd->b[4]);
+    cpu_stb_data(env, addr + (2  << DF_BYTE), pwd->b[5]);
+    cpu_stb_data(env, addr + (1  << DF_BYTE), pwd->b[6]);
+    cpu_stb_data(env, addr + (0  << DF_BYTE), pwd->b[7]);
+    cpu_stb_data(env, addr + (15 << DF_BYTE), pwd->b[8]);
+    cpu_stb_data(env, addr + (14 << DF_BYTE), pwd->b[9]);
+    cpu_stb_data(env, addr + (13 << DF_BYTE), pwd->b[10]);
+    cpu_stb_data(env, addr + (12 << DF_BYTE), pwd->b[11]);
+    cpu_stb_data(env, addr + (11 << DF_BYTE), pwd->b[12]);
+    cpu_stb_data(env, addr + (10 << DF_BYTE), pwd->b[13]);
+    cpu_stb_data(env, addr + (9  << DF_BYTE), pwd->b[14]);
+    cpu_stb_data(env, addr + (8  << DF_BYTE), pwd->b[15]);
+#endif
+#endif
+}
+
+void helper_msa_st_h(CPUMIPSState *env, uint32_t wd,
+                     target_ulong addr)
+{
+    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
+    int mmu_idx = cpu_mmu_index(env, false);
+
+    MEMOP_IDX(DF_HALF)
+    ensure_writable_pages(env, addr, mmu_idx, GETPC());
+#if !defined(CONFIG_USER_ONLY)
+#if !defined(HOST_WORDS_BIGENDIAN)
+    helper_ret_stw_mmu(env, addr + (0 << DF_HALF), pwd->h[0], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (1 << DF_HALF), pwd->h[1], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (2 << DF_HALF), pwd->h[2], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (3 << DF_HALF), pwd->h[3], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (4 << DF_HALF), pwd->h[4], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (5 << DF_HALF), pwd->h[5], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (6 << DF_HALF), pwd->h[6], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (7 << DF_HALF), pwd->h[7], oi, GETPC());
+#else
+    helper_ret_stw_mmu(env, addr + (3 << DF_HALF), pwd->h[0], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (2 << DF_HALF), pwd->h[1], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (1 << DF_HALF), pwd->h[2], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (0 << DF_HALF), pwd->h[3], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (7 << DF_HALF), pwd->h[4], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (6 << DF_HALF), pwd->h[5], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (5 << DF_HALF), pwd->h[6], oi, GETPC());
+    helper_ret_stw_mmu(env, addr + (4 << DF_HALF), pwd->h[7], oi, GETPC());
+#endif
+#else
+#if !defined(HOST_WORDS_BIGENDIAN)
+    cpu_stw_data(env, addr + (0 << DF_HALF), pwd->h[0]);
+    cpu_stw_data(env, addr + (1 << DF_HALF), pwd->h[1]);
+    cpu_stw_data(env, addr + (2 << DF_HALF), pwd->h[2]);
+    cpu_stw_data(env, addr + (3 << DF_HALF), pwd->h[3]);
+    cpu_stw_data(env, addr + (4 << DF_HALF), pwd->h[4]);
+    cpu_stw_data(env, addr + (5 << DF_HALF), pwd->h[5]);
+    cpu_stw_data(env, addr + (6 << DF_HALF), pwd->h[6]);
+    cpu_stw_data(env, addr + (7 << DF_HALF), pwd->h[7]);
+#else
+    cpu_stw_data(env, addr + (3 << DF_HALF), pwd->h[0]);
+    cpu_stw_data(env, addr + (2 << DF_HALF), pwd->h[1]);
+    cpu_stw_data(env, addr + (1 << DF_HALF), pwd->h[2]);
+    cpu_stw_data(env, addr + (0 << DF_HALF), pwd->h[3]);
+    cpu_stw_data(env, addr + (7 << DF_HALF), pwd->h[4]);
+    cpu_stw_data(env, addr + (6 << DF_HALF), pwd->h[5]);
+    cpu_stw_data(env, addr + (5 << DF_HALF), pwd->h[6]);
+    cpu_stw_data(env, addr + (4 << DF_HALF), pwd->h[7]);
+#endif
+#endif
+}
+
+void helper_msa_st_w(CPUMIPSState *env, uint32_t wd,
+                     target_ulong addr)
+{
+    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
+    int mmu_idx = cpu_mmu_index(env, false);
+
+    MEMOP_IDX(DF_WORD)
+    ensure_writable_pages(env, addr, mmu_idx, GETPC());
+#if !defined(CONFIG_USER_ONLY)
+#if !defined(HOST_WORDS_BIGENDIAN)
+    helper_ret_stl_mmu(env, addr + (0 << DF_WORD), pwd->w[0], oi, GETPC());
+    helper_ret_stl_mmu(env, addr + (1 << DF_WORD), pwd->w[1], oi, GETPC());
+    helper_ret_stl_mmu(env, addr + (2 << DF_WORD), pwd->w[2], oi, GETPC());
+    helper_ret_stl_mmu(env, addr + (3 << DF_WORD), pwd->w[3], oi, GETPC());
+#else
+    helper_ret_stl_mmu(env, addr + (1 << DF_WORD), pwd->w[0], oi, GETPC());
+    helper_ret_stl_mmu(env, addr + (0 << DF_WORD), pwd->w[1], oi, GETPC());
+    helper_ret_stl_mmu(env, addr + (3 << DF_WORD), pwd->w[2], oi, GETPC());
+    helper_ret_stl_mmu(env, addr + (2 << DF_WORD), pwd->w[3], oi, GETPC());
+#endif
+#else
+#if !defined(HOST_WORDS_BIGENDIAN)
+    cpu_stl_data(env, addr + (0 << DF_WORD), pwd->w[0]);
+    cpu_stl_data(env, addr + (1 << DF_WORD), pwd->w[1]);
+    cpu_stl_data(env, addr + (2 << DF_WORD), pwd->w[2]);
+    cpu_stl_data(env, addr + (3 << DF_WORD), pwd->w[3]);
+#else
+    cpu_stl_data(env, addr + (1 << DF_WORD), pwd->w[0]);
+    cpu_stl_data(env, addr + (0 << DF_WORD), pwd->w[1]);
+    cpu_stl_data(env, addr + (3 << DF_WORD), pwd->w[2]);
+    cpu_stl_data(env, addr + (2 << DF_WORD), pwd->w[3]);
+#endif
+#endif
+}
+
+void helper_msa_st_d(CPUMIPSState *env, uint32_t wd,
+                     target_ulong addr)
+{
+    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
+    int mmu_idx = cpu_mmu_index(env, false);
+
+    MEMOP_IDX(DF_DOUBLE)
+    ensure_writable_pages(env, addr, mmu_idx, GETPC());
+#if !defined(CONFIG_USER_ONLY)
+    helper_ret_stq_mmu(env, addr + (0 << DF_DOUBLE), pwd->d[0], oi, GETPC());
+    helper_ret_stq_mmu(env, addr + (1 << DF_DOUBLE), pwd->d[1], oi, GETPC());
+#else
+    cpu_stq_data(env, addr + (0 << DF_DOUBLE), pwd->d[0]);
+    cpu_stq_data(env, addr + (1 << DF_DOUBLE), pwd->d[1]);
+#endif
+}
+
 void msa_reset(CPUMIPSState *env)
 {
     if (!ase_msa_available(env)) {
diff --git a/target/mips/op_helper.c b/target/mips/op_helper.c
index 3386b8228e9..89c7d4556a0 100644
--- a/target/mips/op_helper.c
+++ b/target/mips/op_helper.c
@@ -1173,400 +1173,6 @@ void mips_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
 }
 #endif /* !CONFIG_USER_ONLY */
 
-
-/* MSA */
-/* Data format min and max values */
-#define DF_BITS(df) (1 << ((df) + 3))
-
-/* Element-by-element access macros */
-#define DF_ELEMENTS(df) (MSA_WRLEN / DF_BITS(df))
-
-#if !defined(CONFIG_USER_ONLY)
-#define MEMOP_IDX(DF)                                           \
-        TCGMemOpIdx oi = make_memop_idx(MO_TE | DF | MO_UNALN,  \
-                                        cpu_mmu_index(env, false));
-#else
-#define MEMOP_IDX(DF)
-#endif
-
-void helper_msa_ld_b(CPUMIPSState *env, uint32_t wd,
-                     target_ulong addr)
-{
-    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
-    MEMOP_IDX(DF_BYTE)
-#if !defined(CONFIG_USER_ONLY)
-#if !defined(HOST_WORDS_BIGENDIAN)
-    pwd->b[0]  = helper_ret_ldub_mmu(env, addr + (0  << DF_BYTE), oi, GETPC());
-    pwd->b[1]  = helper_ret_ldub_mmu(env, addr + (1  << DF_BYTE), oi, GETPC());
-    pwd->b[2]  = helper_ret_ldub_mmu(env, addr + (2  << DF_BYTE), oi, GETPC());
-    pwd->b[3]  = helper_ret_ldub_mmu(env, addr + (3  << DF_BYTE), oi, GETPC());
-    pwd->b[4]  = helper_ret_ldub_mmu(env, addr + (4  << DF_BYTE), oi, GETPC());
-    pwd->b[5]  = helper_ret_ldub_mmu(env, addr + (5  << DF_BYTE), oi, GETPC());
-    pwd->b[6]  = helper_ret_ldub_mmu(env, addr + (6  << DF_BYTE), oi, GETPC());
-    pwd->b[7]  = helper_ret_ldub_mmu(env, addr + (7  << DF_BYTE), oi, GETPC());
-    pwd->b[8]  = helper_ret_ldub_mmu(env, addr + (8  << DF_BYTE), oi, GETPC());
-    pwd->b[9]  = helper_ret_ldub_mmu(env, addr + (9  << DF_BYTE), oi, GETPC());
-    pwd->b[10] = helper_ret_ldub_mmu(env, addr + (10 << DF_BYTE), oi, GETPC());
-    pwd->b[11] = helper_ret_ldub_mmu(env, addr + (11 << DF_BYTE), oi, GETPC());
-    pwd->b[12] = helper_ret_ldub_mmu(env, addr + (12 << DF_BYTE), oi, GETPC());
-    pwd->b[13] = helper_ret_ldub_mmu(env, addr + (13 << DF_BYTE), oi, GETPC());
-    pwd->b[14] = helper_ret_ldub_mmu(env, addr + (14 << DF_BYTE), oi, GETPC());
-    pwd->b[15] = helper_ret_ldub_mmu(env, addr + (15 << DF_BYTE), oi, GETPC());
-#else
-    pwd->b[0]  = helper_ret_ldub_mmu(env, addr + (7  << DF_BYTE), oi, GETPC());
-    pwd->b[1]  = helper_ret_ldub_mmu(env, addr + (6  << DF_BYTE), oi, GETPC());
-    pwd->b[2]  = helper_ret_ldub_mmu(env, addr + (5  << DF_BYTE), oi, GETPC());
-    pwd->b[3]  = helper_ret_ldub_mmu(env, addr + (4  << DF_BYTE), oi, GETPC());
-    pwd->b[4]  = helper_ret_ldub_mmu(env, addr + (3  << DF_BYTE), oi, GETPC());
-    pwd->b[5]  = helper_ret_ldub_mmu(env, addr + (2  << DF_BYTE), oi, GETPC());
-    pwd->b[6]  = helper_ret_ldub_mmu(env, addr + (1  << DF_BYTE), oi, GETPC());
-    pwd->b[7]  = helper_ret_ldub_mmu(env, addr + (0  << DF_BYTE), oi, GETPC());
-    pwd->b[8]  = helper_ret_ldub_mmu(env, addr + (15 << DF_BYTE), oi, GETPC());
-    pwd->b[9]  = helper_ret_ldub_mmu(env, addr + (14 << DF_BYTE), oi, GETPC());
-    pwd->b[10] = helper_ret_ldub_mmu(env, addr + (13 << DF_BYTE), oi, GETPC());
-    pwd->b[11] = helper_ret_ldub_mmu(env, addr + (12 << DF_BYTE), oi, GETPC());
-    pwd->b[12] = helper_ret_ldub_mmu(env, addr + (11 << DF_BYTE), oi, GETPC());
-    pwd->b[13] = helper_ret_ldub_mmu(env, addr + (10 << DF_BYTE), oi, GETPC());
-    pwd->b[14] = helper_ret_ldub_mmu(env, addr + (9  << DF_BYTE), oi, GETPC());
-    pwd->b[15] = helper_ret_ldub_mmu(env, addr + (8  << DF_BYTE), oi, GETPC());
-#endif
-#else
-#if !defined(HOST_WORDS_BIGENDIAN)
-    pwd->b[0]  = cpu_ldub_data(env, addr + (0  << DF_BYTE));
-    pwd->b[1]  = cpu_ldub_data(env, addr + (1  << DF_BYTE));
-    pwd->b[2]  = cpu_ldub_data(env, addr + (2  << DF_BYTE));
-    pwd->b[3]  = cpu_ldub_data(env, addr + (3  << DF_BYTE));
-    pwd->b[4]  = cpu_ldub_data(env, addr + (4  << DF_BYTE));
-    pwd->b[5]  = cpu_ldub_data(env, addr + (5  << DF_BYTE));
-    pwd->b[6]  = cpu_ldub_data(env, addr + (6  << DF_BYTE));
-    pwd->b[7]  = cpu_ldub_data(env, addr + (7  << DF_BYTE));
-    pwd->b[8]  = cpu_ldub_data(env, addr + (8  << DF_BYTE));
-    pwd->b[9]  = cpu_ldub_data(env, addr + (9  << DF_BYTE));
-    pwd->b[10] = cpu_ldub_data(env, addr + (10 << DF_BYTE));
-    pwd->b[11] = cpu_ldub_data(env, addr + (11 << DF_BYTE));
-    pwd->b[12] = cpu_ldub_data(env, addr + (12 << DF_BYTE));
-    pwd->b[13] = cpu_ldub_data(env, addr + (13 << DF_BYTE));
-    pwd->b[14] = cpu_ldub_data(env, addr + (14 << DF_BYTE));
-    pwd->b[15] = cpu_ldub_data(env, addr + (15 << DF_BYTE));
-#else
-    pwd->b[0]  = cpu_ldub_data(env, addr + (7  << DF_BYTE));
-    pwd->b[1]  = cpu_ldub_data(env, addr + (6  << DF_BYTE));
-    pwd->b[2]  = cpu_ldub_data(env, addr + (5  << DF_BYTE));
-    pwd->b[3]  = cpu_ldub_data(env, addr + (4  << DF_BYTE));
-    pwd->b[4]  = cpu_ldub_data(env, addr + (3  << DF_BYTE));
-    pwd->b[5]  = cpu_ldub_data(env, addr + (2  << DF_BYTE));
-    pwd->b[6]  = cpu_ldub_data(env, addr + (1  << DF_BYTE));
-    pwd->b[7]  = cpu_ldub_data(env, addr + (0  << DF_BYTE));
-    pwd->b[8]  = cpu_ldub_data(env, addr + (15 << DF_BYTE));
-    pwd->b[9]  = cpu_ldub_data(env, addr + (14 << DF_BYTE));
-    pwd->b[10] = cpu_ldub_data(env, addr + (13 << DF_BYTE));
-    pwd->b[11] = cpu_ldub_data(env, addr + (12 << DF_BYTE));
-    pwd->b[12] = cpu_ldub_data(env, addr + (11 << DF_BYTE));
-    pwd->b[13] = cpu_ldub_data(env, addr + (10 << DF_BYTE));
-    pwd->b[14] = cpu_ldub_data(env, addr + (9 << DF_BYTE));
-    pwd->b[15] = cpu_ldub_data(env, addr + (8 << DF_BYTE));
-#endif
-#endif
-}
-
-void helper_msa_ld_h(CPUMIPSState *env, uint32_t wd,
-                     target_ulong addr)
-{
-    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
-    MEMOP_IDX(DF_HALF)
-#if !defined(CONFIG_USER_ONLY)
-#if !defined(HOST_WORDS_BIGENDIAN)
-    pwd->h[0] = helper_ret_lduw_mmu(env, addr + (0 << DF_HALF), oi, GETPC());
-    pwd->h[1] = helper_ret_lduw_mmu(env, addr + (1 << DF_HALF), oi, GETPC());
-    pwd->h[2] = helper_ret_lduw_mmu(env, addr + (2 << DF_HALF), oi, GETPC());
-    pwd->h[3] = helper_ret_lduw_mmu(env, addr + (3 << DF_HALF), oi, GETPC());
-    pwd->h[4] = helper_ret_lduw_mmu(env, addr + (4 << DF_HALF), oi, GETPC());
-    pwd->h[5] = helper_ret_lduw_mmu(env, addr + (5 << DF_HALF), oi, GETPC());
-    pwd->h[6] = helper_ret_lduw_mmu(env, addr + (6 << DF_HALF), oi, GETPC());
-    pwd->h[7] = helper_ret_lduw_mmu(env, addr + (7 << DF_HALF), oi, GETPC());
-#else
-    pwd->h[0] = helper_ret_lduw_mmu(env, addr + (3 << DF_HALF), oi, GETPC());
-    pwd->h[1] = helper_ret_lduw_mmu(env, addr + (2 << DF_HALF), oi, GETPC());
-    pwd->h[2] = helper_ret_lduw_mmu(env, addr + (1 << DF_HALF), oi, GETPC());
-    pwd->h[3] = helper_ret_lduw_mmu(env, addr + (0 << DF_HALF), oi, GETPC());
-    pwd->h[4] = helper_ret_lduw_mmu(env, addr + (7 << DF_HALF), oi, GETPC());
-    pwd->h[5] = helper_ret_lduw_mmu(env, addr + (6 << DF_HALF), oi, GETPC());
-    pwd->h[6] = helper_ret_lduw_mmu(env, addr + (5 << DF_HALF), oi, GETPC());
-    pwd->h[7] = helper_ret_lduw_mmu(env, addr + (4 << DF_HALF), oi, GETPC());
-#endif
-#else
-#if !defined(HOST_WORDS_BIGENDIAN)
-    pwd->h[0] = cpu_lduw_data(env, addr + (0 << DF_HALF));
-    pwd->h[1] = cpu_lduw_data(env, addr + (1 << DF_HALF));
-    pwd->h[2] = cpu_lduw_data(env, addr + (2 << DF_HALF));
-    pwd->h[3] = cpu_lduw_data(env, addr + (3 << DF_HALF));
-    pwd->h[4] = cpu_lduw_data(env, addr + (4 << DF_HALF));
-    pwd->h[5] = cpu_lduw_data(env, addr + (5 << DF_HALF));
-    pwd->h[6] = cpu_lduw_data(env, addr + (6 << DF_HALF));
-    pwd->h[7] = cpu_lduw_data(env, addr + (7 << DF_HALF));
-#else
-    pwd->h[0] = cpu_lduw_data(env, addr + (3 << DF_HALF));
-    pwd->h[1] = cpu_lduw_data(env, addr + (2 << DF_HALF));
-    pwd->h[2] = cpu_lduw_data(env, addr + (1 << DF_HALF));
-    pwd->h[3] = cpu_lduw_data(env, addr + (0 << DF_HALF));
-    pwd->h[4] = cpu_lduw_data(env, addr + (7 << DF_HALF));
-    pwd->h[5] = cpu_lduw_data(env, addr + (6 << DF_HALF));
-    pwd->h[6] = cpu_lduw_data(env, addr + (5 << DF_HALF));
-    pwd->h[7] = cpu_lduw_data(env, addr + (4 << DF_HALF));
-#endif
-#endif
-}
-
-void helper_msa_ld_w(CPUMIPSState *env, uint32_t wd,
-                     target_ulong addr)
-{
-    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
-    MEMOP_IDX(DF_WORD)
-#if !defined(CONFIG_USER_ONLY)
-#if !defined(HOST_WORDS_BIGENDIAN)
-    pwd->w[0] = helper_ret_ldul_mmu(env, addr + (0 << DF_WORD), oi, GETPC());
-    pwd->w[1] = helper_ret_ldul_mmu(env, addr + (1 << DF_WORD), oi, GETPC());
-    pwd->w[2] = helper_ret_ldul_mmu(env, addr + (2 << DF_WORD), oi, GETPC());
-    pwd->w[3] = helper_ret_ldul_mmu(env, addr + (3 << DF_WORD), oi, GETPC());
-#else
-    pwd->w[0] = helper_ret_ldul_mmu(env, addr + (1 << DF_WORD), oi, GETPC());
-    pwd->w[1] = helper_ret_ldul_mmu(env, addr + (0 << DF_WORD), oi, GETPC());
-    pwd->w[2] = helper_ret_ldul_mmu(env, addr + (3 << DF_WORD), oi, GETPC());
-    pwd->w[3] = helper_ret_ldul_mmu(env, addr + (2 << DF_WORD), oi, GETPC());
-#endif
-#else
-#if !defined(HOST_WORDS_BIGENDIAN)
-    pwd->w[0] = cpu_ldl_data(env, addr + (0 << DF_WORD));
-    pwd->w[1] = cpu_ldl_data(env, addr + (1 << DF_WORD));
-    pwd->w[2] = cpu_ldl_data(env, addr + (2 << DF_WORD));
-    pwd->w[3] = cpu_ldl_data(env, addr + (3 << DF_WORD));
-#else
-    pwd->w[0] = cpu_ldl_data(env, addr + (1 << DF_WORD));
-    pwd->w[1] = cpu_ldl_data(env, addr + (0 << DF_WORD));
-    pwd->w[2] = cpu_ldl_data(env, addr + (3 << DF_WORD));
-    pwd->w[3] = cpu_ldl_data(env, addr + (2 << DF_WORD));
-#endif
-#endif
-}
-
-void helper_msa_ld_d(CPUMIPSState *env, uint32_t wd,
-                     target_ulong addr)
-{
-    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
-    MEMOP_IDX(DF_DOUBLE)
-#if !defined(CONFIG_USER_ONLY)
-    pwd->d[0] = helper_ret_ldq_mmu(env, addr + (0 << DF_DOUBLE), oi, GETPC());
-    pwd->d[1] = helper_ret_ldq_mmu(env, addr + (1 << DF_DOUBLE), oi, GETPC());
-#else
-    pwd->d[0] = cpu_ldq_data(env, addr + (0 << DF_DOUBLE));
-    pwd->d[1] = cpu_ldq_data(env, addr + (1 << DF_DOUBLE));
-#endif
-}
-
-#define MSA_PAGESPAN(x) \
-        ((((x) & ~TARGET_PAGE_MASK) + MSA_WRLEN / 8 - 1) >= TARGET_PAGE_SIZE)
-
-static inline void ensure_writable_pages(CPUMIPSState *env,
-                                         target_ulong addr,
-                                         int mmu_idx,
-                                         uintptr_t retaddr)
-{
-    /* FIXME: Probe the actual accesses (pass and use a size) */
-    if (unlikely(MSA_PAGESPAN(addr))) {
-        /* first page */
-        probe_write(env, addr, 0, mmu_idx, retaddr);
-        /* second page */
-        addr = (addr & TARGET_PAGE_MASK) + TARGET_PAGE_SIZE;
-        probe_write(env, addr, 0, mmu_idx, retaddr);
-    }
-}
-
-void helper_msa_st_b(CPUMIPSState *env, uint32_t wd,
-                     target_ulong addr)
-{
-    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
-    int mmu_idx = cpu_mmu_index(env, false);
-
-    MEMOP_IDX(DF_BYTE)
-    ensure_writable_pages(env, addr, mmu_idx, GETPC());
-#if !defined(CONFIG_USER_ONLY)
-#if !defined(HOST_WORDS_BIGENDIAN)
-    helper_ret_stb_mmu(env, addr + (0  << DF_BYTE), pwd->b[0],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (1  << DF_BYTE), pwd->b[1],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (2  << DF_BYTE), pwd->b[2],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (3  << DF_BYTE), pwd->b[3],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (4  << DF_BYTE), pwd->b[4],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (5  << DF_BYTE), pwd->b[5],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (6  << DF_BYTE), pwd->b[6],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (7  << DF_BYTE), pwd->b[7],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (8  << DF_BYTE), pwd->b[8],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (9  << DF_BYTE), pwd->b[9],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (10 << DF_BYTE), pwd->b[10], oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (11 << DF_BYTE), pwd->b[11], oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (12 << DF_BYTE), pwd->b[12], oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (13 << DF_BYTE), pwd->b[13], oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (14 << DF_BYTE), pwd->b[14], oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (15 << DF_BYTE), pwd->b[15], oi, GETPC());
-#else
-    helper_ret_stb_mmu(env, addr + (7  << DF_BYTE), pwd->b[0],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (6  << DF_BYTE), pwd->b[1],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (5  << DF_BYTE), pwd->b[2],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (4  << DF_BYTE), pwd->b[3],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (3  << DF_BYTE), pwd->b[4],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (2  << DF_BYTE), pwd->b[5],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (1  << DF_BYTE), pwd->b[6],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (0  << DF_BYTE), pwd->b[7],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (15 << DF_BYTE), pwd->b[8],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (14 << DF_BYTE), pwd->b[9],  oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (13 << DF_BYTE), pwd->b[10], oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (12 << DF_BYTE), pwd->b[11], oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (11 << DF_BYTE), pwd->b[12], oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (10 << DF_BYTE), pwd->b[13], oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (9  << DF_BYTE), pwd->b[14], oi, GETPC());
-    helper_ret_stb_mmu(env, addr + (8  << DF_BYTE), pwd->b[15], oi, GETPC());
-#endif
-#else
-#if !defined(HOST_WORDS_BIGENDIAN)
-    cpu_stb_data(env, addr + (0  << DF_BYTE), pwd->b[0]);
-    cpu_stb_data(env, addr + (1  << DF_BYTE), pwd->b[1]);
-    cpu_stb_data(env, addr + (2  << DF_BYTE), pwd->b[2]);
-    cpu_stb_data(env, addr + (3  << DF_BYTE), pwd->b[3]);
-    cpu_stb_data(env, addr + (4  << DF_BYTE), pwd->b[4]);
-    cpu_stb_data(env, addr + (5  << DF_BYTE), pwd->b[5]);
-    cpu_stb_data(env, addr + (6  << DF_BYTE), pwd->b[6]);
-    cpu_stb_data(env, addr + (7  << DF_BYTE), pwd->b[7]);
-    cpu_stb_data(env, addr + (8  << DF_BYTE), pwd->b[8]);
-    cpu_stb_data(env, addr + (9  << DF_BYTE), pwd->b[9]);
-    cpu_stb_data(env, addr + (10 << DF_BYTE), pwd->b[10]);
-    cpu_stb_data(env, addr + (11 << DF_BYTE), pwd->b[11]);
-    cpu_stb_data(env, addr + (12 << DF_BYTE), pwd->b[12]);
-    cpu_stb_data(env, addr + (13 << DF_BYTE), pwd->b[13]);
-    cpu_stb_data(env, addr + (14 << DF_BYTE), pwd->b[14]);
-    cpu_stb_data(env, addr + (15 << DF_BYTE), pwd->b[15]);
-#else
-    cpu_stb_data(env, addr + (7  << DF_BYTE), pwd->b[0]);
-    cpu_stb_data(env, addr + (6  << DF_BYTE), pwd->b[1]);
-    cpu_stb_data(env, addr + (5  << DF_BYTE), pwd->b[2]);
-    cpu_stb_data(env, addr + (4  << DF_BYTE), pwd->b[3]);
-    cpu_stb_data(env, addr + (3  << DF_BYTE), pwd->b[4]);
-    cpu_stb_data(env, addr + (2  << DF_BYTE), pwd->b[5]);
-    cpu_stb_data(env, addr + (1  << DF_BYTE), pwd->b[6]);
-    cpu_stb_data(env, addr + (0  << DF_BYTE), pwd->b[7]);
-    cpu_stb_data(env, addr + (15 << DF_BYTE), pwd->b[8]);
-    cpu_stb_data(env, addr + (14 << DF_BYTE), pwd->b[9]);
-    cpu_stb_data(env, addr + (13 << DF_BYTE), pwd->b[10]);
-    cpu_stb_data(env, addr + (12 << DF_BYTE), pwd->b[11]);
-    cpu_stb_data(env, addr + (11 << DF_BYTE), pwd->b[12]);
-    cpu_stb_data(env, addr + (10 << DF_BYTE), pwd->b[13]);
-    cpu_stb_data(env, addr + (9  << DF_BYTE), pwd->b[14]);
-    cpu_stb_data(env, addr + (8  << DF_BYTE), pwd->b[15]);
-#endif
-#endif
-}
-
-void helper_msa_st_h(CPUMIPSState *env, uint32_t wd,
-                     target_ulong addr)
-{
-    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
-    int mmu_idx = cpu_mmu_index(env, false);
-
-    MEMOP_IDX(DF_HALF)
-    ensure_writable_pages(env, addr, mmu_idx, GETPC());
-#if !defined(CONFIG_USER_ONLY)
-#if !defined(HOST_WORDS_BIGENDIAN)
-    helper_ret_stw_mmu(env, addr + (0 << DF_HALF), pwd->h[0], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (1 << DF_HALF), pwd->h[1], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (2 << DF_HALF), pwd->h[2], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (3 << DF_HALF), pwd->h[3], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (4 << DF_HALF), pwd->h[4], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (5 << DF_HALF), pwd->h[5], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (6 << DF_HALF), pwd->h[6], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (7 << DF_HALF), pwd->h[7], oi, GETPC());
-#else
-    helper_ret_stw_mmu(env, addr + (3 << DF_HALF), pwd->h[0], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (2 << DF_HALF), pwd->h[1], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (1 << DF_HALF), pwd->h[2], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (0 << DF_HALF), pwd->h[3], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (7 << DF_HALF), pwd->h[4], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (6 << DF_HALF), pwd->h[5], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (5 << DF_HALF), pwd->h[6], oi, GETPC());
-    helper_ret_stw_mmu(env, addr + (4 << DF_HALF), pwd->h[7], oi, GETPC());
-#endif
-#else
-#if !defined(HOST_WORDS_BIGENDIAN)
-    cpu_stw_data(env, addr + (0 << DF_HALF), pwd->h[0]);
-    cpu_stw_data(env, addr + (1 << DF_HALF), pwd->h[1]);
-    cpu_stw_data(env, addr + (2 << DF_HALF), pwd->h[2]);
-    cpu_stw_data(env, addr + (3 << DF_HALF), pwd->h[3]);
-    cpu_stw_data(env, addr + (4 << DF_HALF), pwd->h[4]);
-    cpu_stw_data(env, addr + (5 << DF_HALF), pwd->h[5]);
-    cpu_stw_data(env, addr + (6 << DF_HALF), pwd->h[6]);
-    cpu_stw_data(env, addr + (7 << DF_HALF), pwd->h[7]);
-#else
-    cpu_stw_data(env, addr + (3 << DF_HALF), pwd->h[0]);
-    cpu_stw_data(env, addr + (2 << DF_HALF), pwd->h[1]);
-    cpu_stw_data(env, addr + (1 << DF_HALF), pwd->h[2]);
-    cpu_stw_data(env, addr + (0 << DF_HALF), pwd->h[3]);
-    cpu_stw_data(env, addr + (7 << DF_HALF), pwd->h[4]);
-    cpu_stw_data(env, addr + (6 << DF_HALF), pwd->h[5]);
-    cpu_stw_data(env, addr + (5 << DF_HALF), pwd->h[6]);
-    cpu_stw_data(env, addr + (4 << DF_HALF), pwd->h[7]);
-#endif
-#endif
-}
-
-void helper_msa_st_w(CPUMIPSState *env, uint32_t wd,
-                     target_ulong addr)
-{
-    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
-    int mmu_idx = cpu_mmu_index(env, false);
-
-    MEMOP_IDX(DF_WORD)
-    ensure_writable_pages(env, addr, mmu_idx, GETPC());
-#if !defined(CONFIG_USER_ONLY)
-#if !defined(HOST_WORDS_BIGENDIAN)
-    helper_ret_stl_mmu(env, addr + (0 << DF_WORD), pwd->w[0], oi, GETPC());
-    helper_ret_stl_mmu(env, addr + (1 << DF_WORD), pwd->w[1], oi, GETPC());
-    helper_ret_stl_mmu(env, addr + (2 << DF_WORD), pwd->w[2], oi, GETPC());
-    helper_ret_stl_mmu(env, addr + (3 << DF_WORD), pwd->w[3], oi, GETPC());
-#else
-    helper_ret_stl_mmu(env, addr + (1 << DF_WORD), pwd->w[0], oi, GETPC());
-    helper_ret_stl_mmu(env, addr + (0 << DF_WORD), pwd->w[1], oi, GETPC());
-    helper_ret_stl_mmu(env, addr + (3 << DF_WORD), pwd->w[2], oi, GETPC());
-    helper_ret_stl_mmu(env, addr + (2 << DF_WORD), pwd->w[3], oi, GETPC());
-#endif
-#else
-#if !defined(HOST_WORDS_BIGENDIAN)
-    cpu_stl_data(env, addr + (0 << DF_WORD), pwd->w[0]);
-    cpu_stl_data(env, addr + (1 << DF_WORD), pwd->w[1]);
-    cpu_stl_data(env, addr + (2 << DF_WORD), pwd->w[2]);
-    cpu_stl_data(env, addr + (3 << DF_WORD), pwd->w[3]);
-#else
-    cpu_stl_data(env, addr + (1 << DF_WORD), pwd->w[0]);
-    cpu_stl_data(env, addr + (0 << DF_WORD), pwd->w[1]);
-    cpu_stl_data(env, addr + (3 << DF_WORD), pwd->w[2]);
-    cpu_stl_data(env, addr + (2 << DF_WORD), pwd->w[3]);
-#endif
-#endif
-}
-
-void helper_msa_st_d(CPUMIPSState *env, uint32_t wd,
-                     target_ulong addr)
-{
-    wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
-    int mmu_idx = cpu_mmu_index(env, false);
-
-    MEMOP_IDX(DF_DOUBLE)
-    ensure_writable_pages(env, addr, mmu_idx, GETPC());
-#if !defined(CONFIG_USER_ONLY)
-    helper_ret_stq_mmu(env, addr + (0 << DF_DOUBLE), pwd->d[0], oi, GETPC());
-    helper_ret_stq_mmu(env, addr + (1 << DF_DOUBLE), pwd->d[1], oi, GETPC());
-#else
-    cpu_stq_data(env, addr + (0 << DF_DOUBLE), pwd->d[0]);
-    cpu_stq_data(env, addr + (1 << DF_DOUBLE), pwd->d[1]);
-#endif
-}
-
 void helper_cache(CPUMIPSState *env, target_ulong addr, uint32_t op)
 {
 #ifndef CONFIG_USER_ONLY
-- 
2.26.2

