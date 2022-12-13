Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCE964AD3C
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 02:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiLMBj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 20:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbiLMBjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 20:39:31 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A26095A3
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:39:23 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso1954400pjt.0
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gw9lJ6aK3kO8Zby1Es3z12UsrjzqgSAcUGWG4cZ2Bi4=;
        b=gn3WsGo0laaxSpOG0/xHVWdUjJwAYJXJFUMg0qSkAcEqESWPgswuKaJd+FIZH44nhY
         Hza8l83wFUF3cY/CDEE3sS/SxYc2ZCIOF8dAYZYAFdywS3i+W8O490U+Y3seOiPNNXR3
         0hJXlJFo4aAKHdJUNwcdI2d/v/rYxICeXdNUn8DBl/efFllH7AD6qUyqpf6tEVtICHz1
         d9AfjuC9B+XnDioGgjVmCnxxlEkMmDAZt6Zpb2GhtnqDhk95yVvLfvrZtSzK3KHa/Q4I
         qubuw/JeHsVYP7kayMH6vmhZ/PVgSvEreoLKnTl3LrmArjwhG4QpAdks32Q8Nu0IpSV9
         Bnqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gw9lJ6aK3kO8Zby1Es3z12UsrjzqgSAcUGWG4cZ2Bi4=;
        b=kWxMgQvGyaI7SAwLqONnFjbE6FOTj6Xd0cdnYhPgCunkgVUIxNa99cAeYt8ypW0iJu
         BEykLYLn6UySS4aJnUD57eRyGX4NexgJexSvuWUnbhtOIzcbaDTQi9FX1mLQ17DoMCrS
         6AIJNoFTwmkkIEfcHCwIEw+CRpQtLiGXIwdVaFOrV5JhFgyoTiDBrxrSgSLcyKEu6lPM
         i7eKzh1KjOFk9csTqHZYl+vjTyxeSCf0cd+HYj8nzCd7XLBsfqAZn42FCqg9APpTXATs
         Hq8AsIiQPoOUFDAtUt1ssiVvpVZZYzyPFwpvoRy10PLcjve7fniC3gx24e98UoEuILAw
         YIyA==
X-Gm-Message-State: ANoB5pnoD1c/flzvVz6sEToU5XpsRI0FMf0UXKCpUrbd7b3yDrNavuiq
        DggTFxc6k77JNYx97v8rULOYdw==
X-Google-Smtp-Source: AA0mqf5sKn41TAu/WUk4Ug3Jl/DPtoBxsoRElbzkJJdKW3eZ3ktQUDCszH+u3IpNiqgnYfNJcu3+Qg==
X-Received: by 2002:a05:6a20:d38e:b0:aa:5c2d:ae2a with SMTP id iq14-20020a056a20d38e00b000aa5c2dae2amr21754266pzb.61.1670895562379;
        Mon, 12 Dec 2022 17:39:22 -0800 (PST)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b00172973d3cd9sm7091052plg.55.2022.12.12.17.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 17:39:21 -0800 (PST)
Date:   Tue, 13 Dec 2022 01:39:18 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH v4 0/2] Deprecate BUG() in pte_list_remove() in
 shadow mmu
Message-ID: <Y5fXxsPtDeMZn2nV@google.com>
References: <20221129191237.31447-1-mizhang@google.com>
 <Y5Oob6mSJKGoDBnt@google.com>
 <Y5avm5VXpRt263wQ@google.com>
 <Y5dax8XJV0F5adUw@google.com>
 <CALzav=f2k9dPYkeW2D0ZvkDuDhA8Wmu+zV8W4isMFfd-HAQjrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=f2k9dPYkeW2D0ZvkDuDhA8Wmu+zV8W4isMFfd-HAQjrA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022, David Matlack wrote:
