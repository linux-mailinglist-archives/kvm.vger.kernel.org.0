Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C2177EFBB
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 06:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347965AbjHQEGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 00:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348016AbjHQEGA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 00:06:00 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C49271D
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 21:05:59 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-31783d02093so6309895f8f.0
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 21:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrtc27.com; s=gmail.jrtc27.user; t=1692245157; x=1692849957;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RPAvUFmMc6MHYhPtcS+J2Wjm5R9zwPAqvH6XS/X0hao=;
        b=DOx//VT3uLRhMKZN1gvZ1e26MR0GD7yjJ1Uh+tgiJ+j0T+pf111e0oMTmi8jmQJZxn
         Xfo8mfRy6RIEBDYYhD2/32oqIKdUL649MurhO4POndlvLkJ3bM9V+USg+Hrx/Z+kexZq
         7hvC/W+pUlWMG4lleGbE3G20NaHhNwpnf7dB+1T1n2inx09RFpX+CK9hjSjieUkelE9T
         jwHmeU1WHzYErWj/Tch/cK2mM8RN5N+xMiY3xnehx8OSGnTIYFMW8vk068IC8r8uvwaD
         0v6Pw/SGwnilyihfyQTh19Fp3SFjpw9jocPMNod+RiquXGvkiyBSgAsaRMlSCzZd5/96
         71ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692245157; x=1692849957;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RPAvUFmMc6MHYhPtcS+J2Wjm5R9zwPAqvH6XS/X0hao=;
        b=XNSg6dHrXVN0wDpv3rs5PMu0q58ThuoMDuTvVSXxZC75cqVM2jtcOtiG2C95iFpgWM
         ZVkJDvBwIal54LAhuxFYP1e95py385DW0uR/O4nmXDu5Qvq7lLfZlwWmH49/GTP3HPqv
         KJFB326Jf57ZSIgFvkAXqdtBdNa0ScIZkMVTdMEpet5OQeLYA1XmEenBxVE7Ejp6UrsN
         9K54ASlkqA4GKorzgZ6qdR1JtWHmkE48IwVVq3STnH2RPOtcF7gx33SI2QGygPTwGIRM
         Pr1BMOjrZy+VWxnYLuR+bPJdv6AeCz0wDPE6rgURECz45KxjyAA3wX4JCyCYtKz7GD+P
         3OAw==
X-Gm-Message-State: AOJu0Ywt9kF9ymGIeVfPuN4db8a5d+7ERRvEruL8OFAPfdh06f1wdsJJ
        4QAjgR4xxP0x1h8WBsAh6SJKBUzyWD26Pmeeh7neXg==
X-Google-Smtp-Source: AGHT+IG7M1cue9DEYwFoKSeGNCqOcVuwwMifdF7sqjo7y0IqOhjGcIK5XPaod2BNxeerL82qeVFCEA==
X-Received: by 2002:a05:6000:cd:b0:317:5e5e:60e0 with SMTP id q13-20020a05600000cd00b003175e5e60e0mr2939290wrx.28.1692245157358;
        Wed, 16 Aug 2023 21:05:57 -0700 (PDT)
Received: from smtpclient.apple ([131.111.5.246])
        by smtp.gmail.com with ESMTPSA id j2-20020adfff82000000b003195504c754sm21581512wrr.31.2023.08.16.21.05.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Aug 2023 21:05:57 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH 00/10] RISC-V: Refactor instructions
From:   Jessica Clarke <jrtc27@jrtc27.com>
In-Reply-To: <12FAB5A9-5723-4A5B-8729-75D8A38921B9@jrtc27.com>
Date:   Thu, 17 Aug 2023 05:05:45 +0100
Cc:     Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, bpf@vger.kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <46884D2C-F3AA-4A83-8295-AE5C0F58FE13@jrtc27.com>
References: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
 <20230804-2c57bddd6e87fdebc20ff9d5@orel> <ZM00UYDzEAz/JT3n@ghost>
 <ZN1qXlLp6qfpBeGF@ghost> <12FAB5A9-5723-4A5B-8729-75D8A38921B9@jrtc27.com>
