Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58CF5399DC
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 01:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348592AbiEaXAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 19:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346457AbiEaXAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 19:00:43 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7588D698
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 16:00:42 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id t144so385424oie.7
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 16:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eJ24BACjbDHvthbMgm4XcuH4zJHXMsFnkczDnEhJpgc=;
        b=UBtRp3WpXKuh4/WKxp0nVJHD5gvhgnq+eNJ/fO3ud3ddLXWLPFRQrRoVXxcE2KueBX
         L6nSzzB3fkj9/C/O/j2Sv7bm8uTC+mQJGv+JB0Ye6L5sLj3CpCZWllcZC4iDwX111HSZ
         BsVyQDcpMNXUviN/JvhMefXXABPdZoN29CjAcx81JI8xUzeIyJd12Cv02tHku5BmZD+n
         m84JkHnhJfZnx9ObxGjcAyupvI12SYYw44mctqa3zoL+yKb9YiQcOKK2lCRqttVWD2qU
         9pPZ+Xev5NJQHl6NGIG9bk8hTaXduAfsT8b4ktpdL+BYug+9dTdKDNNHZQTubz809+Cd
         etvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eJ24BACjbDHvthbMgm4XcuH4zJHXMsFnkczDnEhJpgc=;
        b=pwDujYMMXQwTgajJ3D/szmRgH60ABAS2x2ank+6DER4sKsNmCErYAPInbasY/6kk3x
         b4FrjOSRUSeI1TBhklk6zvb8DHurAhT556l2CNHeOTC1by6SZKPlS6zrYLp1VENfUOjk
         Xx6IXtItVJ2lnJhkKQ9QPve3g65H/m+c5ucajYsObZRH9oj+klAjltpPNVGflucosaBc
         OdhEXLuzpZXu0Q6mOAzMIx5tRyDtCHpzdsXaEI1NMAmYhQt/boQI+bUjXEMba3Sgnj7h
         knBT9SbFd9CX8fgHJOMN7yeuZB514Bo7Y+qqLaUtIOEmfmvqD/6vTdZXZWJA5Y0zJf16
         0IRA==
X-Gm-Message-State: AOAM532+wx+FrcF+EaGWQrr6bspoAEF2HINLrCS6AtVHwoS66GWGa1Hb
        aqxvqPpSCOERyeb6aP/eJyVIhWA9Zdvm6IgSwgOLVQ==
X-Google-Smtp-Source: ABdhPJzTTWc73ximZkQFkN2gkYfd+ahEmzA7PN27k5b+sHnaNFd+LGh12QSDr90VunGkhbmdoDFJIc3CGa9vr961AdQ=
X-Received: by 2002:a05:6808:13c4:b0:32a:f1cb:fc12 with SMTP id
 d4-20020a05680813c400b0032af1cbfc12mr13896481oiw.13.1654038041657; Tue, 31
 May 2022 16:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QXUfFksVLF=gzU3EYkyf7RQKvr5_FU6Ea5enf39vinY3A@mail.gmail.com>
In-Reply-To: <CAGG=3QXUfFksVLF=gzU3EYkyf7RQKvr5_FU6Ea5enf39vinY3A@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 31 May 2022 16:00:30 -0700
Message-ID: <CALMp9eQNmxscE1iMCV=ibF9zQ5E+CYGbfjV6vYtL-ddOECrDXw@mail.gmail.com>
Subject: Re: [kvm-unit-tests RFC] Inlining in PMU Test
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 6:32 PM Bill Wendling <morbo@google.com> wrote:
>
> I'm into an issue when I compile kvm-unit-tests with a new-ish Clang
> version. It results in a failure similar to this:
>
> Serial contents after VMM exited:
> SeaBIOS (version 1.8.2-20160510_123855-google)
> Total RAM Size = 0x0000000100000000 = 4096 MiB
> CPU Mhz=2000
> CPUs found: 1     Max CPUs supported: 1
> Booting from ROM...
> enabling apic
> paging enabled
> cr0 = 80010011
> cr3 = bfefc000
> cr4 = 20
> PMU version:         4
> GP counters:         3
> GP counter width:    48
> Mask length:         7
> Fixed counters:      3
> Fixed counter width: 48
>  ---8<---
> PASS: all counters
> FAIL: overflow: cntr-0
> PASS: overflow: status-0
> PASS: overflow: status clear-0
> PASS: overflow: irq-0
> FAIL: overflow: cntr-1
> PASS: overflow: status-1
> PASS: overflow: status clear-1
> PASS: overflow: irq-1
> FAIL: overflow: cntr-2
> PASS: overflow: status-2
> PASS: overflow: status clear-2
> PASS: overflow: irq-2
> FAIL: overflow: cntr-3
> PASS: overflow: status-3
> PASS: overflow: status clear-3
> PASS: overflow: irq-3
>  ---8<---
>
> It turns out that newer Clangs are much more aggressive at inlining
> than GCC. I could replicate this failure with GCC with the patch
> below[1] (the patch probably isn't minimal). If I add the "noinline"
> attribute "measure()" in the patch below, the test passes.
>
> Is there a subtle assumption being made by the test that breaks with
> aggressive inlining? If so, is adding the "noinline" attribute to
> "measure()" the correct fix, or should the test be made more robust?

It's not all that subtle. :-)

The test assumes that every invocation of measure() will retire the
same number of instructions over the part of measure() where a PMC is
programmed to count instructions retired.

To set up PMC overflow, check_counter_overflow() first records the
number of instructions retired in an invocation of measure(). That
value is stored in 'count.' Then, it initializes a PMC to (1 - count),
and it invokes measure() again. It expects that 'count' instructions
will have been retired, and the PMC will now have the value '1.'

If the first measure() and the second measure() are different code
sequences, this doesn't work.

Adding 'noinline' to measure() is probably the right thing to do.
