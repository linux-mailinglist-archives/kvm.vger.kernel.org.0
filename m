Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6370376FD3D
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 11:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjHDJ2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 05:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjHDJ2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 05:28:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B41A30EA
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 02:28:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-99c4923195dso256837566b.2
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 02:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691141310; x=1691746110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfqEgyUyGWV+uCR/G+Jp30EpbAjcXJAFKXc4wfVRnvc=;
        b=E5XARrnWgyw7Cl6ZED5yZTcAjZ31Ocmt/9ACuiwG3t25Jv8VSFbwPR0xS8/w6YDBWS
         jFraad9vh58ejKHgML+JfZPZLP6hZx6immp48/Ns5zgR1eVbrtVmIxwjpDjurBTZQLkZ
         0la33KkRHDu0Sny+rPQjycd9YlzI3KNeLSdwoRjSh2x7GSGeRvrN+8/jv+SxRdnX4Mf2
         5wLmtp9/XsJpk/EWdDbpwoNxWZsvCmxe0FRPzCVH7oKMxWd9yyKlyhyTQ6KTnoB2fiEt
         192MzRXO2VNkgNOtCPU4sZx8wov6wXGgBZfbXDKB++JuQrVnIiKO3CXnkPFx07E5vDhY
         NsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691141310; x=1691746110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfqEgyUyGWV+uCR/G+Jp30EpbAjcXJAFKXc4wfVRnvc=;
        b=Efx341ehIWnIwoqA6jG0x5VBut+Hnv8m/uTFasINBY+k7vhXz6XHZkYzX8DYxy/Upn
         EpDzvZcW7e/XBQE/wJ/ZB1v22Sgv+46zqVZ9Ukh4y9PfL0dYiQFcTYQZQ6Q46MF7gc7S
         yVCbxA1DYikILQFsYzAFg3PG/9gsZEiKuK029LKCnjF7tIyH95c2R/lemgqftkhn1yHG
         S8vaUMAyCIZCvpNp+DAdik9o+PH7qbx2IJBjIjeAyP9fXozm+ytfSDjsuIkDznTo4xAt
         IOfAtRcyoUv47YyBCEvjo7zCWDEwKs1KD6ob0GP5gDsybhouNnvKwXv+itoAs1eSM2y+
         aDhw==
X-Gm-Message-State: AOJu0YyORhYOHPc5sV9ly6ydKwjTLqeU/WhmwnuaZriYEQ+rgAzHDXUh
        lryNT9HHcd9mN1SeZp9vcCn63A==
X-Google-Smtp-Source: AGHT+IE6rLcJxJxn18Xxg19aKhaZkkPhYOGD3RLIstSvThFuRa9fmKxoji2QZX4Ve7Hm/5p2G7FBoA==
X-Received: by 2002:a17:906:2012:b0:99b:f53c:3648 with SMTP id 18-20020a170906201200b0099bf53c3648mr991573ejo.72.1691141310471;
        Fri, 04 Aug 2023 02:28:30 -0700 (PDT)
Received: from localhost (212-5-140-29.ip.btc-net.bg. [212.5.140.29])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709066a8700b009930042510csm1024394ejr.222.2023.08.04.02.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 02:28:30 -0700 (PDT)
Date:   Fri, 4 Aug 2023 12:28:28 +0300
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Charlie Jenkins <charlie@rivosinc.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        bpf@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
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
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Nam Cao <namcaov@gmail.com>
Subject: Re: [PATCH 00/10] RISC-V: Refactor instructions
Message-ID: <20230804-2c57bddd6e87fdebc20ff9d5@orel>
References: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 07:10:25PM -0700, Charlie Jenkins wrote:
> There are numerous systems in the kernel that rely on directly
> modifying, creating, and reading instructions. Many of these systems
> have rewritten code to do this. This patch will delegate all instruction
> handling into insn.h and reg.h. All of the compressed instructions, RVI,
> Zicsr, M, A instructions are included, as well as a subset of the F,D,Q
> extensions.
> 
> ---
> This is modifying code that https://lore.kernel.org/lkml/20230731183925.152145-1-namcaov@gmail.com/
> is also touching.
> 
> ---
> Testing:
> 
> There are a lot of subsystems touched and I have not tested every
> individual instruction. I did a lot of copy-pasting from the RISC-V spec
> so opcodes and such should be correct

How about we create macros which generate each of the functions an
instruction needs, e.g. riscv_insn_is_*(), etc. based on the output of
[1]. I know basically nothing about that project, but it looks like it
creates most the defines this series is creating from what we [hope] to
be an authoritative source. I also assume that if we don't like the
current output format, then we could probably post patches to the project
to get the format we want. For example, we could maybe propose an "lc"
format for "Linux C".

I'd also recommend only importing the generated defines and generating
the functions that will actually have immediate consumers or are part of
a set of defines that have immediate consumers. Each consumer of new
instructions will be responsible for generating and importing the defines
and adding the respective macro invocations to generate the functions.
This series can also take that approach, i.e. convert one set of
instructions at a time, each in a separate patch.

[1] https://github.com/riscv/riscv-opcodes

Thanks,
drew


> , but the construction of every
> instruction is not fully tested.
> 
> vector: Compiled and booted
> 
> jump_label: Ensured static keys function as expected.
> 
> kgdb: Attempted to run the provided tests but they failed even without
> my changes
> 
> module: Loaded and unloaded modules
> 
> patch.c: Ensured kernel booted
> 
> kprobes: Used a kprobing module to probe jalr, auipc, and branch
> instructions
> 
> nommu misaligned addresses: Kernel boots
> 
> kvm: Ran KVM selftests
> 
> bpf: Kernel boots. Most of the instructions are exclusively used by BPF
> but I am unsure of the best way of testing BPF.
> 
> Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
> 
> ---
> Charlie Jenkins (10):
>       RISC-V: Expand instruction definitions
>       RISC-V: vector: Refactor instructions
>       RISC-V: Refactor jump label instructions
>       RISC-V: KGDB: Refactor instructions
>       RISC-V: module: Refactor instructions
>       RISC-V: Refactor patch instructions
>       RISC-V: nommu: Refactor instructions
>       RISC-V: kvm: Refactor instructions
>       RISC-V: bpf: Refactor instructions
>       RISC-V: Refactor bug and traps instructions
> 
>  arch/riscv/include/asm/bug.h             |   18 +-
>  arch/riscv/include/asm/insn.h            | 2744 +++++++++++++++++++++++++++---
>  arch/riscv/include/asm/reg.h             |   88 +
>  arch/riscv/kernel/jump_label.c           |   13 +-
>  arch/riscv/kernel/kgdb.c                 |   13 +-
>  arch/riscv/kernel/module.c               |   80 +-
>  arch/riscv/kernel/patch.c                |    3 +-
>  arch/riscv/kernel/probes/kprobes.c       |   13 +-
>  arch/riscv/kernel/probes/simulate-insn.c |  100 +-
>  arch/riscv/kernel/probes/uprobes.c       |    5 +-
>  arch/riscv/kernel/traps.c                |    9 +-
>  arch/riscv/kernel/traps_misaligned.c     |  218 +--
>  arch/riscv/kernel/vector.c               |    5 +-
>  arch/riscv/kvm/vcpu_insn.c               |  281 +--
>  arch/riscv/net/bpf_jit.h                 |  707 +-------
>  15 files changed, 2825 insertions(+), 1472 deletions(-)
> ---
> base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
> change-id: 20230801-master-refactor-instructions-v4-433aa040da03
> -- 
> - Charlie
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
