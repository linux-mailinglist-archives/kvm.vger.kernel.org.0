Return-Path: <kvm+bounces-682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 543E47E1F47
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72F1E1C20BA9
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D7321A71D;
	Mon,  6 Nov 2023 11:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P+25o6DE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B651A701
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:05:15 +0000 (UTC)
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA053BB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:05:12 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2c6efcef4eeso52232321fa.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268711; x=1699873511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WxUmiCwPV5zJl3mXwLh1MUI3WD6xJyg5vO6bbT+CodM=;
        b=P+25o6DEOLUViaRGcFEQjg/TKY2Cjuz7z/Z/4lgmT6VQRPoxUVHPPC00MFPkty7m08
         7ZhDRSP9MCJf4uoCSBqt6D4BHDukOifLTkZbUTY1+EQDm6xo9teNXv8U48zH6teVLOqA
         6tOCQOrjs6pNXQFYpP1qnw6kVkdaKvjrKgXmWbEzhfqA078mk1L2dkKLWrZF4szlm1/O
         xkFtytUcA8jLD0K0sBMgvIqL9pwCStGhUIU98gJwPnIG0OnoOdtmTj+gSDD+jc18jSRA
         XO64vAMMpUJT5COkYyWDS94N5fD/k9CjqIfsUWOUMN9eJtYG3FSdERlVGs8CnMrs7B4U
         IQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268711; x=1699873511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WxUmiCwPV5zJl3mXwLh1MUI3WD6xJyg5vO6bbT+CodM=;
        b=eSnDHnc6LYvEKEJ/yye8yQdDMryJB9vGQHRnoHVHGB2GbgJArVSimvzKzQ9rHtWJCU
         njv/5fj6SdF3gGvWd/+ZnD3YKf0nBeEsxpNSvruNiFkAncx+KKzXb0qA4oCBTMJyAjH2
         cOsOkTOd2k0kLOi+BfGh4/iL1ZNAXW89rc3W2hQTy/PCIJeftw8BpMRhjj87dSvRd+Gc
         tEc51RaheCq+vqBIeBbknVzz+dL9H9t3QV81Lbg8l+pSkfy5nNZgTG7ewW4BrecyGE0k
         vWMdKYIv1vigJlIt3K8SoNsNpjJ9gEumNioApN2po+hodW9/bNOAvNc34GSt/QqxIRHn
         izjg==
X-Gm-Message-State: AOJu0YwEsW0rzX3OzteDY6F/w5KD94x9V2WXo3UCg7QMyLddZ3LnNpsu
	88AKbdZsLXeaTW0vkOsjykeOiw==
X-Google-Smtp-Source: AGHT+IGesghmwnsW7pNz/cPIy+OAEt0HtfvDXrPkmNh4TvVN2ENKoIeGC2Q+uLhqqoE2yhO8HQohrw==
X-Received: by 2002:a2e:b0e5:0:b0:2c5:2813:5538 with SMTP id h5-20020a2eb0e5000000b002c528135538mr22071679ljl.21.1699268710824;
        Mon, 06 Nov 2023 03:05:10 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id a11-20020a05600c2d4b00b00405c33a9a12sm6133016wmg.0.2023.11.06.03.05.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:05:10 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	LIU Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PULL 13/60] target: Declare FOO_CPU_TYPE_NAME/SUFFIX in 'cpu-qom.h'
Date: Mon,  6 Nov 2023 12:02:45 +0100
Message-ID: <20231106110336.358-14-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106110336.358-1-philmd@linaro.org>
References: <20231106110336.358-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hegerogeneous code needs access to the FOO_CPU_TYPE_NAME()
macro to resolve target CPU types. Move the declaration
(along with the required FOO_CPU_TYPE_SUFFIX) to "cpu-qom.h".

