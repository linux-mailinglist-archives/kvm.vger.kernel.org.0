Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0311E8D0E
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgE3CHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728349AbgE3CHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:07:22 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368A4C08C5C9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:07:22 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d5so1363419ios.9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TVnMDfsuqP6GtyvPhUxVptDusSYgxx3CkOe/VJIieC4=;
        b=vOUfu9NDO+nxa7v1u4nhx4LqpEp1xVg7Ch9WAxYtk5dHR/WXu7UVpodudmJbCOdMK8
         psGuavrCQqspLEC6YzB9Cg7+aqDn+S0GkdPubbPUh1QHixWmpAkH250RRTyfa8jQmD3a
         9p8P6OGYFzjNJq4+CbbKUgm+ieX0bQIeb82uWfep59AbSe0Fc7p7fkTWNArYp66wM5If
         ot67UatT4xd2rZWxmL4BLgerT21ZXf1qraxn05FQRPRlGfLQFOhpPq2xxNSkAiSV0IdR
         oHghnVgNXyBWwlaxgyXIqxF8tezghixua6VQELrUAhNYbfFSWFOXGnePM6Y9GQbZ/7JK
         PL9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TVnMDfsuqP6GtyvPhUxVptDusSYgxx3CkOe/VJIieC4=;
        b=dAetkjeS2YZB6yrdQibxmkgRyQShmRcH3Gkn55AQzBKvezdFBfs4arDRz7iL632vyu
         TFCKWBt88aI9csupMFhfrZ6D1w5w20G5TcJQF9RHvGWZtvivBW1MUoCWLE5gkdJElBJt
         WmjBhPPHNHzdtFJr26tLg/row6K3Ek2+KsKWAxPz2mwe+rQ+Wukn6nDwsJ//LxHz15Vl
         vm2eMVOYOiemFbmydfIRExiKcdchxZUqL3vU2qGoaBA4wIwwl6BMnCuvd60bsD2SgOJK
         TNnZ6ncRI76TSd8JDzMD44AepKhjEw7FScI4lLXQf05RqhoGTFuSz72UqPdu+7yAV1U/
         OC4A==
X-Gm-Message-State: AOAM53036aheDBDk9bO4O+Dr+w1uQneAUQQ0BjIHL76OhkXog6BHqUg4
        8L5tcOycUUXYDzWj0F80shBHv8P9WW4/I2yIelI3fg==
X-Google-Smtp-Source: ABdhPJyNNkpim2SxUsqWPeYvznrtm5bScRIr8Vx6cephH+v+l9U5qX7clOCLV+5N87ZOPAQD/ZzA72YqXyaSLEwA76I=
X-Received: by 2002:a6b:e311:: with SMTP id u17mr9067459ioc.51.1590804441038;
 Fri, 29 May 2020 19:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <eeacea5ff4c2c5ba16a14dfdb86869dc5b17520a.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <eeacea5ff4c2c5ba16a14dfdb86869dc5b17520a.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:06:45 -0700
Message-ID: <CABayD+c_jna3GjP_n2cMNEmWtREvZ_M8R9tY9GjQddTEE01T8Q@mail.gmail.com>
Subject: Re: [PATCH v8 11/18] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
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

On Tue, May 5, 2020 at 2:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> The ioctl can be used to set page encryption bitmap for an
> incoming guest.
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
>  Documentation/virt/kvm/api.rst  | 44 +++++++++++++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/svm/sev.c          | 50 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          |  1 +
>  arch/x86/kvm/svm/svm.h          |  1 +
>  arch/x86/kvm/x86.c              | 12 ++++++++
>  include/uapi/linux/kvm.h        |  1 +
>  7 files changed, 111 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index ecad84086892..fa70017ee693 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4663,6 +4663,28 @@ or shared. The bitmap can be used during the guest=
 migration. If the page
