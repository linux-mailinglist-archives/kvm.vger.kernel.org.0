Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F31A6C3130
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 13:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjCUMC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 08:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjCUMC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 08:02:58 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E8E4AFF2
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 05:02:49 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id t15so13391213wrz.7
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 05:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google; t=1679400168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTVMP5CWDZSChcBlwLBScmxhwJu3q0YBdvBg2oyne9M=;
        b=LvrQDE3nDrU8JnbtSn+F/ehFEi6zwZs8mQBjVwvaO38j1qJ7QAw5eHxQlNIoo2MwSm
         TkL+BWWyR6imrqtw5RgTUZ7Ifj49yFYd5dTY0M0PWZfl9U3KOzOYyGXJyeUjebUPC8FE
         pluW9hNAmWJesME+J61sqng4NyfBv9dkRMrfNu7R/s29/DbrSOpvudsZZWmaMJj8dl+j
         nsDd5m9t5UT5ZFvYbfoetObelrWoa90iJvO365/UkQkbTOkDSmaoTE9+I+dAilDtEKj5
         1fjkE7mngHxnBAOHv5eOfGu5QQJWreKJnWY8fT/P+exEtXRCrZJ9KZqs9XLv4MHGwsJ4
         bQOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679400168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OTVMP5CWDZSChcBlwLBScmxhwJu3q0YBdvBg2oyne9M=;
        b=48mNV6CFuoFvpLkArtCWIObH5FaKdjotrOCPgn2rgGSP7/cjV4KSV2/VBsszZ7sseP
         ERUvtN3wQIOVcFD+KM8UiBr50iRx+SH16KNlRUMpIrv9Vn6VUZdOAO2kNgc8HjnmASnv
         gcvsM4Y8BzUM0jJCz4nsWBDgaEAAZzvUKxMfCZTzyik2grn2+PjMQ20zRsFZLRVOMCdR
         Xg5zUy/VbufBPp3H8rQAiqXD2o83Q5u8BELS+em1QoRyw/3c7bzK57mVgtPTAPazSU8h
         fvxlOfYZ6f9FusjX9tbFg7p5RUXHWIQupdx6m3+3vS/nilloC4//5nvg4Ykaf9Y9V3Vn
         CKLA==
X-Gm-Message-State: AO0yUKX9qqg9ev2kSRZ9+CdVzn0ZY5Bly0opxGxtPeHlNDJWDJ/tDzgu
        2xJ0uhX0WKCMC5a1LOlixN2qYUOAlLWXiVlBVCoVlg==
X-Google-Smtp-Source: AK7set8mHb8tF1n0BLg6HeZ1BSpksACXCj0hD6C8cgZSIAg1bqRgTPWPq2QPyGHNT5vrf+J0kHmd2Tp2lgTRPOePDaU=
X-Received: by 2002:a5d:58f2:0:b0:2d3:c90e:88c3 with SMTP id
 f18-20020a5d58f2000000b002d3c90e88c3mr563814wrd.13.1679400167991; Tue, 21 Mar
 2023 05:02:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
In-Reply-To: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
From:   =?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>
Date:   Tue, 21 Mar 2023 13:02:36 +0100
Message-ID: <CAEg0e7iXkPcqAhZH0xxbMyXVP6hnk5vvtUW52qT_2rFDK3PVcQ@mail.gmail.com>
Subject: Re: [PATCH 00/45] Add RISC-V vector cryptographic instruction set support
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Cc:     qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 10:16=E2=80=AFAM Lawrence Hunter
<lawrence.hunter@codethink.co.uk> wrote:
>
> This patchset provides an implementation for Zvkb, Zvkned, Zvknh, Zvksh, =
Zvkg, and Zvksed of the draft RISC-V vector cryptography extensions as per =
the 20230303 version of the specification(1) (1fcbb30). Please note that th=
e Zvkt data-independent execution latency extension has not been implemente=
d, and we would recommend not using these patches in an environment where t=
iming attacks are an issue.
>
> Work performed by Dickon, Lawrence, Nazar, Kiran, and William from Codeth=
ink sponsored by SiFive, as well as Max Chou and Frank Chang from SiFive.
>
> For convenience we have created a git repo with our patches on top of a r=
ecent master. https://github.com/CodethinkLabs/qemu-ct

