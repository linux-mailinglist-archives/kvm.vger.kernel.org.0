Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7714159A614
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 21:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350488AbiHSTG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 15:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350417AbiHSTG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 15:06:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806D610975E
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 12:06:55 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-334ab1f0247so90012177b3.7
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 12:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=Scxx2WxT5O+vs9/nBnpMEI6Jj8+LnDx00EwfheEhbiA=;
        b=D5PuOvajf3fP4Ji6yQy1evwGrkBulRcdtR37aDxGD0sb1cNhJwiGXKiBPx/qnweE6G
         0YpzGGR/FdE9QvZ3zTkZ5NTBMBr++DErASp82jaKnYuti0AAGikQU3TZQB/9UJ9iTBsW
         gQyFmOTIybhOSE82kZrWf1ttkXHekLJX0uaD9mQfrDgjvM25bS96Dhyiq1jem88qRgzu
         A/vx5N6VqqpSsDFRtSuSnATNg5A4LnW+exwimnCxcEJfN7gTtMrhq5B1sAmCP7pNqXuV
         +KGI1ZwTCQSkcWS3yx5mv5HPvbbbEGM3ipDxakrKxb7UIPVgW9Ta7AaWtclRwdfLPEBk
         ftAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=Scxx2WxT5O+vs9/nBnpMEI6Jj8+LnDx00EwfheEhbiA=;
        b=6MRWVVgAoCl58TGy6ZJbjcyiK3NvaH+gdMfsHb+6UipngEmsbytwIAyypTXx+2SuTw
         IC8lEMVOvkpwsxu4S8LHD3o2NYo6QXzazTDKzwYFhVN6mzF3O4ZcPLzx08JPwNp7mp/0
         edc+KeDkdLdcbt28wrxU7kZgkOdUyHcTJPtpmZEH7aJUVoSJBOPe1OAHnBQlru0DRci5
         xYGSzA14ZXTfptCi1v4gBDzkiYi8HSPfI1iksw6ZKpjZAmLT2AQeO0toh4KsXZAr7GA1
         mrVL1OFHpylR/vH7ClXdwD6myEQYuWaU8AyvUECrGghQP7rX7O2WgWn1V2qmVnAD7N23
         /4RQ==
X-Gm-Message-State: ACgBeo3h0WWhpCNidEOd83ORfP8BmVKgYKrnohPa85s/wS/3ZT6QzS+y
        NrDjyDwFhGz3rDNhuJnTFRFySNtYIVmT8yo4TCI=
X-Google-Smtp-Source: AA6agR5RqgJAoSg5QPgdQ/Z86BYE5Wpe9Lm5jPFGnEvkXlx218Q7krGpFTG2nbVigRefPFr9DXek6FuQIPMnFJmeG30=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:4752:6cab:cd5c:55be])
 (user=ndesaulniers job=sendgmr) by 2002:a5b:9c4:0:b0:691:7745:afb5 with SMTP
 id y4-20020a5b09c4000000b006917745afb5mr8762907ybq.57.1660936014766; Fri, 19
 Aug 2022 12:06:54 -0700 (PDT)
Date:   Fri, 19 Aug 2022 12:06:40 -0700
In-Reply-To: <CAADnVQJFc9AnH_9CW+bSRotkKvOmkO9jq-RF6dmyPYOpq691Yg@mail.gmail.com>
Message-Id: <20220819190640.2763586-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAADnVQJFc9AnH_9CW+bSRotkKvOmkO9jq-RF6dmyPYOpq691Yg@mail.gmail.com>
X-Developer-Key: i=ndesaulniers@google.com; a=ed25519; pk=lvO/pmg+aaCb6dPhyGC1GyOCvPueDrrc8Zeso5CaGKE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1660936000; l=10408;
 i=ndesaulniers@google.com; s=20211004; h=from:subject; bh=o5jtF0qgjBAwzK8hj72cqFfTQZrRKJnCZmTAHywxjks=;
 b=yCfT5EfvYho4viB2fnHbpoJCl9sDkYwrxmJgkRt2Ft3CC+gArTmwlhkq0zP3pLGVR+AMz5f88NSh
 NCZyS5vNAaADorgpPkfQrOvx1OaHgMw1UuCcCWS1XHMMO6NndUTF
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2] asm goto: eradicate CC_HAS_ASM_GOTO
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Borislav Petkov <bp@suse.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GCC has supported asm goto since 4.5, and Clang has since version 9.0.0.
The minimum supported versions of these tools for the build according to
Documentation/process/changes.rst are 5.1 and 11.0.0 respectively.