To:     Charlie Jenkins <charlie@rivosinc.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17 Aug 2023, at 04:57, Jessica Clarke <jrtc27@jrtc27.com> wrote:
>=20
> On 17 Aug 2023, at 01:31, Charlie Jenkins <charlie@rivosinc.com> =
wrote:
>>=20
>> On Fri, Aug 04, 2023 at 10:24:33AM -0700, Charlie Jenkins wrote:
>>> On Fri, Aug 04, 2023 at 12:28:28PM +0300, Andrew Jones wrote:
>>>> On Thu, Aug 03, 2023 at 07:10:25PM -0700, Charlie Jenkins wrote:
>>>>> There are numerous systems in the kernel that rely on directly
>>>>> modifying, creating, and reading instructions. Many of these =
systems
>>>>> have rewritten code to do this. This patch will delegate all =
instruction
>>>>> handling into insn.h and reg.h. All of the compressed =
instructions, RVI,
>>>>> Zicsr, M, A instructions are included, as well as a subset of the =
F,D,Q
>>>>> extensions.
>>>>>=20
>>>>> ---
>>>>> This is modifying code that =
https://lore.kernel.org/lkml/20230731183925.152145-1-namcaov@gmail.com/
>>>>> is also touching.
>>>>>=20
>>>>> ---
>>>>> Testing:
>>>>>=20
>>>>> There are a lot of subsystems touched and I have not tested every
>>>>> individual instruction. I did a lot of copy-pasting from the =
RISC-V spec
>>>>> so opcodes and such should be correct
>>>>=20
>>>> How about we create macros which generate each of the functions an
>>>> instruction needs, e.g. riscv_insn_is_*(), etc. based on the output =
of
>>>> [1]. I know basically nothing about that project, but it looks like =
it
>>>> creates most the defines this series is creating from what we =
[hope] to
>>>> be an authoritative source. I also assume that if we don't like the
>>>> current output format, then we could probably post patches to the =
project
>>>> to get the format we want. For example, we could maybe propose an =
"lc"
>>>> format for "Linux C".
>>> That's a great idea, I didn't realize that existed!
>> I have discovered that the riscv-opcodes repository is not in a state
>> that makes it helpful. If it were workable, it would make it easy to
>> include a "Linux C" format. I have had a pull request open on the =
repo
>> for two weeks now and the person who maintains the repo has not
>> interacted.
>=20
> Huh? Andrew has replied to you twice on your PR, and was the last one =
to
> comment. That=E2=80=99s hardly =E2=80=9Chas not interacted=E2=80=9D.
>=20
>> At minimum, in order for it to be useful it would need an ability to
>> describe the bit order of immediates in an instruction and include =
script
>> arguments to select which instructions should be included. There is a
>> "C" format, but it is actually just a Spike format.
>=20
> So extend it? Or do something with QEMU=E2=80=99s equivalent that =
expresses it.

Note that every field already identifies the bit order (or, for the
case of compressed instructions, register restrictions) since that=E2=80=99=
s
needed to produce the old LaTeX instruction set listings; that=E2=80=99s =
why
there=E2=80=99s jimm20 vs imm20, for example. One could surely encode =
that in
Python and generate the LaTeX strings from the Python, making the
details of the encodings available elsewhere. Or just have your own
mapping from name to whatever you need. But, either way, the
information should all be there today in the input files, it=E2=80=99s =
just a
matter of extending the script to produce whatever you want from them.

