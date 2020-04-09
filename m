Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181BC1A3B74
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 22:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgDIUl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 16:41:56 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33839 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgDIUlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 16:41:55 -0400
Received: by mail-lf1-f67.google.com with SMTP id x23so715564lfq.1
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 13:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CY6yMMcNiM658Ov2xVuGMqWgh+PKY1fPB7CNtkfRTKc=;
        b=FtZ/01qnMwv8X44Ev65XWzO4kEs/X0mFjNiKJ7ZnBTNOyFys9iEXG4PwugdrM0Fbre
         nbXM79DjPZCHZoWRV4LU8WnfqcNw0osNzLEGgQIB5EHRPHStDnb8hobBAqbef5YFDyNj
         BfxQgRs9T0Gr0G4T4lyJ//l1gcrb659rvCoecSQDeavDoh775fQj0lDFauqib7dhxoTe
         a91t2GPFuiX8c2G3BSNUD/h4JchXnArV4U80sI29H/EC2ALSvnsIiZK/6QCkjqKphZy6
         JWvQ4qq1sea8Xs/x9y01EZ+lPqLbRENSQkbULw1OcSXcdWsvoYQ9yohvjjClt8/ThvPS
         yKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CY6yMMcNiM658Ov2xVuGMqWgh+PKY1fPB7CNtkfRTKc=;
        b=sP+Wn2sB/h2NfB9vamzs6lZsBY1vNOnye+osEGzJZ1EXFhcLTPXhRnoIS+ZsRdZxhI
         jLbzI/fdSdo2dvow++cVJfuIQPJ9SpJFD647usLZqgR0nokl8ds5giKTpdmajw1gV1zM
         O7NK1Vn9wxEAKvx2xmB/4vyOfMr6eStdIBOf5yBbn+gr677goP03Ku0HtPn/fZ4C6kT7
         3pe4WBwiSTh/DhGZwZgYVq6dZSRSgfJBlA4Ke4s2HIzQuTr4zAs7/9t4wxylPncTCgno
         10PGZyAfNPyfvhBlcQjTrNLcv0kRVNHRw8YRQHP97MuObP581xT2XBnN8EHQnFyX84qj
         Ws/Q==
X-Gm-Message-State: AGi0PuaQlPzzxcbHn/UoIEIhQFjRWma/Zrdqplj/oND8lxnkRmxSFN+L
        M9uo1XN7B8RndDeBOJdc5UmFMWte40qMFVyPdBzHeg==
X-Google-Smtp-Source: APiQypLaW+WbYLMHex3ipsaOtLTO+uKh9J59KF3qqswERC0KfBbzldmIXktMMA2yjD6uL7Yw0fGWUdZ1EvCU7Pz0ipg=
X-Received: by 2002:ac2:515d:: with SMTP id q29mr645642lfd.210.1586464909807;
 Thu, 09 Apr 2020 13:41:49 -0700 (PDT)
MIME-Version: 1.0
References: <265ef8a0ab75f01bc673cce6ddcf7988c7623943.1585548051.git.ashish.kalra@amd.com>
 <CABayD+ekEYAS4z=L2r1q+8xaEzqKmJuzuYQhsWX3X=htgTvL5w@mail.gmail.com>
 <20200407052740.GA31821@ashkalra_ubuntu_server> <CABayD+cNdEJxoSHee3s0toy6-nO6Bm4-OsrbBdS8mCWoMBSqLQ@mail.gmail.com>
 <d67a104e-6a01-a766-63b2-3f8b6026ca4c@amd.com> <CABayD+ehZZabp2tA8K-ViB0BXPyjpz-XpXPXoD7MUH0OLz_Z-g@mail.gmail.com>
 <20200408011726.GA3684@ashkalra_ubuntu_server> <CABayD+et6p8UAr1jTFMK2SbYvihveLH6kp=RRqzBxvaU-HPy2Q@mail.gmail.com>
 <42597534-b8c6-4c73-9b12-ddbde079fc7c@amd.com> <20200408031818.GA27654@ashkalra_ubuntu_server>
 <20200409161812.GA18882@ashkalra_ubuntu_server>