I did test and review this patchset.
Since most of my comments affect multiple patches I have summarized
them here in one email.
Observations that only affect a single patch will be sent in response
to the corresponding email.

I have tested this series with the OpenSSL PR for Zvk that can be found her=
e:
  https://github.com/openssl/openssl/pull/20149
I ran with all Zvk* extensions enabled (using Zvkg for GCM) and with
Zvkb only (using Zvkb for GCM).
All tests succeed. Note, however, that the test coverage is limited
(e.g. no .vv instructions, vstart is always zero).

When sending out a follow-up version (even if it just introduces a minimal =
fix),
then consider using patchset versioning (e.g. git format-patch -v2 ...).

It might be a matter of taste, but I would prefer a series that groups
and orders the commits differently:
  a) independent changes to the existing code (refactoring only, but
no new features) - one commit per topic
  b) introduction of new functionality - one commit per extension
A series using such a commit granularity and order would be easier to
maintain and review (and not result in 45 patches).
Also, the refactoring changes could land before Zvk freezes if
maintainers decide to do so.

So far all translation files in target/riscv/insn_trans/* contain
multiple extensions if they are related.
I think we should follow this pattern and use a common trans_zvk.c.inc file=
.

All patches to insn32.decode have comments of the form "RV64 Zvk*
vector crypto extension".
What is the point of the "RV64"? I would simply remove that.

All instructions set "env->vstart =3D 0;" at the end.
I don't think that this is correct (the specification does not require this=
).

The tests of the reserved encodings are not consistent:
* Zvknh does a dynamic test (query tcg_gen_*())
* Zvkned does a dynamic test (tcg_gen_*())
* Zvkg does not test for (vl%EGS =3D=3D 0)
The vl CSR can only be updated by the vset{i}vl{i} instructions.
The same applies to the vstart CSR and the vtype CSR that holds vsew,
vlmul and other fields.
The current code tests the VSTART/SEW value using "s->vstart % 4 =3D=3D
0"/"s->sew =3D=3D MO_32".
Why is it not possible to do the same with VL, i.e. "s->vl % 4 =3D=3D 0"
(after adding it to DisasContext)?
Also, I would introduce named constants or macros for the EGS values
to avoid magic constants in the code
(some extensions do that - e.g. ZVKSED_EGS).

BR
Christoph


>
> 1. https://github.com/riscv/riscv-crypto/releases
>
>
> Dickon Hood (2):
>   qemu/bitops.h: Limit rotate amounts
>   target/riscv: Add vrol.[vv,vx] and vror.[vv,vx,vi] decoding,
>     translation and execution support
>
> Kiran Ostrolenk (8):
>   target/riscv: Refactor some of the generic vector functionality
>   target/riscv: Refactor some of the generic vector functionality
>   target/riscv: Refactor some of the generic vector functionality
>   target/riscv: Refactor some of the generic vector functionality
>   target/riscv: Add vsha2ms.vv decoding, translation and execution
>     support
>   target/riscv: Add zvksh cpu property
>   target/riscv: Add vsm3c.vi decoding, translation and execution support
>   target/riscv: Expose zvksh cpu property
>
> Lawrence Hunter (17):
>   target/riscv: Add vclmul.vv decoding, translation and execution
>     support
>   target/riscv: Add vclmul.vx decoding, translation and execution
>     support
>   target/riscv: Add vclmulh.vv decoding, translation and execution
>     support
>   target/riscv: Add vclmulh.vx decoding, translation and execution
>     support
>   target/riscv: Add vaesef.vv decoding, translation and execution
>     support
>   target/riscv: Add vaesef.vs decoding, translation and execution
>     support
>   target/riscv: Add vaesdf.vv decoding, translation and execution
>     support
>   target/riscv: Add vaesdf.vs decoding, translation and execution
>     support
>   target/riscv: Add vaesdm.vv decoding, translation and execution
>     support
>   target/riscv: Add vaesdm.vs decoding, translation and execution
>     support
>   target/riscv: Add vaesz.vs decoding, translation and execution support
>   target/riscv: Add vsha2c[hl].vv decoding, translation and execution
>     support
>   target/riscv: Add vsm3me.vv decoding, translation and execution
>     support
>   target/riscv: Add zvkg cpu property
>   target/riscv: Add vgmul.vv decoding, translation and execution support
>   target/riscv: Add vghsh.vv decoding, translation and execution support
>   target/riscv: Expose zvkg cpu property
>
> Max Chou (5):
>   crypto: Create sm4_subword
>   crypto: Add SM4 constant parameter CK
>   target/riscv: Add zvksed cfg property
>   target/riscv: Add Zvksed support
>   target/riscv: Expose Zvksed property
>
> Nazar Kazakov (10):
>   target/riscv: Add zvkb cpu property
>   target/riscv: Add vrev8.v decoding, translation and execution support
>   target/riscv: Add vandn.[vv,vx] decoding, translation and execution
>     support
>   target/riscv: Expose zvkb cpu property
>   target/riscv: Add zvkned cpu property
>   target/riscv: Add vaeskf1.vi decoding, translation and execution
>     support
>   target/riscv: Add vaeskf2.vi decoding, translation and execution
>     support
>   target/riscv: Expose zvkned cpu property
>   target/riscv: Add zvknh cpu properties
>   target/riscv: Expose zvknh cpu properties
>
> William Salmon (3):
>   target/riscv: Add vbrev8.v decoding, translation and execution support
>   target/riscv: Add vaesem.vv decoding, translation and execution
>     support
>   target/riscv: Add vaesem.vs decoding, translation and execution
>     support
>
>  accel/tcg/tcg-runtime-gvec.c                 |   11 +
>  accel/tcg/tcg-runtime.h                      |    1 +
>  crypto/sm4.c                                 |   10 +
>  include/crypto/sm4.h                         |    9 +
>  include/qemu/bitops.h                        |   24 +-
>  target/arm/tcg/crypto_helper.c               |   10 +-
>  target/riscv/cpu.c                           |   36 +
>  target/riscv/cpu.h                           |    7 +
>  target/riscv/helper.h                        |   71 ++
>  target/riscv/insn32.decode                   |   49 +
>  target/riscv/insn_trans/trans_rvv.c.inc      |   93 +-
>  target/riscv/insn_trans/trans_rvzvkb.c.inc   |  220 ++++
>  target/riscv/insn_trans/trans_rvzvkg.c.inc   |   40 +
>  target/riscv/insn_trans/trans_rvzvkned.c.inc |  170 +++
>  target/riscv/insn_trans/trans_rvzvknh.c.inc  |   84 ++
>  target/riscv/insn_trans/trans_rvzvksed.c.inc |   57 +
>  target/riscv/insn_trans/trans_rvzvksh.c.inc  |   43 +
>  target/riscv/meson.build                     |    4 +-
>  target/riscv/op_helper.c                     |    5 +
>  target/riscv/translate.c                     |    6 +
>  target/riscv/vcrypto_helper.c                | 1001 ++++++++++++++++++
>  target/riscv/vector_helper.c                 |  240 +----
>  target/riscv/vector_internals.c              |   81 ++
>  target/riscv/vector_internals.h              |  222 ++++
>  24 files changed, 2192 insertions(+), 302 deletions(-)
>  create mode 100644 target/riscv/insn_trans/trans_rvzvkb.c.inc
>  create mode 100644 target/riscv/insn_trans/trans_rvzvkg.c.inc
>  create mode 100644 target/riscv/insn_trans/trans_rvzvkned.c.inc
>  create mode 100644 target/riscv/insn_trans/trans_rvzvknh.c.inc
>  create mode 100644 target/riscv/insn_trans/trans_rvzvksed.c.inc
>  create mode 100644 target/riscv/insn_trans/trans_rvzvksh.c.inc
>  create mode 100644 target/riscv/vcrypto_helper.c
>  create mode 100644 target/riscv/vector_internals.c
>  create mode 100644 target/riscv/vector_internals.h
>
> --
> 2.39.2
>
>
