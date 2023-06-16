Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E27732B46
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343695AbjFPJVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343499AbjFPJVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:21:45 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABFA2133
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:21:43 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1a994308bc6so547525fac.3
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686907303; x=1689499303;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vVRxX4mWQUCI3SHJkD6g1lLBz5zHgS/7wRelzGzudzA=;
        b=TOXTv1DnizYQ+gHzhCvhrk11OO2WnW8NdvhaUAGMlRXOYiQRkaG/hvlLxZ42CPMGqz
         ZkzlHMN4E+Kh2fqlCEr3peeU4s2+qlDRXZdq2ChpsqK0jGWJVU/PEmRtuxYRlAT3wF0S
         qCc/+mNjxuS2uceShWmqFaXaEReUBX5B/YQ1EMjft38IHQ5uO+yPDEqiWv2DHpuqTU8P
         qw409+hwv1vNVHCpp0ElRg5XTCVCN/T+TJQJoTluLe1efcMaOdGQQGJ9Ro4A5s8akDXV
         l+ygvTNpCYduDwxUSdYIQa2SWPNk83FVazzK0DuUqWFSS0X8SYpYcHRTsltcICpInX5y
         jzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686907303; x=1689499303;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVRxX4mWQUCI3SHJkD6g1lLBz5zHgS/7wRelzGzudzA=;
        b=SI+XEWKxGbhZ6S0PpFHeY6IGUrkxY8YAMmMYcXMZHWINoFJ9QAViw43S3O4eUeOHzC
         DbvLCPr3t37qfXVkQEvgC8PsZFu5q0kPckeFwHzs3G9GBci3ObuZqCvSzqar6fzjG1kO
         N8LsTL1pUKFlEVlAVdbSWa9nydoB8c2o8KjGATb6ZhrbCFDNMbWEqkvNX1mCw5pzM6eg
         JkDvEf2Rob5IW6BBpJm/qJ249L3DQnbrd+Do/92+QBVisuvYlYZCuqPxBVhPmxd8g9Z8
         fQULv8CBniUZRJm+5IprAaAeBys65Xnfqljzr9h3ydFpdPhm39pYcjVhshNO84PzPH9A
         uc0Q==
X-Gm-Message-State: AC+VfDyPlk8RHm/L8f0UfZaKJFD2PZFEyRV/CtCqb1FJtnOekdGIm++B
        HTKWQMsr4ap6JI+XA86lRK1YOA==
X-Google-Smtp-Source: ACHHUZ7rZEFQWrfr3XEyx/4m3v0Gs7112/0hS8pjZCboJ/VJrMexbmLqpO/cwed5yIYZtQDD/1EgEQ==
X-Received: by 2002:a05:6870:c395:b0:19f:202b:513c with SMTP id g21-20020a056870c39500b0019f202b513cmr1499094oao.29.1686907302991;
        Fri, 16 Jun 2023 02:21:42 -0700 (PDT)
Received: from [192.168.68.107] ([177.170.117.210])
        by smtp.gmail.com with ESMTPSA id r21-20020a05687032d500b001a663e49523sm8198959oac.36.2023.06.16.02.21.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 02:21:42 -0700 (PDT)
Message-ID: <7f2b7328-8c0b-0664-574f-fcf6fe442b74@ventanamicro.com>
Date:   Fri, 16 Jun 2023 06:21:37 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 00/19] Add RISC-V vector cryptographic instruction set
 support
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org
References: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Lawrence,

Can you please re-send, rebased on top of Alistair's riscv-to-apply.next? There are
some comments from Weiwei Li that are worth considering. Richard Henderson also took
patches 8-9-10 via his tcg queue so you don't have to worry about those.

CC my email in the next version and I'll get some reviews going. QEMU feature
freeze for 8.1 is July 11th - perhaps we can squeeze this in for 8.1.


Thanks,

Daniel

