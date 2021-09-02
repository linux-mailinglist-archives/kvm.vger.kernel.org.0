Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFDD3FF2ED
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 19:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346868AbhIBSAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346850AbhIBSAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:00:20 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D328C061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 10:59:22 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v26so5462248ybd.9
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 10:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I6lNmz1ZHPNmtMHcGebqNi31a0bwccl3naNODv57iB0=;
        b=hBowUWs5ABee1O6qSaIcb6Azek8v4ILJhEmiOTmf2XcZFin/3vVoktd+dfRrLP9HfS
         hM4m55PRK0rVzr030c/PL04yUtTQ2jPcHp1rubY12nnMKEkLVCCQtVChTYRS8k329YuF
         vCOt3jQI0Jb/qyYgEUCL5wPG2X1fblZWZ8LLoO+Esc5rIVSxYpUpkNiv1g8f+9+bc6HF
         9BR9ErUyBkxwNWd3yIROJd2r0lPpcEsJzQKoEdsAHj4ixE4i41o/gn6LLnOuoc8I+6df
         xxk9yXBkTMNySknd7yExpoyAn/6oRHph3/oYLLL2+oY/ryvO+Rm9Sn6ab0AWZH7HSKa1
         UhYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I6lNmz1ZHPNmtMHcGebqNi31a0bwccl3naNODv57iB0=;
        b=qd/rntQubwa8z31qv5UxU49NMFYBoNFCGZc3V6F2CrmAzWGQMenkvdl0gQx0T3z0jU
         SHxj2QvU/Vq9bm+sTnNWb49gXsNF4eAw0oiS68BVfc9qB+8J43K7Id4SRoOIT97bRrJ8
         GLFbjudBAqkC30nqgjz1uEComFXj+ccKnWpMKLG/FatEmQ6BPiW/LvxUTQNfuUiKTCEz
         bxw6BgRJFHYtIvwDUYkF2XVU6F1ZCeh1pNXlpdt/XOH7HT/WzrV82aTNfOb8nxBfawK1
         BLwp9LI6RqyjOvydf21e9d/PDPXAhFC7dBhX1Z/+0irtoJQDwEY4LRXzlAFxqdKRIesU
         LM+g==
X-Gm-Message-State: AOAM533s/4HegBkbo6lbraD/+oEGYI/+ARCYTNS55NRd69SmyfniQEPK
        5IO1zAnknvdLJNnHgE14znK6A2VURDlZMWWHEZihQA==
X-Google-Smtp-Source: ABdhPJwU2Al1PvBzdSgmpnQsQopc50AvxUK0PW3IjKLQDYe5gecpLFlqArUCMUIPs+Id17BVGWtI+q72jBUHYsGgTpY=
X-Received: by 2002:a25:38ce:: with SMTP id f197mr5816802yba.254.1630605561360;
 Thu, 02 Sep 2021 10:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com> <20210901211412.4171835-11-rananta@google.com>
 <YTEJt2pC1cIcwvyD@google.com>
In-Reply-To: <YTEJt2pC1cIcwvyD@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 2 Sep 2021 10:59:10 -0700
Message-ID: <CAJHc60zR8q28kvbpB2USeVR154OzKLQuZOFSOOOsW0WrqD0OEw@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] KVM: arm64: selftests: Add host support for vGIC
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 2, 2021 at 10:28 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Sep 01, 2021 at 09:14:10PM +0000, Raghavendra Rao Ananta wrote:
> > Implement a simple library to do perform vGIC-v3
> > setup from a host of view. This includes creating
> > a vGIC device, setting up distributor and redistributor
> > attributes, and mapping the guest physical addresses.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >
> > ---
> >  tools/testing/selftests/kvm/Makefile          |  2 +-
> >  .../selftests/kvm/include/aarch64/vgic.h      | 14 ++++
> >  .../testing/selftests/kvm/lib/aarch64/vgic.c  | 67 +++++++++++++++++++
> >  3 files changed, 82 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 5476a8ddef60..8342f65c1d96 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -35,7 +35,7 @@ endif
> >
> >  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
> >  LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> > -LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c
> > +LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
> >  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
> >
> >  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> > new file mode 100644
> > index 000000000000..45bbf238147a
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> > @@ -0,0 +1,14 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * ARM Generic Interrupt Controller (GIC) host specific defines
> > + */
> > +
> > +#ifndef SELFTEST_KVM_VGIC_H
> > +#define SELFTEST_KVM_VGIC_H
> > +
> > +#include <linux/kvm.h>
> > +
> > +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> > +             uint64_t gicd_base_gpa, uint64_t gicr_base_gpa, uint32_t slot);
> > +
> > +#endif /* SELFTEST_KVM_VGIC_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > new file mode 100644
> > index 000000000000..a0e4b986d335
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > @@ -0,0 +1,67 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * ARM Generic Interrupt Controller (GIC) v3 host support
> > + */
> > +
> > +#include <linux/kvm.h>
> > +#include <linux/sizes.h>
> > +
> > +#include "kvm_util.h"
> > +
> > +#define VGIC_V3_GICD_SZ              (SZ_64K)
> > +#define VGIC_V3_GICR_SZ              (2 * SZ_64K)
> > +
> > +#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
> > +     (((uint64_t)(count) << 52) | \
> > +     ((uint64_t)((base) >> 16) << 16) | \
> > +     ((uint64_t)(flags) << 12) | \
> > +     index)
> > +
> > +static void vgic_v3_map(struct kvm_vm *vm, uint64_t addr, unsigned int size)
> > +{
> > +     unsigned int n_pages = DIV_ROUND_UP(size, vm_get_page_size(vm));
> > +
> > +     virt_map(vm, addr, addr, n_pages);
> > +}
> > +
> > +/*
> > + * vGIC-v3 default host setup
> > + *
> > + * Input args:
> > + *   vm - KVM VM
> > + *   nr_vcpus - Number of vCPUs for this VM
> > + *   gicd_base_gpa - Guest Physical Address of the Distributor region
> > + *   gicr_base_gpa - Guest Physical Address of the Redistributor region
> > + *
> > + * Output args: None
> > + *
> > + * Return: GIC file-descriptor or negative error code upon failure
> > + *
> > + * The function creates a vGIC-v3 device and maps the distributor and
> > + * redistributor regions of the guest.
> > + */
> > +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> > +             uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
> > +{
> > +     uint64_t redist_attr;
> > +     int gic_fd;
> > +
> > +     TEST_ASSERT(nr_vcpus <= KVM_MAX_VCPUS,
> > +                     "Invalid number of CPUs: %u\n", nr_vcpus);
> > +
> > +     gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
>
> Nit: you can return early if gic_fd is bad.
>
kvm_create_device() already takes care of this and the test would
simply fail if gic_fd was bad.
So, I think we can positively move on :)
> > +
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +                     KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> > +     vgic_v3_map(vm, gicd_base_gpa, VGIC_V3_GICD_SZ);
>
> vgic_v3_map() implies that it's doing something vgic specific, when it's
> just converting bytes to pages. What about something like the following?
>
>         virt_map(vm, addr, addr, VM_BYTES_TO_PAGES(vm, VGIC_V3_GICD_SZ));
>
> and you add a VM_BYTES_TO_PAGES macro to include/kvm_util.h? I think
> this macro can be useful to others.
>
Yeah, good idea. Will do.

Regards,
Raghavendra
> > +
> > +     redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +                     KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> > +     vgic_v3_map(vm, gicr_base_gpa, VGIC_V3_GICR_SZ * nr_vcpus);
> > +
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> > +                             KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> > +
> > +     return gic_fd;
> > +}
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