Remove the feature detection script, Kconfig option, and clean up some
fallback code that is no longer supported.

The removed script was also testing for a GCC specific bug that was
fixed in the 4.7 release.

Also remove workarounds for bpftrace using clang older than 9.0.0, since
other BPF backend fixes are required at this point.

Link: https://lore.kernel.org/lkml/CAK7LNATSr=BXKfkdW8f-H5VT_w=xBpT2ZQcZ7rm6JfkdE+QnmA@mail.gmail.com/
Link: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48637
Acked-by: Borislav Petkov <bp@suse.de>
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---

Changes v1 -> v2:
https://lore.kernel.org/linux-kbuild/20220819170053.2686006-1-ndesaulniers@google.com/
* Pick up Boris' ack.
* Drop line about Dash compat as per Alexandre.
* Drop Alexandre's reported by as per Masahiro.
* s/Kbuild/asm goto/ in oneline as per Masahiro.
* Remove entirety of bpftrace workarounds as per Alexei.
* Fix mistake in arch/x86/include/asm/rmwcc.h in v1 where I removed too
  much; we still need guards for __GCC_ASM_FLAG_OUTPUTS__.

 Documentation/kbuild/kconfig-language.rst |  4 ++--
 arch/Kconfig                              |  3 +--
 arch/um/include/asm/cpufeature.h          | 15 ---------------
 arch/x86/Makefile                         |  4 ----
 arch/x86/include/asm/cpufeature.h         | 15 ---------------
 arch/x86/include/asm/rmwcc.h              |  6 +++---
 arch/x86/kvm/emulate.c                    |  2 +-
 init/Kconfig                              |  4 ----
 scripts/gcc-goto.sh                       | 22 ----------------------
 tools/arch/x86/include/asm/rmwcc.h        | 21 ---------------------
 10 files changed, 7 insertions(+), 89 deletions(-)
 delete mode 100755 scripts/gcc-goto.sh

diff --git a/Documentation/kbuild/kconfig-language.rst b/Documentation/kbuild/kconfig-language.rst
index 7fb398649f51..858ed5d80def 100644
--- a/Documentation/kbuild/kconfig-language.rst
+++ b/Documentation/kbuild/kconfig-language.rst
@@ -525,8 +525,8 @@ followed by a test macro::
 If you need to expose a compiler capability to makefiles and/or C source files,
 `CC_HAS_` is the recommended prefix for the config option::
 
-  config CC_HAS_ASM_GOTO
-	def_bool $(success,$(srctree)/scripts/gcc-goto.sh $(CC))
+  config CC_HAS_FOO
+	def_bool $(success,$(srctree)/scripts/cc-check-foo.sh $(CC))
 
 Build as module only
 ~~~~~~~~~~~~~~~~~~~~
diff --git a/arch/Kconfig b/arch/Kconfig
index f330410da63a..5dbf11a5ba4e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -53,7 +53,6 @@ config KPROBES
 config JUMP_LABEL
 	bool "Optimize very unlikely/likely branches"
 	depends on HAVE_ARCH_JUMP_LABEL
-	depends on CC_HAS_ASM_GOTO
 	select OBJTOOL if HAVE_JUMP_LABEL_HACK
 	help
 	 This option enables a transparent branch optimization that
@@ -1361,7 +1360,7 @@ config HAVE_PREEMPT_DYNAMIC_CALL
 
 config HAVE_PREEMPT_DYNAMIC_KEY
 	bool
-	depends on HAVE_ARCH_JUMP_LABEL && CC_HAS_ASM_GOTO
+	depends on HAVE_ARCH_JUMP_LABEL
 	select HAVE_PREEMPT_DYNAMIC
 	help
 	   An architecture should select this if it can handle the preemption
