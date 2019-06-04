Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE934E7F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbfFDRMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:12:20 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:34242 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbfFDRMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:12:20 -0400
Received: by mail-it1-f194.google.com with SMTP id u124so3059079itc.1;
        Tue, 04 Jun 2019 10:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YwvRTSi8hPGYNKJsDR2mQt7/vaWadpcHt5lEeh5TQj0=;
        b=Bd7V+auq6f1XOlBC2pUbLKqKr37pQFOUTGlbFWLySuV7WdFk20+wWfgl3DexqyqwRQ
         XTDFAAqxb2uedga0O//1YKG7BxO++EqRAdTJdR0Y1Yc8JRNi/Gqk2hlMF6cWkPDGYb/n
         BZpijgpA88Vzp+0/F3BHuGiSX9COx3eW/7j4hyowUM93hYHLDnWbY+QOp/BWgek0nl8y
         TIk2/Dhr7rBv7tEKAm/Iew4qO46003bLBEdENnaXALWzuCyK5YYffZLrHlYdQBCO/qh0
         qpQIUYM79bGjKfEXOYm2wOIuuU2nJ1TwLvYOeKwhNpk4X9fSBCJF23V0T6hj88q4c0gU
         X3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YwvRTSi8hPGYNKJsDR2mQt7/vaWadpcHt5lEeh5TQj0=;
        b=gNemzrTEv3zjrbRvsx4jJW/a3qzwduklPtd+EzHjozKteEwPhlS0YRamAQY8shvfFT
         r1KTj2apFPuuWOydzd5G7APanfjOkPeHTkleR57xD6Ksfthl+8LRldKDxkxqtc4kQ3LH
         yHpYbCmDJa/OO1jlIahqUmFAwjXPhf3G7Tu2AaXqyWu/sVycQaepCaLYP2OqWkz2DYCf
         YhzEX/aGWr0bTNgDNYZIpkR/Q0Og8g8xfWIcB47E9c9rAJ9pl7TXyeF7Nxzqw37MPDlm
         J+PnzwvjmDTIJIGUO/4U/joVhbnCDxwLIxYsR4ZH+uKAP3Dtp1QE9kHNi/eYpSSHZlx1
         FsUA==
X-Gm-Message-State: APjAAAUWk1CeicDABEPAKtCUDk0e/r/iE8wSQoAvi41chqEhIHeNkAmU
        AjpFeqf/hncH2SSgftGRPJCebemitkt/4BFw2ck=
X-Google-Smtp-Source: APXvYqzDktx7jgwD6BJgywS6VvFnx4Vw5PiOeWLjzlixLk9bShnuYNP9pOlCXdlEUtnAFTWLZjmGg9tX/MfqEkD4oI4=
X-Received: by 2002:a02:b914:: with SMTP id v20mr2116128jan.83.1559668338874;
 Tue, 04 Jun 2019 10:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190603170306.49099-1-nitesh@redhat.com> <20190603170306.49099-2-nitesh@redhat.com>
 <CAKgT0Udnc_cmgBLFEZ5udexsc1cfjX1rJR3qQFOW-7bfuFh6gQ@mail.gmail.com>
 <4cdfee20-126e-bc28-cf1c-2cfd484ca28e@redhat.com> <CAKgT0Ud6uKpcj9HFHYOThCY=0_P0=quBLbsDR7uUMdbwcYeSTw@mail.gmail.com>
 <09e6caea-7000-b3e4-d297-df6bea78e127@redhat.com> <CAKgT0UeMpcckGpT6OnC2kqgtyT2p9bvNgE2C0eqW1GOJTU-DHA@mail.gmail.com>
 <13b96507-6347-1702-7822-6efb0f1bbf20@redhat.com>
