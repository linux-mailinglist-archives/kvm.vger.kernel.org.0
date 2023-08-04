Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4046E76F78D
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbjHDCLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjHDCLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:11:22 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994C044BB
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 19:10:51 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1bbaa549bcbso1180668fac.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 19:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1691115050; x=1691719850;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aKI9/8r29fiRcdK5stgXJjwhW7P4T9bJiQbL+zxyBRE=;
        b=AkhJfOQFM1pGb6BlPUy06oljjiN78H7icu0FCH4lB+bXHw/LwEgE5WfUHUrhk68xKT
         VZ9dam0/U64TWA5t9TdKruXPJ3X0H+Sf0d6VfdGQUmlqqGKLC8z8Yvh7+P06WeYSaRF6
         7tff9KQinoC1Hs5opB6YqN+4f3XkGXDoNcN0XTyYvtwmEI6i78JSWRjapxttsIFecIL3
         TCvudV8tBM9EoNig/xmiY7igTYmcPHx0ukaFkc/TJlPFpGWB16NSmemF6Z9bDb7+PdFN
         fVb3cD33kRf2q8frdWvDdZU0s40iHWB50DKpovfgMWF8buP9mcXSJ1u8dbQjRbyQHCxf
         UWXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691115050; x=1691719850;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aKI9/8r29fiRcdK5stgXJjwhW7P4T9bJiQbL+zxyBRE=;
        b=S/98EvWUEg0NOcjlcUfsB3gias2sYg/oM5uF4VrzccxXeB3+iG5H1UFaz9Z9PIyV0f
         xGV94FDZMoPyEg1yXhARVwb3tTrm07NmtPDiHRMNbX5aiq8iOCfPfIl+Zoboadh69/84
         iwJ48eSLgUO/HgsJGcAV44Mq8AbejOLo1Udc5FUXJ0qHicpXOZCqzWowi16bqbVBy93f
         nlAqx4/iPZlfhMf7WwqdOceiyhHe3BH6STNdwnXZ+V6VM98CIXHN6e4m/87hm4ltBka1
         +XpMhLyCBaV2RQ+odbHDYcuGNBucMB7/qZotwDexpl+KCM8qSlnfaOIzNWMNZJ3Du7cj
         AZVg==
X-Gm-Message-State: AOJu0YzWqSzSnTH35eJEmcAZ3kiWi/zcm8cqCvX/9RCfCLaHHtJvy6DJ
        FU5lXejWTDh9CUXxmkyGG0MVjg==
X-Google-Smtp-Source: AGHT+IGEhqmUxc1mmFiSsBDUL26nAWIZW9KyBf1DeJ5CThKaab1yi3ouqz1V6OLbD8yYEm2oPVP2Jw==
X-Received: by 2002:a05:6871:707:b0:19f:aee0:e169 with SMTP id f7-20020a056871070700b0019faee0e169mr420658oap.30.1691115050056;
        Thu, 03 Aug 2023 19:10:50 -0700 (PDT)
Received: from charlie.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id g6-20020a655806000000b0055c558ac4edsm369499pgr.46.2023.08.03.19.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 19:10:49 -0700 (PDT)
From:   Charlie Jenkins <charlie@rivosinc.com>
Subject: [PATCH 00/10] RISC-V: Refactor instructions
Date:   Thu, 03 Aug 2023 19:10:25 -0700
Message-Id: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABJezGQC/x2NQQqDQAxFryJZG4jOLMSrlC7CmNYsHEsyFUG8e
 0OXD/777wIXU3GYuwtMDnXda8DQd1BWrm9BXYJhpDHRRANu7E0MTV5c2m6o1Zt9SwvP8ciYU2K
 mTAtTgnj5xFLPf+HxvO8foTEC2nEAAAA=
To:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        bpf@vger.kernel.org
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Nam Cao <namcaov@gmail.com>,
        Charlie Jenkins <charlie@rivosinc.com>
X-Mailer: b4 0.12.3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are numerous systems in the kernel that rely on directly
modifying, creating, and reading instructions. Many of these systems
have rewritten code to do this. This patch will delegate all instruction
handling into insn.h and reg.h. All of the compressed instructions, RVI,
Zicsr, M, A instructions are included, as well as a subset of the F,D,Q
extensions.

---
This is modifying code that https://lore.kernel.org/lkml/20230731183925.152145-1-namcaov@gmail.com/
is also touching.

---
Testing:

There are a lot of subsystems touched and I have not tested every
individual instruction. I did a lot of copy-pasting from the RISC-V spec
so opcodes and such should be correct, but the construction of every
instruction is not fully tested.

vector: Compiled and booted

jump_label: Ensured static keys function as expected.

kgdb: Attempted to run the provided tests but they failed even without
my changes

module: Loaded and unloaded modules

patch.c: Ensured kernel booted

kprobes: Used a kprobing module to probe jalr, auipc, and branch
instructions

nommu misaligned addresses: Kernel boots

kvm: Ran KVM selftests

bpf: Kernel boots. Most of the instructions are exclusively used by BPF
but I am unsure of the best way of testing BPF.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>

---
Charlie Jenkins (10):
      RISC-V: Expand instruction definitions
      RISC-V: vector: Refactor instructions
      RISC-V: Refactor jump label instructions
      RISC-V: KGDB: Refactor instructions
      RISC-V: module: Refactor instructions
      RISC-V: Refactor patch instructions
      RISC-V: nommu: Refactor instructions
      RISC-V: kvm: Refactor instructions
      RISC-V: bpf: Refactor instructions
      RISC-V: Refactor bug and traps instructions

 arch/riscv/include/asm/bug.h             |   18 +-
 arch/riscv/include/asm/insn.h            | 2744 +++++++++++++++++++++++++++---
 arch/riscv/include/asm/reg.h             |   88 +
 arch/riscv/kernel/jump_label.c           |   13 +-
 arch/riscv/kernel/kgdb.c                 |   13 +-
 arch/riscv/kernel/module.c               |   80 +-
 arch/riscv/kernel/patch.c                |    3 +-
 arch/riscv/kernel/probes/kprobes.c       |   13 +-
 arch/riscv/kernel/probes/simulate-insn.c |  100 +-
 arch/riscv/kernel/probes/uprobes.c       |    5 +-
 arch/riscv/kernel/traps.c                |    9 +-
 arch/riscv/kernel/traps_misaligned.c     |  218 +--
 arch/riscv/kernel/vector.c               |    5 +-
 arch/riscv/kvm/vcpu_insn.c               |  281 +--
 arch/riscv/net/bpf_jit.h                 |  707 +-------
 15 files changed, 2825 insertions(+), 1472 deletions(-)
---
base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
change-id: 20230801-master-refactor-instructions-v4-433aa040da03
-- 
- Charlie

