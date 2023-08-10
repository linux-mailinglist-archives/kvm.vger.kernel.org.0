Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33D2778271
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 22:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjHJUzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 16:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjHJUzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 16:55:09 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C6F2738
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 13:55:07 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-40a47e8e38dso19021cf.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 13:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691700907; x=1692305707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fbz6nfirzOItWcULJrhy76vEH5UntBJ+zAdtRqxrtIs=;
        b=mkXquOWImM+ipsQFpSuV6HphXWcMu0DYJyCRbKA/Dq79yQhHG6TR+uE6DNBjdtFfKW
         9Ou/urveYZ4pdU9VR2letW3AyzwHrPpup+XFQvg0vonxJ42AGrE0ltKx1/f55708OXYf
         vRUx09Hzn0lW4KrJOE9nmWrwtUjt3v4ixV/ExTTUVlINSh80tyHy1p6Y/nwisurUxSg3
         Wmv9YQlCHLhD3Pnz+PxZu242lj8GKSajSa1rIlgV/+M9oPmy8Wnkw4+ChJ0Lg9d6ijtw
         nCaMDID/yxucfw6q1AGYHCMLPpDCnZU/dtO0FRBlOqagop7dekdu3rV5nFgzRGnaj5/N
         zDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691700907; x=1692305707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fbz6nfirzOItWcULJrhy76vEH5UntBJ+zAdtRqxrtIs=;
        b=a9hxIz1yh+m/0juxaNJfHdX5N9Ap4YAwAtBfJAEwAmsZPPmkWCyj5qhJ3uwmE7Z002
         RSXd8Z10vwu44oVYP+VxYYJuErQMZbVQEhmV4+P3PkXa0wueXwZp0xFK2oNR7633KBYA
         vWLSIC9tuKhtjQ1YBcmCwt/Wzn5qAbvLAxDEiQ5VPsLBwGKRbXqWXmgM+SMAxn0ZPRTz
         9IJlcRNJ6pZSnyLh+riMkGSxi2BIxog2Ozt97HU0dMmJ+dTwIq42e6+uvorJKwguuX1g
         3dg7LI2RFkrVj0QVSr87pScQN3kY5J4nuyH1RilGbGqO7fQTj6FWVOQFYqB2kuhvAFWQ
         hQ+Q==
X-Gm-Message-State: AOJu0Yy1tI2gaJi8O7KKSIP9acdbhIM6yNiGo+/s4sLMFEw4KUooAZ+S
        chFsnyw2+rY0WHwHNZ+0lU4Xmx2LN1YGuZSurchyaeBDirpymjD6O9ic8A==
X-Google-Smtp-Source: AGHT+IETRvm1u0c2tw6CwIcy/y+qdG7C9yLn61u49rI1SxhvjvsG0R6dfHP+vWIwnY34cSPU455isRrBYsnfx2fRx9Y=
X-Received: by 2002:ac8:7f86:0:b0:403:96e3:4745 with SMTP id
 z6-20020ac87f86000000b0040396e34745mr69781qtj.20.1691700906744; Thu, 10 Aug
 2023 13:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com> <20230808231330.3855936-3-rananta@google.com>
 <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com> <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
 <30e45ef3-309a-63de-e085-be1645c1be79@redhat.com>
In-Reply-To: <30e45ef3-309a-63de-e085-be1645c1be79@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 10 Aug 2023 13:54:55 -0700
Message-ID: <CAJHc60x=bhXS3PahuRPwRVdqN4LeX-PBdjdEeCEomhf2YAJ1mw@mail.gmail.com>
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs() globally
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 5:26=E2=80=AFAM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
>
>
> On 8/10/23 00:38, Raghavendra Rao Ananta wrote:
> > Hi Gavin,
> >
> > On Tue, Aug 8, 2023 at 9:00=E2=80=AFPM Gavin Shan <gshan@redhat.com> wr=
ote:
> >>
> >>
> >> On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
> >>> There's no reason for the architectures to declare
> >>> kvm_arch_flush_remote_tlbs() in their own headers. Hence to
> >>> avoid this duplication, make the declaration global, leaving
> >>> the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> >>> as needed.
> >>>
> >>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >>> ---
> >>>    arch/mips/include/asm/kvm_host.h | 1 -
> >>>    include/linux/kvm_host.h         | 2 ++
> >>>    2 files changed, 2 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm=
/kvm_host.h
> >>> index 9b0ad8f3bf327..54a85f1d4f2c8 100644
> >>> --- a/arch/mips/include/asm/kvm_host.h
> >>> +++ b/arch/mips/include/asm/kvm_host.h
> >>> @@ -897,6 +897,5 @@ static inline void kvm_arch_vcpu_blocking(struct =
kvm_vcpu *vcpu) {}
> >>>    static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)=
 {}
> >>>
> >>>    #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> >>> -int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >>>
> >>>    #endif /* __MIPS_KVM_HOST_H__ */
> >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >>> index e3f968b38ae97..ade5d4500c2ce 100644
> >>> --- a/include/linux/kvm_host.h
> >>> +++ b/include/linux/kvm_host.h
> >>> @@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlbs(st=
ruct kvm *kvm)
> >>>    {
> >>>        return -ENOTSUPP;
> >>>    }
> >>> +#else
> >>> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >>>    #endif
> >>>
> >>>    #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
> >>
> >> Is the declaration inconsistent to that in arch/x86/include/asm/kvm_ho=
st.h?
> >> In order to keep them consistent, I guess we need move kvm_arch_flush_=
remote_tlbs()
> >> from x86's header file to arch/x86/kvm/mmu/mmu.c and 'inline' needs to=
 be dropped.
> >>
> > Unsure of the original intentions, I didn't want to disturb any
> > existing arrangements. If more people agree to this refactoring, I'm
> > happy to move.
>
> This is amazing to me. This change can be compiled without any error
> even if the declaration inconsistent between the kvm_host.h and x86's
> header file.
>
> I'm curious which option make it possible?
>
After doing some experiments, I think it works because of the order in
which the inline-definition and the declaration are laid out. If the
'inline' part of the function comes first and then the declaration, we
don't see any error. However if the positions were reversed, we would
see an error. (I'm not sure what the technical reason for this is).

Just to be safe, I can move the definition to arch/x86/kvm/mmu/mmu.c
as a non-inline function.

Thank you.
Raghavendra
> Thanks,
> Shaoqin
>
> >
> > Thank you.
> > Raghavendra
> >> Thanks,
> >> Gavin
> >>
> >
>
> --
> Shaoqin
>
