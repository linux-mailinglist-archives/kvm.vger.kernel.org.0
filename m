Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCDA57EA8A
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiGWAHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGWAHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:07:35 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81BB33A3D
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:07:33 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id p10so2440572lfd.9
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ITeXNmTHghT7JbHp8okODbZaYzIJfstIsA3P3tV9y40=;
        b=W9pYztkij0UdIoVKCwii/oFiV0cvZ5D936E0/mEOHV+PGCHn9DscpcUnOl4HetSX0O
         6idU7oCZ5SjLAeIknNBeMGaKoJlq+2hNYU0MxEGIRNKR/px74S1VmIV/weHGBGbkAo8b
         K6czUcrgj5P6xHnLaQGr1Xv1xoSpEB/5K0v/0YySzYEp3Lt98KIWz5/rE3SG9wg3QALE
         961WwNiLN/kU+46s4yDrn6mpPVkM71wbgIvv0vUamutY7QfvNc86ZJBf8QHZAOjSCAex
         5/eRQyYeeSlDXjMwP5dA2jLTyLpvweEdNiXtMhmMAbeAgVI4z4Pqk2HiLP/xsTgIhqjy
         EfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ITeXNmTHghT7JbHp8okODbZaYzIJfstIsA3P3tV9y40=;
        b=1b3RZgTdl772bbl52JpkKoSRFhUIKYhFjqjKg1B1lotPZ2rMjVOosbMiHx/NCuYUdM
         a9MwFy1KjcZxHq0hPDwYD8ktffwwbuS1a8bzTDkKElQPsO7153fPaFR6Rk21eCdvMfG3
         JqFBOoZUg7mdSWKD2clFk5i/Wgkio8lmrHvKfcfwc6ejQ9Uclkz2zBpPM8kP4ue9J5wn
         FAUoW3waelveMZOZetxrcEs3C2GjLGTf4tlbVnoO5xY+f0mIlZGTMYdFUVQ4QKGOZ+E+
         EMNGLEcTZbWr4U75Nfz1Tgmv6Np47utDciYAaMotKC0p+v6xbONy7OLhre1ZuHttBcFP
         W4UQ==
X-Gm-Message-State: AJIora9Vu78pbdH1kSTfmVWYv1U77s5X0iTEQ3bHnPSUotL4ePlPC3Jk
        mt9ClqBefEG7UNPAxZMszRag2QvCQlfgLEk+gkLaTg==
X-Google-Smtp-Source: AGRyM1vhBy1BgDXpMpcs+ikuvIT5rufv+Xk7q4ZO7FkjKO1mj+TBVoGrz0GeyPpBFfd6JIvzLIa2nGMc91CSlhV3ZEk=
X-Received: by 2002:ac2:5207:0:b0:48a:7aa6:e74c with SMTP id
 a7-20020ac25207000000b0048a7aa6e74cmr831153lfl.104.1658534852169; Fri, 22 Jul
 2022 17:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220722234838.2160385-1-dmatlack@google.com> <20220722234838.2160385-2-dmatlack@google.com>
 <Yts6cCcnfg1xV54O@google.com>
In-Reply-To: <Yts6cCcnfg1xV54O@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 22 Jul 2022 17:07:05 -0700
Message-ID: <CALzav=fCZkyO=9Hvub+Grb3QYW6QJ2bLyUACR8Aaqzx+k8O4LA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Fix KVM_EXCEPTION_MAGIC build with Clang
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        "open list:CLANG/LLVM BUILD SUPPORT" <llvm@lists.linux.dev>,
        kvm list <kvm@vger.kernel.org>
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

On Fri, Jul 22, 2022 at 5:01 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jul 22, 2022, David Matlack wrote:
> > Change KVM_EXCEPTION_MAGIC to use the all-caps "ULL", rather than lower
> > case. This fixes a build failure with Clang:
> >
> >   In file included from x86_64/hyperv_features.c:13:
> >   include/x86_64/processor.h:825:9: error: unexpected token in argument list
> >           return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
> >                  ^
> >   include/x86_64/processor.h:802:15: note: expanded from macro 'kvm_asm_safe'
> >           asm volatile(KVM_ASM_SAFE(insn)                 \
> >                        ^
> >   include/x86_64/processor.h:785:2: note: expanded from macro 'KVM_ASM_SAFE'
> >           "mov $" __stringify(KVM_EXCEPTION_MAGIC) ", %%r9\n\t"   \
> >           ^
> >   <inline asm>:1:18: note: instantiated into assembly here
> >           mov $0xabacadabaull, %r9
> >                           ^
> >
> > Fixes: 3b23054cd3f5 ("KVM: selftests: Add x86-64 support for exception fixup")
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> >  tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > index 45edf45821d0..51c6661aca77 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > @@ -754,7 +754,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> >                       void (*handler)(struct ex_regs *));
> >
> >  /* If a toddler were to say "abracadabra". */
> > -#define KVM_EXCEPTION_MAGIC 0xabacadabaull
> > +#define KVM_EXCEPTION_MAGIC 0xabacadabaULL
>
> Really?!?!?! That's what makes clang happy?!?!?

Heh, yup. I was surprised when it worked.

Hopefully some of the Clang folks CC'd can shed some light on why.
