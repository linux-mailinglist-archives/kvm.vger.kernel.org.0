Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1ECFF8598
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 01:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfKLAvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 19:51:39 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41380 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLAvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 19:51:39 -0500
Received: by mail-ot1-f66.google.com with SMTP id 94so12871936oty.8
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 16:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j0wcI8/vYDeQzfI5+yZyNOVKSOKExVS3Qh36JWMEILM=;
        b=dz+s05YvVJDQXAkmQIBZwvJSZcXxXf9KXUeoV5Wre4jNuBNa67LpbcLslHayjVeE4J
         SPYc1PicD54ghzvc0FzfJR10FNbKY5lh9fvI1iMKfvCv+tjfuT0MJZ1B7l+4LlNpow5D
         Lo8r79PpZQ4VKtmxItOAHWDihM0LOiWM80102veJfEN333BeNYqDsmLP7mv7ZId0TTlg
         f4HwagX++WsSCpsYdoKtMgI4mJFh74vW+mGZRiJvjCkbxG3sSe9Snob9WM9M30CHkuvA
         yN0Cn1ayVBR8Gjv6U2p4pWEI7NwbfV4UNAvRI6p1K/kTexNSE8EeX9Gn5Nt3Q/F7CztS
         3qtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j0wcI8/vYDeQzfI5+yZyNOVKSOKExVS3Qh36JWMEILM=;
        b=oe5dIdny7d/oQa2hVgjZSC+EFoD+gwE43hs0jgJglSPGHJzqh6CFyDkyw3GIFYf9iR
         4H4I6bEH7gzxafeLUvprRsP9oefamc/6P80TKxGSmn0H274QRaYUjHyKbLf8gcB5MwAj
         HifUCcRVuoHcxuyu7n8bvjxWQ/KzZFRwyZpS9i1qt9iC8eSlVAlpDHAcFjcNerj2wCnN
         qSB5hYK5hm7Hhri7qxX5IuwvpzL1qJTTZaRLkrRL244tVf0TjdpNhF1cLIeFFRgKrp8g
         uxQpVjAvclc9WQRyh4EHcxe5ER9pE4sAwIJoFoNqipG/EFNETfswn7v+CYe+9woqFI6t
         /ukw==
X-Gm-Message-State: APjAAAUGZeeUd7TH8u3nMkIVUkpwJG8TmDRq4qXY9dsDYTlahg4IiTPQ
        oGEP8qV5Bz354asC3ZcNPSFcdgwrcdPG7wcWuuJpPg==
X-Google-Smtp-Source: APXvYqySz9nDf9cx4nrhgQe0VFFAM8g8LJFknhEecjwp05UNtr65ee3wabSo4wZkkXZYIwLZPR6IUZu+MyOm1VgvYjw=
X-Received: by 2002:a05:6830:1af7:: with SMTP id c23mr22149205otd.247.1573519898074;
 Mon, 11 Nov 2019 16:51:38 -0800 (PST)
MIME-Version: 1.0
References: <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
 <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
 <20191106233913.GC21617@linux.intel.com> <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
 <CAPcyv4i3M18V9Gmx3x7Ad12VjXbq94NsaUG9o71j59mG9-6H9Q@mail.gmail.com>
 <0db7c328-1543-55db-bc02-c589deb3db22@redhat.com> <CAPcyv4gMu547patcROaqBqbwxut5au-WyE_M=XsKxyCLbLXHTg@mail.gmail.com>
 <20191107155846.GA7760@linux.intel.com> <20191109014323.GB8254@linux.intel.com>
 <CAPcyv4hAY_OfExNP+_067Syh9kZAapppNwKZemVROfxgbDLLYQ@mail.gmail.com> <20191111182750.GE11805@linux.intel.com>
In-Reply-To: <20191111182750.GE11805@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 11 Nov 2019 16:51:26 -0800
Message-ID: <CAPcyv4hErx-Hd5q+3+W6VUSWDpEuOfipMsWAL+nnQtZvYAf3bg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 11, 2019 at 10:27 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Nov 08, 2019 at 06:00:46PM -0800, Dan Williams wrote:
> > On Fri, Nov 8, 2019 at 5:43 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > > On Thu, Nov 07, 2019 at 07:58:46AM -0800, Sean Christopherson wrote:
> > > > Insertion into KVM's secondary MMU is mutually exclusive with an invalidate
> > > > from the mmu_notifier.  KVM holds a reference to the to-be-inserted page
> > > > until the page has been inserted, which ensures that the page is pinned and
> > > > thus won't be invalidated until after the page is inserted.  This prevents
> > > > an invalidate from racing with insertion.  Dropping the reference
> > > > immediately after gup() would allow the invalidate to run prior to the page
> > > > being inserted, and so KVM would map the stale PFN into the guest's page
> > > > tables after it was invalidated in the host.
> > >
> > > My previous analysis is wrong, although I did sort of come to the right
> > > conclusion.
> > >
> > > The part that's wrong is that KVM does not rely on pinning a page/pfn when
> > > installing the pfn into its secondary MMU (guest page tables).  Instead,
> > > KVM keeps track of mmu_notifier invalidate requests and cancels insertion
> > > if an invalidate occured at any point between the start of hva_to_pfn(),
> > > i.e. the get_user_pages() call, and acquiring KVM's mmu lock (which must
> > > also be grabbed by mmu_notifier invalidate).  So for any pfn, regardless
> > > of whether it's backed by a struct page, KVM inserts a pfn if and only if
> > > it is guaranteed to get an mmu_notifier invalidate for the pfn (and isn't
> > > already invalidated).
> > >
> > > In the page fault flow, KVM doesn't care whether or not the pfn remains
> > > valid in the associated vma.  In other words, Dan's idea of immediately
> > > doing put_page() on ZONE_DEVICE pages would work for *page faults*...
> > >
> > > ...but not for all the other flows where KVM uses gfn_to_pfn(), and thus
> > > get_user_pages().  When accessing entire pages of guest memory, e.g. for
> > > nested virtualization, KVM gets the page associated with a gfn, maps it
> > > with kmap() to get a kernel address and keeps the mapping/page until it's
> > > done reading/writing the page.  Immediately putting ZONE_DEVICE pages
> > > would result in use-after-free scenarios for these flows.
> >
> > Thanks for this clarification. I do want to put out though that
> > ZONE_DEVICE pages go idle, they don't get freed. As long as KVM drops
> > its usage on invalidate it's perfectly fine for KVM to operate on idle
> > ZONE_DEVICE pages. The common case is that ZONE_DEVICE pages are
> > accessed and mapped while idle. Only direct-I/O temporarily marks them
> > busy to synchronize with invalidate. KVM obviates that need by
> > coordinating with mmu-notifiers instead.
>
> Only the KVM MMU, e.g. page fault handler, coordinates via mmu_notifier,
> the kvm_vcpu_map() case would continue using pages across an invalidate.
>
> Or did I misunderstand?

Not sure *I* understand KVM's implementation.

[ Note, I already acked the solution since it fixes the problem at
hand (thanks btw!), so feel free to drop this discussion if you don't
have time to hit me with the clue bat ]

An elevated page reference count for file mapped pages causes the
filesystem (for a dax mode file) to wait for that reference count to
drop to 1 before allowing the truncate to proceed. For a page cache
backed file mapping (non-dax) the reference count is not considered in
the truncate path. It does prevent the page from getting freed in the
page cache case, but the association to the file is lost for truncate.

As long as any memory the guest expects to be persistent is backed by
mmu-notifier coordination we're all good, otherwise an elevated
reference count does not coordinate with truncate in a reliable way.