diff --git a/arch/um/include/asm/cpufeature.h b/arch/um/include/asm/cpufeature.h
index 19cd7ed6ec3c..4b6d1b526bc1 100644
--- a/arch/um/include/asm/cpufeature.h
+++ b/arch/um/include/asm/cpufeature.h
@@ -65,20 +65,6 @@ extern void setup_clear_cpu_cap(unsigned int bit);
 
 #define setup_force_cpu_bug(bit) setup_force_cpu_cap(bit)
 
-#if defined(__clang__) && !defined(CONFIG_CC_HAS_ASM_GOTO)
-
-/*
- * Workaround for the sake of BPF compilation which utilizes kernel
- * headers, but clang does not support ASM GOTO and fails the build.
- */
-#ifndef __BPF_TRACING__
-#warning "Compiler lacks ASM_GOTO support. Add -D __BPF_TRACING__ to your compiler arguments"
-#endif
-
-#define static_cpu_has(bit)            boot_cpu_has(bit)
-
-#else
-
 /*
  * Static testing of CPU features. Used the same as boot_cpu_has(). It
  * statically patches the target code for additional performance. Use
@@ -137,7 +123,6 @@ static __always_inline bool _static_cpu_has(u16 bit)
 		boot_cpu_has(bit) :				\
 		_static_cpu_has(bit)				\
 )
-#endif
 
 #define cpu_has_bug(c, bit)		cpu_has(c, (bit))
 #define set_cpu_bug(c, bit)		set_cpu_cap(c, (bit))
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 7854685c5f25..bafbd905e6e7 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -286,10 +286,6 @@ vdso_install:
 
 archprepare: checkbin
 checkbin:
-ifndef CONFIG_CC_HAS_ASM_GOTO
-	@echo Compiler lacks asm-goto support.
-	@exit 1
-endif
 ifdef CONFIG_RETPOLINE
 ifeq ($(RETPOLINE_CFLAGS),)
 	@echo "You are building kernel with non-retpoline compiler." >&2
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index ea34cc31b047..1a85e1fb0922 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -155,20 +155,6 @@ extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
 
 #define setup_force_cpu_bug(bit) setup_force_cpu_cap(bit)
 
-#if defined(__clang__) && !defined(CONFIG_CC_HAS_ASM_GOTO)
-
-/*
- * Workaround for the sake of BPF compilation which utilizes kernel
- * headers, but clang does not support ASM GOTO and fails the build.
- */
-#ifndef __BPF_TRACING__
-#warning "Compiler lacks ASM_GOTO support. Add -D __BPF_TRACING__ to your compiler arguments"
-#endif
-
-#define static_cpu_has(bit)            boot_cpu_has(bit)
-
-#else
-
 /*
  * Static testing of CPU features. Used the same as boot_cpu_has(). It
  * statically patches the target code for additional performance. Use
@@ -208,7 +194,6 @@ static __always_inline bool _static_cpu_has(u16 bit)
 		boot_cpu_has(bit) :				\
 		_static_cpu_has(bit)				\
 )
-#endif
 
 #define cpu_has_bug(c, bit)		cpu_has(c, (bit))
 #define set_cpu_bug(c, bit)		set_cpu_cap(c, (bit))
diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
index 8a9eba191516..7fa611216417 100644
--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
@@ -11,7 +11,7 @@
 
 #define __CLOBBERS_MEM(clb...)	"memory", ## clb
 
-#if !defined(__GCC_ASM_FLAG_OUTPUTS__) && defined(CONFIG_CC_HAS_ASM_GOTO)
+#ifndef __GCC_ASM_FLAG_OUTPUTS__
 
 /* Use asm goto */
 
@@ -27,7 +27,7 @@ cc_label:	c = true;						\
 	c;								\
 })
 
-#else /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CONFIG_CC_HAS_ASM_GOTO) */
+#else /* defined(__GCC_ASM_FLAG_OUTPUTS__) */
 
 /* Use flags output or a set instruction */
 
@@ -40,7 +40,7 @@ cc_label:	c = true;						\
 	c;								\
 })
 
