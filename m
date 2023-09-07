Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F07679737A
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 17:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjIGPYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 11:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjIGPVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 11:21:51 -0400
Received: from mail-vs1-xe4a.google.com (mail-vs1-xe4a.google.com [IPv6:2607:f8b0:4864:20::e4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9261F1BF
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 08:21:23 -0700 (PDT)
Received: by mail-vs1-xe4a.google.com with SMTP id ada2fe7eead31-44ea3b44f9eso410697137.3
        for <kvm@vger.kernel.org>; Thu, 07 Sep 2023 08:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694100082; x=1694704882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FgzAJvMWabKSg+Fs2ABIxLNoYDB74sHy1tmQmF1BFrA=;
        b=0Y0KNUXHk7p8szMIu6nqzrVlh/RZJ9GuBmczypjwztJbMAbdpybVcow9YADNMU3H8y
         Hldsy0RNw+318ulTydQJkh6pcAY1gyvAjMku8DAeBe815gBtTPvGMqUv8tTtG99JOcd+
         tiZEAJ3rmWCKWZC3JdKxD4qAX4Eau+R+MAHZTcl+yjsrSYmQAEEJ474VYanB0s+U1roF
         u2ZbGjF8sn1IPqECFKuqODhvN+SkzBmMUTd2jK0Bf1b9/xs/wVhgCn7a0EQESBCuWx1u
         QajzjaQoWOloNSuQVAq/gIvlcStJIhOtvn4QGZe1GDSr9sxTOJdeKKz9Iof52vx7VYyB
         WChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694100082; x=1694704882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FgzAJvMWabKSg+Fs2ABIxLNoYDB74sHy1tmQmF1BFrA=;
        b=eQJGdL601Ok/Gxtb3jbf9hbhvr+KSVnkVX5llklf4wBcon0XcCqaHWe8FD9XpwZ68C
         wBIU9rt04Wl5hd/fWYbs1HIKKipUxeFe9WEf/u4aSEAClQvePNQr4sOMB2kF3MRhr9nO
         0LOkMZqGMeccEtxLPju6Nd9d5AYD/6WrKvA0pntdRXVAKvBvUMWkWc8s708xYAfa7ZUN
         iH+luqfGAZ3aGsRwmAveq7lq156Mh7JBVJYU2Ev5Su9ObRlnB/WPDi4r6qQ2lvM+AMKt
         6paUSvTAM/l91nfPi00P5oKFwx6jaIEKi5MWR4lMYUcvohiSZL8wqo8zgQtz/IoR/iIL
         yobw==
X-Gm-Message-State: AOJu0YxozHwnT0xCwFVLVJfJJgQaonrr3icj5RQ3LK92h9j0VueIqzxH
        pha9sZKQY8f5nAQ8Iq0DaKiRL0IyXfw=
X-Google-Smtp-Source: AGHT+IFZD8rMKqtrUZuxadapb0kMDmHCmcHSIKx2uaonJiqykBzMJVL+4SXojH5SnWKxOUNiBkjxt5kZ8C0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1cc:b0:d07:e80c:412e with SMTP id
 u12-20020a05690201cc00b00d07e80c412emr228078ybh.12.1694097933191; Thu, 07 Sep
 2023 07:45:33 -0700 (PDT)
Date:   Thu, 7 Sep 2023 07:45:31 -0700
In-Reply-To: <68859513bc0fb4eda4e3e62ec073dd2a58f7676b.camel@intel.com>
Mime-Version: 1.0
References: <20230825020733.2849862-1-seanjc@google.com> <20230825020733.2849862-3-seanjc@google.com>
 <68859513bc0fb4eda4e3e62ec073dd2a58f7676b.camel@intel.com>
Message-ID: <ZPniC2JCOPMK1JQb@google.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Y Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023, Kai Huang wrote:
> On Thu, 2023-08-24 at 19:07 -0700, Sean Christopherson wrote:
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 1a5a1e7d1eb7..8e2e07ed1a1b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4334,6 +4334,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >  	if (unlikely(!fault->slot))
> >  		return kvm_handle_noslot_fault(vcpu, fault, access);
> >  
> > +	if (mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva))
> > +		return RET_PF_RETRY;
> > +
> 
> ... Perhaps a comment saying this is to avoid unnecessary MMU lock contention
> would be nice.  Otherwise we have is_page_fault_stale() called later within the
> MMU lock.  I suppose people only tend to use git blamer when they cannot find
> answer in the code :-)

Agreed, will add.

> >  	return RET_PF_CONTINUE;
> >  }
> >  
> 
> Btw, currently fault->mmu_seq is set in kvm_faultin_pfn(), which happens after
> fast_page_fault().  Conceptually, should we move this to even before
> fast_page_fault() because I assume the range zapping should also apply to the
> cases that fast_page_fault() handles?

Nope, fast_page_fault() doesn't need to "manually" detect invalidated SPTEs because
it only modifies shadow-present SPTEs and does so with an atomic CMPXCHG.  If a
SPTE is zapped by an mmu_notifier event (or anything else), the CMPXCHG will fail
and fast_page_fault() will see the !PRESENT SPTE on the next retry and bail.
