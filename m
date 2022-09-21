Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5805E557B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiIUVvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiIUVv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:51:29 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D1BA6C5F
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:51:27 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e67so1130728pgc.12
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=BcNo2HJQOFnOqNPiwxnv6r4+Z8Ly3SmsmsS2gAGqanY=;
        b=w7t6YRuzWQMa5xOtYlb27TT04BAQ8WJF6wuzxe1JKInLzPtVUJCvTLdb071xceM/nK
         HVyo62Vu5+pbxkbM7+qBfTrgL+UOJhJTIJMJKhxExoBQebXVfvuvU9qbwMcgXPXOSFPq
         cT/OhuxKodtlLhMVnwAu8ZRTLcSZrq9YP7K6GWn2y30vFEkoBdDOlinhNfmIhgFN7bko
         WSSZQ0l84zui0GuU3z4m6XKS4COw17SqsrSegAyp2IknDnCsGeChNFzDDvS1IeWgnAfl
         LpwVjFFikrELoL5fu2ypEA3hrOrpWGD43XaX0UAaV+baTJG4vOufOctmIBWRwBniQ5oV
         5njQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=BcNo2HJQOFnOqNPiwxnv6r4+Z8Ly3SmsmsS2gAGqanY=;
        b=Vry5Aj/zGq88RD3HrxwJAxOI3Ar1QbXEDmPW0BEiLulnw2BSfDhao5KdImksGSqyDP
         DWON9QGG5gvlCKxsCIKQM6xB/JB6N89MMz5OKRhBhsgrFCDvqvTkEtRNLvTACHXemhYC
         VAQ1rkmYQkCTetj8idjjafpRyn5BfzZyhJvhycQEJp/xYvYWy86xgi0wVYJ+s2EnyMHo
         QnNPKWNok8qeYyI1TcI0QSLjOPJuXG3JC2YwyGyef4tkdaig5A5CrkyAg4/G9fmV7E5U
         OxmNWykmtckLXQ4M5pxiNZ4j+l+DmyhMK/LZOF3IUpY5wzzDTORhLJkDibjsTm3H1jSc
         42og==
X-Gm-Message-State: ACrzQf1KmceXpQqz4Fo3eGxqPcDq/544Gq26Kcc0Qf+5v2kfLIO7dTE+
        Tn5t4AVsql7rReXuVhRvOxIhYQ==
X-Google-Smtp-Source: AMsMyM6TNzO2Xhw6rScUWI5ahGUQwwcwx+Bjr8U+Im0AkbHv8qzx+BpYtUZ/oCIrkw7glfUdD/Z6zw==
X-Received: by 2002:a05:6a00:b8d:b0:545:e7de:78e5 with SMTP id g13-20020a056a000b8d00b00545e7de78e5mr347622pfj.72.1663797086513;
        Wed, 21 Sep 2022 14:51:26 -0700 (PDT)
Received: from stillson.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id k7-20020aa79727000000b005484d133127sm2634536pfg.129.2022.09.21.14.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:51:25 -0700 (PDT)
From:   Chris Stillson <stillson@rivosinc.com>
Cc:     Greentime Hu <greentime.hu@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Guo Ren <guoren@kernel.org>,
        Chris Stillson <stillson@rivosinc.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jisheng Zhang <jszhang@kernel.org>,
        Dao Lu <daolu@rivosinc.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Nick Knight <nick.knight@sifive.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Changbin Du <changbin.du@intel.com>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Yury Norov <yury.norov@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Colin Cross <ccross@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Barret Rhoden <brho@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [PATCH v12 10/17] riscv: Add sigcontext save/restore for vector
Date:   Wed, 21 Sep 2022 14:43:52 -0700
Message-Id: <20220921214439.1491510-10-stillson@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921214439.1491510-1-stillson@rivosinc.com>
References: <20220921214439.1491510-1-stillson@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

This patch adds sigcontext save/restore for vector. The vector registers
will be saved in datap pointer. The datap pointer will be allocated
dynamically when the task needs in kernel space. The datap pointer will
be set right after the __riscv_v_state data structure to save all the
vector registers in the signal handler stack.

Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
---
 arch/riscv/include/uapi/asm/sigcontext.h |  24 ++++
 arch/riscv/kernel/asm-offsets.c          |   2 +
 arch/riscv/kernel/signal.c               | 165 ++++++++++++++++++++++-
 3 files changed, 187 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/sigcontext.h b/arch/riscv/include/uapi/asm/sigcontext.h
index 84f2dfcfdbce..b8a0fd7d7cfc 100644
--- a/arch/riscv/include/uapi/asm/sigcontext.h
+++ b/arch/riscv/include/uapi/asm/sigcontext.h
@@ -8,6 +8,23 @@
 
 #include <asm/ptrace.h>
 
