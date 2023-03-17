Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A76C6BE867
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjCQLix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCQLiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:38:51 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9DEB7182
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:38:11 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cn6so4791904pjb.2
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679053068;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LGkZTe2LulB28qkawijLyK0EfR01doQgW0M1klk25dc=;
        b=c6WEHsafIPK2QmGy33qPthwOZ0J16Np0FKUE1+/2qTSo9juwJy1TfEbvoKVfa7bGjb
         PtcsHWBZR9hqurlYc7eqR+8yG1M3J7YuLTeBA1QwMldLSrJbXA3JiVZU361LmOZMC0Zz
         Prot3b1epS0CCNSONPvGfsTBzlWWLWl1moDgXN2Ij6SmzG/4FcuaZY8yxAlAO4eQQ7yi
         OQ4hsJIFSkfkJ2x9VpzX9XlX2P0WJx3v27ZpkobqrmIedi4y+t2BEDM7cMVXZPeK3rA/
         NKR8z0mQLRaGtTvoaLloRtszbZDg7MrUxzKrx+kJ76xXeT9DFtdXQzeYyiIclVudQjh9
         Kxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053068;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LGkZTe2LulB28qkawijLyK0EfR01doQgW0M1klk25dc=;
        b=4/9/qPO53G4fmNXP9vLLI0uYO+d517W2WsP7qWHDy14aUjM45cAMhkIEmjhO1LJZWu
         qFfKu9/sypogLq18A1704ESix0O+TldtcAK0qdCdeYdtpshWubKso3smxZcySAViK2ga
         2sw0KFP0cFTA4wyGVSBXpqX/APIHWpFhPcHBqUFr/WAS7nDAF++NePAQ+EfgIpasN24D
         RIeEWvxMoQCrN5lFM+bV+rRI1y4FfnEx1j5PbzK0bPvrYgCwGP0BiAC2xsxU9U0W/B/Q
         vpH12Ekp4yFgiBcLifELktxmWx7Li1k793lms+4MWjiqHPVqeXSc0wDuGIHNom0QOPze
         k1rg==
X-Gm-Message-State: AO0yUKX0nsTORkwe4q5G2/0ZoIXDndDLpFR1ZTu9Q0np/cSN9LY7yc7w
        hAKCXFA7g7GWuYCXuzogRpBF0g==
X-Google-Smtp-Source: AK7set+rsAE7NRf3j5TFzM76qy8V2Gww4CE2W3ZEiYitz+Hw+NnDEkHNMKgMQ+gHiipjh7SuU7b9oA==
X-Received: by 2002:a17:90b:4f81:b0:237:9cc7:28a4 with SMTP id qe1-20020a17090b4f8100b002379cc728a4mr7615208pjb.14.1679053068526;
        Fri, 17 Mar 2023 04:37:48 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:37:47 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        Zong Li <zong.li@sifive.com>,
        Nick Knight <nick.knight@sifive.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH -next v15 14/19] riscv: signal: Report signal frame size to userspace via auxv
Date:   Fri, 17 Mar 2023 11:35:33 +0000
Message-Id: <20230317113538.10878-15-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

The vector register belongs to the signal context. They need to be stored
and restored as entering and leaving the signal handler. According to the
V-extension specification, the maximum length of the vector registers can
be 2^(XLEN-1). Hence, if userspace refers to the MINSIGSTKSZ to create a
sigframe, it may not be enough. To resolve this problem, this patch refers
to the commit 94b07c1f8c39c
("arm64: signal: Report signal frame size to userspace via auxv") to enable
userspace to know the minimum required sigframe size through the auxiliary
vector and use it to allocate enough memory for signal context.

Note that auxv always reports size of the sigframe as if V exists for
all starting processes, whenever the kernel has CONFIG_RISCV_ISA_V. The
reason is that users usually reference this value to allocate an
alternative signal stack, and the user may use V anytime. So the user
must reserve a space for V-context in sigframe in case that the signal
handler invokes after the kernel allocating V.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/asm/elf.h         |  9 +++++++++
 arch/riscv/include/asm/processor.h   |  2 ++
 arch/riscv/include/uapi/asm/auxvec.h |  1 +
 arch/riscv/kernel/signal.c           | 20 +++++++++++++++-----
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
index 30e7d2455960..ca23c4f6c440 100644
--- a/arch/riscv/include/asm/elf.h
+++ b/arch/riscv/include/asm/elf.h
@@ -105,6 +105,15 @@ do {								\
 		get_cache_size(3, CACHE_TYPE_UNIFIED));		\
 	NEW_AUX_ENT(AT_L3_CACHEGEOMETRY,			\
 		get_cache_geometry(3, CACHE_TYPE_UNIFIED));	\
