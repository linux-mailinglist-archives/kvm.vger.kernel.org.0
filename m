Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1DF318DEA
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 16:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhBKPOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 10:14:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230015AbhBKPFQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 10:05:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613055781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lBx/DrdLPiAvVLikKviEEFS8N/a5y1c+bPIMuy6aJqA=;
        b=KhFIeIA7ETZt36XMs7yuvdBkpdRv/XcT7wi2/UxOy7ZiRoAeTeTqMlLG+wf8VFfnDLAF9Q
        cxnh1WYn4QpDnZOottctFItfGDaUJpNsk3JkpBjNkhc6Zobs3puk0aBF2z63XrWs/IOjnF
        hoVGb/v+7l+xWdJBwYMqXflg+pAQolw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-rxDribc_MziNwXkxW_WNqg-1; Thu, 11 Feb 2021 09:59:22 -0500
X-MC-Unique: rxDribc_MziNwXkxW_WNqg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F84A192CC40;
        Thu, 11 Feb 2021 14:59:21 +0000 (UTC)
Received: from localhost (ovpn-115-9.ams2.redhat.com [10.36.115.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 956F226190;
        Thu, 11 Feb 2021 14:59:19 +0000 (UTC)
Date:   Thu, 11 Feb 2021 14:59:18 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
Subject: Re: [RESEND RFC v2 1/4] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <20210211145918.GV247031@stefanha-x1.localdomain>
References: <cover.1611850290.git.eafanasova@gmail.com>
 <de84fca7e7ad62943eb15e4e9dd598d4d0f806ef.1611850291.git.eafanasova@gmail.com>
 <a3794e77-54ec-7866-35ba-c3d8a3908aa6@redhat.com>
 <da345926a4689016296970d62d4432bb9abdc7b7.camel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JEhTuUFIcUlI65CC"
Content-Disposition: inline
In-Reply-To: <da345926a4689016296970d62d4432bb9abdc7b7.camel@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--JEhTuUFIcUlI65CC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 10, 2021 at 11:31:30AM -0800, Elena Afanasova wrote:
> On Mon, 2021-02-08 at 14:21 +0800, Jason Wang wrote:
> > On 2021/1/30 =E4=B8=8A=E5=8D=882:48, Elena Afanasova wrote:
> > > This vm ioctl adds or removes an ioregionfd MMIO/PIO region. Guest
> > > read and write accesses are dispatched through the given ioregionfd
> > > instead of returning from ioctl(KVM_RUN). Regions can be deleted by
> > > setting fds to -1.
> > >=20
> > > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > > ---
> > > Changes in v2:
> > >    - changes after code review
> > >=20
> > >   arch/x86/kvm/Kconfig     |   1 +
> > >   arch/x86/kvm/Makefile    |   1 +
> > >   arch/x86/kvm/x86.c       |   1 +
> > >   include/linux/kvm_host.h |  17 +++
> > >   include/uapi/linux/kvm.h |  23 ++++
> > >   virt/kvm/Kconfig         |   3 +
> > >   virt/kvm/eventfd.c       |  25 +++++
> > >   virt/kvm/eventfd.h       |  14 +++
> > >   virt/kvm/ioregion.c      | 232
> > > +++++++++++++++++++++++++++++++++++++++
> > >   virt/kvm/ioregion.h      |  15 +++
> > >   virt/kvm/kvm_main.c      |  11 ++
> > >   11 files changed, 343 insertions(+)
> > >   create mode 100644 virt/kvm/eventfd.h
> > >   create mode 100644 virt/kvm/ioregion.c
> > >   create mode 100644 virt/kvm/ioregion.h
> > >=20
> > > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > > index f92dfd8ef10d..b914ef375199 100644
> > > --- a/arch/x86/kvm/Kconfig
> > > +++ b/arch/x86/kvm/Kconfig
> > > @@ -33,6 +33,7 @@ config KVM
> > >   	select HAVE_KVM_IRQ_BYPASS
> > >   	select HAVE_KVM_IRQ_ROUTING
> > >   	select HAVE_KVM_EVENTFD
> > > +	select KVM_IOREGION
> > >   	select KVM_ASYNC_PF
> > >   	select USER_RETURN_NOTIFIER
> > >   	select KVM_MMIO
> > > diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> > > index b804444e16d4..b3b17dc9f7d4 100644
> > > --- a/arch/x86/kvm/Makefile
> > > +++ b/arch/x86/kvm/Makefile
> > > @@ -12,6 +12,7 @@ KVM :=3D ../../../virt/kvm
> > >   kvm-y			+=3D $(KVM)/kvm_main.o
> > > $(KVM)/coalesced_mmio.o \
> > >   				$(KVM)/eventfd.o $(KVM)/irqchip.o
> > > $(KVM)/vfio.o
> > >   kvm-$(CONFIG_KVM_ASYNC_PF)	+=3D $(KVM)/async_pf.o
> > > +kvm-$(CONFIG_KVM_IOREGION)	+=3D $(KVM)/ioregion.o
> > >  =20
> > >   kvm-y			+=3D x86.o emulate.o i8259.o irq.o
> > > lapic.o \
> > >   			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o
> > > mtrr.o \
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index e545a8a613b1..ddb28f5ca252 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -3739,6 +3739,7 @@ int kvm_vm_ioctl_check_extension(struct kvm
> > > *kvm, long ext)
> > >   	case KVM_CAP_X86_USER_SPACE_MSR:
> > >   	case KVM_CAP_X86_MSR_FILTER:
> > >   	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> > > +	case KVM_CAP_IOREGIONFD:
> > >   		r =3D 1;
> > >   		break;
> > >   	case KVM_CAP_SYNC_REGS:
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 7f2e2a09ebbd..7cd667dddba9 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -470,6 +470,10 @@ struct kvm {
> > >   		struct mutex      resampler_lock;
> > >   	} irqfds;
> > >   	struct list_head ioeventfds;
> > > +#endif
> > > +#ifdef CONFIG_KVM_IOREGION
> > > +	struct list_head ioregions_mmio;
> > > +	struct list_head ioregions_pio;
> > >   #endif
> > >   	struct kvm_vm_stat stat;
> > >   	struct kvm_arch arch;
> > > @@ -1262,6 +1266,19 @@ static inline int kvm_ioeventfd(struct kvm
> > > *kvm, struct kvm_ioeventfd *args)
> > >  =20
> > >   #endif /* CONFIG_HAVE_KVM_EVENTFD */
> > >  =20
> > > +#ifdef CONFIG_KVM_IOREGION
> > > +void kvm_ioregionfd_init(struct kvm *kvm);
> > > +int kvm_ioregionfd(struct kvm *kvm, struct kvm_ioregion *args);
> > > +
> > > +#else
> > > +
> > > +static inline void kvm_ioregionfd_init(struct kvm *kvm) {}
> > > +static inline int kvm_ioregionfd(struct kvm *kvm, struct
> > > kvm_ioregion *args)
> > > +{
> > > +	return -ENOSYS;
> > > +}
> > > +#endif
> > > +
> > >   void kvm_arch_irq_routing_update(struct kvm *kvm);
> > >  =20
> > >   static inline void kvm_make_request(int req, struct kvm_vcpu
> > > *vcpu)
> > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > index ca41220b40b8..81e775778c66 100644
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -732,6 +732,27 @@ struct kvm_ioeventfd {
> > >   	__u8  pad[36];
> > >   };
> > >  =20
> > > +enum {
> > > +	kvm_ioregion_flag_nr_pio,
> > > +	kvm_ioregion_flag_nr_posted_writes,
> > > +	kvm_ioregion_flag_nr_max,
> > > +};
> > > +
> > > +#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
> > > +#define KVM_IOREGION_POSTED_WRITES (1 <<
> > > kvm_ioregion_flag_nr_posted_writes)
> > > +
> > > +#define KVM_IOREGION_VALID_FLAG_MASK ((1 <<
> > > kvm_ioregion_flag_nr_max) - 1)
> > > +
> > > +struct kvm_ioregion {
> > > +	__u64 guest_paddr; /* guest physical address */
> > > +	__u64 memory_size; /* bytes */
> >=20
> > Do we really need __u64 here?
> >=20
> >=20
> > > +	__u64 user_data;
> > > +	__s32 rfd;
> > > +	__s32 wfd;
> > > +	__u32 flags;
> > > +	__u8  pad[28];
> > > +};
> > > +
> > >   #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
> > >   #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
> > >   #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> > > @@ -1053,6 +1074,7 @@ struct kvm_ppc_resize_hpt {
> > >   #define KVM_CAP_X86_USER_SPACE_MSR 188
> > >   #define KVM_CAP_X86_MSR_FILTER 189
> > >   #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
> > > +#define KVM_CAP_IOREGIONFD 191
> > >  =20
> > >   #ifdef KVM_CAP_IRQ_ROUTING
> > >  =20
> > > @@ -1308,6 +1330,7 @@ struct kvm_vfio_spapr_tce {
> > >   					struct
> > > kvm_userspace_memory_region)
> > >   #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
> > >   #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> > > +#define KVM_SET_IOREGION          _IOW(KVMIO,  0x49, struct
> > > kvm_ioregion)
> > >  =20
> > >   /* enable ucontrol for s390 */
> > >   struct kvm_s390_ucas_mapping {
> > > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > > index 1c37ccd5d402..5e6620bbf000 100644
> > > --- a/virt/kvm/Kconfig
> > > +++ b/virt/kvm/Kconfig
> > > @@ -17,6 +17,9 @@ config HAVE_KVM_EVENTFD
> > >          bool
> > >          select EVENTFD
> > >  =20
> > > +config KVM_IOREGION
> > > +       bool
> > > +
> > >   config KVM_MMIO
> > >          bool
> > >  =20
> > > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > > index c2323c27a28b..aadb73903f8b 100644
> > > --- a/virt/kvm/eventfd.c
> > > +++ b/virt/kvm/eventfd.c
> > > @@ -27,6 +27,7 @@
> > >   #include <trace/events/kvm.h>
> > >  =20
> > >   #include <kvm/iodev.h>
> > > +#include "ioregion.h"
> > >  =20
> > >   #ifdef CONFIG_HAVE_KVM_IRQFD
> > >  =20
> > > @@ -755,6 +756,23 @@ static const struct kvm_io_device_ops
> > > ioeventfd_ops =3D {
> > >   	.destructor =3D ioeventfd_destructor,
> > >   };
> > >  =20
> > > +#ifdef CONFIG_KVM_IOREGION
> > > +/* assumes kvm->slots_lock held */
> > > +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx,
> > > +			  u64 start, u64 size)
> > > +{
> > > +	struct _ioeventfd *_p;
> > > +
> > > +	list_for_each_entry(_p, &kvm->ioeventfds, list)
> > > +		if (_p->bus_idx =3D=3D bus_idx &&
> > > +		    overlap(start, size, _p->addr,
> > > +			    !_p->length ? 8 : _p->length))
> > > +			return true;
> > > +
> > > +	return false;
> > > +}
> > > +#endif
> > > +
> > >   /* assumes kvm->slots_lock held */
> > >   static bool
> > >   ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
> > > @@ -770,6 +788,13 @@ ioeventfd_check_collision(struct kvm *kvm,
> > > struct _ioeventfd *p)
> > >   		       _p->datamatch =3D=3D p->datamatch))))
> > >   			return true;
> > >  =20
> > > +#ifdef CONFIG_KVM_IOREGION
> > > +	if (p->bus_idx =3D=3D KVM_MMIO_BUS || p->bus_idx =3D=3D KVM_PIO_BUS)
> > > +		if (kvm_ioregion_collides(kvm, p->bus_idx, p->addr,
> > > +					  !p->length ? 8 : p->length))
> > > +			return true;
> > > +#endif
> > > +
> > >   	return false;
> > >   }
> > >  =20
> > > diff --git a/virt/kvm/eventfd.h b/virt/kvm/eventfd.h
> > > new file mode 100644
> > > index 000000000000..73a621eebae3
> > > --- /dev/null
> > > +++ b/virt/kvm/eventfd.h
> > > @@ -0,0 +1,14 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > +#ifndef __KVM_EVENTFD_H__
> > > +#define __KVM_EVENTFD_H__
> > > +
> > > +#ifdef CONFIG_KVM_IOREGION
> > > +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx, u64 start,
> > > u64 size);
> > > +#else
> > > +static inline bool
> > > +kvm_eventfd_collides(struct kvm *kvm, int bus_idx, u64 start, u64
> > > size)
> > > +{
> > > +	return false;
> > > +}
> > > +#endif
> > > +#endif
> > > diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> > > new file mode 100644
> > > index 000000000000..48ff92bca966
> > > --- /dev/null
> > > +++ b/virt/kvm/ioregion.c
> > > @@ -0,0 +1,232 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +#include <linux/kvm_host.h>
> > > +#include <linux/fs.h>
> > > +#include <kvm/iodev.h>
> > > +#include "eventfd.h"
> > > +
> > > +void
> > > +kvm_ioregionfd_init(struct kvm *kvm)
> > > +{
> > > +	INIT_LIST_HEAD(&kvm->ioregions_mmio);
> > > +	INIT_LIST_HEAD(&kvm->ioregions_pio);
> > > +}
> > > +
> > > +struct ioregion {
> > > +	struct list_head     list;
> > > +	u64                  paddr;  /* guest physical address */
> > > +	u64                  size;   /* size in bytes */
> > > +	struct file         *rf;
> > > +	struct file         *wf;
> > > +	u64                  user_data; /* opaque token used by
> > > userspace */
> > > +	struct kvm_io_device dev;
> > > +	bool                 posted_writes;
> > > +};
> > > +
> > > +static inline struct ioregion *
> > > +to_ioregion(struct kvm_io_device *dev)
> > > +{
> > > +	return container_of(dev, struct ioregion, dev);
> > > +}
> > > +
> > > +/* assumes kvm->slots_lock held */
> > > +static void
> > > +ioregion_release(struct ioregion *p)
> > > +{
> > > +	fput(p->rf);
> > > +	fput(p->wf);
> > > +	list_del(&p->list);
> > > +	kfree(p);
> > > +}
> > > +
> > > +static int
> > > +ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> > > gpa_t addr,
> > > +	      int len, void *val)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +
> > > +static int
> > > +ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> > > gpa_t addr,
> > > +		int len, const void *val)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +
> > > +/*
> > > + * This function is called as KVM is completely shutting down.  We
> > > do not
> > > + * need to worry about locking just nuke anything we have as
> > > quickly as possible
> > > + */
> > > +static void
> > > +ioregion_destructor(struct kvm_io_device *this)
> > > +{
> > > +	struct ioregion *p =3D to_ioregion(this);
> > > +
> > > +	ioregion_release(p);
> > > +}
> > > +
> > > +static const struct kvm_io_device_ops ioregion_ops =3D {
> > > +	.read       =3D ioregion_read,
> > > +	.write      =3D ioregion_write,
> > > +	.destructor =3D ioregion_destructor,
> > > +};
> > > +
> > > +static inline struct list_head *
> > > +get_ioregion_list(struct kvm *kvm, enum kvm_bus bus_idx)
> > > +{
> > > +	return (bus_idx =3D=3D KVM_MMIO_BUS) ?
> > > +		&kvm->ioregions_mmio : &kvm->ioregions_pio;
> > > +}
> > > +
> > > +/* check for not overlapping case and reverse */
> > > +inline bool
> > > +overlap(u64 start1, u64 size1, u64 start2, u64 size2)
> > > +{
> > > +	u64 end1 =3D start1 + size1 - 1;
> > > +	u64 end2 =3D start2 + size2 - 1;
> > > +
> > > +	return !(end1 < start2 || start1 >=3D end2);
> > > +}
> > > +
> > > +/* assumes kvm->slots_lock held */
> > > +bool
> > > +kvm_ioregion_collides(struct kvm *kvm, int bus_idx,
> > > +		      u64 start, u64 size)
> > > +{
> > > +	struct ioregion *_p;
> > > +	struct list_head *ioregions;
> > > +
> > > +	ioregions =3D get_ioregion_list(kvm, bus_idx);
> > > +	list_for_each_entry(_p, ioregions, list)
> > > +		if (overlap(start, size, _p->paddr, _p->size))
> > > +			return true;
> > > +
> > > +	return false;
> > > +}
> > > +
> > > +/* assumes kvm->slots_lock held */
> > > +static bool
> > > +ioregion_collision(struct kvm *kvm, struct ioregion *p, enum
> > > kvm_bus bus_idx)
> > > +{
> > > +	if (kvm_ioregion_collides(kvm, bus_idx, p->paddr, p->size) ||
> > > +	    kvm_eventfd_collides(kvm, bus_idx, p->paddr, p->size))
> > > +		return true;
> > > +
> > > +	return false;
> > > +}
> > > +
> > > +static enum kvm_bus
> > > +get_bus_from_flags(__u32 flags)
> > > +{
> > > +	if (flags & KVM_IOREGION_PIO)
> > > +		return KVM_PIO_BUS;
> > > +	return KVM_MMIO_BUS;
> > > +}
> > > +
> > > +int
> > > +kvm_set_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
> > > +{
> > > +	struct ioregion *p;
> > > +	struct file *rfile, *wfile;
> > > +	enum kvm_bus bus_idx;
> > > +	int ret =3D 0;
> > > +
> > > +	if (!args->memory_size)
> > > +		return -EINVAL;
> > > +	if ((args->guest_paddr + args->memory_size - 1) < args-
> > > >guest_paddr)
> > > +		return -EINVAL;
> > > +
> > > +	rfile =3D fget(args->rfd);
> > > +	if (!rfile)
> > > +		return -EBADF;
> >=20
> > So the question still, if we want to use ioregion fd for doorbell,
> > we=20
> > don't need rfd in this case?
> >=20
> Using ioregionfd for doorbell seems to be an open question. Probably it
> could just focus on the non-doorbell cases.

Below you replied FAST_MMIO will be in v3. That is the doorbell case, so
maybe it is in scope for this patch series?

I think continuing to use ioeventfd for most doorbell registers makes
sense.

However, there are two cases where ioregionfd doorbell support is
interesting:

1. The (non-FAST_MMIO) case where the application needs to know the
   value written to the doorbell. ioeventfd cannot do this (datamatch
   can handle a subset of cases but not all) so we need ioregionfd for
   this.

2. The FAST_MMIO case just for convenience if applications prefer to use
   a single API (ioregionfd) instead of implementing both ioregionfd and
   ioeventfd.

ioeventfd will still have its benefits (and limitations) that make it
different from ioregionfd. In particular, ioregionfd will not merge
doorbell writes into a single message because doing so would basically
involve reimplementing ioeventfd functionality as part of ioregionfd and
isn't compatible with the current approach where userspace can provide
any file descriptor for communication.

Elena and Jason: do you agree with this API design?

--JEhTuUFIcUlI65CC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlRkYACgkQnKSrs4Gr
c8inUggAkhJfBvqc/3mE6PiUbolZgRcPgMQad8ZABJG6NgpIjtv9qOz7pauwEHzf
bId/6MRjkQ8KPx9njByuIUdGh+GWL6HdZQ9o9l9QW9izJrk0cKtE9FHxJmmh2mfX
kS7TG8U5umsyVRPaNOtqC3w3f3GbkNscfo8oCDW+VH1qqUbUOG5+A4NKxAnsJqbM
avPXfeRRiVuGJwDtPE0V0AXF/9sdKSn15iWko4H33t/z57+TBzUPVQsV5mR8ZcgF
B9j/ebbS1il6+uK37dN4kKv1cnWksfwkPv+ENg8ZnMkFnd/rkSQm+ByKJutoM3i/
RRo6pzVCFGGp8tfMCkJI82YNIXIrMg==
=3sn0
-----END PGP SIGNATURE-----

--JEhTuUFIcUlI65CC--