>  is private then the userspace need to use SEV migration commands to tran=
smit
>  the page.
>
> +4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
> +---------------------------------------
> +
> +:Capability: basic
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_page_enc_bitmap (in/out)
> +:Returns: 0 on success, -1 on error
> +
> +/* for KVM_SET_PAGE_ENC_BITMAP */
> +struct kvm_page_enc_bitmap {
> +       __u64 start_gfn;
> +       __u64 num_pages;
> +       union {
> +               void __user *enc_bitmap; /* one bit per page */
> +               __u64 padding2;
> +       };
> +};
> +
> +During the guest live migration the outgoing guest exports its page encr=
yption
> +bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryp=
tion
> +bitmap for an incoming guest.
>
>  4.125 KVM_S390_PV_COMMAND
>  -------------------------
> @@ -4717,6 +4739,28 @@ KVM_PV_VM_VERIFY
>    Verify the integrity of the unpacked image. Only if this succeeds,
>    KVM is allowed to start protected VCPUs.
>
> +4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
> +---------------------------------------
> +
> +:Capability: basic
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_page_enc_bitmap (in/out)
> +:Returns: 0 on success, -1 on error
> +
> +/* for KVM_SET_PAGE_ENC_BITMAP */
> +struct kvm_page_enc_bitmap {
> +       __u64 start_gfn;
> +       __u64 num_pages;
> +       union {
> +               void __user *enc_bitmap; /* one bit per page */
> +               __u64 padding2;
> +       };
> +};
> +
> +During the guest live migration the outgoing guest exports its page encr=
yption
> +bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryp=
tion
> +bitmap for an incoming guest.
>
>  5. The kvm_run structure
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 9e428befb6a4..fc74144d5ab0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1258,6 +1258,8 @@ struct kvm_x86_ops {
>                                   unsigned long sz, unsigned long mode);
>         int (*get_page_enc_bitmap)(struct kvm *kvm,
>                                 struct kvm_page_enc_bitmap *bmap);
> +       int (*set_page_enc_bitmap)(struct kvm *kvm,
> +                               struct kvm_page_enc_bitmap *bmap);
>  };
>
>  struct kvm_x86_init_ops {
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 387045902470..30efc1068707 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1504,6 +1504,56 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
>         return ret;
>  }
>
> +int svm_set_page_enc_bitmap(struct kvm *kvm,
> +                                  struct kvm_page_enc_bitmap *bmap)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       unsigned long gfn_start, gfn_end;
> +       unsigned long *bitmap;
> +       unsigned long sz;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +       /* special case of resetting the complete bitmap */
> +       if (!bmap->enc_bitmap) {
> +               mutex_lock(&kvm->lock);
> +               /* by default all pages are marked encrypted */
> +               if (sev->page_enc_bmap_size)
> +                       bitmap_fill(sev->page_enc_bmap,
> +                                   sev->page_enc_bmap_size);
> +               mutex_unlock(&kvm->lock);
> +               return 0;
> +       }
>
> +
> +       gfn_start =3D bmap->start_gfn;
> +       gfn_end =3D gfn_start + bmap->num_pages;
> +
> +       sz =3D ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
> +       bitmap =3D kmalloc(sz, GFP_KERNEL);
> +       if (!bitmap)
> +               return -ENOMEM;
> +
> +       ret =3D -EFAULT;
> +       if (copy_from_user(bitmap, bmap->enc_bitmap, sz))
> +               goto out;
> +
> +       mutex_lock(&kvm->lock);
> +       ret =3D sev_resize_page_enc_bitmap(kvm, gfn_end);
> +       if (ret)
> +               goto unlock;
> +
> +       bitmap_copy(sev->page_enc_bmap + BIT_WORD(gfn_start), bitmap,
> +                   (gfn_end - gfn_start));

I *think* this assumes that gfn_start is a multiple of 8. I'm not
certain I have a clean suggestion for fixing this, other than
advertising that this is an expectation, and returning an error if
that is not true.

If I'm reading bitmap_copy correctly, I also think it assumes all
bitmaps have lengths that are unsigned long aligned, which surprised
me.
>
> +
> +       ret =3D 0;
> +unlock:
> +       mutex_unlock(&kvm->lock);
> +out:
> +       kfree(bitmap);
> +       return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 588709a9f68e..501e82f5593c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4017,6 +4017,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>
>         .page_enc_status_hc =3D svm_page_enc_status_hc,
>         .get_page_enc_bitmap =3D svm_get_page_enc_bitmap,
> +       .set_page_enc_bitmap =3D svm_set_page_enc_bitmap,
>  };
>
>  static struct kvm_x86_init_ops svm_init_ops __initdata =3D {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index f087fa7b380c..2ebdcce50312 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -405,6 +405,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm);
>  int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>                                   unsigned long npages, unsigned long enc=
);
>  int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap =
*bmap);
> +int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap =
*bmap);
>
>  /* avic.c */
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 937797cfaf9a..c4166d7a0493 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5220,6 +5220,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
>                         r =3D kvm_x86_ops.get_page_enc_bitmap(kvm, &bitma=
p);
>                 break;
>         }
> +       case KVM_SET_PAGE_ENC_BITMAP: {
> +               struct kvm_page_enc_bitmap bitmap;
> +
> +               r =3D -EFAULT;
> +               if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> +                       goto out;
> +
> +               r =3D -ENOTTY;
> +               if (kvm_x86_ops.set_page_enc_bitmap)
> +                       r =3D kvm_x86_ops.set_page_enc_bitmap(kvm, &bitma=
p);
> +               break;
> +       }
>         default:
>                 r =3D -ENOTTY;
>         }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index af62f2afaa5d..2798b17484d0 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1529,6 +1529,7 @@ struct kvm_pv_cmd {
>  #define KVM_S390_PV_COMMAND            _IOWR(KVMIO, 0xc5, struct kvm_pv_=
cmd)
>
>  #define KVM_GET_PAGE_ENC_BITMAP        _IOW(KVMIO, 0xc6, struct kvm_page=
_enc_bitmap)
> +#define KVM_SET_PAGE_ENC_BITMAP        _IOW(KVMIO, 0xc7, struct kvm_page=
_enc_bitmap)
>
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
> --
> 2.17.1
>

Otherwise, this looks good to me. Thanks for merging the ioctls together.

Reviewed-by: Steve Rutherford <srutherford@google.com>
