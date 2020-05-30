Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB6B1E8D0B
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgE3CGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgE3CGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:06:35 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1F0C08C5C9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:06:35 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d5so1362462ios.9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2e8MiG6AUYZrBX4tJToC0escpzIr0EOlGFV1C0ZSabw=;
        b=Gt7mIjttLrlT1SgQPaE6+yvum0nNTUxMy7xacAA9Mk5WHH0i/znthcEY/Zxg6XEwiT
         Qf5GKzQR/AfWvq24PZBBY8a10WeXLmsTK5HD9CZLT1rHK0UnkTyoRNK+WmHy56LM6Yt8
         1d71OWQQ76HUzCcDZpI8+KXv+1Ab1gpii2r0MP0A+D+cjOZBmJtMOTEi9Ajqt+383U9I
         2h1QZr1x9SU47KxPL2kbeDnEAUJBe2UyBFJQtqJuerXoVDKNer8p1W6AwV6xhMhaj2i1
         FmgU76TMn5Rg/NpWA7aTydE9J9o0YdgYpXNDdPGW3VcnQ6SIfAFVJ5LIavB2fbqNnrA5
         VxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2e8MiG6AUYZrBX4tJToC0escpzIr0EOlGFV1C0ZSabw=;
        b=jPqZgMp00dDAMe+Ts1ZdDA0xdInDPfGxDA/IiHDELspICUX8RzQMT4Xtnopql47QmZ
         VQjWPcTgVLh05mCsukBkn2hkqUyWb2qHA1DUFEB2thD9fuEa4x+9+eRf2Qu0BrUov4gw
         iCmItjb+XFOqE4esPWjrgDMbvNOIMJVcfMUve8cOwFXgbfjYteWAE9z7DH57Y3ikPqEo
         zk1zsyinV+caFDuOYEcswjxBCh3n1MGYaohkHp4CyQVYEXLETSkpi39cz+VsO+UB2SBn
         agUK3txSJ5R+QAmc9kjxQyXsvBeAc6vVfzQofPFcm9JNVsnF02/rYkdXctC88+ee0jhp
         HtEQ==
X-Gm-Message-State: AOAM530u2NaSijW/4pT/CmsRon5uSEm0ON6AFlgejnIgDQh5zpRfLi+9
        gipprrgs7kLT7A9eRbph+hCnRvmsCxiNgiyG+TMRvw==
X-Google-Smtp-Source: ABdhPJyoQ4UFJh365PpqOXnlPA8KrQQeqd7/RuxHPv1LboLYrl3tJkdr0enzL85Es8tJihKs+eLjjeEhx2ARvfAXISw=
X-Received: by 2002:a5d:9e51:: with SMTP id i17mr8765989ioi.8.1590804394104;
 Fri, 29 May 2020 19:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <d4680b02ff88b2687cbb807afd8eb47784dd3a33.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <d4680b02ff88b2687cbb807afd8eb47784dd3a33.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:05:57 -0700
