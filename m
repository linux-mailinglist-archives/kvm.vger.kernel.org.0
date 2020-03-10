Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA41B17ED9C
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 02:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCJBFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 21:05:36 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40752 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgCJBFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 21:05:36 -0400
Received: by mail-lf1-f65.google.com with SMTP id j17so4887582lfe.7
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 18:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ygq4rL6c32b9v1mGIXmpjeyzDhpEGmFslVXH83B3YQI=;
        b=gGjInPXdKZ+GQ+k0bdOIaoJ0g2Zi/WGSTdvmbRGcdW2F0cdc9UoYm8eeTpLoEgR9L9
         4PN/93glZzGJPsOyfvJ5x3vagJ0yF+Rs9g+8SezQ7bwMfgv4zxzgM6FkcJWItNm33dq8
         O8QVTWv5claEBO+Lc1bb5weQ3bhpi3i/dLxsUrZf8E1FtmPhbRSaMXTtxiiZyK3D0Qhz
         udW2aY9fzrx88P4JwvBoe+BbGk3qT9MQRdeU6st0GbuSahNUbvIMxzzZDBkXVmW13CJ+
         RaYb2USVlCFmxB2q8t7KJHNyQ0RocEB+Ua+iv2mhK7lmSffgAAM+3tR0ZtfgSphgV3Tv
         eV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ygq4rL6c32b9v1mGIXmpjeyzDhpEGmFslVXH83B3YQI=;
        b=f8AAmD/8XA6MkftM/97GKiYILHKfqK7QXIxYnrX5CQVwgQttCieory+2o9FCxPxdew
         N2M+FMdEYxTZq9Rwx85wEHic/y3p7r3Eh36u2vnW2rRbi6wLuJv7OrbMUlsk6TGqycr6
         USaz/BEp8MEvL6p3XxT/Q8orasF81ngWihv1pThROXkSormlmrZiWYY6E3+FzI1HEYJd
         wXr4nsM6uI8hUmPpDXdvAblSwGqkD59daSl3k/ycIQQK1t9FB0inTNBwHvxbQcqfBYBY
         JL97Sgp0mshmbfu7XcSXw8jKa3B081fHyqAF75XV7AYh4Qtwin0dYLLaOaNVBjJaXvgi
         VK4Q==
X-Gm-Message-State: ANhLgQ1dFYzxVImeMLG229uWsQ2D5EzWWdZgGzhwgJLXUDmDNfcUwW4L
        /4p3HN7VCSuJ7vRFMSsO6T8Se/35LrjTILQYSERh3Q==
X-Google-Smtp-Source: ADFU+vtHcZhKvzzl5a2j6uSJBS313bp20fEBZQgxPfgMt2/YQwS8EYKnQRaBhZ3RLzo7gLKn4ZkwwECGmj3cQrvkRDI=
X-Received: by 2002:a19:fc1d:: with SMTP id a29mr11058514lfi.209.1583802332298;
 Mon, 09 Mar 2020 18:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com> <b1b4675537fc592a6a78c0ca1888feba0d515557.1581555616.git.ashish.kalra@amd.com>
