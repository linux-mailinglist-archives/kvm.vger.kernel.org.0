Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0900B6C66BF
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 12:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCWLg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 07:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCWLgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 07:36:55 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E6BDB
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:36:52 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l37so295869wms.2
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google; t=1679571411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ecGNG+73mRrWxMLCOH2Kb9ZFh8TRWD8c8oO8EeShaR0=;
        b=oABH3RdL3jBZD0XerI7w50YgmT3GH6DaEHqb9/QxYTCmxzFQhtkdd+uOig2S0Kotu8
         5R2bTX01tbNiOvJX2pQf+nf84PqcAVnMvVJ7Qu+HE8CNAWxPuyKRQqUkpvJVkR9rwQUf
         3pTsLGf/tk0X+AGm1fByr1T9xyosz2bUE1ILJ2y3AqswThWrwL3cwp9Cfckd3PHYgf0Z
         2uQLMCL0bNARo4F4Vpp3STeL09KUOOAyVpMczB+LmtQEn4AVz7MLhk6gnr1DUhKRMILF
         Jm/gGT/bpWnwfh5zRraCeNQ2QQ5+z7P8U5drjrU3sEewoNP1Y1xgb0i9aKtC5Qcb67vl
         uxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679571411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ecGNG+73mRrWxMLCOH2Kb9ZFh8TRWD8c8oO8EeShaR0=;
        b=fBYZT3jzqPF2UxsvwBUIMCGcN/UJGrvMbObeJEhLtCdwX+ROls/ZR0vaYpL8b/hp7J
         xzldJXzWbPVojy8bZfFkbOWnP5hQk5ThHEdP6toS3alrAXJAV6VEN0fFFfSAPLBje3lr
         2H4FTiBv6n6eSOw8QRNN4VYBxFLbxYVH+j/sD7cZl0+/9TjDk4OtBTJ/cuLZr17CWsJP
         yv3Rsx1Jt3qiltppKyCToP3LJEBmYstakpZpKt+RW7VyN5o7Unc3DzukfJWC6a3xumE/
         xdW0Jze5vwcFOK6Zojp5YdtQwShYrRuuVHeAjw2a3xq+tGDDOIN+MjW6bSp1ibtCbRhy
         U/+A==
X-Gm-Message-State: AO0yUKUOTS6VBeMoJhRYLjd3+fvyM9+yHfiKXwXdTGOgCCV+aKkU4JXZ
        U8VYKRWcZkTBPMTw/z2L9Je363gUFkIm9KAqrxQVfw==
X-Google-Smtp-Source: AK7set9UthFeVTobRAjOxEUgZAyIOY+EHG/Tin4sk4CjAF9THs9tZu70/W60YzSLgJD/wYdFYIsCXCkvOPsR1fzEv0E=
X-Received: by 2002:a7b:c3c1:0:b0:3ea:8ed9:5f3e with SMTP id
 t1-20020a7bc3c1000000b003ea8ed95f3emr653847wmj.4.1679571410968; Thu, 23 Mar
 2023 04:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
 <CAEg0e7iXkPcqAhZH0xxbMyXVP6hnk5vvtUW52qT_2rFDK3PVcQ@mail.gmail.com> <4b21e3316c50763d0fbe273a59bc985c@codethink.co.uk>
