Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6D81A4AF7
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 22:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgDJUQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 16:16:57 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46733 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgDJUQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 16:16:56 -0400
Received: by mail-lj1-f196.google.com with SMTP id r7so3033565ljg.13
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 13:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x9Kpgt3EBimCtrMxDgE/VNpUSewWOwwq2TyjR8XF3ho=;
        b=RUsbB4ZIyDvYRo3XjWCO5vk7bbk2ieV/+hxBNvEYe68nW90lW/2Sd47nMVWj+P/CZy
         mzWiSo9rz8P9YKKRnLr0fv4guJZR9LBIiWDWUjt4MGlXkWSS86wokUpNLGSFEMkxjiLw
         LTXog3oQUeYlAsSqFRikDVi4eH4drjdYkE8BOstUC5peyRDvWlXnvwXkhypN/QhniU3b
         4YCcCYkBHVoSV3rn5VxZxuD/3+bRVsenvdRYcGKiUFuZjC7CjGj8trd5tjiJjRTRtern
         eFIUSiEyg5/KfdsTknoKQHJ3es8Vc2UJgMfKQ28DDzbrx2F98YVzy+eVwLf/4r+6ZNKS
         rOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x9Kpgt3EBimCtrMxDgE/VNpUSewWOwwq2TyjR8XF3ho=;
        b=GAOtjqRDEtQVd56LCiF+9dUyigwVdUg91pL5uE/CFXYNKcfR6cxlTS8dNfJvuQpv4S
         yEWX0lr7gY6s4/kxT4Igx3SmXiqBkutoSIr0C1pH1ROm6EMG3PLcd9amR6YoO/9HADgu
         h0fHsnLzGrcLJ8lSjvQorqq3Cm6unse4qwmh+2b5I8LbP7kbh+kNpdS/LF8eN/pIq8/M
         SfFky37NqKnwSV5xAOympX5vBJXZEfckZsaRLwmgY+S30OrYtOT2tKWY7xQec/7lI+YX
         tszMHsAhC6qn0EHRwst0zecTM7CVyowi3lbFNmKbdSBBwslux4uJAnq4SblqU5trWgJj
         01xw==
X-Gm-Message-State: AGi0PuaPZJZcohmfLcKwrk44IfnbjhSuqPYUGjyCi7AJznsLkgXa8Sa3
        JAqDKrRe5nGQgD83BAOBlbVklo3Atd8YfuwTeV2KXQ==
X-Google-Smtp-Source: APiQypLrNtT5clQMft00XR6LMuAxtBUa3EU3jlYZRNrYWYy1SD52t/u6aczDCAaVB3059gv04TKS6/x7iQZVRcjMYZc=
X-Received: by 2002:a2e:884d:: with SMTP id z13mr4077527ljj.158.1586549811095;
 Fri, 10 Apr 2020 13:16:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585548051.git.ashish.kalra@amd.com> <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
 <b77a4a1e-b8ca-57a2-d849-adda91bfeac7@oracle.com> <20200403214559.GB28747@ashkalra_ubuntu_server>
 <65c09963-2027-22c1-e04d-4c8c3658b2c3@oracle.com> <CABayD+cf=Po-k7jqUQjq3AGopxk86d6bTcBhQxijnzpcUh90GA@mail.gmail.com>
 <20200408015221.GB27608@ashkalra_ubuntu_server> <CABayD+f0qdS5akac8JiB_HU_pWefHDsF=xRNhzSv42w-PTXnyg@mail.gmail.com>
 <20200410013418.GB19168@ashkalra_ubuntu_server> <CABayD+dDtjz7rJe1ujQ_sq88JRUzHaXXNP_hQVhD1vkXkPsXCw@mail.gmail.com>
In-Reply-To: <CABayD+dDtjz7rJe1ujQ_sq88JRUzHaXXNP_hQVhD1vkXkPsXCw@mail.gmail.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 10 Apr 2020 13:16:14 -0700
Message-ID: <CABayD+dwJeu+o+TG843XX1nWHWMz=iwW0uWBKPaG0uJEsxCYGw@mail.gmail.com>
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

On Fri, Apr 10, 2020 at 11:14 AM Steve Rutherford
<srutherford@google.com> wrote:
>
> On Thu, Apr 9, 2020 at 6:34 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > Hello Steve,
> >
> > On Thu, Apr 09, 2020 at 05:59:56PM -0700, Steve Rutherford wrote:
> > > On Tue, Apr 7, 2020 at 6:52 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > >
> > > > Hello Steve,
> > > >
> > > > On Tue, Apr 07, 2020 at 06:25:51PM -0700, Steve Rutherford wrote:
> > > > > On Mon, Apr 6, 2020 at 11:53 AM Krish Sadhukhan
> > > > > <krish.sadhukhan@oracle.com> wrote:
> > > > > >
> > > > > >
> > > > > > On 4/3/20 2:45 PM, Ashish Kalra wrote:
> > > > > > > On Fri, Apr 03, 2020 at 02:14:23PM -0700, Krish Sadhukhan wrote:
> > > > > > >> On 3/29/20 11:23 PM, Ashish Kalra wrote:
> > > > > > >>> From: Ashish Kalra <ashish.kalra@amd.com>
> > > > > > >>>
> > > > > > >>> This ioctl can be used by the application to reset the page
> > > > > > >>> encryption bitmap managed by the KVM driver. A typical usage
> > > > > > >>> for this ioctl is on VM reboot, on reboot, we must reinitialize
> > > > > > >>> the bitmap.
> > > > > > >>>
> > > > > > >>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > > > >>> ---
> > > > > > >>>    Documentation/virt/kvm/api.rst  | 13 +++++++++++++
> > > > > > >>>    arch/x86/include/asm/kvm_host.h |  1 +
> > > > > > >>>    arch/x86/kvm/svm.c              | 16 ++++++++++++++++
> > > > > > >>>    arch/x86/kvm/x86.c              |  6 ++++++
> > > > > > >>>    include/uapi/linux/kvm.h        |  1 +
> > > > > > >>>    5 files changed, 37 insertions(+)
> > > > > > >>>
> > > > > > >>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > > > > >>> index 4d1004a154f6..a11326ccc51d 100644
> > > > > > >>> --- a/Documentation/virt/kvm/api.rst
> > > > > > >>> +++ b/Documentation/virt/kvm/api.rst
> > > > > > >>> @@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
> > > > > > >>>    bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
> > > > > > >>>    bitmap for an incoming guest.
> > > > > > >>> +4.127 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
> > > > > > >>> +-----------------------------------------
> > > > > > >>> +
> > > > > > >>> +:Capability: basic
> > > > > > >>> +:Architectures: x86
> > > > > > >>> +:Type: vm ioctl
> > > > > > >>> +:Parameters: none
> > > > > > >>> +:Returns: 0 on success, -1 on error
> > > > > > >>> +
> > > > > > >>> +The KVM_PAGE_ENC_BITMAP_RESET is used to reset the guest's page encryption
> > > > > > >>> +bitmap during guest reboot and this is only done on the guest's boot vCPU.
> > > > > > >>> +
> > > > > > >>> +
> > > > > > >>>    5. The kvm_run structure
> > > > > > >>>    ========================
> > > > > > >>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > > > >>> index d30f770aaaea..a96ef6338cd2 100644
> > > > > > >>> --- a/arch/x86/include/asm/kvm_host.h
> > > > > > >>> +++ b/arch/x86/include/asm/kvm_host.h
> > > > > > >>> @@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
> > > > > > >>>                             struct kvm_page_enc_bitmap *bmap);
> > > > > > >>>     int (*set_page_enc_bitmap)(struct kvm *kvm,
> > > > > > >>>                             struct kvm_page_enc_bitmap *bmap);
> > > > > > >>> +   int (*reset_page_enc_bitmap)(struct kvm *kvm);
> > > > > > >>>    };
> > > > > > >>>    struct kvm_arch_async_pf {
> > > > > > >>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > > > > >>> index 313343a43045..c99b0207a443 100644
> > > > > > >>> --- a/arch/x86/kvm/svm.c
> > > > > > >>> +++ b/arch/x86/kvm/svm.c
> > > > > > >>> @@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
> > > > > > >>>     return ret;
> > > > > > >>>    }
> > > > > > >>> +static int svm_reset_page_enc_bitmap(struct kvm *kvm)
> > > > > > >>> +{
> > > > > > >>> +   struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > > > >>> +
> > > > > > >>> +   if (!sev_guest(kvm))
> > > > > > >>> +           return -ENOTTY;
> > > > > > >>> +
> > > > > > >>> +   mutex_lock(&kvm->lock);
> > > > > > >>> +   /* by default all pages should be marked encrypted */
> > > > > > >>> +   if (sev->page_enc_bmap_size)
> > > > > > >>> +           bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
> > > > > > >>> +   mutex_unlock(&kvm->lock);
> > > > > > >>> +   return 0;
> > > > > > >>> +}
> > > > > > >>> +
> > > > > > >>>    static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > > > > > >>>    {
> > > > > > >>>     struct kvm_sev_cmd sev_cmd;
> > > > > > >>> @@ -8203,6 +8218,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> > > > > > >>>     .page_enc_status_hc = svm_page_enc_status_hc,
> > > > > > >>>     .get_page_enc_bitmap = svm_get_page_enc_bitmap,
> > > > > > >>>     .set_page_enc_bitmap = svm_set_page_enc_bitmap,
> > > > > > >>> +   .reset_page_enc_bitmap = svm_reset_page_enc_bitmap,
> > > > > > >>
> > > > > > >> We don't need to initialize the intel ops to NULL ? It's not initialized in
> > > > > > >> the previous patch either.
> > > > > > >>
> > > > > > >>>    };
> > > > > > > This struct is declared as "static storage", so won't the non-initialized
> > > > > > > members be 0 ?
> > > > > >
> > > > > >
> > > > > > Correct. Although, I see that 'nested_enable_evmcs' is explicitly
> > > > > > initialized. We should maintain the convention, perhaps.
> > > > > >
> > > > > > >
> > > > > > >>>    static int __init svm_init(void)
> > > > > > >>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > > >>> index 05e953b2ec61..2127ed937f53 100644
> > > > > > >>> --- a/arch/x86/kvm/x86.c
> > > > > > >>> +++ b/arch/x86/kvm/x86.c
> > > > > > >>> @@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
> > > > > > >>>                     r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
> > > > > > >>>             break;
> > > > > > >>>     }
> > > > > > >>> +   case KVM_PAGE_ENC_BITMAP_RESET: {
> > > > > > >>> +           r = -ENOTTY;
> > > > > > >>> +           if (kvm_x86_ops->reset_page_enc_bitmap)
> > > > > > >>> +                   r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
> > > > > > >>> +           break;
> > > > > > >>> +   }
> > > > > > >>>     default:
> > > > > > >>>             r = -ENOTTY;
> > > > > > >>>     }
> > > > > > >>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > > > > >>> index b4b01d47e568..0884a581fc37 100644
> > > > > > >>> --- a/include/uapi/linux/kvm.h
> > > > > > >>> +++ b/include/uapi/linux/kvm.h
> > > > > > >>> @@ -1490,6 +1490,7 @@ struct kvm_enc_region {
> > > > > > >>>    #define KVM_GET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
> > > > > > >>>    #define KVM_SET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
> > > > > > >>> +#define KVM_PAGE_ENC_BITMAP_RESET  _IO(KVMIO, 0xc7)
> > > > > > >>>    /* Secure Encrypted Virtualization command */
> > > > > > >>>    enum sev_cmd_id {
> > > > > > >> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > > > >
> > > > >
> > > > > Doesn't this overlap with the set ioctl? Yes, obviously, you have to
> > > > > copy the new value down and do a bit more work, but I don't think
> > > > > resetting the bitmap is going to be the bottleneck on reboot. Seems
> > > > > excessive to add another ioctl for this.
> > > >
> > > > The set ioctl is generally available/provided for the incoming VM to setup
> > > > the page encryption bitmap, this reset ioctl is meant for the source VM
> > > > as a simple interface to reset the whole page encryption bitmap.
> > > >
> > > > Thanks,
> > > > Ashish
> > >
> > >
> > > Hey Ashish,
> > >
> > > These seem very overlapping. I think this API should be refactored a bit.
> > >
> > > 1) Use kvm_vm_ioctl_enable_cap to control whether or not this
> > > hypercall (and related feature bit) is offered to the VM, and also the
> > > size of the buffer.
> >
> > If you look at patch 13/14, i have added a new kvm para feature called
> > "KVM_FEATURE_SEV_LIVE_MIGRATION" which indicates host support for SEV
> > Live Migration and a new Custom MSR which the guest does a wrmsr to
> > enable the Live Migration feature, so this is like the enable cap
> > support.
> >
> > There are further extensions to this support i am adding, so patch 13/14
> > of this patch-set is still being enhanced and will have full support
> > when i repost next.
> >
> > > 2) Use set for manipulating values in the bitmap, including resetting
> > > the bitmap. Set the bitmap pointer to null if you want to reset to all
> > > 0xFFs. When the bitmap pointer is set, it should set the values to
> > > exactly what is pointed at, instead of only clearing bits, as is done
> > > currently.
> >
> > As i mentioned in my earlier email, the set api is supposed to be for
> > the incoming VM, but if you really need to use it for the outgoing VM
> > then it can be modified.
> >
> > > 3) Use get for fetching values from the kernel. Personally, I'd
> > > require alignment of the base GFN to a multiple of 8 (but the number
> > > of pages could be whatever), so you can just use a memcpy. Optionally,
> > > you may want some way to tell userspace the size of the existing
> > > buffer, so it can ensure that it can ask for the entire buffer without
> > > having to track the size in usermode (not strictly necessary, but nice
> > > to have since it ensures that there is only one place that has to
> > > manage this value).
> > >
> > > If you want to expand or contract the bitmap, you can use enable cap
> > > to adjust the size.
> >
> > As being discussed on the earlier mail thread, we are doing this
> > dynamically now by computing the guest RAM size when the
> > set_user_memory_region ioctl is invoked. I believe that should handle
> > the hot-plug and hot-unplug events too, as any hot memory updates will
> > need KVM memslots to be updated.
> Ahh, sorry, forgot you mentioned this: yes this can work. Host needs
> to be able to decide not to allocate, but this should be workable.
> >
> > > If you don't want to offer the hypercall to the guest, don't call the
> > > enable cap.
> > > This API avoids using up another ioctl. Ioctl space is somewhat
> > > scarce. It also gives userspace fine grained control over the buffer,
> > > so it can support both hot-plug and hot-unplug (or at the very least
> > > it is not obviously incompatible with those). It also gives userspace
> > > control over whether or not the feature is offered. The hypercall
> > > isn't free, and being able to tell guests to not call when the host
> > > wasn't going to migrate it anyway will be useful.
> > >
> >
> > As i mentioned above, now the host indicates if it supports the Live
> > Migration feature and the feature and the hypercall are only enabled on
> > the host when the guest checks for this support and does a wrmsr() to
> > enable the feature. Also the guest will not make the hypercall if the
> > host does not indicate support for it.
> If my read of those patches was correct, the host will always
> advertise support for the hypercall. And the only bit controlling
> whether or not the hypercall is advertised is essentially the kernel
> version. You need to rollout a new kernel to disable the hypercall.

Ahh, awesome, I see I misunderstood how the CPUID bits get passed
through: usermode can still override them. Forgot about the back and
forth for CPUID with usermode. My point about informing the guest
kernel is clearly moot. The host still needs the ability to prevent
allocations, but that is more minor. Maybe use a flag on the memslots
directly?
