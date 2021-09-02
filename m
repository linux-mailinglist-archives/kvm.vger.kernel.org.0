Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BE13FF2D8
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 19:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346689AbhIBRxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 13:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhIBRxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 13:53:15 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990E2C061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 10:52:16 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id a93so5484112ybi.1
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xAUZw7IrrctnJdeQBEtbAhv9xiy70VOpKzIZyk6KqAA=;
        b=iyKqthjIRwPONyCS4/FKOde7Qj8MPxzxsMuN8Ti/E5d4o95dMRFhXGD0ZN2pu7RPVp
         JwWUX/2NUc7y4oxHWdsjIHW4i99GjxckLQGR8lyOsGYMBoUAf4tdI8Tc2b2WN05V78s1
         1ci/XTZoMbCx+VULa5z5tq7lKuPFjEOFL2ewyVdnHWMbRBr8zMXxtFQ47bECS/S778Vd
         uWYSbkDI5Q7wCUKjWhT936QxX63P6W5fUF+RE1aax17r7lqa+ihcXphy+D1BQzgYmBOh
         74HWpCi3vjxnYhTz4SIltFZH+bMTbuiVxuEulZmZgyDq40oAz76TRf9JSIgTAEM3wNC2
         3lXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xAUZw7IrrctnJdeQBEtbAhv9xiy70VOpKzIZyk6KqAA=;
        b=JtJiYkl9VmC3vREucevMxC8uOqP3SfAUuJFH0HKyygOteGA70wzJWhOQik7qFHs6h9
         /vi1FM2Q0Ikio/ZgRnLcf5/ycD9ii8Ta32dfnPHsRlQldx41ynsg4Losi4I7nvcNFi2j
         /XlygwQQQ7L7l0JUZYoj+Eh4nKE0YMyDQfmuO9VJ21yEojoCZxy/mehQtyL7WCHLY8G+
         J9pDfurBKUnKY321ztvxGy5qGmhYzb0RgJIE8AuVJWFflScguLK22OXjAtRnsFB7I8ci
         WdF7AxYC+IqWswiiL7U4trsRnaW2R0u1lzjuiCYniAF9fcjMr+Qc3+91RVB+YR31VIh9
         +9dw==
X-Gm-Message-State: AOAM531ANknzkO/5kA5MetLRlBCmg/6lFXuXqR5inaj/fnGTxw7RXr6s
        LvcKHbPryjMozGY1d2+47l2gO+KtK00NpXfR3BD4eQ==
X-Google-Smtp-Source: ABdhPJwQXtJzqbxl4gNeMNvhKYFqgI/uCi3/Up5vD6artyFiw1jvBI/+9aQ5dnuQX2F2LGGKUfF/T1/Eh5NonYuxIbU=
X-Received: by 2002:a25:4f87:: with SMTP id d129mr5967977ybb.359.1630605135660;
 Thu, 02 Sep 2021 10:52:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com> <20210901211412.4171835-8-rananta@google.com>
 <YTARPBhMHXjgcPlg@google.com> <20210902123656.lfzwqrlw5kbvckah@gator>
In-Reply-To: <20210902123656.lfzwqrlw5kbvckah@gator>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 2 Sep 2021 10:52:05 -0700
Message-ID: <CAJHc60xQYiOsQcZ64SVsVRarnb2b+fefRYq+xQ8FeqGxH0fY2w@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] KVM: arm64: selftests: Add support to get the
 vcpuid from MPIDR_EL1
To:     Andrew Jones <drjones@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 2, 2021 at 5:37 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Sep 01, 2021 at 11:48:12PM +0000, Oliver Upton wrote:
> > On Wed, Sep 01, 2021 at 09:14:07PM +0000, Raghavendra Rao Ananta wrote:
> > > At times, such as when in the interrupt handler, the guest wants to
> > > get the vCPU-id that it's running on. As a result, introduce
> > > get_vcpuid() that parses the MPIDR_EL1 and returns the vcpuid to the
> > > requested caller.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  .../selftests/kvm/include/aarch64/processor.h | 19 +++++++++++++++++++
> > >  1 file changed, 19 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > index c35bb7b8e870..8b372cd427da 100644
> > > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > @@ -251,4 +251,23 @@ static inline void local_irq_disable(void)
> > >     asm volatile("msr daifset, #3" : : : "memory");
> > >  }
> > >
> > > +#define MPIDR_LEVEL_BITS 8
> > > +#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
> > > +#define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
> > > +#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
> > > +   ((mpidr >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK)
> > > +
> > > +static inline uint32_t get_vcpuid(void)
> > > +{
> > > +   uint32_t vcpuid = 0;
> > > +   uint64_t mpidr = read_sysreg(mpidr_el1);
> > > +
> > > +   /* KVM limits only 16 vCPUs at level 0 */
> > > +   vcpuid = mpidr & 0x0f;
> > > +   vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 1) << 4;
> > > +   vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 2) << 12;
> > > +
> > > +   return vcpuid;
> > > +}
> >
> > Are we guaranteed that KVM will always compose vCPU IDs the same way? I
> > do not believe this is guaranteed ABI.
>
> I don't believe we are. At least in QEMU we take pains to avoid that
> assumption.
>
> >
> > For the base case, you could pass the vCPU ID as an arg to the guest
> > function.
> >
> > I do agree that finding the vCPU ID is a bit more challenging in an
> > interrupt context. Maybe use a ucall to ask userspace? But of course,
> > every test implements its own run loop, so its yet another case that
> > tests need to handle.
> >
> > Or, you could allocate an array at runtime of length KVM_CAP_MAX_VCPUS
> > (use the KVM_CHECK_EXTENSION ioctl to get the value). Once all vCPUs are
> > instantiated, iterate over them from userspace to populate the {MPIDR,
> > VCPU_ID} map. You'd need to guarantee that callers initialize the vGIC
> > *after* adding vCPUs to the guest.
>
> I agree with this approach. It may even make sense to create a common
> function that returns a {cpu_id,vcpu_index} map for other tests to use.
>
Interesting idea. I'll look into this.

Regards,
Raghavendra

> Thanks,
> drew
>
> >
> > --
> > Thanks,
> > Oliver
> >
> > >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > > --
> > > 2.33.0.153.gba50c8fa24-goog
> > >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
>