+/* The Magic number for signal context frame header. */
+#define RVV_MAGIC	0x53465457
+#define END_MAGIC	0x0
+
+/* The size of END signal context header. */
+#define END_HDR_SIZE	0x0
+
+struct __riscv_ctx_hdr {
+	__u32 magic;
+	__u32 size;
+};
+
+struct __sc_riscv_v_state {
+	struct __riscv_ctx_hdr head;
+	struct __riscv_v_state v_state;
+} __attribute__((aligned(16)));
+
 /*
  * Signal context structure
  *
@@ -17,6 +34,13 @@
 struct sigcontext {
 	struct user_regs_struct sc_regs;
 	union __riscv_fp_state sc_fpregs;
+	/*
+	 * 4K + 128 reserved for vector state and future expansion.
+	 * This space is enough to store the vector context whose VLENB
+	 * is less or equal to 128.
+	 * (The size of the vector context is 4144 byte as VLENB is 128)
+	 */
+	__u8 __reserved[4224] __attribute__((__aligned__(16)));
 };
 
 #endif /* _UAPI_ASM_RISCV_SIGCONTEXT_H */
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 37e3e6a8d877..80316ef7bb78 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -75,6 +75,8 @@ void asm_offsets(void)
 	OFFSET(TSK_STACK_CANARY, task_struct, stack_canary);
 #endif
 
+	OFFSET(RISCV_V_STATE_MAGIC, __riscv_ctx_hdr, magic);
+	OFFSET(RISCV_V_STATE_SIZE, __riscv_ctx_hdr, size);
 	OFFSET(RISCV_V_STATE_VSTART, __riscv_v_state, vstart);
 	OFFSET(RISCV_V_STATE_VL, __riscv_v_state, vl);
 	OFFSET(RISCV_V_STATE_VTYPE, __riscv_v_state, vtype);
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 38b05ca6fe66..41d9a02c7098 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -20,15 +20,16 @@
 #include <asm/csr.h>
 
 extern u32 __user_rt_sigreturn[2];
+static size_t rvv_sc_size;
 
 #define DEBUG_SIG 0
 
 struct rt_sigframe {
 	struct siginfo info;
-	struct ucontext uc;
 #ifndef CONFIG_MMU
 	u32 sigreturn_code[2];
 #endif
+	struct ucontext uc;
 };
 
 #ifdef CONFIG_FPU