-#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CONFIG_CC_HAS_ASM_GOTO) */
+#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) */
 
 #define GEN_UNARY_RMWcc_4(op, var, cc, arg0)				\
 	__GEN_RMWcc(op " " arg0, var, cc, __CLOBBERS_MEM())
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b4eeb7c75dfa..08613c65138d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -493,7 +493,7 @@ FOP_END;
 
 /*
  * XXX: inoutclob user must know where the argument is being expanded.
- *      Relying on CONFIG_CC_HAS_ASM_GOTO would allow us to remove _fault.
+ *      Using asm goto would allow us to remove _fault.
  */
 #define asm_safe(insn, inoutclob...) \
 ({ \
diff --git a/init/Kconfig b/init/Kconfig
index 80fe60fa77fb..532362fcfe31 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -70,11 +70,7 @@ config CC_CAN_LINK_STATIC
 	default $(success,$(srctree)/scripts/cc-can-link.sh $(CC) $(CLANG_FLAGS) $(USERCFLAGS) $(USERLDFLAGS) $(m64-flag) -static) if 64BIT
 	default $(success,$(srctree)/scripts/cc-can-link.sh $(CC) $(CLANG_FLAGS) $(USERCFLAGS) $(USERLDFLAGS) $(m32-flag) -static)
 
-config CC_HAS_ASM_GOTO
-	def_bool $(success,$(srctree)/scripts/gcc-goto.sh $(CC))
-
 config CC_HAS_ASM_GOTO_OUTPUT
-	depends on CC_HAS_ASM_GOTO
 	def_bool $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
 
 config CC_HAS_ASM_GOTO_TIED_OUTPUT
diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
deleted file mode 100755
index 8b980fb2270a..000000000000
--- a/scripts/gcc-goto.sh
+++ /dev/null
@@ -1,22 +0,0 @@
-#!/bin/sh
-# SPDX-License-Identifier: GPL-2.0
-# Test for gcc 'asm goto' support
-# Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
-
-cat << "END" | $@ -x c - -fno-PIE -c -o /dev/null
-int main(void)
-{
-#if defined(__arm__) || defined(__aarch64__)
-	/*
-	 * Not related to asm goto, but used by jump label
-	 * and broken on some ARM GCC versions (see GCC Bug 48637).
-	 */
-	static struct { int dummy; int state; } tp;
-	asm (".long %c0" :: "i" (&tp.state));
-#endif
-
-entry:
-	asm goto ("" :::: entry);
-	return 0;
-}
-END
diff --git a/tools/arch/x86/include/asm/rmwcc.h b/tools/arch/x86/include/asm/rmwcc.h
index fee7983a90b4..11ff975242ca 100644
--- a/tools/arch/x86/include/asm/rmwcc.h
+++ b/tools/arch/x86/include/asm/rmwcc.h
@@ -2,8 +2,6 @@
 #ifndef _TOOLS_LINUX_ASM_X86_RMWcc
 #define _TOOLS_LINUX_ASM_X86_RMWcc
 
-#ifdef CONFIG_CC_HAS_ASM_GOTO
-
 #define __GEN_RMWcc(fullop, var, cc, ...)				\
 do {									\
 	asm_volatile_goto (fullop "; j" cc " %l[cc_label]"		\
@@ -20,23 +18,4 @@ cc_label:								\
 #define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
 	__GEN_RMWcc(op " %1, " arg0, var, cc, vcon (val))
 
-#else /* !CONFIG_CC_HAS_ASM_GOTO */
-
-#define __GEN_RMWcc(fullop, var, cc, ...)				\
-do {									\
-	char c;								\
-	asm volatile (fullop "; set" cc " %1"				\
-			: "+m" (var), "=qm" (c)				\
-			: __VA_ARGS__ : "memory");			\
-	return c != 0;							\
-} while (0)
-
-#define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
-	__GEN_RMWcc(op " " arg0, var, cc)
-
-#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
-	__GEN_RMWcc(op " %2, " arg0, var, cc, vcon (val))
-
-#endif /* CONFIG_CC_HAS_ASM_GOTO */
-
 #endif /* _TOOLS_LINUX_ASM_X86_RMWcc */
-- 
2.37.1.595.g718a3a8f04-goog