Message-ID: <CABayD+enZfQjEvJ6ysmVkkN8G=Cu64YaWCr27=U+FpJ-jfWz2A@mail.gmail.com>
Subject: Re: [PATCH v8 09/18] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
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
> The ioctl can be used to retrieve page encryption bitmap for a given
> gfn range.
>
> Return the correct bitmap as per the number of pages being requested
> by the user. Ensure that we only copy bmap->num_pages bytes in the
> userspace buffer, if bmap->num_pages is not byte aligned we read
> the trailing bits from the userspace and copy those bits as is.
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
>  Documentation/virt/kvm/api.rst  | 27 +++++++++++++
>  arch/x86/include/asm/kvm_host.h |  2 +
>  arch/x86/kvm/svm/sev.c          | 70 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          |  1 +
>  arch/x86/kvm/svm/svm.h          |  1 +
>  arch/x86/kvm/x86.c              | 12 ++++++
>  include/uapi/linux/kvm.h        | 12 ++++++
>  7 files changed, 125 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index efbbe570aa9b..ecad84086892 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4636,6 +4636,33 @@ This ioctl resets VCPU registers and control struc=
tures according to
>  the clear cpu reset definition in the POP. However, the cpu is not put
>  into ESA mode. This reset is a superset of the initial reset.
>
> +4.125 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
> +---------------------------------------
> +
> +:Capability: basic
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_page_enc_bitmap (in/out)
> +:Returns: 0 on success, -1 on error
> +
> +/* for KVM_GET_PAGE_ENC_BITMAP */
> +struct kvm_page_enc_bitmap {
> +       __u64 start_gfn;
> +       __u64 num_pages;
> +       union {
> +               void __user *enc_bitmap; /* one bit per page */
> +               __u64 padding2;
> +       };
> +};
> +
> +The encrypted VMs have the concept of private and shared pages. The priv=
ate
> +pages are encrypted with the guest-specific key, while the shared pages =
may
> +be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
> +be used to get the bitmap indicating whether the guest page is private
> +or shared. The bitmap can be used during the guest migration. If the pag=
e
> +is private then the userspace need to use SEV migration commands to tran=
smit
> +the page.
> +
>
>  4.125 KVM_S390_PV_COMMAND
>  -------------------------
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 4a8ee22f4f5b..9e428befb6a4 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1256,6 +1256,8 @@ struct kvm_x86_ops {
>         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
>         int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
>                                   unsigned long sz, unsigned long mode);
> +       int (*get_page_enc_bitmap)(struct kvm *kvm,
> +                               struct kvm_page_enc_bitmap *bmap);
>  };
>
>  struct kvm_x86_init_ops {
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f088467708f0..387045902470 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1434,6 +1434,76 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsign=
ed long gpa,
>         return 0;
>  }
>
> +int svm_get_page_enc_bitmap(struct kvm *kvm,
> +                                  struct kvm_page_enc_bitmap *bmap)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       unsigned long gfn_start, gfn_end;
> +       unsigned long sz, i, sz_bytes;
> +       unsigned long *bitmap;
> +       int ret, n;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +
> +       gfn_start =3D bmap->start_gfn;
> +       gfn_end =3D gfn_start + bmap->num_pages;
> +
> +       sz =3D ALIGN(bmap->num_pages, BITS_PER_LONG) / BITS_PER_BYTE;
> +       bitmap =3D kmalloc(sz, GFP_KERNEL);
> +       if (!bitmap)
> +               return -ENOMEM;
> +
> +       /* by default all pages are marked encrypted */
> +       memset(bitmap, 0xff, sz);
> +
> +       mutex_lock(&kvm->lock);
> +       if (sev->page_enc_bmap) {
> +               i =3D gfn_start;
> +               for_each_clear_bit_from(i, sev->page_enc_bmap,
> +                                     min(sev->page_enc_bmap_size, gfn_en=
d))
gfn_end is not a size? I believe you want either gfn_end - gfn_start
or bmap->num_pages.

> +                       clear_bit(i - gfn_start, bitmap);
> +       }
> +       mutex_unlock(&kvm->lock);
> +
> +       ret =3D -EFAULT;
> +
> +       n =3D bmap->num_pages % BITS_PER_BYTE;
> +       sz_bytes =3D ALIGN(bmap->num_pages, BITS_PER_BYTE) / BITS_PER_BYT=
E;
> +
> +       /*
> +        * Return the correct bitmap as per the number of pages being
> +        * requested by the user. Ensure that we only copy bmap->num_page=
s
> +        * bytes in the userspace buffer, if bmap->num_pages is not byte
> +        * aligned we read the trailing bits from the userspace and copy
Nit: "userspace" instead of "the userspace".



> +        * those bits as is.
> +        */
> +
> +       if (n) {
> +               unsigned char *bitmap_kernel =3D (unsigned char *)bitmap;
> +               unsigned char bitmap_user;
> +               unsigned long offset, mask;
> +
> +               offset =3D bmap->num_pages / BITS_PER_BYTE;
> +               if (copy_from_user(&bitmap_user, bmap->enc_bitmap + offse=
t,
> +                               sizeof(unsigned char)))
> +                       goto out;
> +
> +               mask =3D GENMASK(n - 1, 0);
> +               bitmap_user &=3D ~mask;
> +               bitmap_kernel[offset] &=3D mask;
> +               bitmap_kernel[offset] |=3D bitmap_user;
> +       }
> +
> +       if (copy_to_user(bmap->enc_bitmap, bitmap, sz_bytes))
> +               goto out;
> +
> +       ret =3D 0;
> +out:
> +       kfree(bitmap);
> +       return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1013ef0f4ce2..588709a9f68e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4016,6 +4016,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>         .check_nested_events =3D svm_check_nested_events,
>
>         .page_enc_status_hc =3D svm_page_enc_status_hc,
> +       .get_page_enc_bitmap =3D svm_get_page_enc_bitmap,
>  };
>
>  static struct kvm_x86_init_ops svm_init_ops __initdata =3D {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6a562f5928a2..f087fa7b380c 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -404,6 +404,7 @@ int svm_check_nested_events(struct kvm_vcpu *vcpu);
>  int nested_svm_exit_special(struct vcpu_svm *svm);
>  int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>                                   unsigned long npages, unsigned long enc=
);
> +int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap =
*bmap);
>
>  /* avic.c */
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5f5ddb5765e2..937797cfaf9a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5208,6 +5208,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
>         case KVM_SET_PMU_EVENT_FILTER:
>                 r =3D kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
>                 break;
> +       case KVM_GET_PAGE_ENC_BITMAP: {
> +               struct kvm_page_enc_bitmap bitmap;
> +
> +               r =3D -EFAULT;
> +               if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> +                       goto out;
> +
> +               r =3D -ENOTTY;
> +               if (kvm_x86_ops.get_page_enc_bitmap)
> +                       r =3D kvm_x86_ops.get_page_enc_bitmap(kvm, &bitma=
p);
> +               break;
> +       }
>         default:
>                 r =3D -ENOTTY;
>         }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 0fe1d206d750..af62f2afaa5d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -505,6 +505,16 @@ struct kvm_dirty_log {
>         };
>  };
>
> +/* for KVM_GET_PAGE_ENC_BITMAP */
> +struct kvm_page_enc_bitmap {
> +       __u64 start_gfn;
> +       __u64 num_pages;
> +       union {
> +               void __user *enc_bitmap; /* one bit per page */
> +               __u64 padding2;
> +       };
> +};
> +
>  /* for KVM_CLEAR_DIRTY_LOG */
>  struct kvm_clear_dirty_log {
>         __u32 slot;
> @@ -1518,6 +1528,8 @@ struct kvm_pv_cmd {
>  /* Available with KVM_CAP_S390_PROTECTED */
>  #define KVM_S390_PV_COMMAND            _IOWR(KVMIO, 0xc5, struct kvm_pv_=
cmd)
>
> +#define KVM_GET_PAGE_ENC_BITMAP        _IOW(KVMIO, 0xc6, struct kvm_page=
_enc_bitmap)
> +
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>         /* Guest initialization commands */
> --
> 2.17.1
>