In-Reply-To: <4b21e3316c50763d0fbe273a59bc985c@codethink.co.uk>
From:   =?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>
Date:   Thu, 23 Mar 2023 12:36:37 +0100
Message-ID: <CAEg0e7ju=cyTxHbuxnYK4M_HpxNqk3RxuAV62kGWiXBUR7MPaA@mail.gmail.com>
Subject: Re: [PATCH 00/45] Add RISC-V vector cryptographic instruction set support
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Cc:     qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 12:34=E2=80=AFPM Lawrence Hunter
<lawrence.hunter@codethink.co.uk> wrote:
>
> On 21/03/2023 12:02, Christoph M=C3=BCllner wrote:
> > On Fri, Mar 10, 2023 at 10:16=E2=80=AFAM Lawrence Hunter
> > <lawrence.hunter@codethink.co.uk> wrote:
> >>
> >> This patchset provides an implementation for Zvkb, Zvkned, Zvknh,
> >> Zvksh, Zvkg, and Zvksed of the draft RISC-V vector cryptography
> >> extensions as per the 20230303 version of the specification(1)
> >> (1fcbb30). Please note that the Zvkt data-independent execution
> >> latency extension has not been implemented, and we would recommend not
> >> using these patches in an environment where timing attacks are an
> >> issue.
> >>
> >> Work performed by Dickon, Lawrence, Nazar, Kiran, and William from
> >> Codethink sponsored by SiFive, as well as Max Chou and Frank Chang
> >> from SiFive.
> >>
> >> For convenience we have created a git repo with our patches on top of
> >> a recent master. https://github.com/CodethinkLabs/qemu-ct
> >
> > I did test and review this patchset.
> > Since most of my comments affect multiple patches I have summarized
> > them here in one email.
> > Observations that only affect a single patch will be sent in response
> > to the corresponding email.
> >
> > I have tested this series with the OpenSSL PR for Zvk that can be found
> > here:
> >    https://github.com/openssl/openssl/pull/20149
> > I ran with all Zvk* extensions enabled (using Zvkg for GCM) and with
> > Zvkb only (using Zvkb for GCM).
> > All tests succeed. Note, however, that the test coverage is limited
> > (e.g. no .vv instructions, vstart is always zero).
> >
> > When sending out a follow-up version (even if it just introduces a
> > minimal fix),
> > then consider using patchset versioning (e.g. git format-patch -v2
> > ...).
>
> Ok, will do
>
> > It might be a matter of taste, but I would prefer a series that groups
> > and orders the commits differently:
> >    a) independent changes to the existing code (refactoring only, but
> > no new features) - one commit per topic
> >    b) introduction of new functionality - one commit per extension
> > A series using such a commit granularity and order would be easier to
> > maintain and review (and not result in 45 patches).
> > Also, the refactoring changes could land before Zvk freezes if
> > maintainers decide to do so.
>
> Makes sense, will do
>
> > So far all translation files in target/riscv/insn_trans/* contain
> > multiple extensions if they are related.
> > I think we should follow this pattern and use a common trans_zvk.c.inc
> > file.
>
> Agree, will do
>
> > All patches to insn32.decode have comments of the form "RV64 Zvk*
> > vector crypto extension".
> > What is the point of the "RV64"? I would simply remove that.
>
> Ok, will remove it
>
> > All instructions set "env->vstart =3D 0;" at the end.
> > I don't think that this is correct (the specification does not require
> > this).
>
> That's from vector spec: "All vector instructions are defined to begin
> execution with the element number given in the vstart CSR, leaving
> earlier elements in the destination vector undisturbed, and to reset the
> vstart CSR to zero at the end of execution." - from "3.7. Vector Start
> Index CSR vstart"

Yes, you are right.
I just created a PR for the Zvk* spec to clarify this:
  https://github.com/riscv/riscv-crypto/pull/308

>
> > The tests of the reserved encodings are not consistent:
> > * Zvknh does a dynamic test (query tcg_gen_*())
> > * Zvkned does a dynamic test (tcg_gen_*())
> > * Zvkg does not test for (vl%EGS =3D=3D 0)
>
> Zvkg also does dynamic test, by calling macros GEN_V_UNMASKED_TRANS and
> GEN_VV_UNMASKED_TRANS
>
> > The vl CSR can only be updated by the vset{i}vl{i} instructions.
> > The same applies to the vstart CSR and the vtype CSR that holds vsew,
> > vlmul and other fields.
> > The current code tests the VSTART/SEW value using "s->vstart % 4 =3D=3D
> > 0"/"s->sew =3D=3D MO_32".
> > Why is it not possible to do the same with VL, i.e. "s->vl % 4 =3D=3D 0=
"
> > (after adding it to DisasContext)?
>
> vl can also be updated by another instruction - from vector spec "3.5.
> Vector Length Register vl" - "The XLEN-bit-wide read-only vl CSR can
> only be updated by the vset{i}vl{i} instructions, and the
> fault-only-first vector load instruction variants." So just because of
> that fault-only-first instruction we need dynamic checks.
>
> vstart is just another CSR -- software can write to it, but probably
> shouldn't.  Whether that's ever going to be useful outside testing ISA
> conformance tests or not I don't know, but it's clearly read-write (also
> section 3.7).
>
> > Also, I would introduce named constants or macros for the EGS values
> > to avoid magic constants in the code
> > (some extensions do that - e.g. ZVKSED_EGS).
>
> Makes sense, will do
>
> Best,
> Lawrence
