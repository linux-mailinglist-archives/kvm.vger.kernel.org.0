Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7197616552A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 03:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgBTCkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 21:40:19 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34083 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgBTCkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 21:40:18 -0500
Received: by mail-lf1-f65.google.com with SMTP id l18so1822555lfc.1
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 18:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=otgZqvPq+4Pddd4R7R7YPMAxMkkLRo5HXUh0IOwXlqk=;
        b=SF1EjwU+wv7TQ1r9W7sc/MbKsFb+dNEuYE1Cz+xl1hjeh+QxAkZ40uYWaiOb5u2lW+
         AlJeBkWMZwtctxzQtcnCo0RouuTeEbTmxEXmIDMP15u5NkrajqRZiT3LQQ2LZXhhh+jp
         OJ9CQ1AjqVEONuuK4U1znk5nxdfXCku9mhmttRV6u0rb9L0QL+pKL6FLLbcRG+lnq81r
         EJOJOwzOSm76F2wc/0EaxxdzzfHjEt2AbTeCmAbGeWm5C7ngalydEGFWH5KZzYf7zPcO
         npivYcTyN9aXZ0ArX6jFnoae0mp/7GpT9H3QxX8wfikhNXGGJH8tPRj48bj3tchk5pgb
         QjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=otgZqvPq+4Pddd4R7R7YPMAxMkkLRo5HXUh0IOwXlqk=;
        b=oFAfR8FjY6kqEaBcuysFazRwhwGv0n0hBmXkoVvgclUIF88nd3zd6p14+xpO7RvkLK
         Jm7APgW5kvR3OuXAwpUA65b2feJj3yvNnW+KetMtdnJTevCSDYUHvpcrNRnHZR7eJQf/
         yVIBtGLrS2hMFZAj0bcFF9OcoSmZ985wQkXCvoBSxdPDxGKecdFShpH+gXWosXywBS+p
         XY3ctf1cAfZE2dnGxxYbuxNrUK5S+HGejnAKl6NkjJblsLQmtDQ1utb41DxXDa24PjX2
         wC2dwL/nXuij6z7mpfn3uxaxrZHanOC/gLGdry08qzDHRoxPk/JqLp55X8FDEfaF3OZ0
         WmHA==
X-Gm-Message-State: APjAAAV+7DT/bnSt9ZVPx79fITYFqjSmSDPd44nWYo4kbE4wWQwpqP/K
        kweDfjxrp2MA9KtrmSQZcaWlbwElTlHQpNFCt3NHog==
X-Google-Smtp-Source: APXvYqxK9gpSv5HqVuYrGt/Qj2lVjO7gKfBDymep0cUYVz7aoV/+bAF6COx8tR7SmRFncvH85RNzIPXxZE84mV2nzJs=
X-Received: by 2002:a19:f703:: with SMTP id z3mr14889612lfe.16.1582166416083;
 Wed, 19 Feb 2020 18:40:16 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com> <fc5e111e0a4eda0e6ea1ee3923327384906aff36.1581555616.git.ashish.kalra@amd.com>
In-Reply-To: <fc5e111e0a4eda0e6ea1ee3923327384906aff36.1581555616.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 19 Feb 2020 18:39:39 -0800
Message-ID: <CABayD+fM-s0+j6JXN5qb0zce2Kqi6AC8+c+7qbqKr0NgC-QYiQ@mail.gmail.com>
Subject: Re: [PATCH 08/12] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, x86@kernel.org,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 5:17 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       unsigned long *map;
> +       unsigned long sz;
> +
> +       if (sev->page_enc_bmap_size >= new_size)
> +               return 0;
> +
> +       sz = ALIGN(new_size, BITS_PER_LONG) / 8;
> +
> +       map = vmalloc(sz);
> +       if (!map) {
> +               pr_err_once("Failed to allocate encrypted bitmap size %lx\n",
> +                               sz);
> +               return -ENOMEM;
> +       }
> +
> +       /* mark the page encrypted (by default) */
> +       memset(map, 0xff, sz);
> +
> +       bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size);
Personally, I would do the arithmetic and swap the `memset(map, 0xff,
sz);` for `memset(map + sev->page_enc_bmap_size, 0xff, sz -
sev->page_enc_bmap_size);`, but gcc might be smart enough to do this
for you.

> +       kvfree(sev->page_enc_bmap);
> +
> +       sev->page_enc_bmap = map;
> +       sev->page_enc_bmap_size = new_size;
> +
> +       return 0;
> +}
> +
> +static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> +                                 unsigned long npages, unsigned long enc)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       gfn_t gfn_start, gfn_end;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -EINVAL;
> +
> +       if (!npages)
> +               return 0;
> +
> +       gfn_start = gpa_to_gfn(gpa);
> +       gfn_end = gfn_start + npages;
> +
> +       /* out of bound access error check */
> +       if (gfn_end <= gfn_start)
> +               return -EINVAL;
> +
> +       /* lets make sure that gpa exist in our memslot */
> +       pfn_start = gfn_to_pfn(kvm, gfn_start);
> +       pfn_end = gfn_to_pfn(kvm, gfn_end);
I believe these functions assume as_id==0, which is probably fine in
practice. If one were to want to migrate a VM with SMM support (which
I believe is the only current usage of non-zero as_ids), it feels like
SMM would need to be in control of its own c-bit tracking, but that
doesn't seem super feasible (otherwise the guest kernel could corrupt
SMM by passing invalid c-bit statuses). I'm not certain anyone wants
SMM with SEV anyway?

> +
> +       if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
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
> +       ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
> +       if (ret)
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
> +       return ret;
> +}
> +
>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -7972,6 +8064,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>         .need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>
>         .apic_init_signal_blocked = svm_apic_init_signal_blocked,
> +
> +       .page_enc_status_hc = svm_page_enc_status_hc,
>  };
>
>  static int __init svm_init(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9a6664886f2e..7963f2979fdf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7879,6 +7879,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>         .nested_get_evmcs_version = NULL,
>         .need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
>         .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> +       .page_enc_status_hc = NULL,
>  };
>
>  static void vmx_cleanup_l1d_flush(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fbabb2f06273..298627fa3d39 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7547,6 +7547,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>                 kvm_sched_yield(vcpu->kvm, a0);
>                 ret = 0;
>                 break;
> +       case KVM_HC_PAGE_ENC_STATUS:
> +               ret = -KVM_ENOSYS;
> +               if (kvm_x86_ops->page_enc_status_hc)
> +                       ret = kvm_x86_ops->page_enc_status_hc(vcpu->kvm,
> +                                       a0, a1, a2);
> +               break;
>         default:
>                 ret = -KVM_ENOSYS;
>                 break;
Add a cap to kvm_vm_ioctl_enable_cap so that the vmm can configure
whether or not this hypercall is offered. Moving to an enable cap
would also allow the vmm to pass down the expected size of the c-bit
tracking buffer, so that you don't need to handle dynamic resizing in
response to guest hypercall, otherwise KVM will sporadically start
copying around large buffers when working with large VMs.

Stepping back a bit, I'm a little surprised by the fact that you don't
treat the c-bit buffers the same way as the dirty tracking buffers and
put them alongside the memslots. That's probably more effort, and the
strategy of using one large buffer should work fine (assuming you
don't need to support non-zero as_ids).