"target/foo/cpu-qom.h" is supposed to be target agnostic
(include-able by any target). Add such mention in the
header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: LIU Zhiwei <zhiwei_liu@linux.alibaba.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20231013140116.255-7-philmd@linaro.org>
---
 target/alpha/cpu-qom.h   | 5 ++++-
 target/alpha/cpu.h       | 2 --
 target/avr/cpu-qom.h     | 5 ++++-
 target/avr/cpu.h         | 2 --
 target/cris/cpu-qom.h    | 5 ++++-
 target/cris/cpu.h        | 2 --
 target/i386/cpu-qom.h    | 3 +++
 target/i386/cpu.h        | 2 --
 target/m68k/cpu-qom.h    | 5 ++++-
 target/m68k/cpu.h        | 2 --
 target/mips/cpu-qom.h    | 3 +++
 target/mips/cpu.h        | 2 --
 target/rx/cpu-qom.h      | 5 ++++-
 target/rx/cpu.h          | 2 --
 target/s390x/cpu-qom.h   | 5 ++++-
 target/s390x/cpu.h       | 2 --
 target/sh4/cpu-qom.h     | 5 ++++-
 target/sh4/cpu.h         | 2 --
 target/sparc/cpu-qom.h   | 5 ++++-
 target/sparc/cpu.h       | 2 --
 target/tricore/cpu-qom.h | 5 +++++
 target/tricore/cpu.h     | 2 --
 target/xtensa/cpu-qom.h  | 5 ++++-
 target/xtensa/cpu.h      | 2 --
 24 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/target/alpha/cpu-qom.h b/target/alpha/cpu-qom.h
index c5fbd8f11a..c4a4523993 100644
--- a/target/alpha/cpu-qom.h
+++ b/target/alpha/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU Alpha CPU
+ * QEMU Alpha CPU QOM header (target agnostic)
  *
  * Copyright (c) 2012 SUSE LINUX Products GmbH
  *
@@ -27,6 +27,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(AlphaCPU, AlphaCPUClass, ALPHA_CPU)
 
+#define ALPHA_CPU_TYPE_SUFFIX "-" TYPE_ALPHA_CPU
+#define ALPHA_CPU_TYPE_NAME(model) model ALPHA_CPU_TYPE_SUFFIX
+
 /**
  * AlphaCPUClass:
  * @parent_realize: The parent class' realize handler.
diff --git a/target/alpha/cpu.h b/target/alpha/cpu.h
index c8d97ac27a..3bff56c565 100644
--- a/target/alpha/cpu.h
+++ b/target/alpha/cpu.h
@@ -426,8 +426,6 @@ enum {
 
 void alpha_translate_init(void);
 
-#define ALPHA_CPU_TYPE_SUFFIX "-" TYPE_ALPHA_CPU
-#define ALPHA_CPU_TYPE_NAME(model) model ALPHA_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_ALPHA_CPU
 
 void alpha_cpu_list(void);
diff --git a/target/avr/cpu-qom.h b/target/avr/cpu-qom.h
index d89be01e0f..75590cdd97 100644
--- a/target/avr/cpu-qom.h
+++ b/target/avr/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU AVR CPU
+ * QEMU AVR CPU QOM header (target agnostic)
  *
  * Copyright (c) 2016-2020 Michael Rolnik
  *
@@ -28,6 +28,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(AVRCPU, AVRCPUClass, AVR_CPU)
 
+#define AVR_CPU_TYPE_SUFFIX "-" TYPE_AVR_CPU
+#define AVR_CPU_TYPE_NAME(name) (name AVR_CPU_TYPE_SUFFIX)
+
 /**
  *  AVRCPUClass:
  *  @parent_realize: The parent class' realize handler.
diff --git a/target/avr/cpu.h b/target/avr/cpu.h
index f8b065ed79..0487399cb2 100644
--- a/target/avr/cpu.h
+++ b/target/avr/cpu.h
@@ -28,8 +28,6 @@
 #error "AVR 8-bit does not support user mode"
 #endif
 
-#define AVR_CPU_TYPE_SUFFIX "-" TYPE_AVR_CPU
-#define AVR_CPU_TYPE_NAME(name) (name AVR_CPU_TYPE_SUFFIX)
 #define CPU_RESOLVING_TYPE TYPE_AVR_CPU
 
 #define TCG_GUEST_DEFAULT_MO 0
diff --git a/target/cris/cpu-qom.h b/target/cris/cpu-qom.h
index c2fee242f4..d7e5f33e62 100644
--- a/target/cris/cpu-qom.h
+++ b/target/cris/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU CRIS CPU
+ * QEMU CRIS CPU QOM header (target agnostic)
  *
  * Copyright (c) 2012 SUSE LINUX Products GmbH
  *
@@ -27,6 +27,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(CRISCPU, CRISCPUClass, CRIS_CPU)
 
+#define CRIS_CPU_TYPE_SUFFIX "-" TYPE_CRIS_CPU
+#define CRIS_CPU_TYPE_NAME(name) (name CRIS_CPU_TYPE_SUFFIX)
+
 /**
  * CRISCPUClass:
  * @parent_realize: The parent class' realize handler.
diff --git a/target/cris/cpu.h b/target/cris/cpu.h
index 6aa445348f..b821bb7983 100644
--- a/target/cris/cpu.h
+++ b/target/cris/cpu.h
@@ -240,8 +240,6 @@ enum {
 /* CRIS uses 8k pages.  */
 #define MMAP_SHIFT TARGET_PAGE_BITS
 