In-Reply-To: <20200409161812.GA18882@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 9 Apr 2020 13:41:13 -0700
Message-ID: <CABayD+cLq9WORd4xik_keuaW4eNgQcKBN_x9K-wqtPH0eE3gGQ@mail.gmail.com>
Subject: Re: [PATCH v6 08/14] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 9, 2020 at 9:18 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> Hello Brijesh, Steve,
>
> On Wed, Apr 08, 2020 at 03:18:18AM +0000, Ashish Kalra wrote:
> > Hello Brijesh,
> >
> > On Tue, Apr 07, 2020 at 09:34:15PM -0500, Brijesh Singh wrote:
> > >
> > > On 4/7/20 8:38 PM, Steve Rutherford wrote:
> > > > On Tue, Apr 7, 2020 at 6:17 PM Ashish Kalra <ashish.kalra@amd.com> =
wrote:
> > > >> Hello Steve, Brijesh,
> > > >>
> > > >> On Tue, Apr 07, 2020 at 05:35:57PM -0700, Steve Rutherford wrote:
> > > >>> On Tue, Apr 7, 2020 at 5:29 PM Brijesh Singh <brijesh.singh@amd.c=
om> wrote:
> > > >>>>
> > > >>>> On 4/7/20 7:01 PM, Steve Rutherford wrote:
> > > >>>>> On Mon, Apr 6, 2020 at 10:27 PM Ashish Kalra <ashish.kalra@amd.=
com> wrote:
> > > >>>>>> Hello Steve,
> > > >>>>>>
> > > >>>>>> On Mon, Apr 06, 2020 at 07:17:37PM -0700, Steve Rutherford wro=
te:
> > > >>>>>>> On Sun, Mar 29, 2020 at 11:22 PM Ashish Kalra <Ashish.Kalra@a=
md.com> wrote:
> > > >>>>>>>> From: Brijesh Singh <Brijesh.Singh@amd.com>
> > > >>>>>>>>
> > > >>>>>>>> This hypercall is used by the SEV guest to notify a change i=
n the page
> > > >>>>>>>> encryption status to the hypervisor. The hypercall should be=
 invoked
> > > >>>>>>>> only when the encryption attribute is changed from encrypted=
 -> decrypted
> > > >>>>>>>> and vice versa. By default all guest pages are considered en=
crypted.
> > > >>>>>>>>
> > > >>>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
> > > >>>>>>>> Cc: Ingo Molnar <mingo@redhat.com>
> > > >>>>>>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > >>>>>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > >>>>>>>> Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
> > > >>>>>>>> Cc: Joerg Roedel <joro@8bytes.org>
> > > >>>>>>>> Cc: Borislav Petkov <bp@suse.de>
> > > >>>>>>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > >>>>>>>> Cc: x86@kernel.org
> > > >>>>>>>> Cc: kvm@vger.kernel.org
> > > >>>>>>>> Cc: linux-kernel@vger.kernel.org
> > > >>>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > >>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > >>>>>>>> ---
> > > >>>>>>>>  Documentation/virt/kvm/hypercalls.rst | 15 +++++
> > > >>>>>>>>  arch/x86/include/asm/kvm_host.h       |  2 +
> > > >>>>>>>>  arch/x86/kvm/svm.c                    | 95 ++++++++++++++++=
+++++++++++
> > > >>>>>>>>  arch/x86/kvm/vmx/vmx.c                |  1 +
> > > >>>>>>>>  arch/x86/kvm/x86.c                    |  6 ++
> > > >>>>>>>>  include/uapi/linux/kvm_para.h         |  1 +
> > > >>>>>>>>  6 files changed, 120 insertions(+)
> > > >>>>>>>>
> > > >>>>>>>> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documen=
tation/virt/kvm/hypercalls.rst
> > > >>>>>>>> index dbaf207e560d..ff5287e68e81 100644
> > > >>>>>>>> --- a/Documentation/virt/kvm/hypercalls.rst
> > > >>>>>>>> +++ b/Documentation/virt/kvm/hypercalls.rst
> > > >>>>>>>> @@ -169,3 +169,18 @@ a0: destination APIC ID
> > > >>>>>>>>
> > > >>>>>>>>  :Usage example: When sending a call-function IPI-many to vC=
PUs, yield if
> > > >>>>>>>>                 any of the IPI target vCPUs was preempted.
> > > >>>>>>>> +
> > > >>>>>>>> +
> > > >>>>>>>> +8. KVM_HC_PAGE_ENC_STATUS
> > > >>>>>>>> +-------------------------
> > > >>>>>>>> +:Architecture: x86
> > > >>>>>>>> +:Status: active
> > > >>>>>>>> +:Purpose: Notify the encryption status changes in guest pag=
e table (SEV guest)
> > > >>>>>>>> +
> > > >>>>>>>> +a0: the guest physical address of the start page
> > > >>>>>>>> +a1: the number of pages
> > > >>>>>>>> +a2: encryption attribute
> > > >>>>>>>> +
> > > >>>>>>>> +   Where:
> > > >>>>>>>> +       * 1: Encryption attribute is set
> > > >>>>>>>> +       * 0: Encryption attribute is cleared
> > > >>>>>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/incl=
ude/asm/kvm_host.h
> > > >>>>>>>> index 98959e8cd448..90718fa3db47 100644
> > > >>>>>>>> --- a/arch/x86/include/asm/kvm_host.h
> > > >>>>>>>> +++ b/arch/x86/include/asm/kvm_host.h
> > > >>>>>>>> @@ -1267,6 +1267,8 @@ struct kvm_x86_ops {
> > > >>>>>>>>
> > > >>>>>>>>         bool (*apic_init_signal_blocked)(struct kvm_vcpu *vc=
pu);
> > > >>>>>>>>         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu)=
;
> > > >>>>>>>> +       int (*page_enc_status_hc)(struct kvm *kvm, unsigned =
long gpa,
> > > >>>>>>>> +                                 unsigned long sz, unsigned=
 long mode);
