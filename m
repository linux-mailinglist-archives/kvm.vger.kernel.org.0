Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B762174CDBA
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 08:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjGJG4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 02:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjGJG4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 02:56:15 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7F5B3
        for <kvm@vger.kernel.org>; Sun,  9 Jul 2023 23:56:14 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-576a9507a9bso77254017b3.1
        for <kvm@vger.kernel.org>; Sun, 09 Jul 2023 23:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688972173; x=1691564173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIZnG0LouIQZjqRz+SIomv2vPH1oYn8qw1pvTL+LDa0=;
        b=Bg8KShzTguoo3F507gjl1vaFOdNVU/hYrnbc+P0bB/vU3um8bz4YLbSKsDD80GsqQT
         pMJEajKiwn/5Z6mO964rKFnQwrWZMfp92xq3jbCTcU1LORNUzZWx3CV/uYfpduBjn7hO
         YrDhU5xeWVeCf0fZ6N0q3PARIgQZ1Y2T9Z2gmf9RYFSt3DtjxCqQR5YSjPGIMAGfPb2J
         bcUWgtZo+m0vdy1exKpeOfVzPuJyfnjf/k0HB1iKm2lWJzvsXG8mjqpjUkxu3PMYd5gV
         XeoSj985OeEXBkqZ2KDamGUH2YgJyOXiCa7bSCfTA2Pk574c83j7Oi5A4aQEqAOoGUuS
         cwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688972173; x=1691564173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIZnG0LouIQZjqRz+SIomv2vPH1oYn8qw1pvTL+LDa0=;
        b=kyETosjuT3ZLmCsx950tYdeaHn4DsbrKdJiI03c8pzX6YYHchr/6XRYlo5BxV2ei08
         kMX5mTrnmr25i9YiYzBZmNQRa7RDle3SC2Gha0fNct6a+wwTXFRZ9catpgh8ZusFcsbO
         B8MFo5DCp2F18BEWC/gl1eUXWOwl0HHzAAV0aV7sCDNMozUAePc175sofmFRbcKiLIbf
         8JfyHkAFyuXCOp5QKLHdLhGohvGlGBGAw2WwHK8RV3T899J9KlSJ6JcIKAoBQwSHZ1ei
         zd3Gh9OQha5ZjPjQ1Dth/cJsZzjgjRgKGyxMUDruY5L+D9mxn0ch2D6NSRd9fcYeSbW2
         mHUA==
X-Gm-Message-State: ABy/qLaBaenPRiBUkc9smOw5pV9zTHNstpyCqDibEsOOjRJ2j4Q9mJUn
        qF2xswaLPkjcFrxxFu7Rogml7vTii/1o/+lPitkDEQ==
X-Google-Smtp-Source: APBJJlEVFucf7hdAyHsheRqw2r+BqCRoQRABvUDVm9kfCJHaD24AGS2FLHBod6XQ1R3owKoOymSqfFWTpN2K0MW1g+o=
X-Received: by 2002:a81:4e4d:0:b0:579:de63:3486 with SMTP id
 c74-20020a814e4d000000b00579de633486mr8875941ywb.5.1688972173615; Sun, 09 Jul
 2023 23:56:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230707151119.81208-1-alexandru.elisei@arm.com>
In-Reply-To: <20230707151119.81208-1-alexandru.elisei@arm.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Mon, 10 Jul 2023 12:26:02 +0530
Message-ID: <CAK9=C2X-pdVtV8Zr8hOGm=nKTUCzva-2+58UVQBiOd6+oqya-w@mail.gmail.com>
Subject: Re: [PATCH kvmtool v2 0/4] Add --loglevel argument
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 7, 2023 at 8:41=E2=80=AFPM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> kvmtool can be unnecessarily verbose at times, and Will proposed in a cha=
t
> we had a while ago to add a --loglevel command line argument to choose
> which type of messages to silence. This is me taking a stab at it.
>
> Build tested for all arches and run tested lightly on a rockpro64 and my
> x86 machine.
>
> Base commit is 3b1cdcf9e78f ("virtio/vhost: Clear VIRTIO_F_ACCESS_PLATFOR=
M").
>
> Changelog in each patch.
>
> Alexandru Elisei (4):
>   util: Make pr_err() return void
>   Replace printf/fprintf with pr_* macros
>   util: Use __pr_debug() instead of pr_info() to print debug messages
>   Add --loglevel argument for the run command

Looks good for KVMTOOL RISC-V.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

>
>  arm/gic.c            |  5 ++--
>  builtin-run.c        | 69 ++++++++++++++++++++++++++++++--------------
>  builtin-setup.c      | 16 +++++-----
>  guest_compat.c       |  2 +-
>  include/kvm/util.h   | 14 ++++++---
>  kvm-cpu.c            | 12 ++++----
>  mmio.c               |  2 +-
>  util/parse-options.c | 28 ++++++++++--------
>  util/util.c          | 27 +++++++++++++++--
>  9 files changed, 116 insertions(+), 59 deletions(-)
>
> --
> 2.41.0
>
