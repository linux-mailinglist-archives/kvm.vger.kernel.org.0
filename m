Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77CE750F08
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbjGLQxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjGLQxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:53:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6A61BEC
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:53:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bd69bb4507eso7866180276.2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689180808; x=1691772808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TuwmCccTzzPRVYbABitkJk2otUQw/JA11EzNmmOq3F8=;
        b=LY3EnhCMzD5FX+ReAkl8wiSgiqXHx+ha+7COu+SQjXOgfs3EXcRzd8FuOv6s6gMFGY
         Sx6bXEKZUfyyIdrzMJyxYmejS3qH5NB0y2W7dxHfgnutJE1JBHqB83xDnwmY3vcnpojX
         JdCErBkT+loA7bbAhxqn2cB8tEam7rho/dMbz2QifbhAm9KZSq6ZyWiCEBL2vaIYP+S2
         U4Kevd+b1B2218tpwRIAt0LzXPVjxtpwINm2ehnh7y+li0kep8KKUuI5BHxBBwEd0lyg
         m9UfxX9YZ05wnWp/uxTGjEgSCeWR09MUqGHPChylubjoPz90kTOFbTnO6V59DV80Zf82
         iaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689180808; x=1691772808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TuwmCccTzzPRVYbABitkJk2otUQw/JA11EzNmmOq3F8=;
        b=SHIJklzno13gOBG2fCCoRRTsLUl/Kc2OaGPr/iF6fEUqJA+hOAbuiLM0y9A+s3lciU
         Mn/QCmOSPAFzn0nKwYk73XlLKrc1PquK7wyWEcTJqAUznWECc5NWb71x1ttm1qPbjJxH
         f9zP0rhkx1AytH9KIkze9620nb/fiEsxpCXfxHa6YmB01BqO8wICAl2dxKJj2KLQ3vS8
         U/pDb101QVwX0Tch3K2BusEJFcl+YB/1xvqBwoQUmjoZpTDFRKJQ66zsjpNX3rpHkOKA
         j7Oo3lRgSJNUw5jN7g0Tf+2v8gJY4GB7HQ5qwrg3MDqPAgYBzIOUEzyZWLXUb6WPJ6aU
         EBJw==
X-Gm-Message-State: ABy/qLYQ6qm0SzhxKhavNLOtJtg5gFnMNZDAYuvZ4go+wnPWpF9mIjxt
        dPwWiJ5kElfNCPwuM2QneOUZEW4eWMg=
X-Google-Smtp-Source: APBJJlHPzUYAMUevw56rN72xCda5PMJmwguFn3cN/qClrzRT6VtD9MBYOBO1RPRXFRDT8Ob9wSXcO/zDXXw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aba1:0:b0:c15:cbd1:60da with SMTP id
 v30-20020a25aba1000000b00c15cbd160damr162947ybi.6.1689180808382; Wed, 12 Jul
 2023 09:53:28 -0700 (PDT)
Date:   Wed, 12 Jul 2023 09:53:26 -0700
In-Reply-To: <87y1jn52pp.fsf@redhat.com>
Mime-Version: 1.0
References: <202307080326.zDp7E3o0-lkp@intel.com> <87y1jn52pp.fsf@redhat.com>
Message-ID: <ZK7ahtc2DVx6E/si@google.com>
Subject: Re: [stable:linux-5.15.y 55/9999] arch/x86/kvm/hyperv.c:2185:5:
 error: stack frame size (1036) exceeds limit (1024) in 'kvm_hv_hypercall'
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023, Vitaly Kuznetsov wrote:
> kernel test robot <lkp@intel.com> writes:
> 
> > Hi Vitaly,
> >
> > First bad commit (maybe != root cause):
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
> > head:   d54cfc420586425d418a53871290cc4a59d33501
> > commit: cb188e07105f2216f5efbefac95df4b6ce266906 [55/9999] KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall
> > config: i386-buildonly-randconfig-r006-20230708 (https://download.01.org/0day-ci/archive/20230708/202307080326.zDp7E3o0-lkp@intel.com/config)
> > compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
> > reproduce: (https://download.01.org/0day-ci/archive/20230708/202307080326.zDp7E3o0-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202307080326.zDp7E3o0-lkp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> >>> arch/x86/kvm/hyperv.c:2185:5: error: stack frame size (1036) exceeds limit (1024) in 'kvm_hv_hypercall' [-Werror,-Wframe-larger-than]
> >    int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >        ^
> >    1 error generated.
> 
> (sorry for delayed reply)
> 
> This used to be a warning (without CONFIG_KVM_WERROR I guess?) :-) E.g.
> 
> https://lore.kernel.org/kvm/87zgg6sza8.fsf@redhat.com/#t
> 
> where Nathan explained LLVM's behavior:
> 
> https://lore.kernel.org/kvm/Yvp87jlVWg0e376v@dev-arch.thelio-3990X/
> 
> This was 'fixed' upstream with
> 
> commit 7d5e88d301f84a7b64602dbe3640f288223095ea
> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date:   Tue Nov 1 15:53:56 2022 +0100
> 
>     KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv' instead of on-stack 'sparse_banks'
>   
> and personally, I'm not against backporting it to 5.15.y but I seriously
> doubt it is worth the hassle (i386 KVM + llvm + CONFIG_KVM_WERROR is
> likely an impossible combo).
> 
> Also, there seems to be another build problem with CONFIG_KVM_WERROR I
> met with clan-16 and the same config:
> 
> ../arch/x86/kvm/x86.c:2315:19: error: unused function 'gtod_is_based_on_tsc' [-Werror,-Wunused-function]
> static inline int gtod_is_based_on_tsc(int mode)
> 
> TL;DR: Let's ignore this for 5.15, not worth fixing IMO. Cc: kvm@ to
> check if anyone thinks differently.

Ya, ignore it.  KVM_WERROR is off-by-default for 32-bit builds, and all evidence
suggests that no one uses KVM with 32-bit kernels these days, so I can't imagine
this negatively affects anyone.

  config KVM_WERROR
        bool "Compile KVM with -Werror"
        # KASAN may cause the build to fail due to larger frames
        default y if X86_64 && !KASAN

