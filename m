Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793AD5AF81A
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 00:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiIFWqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 18:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiIFWqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 18:46:33 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF42CE08
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 15:46:31 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f124so3615604pgc.0
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 15:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=oaTtXOG0HZ5g5qg4koIa0611t09qPZATkIZPeRybbyE=;
        b=F9OuXAaK9W/u+qhAD+rF7gpCdPMj7kJHKN9t+vgit1gYXr1EkM+WrrruLUx4F3l5ie
         UsrOz+FuNMl/EFgfiACGIkaE9ifiyu06ogeBMh8iWGI51bjZOkTmurcic6E4XvY8nqzP
         TSWashKQMI97TUyvJyFBZTiNoYrqjmmbnVrOfevlaMSQweP4Gq5ZohUCYj/N3RSC/bav
         71+jlsf7gG0rg221WIDoGpXAkFxLoBWnCzLI1ecyoumbxuLAvIFzvmP8WuAgTQ2rweYw
         QV0B2dTMPyJE1NZl+ObhHFeqjGZlhGnpQ7Uror3D3se62430ZVQDcpKraWsPk7whuD10
         R7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=oaTtXOG0HZ5g5qg4koIa0611t09qPZATkIZPeRybbyE=;
        b=XrksC1YyMumv76cJxlbEE0M1Xo+qDXtmaQAK24SS5Plf2IoECl/veMVOsNq4oEO7lq
         x91VtFWhh/TIWWqKVVC9pZLN8JAcP/osXocxhPXhup2ZGXIwDhuDm8mwAHtoZbmdkv1w
         almQt5aaCRzHz/gVoNjfwPzcIAG8do66lLkn75mENI8IdomPWbvPJQ+ZrajiwyaZLMfg
         +GLBK5JiE0TR/Lk5pVIiVKLPN178Zelix4UczlWi5w1MVeNIGALNfUU+vTpSOc/OxNa1
         P/DweMAQebLLRs7iZVw2DQtUdg4CUVHTu+yHGnZQAS0WymnXP8aDfzzYOZgGUx5gkM6K
         kjQA==
X-Gm-Message-State: ACgBeo1uHwtnMZ1Zx4IpEF4jKCKbQnhHsJ5Oe0Roawy0A1dzE2k8X6zr
        niTbCJ899+2us/BWr0MTuOaD80NYflZoqKmT30szZg==
X-Google-Smtp-Source: AA6agR4WXCPxI2ko7VjeNRcYuBi9mTyTQdAo9o/DqThW0lVl9+S2gG/rh8cOJHLIfKbVARJIwkcMY0Bc4bDVu7/OvYE=
X-Received: by 2002:a63:4726:0:b0:430:3886:5a2f with SMTP id
 u38-20020a634726000000b0043038865a2fmr774630pga.99.1662504390764; Tue, 06 Sep
 2022 15:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220903012849.938069-1-vannapurve@google.com>
 <20220903012849.938069-3-vannapurve@google.com> <20220905074609.ga4tnpuxpcgppx4r@kamzik>
In-Reply-To: <20220905074609.ga4tnpuxpcgppx4r@kamzik>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Tue, 6 Sep 2022 15:46:20 -0700
Message-ID: <CAGtprH9Kaemwupgoo_kgM-Ci2cnN2kpXa+ZwEymSnYNFhS9Fsg@mail.gmail.com>
Subject: Re: [V1 PATCH 2/5] selftests: kvm: Introduce kvm_arch_main and helpers
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     x86 <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>, oupton@google.com,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        drjones@redhat.com, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 5, 2022 at 12:46 AM Andrew Jones <andrew.jones@linux.dev> wrote:
>
> On Sat, Sep 03, 2022 at 01:28:46AM +0000, Vishal Annapurve wrote:
> > Introduce following APIs:
> > 1) kvm_arch_main : to be called at the startup of each test.
>
> With this, AArch64 can move the content of its constructor,
> init_guest_modes(), into kvm_arch_main(). Or, instead of the
>
>  main()
>  {
>     /* common main stuff */
>     kvm_arch_main();
>     __main();
>  }
>
> approach we could have each arch provide a constructor
>
>  arch_init()
>  {
>     common_pre_main_stuff();
>     /* arch specific pre-main stuff */
>  }
>
> I personally prefer the latter.
>

