Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7894F6308C1
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 02:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiKSBvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 20:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiKSBvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 20:51:02 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47099B4B5
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:25:42 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id b131so7566347yba.11
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+1rO+iE32YVI2C13beK1Lr5yeQPaLIpsNBXXRqc/bqo=;
        b=GpIin99X6/w9xWjRCsZ+EWoJnSZej7N0lPrgLgTI0e0STqhqsyeeZaTuRu3OpvbjEx
         zviB02fC3XD9iWK0pTN6EiZjY6Tf8uv7wBZnSHl1o55KeDF/8k0H3ytjYrCJpo9POD2w
         2EZVxbuPZPEQTSYHAdf2t0XpD0re/txoc1elJbYcxL9K/c2WBriO/tWb0PE49blgoYEC
         qmTcxDH6uT5JP6aMADTdzRGvHwQoJqiTi+tQ1PcKsDY5q8J22unXHRz93/B8SXn/otcR
         faE8+jZQbf+NTTHURDLto82HESqnwolaV4jBkF/P7yD2cpM1o/ARcI3/WS9kN+j8v600
         nlIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+1rO+iE32YVI2C13beK1Lr5yeQPaLIpsNBXXRqc/bqo=;
        b=3F+2rfXL3rAQkMDIFcx09OugCJSxlI7pQd43oys38QRWyvLPCDnqRUUmnOH1/U+w2F
         Vs5THocJMPidAeSF/xuHLJ3jAJuzND8pgh9jb2FkWhfrk/J/6fdVkfVuO8M3Z1RCkL7X
         QDmfoaPDD5DKtc0Oh+z+LELnpQ/DXA2jM2UIdUJit6711d02ybwIgJ42ZixiS2M+mXqY
         ekrCrBT2qpM96524o/aZGJkaAeiKrNII/jh2yV3oAr7ixJXIeJEaJ+o0Xcpau8Xu+hMO
         FiWIaIhaBcYvMnOctkhXHeJfkzXto0nYo2di1AjLdl0vmgZu6cNL7TuCpqX6EwjNKfp2
         Jj0Q==
X-Gm-Message-State: ANoB5plUXaE9dSDu/8UMRkO6MNgQLCfaa0dXIZqHs7ow4Khnzr5d+ygK
        s1jZHUOFLcUs3Rttfmee8dTc2+COlltnh9dHlqbrRw==
X-Google-Smtp-Source: AA0mqf7Qw4UkOdWFIq8pgraYV1aFtBVIj7+WeMbTcdl6TQ1NzoiNT63lcihVGxGRbmZyxNiZjILzZfrdOO2pmPFQPaU=
X-Received: by 2002:a25:ae12:0:b0:6d0:704:f19f with SMTP id
 a18-20020a25ae12000000b006d00704f19fmr9436888ybj.191.1668821141314; Fri, 18
 Nov 2022 17:25:41 -0800 (PST)
MIME-Version: 1.0
References: <20221117001657.1067231-1-dmatlack@google.com> <20221117001657.1067231-4-dmatlack@google.com>
 <97ccc949-254e-879d-9206-613b328c271d@huawei.com> <CALzav=fY6-C_Y1+8B0_hQM9X8L-SA2cEULgcp24-6f_xVLgkqw@mail.gmail.com>
In-Reply-To: <CALzav=fY6-C_Y1+8B0_hQM9X8L-SA2cEULgcp24-6f_xVLgkqw@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 18 Nov 2022 17:25:15 -0800
Message-ID: <CALzav=dxO9uN63vuhdmja5s5y1PLUOA36KdCVwVWWALgCjBpSw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] KVM: Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL
To:     "wangyanan (Y)" <wangyanan55@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        wangyuan38@huawei.com
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

