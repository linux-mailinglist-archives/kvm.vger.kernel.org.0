Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1601C2EA899
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 11:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbhAEK0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 05:26:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728012AbhAEK0v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 05:26:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609842322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4iMqPMdGM4untdvuGafXUnu4TCIBK4eJvrjbZoRNFEA=;
        b=GTx//pu8iw8ZrukXQeXP19mTAL9jbfn8yolb8P5RYOrRtga85rTBvckO0eQ+rkPpd27ilE
        m+DIMKjNWDq3oJWW6UQ+mhs20dPXi6VFgkVtuEUfbbK+NZ7MpJSU6fmldoHKgR6jjwb+QU
        eMe0sktYbTW4UGiRu+/M8f6zrta9rYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-GzSiPdWRPVO-VZ1tTLEM5A-1; Tue, 05 Jan 2021 05:25:20 -0500
X-MC-Unique: GzSiPdWRPVO-VZ1tTLEM5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26795803621;
        Tue,  5 Jan 2021 10:25:19 +0000 (UTC)
Received: from localhost (ovpn-114-124.ams2.redhat.com [10.36.114.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 981F171C9E;
        Tue,  5 Jan 2021 10:25:18 +0000 (UTC)
Date:   Tue, 5 Jan 2021 10:25:17 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
Subject: Re: [RFC 1/2] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <20210105102517.GA31084@stefanha-x1.localdomain>
References: <cover.1609231373.git.eafanasova@gmail.com>
 <d4af2bcbd2c6931a24ba99236248529c3bfb6999.1609231374.git.eafanasova@gmail.com>
 <d79bdf44-9088-e005-3840-03f6bad22ed7@redhat.com>
 <0cc68c81d6fae042d8a84bf90dd77eecd4da7cc8.camel@gmail.com>
 <947ba980-f870-16fb-2ea5-07da617d6bb6@redhat.com>
 <29955fdc90d2efab7b79c91b9a97183e95243cc1.camel@gmail.com>
 <47e8b7e8-d9b8-b2a2-c014-05942d99452a@redhat.com>
MIME-Version: 1.0
In-Reply-To: <47e8b7e8-d9b8-b2a2-c014-05942d99452a@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 05, 2021 at 11:53:01AM +0800, Jason Wang wrote:
>=20
> On 2021/1/5 =E4=B8=8A=E5=8D=888:02, Elena Afanasova wrote:
> > On Mon, 2021-01-04 at 13:34 +0800, Jason Wang wrote:
> > > On 2021/1/4 =E4=B8=8A=E5=8D=884:32, Elena Afanasova wrote:
> > > > On Thu, 2020-12-31 at 11:45 +0800, Jason Wang wrote:
> > > > > On 2020/12/29 =E4=B8=8B=E5=8D=886:02, Elena Afanasova wrote:
> > > > > > This vm ioctl adds or removes an ioregionfd MMIO/PIO region.
> > > > > How about FAST_MMIO?
> > > > >=20
> > > > I=E2=80=99ll add KVM_IOREGION_FAST_MMIO flag support. So this may b=
e
> > > > suitable
> > > > for triggers which could use posted writes. The struct
> > > > ioregionfd_cmd
> > > > size bits and the data field will be unused in this case.
> > > Note that eventfd checks for length and have datamatch support. Do
> > > we
> > > need to do something similar.
> > >=20
> > Do you think datamatch support is necessary for ioregionfd?
>=20
>=20
> I'm not sure. But if we don't have this support, it probably means we can=
't
> use eventfd for ioregionfd.

This is an interesting question because ioregionfd and ioeventfd have
different semantics. While it would be great to support all ioeventfd
features in ioregionfd, I'm not sure that is possible. I think ioeventfd
will remain useful for devices that only need a doorbell write register.

The differences:

1. ioeventfd has datamatch. This could be implemented in ioregionfd so
   that a datamatch failure results in the classic ioctl(KVM_RETURN)
   MMIO/PIO exit reason and the VMM can handle the access.

   I'm not sure if this feature is useful though. Most of the time
   ioregionfd users want to handle all accesses to the region and the
   VMM may not even know how to handle register accesses because they
   can only be handled in a dedicated thread or an out-of-process
   device.

2. Write coalescing. ioeventfd combines writes because an eventfd is a
   counter. The counter is incremented on each write and the counter is
   reset to zero by reading the eventfd. This way a slow userspace can
   read the eventfd just once while a fast guest writes to it many times
   (similar to interrupt coalescing in physical hardware). ioregionfd
   cannot really do that, userspace will have to read one struct
   ioregion_cmd per guest access. Elena and I briefly discussed
   optimizing this by implementing a custom struct file_operations so
   the ->read() callback can coalesce multiple writes to the same
   address, but this makes sense mostly for guest write operations in
   FAST_MMIO mode, doesn't allow userspace to provide any type of fd
   (socket, pipe, etc), and increases the complexity.

Keeping in mind that ioeventfd and ioregionfd can be combined, I think
the main advantage to supporting all ioeventfd features in ioregionfd is
uniformity (offering everything through a single interface).

Supporting ioeventfd features in ioregionfd is possible to an extent but
will make ioctl(KVM_SET_IOREGION) more complex and userspace will still
have to create multiple fds because ioeventfd-style doorbell write
registers have different semantics from regular ioregionfd regions
(no posted writes).

My thoughts are that ioregionfd should do what it's good at and
ioeventfd should do what it's good at.

> > > I guess the idea is to have a generic interface to let eventfd work
> > > for
> > > ioregion as well.
> > >=20
> > It seems that posted writes is the only "fast" case in ioregionfd. So I
> > was thinking about using FAST_MMIO for this case only. Maybe in some
> > cases it will be better to just use ioeventfd. But I'm not sure.
>=20
>=20
> To be a generic infrastructure, it's better to have this, but we can list=
en
> from the opinion of others.

I think we want both FAST_MMIO and regular MMIO options for posted
writes:

1. FAST_MMIO - ioregionfd_cmd size and data fields are zero and do not
   contain information about the nature of the guest access. This is
   fine for ioeventfd doorbell style registers because we don't need
   that information.

2. Regular MMIO - ioregionfd_cmd size and data fields contain valid data
   about the nature of the guest access. This is needed when the device
   register is more than a simple "kick" doorbell. For example, if the
   device needs to know the value that the guest wrote.

I suggest defining an additional KVM_SET_IOREGION flag called
KVM_IOREGION_FAST_MMIO that can be set together with
KVM_IOREGION_POSTED_WRITES.

KVM_IOREGION_PIO cannot be used together with KVM_IOREGION_FAST_MMIO.

In theory KVM_IOREGION_POSTED_WRITES doesn't need to be set with
KVM_IOREGION_FAST_MMIO. Userspace would have to send back a struct
ioregionfd_resp to acknowledge that the write has been handled.

Read accesses are indistinguishable from write accesses with
KVM_IOREGION_FAST_MMIO so it only makes sense to use the flag on
write-only regions. If the guest performs a read then userspace will see
a write and the destination CPU register will be unchanged (I think this
is already the case for FAST_MMIO).

> > > > > > Guest
> > > > > > read and write accesses are dispatched through the given
> > > > > > ioregionfd
> > > > > > instead of returning from ioctl(KVM_RUN). Regions can be
> > > > > > deleted by
> > > > > > setting fds to -1.
> > > > > >=20
> > > > > > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > > > > > ---
> > > > > >     arch/x86/kvm/Kconfig     |   1 +
> > > > > >     arch/x86/kvm/Makefile    |   1 +
> > > > > >     arch/x86/kvm/x86.c       |   1 +
> > > > > >     include/linux/kvm_host.h |  17 +++
> > > > > >     include/uapi/linux/kvm.h |  23 ++++
> > > > > >     virt/kvm/Kconfig         |   3 +
> > > > > >     virt/kvm/eventfd.c       |  25 +++++
> > > > > >     virt/kvm/eventfd.h       |  14 +++
> > > > > >     virt/kvm/ioregion.c      | 233
> > > > > > +++++++++++++++++++++++++++++++++++++++
> > > > > >     virt/kvm/ioregion.h      |  15 +++
> > > > > >     virt/kvm/kvm_main.c      |  20 +++-
> > > > > >     11 files changed, 350 insertions(+), 3 deletions(-)
> > > > > >     create mode 100644 virt/kvm/eventfd.h
> > > > > >     create mode 100644 virt/kvm/ioregion.c
> > > > > >     create mode 100644 virt/kvm/ioregion.h
> > > > > >=20
> > > > > > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > > > > > index f92dfd8ef10d..b914ef375199 100644
> > > > > > --- a/arch/x86/kvm/Kconfig
> > > > > > +++ b/arch/x86/kvm/Kconfig
> > > > > > @@ -33,6 +33,7 @@ config KVM
> > > > > >     =09select HAVE_KVM_IRQ_BYPASS
> > > > > >     =09select HAVE_KVM_IRQ_ROUTING
> > > > > >     =09select HAVE_KVM_EVENTFD
> > > > > > +=09select KVM_IOREGION
> > > > > >     =09select KVM_ASYNC_PF
> > > > > >     =09select USER_RETURN_NOTIFIER
> > > > > >     =09select KVM_MMIO
> > > > > > diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> > > > > > index b804444e16d4..b3b17dc9f7d4 100644
> > > > > > --- a/arch/x86/kvm/Makefile
> > > > > > +++ b/arch/x86/kvm/Makefile
> > > > > > @@ -12,6 +12,7 @@ KVM :=3D ../../../virt/kvm
> > > > > >     kvm-y=09=09=09+=3D $(KVM)/kvm_main.o
> > > > > > $(KVM)/coalesced_mmio.o \
> > > > > >     =09=09=09=09$(KVM)/eventfd.o
> > > > > > $(KVM)/irqchip.o
> > > > > > $(KVM)/vfio.o
> > > > > >     kvm-$(CONFIG_KVM_ASYNC_PF)=09+=3D $(KVM)/async_pf.o
> > > > > > +kvm-$(CONFIG_KVM_IOREGION)=09+=3D $(KVM)/ioregion.o
> > > > > >     kvm-y=09=09=09+=3D x86.o emulate.o i8259.o
> > > > > > irq.o
> > > > > > lapic.o \
> > > > > >     =09=09=09   i8254.o ioapic.o irq_comm.o cpuid.o
> > > > > > pmu.o
> > > > > > mtrr.o \
> > > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > > index e545a8a613b1..ddb28f5ca252 100644
> > > > > > --- a/arch/x86/kvm/x86.c
> > > > > > +++ b/arch/x86/kvm/x86.c
> > > > > > @@ -3739,6 +3739,7 @@ int kvm_vm_ioctl_check_extension(struct
> > > > > > kvm
> > > > > > *kvm, long ext)
> > > > > >     =09case KVM_CAP_X86_USER_SPACE_MSR:
> > > > > >     =09case KVM_CAP_X86_MSR_FILTER:
> > > > > >     =09case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> > > > > > +=09case KVM_CAP_IOREGIONFD:
> > > > > >     =09=09r =3D 1;
> > > > > >     =09=09break;
> > > > > >     =09case KVM_CAP_SYNC_REGS:
> > > > > > diff --git a/include/linux/kvm_host.h
> > > > > > b/include/linux/kvm_host.h
> > > > > > index 7f2e2a09ebbd..7cd667dddba9 100644
> > > > > > --- a/include/linux/kvm_host.h
> > > > > > +++ b/include/linux/kvm_host.h
> > > > > > @@ -470,6 +470,10 @@ struct kvm {
> > > > > >     =09=09struct mutex      resampler_lock;
> > > > > >     =09} irqfds;
> > > > > >     =09struct list_head ioeventfds;
> > > > > > +#endif
> > > > > > +#ifdef CONFIG_KVM_IOREGION
> > > > > > +=09struct list_head ioregions_mmio;
> > > > > > +=09struct list_head ioregions_pio;
> > > > > >     #endif
> > > > > >     =09struct kvm_vm_stat stat;
> > > > > >     =09struct kvm_arch arch;
> > > > > > @@ -1262,6 +1266,19 @@ static inline int kvm_ioeventfd(struct
> > > > > > kvm
> > > > > > *kvm, struct kvm_ioeventfd *args)
> > > > > >     #endif /* CONFIG_HAVE_KVM_EVENTFD */
> > > > > > +#ifdef CONFIG_KVM_IOREGION
> > > > > > +void kvm_ioregionfd_init(struct kvm *kvm);
> > > > > > +int kvm_ioregionfd(struct kvm *kvm, struct kvm_ioregion
> > > > > > *args);
> > > > > > +
> > > > > > +#else
> > > > > > +
> > > > > > +static inline void kvm_ioregionfd_init(struct kvm *kvm) {}
> > > > > > +static inline int kvm_ioregionfd(struct kvm *kvm, struct
> > > > > > kvm_ioregion *args)
> > > > > > +{
> > > > > > +=09return -ENOSYS;
> > > > > > +}
> > > > > > +#endif
> > > > > > +
> > > > > >     void kvm_arch_irq_routing_update(struct kvm *kvm);
> > > > > >     static inline void kvm_make_request(int req, struct kvm_vcp=
u
> > > > > > *vcpu)
> > > > > > diff --git a/include/uapi/linux/kvm.h
> > > > > > b/include/uapi/linux/kvm.h
> > > > > > index ca41220b40b8..81e775778c66 100644
> > > > > > --- a/include/uapi/linux/kvm.h
> > > > > > +++ b/include/uapi/linux/kvm.h
> > > > > > @@ -732,6 +732,27 @@ struct kvm_ioeventfd {
> > > > > >     =09__u8  pad[36];
> > > > > >     };
> > > > > > +enum {
> > > > > > +=09kvm_ioregion_flag_nr_pio,
> > > > > > +=09kvm_ioregion_flag_nr_posted_writes,
> > > > > > +=09kvm_ioregion_flag_nr_max,
> > > > > > +};
> > > > > > +
> > > > > > +#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
> > > > > > +#define KVM_IOREGION_POSTED_WRITES (1 <<
> > > > > > kvm_ioregion_flag_nr_posted_writes)
> > > > > > +
> > > > > > +#define KVM_IOREGION_VALID_FLAG_MASK ((1 <<
> > > > > > kvm_ioregion_flag_nr_max) - 1)
> > > > > > +
> > > > > > +struct kvm_ioregion {
> > > > > > +=09__u64 guest_paddr; /* guest physical address */
> > > > > > +=09__u64 memory_size; /* bytes */
> > > > > > +=09__u64 user_data;
> > > > > What will this field do? Is it a token?
> > > > >=20
> > > > Yes, it=E2=80=99s an opaque token that can be used by userspace in =
order to
> > > > determine which MemoryRegion to dispatch.
> > > This part I don't understand. Userspace should know the fd number
> > > (which
> > > I guess should be sufficient?).
> > >=20
> > I think the user_data field can be useful if same fd is registered with
> > multiple GPA ranges.
>=20
>=20
> Yes, but if I read the code correctly, we encode the address in the
> protocol. Isn't it sufficient?

struct ioregionfd_cmd::offset is a relative address from the start of
the ioregion.

The idea is that userspace doesn't need to look up the address. The
kernel has already done that and provided an offset that is relative to
the start of the ioregion that was registered with KVM_SET_IOREGION.

Userspace uses user_data to determine the device/sub-device/region (e.g.
QEMU's MemoryRegion) and passes the offset directly to its
->read()/->write() handler function.

If a userspace program prefers to re-dispatch based on the address then
it can set user_data =3D guest_paddr, but I think most userspace programs
will prefer to set user_data to a DeviceState (for simple devices with
just one ioregion) or MemoryRegion (for complex devices with multiple
ioregions) pointer instead.

Stefan

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/0PosACgkQnKSrs4Gr
c8gW7gf/YJcHPNmo95ZsVpd/E7hHPHRlsqydljFryU+uw4DzOeaAzso9NBVaRrJe
CfFepZsbKaTu0LclAzyp1wY8v4tr58QJFK598LaJpJgfEWLj3e9R+k8ThBBoCPNZ
JB+ukklw//c0EkSnZoMIIXbmepUJYKeF3kgHvtzuKfHfmRZzhP4E493YIs3NGU4Q
DF1AdILmoiOaYlgkzlb77FXJktxUhEMENVviuI2oArmblpr7J93gTgySJg8uvGye
Li1CgAKeg8phjMk6zYgGD4bta3YZuC9xV7ScUs/zoyKBdHME7/lzX0KjXUhiuG3U
Zte28UTwB154WktIWWU2gVoBQ4UwxA==
=w5Jg
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--