On 4/28/23 11:47, Lawrence Hunter wrote:
> This patchset provides an implementation for Zvbb, Zvbc, Zvkned, Zvknh, Zvksh, Zvkg, and Zvksed of the draft RISC-V vector cryptography extensions as per the v20230425 version of the specification(1) (6a7ae7f2). This is an update to the patchset submitted to qemu-devel on Monday, 17 Apr 2023 14:58:36 +0100.
> 
> v2:
> 
>      squashed commits into one commit per extension with separate commits for
>      each refactoring
>      unified trans_rvzvk*.c.inc files into one trans_rvvk.c.inc
>      style fixes in insn32.decode and other files
>      added macros for EGS values in translation functions.
>      updated from v20230303 to v20230407 of the spec:
>          Zvkb has been split into Zvbb and Zvbc
>          vbrev, vclz, vctz, vcpop and vwsll have been added to Zvbb.
> 
> v3:
> 
>      New patch 03/19 removes redundant “cpu_vl == 0” checks from trans_rvv.c.inc
>      Introduction of new tcg ops has been factored out of patch 11/19 and into 09/19
>          These ops are now added to non riscv-specific files
> 
> As v20230425 is a freeze candidate, we are not expecting any significant changes to the specification or this patch series.
> 
> Please note that the Zvkt data-independent execution latency extension (and all extensions including it) has not been implemented, and we would recommend not using these patches in an environment where timing attacks are an issue.
> 
> Work performed by Dickon, Lawrence, Nazar, Kiran, and William from Codethink sponsored by SiFive, as well as Max Chou and Frank Chang from SiFive.
> 
> For convenience we have created a git repo with our patches on top of a recent master. https://github.com/CodethinkLabs/qemu-ct
> 
>      https://github.com/riscv/riscv-crypto/releases
> 
> Thanks to those who have already reviewed:
> 
>      Richard Henderson richard.henderson@linaro.org
>          [PATCH v2 02/17] target/riscv: Refactor vector-vector translation macro
>          [PATCH v2 04/17] target/riscv: Move vector translation checks
>          [PATCH v2 05/17] target/riscv: Refactor translation of vector-widening instruction
>          [PATCH v2 07/17] qemu/bitops.h: Limit rotate amounts
>          [PATCH v2 08/17] qemu/host-utils.h: Add clz and ctz functions for lower-bit integers
>          [PATCH v2 14/17] crypto: Create sm4_subword
>      Alistair Francis alistair.francis@wdc.com
>          [PATCH v2 02/17] target/riscv: Refactor vector-vector translation macro
>      Philipp Tomsich philipp.tomsich@vrull.eu
>          Various v1 reviews
>      Christoph Müllner christoph.muellner@vrull.eu
>          Various v1 reviews
> 
> 
> Dickon Hood (3):
>    target/riscv: Refactor translation of vector-widening instruction
>    qemu/bitops.h: Limit rotate amounts
>    target/riscv: Add Zvbb ISA extension support
> 
> Kiran Ostrolenk (5):
>    target/riscv: Refactor some of the generic vector functionality
>    target/riscv: Refactor vector-vector translation macro
>    target/riscv: Refactor some of the generic vector functionality
>    qemu/host-utils.h: Add clz and ctz functions for lower-bit integers
>    target/riscv: Add Zvknh ISA extension support
> 
> Lawrence Hunter (2):
>    target/riscv: Add Zvbc ISA extension support
>    target/riscv: Add Zvksh ISA extension support
> 
> Max Chou (3):
>    crypto: Create sm4_subword
>    crypto: Add SM4 constant parameter CK
>    target/riscv: Add Zvksed ISA extension support
> 
> Nazar Kazakov (6):
>    target/riscv: Remove redundant "cpu_vl == 0" checks
>    target/riscv: Move vector translation checks
>    tcg: Add andcs and rotrs tcg gvec ops
>    target/riscv: Add Zvkned ISA extension support
>    target/riscv: Add Zvkg ISA extension support
>    target/riscv: Expose Zvk* and Zvb[b,c] cpu properties
> 
>   accel/tcg/tcg-runtime-gvec.c             |   11 +
>   accel/tcg/tcg-runtime.h                  |    1 +
>   crypto/sm4.c                             |   10 +
>   include/crypto/sm4.h                     |    9 +
>   include/qemu/bitops.h                    |   24 +-
>   include/qemu/host-utils.h                |   54 ++
>   include/tcg/tcg-op-gvec.h                |    4 +
>   target/arm/tcg/crypto_helper.c           |   10 +-
>   target/riscv/cpu.c                       |   39 +
>   target/riscv/cpu.h                       |    8 +
>   target/riscv/helper.h                    |   95 ++
>   target/riscv/insn32.decode               |   58 ++
>   target/riscv/insn_trans/trans_rvv.c.inc  |  174 ++--
>   target/riscv/insn_trans/trans_rvvk.c.inc |  593 ++++++++++++
>   target/riscv/meson.build                 |    4 +-
>   target/riscv/op_helper.c                 |    6 +
>   target/riscv/translate.c                 |    1 +
>   target/riscv/vcrypto_helper.c            | 1052 ++++++++++++++++++++++
>   target/riscv/vector_helper.c             |  243 +----
>   target/riscv/vector_internals.c          |   81 ++
>   target/riscv/vector_internals.h          |  228 +++++
>   tcg/tcg-op-gvec.c                        |   23 +
>   22 files changed, 2365 insertions(+), 363 deletions(-)
>   create mode 100644 target/riscv/insn_trans/trans_rvvk.c.inc
>   create mode 100644 target/riscv/vcrypto_helper.c
>   create mode 100644 target/riscv/vector_internals.c
>   create mode 100644 target/riscv/vector_internals.h
> 
