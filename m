Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2658067334
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 18:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfGLQWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 12:22:50 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46975 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfGLQWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 12:22:49 -0400
Received: by mail-io1-f66.google.com with SMTP id i10so21475184iol.13;
        Fri, 12 Jul 2019 09:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zYH8Vo9Y5F5IqrJ/iOICmwuOeumCdZOyTM3iTd+JfOs=;
        b=omIzIBYlKRTPh8j23nq6YfsvemBgq2R3BwAVy/MNC4IayYHC/jfN2QFZafA7sS9JSC
         H2WrrCsAkxMxc7Hs+RMx+lj0Dt05CSDOEEIYbHpunimaev2HmJc3Ie9ocayPIWFSLM2u
         TW2zczhZrlnKfGQiQWV0I1YYQCOMIxDkMfN4DQaVFAxkCDM2dW643VGB/VplMFbdaTPX
         2QI9A4ueJVt+2LJS8OwsJlO30zkesxIAfS+HYLgXzUNsPFfRdr4NaV3A1jS1ogHqE/TX
         Fp4Hj4SoepzsqVL0/BH+TUvhpJ+RNBLLO07t3oOCA65C4edKxQjUQ971ohgS+1ZoorJ3
         ipTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zYH8Vo9Y5F5IqrJ/iOICmwuOeumCdZOyTM3iTd+JfOs=;
        b=MKo9F6axWVyvCh66NnlwX28rRpnSYgWQgHo+l174s/DDITk4Vt/+c0DBJrfdiiSexf
         +jaC/8MSNDJLEJYn8bvae+U43CYik9B2/tCJYXN3tAu/3TpM/DSHoFAO4CDoCmZdNMaR
         88V5DX0jBGfe+Myfj3E8T6rVZd9zqe8JroAT5KQqtvF/Bmin85XhexzpQWi9mNCSK8kj
         gEjFkUzSDMJRmzPMix8oDM6vK7NmaGvzQfKFJJLBfbILtxesrqH///pSXyVpippEbuWl
         rhltu19Wb5S1Fcr3V5SS/AR2fWw3jsRuE6cHh+htpjm9tWaRlWdK4Mpx4CWLIMBVoJtt
         l+KA==
X-Gm-Message-State: APjAAAVzzvPh/xs32Ao0YoHt/6XOgw64HTJf2WISv+NLIKbFQsMK3j6r
        TPilrajKfU5nrrx1QjqgC/LpyaQJVHxxaU1t01k=
X-Google-Smtp-Source: APXvYqw2lc2T9kiB5p8fuhbtGKenrvLboCsn3CGdEb4CKCRRbYs33Sb1RaNqUex99oZ/LJbYFUObBQcX1R489/T1RVs=
X-Received: by 2002:a6b:dd18:: with SMTP id f24mr10989410ioc.97.1562948568501;
 Fri, 12 Jul 2019 09:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190710195158.19640-1-nitesh@redhat.com> <20190710195158.19640-2-nitesh@redhat.com>
 <CAKgT0Ue3mVZ_J0GgMUP4PBW4SUD1=L9ixD5nUZybw9_vmBAT0A@mail.gmail.com>
 <3c6c6b93-eb21-a04c-d0db-6f1b134540db@redhat.com> <CAKgT0UcaKhAf+pTeE1CRxqhiPtR2ipkYZZ2+aChetV7=LDeSeA@mail.gmail.com>
 <521db934-3acd-5287-6e75-67feead8ca63@redhat.com>
