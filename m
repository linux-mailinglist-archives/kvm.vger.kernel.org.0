Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4FB314A34C
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 12:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbgA0Lyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 06:54:50 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50895 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729106AbgA0Lyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 06:54:49 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so6505405wmb.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 03:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uwtjzAWfEDSlWJZX5R1nJkn64OYKp/XtUeiInUaiy1I=;
        b=JfGQDLhBFfAQS5g9M2jJBvb5RwF6NNd0X2IBwUBGfR3ItT8gawaMJ2eN0gMCXoONRK
         1DM3A+9qhfqApMiVlt7iairbpCMMNe6OLS92S9JL4+PH1EQpGyEHX/SPid2Vvlcd9Pwo
         p3VDhbVWJOkPJTovGGPcuPA+ohO19AfHDjLnfEJ7c0istG8wSix6FxDoCDehBPSsQlu7
         eV3Mr0KQq1wA19HAoYrTi1t9GnROsFTAwuUY1bSy+sXB47NNjpkdgqKDtCpEJNV1yM5w
         6IpRXc9/QzXTkwLiTzFRujwG6cZyigNGgK4eKO1og8BVnzJvGq9fFAESZoTrrgqJxsSF
         DCzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uwtjzAWfEDSlWJZX5R1nJkn64OYKp/XtUeiInUaiy1I=;
        b=VBJxkALfEpl35rvtJklhw+UCoLKzdxfn6ty1+w4E0wm3d5w2Ak3ly7iASe7mqmpaQ9
         InN/YcaV0pJ4ET/h0wJor65YXnGf/sGEA4fIiaKAiluUmjcJB8YAWXU3NRyyn17Ylb5w
         WV4gSygdR6vKs2TPebAzlGcu7cXewreDVfYdR95/BZLC+YlMkGBX8UM3MMijd89In9he
         Juu4RZDzFaagXgoTdFYgU9risJZg7qrupz7uWU1hgq9nE8mFD2KjjEor/HKozryjFRpy
         5k7Xm4sv17E0VX/QbbA67fBB2GRyF+Sff7cYJOg/v99mETOnqXdqONxmloQ70ldyncz2
         SvMQ==
X-Gm-Message-State: APjAAAWE8aiUsn4GXw3qgNlnwBjpdraKv4KZ3llhsKXRc4M+449YIsVO
        S3jRnfEvuKWaLQryykiC67wJscfscuMYjMD1UOd16cCT
X-Google-Smtp-Source: APXvYqx+DVxlFf17InsnfyT+rYEePDKjliLklJeEvJ7+5u0Pp4ueBzk/XNA/pUwtmOFzdBJtBnRQzzAWUVtaj4SD58c=
X-Received: by 2002:a1c:6246:: with SMTP id w67mr13076771wmb.141.1580126087216;
 Mon, 27 Jan 2020 03:54:47 -0800 (PST)
MIME-Version: 1.0
References: <20191225025945.108466-1-anup.patel@wdc.com> <20191225025945.108466-4-anup.patel@wdc.com>
 <cb49e776-0673-d6cf-d4dc-ec89a946e5b0@arm.com>
