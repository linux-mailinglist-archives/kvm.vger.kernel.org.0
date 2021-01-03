Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402CD2E8E1D
	for <lists+kvm@lfdr.de>; Sun,  3 Jan 2021 21:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbhACUdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jan 2021 15:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbhACUdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jan 2021 15:33:51 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559B8C061573
        for <kvm@vger.kernel.org>; Sun,  3 Jan 2021 12:33:10 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id l11so60027575lfg.0
        for <kvm@vger.kernel.org>; Sun, 03 Jan 2021 12:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=U+a2luozCBI5I40vTTLfU6Awhfwi9erF3FhBkNGcEgg=;
        b=l/vHWg/pu7SP+K31KtB8V6EXN63Z8mbPDa76mpo9KzlnFYtlaBXG5PSC8izcPxO13N
         W1r8A2IROPLIyNGbrXJlJ4yHvx01ZXNE+HwlQiCXGRVO1Mt2hhUyVHZ3UJnYh7EgaXp/
         kfo0UzUmNYo06XjtVTzFZ/GJmPT4LVG1zyrtNKYhVyZisI3YT02ORhTSwbRQJBimp9kg
         o02HtQVr/chWyV/qaSngqBRvSULchojrdITRdKQHjU6o9ujGoMG5D8wteGB1dvmEUNBZ
         0vpoH5ve2luiQTGWC35x9VnVQVi4izGhufm3I7FlX5gVYPX6rSk5B3NlzON9tXbzm9iP
         keHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=U+a2luozCBI5I40vTTLfU6Awhfwi9erF3FhBkNGcEgg=;
        b=R/O2wXyqCYTnaFFAoPVO9E4AU0gsuyVuZmmM8T7ENaoqV+EgzBIS6xvZb0UYv7UI70
         p9V+lEdxUEgx2wav59GkMzaWG0MfmatRANlFuT43YrL2AIl09t5ygC2O/r+mYQWLmtGk
         pbpn/zJYVF4cSoAF7j7UVijoUYg2C9GUZhBzLM0TxwMVkA618f0RefDhWZtL5eJeUVOD
         edZyrRg1JsZlALd5/56Lrsb3NxnRxxmkKZOHZZ9jbT24+E1ekBYdBPSATjTqvYB2VrAf
         E63knkIskI8Ajv0AgKmzJI8W6WGNrQVHyfv6HRui5MJwLmNO0OR2MX85iFMc5rC+6zgr
         0v9A==
X-Gm-Message-State: AOAM532dPXWdQ0KB3g9oyNNBcQLOefdjJwgNK+5pb4sjko2AN5G6Hgox
        C9lB15CWyA06nJxrFnDv5jM=
X-Google-Smtp-Source: ABdhPJzAz7uu7bJ3fB0bkEqMeb7nk/CqDDKYThwbmWKU9TOwq6Abfkrt0Bz1eeh1Zgsdibkz6Tpgiw==
X-Received: by 2002:a05:651c:20b:: with SMTP id y11mr32016898ljn.176.1609705988496;
        Sun, 03 Jan 2021 12:33:08 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id e20sm8412214ljn.8.2021.01.03.12.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 12:33:07 -0800 (PST)
Message-ID: <0cc68c81d6fae042d8a84bf90dd77eecd4da7cc8.camel@gmail.com>
Subject: Re: [RFC 1/2] KVM: add initial support for KVM_SET_IOREGION
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Date:   Sun, 03 Jan 2021 12:32:53 -0800
In-Reply-To: <d79bdf44-9088-e005-3840-03f6bad22ed7@redhat.com>
References: <cover.1609231373.git.eafanasova@gmail.com>
         <d4af2bcbd2c6931a24ba99236248529c3bfb6999.1609231374.git.eafanasova@gmail.com>
         <d79bdf44-9088-e005-3840-03f6bad22ed7@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-12-31 at 11:45 +0800, Jason Wang wrote:
> On 2020/12/29 下午6:02, Elena Afanasova wrote:
> > This vm ioctl adds or removes an ioregionfd MMIO/PIO region.
> 
> How about FAST_MMIO?
> 
I’ll add KVM_IOREGION_FAST_MMIO flag support. So this may be suitable
for triggers which could use posted writes. The struct ioregionfd_cmd
size bits and the data field will be unused in this case.

