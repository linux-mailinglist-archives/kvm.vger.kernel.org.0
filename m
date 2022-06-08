Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0633543AAB
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbiFHRjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiFHRjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:39:33 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ED446653
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 10:39:29 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id x187so20403130vsb.0
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 10:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YMlVWKWFWg+nhbnd5V57+qJ+IXhci7VV/Jgt/zHgEZ0=;
        b=j3J+tWdGuDnMmzW4G3/e2Yrhr9b9g3Ixir6vg/ocyLbpDgCQnabw633VQz6gVt/Clq
         d6sT+N9Jhqbyc//8NN1Kpz7bE3GnUXthlUddzx6GVNOqAYWs2ys7dH/k52qs6ZR9Rh5N
         wYh0MQPu0tIzB1L3mrF28BVdB1JDjrnssIasa6WvL8hA5ICtUnV+hPkeFOZxF2clN1+g
         xoCjHxrkFFsG5YEHV6qSO9Jky2BqWQKskCRD1Smx6E2RuSggMQBft86f5VfN3oUdvNl+
         dA6IFRBsAkMqdTgjgyDDOAfcNA1oKJk5Gdjt1TQV9Gd5xf/yl6adfEct3gEyArl7EvAU
         PArg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YMlVWKWFWg+nhbnd5V57+qJ+IXhci7VV/Jgt/zHgEZ0=;
        b=XUgl2oMjw6L75HNwT0JX9o8TVSkkqCcEvYtHd+q1gsOynBkWjmNagpoV5V68G6CcJr
         +gs+1CCEvQrWXGo1xT+RDC2FPOQPMn95ieehsDkD6LfjctSE/DZCrrqtHO3NTlPAOpjj
         YAp4Jxm0yXlnrnwbCZ4TKH4uwj8CiW72PK7x6xC0onMFcB749xWzICCCwzI5qmpSk8Sm
         xVWJgExLr0oajTrHWK0dlq59YuNbYsqvNaOFlIsR5q/S+kODaS2va7fAhUtvK8i1oO4W
         DMxMCaGgz09l2ww7r79NwKn0SzJ/M23+etznVnufQTNyE+aV1527BVzon4W6x90UtvkP
         n2mA==
X-Gm-Message-State: AOAM532jz/Eb/J6UwbrrYzxEVBuwkn2vrGVsiIRdJms3PMMa2kiq4dMe
        ypknsBqSMp2HrkAX7iLj4qqH8JB450Rg84O5GxPxZg==
X-Google-Smtp-Source: ABdhPJwIIsHt0xzWM00HLFl0l6aL+x8xCN7jsifDlcALw0DFomqzVq6S0bhgX6CLu/L4ldhqPBDIwXZNDYBF05IHKrM=
X-Received: by 2002:a67:d30d:0:b0:34a:8d6c:1be6 with SMTP id
 a13-20020a67d30d000000b0034a8d6c1be6mr14582002vsj.74.1654709968634; Wed, 08
 Jun 2022 10:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org> <20220519134204.5379-60-will@kernel.org>
 <CAMn1gO7Gs8YUEv9Gx8qakedGNwFVgt9i+X+rjw50uc7YGMhpEQ@mail.gmail.com> <CA+EHjTxa8mhiEykjTTgB0J6aFpRqDiRzLKOWOd3hFsSrL+d=5g@mail.gmail.com>
In-Reply-To: <CA+EHjTxa8mhiEykjTTgB0J6aFpRqDiRzLKOWOd3hFsSrL+d=5g@mail.gmail.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Wed, 8 Jun 2022 10:39:14 -0700
Message-ID: <CAMn1gO5gDiL=HE6H2AhxM2hQZ9fnJCAi8n+1NF7bhZDnS+jOyg@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To:     Fuad Tabba <tabba@google.com>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Wed, Jun 8, 2022 at 12:40 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Peter,
>
> On Tue, Jun 7, 2022 at 1:42 AM Peter Collingbourne <pcc@google.com> wrote:
> >
> > On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
> > >
> > > From: Fuad Tabba <tabba@google.com>
> > >
> > > Return an error (-EINVAL) if trying to enable MTE on a protected
> > > vm.
> > >
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/kvm/arm.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 10e036bf06e3..8a1b4ba1dfa7 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -90,7 +90,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > >                 break;
> > >         case KVM_CAP_ARM_MTE:
> > >                 mutex_lock(&kvm->lock);
> > > -               if (!system_supports_mte() || kvm->created_vcpus) {
> > > +               if (!system_supports_mte() ||
> > > +                   kvm_vm_is_protected(kvm) ||
> >
> > Should this check be added to kvm_vm_ioctl_check_extension() as well?
>
> No need. kvm_vm_ioctl_check_extension() calls pkvm_check_extension()
> for protected vms, which functions as an allow list rather than a
> block list.

I see. I guess I got confused when reading the code because I saw this
in kvm_check_extension():

        case KVM_CAP_ARM_NISV_TO_USER:
                r = !kvm || !kvm_vm_is_protected(kvm);
                break;

This can probably be simplified to "r = 1;".

Peter
