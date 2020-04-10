Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817881A3D8E
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 03:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgDJBAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 21:00:35 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32943 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgDJBAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 21:00:35 -0400
Received: by mail-lj1-f195.google.com with SMTP id q22so517410ljg.0
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 18:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7OF1/RtZnvHG7fjsmFZKYQ1XTK/PfLFyNRQtwOREqz8=;
        b=iJ9HZHWos0/K/rbVP52EKhmPj4qxEffZ6KSNyZf3j2KX6tgMniZriGutgl/9kOqvzS
         SukIktvoRba9+PafLUaL/zmfJZYjZYcwAnqgnCalk3PH0dgdmKWJwCFuUr+X9hDvNkbx
         Jr8Oykcu/pQ2axU08JUi2ZRCVL+/vTjTJ5H+rbuhsw1PtK3MS4Qx5/DgILhVHYl94rhy
         w6Duz8R93kZM5VF2/5aAF6b20HFdn8Jkr70YBqJXe5FAUDIcsKeQGsi0rRnzbmX7h2aH
         5Qq4/t1DGHii+V+H4PTNp92B92L2KheblidrEUxTb3xnMfVpfW2vCCVqan/ZZ+8irvYn
         IdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7OF1/RtZnvHG7fjsmFZKYQ1XTK/PfLFyNRQtwOREqz8=;
        b=MU2Rsv45wH+RIEMeelExSojT+8KVwEos1mdNzSB+PYGUpSyQ5DSY+3SSlZIYP1TAT3
         jCKjxruI2gjReLOgwqJ9ExZ2X+PAqnRYE0YfzzJA1OOCaR7ZBK43+PGMOW+/7CWxZCcV
         xxYnQmzGvZuGzH0zcOfjfP8r2D1XyNFAWVos7rCkld/uU6MHDMaSYASv+TcH1MVGAz1h
         ESzFi8EwLmAy1+7o3wgpViczzrLR4ITyUkr3cdCYkKo9uHOlEEV3eu9DhHKxqaU/nNKU
         CI6/stvRBI01Hf3ZwxQMys1T13rutf1ZiZYjbv5+FucNDr7OirHy9Xe3MO3X8uW0z/tV
         oIHQ==
X-Gm-Message-State: AGi0PuZppXrjkawdTzhVMTd6AKAKD1x2Y+AhpA5D3RtCpfOyWmZI8WHu
        0sVLBRXMoZmtZZmySLF5Xs7w01xYZ9D7erirtekdYg==
X-Google-Smtp-Source: APiQypJDGQROu4yduzNDT5PSWGh1O7kN/FxUlKUVhkYUYmYVIOf5TTtWfhS3Sw1BwQkJtTQdhZejEWyjzJLJ3BlCx0w=
X-Received: by 2002:a2e:9bc9:: with SMTP id w9mr1068395ljj.213.1586480432815;
 Thu, 09 Apr 2020 18:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585548051.git.ashish.kalra@amd.com> <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
 <b77a4a1e-b8ca-57a2-d849-adda91bfeac7@oracle.com> <20200403214559.GB28747@ashkalra_ubuntu_server>
 <65c09963-2027-22c1-e04d-4c8c3658b2c3@oracle.com> <CABayD+cf=Po-k7jqUQjq3AGopxk86d6bTcBhQxijnzpcUh90GA@mail.gmail.com>
 <20200408015221.GB27608@ashkalra_ubuntu_server>