> Jess
>=20
>> Nonetheless, it
>> seems like it is prohibitive to use it.
>>>>=20
>>>> I'd also recommend only importing the generated defines and =
generating
>>>> the functions that will actually have immediate consumers or are =
part of
>>>> a set of defines that have immediate consumers. Each consumer of =
new
>>>> instructions will be responsible for generating and importing the =
defines
>>>> and adding the respective macro invocations to generate the =
functions.
>>>> This series can also take that approach, i.e. convert one set of
>>>> instructions at a time, each in a separate patch.
>>> Since I was hand-writing everything and copying it wasn't too much
>>> effort to just copy all of the instructions from a group. However, =
from
>>> a testing standpoint it makes sense to exclude instructions not yet =
in
>>> use.
>>>>=20
>>>> [1] https://github.com/riscv/riscv-opcodes
>>>>=20
>>>> Thanks,
>>>> drew
>>>>=20
>>>>=20
>>>>> , but the construction of every
>>>>> instruction is not fully tested.
>>>>>=20
>>>>> vector: Compiled and booted
>>>>>=20
>>>>> jump_label: Ensured static keys function as expected.
>>>>>=20
>>>>> kgdb: Attempted to run the provided tests but they failed even =
without
>>>>> my changes
>>>>>=20
>>>>> module: Loaded and unloaded modules
>>>>>=20
>>>>> patch.c: Ensured kernel booted
>>>>>=20
>>>>> kprobes: Used a kprobing module to probe jalr, auipc, and branch
>>>>> instructions
>>>>>=20
>>>>> nommu misaligned addresses: Kernel boots
>>>>>=20
>>>>> kvm: Ran KVM selftests
>>>>>=20
>>>>> bpf: Kernel boots. Most of the instructions are exclusively used =
by BPF
>>>>> but I am unsure of the best way of testing BPF.
>>>>>=20
>>>>> Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
>>>>>=20
>>>>> ---
>>>>> Charlie Jenkins (10):
>>>>>     RISC-V: Expand instruction definitions
>>>>>     RISC-V: vector: Refactor instructions
>>>>>     RISC-V: Refactor jump label instructions
>>>>>     RISC-V: KGDB: Refactor instructions
>>>>>     RISC-V: module: Refactor instructions
>>>>>     RISC-V: Refactor patch instructions
>>>>>     RISC-V: nommu: Refactor instructions
>>>>>     RISC-V: kvm: Refactor instructions
>>>>>     RISC-V: bpf: Refactor instructions
>>>>>     RISC-V: Refactor bug and traps instructions
>>>>>=20
>>>>> arch/riscv/include/asm/bug.h             |   18 +-
>>>>> arch/riscv/include/asm/insn.h            | 2744 =
+++++++++++++++++++++++++++---
>>>>> arch/riscv/include/asm/reg.h             |   88 +
>>>>> arch/riscv/kernel/jump_label.c           |   13 +-
>>>>> arch/riscv/kernel/kgdb.c                 |   13 +-
>>>>> arch/riscv/kernel/module.c               |   80 +-
>>>>> arch/riscv/kernel/patch.c                |    3 +-
>>>>> arch/riscv/kernel/probes/kprobes.c       |   13 +-
>>>>> arch/riscv/kernel/probes/simulate-insn.c |  100 +-
>>>>> arch/riscv/kernel/probes/uprobes.c       |    5 +-
>>>>> arch/riscv/kernel/traps.c                |    9 +-
>>>>> arch/riscv/kernel/traps_misaligned.c     |  218 +--
>>>>> arch/riscv/kernel/vector.c               |    5 +-
>>>>> arch/riscv/kvm/vcpu_insn.c               |  281 +--
>>>>> arch/riscv/net/bpf_jit.h                 |  707 +-------
>>>>> 15 files changed, 2825 insertions(+), 1472 deletions(-)
>>>>> ---
>>>>> base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
>>>>> change-id: 20230801-master-refactor-instructions-v4-433aa040da03
>>>>> --=20
>>>>> - Charlie
>>>>>=20
>>>>>=20
>>>>> --=20
>>>>> kvm-riscv mailing list
>>>>> kvm-riscv@lists.infradead.org
>>>>> http://lists.infradead.org/mailman/listinfo/kvm-riscv
>>=20
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv


