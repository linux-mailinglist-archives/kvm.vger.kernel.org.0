Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DED1A1909
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 02:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDHACW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 20:02:22 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34472 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgDHACV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 20:02:21 -0400
Received: by mail-lf1-f66.google.com with SMTP id x23so3781678lfq.1
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 17:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bfMM8ZLchrBKInkYvAKIOS58h1BA5EGeu4xHTZBVMd0=;
        b=roWgCpzDy1JWgd4Nccg6IeCuSmw65kVUCGwA3r883bbIPiVL2xUnctJ0Rnlx/EtMYZ
         u90HbnqHo4l1p60l2IqEGJayS3AlmexsXeGKlniTnIQPW/AuJ/K/u7GUwWDT5OpH14Fs
         YhDz417BAQqVJ4giyKrz2SbPQ5FDIU7NqM8NJSc812+kZcWylyUbcJLFbzfz9pvdLEdS
         r4mEiGkeikgIY051VHv8Ly0kyraQACAyDuYOCFUCP1KCZ4sfsq4uMoyJbeE6+BXjt03o
         2DOCK2Czsh6xIxKWmPDEJoX3Tbc4xNtzgUcx+3vuZIjrEwi+4dfJskG/xyCkg3K68JBa
         yfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bfMM8ZLchrBKInkYvAKIOS58h1BA5EGeu4xHTZBVMd0=;
        b=L0LGfAA9v3UhWJEE5T9zlxFJPumtIrAcWGR07Q/pv1NEfNfbLHr2zUWZUVHb2SBWGZ
         uHFkSeokwtg5Q/ROUBxW3pulnQF9zD9nD4OSo7BUC9/eOIktJHbBpzpKWBfN5xP4X4vk
         TpT7UB9qQFKSdEnyjnn1KNvGec9hLPl8/w7i8rOMMbxwGfA7Zi3sCkgmaCIRynMJHWp9
         BzC3JdqNppfFFq6w974bWDQ7sLslwXYlDZzvALWn6bwacZAGGx31FKW3lP0FqxGoVkRs
         UasuMCfA0xx/fZNABRvsddINqwM/9GE9x2TyRlGNwpmeNJ45sSU/6gVC0Afrj1B2epiZ
         7ZRg==
X-Gm-Message-State: AGi0PuaGZrDaAqgT/rMvj9XZErei0qiWHFJhBFvi2YT+S3lwL7f3gY61
        /3Yme66zzo55V4bMBMBpiEhQcfzADZjlJc8EAVmb9w==
X-Google-Smtp-Source: APiQypKVFC7zBemlOpQ9CTCcKhTPQaPtNwursOM8WqpPegcbQ71N2y57h+Q4jNs5yWFQ2aZBhKW3r6/ECBHGnQrCXbM=
X-Received: by 2002:a19:86c3:: with SMTP id i186mr2856786lfd.209.1586304136883;
 Tue, 07 Apr 2020 17:02:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585548051.git.ashish.kalra@amd.com> <265ef8a0ab75f01bc673cce6ddcf7988c7623943.1585548051.git.ashish.kalra@amd.com>
 <CABayD+ekEYAS4z=L2r1q+8xaEzqKmJuzuYQhsWX3X=htgTvL5w@mail.gmail.com> <20200407052740.GA31821@ashkalra_ubuntu_server>