In-Reply-To: <20200408015221.GB27608@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 9 Apr 2020 17:59:56 -0700
Message-ID: <CABayD+f0qdS5akac8JiB_HU_pWefHDsF=xRNhzSv42w-PTXnyg@mail.gmail.com>
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 7, 2020 at 6:52 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> Hello Steve,
>
> On Tue, Apr 07, 2020 at 06:25:51PM -0700, Steve Rutherford wrote:
> > On Mon, Apr 6, 2020 at 11:53 AM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> > >
> > >
> > > On 4/3/20 2:45 PM, Ashish Kalra wrote:
> > > > On Fri, Apr 03, 2020 at 02:14:23PM -0700, Krish Sadhukhan wrote:
> > > >> On 3/29/20 11:23 PM, Ashish Kalra wrote:
> > > >>> From: Ashish Kalra <ashish.kalra@amd.com>
> > > >>>
> > > >>> This ioctl can be used by the application to reset the page
> > > >>> encryption bitmap managed by the KVM driver. A typical usage
> > > >>> for this ioctl is on VM reboot, on reboot, we must reinitialize
> > > >>> the bitmap.
> > > >>>
> > > >>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > >>> ---
> > > >>>    Documentation/virt/kvm/api.rst  | 13 +++++++++++++
> > > >>>    arch/x86/include/asm/kvm_host.h |  1 +
> > > >>>    arch/x86/kvm/svm.c              | 16 ++++++++++++++++
> > > >>>    arch/x86/kvm/x86.c              |  6 ++++++
> > > >>>    include/uapi/linux/kvm.h        |  1 +
> > > >>>    5 files changed, 37 insertions(+)
> > > >>>
> > > >>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > >>> index 4d1004a154f6..a11326ccc51d 100644
> > > >>> --- a/Documentation/virt/kvm/api.rst
> > > >>> +++ b/Documentation/virt/kvm/api.rst
> > > >>> @@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
> > > >>>    bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
> > > >>>    bitmap for an incoming guest.
> > > >>> +4.127 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
> > > >>> +-----------------------------------------
> > > >>> +
> > > >>> +:Capability: basic
> > > >>> +:Architectures: x86
> > > >>> +:Type: vm ioctl
> > > >>> +:Parameters: none
> > > >>> +:Returns: 0 on success, -1 on error
> > > >>> +
> > > >>> +The KVM_PAGE_ENC_BITMAP_RESET is used to reset the guest's page encryption
> > > >>> +bitmap during guest reboot and this is only done on the guest's boot vCPU.
> > > >>> +
> > > >>> +
> > > >>>    5. The kvm_run structure
> > > >>>    ========================
> > > >>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > >>> index d30f770aaaea..a96ef6338cd2 100644
> > > >>> --- a/arch/x86/include/asm/kvm_host.h
> > > >>> +++ b/arch/x86/include/asm/kvm_host.h
> > > >>> @@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
> > > >>>                             struct kvm_page_enc_bitmap *bmap);
> > > >>>     int (*set_page_enc_bitmap)(struct kvm *kvm,
> > > >>>                             struct kvm_page_enc_bitmap *bmap);
> > > >>> +   int (*reset_page_enc_bitmap)(struct kvm *kvm);
> > > >>>    };
> > > >>>    struct kvm_arch_async_pf {
> > > >>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > >>> index 313343a43045..c99b0207a443 100644
> > > >>> --- a/arch/x86/kvm/svm.c
> > > >>> +++ b/arch/x86/kvm/svm.c
> > > >>> @@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
> > > >>>     return ret;
> > > >>>    }
> > > >>> +static int svm_reset_page_enc_bitmap(struct kvm *kvm)
> > > >>> +{
> > > >>> +   struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > >>> +
> > > >>> +   if (!sev_guest(kvm))
> > > >>> +           return -ENOTTY;
> > > >>> +
> > > >>> +   mutex_lock(&kvm->lock);
> > > >>> +   /* by default all pages should be marked encrypted */
> > > >>> +   if (sev->page_enc_bmap_size)
> > > >>> +           bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
> > > >>> +   mutex_unlock(&kvm->lock);
> > > >>> +   return 0;
> > > >>> +}
> > > >>> +
> > > >>>    static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > > >>>    {
> > > >>>     struct kvm_sev_cmd sev_cmd;
> > > >>> @@ -8203,6 +8218,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> > > >>>     .page_enc_status_hc = svm_page_enc_status_hc,
> > > >>>     .get_page_enc_bitmap = svm_get_page_enc_bitmap,
> > > >>>     .set_page_enc_bitmap = svm_set_page_enc_bitmap,
> > > >>> +   .reset_page_enc_bitmap = svm_reset_page_enc_bitmap,
> > > >>
> > > >> We don't need to initialize the intel ops to NULL ? It's not initialized in
> > > >> the previous patch either.
> > > >>
> > > >>>    };
> > > > This struct is declared as "static storage", so won't the non-initialized
> > > > members be 0 ?
> > >
> > >
> > > Correct. Although, I see that 'nested_enable_evmcs' is explicitly
> > > initialized. We should maintain the convention, perhaps.
> > >
> > > >
> > > >>>    static int __init svm_init(void)
> > > >>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > >>> index 05e953b2ec61..2127ed937f53 100644
> > > >>> --- a/arch/x86/kvm/x86.c
> > > >>> +++ b/arch/x86/kvm/x86.c
> > > >>> @@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
> > > >>>                     r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
> > > >>>             break;
> > > >>>     }
> > > >>> +   case KVM_PAGE_ENC_BITMAP_RESET: {
> > > >>> +           r = -ENOTTY;
> > > >>> +           if (kvm_x86_ops->reset_page_enc_bitmap)
> > > >>> +                   r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
> > > >>> +           break;
> > > >>> +   }
> > > >>>     default:
> > > >>>             r = -ENOTTY;
> > > >>>     }
> > > >>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > >>> index b4b01d47e568..0884a581fc37 100644
> > > >>> --- a/include/uapi/linux/kvm.h
> > > >>> +++ b/include/uapi/linux/kvm.h
> > > >>> @@ -1490,6 +1490,7 @@ struct kvm_enc_region {
> > > >>>    #define KVM_GET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
> > > >>>    #define KVM_SET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
> > > >>> +#define KVM_PAGE_ENC_BITMAP_RESET  _IO(KVMIO, 0xc7)
> > > >>>    /* Secure Encrypted Virtualization command */
> > > >>>    enum sev_cmd_id {
> > > >> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >
> >
> > Doesn't this overlap with the set ioctl? Yes, obviously, you have to
> > copy the new value down and do a bit more work, but I don't think
> > resetting the bitmap is going to be the bottleneck on reboot. Seems
> > excessive to add another ioctl for this.
>
> The set ioctl is generally available/provided for the incoming VM to setup
> the page encryption bitmap, this reset ioctl is meant for the source VM
> as a simple interface to reset the whole page encryption bitmap.
>
> Thanks,
> Ashish


Hey Ashish,

These seem very overlapping. I think this API should be refactored a bit.

1) Use kvm_vm_ioctl_enable_cap to control whether or not this
hypercall (and related feature bit) is offered to the VM, and also the
size of the buffer.
2) Use set for manipulating values in the bitmap, including resetting
the bitmap. Set the bitmap pointer to null if you want to reset to all
0xFFs. When the bitmap pointer is set, it should set the values to
exactly what is pointed at, instead of only clearing bits, as is done
currently.
3) Use get for fetching values from the kernel. Personally, I'd
require alignment of the base GFN to a multiple of 8 (but the number
of pages could be whatever), so you can just use a memcpy. Optionally,
you may want some way to tell userspace the size of the existing
buffer, so it can ensure that it can ask for the entire buffer without
having to track the size in usermode (not strictly necessary, but nice
to have since it ensures that there is only one place that has to
manage this value).

If you want to expand or contract the bitmap, you can use enable cap
to adjust the size.
If you don't want to offer the hypercall to the guest, don't call the
enable cap.
This API avoids using up another ioctl. Ioctl space is somewhat
scarce. It also gives userspace fine grained control over the buffer,
so it can support both hot-plug and hot-unplug (or at the very least
it is not obviously incompatible with those). It also gives userspace
control over whether or not the feature is offered. The hypercall
isn't free, and being able to tell guests to not call when the host
wasn't going to migrate it anyway will be useful.

Thanks,
--Steve
