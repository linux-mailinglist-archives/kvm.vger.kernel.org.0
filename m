Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3B05EB576
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 01:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiIZXTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 19:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiIZXSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 19:18:52 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E06B40F7
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 16:18:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f23so7583871plr.6
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 16:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=SIAPwLGrdF6de2sUvVzEsUXI67gCH9gi2KlqfGNRtvk=;
        b=PiwXiRi6C5W9sHwMs6AfMS2o9JzPIAHf0vDUDJ4gQ4sXVlaTML3wMo++n6LPbexjxG
         yg+3HFqUSr7IIk+GDWu3bk261jQmKuSUpnrjAeXgsQ1fqp2oldn6BXZHs5IPKkBQdm4c
         jnBFOuGs7aTKI7SMJ6LBaNzvjg9tAMuWhXKOGN0ZdgF8r1WtCYP2z41AgLNbGUoZHtXh
         K32XsFj7suJJr0vWAZFCww+Umdo1J5TA0yuR8gTn5cPhzkJ0ycEMDffQ0ZLU+l7yh75b
         yK1F5yOF8lNeNKC0134uIKJ/DVxvCQ6kuXkK/aqJkCL6DGzU8g4G88Y2tXr1kimfhyEG
         jtRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=SIAPwLGrdF6de2sUvVzEsUXI67gCH9gi2KlqfGNRtvk=;
        b=qMmMQ6D98KaLqCz+CaazJUHZEV/TSkjuwsY6InlIPNbntB2vVuGRT8G2hn620GrC1V
         JqJi2XlRoSnKD4jjKHAxynX99lpaMVuX31+ewVJSeOO08JWkF0SOUiCYfl2bScBSbnym
         agQqvQLGoZcOocnzf0xRmtFkxRBRbga8HQDwIZxV7HnVt6zLzlrAdSo30vMnahlRcwbS
         1FylfKpbRjGyYZhPy0B+U58rPaulR9yHjuKFZj3VLk86BO1fpJSGqcPkiieHvkO1YTfa
         sOf4yWRn7nXT/n0bpStRfJVZJynhIzrR8Gf5R2Vw7Biz2zDDSHojJ9oVcdXhFAD1CTvo
         +4og==
X-Gm-Message-State: ACrzQf05mHBRJ8KvP0ii8fkfpmytXLHQE/wC8nHRPpaswBN4V/1Rox5k
        uthDBcZ8Q3lZPix6n8UXQCCq4qaUSyE18K9F9ys7qg==
X-Google-Smtp-Source: AMsMyM4SkUxm44J+T/UiQPpnhjOvmdzF9n1exmwexp+ZbQb4Ohl0IC1hqh5nzSJYdV402K/a4YDOMEG53gH7uD32kgM=
X-Received: by 2002:a17:902:d143:b0:178:456b:8444 with SMTP id
 t3-20020a170902d14300b00178456b8444mr24452996plt.137.1664234330087; Mon, 26
 Sep 2022 16:18:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220915000448.1674802-1-vannapurve@google.com>
 <20220915000448.1674802-3-vannapurve@google.com> <20220915094442.45eldu4bes5alacm@kamzik>
In-Reply-To: <20220915094442.45eldu4bes5alacm@kamzik>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Mon, 26 Sep 2022 16:18:39 -0700
Message-ID: <CAGtprH-PWxLTVVZQoe3kbqBdW0dMh4djOXH0cPWfVkWxu0QjHg@mail.gmail.com>
Subject: Re: [V2 PATCH 2/8] KVM: selftests: Add arch specific initialization
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     x86 <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>
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

On Thu, Sep 15, 2022 at 2:44 AM Andrew Jones <andrew.jones@linux.dev> wrote:
>
> On Thu, Sep 15, 2022 at 12:04:42AM +0000, Vishal Annapurve wrote:
> > Introduce arch specific API: kvm_selftest_arch_init to allow each arch to
> > handle initialization before running any selftest logic.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h      |  5 +++++
> >  .../selftests/kvm/lib/aarch64/processor.c      | 18 +++++++++---------
> >  tools/testing/selftests/kvm/lib/kvm_util.c     |  2 ++
> >  .../selftests/kvm/lib/riscv/processor.c        |  4 ++++
> >  .../selftests/kvm/lib/s390x/processor.c        |  4 ++++
> >  .../selftests/kvm/lib/x86_64/processor.c       |  4 ++++
> >  6 files changed, 28 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 24fde97f6121..98edbbda9f97 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -834,4 +834,9 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
> >       return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
> >  }
> >
> > +/*
> > + * API to execute architecture specific setup before executing selftest logic.
> > + */
> > +void kvm_selftest_arch_init(void);
> > +
> >  #endif /* SELFTEST_KVM_UTIL_BASE_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 6f5551368944..2281d6c5d02f 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -495,15 +495,6 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
> >       close(kvm_fd);
> >  }
> >
> > -/*
> > - * arm64 doesn't have a true default mode, so start by computing the
> > - * available IPA space and page sizes early.
> > - */
> > -void __attribute__((constructor)) init_guest_modes(void)
> > -{
> > -       guest_modes_append_default();
> > -}
> > -
> >  void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> >              uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
> >              uint64_t arg6, struct arm_smccc_res *res)
> > @@ -528,3 +519,12 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> >                      [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
> >                    : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
> >  }
> > +
> > +/*
> > + * arm64 doesn't have a true default mode, so start by computing the
> > + * available IPA space and page sizes early.
> > + */
>
> It'd be better to move this comment inside the function above the
> guest_modes_append_default call.
>

Ack, will fix this in the next series.
> > +void kvm_selftest_arch_init(void)
> > +{
> > +     guest_modes_append_default();
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 3c83838999f5..dafe4471a6c7 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -1984,4 +1984,6 @@ void __attribute((constructor)) kvm_selftest_init(void)
> >  {
> >       /* Tell stdout not to buffer its content. */
> >       setbuf(stdout, NULL);
> > +
> > +     kvm_selftest_arch_init();
> >  }
> > diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > index 604478151212..26660dd2ba78 100644
> > --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > @@ -362,3 +362,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
> >  void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
> >  {
> >  }
> > +
> > +void kvm_selftest_arch_init(void)
> > +{
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
> > index 89d7340d9cbd..8654ec74009a 100644
> > --- a/tools/testing/selftests/kvm/lib/s390x/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
> > @@ -218,3 +218,7 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
> >  void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
> >  {
> >  }
> > +
> > +void kvm_selftest_arch_init(void)
> > +{
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index 2e6e61bbe81b..20bf125f9363 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -1311,3 +1311,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
> >
> >       return val == 'Y';
> >  }
> > +
> > +void kvm_selftest_arch_init(void)
> > +{
> > +}
> > --
> > 2.37.2.789.g6183377224-goog
> >
>
> Otherwise,
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
