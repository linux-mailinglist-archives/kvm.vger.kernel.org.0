Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF971E8D07
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgE3CGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgE3CGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:06:06 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE84BC03E969
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:06:04 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k18so1428580ion.0
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WogKYcbG3qNJMOb5Lxqhum7hEQWrNJSB+tfFFDCww+c=;
        b=tFOx3oy10W3TsqyL7+OV91Eax58OKGIJvAruJXA02FqafBgiXfsY9rOQq6DAPIGZac
         6c/fTp8xxB3i2+tE+f8AN0Ovt6nQ4HSPYnr/YcS3GNM7yJFonV5XG8oQOlHjGdJNyyOQ
         7PziDzUCNcQvi9ARM1UcZZ+uALm+/XCq6M/28uq2ZDXfHaJK1PKxf+ePfVnC44/y2hj1
         xgLrwD1oTJG0cx5q3j7hZvq1gMHZq1WcjTIbYgHMeh1pyDyH/HWFfun/W8fT3zqS7Zwl
         xXxkh6UjI9XwHdGG10+xetDQDbczb0tVF1mMUVm6686ituAFz8F+qBWnJEJ4709dQgWy
         aQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WogKYcbG3qNJMOb5Lxqhum7hEQWrNJSB+tfFFDCww+c=;
        b=GAmryt99e3iQJGqwo+cO+/ZnNFosC0hLO40Q+gE8q46ik1vLFf+J9cfTTzmRWcbt58
         K1b8gQRq4kE8OH7gCrevAfLkjpj3HW1RBTMJkKgwbjzk+iXxCixzFkrZIKgnapKgAXT+
         1VFWTVEywwVfsJ2RyD7L2wx2qLihkU0HdI7heesP6Z2pujXDzTUqSpN8gtumYUVEyeiK
         uDIpSvxRlo2sun1vPgHjbu+gpSrsp4N1Mp3z6MEA3ITfQnZwilfgu3KRUpegXDxAkeK5
         Zrlj/UsapOa+eAymYLbDqOqiOUkPzojiVQqDh0tFoZWqGHhX7ptYSfoq+1jVt3YFC6sP
         VMcA==
X-Gm-Message-State: AOAM533Qm9ir9gNKDC788ApqrfGWx1I5gJksXdLMn2Gczro1T5fs9HsY
        EIEI2bmW7k8J3unbf6l3hhxrrUC2kIyoo81wLRhiyg==
X-Google-Smtp-Source: ABdhPJzVCr03T5/8S/5Rb2FcAPLy/y1eXK/XKIYLv4pK2GWAreITZZVcI3K+e7WV9tfPlmFsaTBlr/MNuvO5+ZQAAto=
X-Received: by 2002:a5d:8914:: with SMTP id b20mr9512453ion.34.1590804363673;
 Fri, 29 May 2020 19:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <12a50d857773f74f25555e0985480fb565ec8438.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <12a50d857773f74f25555e0985480fb565ec8438.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:05:27 -0700
