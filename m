Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253115A82DE
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiHaQR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiHaQR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:17:26 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8D4CEB36
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:17:25 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-11f11d932a8so16851737fac.3
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=686yqyz15WcAe19p1RSiWp4rGukhfeVW4c13nzq/ZBg=;
        b=pzHklyjlaVKSVk0F7QkOvEokdGUn1nAa+C+rU2Zpt3LfdREQD/SLrqB62f1qrxBYGt
         asVopJVcz3cvPhGY8DRimPwTooiNgRJXfElx6H9tV5JB3AGGOSYli58E02woQ8IZyFFG
         WVHO6J7VO82IbW63UU4mLZywmaqrqrcNF2Qn76/PMZ/A5q/keO58rXQQZDqtNu9UkVgF
         Gc8vbBA54Gm3MxCqeTmJu/leG48+TeC7kzR4YgJ+AIFE/hVWdArSgjtzEU6tjGXFOBG4
         cNxwGyk5M/p63hIWqbm6fIMYtRNeN2WY1baxt+TODYoFW2Evs0gL0cPf6iVs0Gsk88Nw
         J/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=686yqyz15WcAe19p1RSiWp4rGukhfeVW4c13nzq/ZBg=;
        b=7l98G6i9hwU/br85oex1Fx/wwPTrWyYwll+sR3AmlBlAnQrrKcgNLAyfdURS5NH67j
         wCyxLbfmKQ1L5v5fcxCpc9+/K/YvFE3juVdIQpKD+Ssu1G2fzIl3Q7ATKw6MrXfjgIXM
         z98u9UxPhntEEvcRMepXrBxqaAg6TWhlD6MeRKJ3+gMkblP4kfxdLPO9FJxvKreNJjap
         iTEwT58YV9sV3i/SLqvoXK4Tw5BfNZDh9keW+6vXJLGPYJpBA3A8ACOGtjv+F8v7U9LZ
         s/MlrnfENgHpoSRfEPw/rhBsojMWYA9BS3XSNndI+8f6oxjJmWP8gR4sgig2q5LLG61t
         kujA==
X-Gm-Message-State: ACgBeo39y88ecP6GMfb+P1aIB8M/pBU3ujOxDkX11DiCEIbd6cJ5nGjQ
        oDXRilNqwf1V5Jww6QAhlBID646QX+z/2eMKKLjfJw==
X-Google-Smtp-Source: AA6agR4Klh8aMsFIsvjGYZiAAcmTScaNnG3yfe9Ho+c99cPGWW3sFacLNoQfpvuitCb2L2Rmr40M6d7wF+cvtUcgGPg=
X-Received: by 2002:aca:170f:0:b0:343:171f:3596 with SMTP id
 j15-20020aca170f000000b00343171f3596mr1491289oii.181.1661962644939; Wed, 31
 Aug 2022 09:17:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220831143150.304406-1-cui.jinpeng2@zte.com.cn>
In-Reply-To: <20220831143150.304406-1-cui.jinpeng2@zte.com.cn>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 31 Aug 2022 09:17:14 -0700
Message-ID: <CALMp9eT1yz0q1xn2nPtKBbnx_ixX4ivFk=qOayz70k_hxooaoQ@mail.gmail.com>
Subject: Re: [PATCH linux-next] KVM: selftests: remove redundant variable tsc_val
To:     cgel.zte@gmail.com
Cc:     pbonzini@redhat.com, shuah@kernel.org, seanjc@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
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

On Wed, Aug 31, 2022 at 7:31 AM <cgel.zte@gmail.com> wrote:
>
> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
>
> Return value directly from expression instead of
> getting value from redundant variable tsc_val.

Nit: I think you mean 'superfluous' rather than 'redundant'?

> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 0cbc71b7af50..75920678f34d 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -237,7 +237,6 @@ static inline uint64_t get_desc64_base(const struct desc64 *desc)
>  static inline uint64_t rdtsc(void)
>  {
>         uint32_t eax, edx;
> -       uint64_t tsc_val;
>         /*
>          * The lfence is to wait (on Intel CPUs) until all previous
>          * instructions have been executed. If software requires RDTSC to be
> @@ -245,8 +244,8 @@ static inline uint64_t rdtsc(void)
>          * execute LFENCE immediately after RDTSC
>          */
>         __asm__ __volatile__("lfence; rdtsc; lfence" : "=a"(eax), "=d"(edx));
> -       tsc_val = ((uint64_t)edx) << 32 | eax;
> -       return tsc_val;
> +
> +       return ((uint64_t)edx) << 32 | eax;
>  }

This does beg the question: "Why?"