I agree with your suggestion of using constructors here. This will
help avoid changes in all the selftests.
Maybe I can add a common constructor that can invoke arch specific
init. I will add this change in the next series.

Thanks,
Vishal

> Thanks,
> drew
>
> > 2) kvm_arch_post_vm_load: called after guest elf image is loaded into
> >    memory to populate any global state in guest memory.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util_base.h | 10 ++++++++++
> >  tools/testing/selftests/kvm/lib/aarch64/processor.c |  8 ++++++++
> >  tools/testing/selftests/kvm/lib/elf.c               |  2 ++
> >  tools/testing/selftests/kvm/lib/kvm_util.c          |  2 ++
> >  tools/testing/selftests/kvm/lib/riscv/processor.c   |  8 ++++++++
> >  tools/testing/selftests/kvm/lib/s390x/processor.c   |  8 ++++++++
> >  tools/testing/selftests/kvm/lib/x86_64/processor.c  |  8 ++++++++
> >  7 files changed, 46 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 9e521d1c8afe..301bef6376a5 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -834,6 +834,16 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
> >       return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
> >  }
> >
> > +/*
> > + * API to execute architecture specific setup before executing selftest logic.
> > + */
> > +void kvm_arch_main(void);
> > +
> > +/*
> > + * API to execute architecture specific setup after loading VMs.
> > + */
> > +void kvm_arch_post_vm_load(struct kvm_vm *vm);
> > +
> >  /*
> >   * API to be implemented by all the selftests.
> >   */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 6f5551368944..a7ca1947d574 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -528,3 +528,11 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> >                      [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
> >                    : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
> >  }
> > +
> > +void kvm_arch_main(void)
> > +{
> > +}
> > +
> > +void kvm_arch_post_vm_load(struct kvm_vm *vm)
> > +{
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
> > index 9f54c098d9d0..f56f9279e703 100644
> > --- a/tools/testing/selftests/kvm/lib/elf.c
> > +++ b/tools/testing/selftests/kvm/lib/elf.c
> > @@ -189,4 +189,6 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
> >                               phdr.p_filesz);
> >               }
> >       }
> > +
> > +     kvm_arch_post_vm_load(vm);
> >  }
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 2e611a021c6e..b778dc684e30 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -1985,6 +1985,8 @@ int main(int argc, char *argv[])
> >       /* Tell stdout not to buffer its content */
> >       setbuf(stdout, NULL);
> >
> > +     kvm_arch_main();
> > +
> >       __main(argc, argv);
> >
> >       return 0;
> > diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > index 604478151212..d992ad5b5771 100644
> > --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > @@ -362,3 +362,11 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
> >  void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
> >  {
> >  }
> > +
> > +void kvm_arch_main(void)
> > +{
> > +}
> > +
> > +void kvm_arch_post_vm_load(struct kvm_vm *vm)
> > +{
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
> > index 89d7340d9cbd..3a249783b3fe 100644
> > --- a/tools/testing/selftests/kvm/lib/s390x/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
> > @@ -218,3 +218,11 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
> >  void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
> >  {
> >  }
> > +
> > +void kvm_arch_main(void)
> > +{
> > +}
> > +
> > +void kvm_arch_post_vm_load(struct kvm_vm *vm)
> > +{
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index 2e6e61bbe81b..e22cfc4bf284 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -1311,3 +1311,11 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
> >
> >       return val == 'Y';
> >  }
> > +
> > +void kvm_arch_main(void)
> > +{
> > +}
> > +
> > +void kvm_arch_post_vm_load(struct kvm_vm *vm)
> > +{
> > +}
> > --
> > 2.37.2.789.g6183377224-goog
> >
