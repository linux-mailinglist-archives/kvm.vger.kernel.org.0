Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D4973342D
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 17:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345493AbjFPPEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 11:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345820AbjFPPDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 11:03:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723083A8D
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 08:03:28 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-54f85f8b961so622763a12.3
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 08:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1686927808; x=1689519808;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4fzBxoJrsqA72FLagFuZLlHo+kt6oB7EGHhB5rZfKO8=;
        b=MMD6/t7meD6X6L9VC02efaxefBKQJAo7FvOUR+aIrnZutOpv8tpfiddGAQkaI9jqXm
         a9mgLfIBM1OYb3VWEqPPbEUykAq5C29TXC9dDM3Pk9lfjNmPTbbsEeKOmtlUGk/Yz/gE
         qLPjCsYl3NKXRXIVIeR2ZP+jxsDUIMbSpxyX9aeoEay2hYon5u2lYErpXsXWn+CEZ7QP
         GBpldaCU+KdIkMUJgUsyM3yZtXhw/yO7tG51PLl/S0FDHdCKfs0HTpBWhLxKPZvxcG4s
         kwHuG9aTPLe5Lbfq1/stkoVrnEWeGDohCrOhqPAujJww17QPEqG/pT+o6df5Dmg2ey9N
         xXVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686927808; x=1689519808;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4fzBxoJrsqA72FLagFuZLlHo+kt6oB7EGHhB5rZfKO8=;
        b=jA4E9uW2G1pCorXHnCX8jLjL20fG6hBYVa0nUSlrDaPcpBSCj0f/gt+7uwShUAr4E3
         KxaFuPPJpScHxnV6No2R9gxYleDWvs/eCf2oWPxwpF5oBuLrlpMb66QbfLwFSg8Jb011
         ltkCWqjvQ8xU/llLAse1VzmZXSJ6i+yAATU3RoITl81gs1z0CEUx06F8BkvUPjHe/Qgk
         YupjzFMgdY6T29XYfOSZYaux/4eUE9FxDKguc9wYvf6VXYLWa0WOdmaGBC0WG8ba8VuV
         QKAEv65laBXJWTpE6z9aCAiza7zMsMLba/EYSpt82vaNbxfznrmqDhMxLMmQEW8AkrCA
         3+dA==
X-Gm-Message-State: AC+VfDxamNBHLwMGAh6dFIWcu0qNq9+xc5wJUc4kZdBWs6PmozULIH60
        8irUhxA1rWtJ4xS38WLmF/obQg==
X-Google-Smtp-Source: ACHHUZ4aOnHVZ5iEXNcHInIHf3v62fXtxXlbjjKJ3pqNhg6vMzwrZqWv72dZtiMYgXbv5MDf16sRDA==
X-Received: by 2002:a17:90a:199d:b0:259:3e17:7e15 with SMTP id 29-20020a17090a199d00b002593e177e15mr2081082pji.7.1686927807648;
        Fri, 16 Jun 2023 08:03:27 -0700 (PDT)
Received: from [10.11.0.74] (125-228-20-175.hinet-ip.hinet.net. [125.228.20.175])
        by smtp.gmail.com with ESMTPSA id h2-20020a17090a298200b002310ed024adsm1606329pjd.12.2023.06.16.08.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 08:03:27 -0700 (PDT)
Message-ID: <f1662612-ea0b-dd32-1c51-ebfa9c1cf950@sifive.com>
Date:   Fri, 16 Jun 2023 23:03:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v3 00/19] Add RISC-V vector cryptographic instruction set
 support
Content-Language: en-US
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        qemu-devel@nongnu.org
Cc:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org
References: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
 <7f2b7328-8c0b-0664-574f-fcf6fe442b74@ventanamicro.com>
From:   Max Chou <max.chou@sifive.com>
In-Reply-To: <7f2b7328-8c0b-0664-574f-fcf6fe442b74@ventanamicro.com>
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

Hi Daniel,

I'm Max Chou from SiFive, one of the authors of this patchset.

I'll take over to update this patchset to the v20230531 version of the 
RISC-V vector cryptography specification and take the comments from 
Weiwei Li into consideration.
Then I'll re-send, rebased on top of Alistair's riscv-to-apply.next in 
the next few days.

Thanks,

Max

