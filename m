Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE983558CF4
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 03:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiFXBqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 21:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiFXBqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 21:46:53 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6065E275F0;
        Thu, 23 Jun 2022 18:46:52 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id b81so576219vkf.1;
        Thu, 23 Jun 2022 18:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gNjciigyzGJAh0dXEnMpi21gMKKHd63d/EqenLBRjGk=;
        b=kRSy17XxrKPbcA8CVwZJFnU4zYNL103NNcZXe+gv6sTfG7B9+IoMFbH0hgDUsnYomt
         T2a6RNS5KWaLLnNjRFxcPhihfrVjrs4XtB/ibrApdMNawpEdl6ozEdP5Ca0f5rMAICSH
         af2VS/C8UPhsEZ/RYvf5zO0pUhcsONliNsHVgmcdFOtAID9HeLWF26WrtAJ5nKQwOSkG
         0UTUZmgUe5B4v4E2sTIYSRWm/VzSq1VOLgspkdsPF6H+g1P/Lf3rFXr0Ug+soNm0pueQ
         4/xqYo1zsvCBlpLRgBpORuG/KSlXeC7qAGzLUxaUQFu9svVXchOtAYD3uMTyfJ5JDhY3
         rEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gNjciigyzGJAh0dXEnMpi21gMKKHd63d/EqenLBRjGk=;
        b=HLQjsCCdtGbbpbjgJW1hlrkJdudG/Wj7tEe76BlVygR0jIsVm3WSW/RdaSzFnf2p9Y
         RRgQ1HllcvFT7nlFD7wHYsIW4pQXg1lWpQPn+bU0Ak1Y1lfB27IwE+8ToKHrtNgCJWgi
         9pEd7CqOfDf9uJyOp2h9BIC0nux9RvoDdgIzkSj6Uy2vvzshfOtibwPqMrxIOHKh0eoW
         GoUvTcU3px8PKMlSn/pM3nMkCFnX666XrpItIH53BE9fo4M/jU+Bj3h2DmJZMzcDmPNo
         Mpl05/GeFHlS9yhwiJ3rzkcf39t5krzVQOCsbNxcwRTygnpU1CC4A0M7EE8h+DZm2Slb
         rc2g==
X-Gm-Message-State: AJIora8PaJSNkdQKG3G/luyE9ICcIYkFT0egR2hjkCBH+5ntF/M7d1lJ
        gtgJ0nagHspy/J3idzrX2iUqXLEoRdN1G9lMIwU=
X-Google-Smtp-Source: AGRyM1vr/K1w1ogZBQtMtcWg5uyuJ5g8OgJQtGcLdmj89xjqE8fpKD4yr6xJNYT24IpdV3NyD2ZsAmI2NaIp5nOJ0Gw=
X-Received: by 2002:a1f:c603:0:b0:36c:500c:d692 with SMTP id
 w3-20020a1fc603000000b0036c500cd692mr11034611vkf.11.1656035211505; Thu, 23
 Jun 2022 18:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220623143059.2626661-1-pbonzini@redhat.com>