In-Reply-To: <13b96507-6347-1702-7822-6efb0f1bbf20@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 4 Jun 2019 10:12:07 -0700
Message-ID: <CAKgT0UfEevMZu_1B0Og5QdOjj0R2PKJyo8msaHfouaL_oNegTw@mail.gmail.com>
Subject: Re: [RFC][Patch v10 1/2] mm: page_hinting: core infrastructure
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
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 4, 2019 at 9:42 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 6/4/19 12:25 PM, Alexander Duyck wrote:
> > On Tue, Jun 4, 2019 at 9:08 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >>
> >> On 6/4/19 11:14 AM, Alexander Duyck wrote:
> >>> On Tue, Jun 4, 2019 at 5:55 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >>>> On 6/3/19 3:04 PM, Alexander Duyck wrote:
> >>>>> On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >>>>>> This patch introduces the core infrastructure for free page hinting in
> >>>>>> virtual environments. It enables the kernel to track the free pages which
> >>>>>> can be reported to its hypervisor so that the hypervisor could
> >>>>>> free and reuse that memory as per its requirement.
> >>>>>>
> >>>>>> While the pages are getting processed in the hypervisor (e.g.,
> >>>>>> via MADV_FREE), the guest must not use them, otherwise, data loss
> >>>>>> would be possible. To avoid such a situation, these pages are
> >>>>>> temporarily removed from the buddy. The amount of pages removed
> >>>>>> temporarily from the buddy is governed by the backend(virtio-balloon
> >>>>>> in our case).
> >>>>>>
> >>>>>> To efficiently identify free pages that can to be hinted to the
> >>>>>> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
> >>>>>> chunks are reported to the hypervisor - especially, to not break up THP
> >>>>>> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bits
> >>>>>> in the bitmap are an indication whether a page *might* be free, not a
> >>>>>> guarantee. A new hook after buddy merging sets the bits.
> >>>>>>
> >>>>>> Bitmaps are stored per zone, protected by the zone lock. A workqueue
> >>>>>> asynchronously processes the bitmaps, trying to isolate and report pages
> >>>>>> that are still free. The backend (virtio-balloon) is responsible for
> >>>>>> reporting these batched pages to the host synchronously. Once reporting/
> >>>>>> freeing is complete, isolated pages are returned back to the buddy.
> >>>>>>
> >>>>>> There are still various things to look into (e.g., memory hotplug, more
> >>>>>> efficient locking, possible races when disabling).
> >>>>>>
> >>>>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> >>>>> So one thing I had thought about, that I don't believe that has been
> >>>>> addressed in your solution, is to determine a means to guarantee
> >>>>> forward progress. If you have a noisy thread that is allocating and
> >>>>> freeing some block of memory repeatedly you will be stuck processing
> >>>>> that and cannot get to the other work. Specifically if you have a zone
> >>>>> where somebody is just cycling the number of pages needed to fill your
> >>>>> hinting queue how do you get around it and get to the data that is
> >>>>> actually code instead of getting stuck processing the noise?
> >>>> It should not matter. As every time the memory threshold is met, entire
> >>>> bitmap
> >>>> is scanned and not just a chunk of memory for possible isolation. This
> >>>> will guarantee
> >>>> forward progress.
> >>> So I think there may still be some issues. I see how you go from the
> >>> start to the end, but how to you loop back to the start again as pages
> >>> are added? The init_hinting_wq doesn't seem to have a way to get back
> >>> to the start again if there is still work to do after you have
> >>> completed your pass without queue_work_on firing off another thread.
> >>>
> >> That will be taken care as the part of a new job, which will be
> >> en-queued as soon
> >> as the free memory count for the respective zone will reach the threshold.
> > So does that mean that you have multiple threads all calling
> > queue_work_on until you get below the threshold?
> Every time a page of order MAX_ORDER - 2 is added to the buddy, free
> memory count will be incremented if the bit is not already set and its
> value will be checked against the threshold.
> >  If so it seems like
> > that would get expensive since that is an atomic test and set
> > operation that would be hammered until you get below that threshold.
>
> Not sure if I understood "until you get below that threshold".
> Can you please explain?
> test_and_set_bit() will be called every time a page with MAX_ORDER -2
> order is added to the buddy. (Not already hinted)

I had overlooked the other paths that are already making use of the
test_and_set_bit(). What I was getting at specifically is that the
WORK_PENDING bit in the work struct is going to be getting hit every
time you add a new page. So it is adding yet another atomic operation
in addition to the increment and test_and_set_bit() that you were
already doing.

Generally you may want to look at trying to reduce how often you are
having to perform these atomic operations. So for example one thing
you could do is use something like an atomic_read before you do your
atomic_inc to determine if you are transitioning to a state where you
were below, and now you are above the threshold. Doing something like
that could save you on the number of calls you are making and save
some significant CPU cycles.