+	/*							 \
+	 * Should always be nonzero unless there's a kernel bug. \
+	 * If we haven't determined a sensible value to give to	 \
+	 * userspace, omit the entry:				 \
+	 */							 \
+	if (likely(signal_minsigstksz))				 \
+		NEW_AUX_ENT(AT_MINSIGSTKSZ, signal_minsigstksz); \
+	else							 \
+		NEW_AUX_ENT(AT_IGNORE, 0);			 \
 } while (0)
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index f0ddf691ac5e..38ded8c5f207 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -7,6 +7,7 @@
 #define _ASM_RISCV_PROCESSOR_H
 
 #include <linux/const.h>
+#include <linux/cache.h>
 
 #include <vdso/processor.h>
 
@@ -81,6 +82,7 @@ int riscv_of_parent_hartid(struct device_node *node, unsigned long *hartid);
 extern void riscv_fill_hwcap(void);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 
+extern unsigned long signal_minsigstksz __ro_after_init;
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_RISCV_PROCESSOR_H */
diff --git a/arch/riscv/include/uapi/asm/auxvec.h b/arch/riscv/include/uapi/asm/auxvec.h
index fb187a33ce58..10aaa83db89e 100644
--- a/arch/riscv/include/uapi/asm/auxvec.h
+++ b/arch/riscv/include/uapi/asm/auxvec.h
@@ -35,5 +35,6 @@
 
 /* entries in ARCH_DLINFO */
 #define AT_VECTOR_SIZE_ARCH	9
+#define AT_MINSIGSTKSZ		51
 
 #endif /* _UAPI_ASM_RISCV_AUXVEC_H */
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 55d2215d18ea..d2d9232498ca 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -21,6 +21,8 @@
 #include <asm/vector.h>
 #include <asm/csr.h>
 
+unsigned long signal_minsigstksz __ro_after_init;
+
 extern u32 __user_rt_sigreturn[2];
 static size_t riscv_v_sc_size __ro_after_init;
 
@@ -195,7 +197,7 @@ static long restore_sigcontext(struct pt_regs *regs,
 	return err;
 }
 
-static size_t get_rt_frame_size(void)
+static size_t get_rt_frame_size(bool cal_all)
 {
 	struct rt_sigframe __user *frame;
 	size_t frame_size;
@@ -203,8 +205,10 @@ static size_t get_rt_frame_size(void)
 
 	frame_size = sizeof(*frame);
 
-	if (has_vector() && riscv_v_vstate_query(task_pt_regs(current)))
-		total_context_size += riscv_v_sc_size;
+	if (has_vector()) {
+		if (cal_all || riscv_v_vstate_query(task_pt_regs(current)))
+			total_context_size += riscv_v_sc_size;
+	}
 	/*
 	 * Preserved a __riscv_ctx_hdr for END signal context header if an
 	 * extension uses __riscv_extra_ext_header
@@ -224,7 +228,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	struct rt_sigframe __user *frame;
 	struct task_struct *task;
 	sigset_t set;
-	size_t frame_size = get_rt_frame_size();
+	size_t frame_size = get_rt_frame_size(false);
 
 	/* Always make any pending restarted system calls return -EINTR */
 	current->restart_block.fn = do_no_restart_syscall;
@@ -320,7 +324,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	struct rt_sigframe __user *frame;
 	long err = 0;
-	size_t frame_size = get_rt_frame_size();
+	size_t frame_size = get_rt_frame_size(false);
 
 	frame = get_sigframe(ksig, regs, frame_size);
 	if (!access_ok(frame, frame_size))
@@ -483,4 +487,10 @@ void __init init_rt_signal_env(void)
 {
 	riscv_v_sc_size = sizeof(struct __riscv_ctx_hdr) +
 			  sizeof(struct __sc_riscv_v_state) + riscv_v_vsize;
+	/*
+	 * Determine the stack space required for guaranteed signal delivery.
+	 * The signal_minsigstksz will be populated into the AT_MINSIGSTKSZ entry
+	 * in the auxiliary array at process startup.
+	 */
+	signal_minsigstksz = get_rt_frame_size(true);
 }
-- 
2.17.1