> 
> > Guest
> > read and write accesses are dispatched through the given ioregionfd
> > instead of returning from ioctl(KVM_RUN). Regions can be deleted by
> > setting fds to -1.
> > 
> > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > ---
> >   arch/x86/kvm/Kconfig     |   1 +
> >   arch/x86/kvm/Makefile    |   1 +
> >   arch/x86/kvm/x86.c       |   1 +
> >   include/linux/kvm_host.h |  17 +++
> >   include/uapi/linux/kvm.h |  23 ++++
> >   virt/kvm/Kconfig         |   3 +
> >   virt/kvm/eventfd.c       |  25 +++++
> >   virt/kvm/eventfd.h       |  14 +++
> >   virt/kvm/ioregion.c      | 233
> > +++++++++++++++++++++++++++++++++++++++
> >   virt/kvm/ioregion.h      |  15 +++
> >   virt/kvm/kvm_main.c      |  20 +++-
> >   11 files changed, 350 insertions(+), 3 deletions(-)
> >   create mode 100644 virt/kvm/eventfd.h
> >   create mode 100644 virt/kvm/ioregion.c
> >   create mode 100644 virt/kvm/ioregion.h
> > 
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index f92dfd8ef10d..b914ef375199 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -33,6 +33,7 @@ config KVM
> >   	select HAVE_KVM_IRQ_BYPASS
> >   	select HAVE_KVM_IRQ_ROUTING
> >   	select HAVE_KVM_EVENTFD
> > +	select KVM_IOREGION
> >   	select KVM_ASYNC_PF
> >   	select USER_RETURN_NOTIFIER
> >   	select KVM_MMIO
> > diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> > index b804444e16d4..b3b17dc9f7d4 100644
> > --- a/arch/x86/kvm/Makefile
> > +++ b/arch/x86/kvm/Makefile
> > @@ -12,6 +12,7 @@ KVM := ../../../virt/kvm
> >   kvm-y			+= $(KVM)/kvm_main.o
> > $(KVM)/coalesced_mmio.o \
> >   				$(KVM)/eventfd.o $(KVM)/irqchip.o
> > $(KVM)/vfio.o
> >   kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
> > +kvm-$(CONFIG_KVM_IOREGION)	+= $(KVM)/ioregion.o
> >   
> >   kvm-y			+= x86.o emulate.o i8259.o irq.o
> > lapic.o \
> >   			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o
> > mtrr.o \
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e545a8a613b1..ddb28f5ca252 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3739,6 +3739,7 @@ int kvm_vm_ioctl_check_extension(struct kvm
> > *kvm, long ext)
> >   	case KVM_CAP_X86_USER_SPACE_MSR:
> >   	case KVM_CAP_X86_MSR_FILTER:
> >   	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> > +	case KVM_CAP_IOREGIONFD:
> >   		r = 1;
> >   		break;
> >   	case KVM_CAP_SYNC_REGS:
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 7f2e2a09ebbd..7cd667dddba9 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -470,6 +470,10 @@ struct kvm {
> >   		struct mutex      resampler_lock;
> >   	} irqfds;
> >   	struct list_head ioeventfds;
> > +#endif
> > +#ifdef CONFIG_KVM_IOREGION
> > +	struct list_head ioregions_mmio;
> > +	struct list_head ioregions_pio;
> >   #endif
> >   	struct kvm_vm_stat stat;
> >   	struct kvm_arch arch;
> > @@ -1262,6 +1266,19 @@ static inline int kvm_ioeventfd(struct kvm
> > *kvm, struct kvm_ioeventfd *args)
> >   
> >   #endif /* CONFIG_HAVE_KVM_EVENTFD */
> >   
> > +#ifdef CONFIG_KVM_IOREGION
> > +void kvm_ioregionfd_init(struct kvm *kvm);
> > +int kvm_ioregionfd(struct kvm *kvm, struct kvm_ioregion *args);
> > +
> > +#else
> > +
> > +static inline void kvm_ioregionfd_init(struct kvm *kvm) {}
> > +static inline int kvm_ioregionfd(struct kvm *kvm, struct
> > kvm_ioregion *args)
> > +{
> > +	return -ENOSYS;
> > +}
> > +#endif
> > +
> >   void kvm_arch_irq_routing_update(struct kvm *kvm);
> >   
> >   static inline void kvm_make_request(int req, struct kvm_vcpu
> > *vcpu)
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index ca41220b40b8..81e775778c66 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -732,6 +732,27 @@ struct kvm_ioeventfd {
> >   	__u8  pad[36];
> >   };
> >   
> > +enum {
> > +	kvm_ioregion_flag_nr_pio,
> > +	kvm_ioregion_flag_nr_posted_writes,
> > +	kvm_ioregion_flag_nr_max,
> > +};
> > +
> > +#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
> > +#define KVM_IOREGION_POSTED_WRITES (1 <<
> > kvm_ioregion_flag_nr_posted_writes)
> > +
> > +#define KVM_IOREGION_VALID_FLAG_MASK ((1 <<
> > kvm_ioregion_flag_nr_max) - 1)
> > +
> > +struct kvm_ioregion {
> > +	__u64 guest_paddr; /* guest physical address */
> > +	__u64 memory_size; /* bytes */
> > +	__u64 user_data;
> 
> What will this field do? Is it a token?
> 
Yes, it’s an opaque token that can be used by userspace in order to
determine which MemoryRegion to dispatch.

> 
> > +	__s32 rfd;
> > +	__s32 wfd;
> > +	__u32 flags;
> > +	__u8  pad[28];
> > +};
> 
> Is this possible to register the same fd with multiple GPA ranges?
> If 
> not, do we need to check for fd collision?
> 
Yes, it’s possible to register the same fd with multiple GPA ranges.

