Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413F11A1935
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 02:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgDHA1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 20:27:14 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46681 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgDHA1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 20:27:13 -0400
Received: by mail-lf1-f68.google.com with SMTP id m19so1779633lfq.13
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 17:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KvXrRfKvnvwe6/Q975jfwQjaaqzmgF5y1rvvbUvPnF0=;
        b=tWEIx62WEGqrxHmygwWu2i2+q1JiC7Ga1AmerGZ9qlAhHcS4AR/qfvn5qNNFHvoM6I
         DlzbDi1BtdxRNniiEyKEA5FZaWI79m7x1p5Zy12kp1fSFpLQ3ABGuOAnNI51NZ2SEWKH
         aZwmLAKJkc1x7dBv34uCPR7UoGID6Ji0dbn8il9QtAt4bX6P5QzDsIk9l9b74TNdKLvw
         lndqJU1QQ6l549AGW6Yd2C2mIneu18eXnbYjyKUy/zaw+n/q4PdQu9D+vyqhOE+989t7
         zU6/IKcDw5jAigD69RqvrF7v7md1/KofErobvld3Z2SFvWye6tOcNrCXuh/niNjkx5qt
         IFYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KvXrRfKvnvwe6/Q975jfwQjaaqzmgF5y1rvvbUvPnF0=;
        b=lUcvamubKStsJFGtBH5QOSROEVzeO+WEzfyBJThfhSozajLgQNUI5gxfrZgdxn7qCq
         vShlzCz2j0Moa+lQvlk/chicHZ0dzu+JxxrK+lLcolFp+yGmu6rhy7vFvchQVC69Dd8Q
         ZKn1Ml8dtHKxUj+pijyhwaTse/D4mZJoRxC116tMll6f2d1kvfVbIcgDhWsHvYfc4MvG
         zky7kkhNktKjPk/Q+QuJq4U4hnLk6Inz6Sn4tw7mPcmnrRcUgok9PACW/uI5VNean+uZ
         iv5nvwGh1mvwnQIV9eyOJOJZZd91DIFFl8eehwU7/Gr7GKf1jzX+NsGuh54TDGadzn1Q
         9gmQ==
X-Gm-Message-State: AGi0PubWr+NZ1gbC2evH906R6pyngrRc6sOzvDcvyeMNFziLI4uJlVhC
        Bbst9QiHcf7rhXxQ55DGKbPJkLQmZG2O73SsjATnqg==
X-Google-Smtp-Source: APiQypKWLd2KVSRVzTdAksij6Twzu4cvvIL0kzstWs1Yx1ZedUNON8pUXbAm2ZG2xjBBJVYkmlDUttiRg6pmMibt1ZQ=
X-Received: by 2002:ac2:515d:: with SMTP id q29mr2898887lfd.210.1586305629755;
 Tue, 07 Apr 2020 17:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585548051.git.ashish.kalra@amd.com> <4d4fbe2b9acda82c04834682900acf782182ec23.1585548051.git.ashish.kalra@amd.com>
In-Reply-To: <4d4fbe2b9acda82c04834682900acf782182ec23.1585548051.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Tue, 7 Apr 2020 17:26:33 -0700
Message-ID: <CABayD+eOCpTGjvxwhtP85j98BKvCxtG8QDBYSC0E08GnaA12jw@mail.gmail.com>
Subject: Re: [PATCH v6 11/14] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
To:     Ashish Kalra <Ashish.Kalra@amd.com>
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

On Sun, Mar 29, 2020 at 11:23 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
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
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  Documentation/virt/kvm/api.rst  | 22 +++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/svm.c              | 42 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c              | 12 ++++++++++
>  include/uapi/linux/kvm.h        |  1 +
>  5 files changed, 79 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 8ad800ebb54f..4d1004a154f6 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4675,6 +4675,28 @@ or shared. The bitmap can be used during the guest=
 migration, if the page
>  is private then userspace need to use SEV migration commands to transmit
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
>  5. The kvm_run structure
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 27e43e3ec9d8..d30f770aaaea 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1271,6 +1271,8 @@ struct kvm_x86_ops {
>                                   unsigned long sz, unsigned long mode);
>         int (*get_page_enc_bitmap)(struct kvm *kvm,
>                                 struct kvm_page_enc_bitmap *bmap);
> +       int (*set_page_enc_bitmap)(struct kvm *kvm,
> +                               struct kvm_page_enc_bitmap *bmap);
>  };
>
>  struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index bae783cd396a..313343a43045 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7756,6 +7756,47 @@ static int svm_get_page_enc_bitmap(struct kvm *kvm=
,
>         return ret;
>  }
>
> +static int svm_set_page_enc_bitmap(struct kvm *kvm,
> +                                  struct kvm_page_enc_bitmap *bmap)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       unsigned long gfn_start, gfn_end;
> +       unsigned long *bitmap;
> +       unsigned long sz, i;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
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
I realize now that usermode could use this for initializing the
minimum size of the enc bitmap, which probably solves my issue from
the other thread.
> +       if (ret)
> +               goto unlock;
> +
> +       i =3D gfn_start;
> +       for_each_clear_bit_from(i, bitmap, (gfn_end - gfn_start))
> +               clear_bit(i + gfn_start, sev->page_enc_bmap);
This API seems a bit strange, since it can only clear bits. I would
expect "set" to force the values to match the values passed down,
instead of only ensuring that cleared bits in the input are also
cleared in the kernel.

This should copy the values from userspace (and fix up the ends since
byte alignment makes that complicated), instead of iterating in this
way.
> +
> +       ret =3D 0;
> +unlock:
> +       mutex_unlock(&kvm->lock);
> +out:
> +       kfree(bitmap);
> +       return ret;
> +}
> +
>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -8161,6 +8202,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_in=
it =3D {
>
>         .page_enc_status_hc =3D svm_page_enc_status_hc,
>         .get_page_enc_bitmap =3D svm_get_page_enc_bitmap,
> +       .set_page_enc_bitmap =3D svm_set_page_enc_bitmap,
>  };
>
>  static int __init svm_init(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3c3fea4e20b5..05e953b2ec61 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5238,6 +5238,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
>                         r =3D kvm_x86_ops->get_page_enc_bitmap(kvm, &bitm=
ap);
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
> +               if (kvm_x86_ops->set_page_enc_bitmap)
> +                       r =3D kvm_x86_ops->set_page_enc_bitmap(kvm, &bitm=
ap);
> +               break;
> +       }
>         default:
>                 r =3D -ENOTTY;
>         }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index db1ebf85e177..b4b01d47e568 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1489,6 +1489,7 @@ struct kvm_enc_region {
>  #define KVM_S390_CLEAR_RESET   _IO(KVMIO,   0xc4)
>
>  #define KVM_GET_PAGE_ENC_BITMAP        _IOW(KVMIO, 0xc5, struct kvm_page=
_enc_bitmap)
> +#define KVM_SET_PAGE_ENC_BITMAP        _IOW(KVMIO, 0xc6, struct kvm_page=
_enc_bitmap)
>
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
> --
> 2.17.1
>