Message-ID: <CABayD+cOkNX=1xafxEnixg7UF3N3eP-Vbj_XXJVRk3fP=W5yzw@mail.gmail.com>
Subject: Re: [PATCH v8 08/18] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 5, 2020 at 2:17 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> This hypercall is used by the SEV guest to notify a change in the page
> encryption status to the hypervisor. The hypercall should be invoked
> only when the encryption attribute is changed from encrypted -> decrypted
> and vice versa. By default all guest pages are considered encrypted.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  Documentation/virt/kvm/hypercalls.rst | 15 +++++
>  arch/x86/include/asm/kvm_host.h       |  2 +
>  arch/x86/kvm/svm/sev.c                | 90 +++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c                |  2 +
>  arch/x86/kvm/svm/svm.h                |  4 ++
>  arch/x86/kvm/vmx/vmx.c                |  1 +
>  arch/x86/kvm/x86.c                    |  6 ++
>  include/uapi/linux/kvm_para.h         |  1 +
>  8 files changed, 121 insertions(+)
>
> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/k=
vm/hypercalls.rst
> index dbaf207e560d..ff5287e68e81 100644
> --- a/Documentation/virt/kvm/hypercalls.rst
> +++ b/Documentation/virt/kvm/hypercalls.rst
> @@ -169,3 +169,18 @@ a0: destination APIC ID
>
>  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
>                 any of the IPI target vCPUs was preempted.
> +
> +
> +8. KVM_HC_PAGE_ENC_STATUS
> +-------------------------
> +:Architecture: x86
> +:Status: active
> +:Purpose: Notify the encryption status changes in guest page table (SEV =
guest)
> +
> +a0: the guest physical address of the start page
> +a1: the number of pages
> +a2: encryption attribute
> +
> +   Where:
> +       * 1: Encryption attribute is set
> +       * 0: Encryption attribute is cleared
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 42a2d0d3984a..4a8ee22f4f5b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1254,6 +1254,8 @@ struct kvm_x86_ops {
>
>         bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> +       int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> +                                 unsigned long sz, unsigned long mode);
>  };
>
>  struct kvm_x86_init_ops {
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 698704defbcd..f088467708f0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1347,6 +1347,93 @@ static int sev_receive_finish(struct kvm *kvm, str=
uct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new=
_size)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       unsigned long *map;
> +       unsigned long sz;
> +
> +       if (sev->page_enc_bmap_size >=3D new_size)
> +               return 0;
> +
> +       sz =3D ALIGN(new_size, BITS_PER_LONG) / 8;
> +
> +       map =3D vmalloc(sz);
> +       if (!map) {
> +               pr_err_once("Failed to allocate encrypted bitmap size %lx=
\n",
> +                               sz);
> +               return -ENOMEM;
> +       }
> +
> +       /* mark the page encrypted (by default) */
> +       memset(map, 0xff, sz);
> +
> +       bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size);
> +       kvfree(sev->page_enc_bmap);
> +
> +       sev->page_enc_bmap =3D map;
> +       sev->page_enc_bmap_size =3D new_size;
> +
> +       return 0;
> +}
> +
> +int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> +                                 unsigned long npages, unsigned long enc=
)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       kvm_pfn_t pfn_start, pfn_end;
> +       gfn_t gfn_start, gfn_end;
> +
> +       if (!sev_guest(kvm))
> +               return -EINVAL;
> +
> +       if (!npages)
> +               return 0;
> +
> +       gfn_start =3D gpa_to_gfn(gpa);
> +       gfn_end =3D gfn_start + npages;
> +
> +       /* out of bound access error check */
> +       if (gfn_end <=3D gfn_start)
> +               return -EINVAL;
> +
> +       /* lets make sure that gpa exist in our memslot */
> +       pfn_start =3D gfn_to_pfn(kvm, gfn_start);
> +       pfn_end =3D gfn_to_pfn(kvm, gfn_end);
> +
> +       if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) =
{
> +               /*
> +                * Allow guest MMIO range(s) to be added
> +                * to the page encryption bitmap.
> +                */
> +               return -EINVAL;
> +       }
> +
> +       if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> +               /*
> +                * Allow guest MMIO range(s) to be added
> +                * to the page encryption bitmap.
> +                */
> +               return -EINVAL;
> +       }
> +
> +       mutex_lock(&kvm->lock);
> +
> +       if (sev->page_enc_bmap_size < gfn_end)
> +               goto unlock;
> +
> +       if (enc)
> +               __bitmap_set(sev->page_enc_bmap, gfn_start,
> +                               gfn_end - gfn_start);
> +       else
> +               __bitmap_clear(sev->page_enc_bmap, gfn_start,
> +                               gfn_end - gfn_start);
> +
> +unlock:
> +       mutex_unlock(&kvm->lock);
> +       return 0;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -1560,6 +1647,9 @@ void sev_vm_destroy(struct kvm *kvm)
>
>         sev_unbind_asid(kvm, sev->handle);
>         sev_asid_free(sev->asid);
> +
> +       kvfree(sev->page_enc_bmap);
> +       sev->page_enc_bmap =3D NULL;
>  }
>
>  int __init sev_hardware_setup(void)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2f379bacbb26..1013ef0f4ce2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4014,6 +4014,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>         .apic_init_signal_blocked =3D svm_apic_init_signal_blocked,
>
>         .check_nested_events =3D svm_check_nested_events,
> +
> +       .page_enc_status_hc =3D svm_page_enc_status_hc,
>  };
>
>  static struct kvm_x86_init_ops svm_init_ops __initdata =3D {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index df3474f4fb02..6a562f5928a2 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -65,6 +65,8 @@ struct kvm_sev_info {
>         int fd;                 /* SEV device fd */
>         unsigned long pages_locked; /* Number of pages locked */
>         struct list_head regions_list;  /* List of registered regions */
> +       unsigned long *page_enc_bmap;
> +       unsigned long page_enc_bmap_size;
>  };
>
>  struct kvm_svm {
> @@ -400,6 +402,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, =
unsigned nr,
>                                bool has_error_code, u32 error_code);
>  int svm_check_nested_events(struct kvm_vcpu *vcpu);
>  int nested_svm_exit_special(struct vcpu_svm *svm);
> +int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> +                                 unsigned long npages, unsigned long enc=
);
>
>  /* avic.c */
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c2c6335a998c..7d01d3aa6461 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7838,6 +7838,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata =
=3D {
>         .nested_get_evmcs_version =3D NULL,
>         .need_emulation_on_page_fault =3D vmx_need_emulation_on_page_faul=
t,
>         .apic_init_signal_blocked =3D vmx_apic_init_signal_blocked,
> +       .page_enc_status_hc =3D NULL,
>  };
>
>  static __init int hardware_setup(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c5835f9cb9ad..5f5ddb5765e2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7605,6 +7605,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>                 kvm_sched_yield(vcpu->kvm, a0);
>                 ret =3D 0;
>                 break;
> +       case KVM_HC_PAGE_ENC_STATUS:
> +               ret =3D -KVM_ENOSYS;
> +               if (kvm_x86_ops.page_enc_status_hc)
> +                       ret =3D kvm_x86_ops.page_enc_status_hc(vcpu->kvm,
> +                                       a0, a1, a2);
> +               break;
>         default:
>                 ret =3D -KVM_ENOSYS;
>                 break;
> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.=
h
> index 8b86609849b9..847b83b75dc8 100644
> --- a/include/uapi/linux/kvm_para.h
> +++ b/include/uapi/linux/kvm_para.h
> @@ -29,6 +29,7 @@
>  #define KVM_HC_CLOCK_PAIRING           9
>  #define KVM_HC_SEND_IPI                10
>  #define KVM_HC_SCHED_YIELD             11
> +#define KVM_HC_PAGE_ENC_STATUS         12
>
>  /*
>   * hypercalls use architecture specific
> --
> 2.17.1
>


Reviewed-by: Steve Rutherford <srutherford@google.com>