> 
> > +
> >   #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
> >   #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
> >   #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> > @@ -1053,6 +1074,7 @@ struct kvm_ppc_resize_hpt {
> >   #define KVM_CAP_X86_USER_SPACE_MSR 188
> >   #define KVM_CAP_X86_MSR_FILTER 189
> >   #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
> > +#define KVM_CAP_IOREGIONFD 191
> >   
> >   #ifdef KVM_CAP_IRQ_ROUTING
> >   
> > @@ -1308,6 +1330,7 @@ struct kvm_vfio_spapr_tce {
> >   					struct
> > kvm_userspace_memory_region)
> >   #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
> >   #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> > +#define KVM_SET_IOREGION          _IOW(KVMIO,  0x49, struct
> > kvm_ioregion)
> >   
> >   /* enable ucontrol for s390 */
> >   struct kvm_s390_ucas_mapping {
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 1c37ccd5d402..5e6620bbf000 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -17,6 +17,9 @@ config HAVE_KVM_EVENTFD
> >          bool
> >          select EVENTFD
> >   
> > +config KVM_IOREGION
> > +       bool
> > +
> >   config KVM_MMIO
> >          bool
> >   
> > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > index c2323c27a28b..aadb73903f8b 100644
> > --- a/virt/kvm/eventfd.c
> > +++ b/virt/kvm/eventfd.c
> > @@ -27,6 +27,7 @@
> >   #include <trace/events/kvm.h>
> >   
> >   #include <kvm/iodev.h>
> > +#include "ioregion.h"
> >   
> >   #ifdef CONFIG_HAVE_KVM_IRQFD
> >   
> > @@ -755,6 +756,23 @@ static const struct kvm_io_device_ops
> > ioeventfd_ops = {
> >   	.destructor = ioeventfd_destructor,
> >   };
> >   
> > +#ifdef CONFIG_KVM_IOREGION
> > +/* assumes kvm->slots_lock held */
> > +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx,
> > +			  u64 start, u64 size)
> > +{
> > +	struct _ioeventfd *_p;
> > +
> > +	list_for_each_entry(_p, &kvm->ioeventfds, list)
> > +		if (_p->bus_idx == bus_idx &&
> > +		    overlap(start, size, _p->addr,
> > +			    !_p->length ? 8 : _p->length))
> > +			return true;
> > +
> > +	return false;
> > +}
> > +#endif
> > +
> >   /* assumes kvm->slots_lock held */
> >   static bool
> >   ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
> > @@ -770,6 +788,13 @@ ioeventfd_check_collision(struct kvm *kvm,
> > struct _ioeventfd *p)
> >   		       _p->datamatch == p->datamatch))))
> >   			return true;
> >   
> > +#ifdef CONFIG_KVM_IOREGION
> > +	if (p->bus_idx == KVM_MMIO_BUS || p->bus_idx == KVM_PIO_BUS)
> > +		if (kvm_ioregion_collides(kvm, p->bus_idx, p->addr,
> > +					  !p->length ? 8 : p->length))
> > +			return true;
> > +#endif
> > +
> >   	return false;
> >   }
> >   
> > diff --git a/virt/kvm/eventfd.h b/virt/kvm/eventfd.h
> > new file mode 100644
> > index 000000000000..73a621eebae3
> > --- /dev/null
> > +++ b/virt/kvm/eventfd.h
> > @@ -0,0 +1,14 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +#ifndef __KVM_EVENTFD_H__
> > +#define __KVM_EVENTFD_H__
> > +
> > +#ifdef CONFIG_KVM_IOREGION
> > +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx, u64 start,
> > u64 size);
> > +#else
> > +static inline bool
> > +kvm_eventfd_collides(struct kvm *kvm, int bus_idx, u64 start, u64
> > size)
> > +{
> > +	return false;
> > +}
> > +#endif
> > +#endif
> > diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> > new file mode 100644
> > index 000000000000..a200c3761343
> > --- /dev/null
> > +++ b/virt/kvm/ioregion.c
> > @@ -0,0 +1,233 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include <linux/kvm_host.h>
> > +#include <linux/fs.h>
> > +#include <kvm/iodev.h>
> > +#include "eventfd.h"
> > +
> > +void
> > +kvm_ioregionfd_init(struct kvm *kvm)
> > +{
> > +	INIT_LIST_HEAD(&kvm->ioregions_mmio);
> > +	INIT_LIST_HEAD(&kvm->ioregions_pio);
> > +}
> > +
> > +struct ioregion {
> > +	struct list_head     list;
> > +	u64                  paddr;
> > +	u64                  size;
> > +	struct file         *rf;
> > +	struct file         *wf;
> > +	u64                  user_data;
> > +	struct kvm_io_device dev;
> > +	bool                 posted_writes;
> > +};
> > +
> > +static inline struct ioregion *
> > +to_ioregion(struct kvm_io_device *dev)
> > +{
> > +	return container_of(dev, struct ioregion, dev);
> > +}
> > +
> > +/* assumes kvm->slots_lock held */
> > +static void
> > +ioregion_release(struct ioregion *p)
> > +{
> > +	fput(p->rf);
> > +	fput(p->wf);
> > +	list_del(&p->list);
> > +	kfree(p);
> > +}
> > +
> > +static int
> > +ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> > gpa_t addr,
> > +	      int len, void *val)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int
> > +ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> > gpa_t addr,
> > +		int len, const void *val)
> > +{
> > +	return 0;
> > +}
> > +
> > +/*
> > + * This function is called as KVM is completely shutting down.  We
> > do not
> > + * need to worry about locking just nuke anything we have as
> > quickly as possible
> > + */
> > +static void
> > +ioregion_destructor(struct kvm_io_device *this)
> > +{
> > +	struct ioregion *p = to_ioregion(this);
> > +
> > +	ioregion_release(p);
> > +}
> > +
> > +static const struct kvm_io_device_ops ioregion_ops = {
> > +	.read       = ioregion_read,
> > +	.write      = ioregion_write,
> > +	.destructor = ioregion_destructor,
> > +};
> > +
> > +static inline struct list_head *
> > +get_ioregion_list(struct kvm *kvm, enum kvm_bus bus_idx)
> > +{
> > +	return (bus_idx == KVM_MMIO_BUS) ?
> > +		&kvm->ioregions_mmio : &kvm->ioregions_pio;
> > +}
> > +
> > +/* check for not overlapping case and reverse */
> > +inline bool
> > +overlap(u64 start1, u64 size1, u64 start2, u64 size2)
> > +{
> > +	u64 end1 = start1 + size1 - 1;
> > +	u64 end2 = start2 + size2 - 1;
> > +
> > +	return !(end1 < start2 || start1 >= end2);
> > +}
> > +
> > +/* assumes kvm->slots_lock held */
> > +bool
> > +kvm_ioregion_collides(struct kvm *kvm, int bus_idx,
> > +		      u64 start, u64 size)
> > +{
> > +	struct ioregion *_p;
> > +	struct list_head *ioregions;
> > +
> > +	ioregions = get_ioregion_list(kvm, bus_idx);
> > +	list_for_each_entry(_p, ioregions, list)
> > +		if (overlap(start, size, _p->paddr, _p->size))
> > +			return true;
> > +
> > +	return false;
> > +}
> > +
> > +/* assumes kvm->slots_lock held */
> > +static bool
> > +ioregion_collision(struct kvm *kvm, struct ioregion *p, enum
> > kvm_bus bus_idx)
> > +{
> > +	if (kvm_ioregion_collides(kvm, bus_idx, p->paddr, p->size) ||
> > +	    kvm_eventfd_collides(kvm, bus_idx, p->paddr, p->size))
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> > +static enum kvm_bus
> > +get_bus_from_flags(__u32 flags)
> > +{
> > +	if (flags & KVM_IOREGION_PIO)
> > +		return KVM_PIO_BUS;
> > +	return KVM_MMIO_BUS;
> > +}
> > +
> > +int
> > +kvm_set_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
> > +{
> > +	struct ioregion *p;
> > +	bool is_posted_writes;
> > +	struct file *rfile, *wfile;
> > +	enum kvm_bus bus_idx;
> > +	int ret = 0;
> > +
> > +	if (!args->memory_size)
> > +		return -EINVAL;
> > +	if ((args->guest_paddr + args->memory_size - 1) < args-
> > >guest_paddr)
> > +		return -EINVAL;
> > +	if (args->flags & ~KVM_IOREGION_VALID_FLAG_MASK)
> > +		return -EINVAL;
> > +
> > +	rfile = fget(args->rfd);
> > +	if (!rfile)
> > +		return -EBADF;
> > +	wfile = fget(args->wfd);
> > +	if (!wfile) {
> > +		fput(rfile);
> > +		return -EBADF;
> > +	}
> > +	if ((rfile->f_flags & O_NONBLOCK) || (wfile->f_flags &
> > O_NONBLOCK)) {
> > +		ret = -EINVAL;
> > +		goto fail;
> > +	}
> 
> Instead of checking nonblocking, can we poll here?
> 
Yes, it’s possible. It would be necessary in the case of out-of-order
requests. But since multiple in-flight messages don’t seem to be a use
case I’m not sure if it’s necessary. Typically device register accesses
should not take a long time, so making them asynchronous doesn't seem
like a practical advantage. Also this might complicate the code and
make it slower. What do you think?

> 
> > +	p = kzalloc(sizeof(*p), GFP_KERNEL_ACCOUNT);
> > +	if (!p) {
> > +		ret = -ENOMEM;
> > +		goto fail;
> > +	}
> > +
> > +	INIT_LIST_HEAD(&p->list);
> > +	p->paddr = args->guest_paddr;
> > +	p->size = args->memory_size;
> > +	p->user_data = args->user_data;
> > +	p->rf = rfile;
> > +	p->wf = wfile;
> > +	is_posted_writes = args->flags & KVM_IOREGION_POSTED_WRITES;
> > +	p->posted_writes = is_posted_writes ? true : false;
> > +	bus_idx = get_bus_from_flags(args->flags);
> > +
> > +	mutex_lock(&kvm->slots_lock);
> > +
> > +	if (ioregion_collision(kvm, p, bus_idx)) {
> > +		ret = -EEXIST;
> > +		goto unlock_fail;
> > +	}
> > +	kvm_iodevice_init(&p->dev, &ioregion_ops);
> > +	ret = kvm_io_bus_register_dev(kvm, bus_idx, p->paddr, p->size,
> > +				      &p->dev);
> > +	if (ret < 0)
> > +		goto unlock_fail;
> 
> We probably need to register to FAST_MMIO when bus_idx is MMIO.
> 
> 
> > +	list_add_tail(&p->list, get_ioregion_list(kvm, bus_idx));
> > +
> > +	mutex_unlock(&kvm->slots_lock);
> > +
> > +	return 0;
> > +
> > +unlock_fail:
> > +	mutex_unlock(&kvm->slots_lock);
> > +	kfree(p);
> > +fail:
> > +	fput(rfile);
> > +	fput(wfile);
> > +
> > +	return ret;
> > +}
> > +
> > +static int
> > +kvm_rm_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
> > +{
> > +	struct ioregion         *p, *tmp;
> > +	enum kvm_bus             bus_idx;
> > +	int                      ret = -ENOENT;
> > +	struct list_head        *ioregions;
> > +
> > +	if (args->rfd != -1 || args->wfd != -1)
> > +		return -EINVAL;
> 
> If we want to use ioregion fd for doorbell, rfd is probably not 
> necessary here.
> 
This condition is simply a requirement that region can be deleted in
the case of both fds are set to -1.

> Thanks
> 
> 
> > +
> > +	bus_idx = get_bus_from_flags(args->flags);
> > +	ioregions = get_ioregion_list(kvm, bus_idx);
> > +
> > +	mutex_lock(&kvm->slots_lock);
> > +
> > +	list_for_each_entry_safe(p, tmp, ioregions, list) {
> > +		if (p->paddr == args->guest_paddr  &&
> > +		    p->size == args->memory_size) {
> > +			kvm_io_bus_unregister_dev(kvm, bus_idx, &p-
> > >dev);
> > +			ioregion_release(p);
> > +			ret = 0;
> > +			break;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&kvm->slots_lock);
> > +
> > +	return ret;
> > +}
> > +
> > +int
> > +kvm_ioregionfd(struct kvm *kvm, struct kvm_ioregion *args)
> > +{
> > +	if (args->rfd == -1 || args->wfd == -1)
> > +		return kvm_rm_ioregion(kvm, args);
> > +	return kvm_set_ioregion(kvm, args);
> > +}
> > diff --git a/virt/kvm/ioregion.h b/virt/kvm/ioregion.h
> > new file mode 100644
> > index 000000000000..23ffa812ec7a
> > --- /dev/null
> > +++ b/virt/kvm/ioregion.h
> > @@ -0,0 +1,15 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +#ifndef __KVM_IOREGION_H__
> > +#define __KVM_IOREGION_H__
> > +
> > +#ifdef CONFIG_KVM_IOREGION
> > +inline bool overlap(u64 start1, u64 size1, u64 start2, u64 size2);
> > +bool kvm_ioregion_collides(struct kvm *kvm, int bus_idx, u64
> > start, u64 size);
> > +#else
> > +static inline bool
> > +kvm_ioregion_collides(struct kvm *kvm, int bus_idx, u64 start, u64
> > size)
> > +{
> > +	return false;
> > +}
> > +#endif
> > +#endif
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 2541a17ff1c4..385d8ec6350d 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -747,6 +747,7 @@ static struct kvm *kvm_create_vm(unsigned long
> > type)
> >   	mmgrab(current->mm);
> >   	kvm->mm = current->mm;
> >   	kvm_eventfd_init(kvm);
> > +	kvm_ioregionfd_init(kvm);
> >   	mutex_init(&kvm->lock);
> >   	mutex_init(&kvm->irq_lock);
> >   	mutex_init(&kvm->slots_lock);
> > @@ -3708,6 +3709,16 @@ static long kvm_vm_ioctl(struct file *filp,
> >   		r = kvm_vm_ioctl_set_memory_region(kvm,
> > &kvm_userspace_mem);
> >   		break;
> >   	}
> > +	case KVM_SET_IOREGION: {
> > +		struct kvm_ioregion data;
> > +
> > +		r = -EFAULT;
> > +		if (copy_from_user(&data, argp, sizeof(data)))
> > +			goto out;
> > +
> > +		r = kvm_ioregionfd(kvm, &data);
> > +		break;
> > +	}
> >   	case KVM_GET_DIRTY_LOG: {
> >   		struct kvm_dirty_log log;
> >   
> > @@ -4301,9 +4312,12 @@ int kvm_io_bus_register_dev(struct kvm *kvm,
> > enum kvm_bus bus_idx, gpa_t addr,
> >   	if (!bus)
> >   		return -ENOMEM;
> >   
> > -	/* exclude ioeventfd which is limited by maximum fd */
> > -	if (bus->dev_count - bus->ioeventfd_count > NR_IOBUS_DEVS - 1)
> > -		return -ENOSPC;
> > +	/* enforce hard limit if kmemcg is disabled and
> > +	 * exclude ioeventfd which is limited by maximum fd
> > +	 */
> > +	if (!memcg_kmem_enabled())
> > +		if (bus->dev_count - bus->ioeventfd_count >
> > NR_IOBUS_DEVS - 1)
> > +			return -ENOSPC;
> >   
> >   	new_bus = kmalloc(struct_size(bus, range, bus->dev_count + 1),
> >   			  GFP_KERNEL_ACCOUNT);