In-Reply-To: <20200407052740.GA31821@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Tue, 7 Apr 2020 17:01:40 -0700
Message-ID: <CABayD+cNdEJxoSHee3s0toy6-nO6Bm4-OsrbBdS8mCWoMBSqLQ@mail.gmail.com>
Subject: Re: [PATCH v6 08/14] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 6, 2020 at 10:27 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> Hello Steve,
>
> On Mon, Apr 06, 2020 at 07:17:37PM -0700, Steve Rutherford wrote:
> > On Sun, Mar 29, 2020 at 11:22 PM Ashish Kalra <Ashish.Kalra@amd.com> wr=
ote:
> > >
> > > From: Brijesh Singh <Brijesh.Singh@amd.com>
> > >
> > > This hypercall is used by the SEV guest to notify a change in the pag=
e
> > > encryption status to the hypervisor. The hypercall should be invoked
> > > only when the encryption attribute is changed from encrypted -> decry=
pted
> > > and vice versa. By default all guest pages are considered encrypted.
> > >
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
> > > Cc: Joerg Roedel <joro@8bytes.org>
> > > Cc: Borislav Petkov <bp@suse.de>
> > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > Cc: x86@kernel.org
> > > Cc: kvm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > ---
> > >  Documentation/virt/kvm/hypercalls.rst | 15 +++++
> > >  arch/x86/include/asm/kvm_host.h       |  2 +
> > >  arch/x86/kvm/svm.c                    | 95 +++++++++++++++++++++++++=
++
> > >  arch/x86/kvm/vmx/vmx.c                |  1 +
> > >  arch/x86/kvm/x86.c                    |  6 ++
> > >  include/uapi/linux/kvm_para.h         |  1 +
> > >  6 files changed, 120 insertions(+)
> > >
> > > diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/vi=
rt/kvm/hypercalls.rst
> > > index dbaf207e560d..ff5287e68e81 100644
> > > --- a/Documentation/virt/kvm/hypercalls.rst
> > > +++ b/Documentation/virt/kvm/hypercalls.rst
> > > @@ -169,3 +169,18 @@ a0: destination APIC ID
> > >
> > >  :Usage example: When sending a call-function IPI-many to vCPUs, yiel=
d if
> > >                 any of the IPI target vCPUs was preempted.
> > > +
> > > +
> > > +8. KVM_HC_PAGE_ENC_STATUS
> > > +-------------------------
> > > +:Architecture: x86
> > > +:Status: active
> > > +:Purpose: Notify the encryption status changes in guest page table (=
SEV guest)
> > > +
> > > +a0: the guest physical address of the start page
> > > +a1: the number of pages
> > > +a2: encryption attribute
> > > +
> > > +   Where:
> > > +       * 1: Encryption attribute is set
> > > +       * 0: Encryption attribute is cleared
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/k=
vm_host.h
> > > index 98959e8cd448..90718fa3db47 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1267,6 +1267,8 @@ struct kvm_x86_ops {
> > >
> > >         bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
> > >         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> > > +       int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> > > +                                 unsigned long sz, unsigned long mod=
e);
> > Nit: spell out size instead of sz.
> > >  };
> > >
> > >  struct kvm_arch_async_pf {
> > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > index 7c2721e18b06..1d8beaf1bceb 100644
> > > --- a/arch/x86/kvm/svm.c
> > > +++ b/arch/x86/kvm/svm.c
> > > @@ -136,6 +136,8 @@ struct kvm_sev_info {
> > >         int fd;                 /* SEV device fd */
> > >         unsigned long pages_locked; /* Number of pages locked */
> > >         struct list_head regions_list;  /* List of registered regions=
 */
> > > +       unsigned long *page_enc_bmap;
> > > +       unsigned long page_enc_bmap_size;
> > >  };
> > >
> > >  struct kvm_svm {
> > > @@ -1991,6 +1993,9 @@ static void sev_vm_destroy(struct kvm *kvm)
> > >
> > >         sev_unbind_asid(kvm, sev->handle);
> > >         sev_asid_free(sev->asid);
> > > +
> > > +       kvfree(sev->page_enc_bmap);
> > > +       sev->page_enc_bmap =3D NULL;
> > >  }
> > >
> > >  static void avic_vm_destroy(struct kvm *kvm)
> > > @@ -7593,6 +7598,94 @@ static int sev_receive_finish(struct kvm *kvm,=
 struct kvm_sev_cmd *argp)
> > >         return ret;
> > >  }
> > >
> > > +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long=
 new_size)
> > > +{
> > > +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> > > +       unsigned long *map;
> > > +       unsigned long sz;
> > > +
> > > +       if (sev->page_enc_bmap_size >=3D new_size)
> > > +               return 0;
> > > +
> > > +       sz =3D ALIGN(new_size, BITS_PER_LONG) / 8;
> > > +
> > > +       map =3D vmalloc(sz);
> > > +       if (!map) {
> > > +               pr_err_once("Failed to allocate encrypted bitmap size=
 %lx\n",
> > > +                               sz);
> > > +               return -ENOMEM;
> > > +       }
> > > +
> > > +       /* mark the page encrypted (by default) */
> > > +       memset(map, 0xff, sz);
> > > +
> > > +       bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size)=
;
> > > +       kvfree(sev->page_enc_bmap);
> > > +
> > > +       sev->page_enc_bmap =3D map;
> > > +       sev->page_enc_bmap_size =3D new_size;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa=
,
> > > +                                 unsigned long npages, unsigned long=
 enc)
