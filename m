Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F574E3935
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 07:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbiCVGyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 02:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbiCVGyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 02:54:07 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D40665C6
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 23:52:40 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id z6so9678567iot.0
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 23:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XFoP8ryMln3uN20GWCunzZwIqKTPKsaz5P8BGJuL+LE=;
        b=oK4Dnxbemz6jkM6BAl43GshFrSPECt5yiqS/W2TtD4osI0sQrDEDzdu+6TcXW1/5Ll
         h3Tks8ZVoxxHfujsFYRjCKYCjluDVWpZmUwOtC557I+8HNXz1FKZTdkrXU9k8m4Y6EHC
         xMdkEFYXkA8ZwFKlrkDmLKO9va4NELZu7Al5Fo07+1qrMPvJv6ERt7bp+5uR5DaVdNbX
         oxARZvZFsp76D4motp6GpUTndgKGrzgOp0i4w/a6ddWxKixsjE41+zIJnnyc4rdjEHAm
         RBngOIPFZYg+80aKchv52lL38R02oOQlIflgaIbjIEMCRhXRgMc082/0P83J1A+nvs/Y
         FE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XFoP8ryMln3uN20GWCunzZwIqKTPKsaz5P8BGJuL+LE=;
        b=hH4Pp1/CoVxeSttrQKQKSpj4Uf9H3sBTUHBr8u/YkYkEIetu/oGKaIwYY8q3p2HYBq
         Dx7tIBJJXM54TAx3VY9lyqdqOOFXmmZQsa48mKRZ/qsmrsnlJg4IznMl6tkEfHwUbb6d
         nkZchg6iZXsxH7426vr1SbQHpuuKOJ4C4O3WYHwot2gYuuP8LglS+ILwjPgonij+DowL
         tXoZAHBYIjKR3cF5HwrlavpGDxa+x9KzyRmuzNSBYLyG23g7IYAGVfA8WqK5BbI+5dJO
         28ig7T+BpLDVIfjTW2Ldpb7zBxgQYOcSPK5VDw+CgGSvo4JnmjidTXZ5gggPa2CViU5Z
         8MTQ==
X-Gm-Message-State: AOAM5321CSQ2C4CqCbl08h885amBU5Iq2BMmcnF6FUWdZkiNHBYrPUj6
        lPAPnjTHnoSbBfNctAvX9ofEAA==
X-Google-Smtp-Source: ABdhPJwSrV9ylByYHP6URYLJyyVsaDxyoDFv8jOKk1FGM5qehDvweIPCo9u6CGJK2Skc2EfPxwq7Eg==
X-Received: by 2002:a05:6602:1541:b0:649:94e:3cf7 with SMTP id h1-20020a056602154100b00649094e3cf7mr11820601iow.10.1647931959803;
        Mon, 21 Mar 2022 23:52:39 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id b12-20020a6be70c000000b00648f61d9652sm9150605ioh.52.2022.03.21.23.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 23:52:39 -0700 (PDT)
Date:   Tue, 22 Mar 2022 06:52:35 +0000
From:   Oliver Upton <oupton@google.com>
To:     Anup Patel <anup@brainfault.org>
Cc:     "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v4 07/15] KVM: Create helper for setting a system event
 exit
Message-ID: <YjlyM6/WFMB4JnHF@google.com>
References: <20220311174001.605719-1-oupton@google.com>
 <20220311174001.605719-8-oupton@google.com>
 <CAAhSdy3mH5JQ9N9JzbUpBw3ZdqKtLretsUKL3WAdMhpEXVmJRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhSdy3mH5JQ9N9JzbUpBw3ZdqKtLretsUKL3WAdMhpEXVmJRg@mail.gmail.com>
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

On Sat, Mar 19, 2022 at 12:58:28PM +0530, Anup Patel wrote:
> On Fri, Mar 11, 2022 at 11:11 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Create a helper that appropriately configures kvm_run for a system event
> > exit.
> >
> > No functional change intended.
> >
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > Acked-by: Anup Patel <anup@brainfault.org>
> > ---
> >  arch/arm64/kvm/psci.c         | 5 +----
> >  arch/riscv/kvm/vcpu_sbi_v01.c | 4 +---
> >  arch/x86/kvm/x86.c            | 6 ++----
> >  include/linux/kvm_host.h      | 2 ++
> >  virt/kvm/kvm_main.c           | 8 ++++++++
> >  5 files changed, 14 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index efd4428fda1c..78266716165e 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -173,10 +173,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
> >                 tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
> >         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> >
> > -       memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> > -       vcpu->run->system_event.type = type;
> > -       vcpu->run->system_event.flags = flags;
> > -       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> > +       kvm_vcpu_set_system_event_exit(vcpu, type, flags);
> >  }
> >
> >  static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
> > diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> > index 07e2de14433a..c5581008dd88 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_v01.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> > @@ -24,9 +24,7 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
> >                 tmp->arch.power_off = true;
> >         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> >
> > -       memset(&run->system_event, 0, sizeof(run->system_event));
> > -       run->system_event.type = type;
> > -       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> > +       kvm_vcpu_set_system_event_exit(vcpu, type, 0);
> 
> This patch needs to be rebased on the latest kvm/next because we have
> done some refactoring to support SBI v0.3 SRST extension.

Sure thing, I've already picked up some fixes anyhow so not a problem.
Thank you for letting me know directly about the conflict though :)

--
Thanks,
Oliver