In-Reply-To: <20220623143059.2626661-1-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 24 Jun 2022 09:46:40 +0800
Message-ID: <CANRm+CzQKwDLCEU6tqHeQwvxtsxUtUZtGJJuun0rDrjqJukgAQ@mail.gmail.com>
Subject: Re: [PATCH v2] MAINTAINERS: Reorganize KVM/x86 maintainership
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jun 2022 at 22:32, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> For the last few years I have been the sole maintainer of KVM, albeit
> getting serious help from all the people who have reviewed hundreds of
> patches.  The volume of KVM x86 alone has gotten to the point where one
> maintainer is not enough; especially if that maintainer is not doing it
> full time and if they want to keep up with the evolution of ARM64 and
> RISC-V at both the architecture and the hypervisor level.
>
> So, this patch is the first step in restoring double maintainership
> or even transitioning to the submaintainer model of other architectures.
>
> The changes here were mostly proposed by Sean offlist and they are twofold:
>
> - revisiting the set of KVM x86 reviewers.  It's important to have an
>   an accurate list of people that are actively reviewing patches ("R"),
>   as well as people that are able to act on bug reports ("M").  Otherwise,
>   voids to be filled are not easily visible.  The proposal is to split
>   KVM on Hyper-V, which is where Vitaly has been the main contributor
>   for quite some time now; likewise for KVM paravirt support, which
>   has been the main interest of Wanpeng and to which Vitaly has also
>   contributed (e.g., for async page faults).  Jim and Joerg have not been
>   particularly active (though Joerg has worked on guest support for AMD
>   SEV); knowing them a bit, I can't imagine they would object to their
>   removal or even be surprised, but please speak up if you do.
>
> - promoting Sean to maintainer for KVM x86 host support.  While for
>   now this changes little, let's treat it as a harbinger for future
>   changes.  The plan is that I would keep the final integration testing
>   for quite some time, and probably focus more on -rc work.  This will
>   give me more time to clean up my ad hoc setup and moving towards a
>   more public CI, with Sean focusing instead on next-release patches,
>   and the testing up to where kvm-unit-tests and selftests pass.  In
>   order to facilitate collaboration between Sean and myself, we'll
>   also formalize a bit more the various branches of kvm.git.
>
> Nothing is going to change with respect to handling pull requests to Linus
> and from other architectures, as well as maintainance of the generic code
> (which I expect and hope to be more important as architectures try to
> share more code) and documentation.  However, it's not a coincidence
> that my entry is now the last for x86, ready to be demoted to reviewer
> if/when the right time comes.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  MAINTAINERS | 40 +++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 97014ae3e5ed..968b622bc3ce 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10897,28 +10897,50 @@ F:    tools/testing/selftests/kvm/*/s390x/
>  F:     tools/testing/selftests/kvm/s390x/
>
>  KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
> +M:     Sean Christopherson <seanjc@google.com>
>  M:     Paolo Bonzini <pbonzini@redhat.com>
> -R:     Sean Christopherson <seanjc@google.com>
> -R:     Vitaly Kuznetsov <vkuznets@redhat.com>
> -R:     Wanpeng Li <wanpengli@tencent.com>
> -R:     Jim Mattson <jmattson@google.com>
> -R:     Joerg Roedel <joro@8bytes.org>
>  L:     kvm@vger.kernel.org
>  S:     Supported
> -W:     http://www.linux-kvm.org
>  T:     git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>  F:     arch/x86/include/asm/kvm*
> -F:     arch/x86/include/asm/pvclock-abi.h
>  F:     arch/x86/include/asm/svm.h
>  F:     arch/x86/include/asm/vmx*.h
>  F:     arch/x86/include/uapi/asm/kvm*
>  F:     arch/x86/include/uapi/asm/svm.h
>  F:     arch/x86/include/uapi/asm/vmx.h
> -F:     arch/x86/kernel/kvm.c
> -F:     arch/x86/kernel/kvmclock.c
>  F:     arch/x86/kvm/
>  F:     arch/x86/kvm/*/
>
> +KVM PARAVIRT (KVM/paravirt)
> +M:     Paolo Bonzini <pbonzini@redhat.com>
> +R:     Wanpeng Li <wanpengli@tencent.com>
> +R:     Vitaly Kuznetsov <vkuznets@redhat.com>
> +L:     kvm@vger.kernel.org
> +S:     Supported
> +T:     git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> +F:     arch/x86/kernel/kvm.c
> +F:     arch/x86/kernel/kvmclock.c
> +F:     arch/x86/include/asm/pvclock-abi.h
> +F:     include/linux/kvm_para.h
> +F:     include/uapi/linux/kvm_para.h
> +F:     include/uapi/asm-generic/kvm_para.h
> +F:     include/asm-generic/kvm_para.h
> +F:     arch/um/include/asm/kvm_para.h
> +F:     arch/x86/include/asm/kvm_para.h
> +F:     arch/x86/include/uapi/asm/kvm_para.h
> +
> +KVM X86 HYPER-V (KVM/hyper-v)
> +M:     Vitaly Kuznetsov <vkuznets@redhat.com>
> +M:     Sean Christopherson <seanjc@google.com>
> +M:     Paolo Bonzini <pbonzini@redhat.com>
> +L:     kvm@vger.kernel.org
> +S:     Supported
> +T:     git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> +F:     arch/x86/kvm/hyperv.*
> +F:     arch/x86/kvm/kvm_onhyperv.*
> +F:     arch/x86/kvm/svm/svm_onhyperv.*
> +F:     arch/x86/kvm/vmx/evmcs.*
> +
>  KERNFS
>  M:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  M:     Tejun Heo <tj@kernel.org>
> --

Looks good to me.

    Wanpeng