> > > +{
> > > +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> > > +       kvm_pfn_t pfn_start, pfn_end;
> > > +       gfn_t gfn_start, gfn_end;
> > > +       int ret;
> > > +
> > > +       if (!sev_guest(kvm))
> > > +               return -EINVAL;
> > > +
> > > +       if (!npages)
> > > +               return 0;
> > > +
> > > +       gfn_start =3D gpa_to_gfn(gpa);
> > > +       gfn_end =3D gfn_start + npages;
> > > +
> > > +       /* out of bound access error check */
> > > +       if (gfn_end <=3D gfn_start)
> > > +               return -EINVAL;
> > > +
> > > +       /* lets make sure that gpa exist in our memslot */
> > > +       pfn_start =3D gfn_to_pfn(kvm, gfn_start);
> > > +       pfn_end =3D gfn_to_pfn(kvm, gfn_end);
> > > +
> > > +       if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_star=
t)) {
> > > +               /*
> > > +                * Allow guest MMIO range(s) to be added
> > > +                * to the page encryption bitmap.
> > > +                */
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) =
{
> > > +               /*
> > > +                * Allow guest MMIO range(s) to be added
> > > +                * to the page encryption bitmap.
> > > +                */
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       mutex_lock(&kvm->lock);
> > > +       ret =3D sev_resize_page_enc_bitmap(kvm, gfn_end);
> > > +       if (ret)
> > > +               goto unlock;
> > > +
> > > +       if (enc)
> > > +               __bitmap_set(sev->page_enc_bmap, gfn_start,
> > > +                               gfn_end - gfn_start);
> > > +       else
> > > +               __bitmap_clear(sev->page_enc_bmap, gfn_start,
> > > +                               gfn_end - gfn_start);
> > > +
> > > +unlock:
> > > +       mutex_unlock(&kvm->lock);
> > > +       return ret;
> > > +}
> > > +
> > >  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > >  {
> > >         struct kvm_sev_cmd sev_cmd;
> > > @@ -7995,6 +8088,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_afte=
r_init =3D {
> > >         .need_emulation_on_page_fault =3D svm_need_emulation_on_page_=
fault,
> > >
> > >         .apic_init_signal_blocked =3D svm_apic_init_signal_blocked,
> > > +
> > > +       .page_enc_status_hc =3D svm_page_enc_status_hc,
> > >  };
> > >
> > >  static int __init svm_init(void)
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 079d9fbf278e..f68e76ee7f9c 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -8001,6 +8001,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_afte=
r_init =3D {
> > >         .nested_get_evmcs_version =3D NULL,
> > >         .need_emulation_on_page_fault =3D vmx_need_emulation_on_page_=
fault,
> > >         .apic_init_signal_blocked =3D vmx_apic_init_signal_blocked,
> > > +       .page_enc_status_hc =3D NULL,
> > >  };
> > >
> > >  static void vmx_cleanup_l1d_flush(void)
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index cf95c36cb4f4..68428eef2dde 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -7564,6 +7564,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcp=
u)
> > >                 kvm_sched_yield(vcpu->kvm, a0);
> > >                 ret =3D 0;
> > >                 break;
> > > +       case KVM_HC_PAGE_ENC_STATUS:
> > > +               ret =3D -KVM_ENOSYS;
> > > +               if (kvm_x86_ops->page_enc_status_hc)
> > > +                       ret =3D kvm_x86_ops->page_enc_status_hc(vcpu-=
>kvm,
> > > +                                       a0, a1, a2);
> > > +               break;
> > >         default:
> > >                 ret =3D -KVM_ENOSYS;
> > >                 break;
> > > diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_p=
ara.h
> > > index 8b86609849b9..847b83b75dc8 100644
> > > --- a/include/uapi/linux/kvm_para.h
> > > +++ b/include/uapi/linux/kvm_para.h
> > > @@ -29,6 +29,7 @@
> > >  #define KVM_HC_CLOCK_PAIRING           9
> > >  #define KVM_HC_SEND_IPI                10
> > >  #define KVM_HC_SCHED_YIELD             11
> > > +#define KVM_HC_PAGE_ENC_STATUS         12
> > >
> > >  /*
> > >   * hypercalls use architecture specific
> > > --
> > > 2.17.1
> > >
> >
> > I'm still not excited by the dynamic resizing. I believe the guest
> > hypercall can be called in atomic contexts, which makes me
> > particularly unexcited to see a potentially large vmalloc on the host
> > followed by filling the buffer. Particularly when the buffer might be
> > non-trivial in size (~1MB per 32GB, per some back of the envelope
> > math).
> >
>
> I think looking at more practical situations, most hypercalls will
> happen during the boot stage, when device specific initializations are
> happening, so typically the maximum page encryption bitmap size would
> be allocated early enough.
>
> In fact, initial hypercalls made by OVMF will probably allocate the
> maximum page bitmap size even before the kernel comes up, especially
> as they will be setting up page enc/dec status for MMIO, ROM, ACPI
> regions, PCI device memory, etc., and most importantly for
> "non-existent" high memory range (which will probably be the
> maximum size page encryption bitmap allocated/resized).
>
> Let me know if you have different thoughts on this ?

Hi Ashish,

If this is not an issue in practice, we can just move past this. If we
are basically guaranteed that OVMF will trigger hypercalls that expand
the bitmap beyond the top of memory, then, yes, that should work. That
leaves me slightly nervous that OVMF might regress since it's not
obvious that calling a hypercall beyond the top of memory would be
"required" for avoiding a somewhat indirectly related issue in guest
kernels.

Adding a kvm_enable_cap doesn't seem particularly complicated and side
steps all of these concerns, so I still prefer it. Caveat, haven't
reviewed the patches about the feature bits yet: the enable cap would
also make it possible for kernels that support live migration to avoid
advertising live migration if host usermode does not want it to be
advertised. This seems pretty important, since hosts that don't plan
to live migrate should have the ability to tell the guest to stop
calling.

Thanks,
Steve
