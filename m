Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB15ECED7
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 22:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiI0Uo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 16:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiI0UoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 16:44:25 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F146E10FE3C
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 13:44:23 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id o2so17405054lfc.10
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 13:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=fR1WfPLFGveMpcbeOBBo1cFw9wNYbgOtXOXOngyKU9w=;
        b=qMSmNa0P0X9WFe0FrjmtvYsiyb25KIngX/6tiIo2rAHGB16kTowfl+2DZEQhN0G3UC
         qZ1S+4rfDTL3SzJqaLL9XnlJUP/D8UEqf/1YYt7uj1HLW1rZxw/pA7kCckKKx2r+HLyE
         /nAt61QJ/37k/LHQxWs+B39T4eHpAHQ2RAZMuiGFqz3ck4DoY+qoCq3Ikv3Gbx0RV27c
         GploQ3wbj3rc7cF5V5HOUErLANZ0BiQjFPAflnYUucW7Yhxt0Fo/Fta0G/lFLtvZCd9M
         s8R43Bkq9Hd2WRwPirPB3EL9fztwroY+VUPk06wGLUs4pjLfKV5eT5UUFaGAttdRrMbG
         i4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=fR1WfPLFGveMpcbeOBBo1cFw9wNYbgOtXOXOngyKU9w=;
        b=Cp7cqhhQWeDbSvPH28qKLzWt2fnk63TW1jlPJMTxdLBLIYVokGFysrGz8cJw/Tbvhf
         xTY+5ubAEXoIGTJmJB39VtiiDrrb8F7GrBEdA2Y4MiR/7a9TD2XiJkkwrzfqyUw7CBp7
         u9W9McMDb3SEUbx1D+D4LugYpXP3MSObWBWjMofhzhSB4W5z9MP8g/R5ZPolvYcUncvb
         gExds2uVqbH4UbH8iFhVWNV0XW1qXiJ06+6UAonL/Ez6+EwjbxUJcNjx+Mv+ogwfL9zH
         eac1SBmRHmUf7wrLdP7PPPky7Ct4Ax2jn3B8xyQEyPlI1+W4u4niwLj8ZY0WGnPtMhQV
         9dXg==
X-Gm-Message-State: ACrzQf15nsVboYkj0UfIK3H4rPHGH33ihDED3Bp7Xr5m9+fletIhigOJ
        w1MmgYA9hyzBkD6MZNfEhnTYI5mvEvUH/HwsWnTBUg==
X-Google-Smtp-Source: AMsMyM5O/ekKBcuYgT6piRVyUJnrl8rvJ+2GF9Z9LyMe+zykZZUVaPeWUwoGNy7bE0bv2+HGaj6BI6jKUL5AwN6ji+k=
X-Received: by 2002:ac2:5469:0:b0:497:ed1:97c6 with SMTP id
 e9-20020ac25469000000b004970ed197c6mr11203880lfn.248.1664311462027; Tue, 27
 Sep 2022 13:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220927190515.984143-1-dmatlack@google.com>
In-Reply-To: <20220927190515.984143-1-dmatlack@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 27 Sep 2022 13:43:45 -0700
Message-ID: <CAHVum0exrpHNmNBkepgbB4C18NWcu--+VQj46Zr-rGoi11=gBg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: selftests: Gracefully handle empty stack traces
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

On Tue, Sep 27, 2022 at 12:05 PM David Matlack <dmatlack@google.com> wrote:
>
> Bail out of test_dump_stack() if the stack trace is empty rather than
> invoking addr2line with zero addresses. The problem with the latter is
> that addr2line will block waiting for addresses to be passed in via
> stdin, e.g. if running a selftest from an interactive terminal.
>
> Opportunistically fix up the comment that mentions skipping 3 frames
> since only 2 are skipped in the code, and move the call to backtrace()
> down to where it is used.
>
> Cc: Vipin Sharma <vipinsh@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
> v2:
>  - Move backtrace() down to where it is used [Vipin]
>  - Change "stack trace empty" to "stack trace missing" [me]
>
> v1: https://lore.kernel.org/kvm/20220922231724.3560211-1-dmatlack@google.com/
>
>  tools/testing/selftests/kvm/lib/assert.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
> index 71ade6100fd3..7b92d1aaeda6 100644
> --- a/tools/testing/selftests/kvm/lib/assert.c
> +++ b/tools/testing/selftests/kvm/lib/assert.c
> @@ -38,16 +38,23 @@ static void test_dump_stack(void)
>                  1];
>         char *c;
>
> -       n = backtrace(stack, n);
>         c = &cmd[0];
>         c += sprintf(c, "%s", addr2line);
> +
>         /*
> -        * Skip the first 3 frames: backtrace, test_dump_stack, and
> -        * test_assert. We hope that backtrace isn't inlined and the other two
> -        * we've declared noinline.
> +        * Skip the first 2 frames, which should be test_dump_stack() and
> +        * test_assert(); both of which are declared noinline. Bail if the
> +        * resulting stack trace would be empty. Otherwise, addr2line will block
> +        * waiting for addresses to be passed in via stdin.
>          */
> +       n = backtrace(stack, n);
> +       if (n <= 2) {
> +               fputs("  (stack trace missing)\n", stderr);
> +               return;
> +       }
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

Reviewed-by: Vipin Sharma <vipinsh@google.com>