On Fri, Nov 18, 2022 at 8:58 AM David Matlack <dmatlack@google.com> wrote:
>
> On Fri, Nov 18, 2022 at 12:28 AM wangyanan (Y) <wangyanan55@huawei.com> wrote:
> >
> > Hi David,
> >
> > On 2022/11/17 8:16, David Matlack wrote:
> > > Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL on every halt,
> > > rather than just sampling the module parameter when the VM is first
> > s/first/firstly
> > > created. This restore the original behavior of kvm.halt_poll_ns for VMs
> > s/restore/restores
> > > that have not opted into KVM_CAP_HALT_POLL.
> > >
> > > Notably, this change restores the ability for admins to disable or
> > > change the maximum halt-polling time system wide for VMs not using
> > > KVM_CAP_HALT_POLL.
> > Should we add more detailed comments about relationship
> > between KVM_CAP_HALT_POLL and kvm.halt_poll_ns in
> > Documentation/virt/kvm/api.rst? Something like:
> > "once KVM_CAP_HALT_POLL is used for a target VM, it will
> > completely ignores any future changes to kvm.halt_poll_ns..."
>
> Yes we should.
>
> I will do some testing on this series today and then resend the series
> as a non-RFC with the Documentation changes.
>
> Thanks for the reviews.

Initial testing looks good but I did not have time to finish due to a
bug in how our VMM is currently using KVM_CAP_HALT_POLL. I will be out
all next week so I'll pick this up the week after.

>
> > > Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > > Fixes: acd05785e48c ("kvm: add capability for halt polling")
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >   include/linux/kvm_host.h |  1 +
> > >   virt/kvm/kvm_main.c      | 27 ++++++++++++++++++++++++---
> > >   2 files changed, 25 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index e6e66c5e56f2..253ad055b6ad 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -788,6 +788,7 @@ struct kvm {
> > >       struct srcu_struct srcu;
> > >       struct srcu_struct irq_srcu;
> > >       pid_t userspace_pid;
> > > +     bool override_halt_poll_ns;
> > >       unsigned int max_halt_poll_ns;
> > >       u32 dirty_ring_size;
> > >       bool vm_bugged;
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 78caf19608eb..7f73ce99bd0e 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -1198,8 +1198,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> > >                       goto out_err_no_arch_destroy_vm;
> > >       }
> > >
> > > -     kvm->max_halt_poll_ns = halt_poll_ns;
> > > -
> > >       r = kvm_arch_init_vm(kvm, type);
> > >       if (r)
> > >               goto out_err_no_arch_destroy_vm;
> > > @@ -3490,7 +3488,20 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
> > >
> > >   static unsigned int kvm_vcpu_max_halt_poll_ns(struct kvm_vcpu *vcpu)
> > >   {
> > > -     return READ_ONCE(vcpu->kvm->max_halt_poll_ns);
> > > +     struct kvm *kvm = vcpu->kvm;
> > > +
> > > +     if (kvm->override_halt_poll_ns) {
> > > +             /*
> > > +              * Ensure kvm->max_halt_poll_ns is not read before
> > > +              * kvm->override_halt_poll_ns.
> > > +              *
> > > +              * Pairs with the smp_wmb() when enabling KVM_CAP_HALT_POLL.
> > > +              */
> > > +             smp_rmb();
> > > +             return READ_ONCE(kvm->max_halt_poll_ns);
> > > +     }
> > > +
> > > +     return READ_ONCE(halt_poll_ns);
> > >   }
> > >
> > >   /*
> > > @@ -4600,6 +4611,16 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
> > >                       return -EINVAL;
> > >
> > >               kvm->max_halt_poll_ns = cap->args[0];
> > > +
> > > +             /*
> > > +              * Ensure kvm->override_halt_poll_ns does not become visible
> > > +              * before kvm->max_halt_poll_ns.
> > > +              *
> > > +              * Pairs with the smp_rmb() in kvm_vcpu_max_halt_poll_ns().
> > > +              */
> > > +             smp_wmb();
> > > +             kvm->override_halt_poll_ns = true;
> > > +
> > >               return 0;
> > >       }
> > >       case KVM_CAP_DIRTY_LOG_RING:
> > Looks good to me:
> > Reviewed-by: Yanan Wang <wangyanan55@huawei.com>
> >
> > Thanks,
> > Yanan