On 2023/6/16 5:21 PM, Daniel Henrique Barboza wrote:
> Hi Lawrence,
>
> Can you please re-send, rebased on top of Alistair's 
> riscv-to-apply.next? There are
> some comments from Weiwei Li that are worth considering. Richard 
> Henderson also took
> patches 8-9-10 via his tcg queue so you don't have to worry about those.
>
> CC my email in the next version and I'll get some reviews going. QEMU 
> feature
> freeze for 8.1 is July 11th - perhaps we can squeeze this in for 8.1.
>
>
> Thanks,
>
> Daniel
>
> On 4/28/23 11:47, Lawrence Hunter wrote:
>> This patchset provides an implementation for Zvbb, Zvbc, Zvkned, 
>> Zvknh, Zvksh, Zvkg, and Zvksed of the draft RISC-V vector 
>> cryptography extensions as per the v20230425 version of the 
>> specification(1) (6a7ae7f2). This is an update to the patchset 
>> submitted to qemu-devel on Monday, 17 Apr 2023 14:58:36 +0100.
>>
>> v2:
>>
>>      squashed commits into one commit per extension with separate 
>> commits for
>>      each refactoring
>>      unified trans_rvzvk*.c.inc files into one trans_rvvk.c.inc
>>      style fixes in insn32.decode and other files
>>      added macros for EGS values in translation functions.
>>      updated from v20230303 to v20230407 of the spec:
>>          Zvkb has been split into Zvbb and Zvbc
>>          vbrev, vclz, vctz, vcpop and vwsll have been added to Zvbb.
>>
>> v3:
>>
>>      New patch 03/19 removes redundant “cpu_vl == 0” checks from 
>> trans_rvv.c.inc
>>      Introduction of new tcg ops has been factored out of patch 11/19 
>> and into 09/19
>>          These ops are now added to non riscv-specific files
>>
>> As v20230425 is a freeze candidate, we are not expecting any 
>> significant changes to the specification or this patch series.
>>
>> Please note that the Zvkt data-independent execution latency 
>> extension (and all extensions including it) has not been implemented, 
>> and we would recommend not using these patches in an environment 
>> where timing attacks are an issue.
>>
>> Work performed by Dickon, Lawrence, Nazar, Kiran, and William from 
>> Codethink sponsored by SiFive, as well as Max Chou and Frank Chang 
>> from SiFive.
>>
>> For convenience we have created a git repo with our patches on top of 
>> a recent master. https://github.com/CodethinkLabs/qemu-ct
>>
>>      https://github.com/riscv/riscv-crypto/releases
>>
>> Thanks to those who have already reviewed:
>>
>>      Richard Henderson richard.henderson@linaro.org
>>          [PATCH v2 02/17] target/riscv: Refactor vector-vector 
>> translation macro
>>          [PATCH v2 04/17] target/riscv: Move vector translation checks
>>          [PATCH v2 05/17] target/riscv: Refactor translation of 
>> vector-widening instruction
>>          [PATCH v2 07/17] qemu/bitops.h: Limit rotate amounts
>>          [PATCH v2 08/17] qemu/host-utils.h: Add clz and ctz 
>> functions for lower-bit integers
>>          [PATCH v2 14/17] crypto: Create sm4_subword
>>      Alistair Francis alistair.francis@wdc.com
>>          [PATCH v2 02/17] target/riscv: Refactor vector-vector 
>> translation macro
>>      Philipp Tomsich philipp.tomsich@vrull.eu
>>          Various v1 reviews
>>      Christoph Müllner christoph.muellner@vrull.eu
>>          Various v1 reviews
>>
>>
>> Dickon Hood (3):
>>    target/riscv: Refactor translation of vector-widening instruction
>>    qemu/bitops.h: Limit rotate amounts
>>    target/riscv: Add Zvbb ISA extension support
>>
>> Kiran Ostrolenk (5):
>>    target/riscv: Refactor some of the generic vector functionality
>>    target/riscv: Refactor vector-vector translation macro
>>    target/riscv: Refactor some of the generic vector functionality
>>    qemu/host-utils.h: Add clz and ctz functions for lower-bit integers
>>    target/riscv: Add Zvknh ISA extension support
>>
>> Lawrence Hunter (2):
>>    target/riscv: Add Zvbc ISA extension support
>>    target/riscv: Add Zvksh ISA extension support
>>
>> Max Chou (3):
>>    crypto: Create sm4_subword
>>    crypto: Add SM4 constant parameter CK
>>    target/riscv: Add Zvksed ISA extension support
>>
>> Nazar Kazakov (6):
>>    target/riscv: Remove redundant "cpu_vl == 0" checks
>>    target/riscv: Move vector translation checks
>>    tcg: Add andcs and rotrs tcg gvec ops
>>    target/riscv: Add Zvkned ISA extension support
>>    target/riscv: Add Zvkg ISA extension support
>>    target/riscv: Expose Zvk* and Zvb[b,c] cpu properties
>>
>>   accel/tcg/tcg-runtime-gvec.c             |   11 +
>>   accel/tcg/tcg-runtime.h                  |    1 +
>>   crypto/sm4.c                             |   10 +
>>   include/crypto/sm4.h                     |    9 +
>>   include/qemu/bitops.h                    |   24 +-
>>   include/qemu/host-utils.h                |   54 ++
>>   include/tcg/tcg-op-gvec.h                |    4 +
>>   target/arm/tcg/crypto_helper.c           |   10 +-
>>   target/riscv/cpu.c                       |   39 +
>>   target/riscv/cpu.h                       |    8 +
>>   target/riscv/helper.h                    |   95 ++
>>   target/riscv/insn32.decode               |   58 ++
>>   target/riscv/insn_trans/trans_rvv.c.inc  |  174 ++--
>>   target/riscv/insn_trans/trans_rvvk.c.inc |  593 ++++++++++++
>>   target/riscv/meson.build                 |    4 +-
>>   target/riscv/op_helper.c                 |    6 +
>>   target/riscv/translate.c                 |    1 +
>>   target/riscv/vcrypto_helper.c            | 1052 ++++++++++++++++++++++
>>   target/riscv/vector_helper.c             |  243 +----
>>   target/riscv/vector_internals.c          |   81 ++
>>   target/riscv/vector_internals.h          |  228 +++++
>>   tcg/tcg-op-gvec.c                        |   23 +
>>   22 files changed, 2365 insertions(+), 363 deletions(-)
>>   create mode 100644 target/riscv/insn_trans/trans_rvvk.c.inc
>>   create mode 100644 target/riscv/vcrypto_helper.c
>>   create mode 100644 target/riscv/vector_internals.c
>>   create mode 100644 target/riscv/vector_internals.h
>>
>
