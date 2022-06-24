Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67678558D21
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 04:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiFXCLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 22:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiFXCLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 22:11:49 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1025650B1D;
        Thu, 23 Jun 2022 19:11:48 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id k5so582806vkd.8;
        Thu, 23 Jun 2022 19:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IcMcYa4wbqZ57F0ULjDUSuPaQEV3oXXPC/cZk3+/exk=;
        b=JwrP1e/c7x90CvTTBoDgz4n5uRSEoywHFVHsJQPwkCVZNqgdlrqKohOA3RJaqEOauA
         CgydQR+AF9oOv446Y/2vMm5IuYTZPmjk8Y6jehnfyFmWrbqDrl7d2YhcAkdtOAosVsu5
         vEruQnS6NCaWPVLhy99EdKdUuMnKCejE12FIBKyQHUipX0UDk2VqD6HcbnLt7vUzW4QA
         GVxJw5fcGw31a7gkvczIbTnFGEaiUiedIOVyjWmtG/np7Z7uYyhcEZe0UwN1rmIAcuTB
         D6KQVzS78pFZLZuE0agFUQT1wwaGrtJwM7xaPnIUXvrTcRg/yruTCG1Ca7NnHcVHCv2d
         Mnqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IcMcYa4wbqZ57F0ULjDUSuPaQEV3oXXPC/cZk3+/exk=;
        b=D5JC6hDF31v5agyHT5XZqfzktFLbUX3Q38J2wZP7kYQkiE2mOLP3ShCMShNfujS8qQ
         4Au2QQj0n17wIN+1fuV4GI58VcyQCpR66hjmUobrSEQ7afAzX3E3n6mRbVOmc7DZzuK2
         M+/eszlDuBRkY3FOsL+W7K2MuYGPNjWGjTXnYf1ZItkzrbUzBKwCkI6IQg5JWzUhmXHp
         MEnpUOYnzqwpmCUWR9FcE2pN51yX/rIaiM/8OEw1eLrasI7XlEeqXmqznRAAee0TZBKj
         atKy0m/yNQsSNtEtlHhhQ8SPD/Iv8Pdu9Et8oqPin/iEr8OKB3rqX6m8+dLhOhKuHwAC
         xEPA==
X-Gm-Message-State: AJIora/E6UWPtl+D3BuPVObzy9XcCTiRkISwvYjrpt4xSGiqMRZjkFmt
        vQwwazNOhZANkxDDBwiofOkyiU/C0L/IrmpZnbw=
X-Google-Smtp-Source: AGRyM1sd0v7rvtZLouSW8vVFEO25bU9siGdrkxQZupDumsGqWkWipFXEp/DMnWe1WYdOeyNd/xxhV1+q30UQBNr2Hew=
X-Received: by 2002:a1f:9f97:0:b0:36b:e62a:28c with SMTP id
 i145-20020a1f9f97000000b0036be62a028cmr14433074vke.3.1656036707158; Thu, 23
 Jun 2022 19:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220623143059.2626661-1-pbonzini@redhat.com>
In-Reply-To: <20220623143059.2626661-1-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 24 Jun 2022 10:11:35 +0800
Message-ID: <CANRm+Czsd5dWvi5_=8HHi0ezE4MEvJs2QjGQEorcAaho1mEx6Q@mail.gmail.com>
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

I can probably volunteer as an "M" and act on bugs here since most of
the important features(except Async PF) contributed by me in recent
years . :)
    Wanpeng
