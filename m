Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7C65EB280
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 22:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiIZUnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 16:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiIZUms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 16:42:48 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60361AD98C
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 13:42:19 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q17so8766515lji.11
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 13:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=eWz7y4gqTrIdFN6xc5A1usZceMWXooafBiB+O1iMCiw=;
        b=kDlAe2LJCiG9zhqZzWWNXR6TmaeUeVewZJeQfpYwd6LjCpm3hTeZbhb58CjJBGocuH
         tsS9Y5ggpNz6TAo9SV2tkZKUkCKau3tfrhVSW/XLB1JDB7HB4l3sEqLinsdsEgeTJ/zi
         Yp+81eXcRg9M7XRIJlaJwwWhSD0AKsV3XoEbD5IGJYewnWrzYPVm4eNwPHf+/zpKHuQk
         v86xcfqQyusE8/PZWwYJ1A5Ej38aKkX6K84QPJnXTz/dp+Ar4obQRdmW3IMeqQHJ5O9G
         EsrLxTCshVWnK2Z2k4nCLLbr6WH/7t4LwgRkSqXUc2olU2k3zggbGcZohAhCglWdtKOF
         01Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=eWz7y4gqTrIdFN6xc5A1usZceMWXooafBiB+O1iMCiw=;
        b=YzczSqYzDAThFZATkNRrfnU5olxf7aDJbSZggY2QeirD0i3calWvOTIfHuWCntEaIi
         n6Hcruc5QMsKXXztAvo19JWUcksT5dQY5wvsuJ8XOastbB22sNoB/z8bUymbtqv/eNLx
         TS5CE/Q0IcFwG0EE8L4jkCs/bwiKaUo3q5mHu5ck3yrcd3bYseUbFEGLHAtgj8gaicdK
         QKi/bUKYjqAjTnuCq9QHkKMeH8+qRyMhSExuDxEWdSUyHYRy2zkT2r4oBdo6jIJ5RD0+
         bUuPmI5lx0UopGxwE3CJc1/o8SYV5kQR5YxsVTT1Sb05NnyGhhKVA8zug32l8jJoP4Vc
         29UA==
X-Gm-Message-State: ACrzQf3s/41Xp2UVofkGNbIp5oeaqvKuOOHXt8q4YJSf7poShgCn4H4N
        1bikFEuXOiXZ28PW0FHDAJrLvrplyxYNwYDHg8Zuiw==
X-Google-Smtp-Source: AMsMyM5WOHAjzROdaEqpfPFJf9/YcVg4kYX0KGB/bTCl40GOgkIHkXio1a9CJbGz4O9/oqXQ18B/7h6wZINlYAOjEEg=
X-Received: by 2002:a2e:84ca:0:b0:25d:77e0:2566 with SMTP id
 q10-20020a2e84ca000000b0025d77e02566mr8779969ljh.78.1664224936638; Mon, 26
 Sep 2022 13:42:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220922231724.3560211-1-dmatlack@google.com>
In-Reply-To: <20220922231724.3560211-1-dmatlack@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 26 Sep 2022 13:41:40 -0700
Message-ID: <CAHVum0cBvORZo1k0p2MQVZQ8tLddpjOmDrmfV19zuTLUYMjrpA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Gracefully handle empty stack traces
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 4:17 PM David Matlack <dmatlack@google.com> wrote:
>
> Bail out of test_dump_stack() if the stack trace is empty rather than
> invoking addr2line with zero addresses. The problem with the latter is
> that addr2line will block waiting for addresses to be passed in via
> stdin, e.g. if running a selftest from an interactive terminal.
>
> Opportunistically fix up the comment that mentions skipping 3 frames
> since only 2 are skipped in the code.
>
> Cc: Vipin Sharma <vipinsh@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/kvm/lib/assert.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
> index 71ade6100fd3..c1ce54a41eca 100644
> --- a/tools/testing/selftests/kvm/lib/assert.c
> +++ b/tools/testing/selftests/kvm/lib/assert.c
> @@ -42,12 +42,18 @@ static void test_dump_stack(void)
>         c = &cmd[0];
>         c += sprintf(c, "%s", addr2line);
>         /*
> -        * Skip the first 3 frames: backtrace, test_dump_stack, and
> -        * test_assert. We hope that backtrace isn't inlined and the other two
> -        * we've declared noinline.
> +        * Skip the first 2 frames, which should be test_dump_stack() and
> +        * test_assert(); both of which are declared noinline.  Bail if the
> +        * resulting stack trace would be empty. Otherwise, addr2line will block
> +        * waiting for addresses to be passed in via stdin.
>          */
> +       if (n <= 2) {
> +               fputs("  (stack trace empty)\n", stderr);
> +               return;
> +       }

Shouldn't this condition be put immediately after
        n = backtrace(stack,n)

It is more natural to check the return value when an API has returned.

Verified that this change does fix the issue. Thanks for the fix.

>         for (i = 2; i < n; i++)
>                 c += sprintf(c, " %lx", ((unsigned long) stack[i]) - 1);
> +
>         c += sprintf(c, "%s", pipeline);
>  #pragma GCC diagnostic push
>  #pragma GCC diagnostic ignored "-Wunused-result"
>
> base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
> prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
> prerequisite-patch-id: 1a148d98d96d73a520ed070260608ddf1bdd0f08
> --
> 2.37.3.998.g577e59143f-goog
>