In-Reply-To: <b1b4675537fc592a6a78c0ca1888feba0d515557.1581555616.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 9 Mar 2020 18:04:56 -0700
Message-ID: <CABayD+cZhCUkEAdCv+qTgvBOzsfDX5Vo8kYATHZDa4PwX_PYiQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 5:15 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The command is used for encrypting the guest memory region using the encr=
yption
> context created with KVM_SEV_SEND_START.
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
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        |  24 ++++
>  arch/x86/kvm/svm.c                            | 136 +++++++++++++++++-
>  include/uapi/linux/kvm.h                      |   9 ++
>  3 files changed, 165 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documenta=
tion/virt/kvm/amd-memory-encryption.rst
> index 826911f41f3b..0f1c3860360f 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -265,6 +265,30 @@ Returns: 0 on success, -negative on error
>                  __u32 session_len;
>          };
>
> +11. KVM_SEV_SEND_UPDATE_DATA
> +----------------------------
> +
> +The KVM_SEV_SEND_UPDATE_DATA command can be used by the hypervisor to en=
crypt the
> +outgoing guest memory region with the encryption context creating using
> +KVM_SEV_SEND_START.
> +
> +Parameters (in): struct kvm_sev_send_update_data
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_launch_send_update_data {
> +                __u64 hdr_uaddr;        /* userspace address containing =
the packet header */
> +                __u32 hdr_len;
> +
> +                __u64 guest_uaddr;      /* the source memory region to b=
e encrypted */
> +                __u32 guest_len;
> +
> +                __u64 trans_uaddr;      /* the destition memory region  =
*/
> +                __u32 trans_len;
> +        };
> +
>  References
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 3a7e2cac51de..ae97f774e979 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -426,6 +426,7 @@ static DECLARE_RWSEM(sev_deactivate_lock);
>  static DEFINE_MUTEX(sev_bitmap_lock);
>  static unsigned int max_sev_asid;
>  static unsigned int min_sev_asid;
> +static unsigned long sev_me_mask;
>  static unsigned long *sev_asid_bitmap;
>  static unsigned long *sev_reclaim_asid_bitmap;
>  #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
> @@ -1231,16 +1232,22 @@ static int avic_ga_log_notifier(u32 ga_tag)
>  static __init int sev_hardware_setup(void)
>  {
>         struct sev_user_data_status *status;
> +       int eax, ebx;
>         int rc;
>
> -       /* Maximum number of encrypted guests supported simultaneously */
> -       max_sev_asid =3D cpuid_ecx(0x8000001F);
> +       /*
> +        * Query the memory encryption information.
> +        *  EBX:  Bit 0:5 Pagetable bit position used to indicate encrypt=
ion
> +        *  (aka Cbit).
> +        *  ECX:  Maximum number of encrypted guests supported simultaneo=
usly.
> +        *  EDX:  Minimum ASID value that should be used for SEV guest.
> +        */
> +       cpuid(0x8000001f, &eax, &ebx, &max_sev_asid, &min_sev_asid);
>
>         if (!max_sev_asid)
>                 return 1;
>
> -       /* Minimum ASID value that should be used for SEV guest */
> -       min_sev_asid =3D cpuid_edx(0x8000001F);
> +       sev_me_mask =3D 1UL << (ebx & 0x3f);
>
>         /* Initialize SEV ASID bitmaps */
>         sev_asid_bitmap =3D bitmap_zalloc(max_sev_asid, GFP_KERNEL);
> @@ -7262,6 +7269,124 @@ static int sev_send_start(struct kvm *kvm, struct=
 kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +/* Userspace wants to query either header or trans length. */
> +static int
> +__sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd=
 *argp,
> +                                    struct kvm_sev_send_update_data *par=
ams)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_send_update_data *data;
> +       int ret;
> +
> +       data =3D kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       data->handle =3D sev->handle;
> +       ret =3D sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp-=
>error);
> +
> +       params->hdr_len =3D data->hdr_len;
> +       params->trans_len =3D data->trans_len;
> +
> +       if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
> +                        sizeof(struct kvm_sev_send_update_data)))
> +               ret =3D -EFAULT;
> +
> +       kfree(data);
> +       return ret;
> +}
> +
> +static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *arg=
p)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_send_update_data *data;
> +       struct kvm_sev_send_update_data params;
> +       void *hdr, *trans_data;
> +       struct page **guest_page;
> +       unsigned long n;
> +       int ret, offset;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +                       sizeof(struct kvm_sev_send_update_data)))
> +               return -EFAULT;
> +
> +       /* userspace wants to query either header or trans length */
> +       if (!params.trans_len || !params.hdr_len)
> +               return __sev_send_update_data_query_lengths(kvm, argp, &p=
arams);
> +
> +       if (!params.trans_uaddr || !params.guest_uaddr ||
> +           !params.guest_len || !params.hdr_uaddr)
> +               return -EINVAL;
> +
> +
> +       /* Check if we are crossing the page boundary */
> +       offset =3D params.guest_uaddr & (PAGE_SIZE - 1);
> +       if ((params.guest_len + offset > PAGE_SIZE))
> +               return -EINVAL;
> +
> +       /* Pin guest memory */
> +       guest_page =3D sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK=
,
> +                                   PAGE_SIZE, &n, 0);
> +       if (!guest_page)
> +               return -EFAULT;
> +
> +       /* allocate memory for header and transport buffer */
> +       ret =3D -ENOMEM;
> +       hdr =3D kmalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
> +       if (!hdr)
> +               goto e_unpin;
> +
> +       trans_data =3D kmalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
> +       if (!trans_data)
> +               goto e_free_hdr;
> +
> +       data =3D kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               goto e_free_trans_data;
> +
> +       data->hdr_address =3D __psp_pa(hdr);
> +       data->hdr_len =3D params.hdr_len;
> +       data->trans_address =3D __psp_pa(trans_data);
> +       data->trans_len =3D params.trans_len;
> +
> +       /* The SEND_UPDATE_DATA command requires C-bit to be always set. =
*/
> +       data->guest_address =3D (page_to_pfn(guest_page[0]) << PAGE_SHIFT=
) +
> +                               offset;
> +       data->guest_address |=3D sev_me_mask;
> +       data->guest_len =3D params.guest_len;
> +       data->handle =3D sev->handle;
> +
> +       ret =3D sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp-=
>error);
> +
> +       if (ret)
> +               goto e_free;
> +
> +       /* copy transport buffer to user space */
> +       if (copy_to_user((void __user *)(uintptr_t)params.trans_uaddr,
> +                        trans_data, params.trans_len)) {
> +               ret =3D -EFAULT;
> +               goto e_unpin;
> +       }
> +
> +       /* Copy packet header to userspace. */
> +       ret =3D copy_to_user((void __user *)(uintptr_t)params.hdr_uaddr, =
hdr,
> +                               params.hdr_len);
> +
> +e_free:
> +       kfree(data);
> +e_free_trans_data:
> +       kfree(trans_data);
> +e_free_hdr:
> +       kfree(hdr);
> +e_unpin:
> +       sev_unpin_memory(kvm, guest_page, n);
> +
> +       return ret;
> +}
> +
>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -7306,6 +7431,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __u=
ser *argp)
>         case KVM_SEV_SEND_START:
>                 r =3D sev_send_start(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_SEND_UPDATE_DATA:
> +               r =3D sev_send_update_data(kvm, &sev_cmd);
> +               break;
>         default:
>                 r =3D -EINVAL;
>                 goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 17bef4c245e1..d9dc81bb9c55 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1570,6 +1570,15 @@ struct kvm_sev_send_start {
>         __u32 session_len;
>  };
>
> +struct kvm_sev_send_update_data {
> +       __u64 hdr_uaddr;
> +       __u32 hdr_len;
> +       __u64 guest_uaddr;
> +       __u32 guest_len;
> +       __u64 trans_uaddr;
> +       __u32 trans_len;
> +};
Input from others is welcome here, but I'd put the padding in
intentionally (explicitly fill in the reserved u8s between *_len and
*_uaddr). I had to double check that this pattern was intentional and
matched the SEV spec.
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
> --
> 2.17.1
>

High level: this looks good. Same comments on documenting the magic
parameters for querying as the prior patch, and also the -EFAULT
behavior.

Thanks,
Steve