In-Reply-To: <cb49e776-0673-d6cf-d4dc-ec89a946e5b0@arm.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 27 Jan 2020 17:24:35 +0530
Message-ID: <CAAhSdy1+qV=i3JnCaJ39QPiJ+94hfVNByUrMNiMVZ+fT4RHCpw@mail.gmail.com>
Subject: Re: [kvmtool RFC PATCH 3/8] riscv: Implement Guest/VM arch functions
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>, Will Deacon <will.deacon@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 8, 2020 at 6:52 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hello,
>
> On 12/25/19 3:00 AM, Anup Patel wrote:
> > This patch implements all kvm__arch_<xyz> Guest/VM arch functions.
> >
> > These functions mostly deal with:
> > 1. Guest/VM RAM initialization
> > 2. Updating terminals on character read
> > 3. Loading kernel and initrd images
> >
> > Firmware loading is not implemented currently because initially we
> > will be booting kernel directly without any bootloader. In future,
> > we will certainly support firmware loading.
> >
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > ---
> >  riscv/include/kvm/kvm-arch.h |  15 +++++
> >  riscv/kvm.c                  | 126 +++++++++++++++++++++++++++++++++--
> >  2 files changed, 135 insertions(+), 6 deletions(-)
> >
> > diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> > index 7e9c578..b3ec2d6 100644
> > --- a/riscv/include/kvm/kvm-arch.h
> > +++ b/riscv/include/kvm/kvm-arch.h
> > @@ -45,6 +45,21 @@
> >  struct kvm;
> >
> >  struct kvm_arch {
> > +     /*
> > +      * We may have to align the guest memory for virtio, so keep the
> > +      * original pointers here for munmap.
> > +      */
> > +     void    *ram_alloc_start;
> > +     u64     ram_alloc_size;
> > +
> > +     /*
> > +      * Guest addresses for memory layout.
> > +      */
> > +     u64     memory_guest_start;
> > +     u64     kern_guest_start;
> > +     u64     initrd_guest_start;
> > +     u64     initrd_size;
> > +     u64     dtb_guest_start;
> >  };
> >
> >  static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
> > diff --git a/riscv/kvm.c b/riscv/kvm.c
> > index e816ef5..c0d3639 100644
> > --- a/riscv/kvm.c
> > +++ b/riscv/kvm.c
> > @@ -1,5 +1,7 @@
> >  #include "kvm/kvm.h"
> >  #include "kvm/util.h"
> > +#include "kvm/8250-serial.h"
> > +#include "kvm/virtio-console.h"
> >  #include "kvm/fdt.h"
> >
> >  #include <linux/kernel.h>
> > @@ -19,33 +21,145 @@ bool kvm__arch_cpu_supports_vm(void)
> >
> >  void kvm__init_ram(struct kvm *kvm)
> >  {
> > -     /* TODO: */
> > +     int err;
> > +     u64 phys_start, phys_size;
> > +     void *host_mem;
> > +
> > +     phys_start      = RISCV_RAM;
> > +     phys_size       = kvm->ram_size;
> > +     host_mem        = kvm->ram_start;
> > +
> > +     err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
> > +     if (err)
> > +             die("Failed to register %lld bytes of memory at physical "
> > +                 "address 0x%llx [err %d]", phys_size, phys_start, err);
> > +
> > +     kvm->arch.memory_guest_start = phys_start;
> >  }
> >
> >  void kvm__arch_delete_ram(struct kvm *kvm)
> >  {
> > -     /* TODO: */
> > +     munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
> >  }
> >
> >  void kvm__arch_read_term(struct kvm *kvm)
> >  {
> > -     /* TODO: */
> > +     serial8250__update_consoles(kvm);
> > +     virtio_console__inject_interrupt(kvm);
> >  }
> >
> >  void kvm__arch_set_cmdline(char *cmdline, bool video)
> >  {
> > -     /* TODO: */
> >  }
> >
> >  void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
> >  {
> > -     /* TODO: */
> > +     /*
> > +      * Allocate guest memory. We must align our buffer to 64K to
> > +      * correlate with the maximum guest page size for virtio-mmio.
> > +      * If using THP, then our minimal alignment becomes 2M.
> > +      * 2M trumps 64K, so let's go with that.
> > +      */
> > +     kvm->ram_size = min(ram_size, (u64)RISCV_MAX_MEMORY(kvm));
> > +     kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
> > +     kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path,
> > +                                             kvm->arch.ram_alloc_size);
> > +
> > +     if (kvm->arch.ram_alloc_start == MAP_FAILED)
> > +             die("Failed to map %lld bytes for guest memory (%d)",
> > +                 kvm->arch.ram_alloc_size, errno);
> > +
> > +     kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
> > +                                     SZ_2M);
> > +
> > +     madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> > +             MADV_MERGEABLE);
> > +
> > +     madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> > +             MADV_HUGEPAGE);
> >  }
> >
> > +#define FDT_ALIGN    SZ_4M
> > +#define INITRD_ALIGN 4
> >  bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
> >                                const char *kernel_cmdline)
> >  {
> > -     /* TODO: */
> > +     void *pos, *kernel_end, *limit;
> > +     unsigned long guest_addr, kernel_offset;
> > +     ssize_t file_size;
> > +
> > +     /*
> > +      * Linux requires the initrd and dtb to be mapped inside lowmem,
> > +      * so we can't just place them at the top of memory.
> > +      */
> > +     limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
> > +
> > +#if __riscv_xlen == 64
> > +     /* Linux expects to be booted at 2M boundary for RV64 */
> > +     kernel_offset = 0x200000;
> > +#else
> > +     /* Linux expects to be booted at 4M boundary for RV32 */
> > +     kernel_offset = 0x400000;
> > +#endif
> > +
> > +     pos = kvm->ram_start + kernel_offset;
> > +     kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
> > +     file_size = read_file(fd_kernel, pos, limit - pos);
> > +     if (file_size < 0) {
> > +             if (errno == ENOMEM)
> > +                     die("kernel image too big to fit in guest memory.");
> > +
> > +             die_perror("kernel read");
> > +     }
> > +     kernel_end = pos + file_size;
> > +     pr_debug("Loaded kernel to 0x%llx (%zd bytes)",
> > +              kvm->arch.kern_guest_start, file_size);
> > +
> > +     /* Place FDT just after kernel at FDT_ALIGN address */
> > +     pos = kernel_end + FDT_ALIGN;
> > +     guest_addr = ALIGN(host_to_guest_flat(kvm, pos), FDT_ALIGN);
> > +     pos = guest_flat_to_host(kvm, guest_addr);
> > +     if (pos < kernel_end)
> > +             die("fdt overlaps with kernel image.");
> > +
> > +     kvm->arch.dtb_guest_start = guest_addr;
> > +     pr_debug("Placing fdt at 0x%llx - 0x%llx",
> > +              kvm->arch.dtb_guest_start,
> > +              host_to_guest_flat(kvm, limit));
> > +     limit = pos;
>
> This doesn't look right. pos points to the start of the DTB, not to the top of
> free memory. You probably want to delete the line.

Actually, we are trying to place INITRD between kernel and DTB.

Having looked at it again, I think this is not right approach we should
place INITRD after DTB otherwise a bigger INITRD can easily get
corrupted by DTB creation.

>
> > +
> > +     /* ... and finally the initrd, if we have one. */
> > +     if (fd_initrd != -1) {
> > +             struct stat sb;
> > +             unsigned long initrd_start;
> > +
> > +             if (fstat(fd_initrd, &sb))
> > +                     die_perror("fstat");
> > +
> > +             pos -= (sb.st_size + INITRD_ALIGN);
>
> This too doesn't look right. You're overwriting the DTB and most likely the kernel
> with the initrd.

Sure, I will fix the placement of DTB and INITRD.

Regards,
Anup

>
> Thanks,
> Alex
> > +             guest_addr = ALIGN(host_to_guest_flat(kvm, pos), INITRD_ALIGN);
> > +             pos = guest_flat_to_host(kvm, guest_addr);
> > +             if (pos < kernel_end)
> > +                     die("initrd overlaps with kernel image.");
> > +
> > +             initrd_start = guest_addr;
> > +             file_size = read_file(fd_initrd, pos, limit - pos);
> > +             if (file_size == -1) {
> > +                     if (errno == ENOMEM)
> > +                             die("initrd too big to fit in guest memory.");
> > +
> > +                     die_perror("initrd read");
> > +             }
> > +
> > +             kvm->arch.initrd_guest_start = initrd_start;
> > +             kvm->arch.initrd_size = file_size;
> > +             pr_debug("Loaded initrd to 0x%llx (%llu bytes)",
> > +                      kvm->arch.initrd_guest_start,
> > +                      kvm->arch.initrd_size);
> > +     } else {
> > +             kvm->arch.initrd_size = 0;
> > +     }
> > +
> >       return true;
> >  }
> >