-#define CRIS_CPU_TYPE_SUFFIX "-" TYPE_CRIS_CPU
-#define CRIS_CPU_TYPE_NAME(name) (name CRIS_CPU_TYPE_SUFFIX)
 #define CPU_RESOLVING_TYPE TYPE_CRIS_CPU
 
 /* MMU modes definitions */
diff --git a/target/i386/cpu-qom.h b/target/i386/cpu-qom.h
index 58145717ef..dffc74c1ce 100644
--- a/target/i386/cpu-qom.h
+++ b/target/i386/cpu-qom.h
@@ -32,6 +32,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(X86CPU, X86CPUClass, X86_CPU)
 
+#define X86_CPU_TYPE_SUFFIX "-" TYPE_X86_CPU
+#define X86_CPU_TYPE_NAME(name) (name X86_CPU_TYPE_SUFFIX)
+
 typedef struct X86CPUModel X86CPUModel;
 
 /**
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 096f85483e..6c6b066986 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2239,8 +2239,6 @@ void cpu_x86_update_dr7(CPUX86State *env, uint32_t new_dr7);
 /* hw/pc.c */
 uint64_t cpu_get_tsc(CPUX86State *env);
 
-#define X86_CPU_TYPE_SUFFIX "-" TYPE_X86_CPU
-#define X86_CPU_TYPE_NAME(name) (name X86_CPU_TYPE_SUFFIX)
 #define CPU_RESOLVING_TYPE TYPE_X86_CPU
 
 #ifdef TARGET_X86_64
diff --git a/target/m68k/cpu-qom.h b/target/m68k/cpu-qom.h
index 13d94c9fe3..df0cc8b7a3 100644
--- a/target/m68k/cpu-qom.h
+++ b/target/m68k/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU Motorola 68k CPU
+ * QEMU Motorola 68k CPU QOM header (target agnostic)
  *
  * Copyright (c) 2012 SUSE LINUX Products GmbH
  *
@@ -27,6 +27,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(M68kCPU, M68kCPUClass, M68K_CPU)
 
+#define M68K_CPU_TYPE_SUFFIX "-" TYPE_M68K_CPU
+#define M68K_CPU_TYPE_NAME(model) model M68K_CPU_TYPE_SUFFIX
+
 /*
  * M68kCPUClass:
  * @parent_realize: The parent class' realize handler.
diff --git a/target/m68k/cpu.h b/target/m68k/cpu.h
index 9ea18028ad..7f34686a6f 100644
--- a/target/m68k/cpu.h
+++ b/target/m68k/cpu.h
@@ -561,8 +561,6 @@ enum {
     ACCESS_DATA  = 0x20, /* Data load/store access        */
 };
 
-#define M68K_CPU_TYPE_SUFFIX "-" TYPE_M68K_CPU
-#define M68K_CPU_TYPE_NAME(model) model M68K_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_M68K_CPU
 
 #define cpu_list m68k_cpu_list
diff --git a/target/mips/cpu-qom.h b/target/mips/cpu-qom.h
index c70b4a34be..5822dfb1d2 100644
--- a/target/mips/cpu-qom.h
+++ b/target/mips/cpu-qom.h
@@ -31,6 +31,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(MIPSCPU, MIPSCPUClass, MIPS_CPU)
 
+#define MIPS_CPU_TYPE_SUFFIX "-" TYPE_MIPS_CPU
+#define MIPS_CPU_TYPE_NAME(model) model MIPS_CPU_TYPE_SUFFIX
+
 /**
  * MIPSCPUClass:
  * @parent_realize: The parent class' realize handler.
diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 617c373797..12cc1bfafd 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1301,8 +1301,6 @@ enum {
  */
 #define CPU_INTERRUPT_WAKE CPU_INTERRUPT_TGT_INT_0
 
-#define MIPS_CPU_TYPE_SUFFIX "-" TYPE_MIPS_CPU
-#define MIPS_CPU_TYPE_NAME(model) model MIPS_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_MIPS_CPU
 
 bool cpu_type_supports_cps_smp(const char *cpu_type);
