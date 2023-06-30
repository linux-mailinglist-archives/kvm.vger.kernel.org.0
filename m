Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEAD7441BA
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 20:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjF3SEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 14:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjF3SEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 14:04:14 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F69610F8
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 11:04:13 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2b698dd515dso33687641fa.3
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 11:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688148251; x=1690740251;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uYdGoo2IprrfPMUF4ijD753EkS4/HIm2RYWkY/Jxr5s=;
        b=sQJDPDPhU2yH6TxF/IrqYPa+x/nB9NHhP5ZlgmLDc0NrTPtN6RfViTuwDGygdN4Vlg
         TMfS90ClO96XXxSWl0mIbkPIKDzEtoegAUh8cODszQPcpeYbW+WaX37dwoRIWuPcJR+t
         d80fxgxuomyGG9jujER1E9SG+C9m2C8GsCCOXJwgniprVhvs+JK0QPdw3myFBU7cE8U0
         AgPvlmBHNinIuKuBLbPKUyaU7k0KAOAdEGmxk6NAygQBjlC1mO0Gmgf1QuxZnmBp11qE
         NGkF8UORud38UcyO+Gp1nPTt5imwNgT/6eaEKYgiNdNqUo4Y8r9ahk1uowm+W8OS9rUH
         vmYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688148251; x=1690740251;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uYdGoo2IprrfPMUF4ijD753EkS4/HIm2RYWkY/Jxr5s=;
        b=O7oiMPv24Br5gFpLr/OjIIZlxRfQ0RHAF/Aeennot/IC3dhHb1xgxdNmQwJCowURKQ
         olxfUAn658UwbaCN/6RBGQYpJef8R95d9bdjizq7/hKbPWoJvykbj7pPFxTQaXlA/YKn
         FHqXS2owtAw/Um5/fNHPFxVXIyT5QneYyy55lLkZz/K06d9/KHEx4/2gPP92Jn4dFTTY
         5SBfYfVsgrLKGXpn8aab2taKSNgddPIb7TXwUx1Il7EjbBfMN5SUGmvIJCvjelfrLF7o
         zhoVbBdrwiVjUl7M4LElC6eA3YM8OW8q/4kXD3YHbYm3/S9FGhUnyWmAWK6xRSn9MPm8
         WO0A==
X-Gm-Message-State: ABy/qLY3aP6e+8p6vCtvjSW3Wssli2vDbo4QvEYI7KzLzS1rXK8YLcZ6
        k2I2+MxMbG+QlYf3hzzFhAGg6jI+p1BsP2Zvp6PSFA==
X-Google-Smtp-Source: APBJJlEtwaUdbybFWqQjeuK+sGhxwAg1iNgt4IfVkag0T/duKX4X+vo+xgVFLbleKQ4zuteEzNZdIE7/+bycQNdjoZw=
X-Received: by 2002:a2e:980c:0:b0:2b4:8168:2050 with SMTP id
 a12-20020a2e980c000000b002b481682050mr2486687ljj.29.1688148251192; Fri, 30
 Jun 2023 11:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com> <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com> <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
 <ZJ74gELkj4DgAk4S@google.com> <CAL715WL9T8Ucnj_1AygwMgDjOJrttNZHRP9o-KUNfpx1aYZnog@mail.gmail.com>
 <CALMp9eSQ9uRBVdLDkfCdPbprZ45LpdZY5-5O9i41oJYs-dK7+Q@mail.gmail.com> <CAL715WJDjox6AOU=gzN_E-VPL8aXMuD+SkN3k18T=imoS_dKaw@mail.gmail.com>
In-Reply-To: <CAL715WJDjox6AOU=gzN_E-VPL8aXMuD+SkN3k18T=imoS_dKaw@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 30 Jun 2023 11:03:34 -0700
Message-ID: <CAL715WJfOXOovUJSBtC0SfXVTuXEXwRF3sQBUzGaPDXe99dRoQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
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

> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 48a0528080ab..8d28158e58f2 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -322,7 +322,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
>         if (!pmc_event_is_allowed(pmc))
>                 goto reprogram_complete;
>
> -       if (pmc->counter < pmc->prev_counter)
> +       if (pmc->counter == 0)
>                 __kvm_perf_overflow(pmc, false);
>
>         if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
>
> Since this is software emulation, we (KVM) should only handle overflow
> by plusing one?

Sign. Please ignore this as it is not only hacky but also not working.