> On Mon, Dec 12, 2022 at 8:46 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Dec 12, 2022, Mingwei Zhang wrote:
> > > On Fri, Dec 09, 2022, David Matlack wrote:
> > > > On Tue, Nov 29, 2022 at 07:12:35PM +0000, Mingwei Zhang wrote:
> > > > > Deprecate BUG() in pte_list_remove() in shadow mmu to avoid crashing a
> > > > > physical machine. There are several reasons and motivations to do so:
> > > > >
> > > > > MMU bug is difficult to discover due to various racing conditions and
> > > > > corner cases and thus it extremely hard to debug. The situation gets much
> > > > > worse when it triggers the shutdown of a host. Host machine crash might
> > > > > eliminates everything including the potential clues for debugging.
> > > > >
> > > > > From cloud computing service perspective, BUG() or BUG_ON() is probably no
> > > > > longer appropriate as the host reliability is top priority. Crashing the
> > > > > physical machine is almost never a good option as it eliminates innocent
> > > > > VMs and cause service outage in a larger scope. Even worse, if attacker can
> > > > > reliably triggers this code by diverting the control flow or corrupting the
> > > > > memory, then this becomes vm-of-death attack. This is a huge attack vector
> > > > > to cloud providers, as the death of one single host machine is not the end
> > > > > of the story. Without manual interferences, a failed cloud job may be
> > > > > dispatched to other hosts and continue host crashes until all of them are
> > > > > dead.
> > > >
> > > > My only concern with using KVM_BUG() is whether the machine can keep
> > > > running correctly after this warning has been hit. In other words, are
> > > > we sure the damage is contained to just this VM?
> >
> > Hmm, good point.  The counter-argument is that KVM doesn't BUG() in get_mmio_spte()
> > when a non-MMIO SPTE has reserved bits set, and as we've seen internally in multiple
> > splats where the reserved bits appear to be set by stack overflow, that has a much,
> > much higher probability of being a symptom of data corruption.
> >
> > That said, that's more of a reason to change get_mmio_spte() than it is to ignore
> > potential data corruption in this case.  KVM arguably should kill the VM if
> > get_mmio_spte() fails too.
> >
> > What about explicitly treating both get_mmio_spte() and this as potential data
> > corruption?  E.g. something like this, and then use the DATA_CORRUPTION variant
> > in pte_list_remove()?
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 2055e04b8f89..1cb69c6d186b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4075,6 +4075,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
> >                         pr_err("------ spte = 0x%llx level = %d, rsvd bits = 0x%llx",
> >                                sptes[level], level,
> >                                get_rsvd_bits(rsvd_check, sptes[level], level));
> > +               KVM_BUG_ON_DATA_CORRUPTION(reserved, vcpu->kvm);
> >         }
> >
> >         return reserved;
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f16c4689322b..5c4a06f66f46 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -863,6 +863,17 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
> >         unlikely(__ret);                                        \
> >  })
> >
> > +#define KVM_BUG_ON_DATA_CORRUPTION(cond, kvm)                  \
> > +({                                                             \
> > +       int __ret = (cond);                                     \
> > +                                                               \
> > +       if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION))          \
> > +               BUG_ON(__ret);                                  \
> > +       else if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))      \
> > +               kvm_vm_bugged(kvm);                             \
> > +       unlikely(__ret);                                        \
> > +})
> > +
> >  static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
> >  {
> >  #ifdef CONFIG_PROVE_RCU
> 
> That sounds reasonable to me.

Actually, I disagree after thinking about it for a while. Since
Google turns on CONFIG_BUG_ON_DATA_CORRUPTION on default, this
KVM_BUG_ON_DATA_CORRUPTION() is literally BUG_ON(). Then there is no
point. The purpose of the series is to save the host from crash.

If we follow the upper changes on get_mmio_spte() as well, we are
introducing more BUG()!, ie., more chances to crash the host machine. So
I cannot stay with this idea.

In fact, there could many reasons why RMAPs and SPTEs are messed. In
many times, as illustrated by my example, they are not data corruptions.
They are just errors due to code refactoring or some miscalculations
under certain tricky corner situations, e.g., offset by 1.  So, treating
them blindly as data corruptions is an overkill. This is a comparison to
the list traversal bug, which clearly shows data corruptions.

So, alternatively, I think it should be reasonable to shutdown the KVM
instance if we see things messed up in MMIO SPTEs as well, but please
don not the host for that.


