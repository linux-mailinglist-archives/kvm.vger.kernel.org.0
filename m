Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 989F6F5CDE
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 03:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfKICA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 21:00:59 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35077 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfKICA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 21:00:59 -0500
Received: by mail-oi1-f196.google.com with SMTP id n16so7009752oig.2
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 18:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CMB5JpKwIq6S9PN7vvpe5VBnbdzeo3jW3I3cqODAscQ=;
        b=xi6zg9bQ0lHizHa87ygqX+qHqSdrFuEi4KcpTdAJ0Y9WXNEF4W0XNWCa/V5JZgIHwR
         EDe8LdE4gbvHrM2W5CXoHOBFd30nN1QbrGjHz/KrKn+qXidbyuaIIjTmrGy57pxcOoik
         u1D3HxJ8YWfEv0OqS8d0CX5jL1xcbyNQxEEd3nC3HIlDzf0OuMTAMjTwYFMOEuEy1Z+g
         I41Sl+6KLFxzaT49rj/EQhObdyEQG1p380oOGciQxj16F07Zv6EDL0WQrzU84Z1USW1c
         QyEJqcH89E+RXdq5JjS5yoxl6tQYcvH+xa6gqu6ziiQmcxkiUNtiiXpzLT1afcf1Hcwt
         2YdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CMB5JpKwIq6S9PN7vvpe5VBnbdzeo3jW3I3cqODAscQ=;
        b=jFhrybYcnRaFx/Ty1YKRYhGlb8h8IGGgPyS5BQvclNMowNPd7zTKkXS8w6piMjVx+h
         U7VMabQt3ZVhdvP7E502nI7RzHk3vMMsJeWSGeNbljs4/MMbIKNP1ophFilUksoO1c1l
         wjhN5hBNNmCj+IJ5Iva5dlmVKEZrXVwcQoHi9QL/dD9BsBxMYc1/AEupl71m/0M9H5h6
         hPSfF5l1WNm3/9OsZFt4d9XRb3w12om3za6Qw5Fs3ozNcsYkOmT0y+s9SCh94viDXbw7
         zreGyXbXLGvle9TlhyTY/byY4GHYPOOF4rqKBRQwFAIxTJKfGr4uyZglzQY7DCs5pMnG
         CHmw==
X-Gm-Message-State: APjAAAXQqtpcwtuV0rMMek48TOexprHwOLrl/zF/UlB6FMviaJ6MPOLG
        nDhyS8s1eNz38dqHbu5P++PiKTEx8833GH9CZS159g==
X-Google-Smtp-Source: APXvYqxbOAODZRmObVlkB1fFi8tbZoBup8I2xNiMTryRx94QSzzOKknAk0ruAKgUXiqvkpyg0rBnaBT3Cym0nNLt/Wk=
X-Received: by 2002:aca:55c1:: with SMTP id j184mr13409516oib.105.1573264857672;
 Fri, 08 Nov 2019 18:00:57 -0800 (PST)
MIME-Version: 1.0
References: <20191106170727.14457-2-sean.j.christopherson@intel.com>
 <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
 <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com> <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
 <20191106233913.GC21617@linux.intel.com> <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
 <CAPcyv4i3M18V9Gmx3x7Ad12VjXbq94NsaUG9o71j59mG9-6H9Q@mail.gmail.com>
 <0db7c328-1543-55db-bc02-c589deb3db22@redhat.com> <CAPcyv4gMu547patcROaqBqbwxut5au-WyE_M=XsKxyCLbLXHTg@mail.gmail.com>
 <20191107155846.GA7760@linux.intel.com> <20191109014323.GB8254@linux.intel.com>
In-Reply-To: <20191109014323.GB8254@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 8 Nov 2019 18:00:46 -0800
Message-ID: <CAPcyv4hAY_OfExNP+_067Syh9kZAapppNwKZemVROfxgbDLLYQ@mail.gmail.com>
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