@@ -85,16 +86,155 @@ static long save_fp_state(struct pt_regs *regs,
 #define restore_fp_state(task, regs) (0)
 #endif
 
+#ifdef CONFIG_VECTOR
+static long restore_v_state(struct pt_regs *regs, void **sc_reserved_ptr)
+{
+	long err;
+	struct __sc_riscv_v_state __user *state = (struct __sc_riscv_v_state *)(*sc_reserved_ptr);
+	void *datap;
+	__u32 magic;
+	__u32 size;
+
+	/* Get magic number and check it. */
+	err = __get_user(magic, &state->head.magic);
+	err = __get_user(size, &state->head.size);
+	if (unlikely(err))
+		return err;
+
+	if (magic != RVV_MAGIC || size != rvv_sc_size)
+		return -EINVAL;
+
+	/* Copy everything of __sc_riscv_v_state except datap. */
+	err = __copy_from_user(&current->thread.vstate, &state->v_state,
+			       RISCV_V_STATE_DATAP);
+	if (unlikely(err))
+		return err;
+
+	/* Copy the pointer datap itself. */
+	err = __get_user(datap, &state->v_state.datap);
+	if (unlikely(err))
+		return err;
+
+
+	/* Copy the whole vector content from user space datap. */
+	err = __copy_from_user(current->thread.vstate.datap, datap, riscv_vsize);
+	if (unlikely(err))
+		return err;
+
+	vstate_restore(current, regs);
+
+	/* Move sc_reserved_ptr to point the next signal context frame. */
+	*sc_reserved_ptr += size;
+
+	return err;
+}
+
+static long save_v_state(struct pt_regs *regs, void **sc_reserved_free_ptr)
+{
+	/*
+	 * Put __sc_riscv_v_state to the user's signal context space pointed
+	 * by sc_reserved_free_ptr and the datap point the address right
+	 * after __sc_riscv_v_state.
+	 */
+	struct __sc_riscv_v_state __user *state = (struct __sc_riscv_v_state *)
+		(*sc_reserved_free_ptr);
+	void *datap = state + 1;
+	long err;
+
+	*sc_reserved_free_ptr += rvv_sc_size;
+
+	err = __put_user(RVV_MAGIC, &state->head.magic);
+	err = __put_user(rvv_sc_size, &state->head.size);
+
+	vstate_save(current, regs);
+	/* Copy everything of vstate but datap. */
+	err = __copy_to_user(&state->v_state, &current->thread.vstate,
+			     RISCV_V_STATE_DATAP);
+	if (unlikely(err))
+		return err;
+
+	/* Copy the pointer datap itself. */
+	err = __put_user(datap, &state->v_state.datap);
+	if (unlikely(err))
+		return err;
+
+	/* Copy the whole vector content to user space datap. */
+	err = __copy_to_user(datap, current->thread.vstate.datap, riscv_vsize);
+
+	return err;
+}
+#else
+#define save_v_state(task, regs) (0)
+#define restore_v_state(task, regs) (0)
+#endif
+
 static long restore_sigcontext(struct pt_regs *regs,
 	struct sigcontext __user *sc)
 {
 	long err;
+	void *sc_reserved_ptr = sc->__reserved;
 	/* sc_regs is structured the same as the start of pt_regs */
 	err = __copy_from_user(regs, &sc->sc_regs, sizeof(sc->sc_regs));
 	/* Restore the floating-point state. */
 	if (has_fpu())
 		err |= restore_fp_state(regs, &sc->sc_fpregs);
+
+	while (1 && !err) {
+		__u32 magic, size;
+		struct __riscv_ctx_hdr *head = (struct __riscv_ctx_hdr *)sc_reserved_ptr;
+
+		err |= __get_user(magic, &head->magic);
+		err |= __get_user(size, &head->size);
+		if (err)
+			goto done;
+
+		switch (magic) {
+		case 0:
+			if (size)
+				goto invalid;
+			goto done;
+		case RVV_MAGIC:
+			if (!has_vector())
+				goto invalid;
+			if (size != rvv_sc_size)
+				goto invalid;
+			err |= restore_v_state(regs, &sc_reserved_ptr);
+			break;
+		default:
+			goto invalid;
+		}
+	}
+done:
 	return err;
+
+invalid:
+	return -EINVAL;
+}
+
+static size_t cal_rt_frame_size(void)
+{
+	struct rt_sigframe __user *frame;
+	static size_t frame_size;
+	size_t total_context_size = 0;
+	size_t sc_reserved_size = sizeof(frame->uc.uc_mcontext.__reserved);
+
+	if (frame_size)
+		goto done;
+
+	frame_size = sizeof(*frame);
+
+	if (has_vector())
+		total_context_size += rvv_sc_size;
+	/* Preserved a __riscv_ctx_hdr for END signal context header. */
+	total_context_size += sizeof(struct __riscv_ctx_hdr);
+
+	if (total_context_size > sc_reserved_size)
+		frame_size += (total_context_size - sc_reserved_size);
+
+	frame_size = round_up(frame_size, 16);
+done:
+	return frame_size;
+
 }
 
 SYSCALL_DEFINE0(rt_sigreturn)
@@ -103,13 +243,14 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	struct rt_sigframe __user *frame;
 	struct task_struct *task;
 	sigset_t set;
+	size_t frame_size = cal_rt_frame_size();
 
 	/* Always make any pending restarted system calls return -EINTR */
 	current->restart_block.fn = do_no_restart_syscall;
 
 	frame = (struct rt_sigframe __user *)regs->sp;
 
-	if (!access_ok(frame, sizeof(*frame)))
+	if (!access_ok(frame, frame_size))
 		goto badframe;
 
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
@@ -142,11 +283,20 @@ static long setup_sigcontext(struct rt_sigframe __user *frame,
 {
 	struct sigcontext __user *sc = &frame->uc.uc_mcontext;
 	long err;
+	void *sc_reserved_free_ptr = sc->__reserved;
+
 	/* sc_regs is structured the same as the start of pt_regs */
 	err = __copy_to_user(&sc->sc_regs, regs, sizeof(sc->sc_regs));
 	/* Save the floating-point state. */
 	if (has_fpu())
 		err |= save_fp_state(regs, &sc->sc_fpregs);
+	/* Save the vector state. */
+	if (has_vector())
+		err |= save_v_state(regs, &sc_reserved_free_ptr);
+
+	/* Put END __riscv_ctx_hdr at the end. */
+	err = __put_user(END_MAGIC, &((struct __riscv_ctx_hdr *)sc_reserved_free_ptr)->magic);
+	err = __put_user(END_HDR_SIZE, &((struct __riscv_ctx_hdr *)sc_reserved_free_ptr)->size);
 	return err;
 }
 
@@ -178,9 +328,10 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	struct rt_sigframe __user *frame;
 	long err = 0;
+	size_t frame_size = cal_rt_frame_size();
 
-	frame = get_sigframe(ksig, regs, sizeof(*frame));
-	if (!access_ok(frame, sizeof(*frame)))
+	frame = get_sigframe(ksig, regs, frame_size);
+	if (!access_ok(frame, frame_size))
 		return -EFAULT;
 
 	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
@@ -326,3 +477,9 @@ asmlinkage __visible void do_notify_resume(struct pt_regs *regs,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME)
 		resume_user_mode_work(regs);
 }
+
+void init_rt_signal_env(void);
+void __init init_rt_signal_env(void)
+{
+	rvv_sc_size = sizeof(struct __sc_riscv_v_state) + riscv_vsize;
+}
-- 
2.25.1

