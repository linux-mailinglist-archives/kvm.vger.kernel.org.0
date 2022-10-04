Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10205F411F
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 12:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiJDKxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 06:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiJDKxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 06:53:36 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762F711448
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 03:53:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id f1so10506390ejw.7
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 03:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Kpr+mrMrUQdkMJEhiv+SFh/OrvTKodmrvfpQjEfgfn8=;
        b=dMEUSEhPJSTOWFW3fZq0MJAhwejlXm+cde6mvgLeWXYox1JlE/QtkV+G9RlZCrQ9dR
         6wGx1eFGmA+sIqSi9IufI+thDnlKP9kMpbU+r8zNK6oVwoJUCjz98iE0V1bD6F5BdUeN
         273KYjYw8NtgLJrrsqrZFJftB9gvSeLg3dPydF7nL5vMUdchQSC2/yS8m3EToGg8m5ZO
         uzkH0ICgbnHKr2hEh7Yn/W1iMXqDo6SW+ib2UBX/D+f8OOvrTcLvB306kDbT8HwUwUaF
         A1xYpM7C3Fj+K0xsFUq1nPP+LMKiYEXz+B73O1TbMBA1SN5Vc0+uM6TGNfAnCZw2ekqL
         8HJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Kpr+mrMrUQdkMJEhiv+SFh/OrvTKodmrvfpQjEfgfn8=;
        b=1B0otsppDkK81YX2wpUdjzAaR0s7rof1jCXB5ao3VLRKN72+FG0D8Zg21+x5u5t1pB
         JjzopGRxfr7e1y9E/clct2uKVY0jSruqqP6BWrJyUlCCXLCE/j40S0K5Lgtr3Nze6JD1
         3LG0eUlhpttM6/XCgvcRHEwgkIt6galgYoNY4xrZFrDKpqVRfXJHXlFFDQxjYuGqHPnw
         rl8Hf96EVez08xWcCbk+75NQh3/cnl/NQ/a7AY51kZBEOoRp4fS3Quvh9Zrns+vawosL
         XZvbTYxsy+EJsbklSM9xVvhHPpBksQIL1VdYc0UETZythf6FZRUrGOaFwFgnfS7fDvSO
         LDCA==
X-Gm-Message-State: ACrzQf0lkDIDCYV/AEZLoHo2kYhzHuv2IE1EZtW6q5nfr5Hrnbicm3JT
        UNrlOIXhGny4Yl1fM6DcG6b/Tc3MYrYcnbbxiIihOmZGs0Q=
X-Google-Smtp-Source: AMsMyM5kJpSL758b27/OfCCBDLYfam4LM2nL8cqTs9ozZffOQGjTIOVCC2Rc9YPGS3GZ3wWhhO+oyBLJ4MYrip82ICI=
X-Received: by 2002:a17:907:2bd5:b0:76f:591c:466b with SMTP id
 gv21-20020a1709072bd500b0076f591c466bmr18007019ejc.504.1664880814044; Tue, 04
 Oct 2022 03:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <YziPyCqwl5KIE2cf@zx2c4.com> <20221003103627.947985-1-Jason@zx2c4.com>
 <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org> <CAHmME9pUuduiEcmi2xaY3cd87D_GNX1bkVeXNqVq6AL_e=Kt+Q@mail.gmail.com>
 <YzwM+KhUG0bg+P2e@zx2c4.com>
In-Reply-To: <YzwM+KhUG0bg+P2e@zx2c4.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 4 Oct 2022 11:53:22 +0100
Message-ID: <CAFEAcA9KsooNnYxiqQG-RHustSx0Q3-F8ibpQbXbwxDCA+2Fhg@mail.gmail.com>
Subject: Re: [PATCH v2] mips/malta: pass RNG seed to to kernel via env var
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Oct 2022 at 11:40, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> And just to give you some idea that this truly is possible from firmware
> and I'm not just making it up, consider this patch to U-Boot:
>
> u-boot:
> diff --git a/arch/mips/lib/bootm.c b/arch/mips/lib/bootm.c
> index cab8da4860..27f3ee68c0 100644
> --- a/arch/mips/lib/bootm.c
> +++ b/arch/mips/lib/bootm.c
> @@ -211,6 +211,8 @@ static void linux_env_legacy(bootm_headers_t *images)
>                 sprintf(env_buf, "%un8r", gd->baudrate);
>                 linux_env_set("modetty0", env_buf);
>         }
> +
> +       linux_env_set("rngseed", "4142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60");
>  }
>

>
> So, as you can see, it works perfectly. Thus, setting this in QEMU
> follows *exactly* *the* *same* *pattern* as every other architecture
> that allows for this kind of mechanism. There's nothing weird or unusual
> or out of place happening here.

I think the unusual thing here is that this patch isn't
"this facility is implemented by u-boot [commit whatever,
docs whatever], and here is the patch adding it to QEMU's
handling of the same interface". That is, for boards like
Malta the general expectation is that we're emulating
a piece of real hardware and the firmware/bootloader
that it would be running, so "this is a patch that
implements an interface that the real bootloader doesn't
have" is a bit odd.

thanks
-- PMM
