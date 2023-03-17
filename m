Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3500D6BEF28
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 18:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCQRGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 13:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjCQRFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 13:05:45 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5056D3BC5A
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 10:05:21 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-536af432ee5so106504157b3.0
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 10:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679072720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFnOJ5LuKHmOyMvm2OqEa+8kheq2ORsU1yGkgX6NxSs=;
        b=awiejcVT3NtjE0Ko5FlZGis/mZm+5yuLoA91/HP6ebhWkW3Kah0s+C2GZXN8Ish/H+
         6SYAkqZ2/TseaDkMorXt8AwGlq6YkvMzqV87eUzcf5/oYp5VX3laT9Md3dLcSavg2Mcm
         4H2k2z1W2zhlULD0HJa126jtvsxc36QKJQmMHLhoO0/ndSb8SkZJzDQBZ0q4w/2gq7VQ
         WQ0PFhhMG3jpU22Uwl001bBPcBZ7aJ+6EiUbdaNQ6RrQReOTqoALcYcgXi1ZhQNszu0K
         rgiVOqT/gcI4DO4k+GXIhav0v8eINifiRQsmnJQsFChHRqDorf+t58VcxwdI0YO3e6xo
         nApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679072720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFnOJ5LuKHmOyMvm2OqEa+8kheq2ORsU1yGkgX6NxSs=;
        b=YO+m3zRgXuUPyw6/uuuOMncwwpXGRAYFgJcVGWqT0q7EYpZq35d6NPjUs+/voGC69N
         8mj4AM1GWgJ+jLflz6SNUUKctXmeCz+NDPkBEL0CJt3gI8AnMNjzu4cwm2ZQpZDsv9HQ
         RJ6Sce+WJj/HYwj2YiWd7M+GlL0Ff43qSg1FQMTlsYtd1WbOz6qR1Tq+9qGd0I1Y7vw5
         j+U77vXA5qmNi1oSWcKYqhWYWE/Sih8y1uH/fEbq0yINrUizNFFxWzRbiRUHSRk+ZJ2N
         ZCi2mkAduCmLhAygB8uqOuZLXq62wOBlj3nOOiAd/aKFbIblq3HYLt2we27AG5W7NBix
         dtZQ==
X-Gm-Message-State: AO0yUKVWOAob8B4cf3TLouthCBsitfDm5e4yJT51dPPu/C/03VkyODmF
        dshSyPQXR0vSpbK8dZn7yIh2x7NZDNLlOHOYeo0IIA==
X-Google-Smtp-Source: AK7set//QAk4aSOFhrr3SxZVO3ksc023SPy4sQoFHdqMA1mGTlXnNkFpaQvCaIuc543hMBCKQfBJttutWUiaG79gI24=
X-Received: by 2002:a81:d84d:0:b0:541:69bc:8626 with SMTP id
 n13-20020a81d84d000000b0054169bc8626mr4949791ywl.10.1679072719598; Fri, 17
 Mar 2023 10:05:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230316222752.1911001-1-coltonlewis@google.com> <20230316222752.1911001-2-coltonlewis@google.com>
In-Reply-To: <20230316222752.1911001-2-coltonlewis@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 17 Mar 2023 10:04:43 -0700
Message-ID: <CAHVum0diwWqa38naQaybdJVszKHcxPiHj8a7T305h2TNER35Ew@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: Provide generic way to read system counter
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Mar 16, 2023 at 3:29=E2=80=AFPM Colton Lewis <coltonlewis@google.co=
m> wrote:
>
> Provide a generic function to read the system counter from the guest
> for timing purposes. A common and important way to measure guest
> performance is to measure the amount of time different actions take in
> the guest. Provide also a mathematical conversion from cycles to
> nanoseconds and a macro for timing individual statements.
>
> Substitute the previous custom implementation of a similar function in

May be specify specific name:  guest_read_system_counter()

> system_counter_offset_test with this new implementation.
>
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 15 ++++++++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 30 +++++++++++++++++++
>  .../kvm/system_counter_offset_test.c          | 10 ++-----
>  3 files changed, 47 insertions(+), 8 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index c9286811a4cb..8b478eabee4c 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -10,4 +10,19 @@
>  #include "kvm_util_base.h"
>  #include "ucall_common.h"
>
> +#if defined(__aarch64__) || defined(__x86_64__)
> +
> +uint64_t cycles_read(void);
> +double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles);
> +
> +#define MEASURE_CYCLES(x)                      \
> +       ({                                      \
> +               uint64_t start;                 \
> +               start =3D cycles_read();          \
> +               x;                              \
> +               cycles_read() - start;          \
> +       })
> +

MEASURE_CYCLES should be moved to the next patch where it is getting
used. Does it have to be macro or can it be replaced with a function?

> +#endif
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 3ea24a5f4c43..780481a92efe 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2135,3 +2135,34 @@ void __attribute((constructor)) kvm_selftest_init(=
void)
>
>         kvm_selftest_arch_init();
>  }
> +
> +#if defined(__aarch64__)
> +
> +#include "arch_timer.h"
> +
> +uint64_t cycles_read(void)
> +{
> +       return timer_get_cntct(VIRTUAL);
> +}
> +
> +double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles)
> +{
> +       return cycles * (1e9 / timer_get_cntfrq());
> +}
> +
> +#elif defined(__x86_64__)
> +
> +#include "processor.h"
> +
> +uint64_t cycles_read(void)
> +{
> +       return rdtsc();
> +}
> +
> +double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles)
> +{
> +       uint64_t tsc_khz =3D __vcpu_ioctl(vcpu, KVM_GET_TSC_KHZ, NULL);
> +
> +       return cycles * (1e9 / (tsc_khz * 1000));
> +}
> +#endif

As Andrew noted,  these should be in the respective processor files.