diff --git a/target/rx/cpu-qom.h b/target/rx/cpu-qom.h
index f4cd5664e5..6213d877f7 100644
--- a/target/rx/cpu-qom.h
+++ b/target/rx/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * RX CPU
+ * QEMU RX CPU QOM header (target agnostic)
  *
  * Copyright (c) 2019 Yoshinori Sato
  *
@@ -28,6 +28,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(RXCPU, RXCPUClass, RX_CPU)
 
+#define RX_CPU_TYPE_SUFFIX "-" TYPE_RX_CPU
+#define RX_CPU_TYPE_NAME(model) model RX_CPU_TYPE_SUFFIX
+
 /*
  * RXCPUClass:
  * @parent_realize: The parent class' realize handler.
diff --git a/target/rx/cpu.h b/target/rx/cpu.h
index 8379f4a150..c81613770c 100644
--- a/target/rx/cpu.h
+++ b/target/rx/cpu.h
@@ -112,8 +112,6 @@ struct ArchCPU {
     CPURXState env;
 };
 
-#define RX_CPU_TYPE_SUFFIX "-" TYPE_RX_CPU
-#define RX_CPU_TYPE_NAME(model) model RX_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_RX_CPU
 
 const char *rx_crname(uint8_t cr);
diff --git a/target/s390x/cpu-qom.h b/target/s390x/cpu-qom.h
index 1088965fd5..fcd70daddf 100644
--- a/target/s390x/cpu-qom.h
+++ b/target/s390x/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU S/390 CPU
+ * QEMU S/390 CPU QOM header (target agnostic)
  *
  * Copyright (c) 2012 SUSE LINUX Products GmbH
  *
@@ -27,6 +27,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(S390CPU, S390CPUClass, S390_CPU)
 
+#define S390_CPU_TYPE_SUFFIX "-" TYPE_S390_CPU
+#define S390_CPU_TYPE_NAME(name) (name S390_CPU_TYPE_SUFFIX)
+
 typedef struct S390CPUModel S390CPUModel;
 typedef struct S390CPUDef S390CPUDef;
 
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index 4f366f9e4e..38d7197f4c 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -890,8 +890,6 @@ void s390_set_qemu_cpu_model(uint16_t type, uint8_t gen, uint8_t ec_ga,
 
 
 /* helper.c */
-#define S390_CPU_TYPE_SUFFIX "-" TYPE_S390_CPU
-#define S390_CPU_TYPE_NAME(name) (name S390_CPU_TYPE_SUFFIX)
 #define CPU_RESOLVING_TYPE TYPE_S390_CPU
 
 /* interrupt.c */
diff --git a/target/sh4/cpu-qom.h b/target/sh4/cpu-qom.h
index 08fbebc996..bd0ef49fa1 100644
--- a/target/sh4/cpu-qom.h
+++ b/target/sh4/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU SuperH CPU
+ * QEMU SuperH CPU QOM header (target agnostic)
  *
  * Copyright (c) 2012 SUSE LINUX Products GmbH
  *
@@ -31,6 +31,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(SuperHCPU, SuperHCPUClass, SUPERH_CPU)
 
