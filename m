Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B94C38B4BF
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 18:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhETQ7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 12:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbhETQ7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 12:59:18 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06761C061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 09:57:57 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id h9so17049109oih.4
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 09:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u3Kv7ARv6Puu/f+2EdKOKCXqLT6GwVj82fp6ym2E0h4=;
        b=YrtdJVTqMK2Vo8VyfY/eP6OAoxZoZ1e6jHxlL3OvO3DNdrFlzhfG5/9FaWhGxIAc3V
         8fhFDVLdi+9amw4S2vo7MjrNwUSAMd7iDoGY5mXWBu3j6sECBGWYYchJjjmc9vF0M28K
         mgIFsoK6jJUG0lrPVZ4QCQ+vaGHxNG9dWj+54aW6CUW+rCBCdqBmHsNPXoQBQWgpjIUH
         GStgwUS/hgxYVcj1IMjJ1AUqF/NapU0sPcA+UF8DE1tpBnX0CDk7LNw/A5obld61zUHA
         x9cx9QZA5FaIRPVGK+ALaqEvopGVWZhgB8w6eYkcLhg+wT5YyNBH6aaw8Pxh5uu6+Yol
         743Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u3Kv7ARv6Puu/f+2EdKOKCXqLT6GwVj82fp6ym2E0h4=;
        b=ANureMF7Bc6c8CLw4D+BgQzj2coLlWb6WdiXCiurbPEAOcoNlOJUHlQ2LdR9iz/Ih+
         jiNRD4USTY26h/NVdX7sE9CTkUFKwaDeCHS03hVq+vjIe2V9ATH6N06BxwY1GWR+hcup
         ac0mBKwXVKqJMawPuVkjK64zGsM5F2KMDEE7vkdd3d8tyE7XLrUmO8ihbRlEBxYgncjU
         Ibc1jkRb6Q5iiQRMxmSILMOZxq6OAtKAXVfWEbK5VtQsCK4ouSBmoZCRO1aVIP1L54Ly
         L+Oc3bI/V6Anc7hmupHgNt8wsxEzxvc/jP+JpsN2ejhILHOwWVWX/iJ0Jwq0A9zeDqVT
         gZPA==
X-Gm-Message-State: AOAM533O34FuOT6b6zktONBFJMfKvyB3OqdF6MiPg30yHMJOtcP4t2Xk
        ou/BMU4nzvrtuA1IRvuVdFpoL90p0JPK89PeHHl5Aw==
X-Google-Smtp-Source: ABdhPJzhWsQwGuayNcCTnm9PVDPH6Xu8JUxaUXh3KURIhnlyiSSxFyIoUpeed3onvFEq3cuP4TtZS5ax4hH0aJSi6U4=
X-Received: by 2002:aca:280a:: with SMTP id 10mr4146578oix.13.1621529876011;
 Thu, 20 May 2021 09:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
 <20210520005012.68377-4-krish.sadhukhan@oracle.com> <YKZ4qTp2OIS6LYy2@google.com>
In-Reply-To: <YKZ4qTp2OIS6LYy2@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 May 2021 09:57:45 -0700
Message-ID: <CALMp9eT+Sj4=tQZJaeLfJALkeUbo=jiTmM-CQ71z5aOhD6MMiw@mail.gmail.com>
Subject: Re: [PATCH 3/4 v2] KVM: nVMX: nSVM: Add a new debugfs statistic to
 show how many VCPUs have run nested guests
To:     Sean Christopherson <seanjc@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 7:56 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 19, 2021, Krish Sadhukhan wrote:
> > Add a new debugfs statistic to show how many VCPUs have run nested guests.
> > This statistic considers only the first time a given VCPU successfully runs
> > a nested guest.
> >
> > Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 1 +
> >  arch/x86/kvm/svm/svm.c          | 5 ++++-
> >  arch/x86/kvm/vmx/vmx.c          | 5 ++++-
> >  arch/x86/kvm/x86.c              | 1 +
> >  4 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index cf8557b2b90f..a19fe2cfaa93 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1138,6 +1138,7 @@ struct kvm_vm_stat {
> >       ulong lpages;
> >       ulong nx_lpage_splits;
> >       ulong max_mmu_page_hash_collisions;
> > +     ulong vcpus_ran_nested;
> >  };
> >
> >  struct kvm_vcpu_stat {
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 57c351640355..d1871c51411f 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3876,8 +3876,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
> >               /* Track VMRUNs that have made past consistency checking */
> >               if (svm->nested.nested_run_pending &&
> >                   svm->vmcb->control.exit_code != SVM_EXIT_ERR &&
> > -                 svm->vmcb->control.exit_code != SVM_EXIT_NPF)
> > +                 svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
> > +                     if (!vcpu->stat.nested_runs)
> > +                             ++vcpu->kvm->stat.vcpus_ran_nested;
>
> Using a separate counter seems unnecessary, userspace can aggregate
> vcpu->stat.nested_run itself to see how many vCPUs have done nested VM-Enter.
>
> Jim, were you thinking of something else?  Am I missing something?

It was in the context of a proposed stat to indicate how many vCPUs
are *currently* running nested guests that I said I'd rather just know
how many vCPUs had *ever* run nested guests. I don't need a separate
stat. Checking vcpu->stat.nested_run for non-zero values works fine
for me.