> > > >>>>>>> Nit: spell out size instead of sz.
> > > >>>>>>>>  };
> > > >>>>>>>>
> > > >>>>>>>>  struct kvm_arch_async_pf {
> > > >>>>>>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > >>>>>>>> index 7c2721e18b06..1d8beaf1bceb 100644
> > > >>>>>>>> --- a/arch/x86/kvm/svm.c
> > > >>>>>>>> +++ b/arch/x86/kvm/svm.c
> > > >>>>>>>> @@ -136,6 +136,8 @@ struct kvm_sev_info {
> > > >>>>>>>>         int fd;                 /* SEV device fd */
> > > >>>>>>>>         unsigned long pages_locked; /* Number of pages locke=
d */
> > > >>>>>>>>         struct list_head regions_list;  /* List of registere=
d regions */
> > > >>>>>>>> +       unsigned long *page_enc_bmap;
> > > >>>>>>>> +       unsigned long page_enc_bmap_size;
> > > >>>>>>>>  };
> > > >>>>>>>>
> > > >>>>>>>>  struct kvm_svm {
> > > >>>>>>>> @@ -1991,6 +1993,9 @@ static void sev_vm_destroy(struct kvm =
*kvm)
> > > >>>>>>>>
> > > >>>>>>>>         sev_unbind_asid(kvm, sev->handle);
> > > >>>>>>>>         sev_asid_free(sev->asid);
> > > >>>>>>>> +
> > > >>>>>>>> +       kvfree(sev->page_enc_bmap);
> > > >>>>>>>> +       sev->page_enc_bmap =3D NULL;
> > > >>>>>>>>  }
> > > >>>>>>>>
> > > >>>>>>>>  static void avic_vm_destroy(struct kvm *kvm)
> > > >>>>>>>> @@ -7593,6 +7598,94 @@ static int sev_receive_finish(struct =
kvm *kvm, struct kvm_sev_cmd *argp)
> > > >>>>>>>>         return ret;
> > > >>>>>>>>  }
> > > >>>>>>>>
> > > >>>>>>>> +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsi=
gned long new_size)
> > > >>>>>>>> +{
> > > >>>>>>>> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_i=
nfo;
> > > >>>>>>>> +       unsigned long *map;
> > > >>>>>>>> +       unsigned long sz;
> > > >>>>>>>> +
> > > >>>>>>>> +       if (sev->page_enc_bmap_size >=3D new_size)
> > > >>>>>>>> +               return 0;
> > > >>>>>>>> +
> > > >>>>>>>> +       sz =3D ALIGN(new_size, BITS_PER_LONG) / 8;
> > > >>>>>>>> +
> > > >>>>>>>> +       map =3D vmalloc(sz);
> > > >>>>>>>> +       if (!map) {
> > > >>>>>>>> +               pr_err_once("Failed to allocate encrypted bi=
tmap size %lx\n",
> > > >>>>>>>> +                               sz);
> > > >>>>>>>> +               return -ENOMEM;
> > > >>>>>>>> +       }
> > > >>>>>>>> +
> > > >>>>>>>> +       /* mark the page encrypted (by default) */
> > > >>>>>>>> +       memset(map, 0xff, sz);
> > > >>>>>>>> +
> > > >>>>>>>> +       bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_b=
map_size);
> > > >>>>>>>> +       kvfree(sev->page_enc_bmap);
> > > >>>>>>>> +
> > > >>>>>>>> +       sev->page_enc_bmap =3D map;
> > > >>>>>>>> +       sev->page_enc_bmap_size =3D new_size;
> > > >>>>>>>> +
> > > >>>>>>>> +       return 0;
> > > >>>>>>>> +}
> > > >>>>>>>> +
> > > >>>>>>>> +static int svm_page_enc_status_hc(struct kvm *kvm, unsigned=
 long gpa,
> > > >>>>>>>> +                                 unsigned long npages, unsi=
gned long enc)
> > > >>>>>>>> +{
> > > >>>>>>>> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_i=
nfo;
> > > >>>>>>>> +       kvm_pfn_t pfn_start, pfn_end;
> > > >>>>>>>> +       gfn_t gfn_start, gfn_end;
> > > >>>>>>>> +       int ret;
> > > >>>>>>>> +
> > > >>>>>>>> +       if (!sev_guest(kvm))
> > > >>>>>>>> +               return -EINVAL;
> > > >>>>>>>> +
> > > >>>>>>>> +       if (!npages)
> > > >>>>>>>> +               return 0;
> > > >>>>>>>> +
> > > >>>>>>>> +       gfn_start =3D gpa_to_gfn(gpa);
> > > >>>>>>>> +       gfn_end =3D gfn_start + npages;
> > > >>>>>>>> +
> > > >>>>>>>> +       /* out of bound access error check */
> > > >>>>>>>> +       if (gfn_end <=3D gfn_start)
> > > >>>>>>>> +               return -EINVAL;
> > > >>>>>>>> +
> > > >>>>>>>> +       /* lets make sure that gpa exist in our memslot */
> > > >>>>>>>> +       pfn_start =3D gfn_to_pfn(kvm, gfn_start);
> > > >>>>>>>> +       pfn_end =3D gfn_to_pfn(kvm, gfn_end);
> > > >>>>>>>> +
> > > >>>>>>>> +       if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn=
(pfn_start)) {
> > > >>>>>>>> +               /*
> > > >>>>>>>> +                * Allow guest MMIO range(s) to be added
> > > >>>>>>>> +                * to the page encryption bitmap.
> > > >>>>>>>> +                */
> > > >>>>>>>> +               return -EINVAL;
> > > >>>>>>>> +       }
> > > >>>>>>>> +
> > > >>>>>>>> +       if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(p=
fn_end)) {
> > > >>>>>>>> +               /*
> > > >>>>>>>> +                * Allow guest MMIO range(s) to be added
> > > >>>>>>>> +                * to the page encryption bitmap.
> > > >>>>>>>> +                */
> > > >>>>>>>> +               return -EINVAL;
> > > >>>>>>>> +       }
> > > >>>>>>>> +
> > > >>>>>>>> +       mutex_lock(&kvm->lock);
> > > >>>>>>>> +       ret =3D sev_resize_page_enc_bitmap(kvm, gfn_end);
> > > >>>>>>>> +       if (ret)
> > > >>>>>>>> +               goto unlock;
> > > >>>>>>>> +
> > > >>>>>>>> +       if (enc)
> > > >>>>>>>> +               __bitmap_set(sev->page_enc_bmap, gfn_start,
> > > >>>>>>>> +                               gfn_end - gfn_start);
> > > >>>>>>>> +       else
> > > >>>>>>>> +               __bitmap_clear(sev->page_enc_bmap, gfn_start=
,
> > > >>>>>>>> +                               gfn_end - gfn_start);
> > > >>>>>>>> +
> > > >>>>>>>> +unlock:
> > > >>>>>>>> +       mutex_unlock(&kvm->lock);
> > > >>>>>>>> +       return ret;
> > > >>>>>>>> +}
> > > >>>>>>>> +
> > > >>>>>>>>  static int svm_mem_enc_op(struct kvm *kvm, void __user *arg=
p)
> > > >>>>>>>>  {
> > > >>>>>>>>         struct kvm_sev_cmd sev_cmd;
> > > >>>>>>>> @@ -7995,6 +8088,8 @@ static struct kvm_x86_ops svm_x86_ops =
__ro_after_init =3D {
> > > >>>>>>>>         .need_emulation_on_page_fault =3D svm_need_emulation=
_on_page_fault,
> > > >>>>>>>>
> > > >>>>>>>>         .apic_init_signal_blocked =3D svm_apic_init_signal_b=
locked,
> > > >>>>>>>> +
> > > >>>>>>>> +       .page_enc_status_hc =3D svm_page_enc_status_hc,
> > > >>>>>>>>  };
> > > >>>>>>>>
> > > >>>>>>>>  static int __init svm_init(void)
> > > >>>>>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > >>>>>>>> index 079d9fbf278e..f68e76ee7f9c 100644
> > > >>>>>>>> --- a/arch/x86/kvm/vmx/vmx.c
> > > >>>>>>>> +++ b/arch/x86/kvm/vmx/vmx.c
> > > >>>>>>>> @@ -8001,6 +8001,7 @@ static struct kvm_x86_ops vmx_x86_ops =
__ro_after_init =3D {
> > > >>>>>>>>         .nested_get_evmcs_version =3D NULL,
> > > >>>>>>>>         .need_emulation_on_page_fault =3D vmx_need_emulation=
_on_page_fault,
> > > >>>>>>>>         .apic_init_signal_blocked =3D vmx_apic_init_signal_b=
locked,
> > > >>>>>>>> +       .page_enc_status_hc =3D NULL,
> > > >>>>>>>>  };
> > > >>>>>>>>
> > > >>>>>>>>  static void vmx_cleanup_l1d_flush(void)
> > > >>>>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > >>>>>>>> index cf95c36cb4f4..68428eef2dde 100644
> > > >>>>>>>> --- a/arch/x86/kvm/x86.c
> > > >>>>>>>> +++ b/arch/x86/kvm/x86.c
> > > >>>>>>>> @@ -7564,6 +7564,12 @@ int kvm_emulate_hypercall(struct kvm_=
vcpu *vcpu)
> > > >>>>>>>>                 kvm_sched_yield(vcpu->kvm, a0);
> > > >>>>>>>>                 ret =3D 0;
> > > >>>>>>>>                 break;
> > > >>>>>>>> +       case KVM_HC_PAGE_ENC_STATUS:
> > > >>>>>>>> +               ret =3D -KVM_ENOSYS;
> > > >>>>>>>> +               if (kvm_x86_ops->page_enc_status_hc)
> > > >>>>>>>> +                       ret =3D kvm_x86_ops->page_enc_status=
_hc(vcpu->kvm,
> > > >>>>>>>> +                                       a0, a1, a2);
> > > >>>>>>>> +               break;
> > > >>>>>>>>         default:
> > > >>>>>>>>                 ret =3D -KVM_ENOSYS;
> > > >>>>>>>>                 break;
> > > >>>>>>>> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/li=
nux/kvm_para.h
> > > >>>>>>>> index 8b86609849b9..847b83b75dc8 100644
> > > >>>>>>>> --- a/include/uapi/linux/kvm_para.h
> > > >>>>>>>> +++ b/include/uapi/linux/kvm_para.h
> > > >>>>>>>> @@ -29,6 +29,7 @@
> > > >>>>>>>>  #define KVM_HC_CLOCK_PAIRING           9
> > > >>>>>>>>  #define KVM_HC_SEND_IPI                10
> > > >>>>>>>>  #define KVM_HC_SCHED_YIELD             11
> > > >>>>>>>> +#define KVM_HC_PAGE_ENC_STATUS         12
> > > >>>>>>>>
> > > >>>>>>>>  /*
> > > >>>>>>>>   * hypercalls use architecture specific
> > > >>>>>>>> --
> > > >>>>>>>> 2.17.1
> > > >>>>>>>>
> > > >>>>>>> I'm still not excited by the dynamic resizing. I believe the =
guest
> > > >>>>>>> hypercall can be called in atomic contexts, which makes me
> > > >>>>>>> particularly unexcited to see a potentially large vmalloc on =
the host
> > > >>>>>>> followed by filling the buffer. Particularly when the buffer =
might be
> > > >>>>>>> non-trivial in size (~1MB per 32GB, per some back of the enve=
lope
> > > >>>>>>> math).
> > > >>>>>>>
> > > >>>>>> I think looking at more practical situations, most hypercalls =
will
> > > >>>>>> happen during the boot stage, when device specific initializat=
ions are
> > > >>>>>> happening, so typically the maximum page encryption bitmap siz=
e would
> > > >>>>>> be allocated early enough.
> > > >>>>>>
> > > >>>>>> In fact, initial hypercalls made by OVMF will probably allocat=
e the
> > > >>>>>> maximum page bitmap size even before the kernel comes up, espe=
cially
> > > >>>>>> as they will be setting up page enc/dec status for MMIO, ROM, =
ACPI
> > > >>>>>> regions, PCI device memory, etc., and most importantly for
> > > >>>>>> "non-existent" high memory range (which will probably be the
> > > >>>>>> maximum size page encryption bitmap allocated/resized).
> > > >>>>>>
> > > >>>>>> Let me know if you have different thoughts on this ?
> > > >>>>> Hi Ashish,
> > > >>>>>
> > > >>>>> If this is not an issue in practice, we can just move past this=
. If we
> > > >>>>> are basically guaranteed that OVMF will trigger hypercalls that=
 expand
> > > >>>>> the bitmap beyond the top of memory, then, yes, that should wor=
k. That
> > > >>>>> leaves me slightly nervous that OVMF might regress since it's n=
ot
> > > >>>>> obvious that calling a hypercall beyond the top of memory would=
 be
> > > >>>>> "required" for avoiding a somewhat indirectly related issue in =
guest
> > > >>>>> kernels.
> > > >>>>
> > > >>>> If possible then we should try to avoid growing/shrinking the bi=
tmap .
> > > >>>> Today OVMF may not be accessing beyond memory but a malicious gu=
est
> > > >>>> could send a hypercall down which can trigger a huge memory allo=
cation
> > > >>>> on the host side and may eventually cause denial of service for =
other.
> > > >>> Nice catch! Was just writing up an email about this.
> > > >>>> I am in favor if we can find some solution to handle this case. =
How
> > > >>>> about Steve's suggestion about VMM making a call down to the ker=
nel to
> > > >>>> tell how big the bitmap should be? Initially it should be equal =
to the
> > > >>>> guest RAM and if VMM ever did the memory expansion then it can s=
end down
> > > >>>> another notification to increase the bitmap ?
> > > >>>>
> > > >>>> Optionally, instead of adding a new ioctl, I was wondering if we=
 can
> > > >>>> extend the kvm_arch_prepare_memory_region() to make svm specific=
 x86_ops
> > > >>>> which can take read the userspace provided memory region and cal=
culate
> > > >>>> the amount of guest RAM managed by the KVM and grow/shrink the b=
itmap
> > > >>>> based on that information. I have not looked deep enough to see =
if its
> > > >>>> doable but if it can work then we can avoid adding yet another i=
octl.
> > > >>> We also have the set bitmap ioctl in a later patch in this series=
. We
> > > >>> could also use the set ioctl for initialization (it's a little
> > > >>> excessive for initialization since there will be an additional
> > > >>> ephemeral allocation and a few additional buffer copies, but that=
's
> > > >>> probably fine). An enable_cap has the added benefit of probably b=
eing
> > > >>> necessary anyway so usermode can disable the migration feature fl=
ag.
> > > >>>
> > > >>> In general, userspace is going to have to be in direct control of=
 the
> > > >>> buffer and its size.
> > > >> My only practical concern about setting a static bitmap size based=
 on guest
> > > >> memory is about the hypercalls being made initially by OVMF to set=
 page
> > > >> enc/dec status for ROM, ACPI regions and especially the non-existe=
nt
> > > >> high memory range. The new ioctl will statically setup bitmap size=
 to
> > > >> whatever guest RAM is specified, say 4G, 8G, etc., but the OVMF
> > > >> hypercall for non-existent memory will try to do a hypercall for g=
uest
> > > >> physical memory range like ~6G->64G (for 4G guest RAM setup), this
> > > >> hypercall will basically have to just return doing nothing, becaus=
e
> > > >> the allocated bitmap won't have this guest physical range availabl=
e ?
> > >
> > >
> > > IMO, Ovmf issuing a hypercall beyond the guest RAM is simple wrong, i=
t
> > > should *not* do that.  There was a feature request I submitted someti=
me
> > > back to Tianocore https://bugzilla.tianocore.org/show_bug.cgi?id=3D62=
3 as
> > > I saw this coming in future. I tried highlighting the problem in the
> > > MdeModulePkg that it does not provide a notifier to tell OVMF when co=
re
> > > creates the MMIO holes etc. It was not a big problem with the SEV
> > > initially because we were never getting down to hypervisor to do
> > > something about those non-existent regions. But with the migration it=
s
> > > now important that we should restart the discussion with UEFI folks a=
nd
> > > see what can be done. In the kernel patches we should do what is righ=
t
> > > for the kernel and not workaround the Ovmf limitation.
> >
> > Ok, this makes sense. I will start exploring
> > kvm_arch_prepare_memory_region() to see if it can assist in computing
> > the guest RAM or otherwise i will look at adding a new ioctl interface
> > for the same.
> >
>
> I looked at kvm_arch_prepare_memory_region() and
> kvm_arch_commit_memory_region() and kvm_arch_commit_memory_region()
> looks to be ideal to use for this.
>
> I walked the kvm_memslots in this function and i can compute the
> approximate guest RAM mapped by KVM, though, i get the guest RAM size as
> "twice" the configured size because of the two address spaces on x86 KVM,
> i believe there is one additional address space for SMM/SMRAM use.
>
> I don't think we have a use case of migrating a SEV guest with SMM
> support ?
>
> Considering that, i believe that i can just compute the guest RAM size
> using memslots for address space #0 and use that to grow/shrink the bitma=
p.
>
> As you mentioned i will need to add a new SVM specific x86_ops to
> callback as part of kvm_arch_commit_memory_region() which will in-turn
> call sev_resize_page_enc_bitmap().
>
> Thanks,
> Ashish
>
> > >
> > >
> > > >> Also, hypercalls for ROM, ACPI, device regions and any memory hole=
s within
> > > >> the static bitmap setup as per guest RAM config will work, but wha=
t
> > > >> about hypercalls for any device regions beyond the guest RAM confi=
g ?
> > > >>
> > > >> Thanks,
> > > >> Ashish
Supporting Migration of SEV VM with SMM seems unnecessary, but I
wouldn't go out of my way to make it harder to fix. The bitmap is
as_id unaware already (as it likely should be, since the PA space is
shared), so I would personally ignore summing up the sizes, and
instead look for the highest PA that is mapped by a memslot. If I'm
not mistaken, the address spaces should (more or less) entirely
overlap. This will be suboptimal if the PA space is sparse, but that
would be weird anyway.

You could also go back to a suggestion I had much earlier and have the
memslots own the bitmaps. I believe there is space to add flags for
enabling and disabling features like this on memslots. Basically, you
could treat this in the same way as dirty bitmaps, which seem pretty
similar. This would work well even if PA space were sparse.

The current patch set is nowhere near sufficient for supporting SMM
migration securely, which is fine: we would need to separate out
access to the hypercall for particular pages, so that non-SMM could
not corrupt SMM. And then the code in SMM would also need to support
the hypercall if it ever used shared pages. Until someone asks for
this I don't believe it is worth doing. If we put the bitmaps on the
memslots, we could probably limit access to a memslot's bitmap to
vcpus that can access that memslot. This seems unnecessary for now.

--Steve