In-Reply-To: <521db934-3acd-5287-6e75-67feead8ca63@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 12 Jul 2019 09:22:37 -0700
Message-ID: <CAKgT0Uf7xsdh9OgBq-kyTkyvh8Qo9kV4uiWTVP7NKqzO4X0wyg@mail.gmail.com>
Subject: Re: [RFC][Patch v11 1/2] mm: page_hinting: core infrastructure
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        john.starks@microsoft.com, Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 11, 2019 at 6:13 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 7/11/19 7:20 PM, Alexander Duyck wrote:
> > On Thu, Jul 11, 2019 at 10:58 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >>
> >> On 7/10/19 5:56 PM, Alexander Duyck wrote:
> >>> On Wed, Jul 10, 2019 at 12:52 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >>>> This patch introduces the core infrastructure for free page hinting in
> >>>> virtual environments. It enables the kernel to track the free pages which
> >>>> can be reported to its hypervisor so that the hypervisor could
> >>>> free and reuse that memory as per its requirement.
> >>>>
> >>>> While the pages are getting processed in the hypervisor (e.g.,
> >>>> via MADV_FREE), the guest must not use them, otherwise, data loss
> >>>> would be possible. To avoid such a situation, these pages are
> >>>> temporarily removed from the buddy. The amount of pages removed
> >>>> temporarily from the buddy is governed by the backend(virtio-balloon
> >>>> in our case).
> >>>>
> >>>> To efficiently identify free pages that can to be hinted to the
> >>>> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
> >>>> chunks are reported to the hypervisor - especially, to not break up THP
> >>>> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bits
> >>>> in the bitmap are an indication whether a page *might* be free, not a
> >>>> guarantee. A new hook after buddy merging sets the bits.
> >>>>
> >>>> Bitmaps are stored per zone, protected by the zone lock. A workqueue
> >>>> asynchronously processes the bitmaps, trying to isolate and report pages
> >>>> that are still free. The backend (virtio-balloon) is responsible for
> >>>> reporting these batched pages to the host synchronously. Once reporting/
> >>>> freeing is complete, isolated pages are returned back to the buddy.
> >>>>
> >>>> There are still various things to look into (e.g., memory hotplug, more
> >>>> efficient locking, possible races when disabling).
> >>>>
> >>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> > So just FYI, I thought I would try the patches. It looks like there
> > might be a bug somewhere that is causing it to free memory it
> > shouldn't be. After about 10 minutes my VM crashed with a system log
> > full of various NULL pointer dereferences.
>
> That's interesting, I have tried the patches with MADV_DONTNEED as well.
> I just retried it but didn't see any crash. May I know what kind of
> workload you are running?

I was running the page_fault1 test on a VM with 80G of memory.

> >  The only change I had made
> > is to use MADV_DONTNEED instead of MADV_FREE in QEMU since my headers
> > didn't have MADV_FREE on the host. It occurs to me one advantage of
> > MADV_DONTNEED over MADV_FREE is that you are more likely to catch
> > these sort of errors since it zeros the pages instead of leaving them
> > intact.
> For development purpose maybe. For the final patch-set I think we
> discussed earlier why we should keep MADV_FREE.

I'm still not convinced MADV_FREE is a net win, at least for
performance. You are still paying the cost for the VMEXIT in order to
regain ownership of the page. In the case that you are under memory
pressure it is essentially equivalent to MADV_DONTNEED. Also it
doesn't really do much to help with the memory footprint of the VM
itself. With the MADV_DONTNEED the pages are freed back and you have a
greater liklihood of reducing the overall memory footprint of the
entire system since you would be more likely to be assigned pages that
were recently used rather than having to access a cold page.

<snip>

> >>>> +void page_hinting_enqueue(struct page *page, int order)
> >>>> +{
> >>>> +       int zone_idx;
> >>>> +
> >>>> +       if (!page_hitning_conf || order < PAGE_HINTING_MIN_ORDER)
> >>>> +               return;
> >>> I would think it is going to be expensive to be jumping into this
> >>> function for every freed page. You should probably have an inline
> >>> taking care of the order check before you even get here since it would
> >>> be faster that way.
> >> I see, I can take a look. Thanks.
> >>>> +
> >>>> +       bm_set_pfn(page);
> >>>> +       if (atomic_read(&page_hinting_active))
> >>>> +               return;
> >>> So I would think this piece is racy. Specifically if you set a PFN
> >>> that is somewhere below the PFN you are currently processing in your
> >>> scan it is going to remain unset until you have another page freed
> >>> after the scan is completed. I would worry you can end up with a batch
> >>> free of memory resulting in a group of pages sitting at the start of
> >>> your bitmap unhinted.
> >> True, but that will be hinted next time threshold is met.
> > Yes, but that assumes that there is another free immediately coming.
> > It is possible that you have a big application run and then
> > immediately shut down and have it free all its memory at once. Worst
> > case scenario would be that it starts by freeing from the end and
> > works toward the start. With that you could theoretically end up with
> > a significant chunk of memory waiting some time for another big free
> > to come along.
>
> Any suggestion on some benchmark/test application which I could run to
> see this kind of behavior?

Like I mentioned before, try doing a VM with a bigger memory
footprint. You could probably just do a stack of VMs like what we were
doing with the memhog test. Basically the longer it takes to process
all the pages the greater the liklihood that there are still pages
left when they are freed.