+#define SUPERH_CPU_TYPE_SUFFIX "-" TYPE_SUPERH_CPU
+#define SUPERH_CPU_TYPE_NAME(model) model SUPERH_CPU_TYPE_SUFFIX
+
 /**
  * SuperHCPUClass:
  * @parent_realize: The parent class' realize handler.
diff --git a/target/sh4/cpu.h b/target/sh4/cpu.h
index dc0561b73b..dbe00e29c2 100644
--- a/target/sh4/cpu.h
+++ b/target/sh4/cpu.h
@@ -250,8 +250,6 @@ int cpu_sh4_is_cached(CPUSH4State * env, target_ulong addr);
 
 void cpu_load_tlb(CPUSH4State * env);
 
-#define SUPERH_CPU_TYPE_SUFFIX "-" TYPE_SUPERH_CPU
-#define SUPERH_CPU_TYPE_NAME(model) model SUPERH_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_SUPERH_CPU
 
 #define cpu_list sh4_cpu_list
diff --git a/target/sparc/cpu-qom.h b/target/sparc/cpu-qom.h
index b4a0db84ce..aca29415b4 100644
--- a/target/sparc/cpu-qom.h
+++ b/target/sparc/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU SPARC CPU
+ * QEMU SPARC CPU QOM header (target agnostic)
  *
  * Copyright (c) 2012 SUSE LINUX Products GmbH
  *
@@ -31,6 +31,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(SPARCCPU, SPARCCPUClass, SPARC_CPU)
 
+#define SPARC_CPU_TYPE_SUFFIX "-" TYPE_SPARC_CPU
+#define SPARC_CPU_TYPE_NAME(model) model SPARC_CPU_TYPE_SUFFIX
+
 typedef struct sparc_def_t sparc_def_t;
 /**
  * SPARCCPUClass:
diff --git a/target/sparc/cpu.h b/target/sparc/cpu.h
index 84a030e406..8c567037cb 100644
--- a/target/sparc/cpu.h
+++ b/target/sparc/cpu.h
@@ -660,8 +660,6 @@ hwaddr cpu_get_phys_page_nofault(CPUSPARCState *env, target_ulong addr,
 #endif
 #endif
 
-#define SPARC_CPU_TYPE_SUFFIX "-" TYPE_SPARC_CPU
-#define SPARC_CPU_TYPE_NAME(model) model SPARC_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_SPARC_CPU
 
 #define cpu_list sparc_cpu_list
diff --git a/target/tricore/cpu-qom.h b/target/tricore/cpu-qom.h
index b3b6c75a3a..2598651008 100644
--- a/target/tricore/cpu-qom.h
+++ b/target/tricore/cpu-qom.h
@@ -1,4 +1,6 @@
 /*
+ * QEMU TriCore CPU QOM header (target agnostic)
+ *
  *  Copyright (c) 2012-2014 Bastian Koppelmann C-Lab/University Paderborn
  *
  * This library is free software; you can redistribute it and/or
@@ -26,6 +28,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(TriCoreCPU, TriCoreCPUClass, TRICORE_CPU)
 
+#define TRICORE_CPU_TYPE_SUFFIX "-" TYPE_TRICORE_CPU
+#define TRICORE_CPU_TYPE_NAME(model) model TRICORE_CPU_TYPE_SUFFIX
+
 struct TriCoreCPUClass {
     CPUClass parent_class;
 
diff --git a/target/tricore/cpu.h b/target/tricore/cpu.h
index b4a6ab141d..c537a33ee8 100644
--- a/target/tricore/cpu.h
+++ b/target/tricore/cpu.h
@@ -268,8 +268,6 @@ static inline void cpu_get_tb_cpu_state(CPUTriCoreState *env, vaddr *pc,
     *flags = new_flags;
 }
 
-#define TRICORE_CPU_TYPE_SUFFIX "-" TYPE_TRICORE_CPU
-#define TRICORE_CPU_TYPE_NAME(model) model TRICORE_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_TRICORE_CPU
 
 /* helpers.c */
diff --git a/target/xtensa/cpu-qom.h b/target/xtensa/cpu-qom.h
index 424bcbd8dd..03873ea50b 100644
--- a/target/xtensa/cpu-qom.h
+++ b/target/xtensa/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU Xtensa CPU
+ * QEMU Xtensa CPU QOM header (target agnostic)
  *
  * Copyright (c) 2012 SUSE LINUX Products GmbH
  * All rights reserved.
@@ -36,6 +36,9 @@
 
 OBJECT_DECLARE_CPU_TYPE(XtensaCPU, XtensaCPUClass, XTENSA_CPU)
 
+#define XTENSA_CPU_TYPE_SUFFIX "-" TYPE_XTENSA_CPU
+#define XTENSA_CPU_TYPE_NAME(model) model XTENSA_CPU_TYPE_SUFFIX
+
 typedef struct XtensaConfig XtensaConfig;
 
 /**
diff --git a/target/xtensa/cpu.h b/target/xtensa/cpu.h
index 85aab1bdf8..d6d2fb1f4e 100644
--- a/target/xtensa/cpu.h
+++ b/target/xtensa/cpu.h
@@ -586,8 +586,6 @@ G_NORETURN void xtensa_cpu_do_unaligned_access(CPUState *cpu, vaddr addr,
 
 #define cpu_list xtensa_cpu_list
 
-#define XTENSA_CPU_TYPE_SUFFIX "-" TYPE_XTENSA_CPU
-#define XTENSA_CPU_TYPE_NAME(model) model XTENSA_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_XTENSA_CPU
 
 #if TARGET_BIG_ENDIAN
-- 
2.41.0