On Fri, Nov 8, 2019 at 5:43 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Nov 07, 2019 at 07:58:46AM -0800, Sean Christopherson wrote:
> > On Thu, Nov 07, 2019 at 07:36:45AM -0800, Dan Williams wrote:
> > > On Thu, Nov 7, 2019 at 3:12 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > >
> > > > On 07/11/19 06:48, Dan Williams wrote:
> > > > >> How do mmu notifiers get held off by page references and does that
> > > > >> machinery work with ZONE_DEVICE? Why is this not a concern for the
> > > > >> VM_IO and VM_PFNMAP case?
> > > > > Put another way, I see no protection against truncate/invalidate
> > > > > afforded by a page pin. If you need guarantees that the page remains
> > > > > valid in the VMA until KVM can install a mmu notifier that needs to
> > > > > happen under the mmap_sem as far as I can see. Otherwise gup just
> > > > > weakly asserts "this pinned page was valid in this vma at one point in
> > > > > time".
> > > >
> > > > The MMU notifier is installed before gup, so any invalidation will be
> > > > preceded by a call to the MMU notifier.  In turn,
> > > > invalidate_range_start/end is called with mmap_sem held so there should
> > > > be no race.
> > > >
> > > > However, as Sean mentioned, early put_page of ZONE_DEVICE pages would be
> > > > racy, because we need to keep the reference between the gup and the last
> > > > time we use the corresponding struct page.
> > >
> > > If KVM is establishing the mmu_notifier before gup then there is
> > > nothing left to do with that ZONE_DEVICE page, so I'm struggling to
> > > see what further qualification of kvm_is_reserved_pfn() buys the
> > > implementation.
> >
> > Insertion into KVM's secondary MMU is mutually exclusive with an invalidate
> > from the mmu_notifier.  KVM holds a reference to the to-be-inserted page
> > until the page has been inserted, which ensures that the page is pinned and
> > thus won't be invalidated until after the page is inserted.  This prevents
> > an invalidate from racing with insertion.  Dropping the reference
> > immediately after gup() would allow the invalidate to run prior to the page
> > being inserted, and so KVM would map the stale PFN into the guest's page
> > tables after it was invalidated in the host.
>
> My previous analysis is wrong, although I did sort of come to the right
> conclusion.
>
> The part that's wrong is that KVM does not rely on pinning a page/pfn when
> installing the pfn into its secondary MMU (guest page tables).  Instead,
> KVM keeps track of mmu_notifier invalidate requests and cancels insertion
> if an invalidate occured at any point between the start of hva_to_pfn(),
> i.e. the get_user_pages() call, and acquiring KVM's mmu lock (which must
> also be grabbed by mmu_notifier invalidate).  So for any pfn, regardless
> of whether it's backed by a struct page, KVM inserts a pfn if and only if
> it is guaranteed to get an mmu_notifier invalidate for the pfn (and isn't
> already invalidated).
>
> In the page fault flow, KVM doesn't care whether or not the pfn remains
> valid in the associated vma.  In other words, Dan's idea of immediately
> doing put_page() on ZONE_DEVICE pages would work for *page faults*...
>
> ...but not for all the other flows where KVM uses gfn_to_pfn(), and thus
> get_user_pages().  When accessing entire pages of guest memory, e.g. for
> nested virtualization, KVM gets the page associated with a gfn, maps it
> with kmap() to get a kernel address and keeps the mapping/page until it's
> done reading/writing the page.  Immediately putting ZONE_DEVICE pages
> would result in use-after-free scenarios for these flows.

Thanks for this clarification. I do want to put out though that
ZONE_DEVICE pages go idle, they don't get freed. As long as KVM drops
its usage on invalidate it's perfectly fine for KVM to operate on idle
ZONE_DEVICE pages. The common case is that ZONE_DEVICE pages are
accessed and mapped while idle. Only direct-I/O temporarily marks them
busy to synchronize with invalidate. KVM obviates that need by
coordinating with mmu-notifiers instead.
