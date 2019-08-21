Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3BB9732C
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 09:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfHUHPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 03:15:49 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34675 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfHUHPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 03:15:48 -0400
Received: by mail-ot1-f68.google.com with SMTP id c7so1155522otp.1;
        Wed, 21 Aug 2019 00:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jxVrA9CxsKiHpry0a7lxkK1MkSc5DTM9n5l3rc6J8H4=;
        b=jdhoHtICe2dI2FIvxxNwDJO/W5Lgr/+yZHISXd4hOER1yMlHqsMfnRny1RvnKH1rtK
         sK7F9H42Wh0n7poIog3d/lQHiIbqH3j15kS8chxT28zUtgmus/9Jr3OU5erAn9oQVLXf
         m00i1zqXLMb2SoB4BoyVHVqb2HCBjpSumg7CCNZ/xXq9/Mni5ZxuL0VRtbedP6N9UxnM
         Z1Yhfmu9M/r9/Olv/nSpp/PMzFFQ6F2c/Xz1MXo7vego2f9iow8Fa2uOPWHDZxEenTwA
         Hf9Z1c5I/o+D6IbMgR0IVSaHdZd4INEydaLSsgzmN9j9XlNCllmI64soG1HW/IDQVIza
         iZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jxVrA9CxsKiHpry0a7lxkK1MkSc5DTM9n5l3rc6J8H4=;
        b=HgkiIXVwUF4agGmJaY5x6AYofblj4TyzuNCFDUaJxRiRtAQIZ81ib+V/L3Jm7tsZn5
         6DjK2IkyKOKKaWbvtgQLel+x7zaan4dnFm6JF9oKDw+xDqHCjhjeBrV7PbU5rJXyeKxN
         vs/4Cnt1YcQ9Hdj14YzBtcoqR0CRWogJpSbkViSChse3M74JjcqNnAd3p7ZL32L2QCXL
         iaWyFWq3Z9BX6UWOJgP9Jnn0/EfhMEQzYmBkFwtYKSPcYTekjOHbyY0oH9cfhGZc8x2c
         FIlXvdwST1siOEurXPIemEzlBis8bq5ewHqJZcuusQGHK/p9LI62atTGBClCcz1FaXNz
         zcKQ==
X-Gm-Message-State: APjAAAUK8KQWNN9oCWayKNUa/XWO+9jw7YFhh2WpFanOr+m8waF77gud
        pohQ3lh+Q4P72CbrdlzkD6vFoPb4pIYqzLezSXs=
X-Google-Smtp-Source: APXvYqxLUwsSfJV3VbPtnGgIvbcaJ7kxCf3byp0ch+vdnLw6VbQJGMVMTusoxKmL21/xyqIFuy22JYrj1wzW5rjZaSI=
X-Received: by 2002:a9d:4590:: with SMTP id x16mr23501917ote.254.1566371747851;
 Wed, 21 Aug 2019 00:15:47 -0700 (PDT)
MIME-Version: 1.0
References: <87inbbjx2w.fsf@e105922-lin.cambridge.arm.com> <20180207011455.GA15214@hori1.linux.bs1.fc.nec.co.jp>
 <87fu6bfytm.fsf@e105922-lin.cambridge.arm.com> <20180208121749.0ac09af2b5a143106f339f55@linux-foundation.org>
 <87wozhvc49.fsf@concordia.ellerman.id.au> <e673f38a-9e5f-21f6-421b-b3cb4ff02e91@oracle.com>
 <CANRm+CxAgWVv5aVzQ0wdP_A7QQgqfy7nN_SxyaactG7Mnqfr2A@mail.gmail.com>
 <f79d828c-b0b4-8a20-c316-a13430cfb13c@oracle.com> <20190610235045.GB30991@hori.linux.bs1.fc.nec.co.jp>
 <CANRm+CwwPv52k7pWiErYwFHV=_6kCdiyXZkT3QT6ef_UJagt9A@mail.gmail.com> <20190821053904.GA23349@hori.linux.bs1.fc.nec.co.jp>
In-Reply-To: <20190821053904.GA23349@hori.linux.bs1.fc.nec.co.jp>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 21 Aug 2019 15:15:15 +0800
Message-ID: <CANRm+CxQ8bVBtfkP9Dmysx3C3bgE3UfO8rOuW5BzkQKbf36CRQ@mail.gmail.com>
Subject: Re: ##freemail## Re: [PATCH v2] mm: hwpoison: disable memory error
 handling on 1GB hugepage
To:     Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Punit Agrawal <punit.agrawal@arm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Xiao Guangrong <xiaoguangrong@tencent.com>,
        "lidongchen@tencent.com" <lidongchen@tencent.com>,
        "yongkaiwu@tencent.com" <yongkaiwu@tencent.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Aug 2019 at 13:41, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
>
> On Tue, Aug 20, 2019 at 03:03:55PM +0800, Wanpeng Li wrote:
> > Cc Mel Gorman, Kirill, Dave Hansen,
> > On Tue, 11 Jun 2019 at 07:51, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> > >
> > > On Wed, May 29, 2019 at 04:31:01PM -0700, Mike Kravetz wrote:
> > > > On 5/28/19 2:49 AM, Wanpeng Li wrote:
> > > > > Cc Paolo,
> > > > > Hi all,
> > > > > On Wed, 14 Feb 2018 at 06:34, Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > > > >>
> > > > >> On 02/12/2018 06:48 PM, Michael Ellerman wrote:
> > > > >>> Andrew Morton <akpm@linux-foundation.org> writes:
> > > > >>>
> > > > >>>> On Thu, 08 Feb 2018 12:30:45 +0000 Punit Agrawal <punit.agrawal@arm.com> wrote:
> > > > >>>>
> > > > >>>>>>
> > > > >>>>>> So I don't think that the above test result means that errors are properly
> > > > >>>>>> handled, and the proposed patch should help for arm64.
> > > > >>>>>
> > > > >>>>> Although, the deviation of pud_huge() avoids a kernel crash the code
> > > > >>>>> would be easier to maintain and reason about if arm64 helpers are
> > > > >>>>> consistent with expectations by core code.
> > > > >>>>>
> > > > >>>>> I'll look to update the arm64 helpers once this patch gets merged. But
> > > > >>>>> it would be helpful if there was a clear expression of semantics for
> > > > >>>>> pud_huge() for various cases. Is there any version that can be used as
> > > > >>>>> reference?
> > > > >>>>
> > > > >>>> Is that an ack or tested-by?
> > > > >>>>
> > > > >>>> Mike keeps plaintively asking the powerpc developers to take a look,
> > > > >>>> but they remain steadfastly in hiding.
> > > > >>>
> > > > >>> Cc'ing linuxppc-dev is always a good idea :)
> > > > >>>
> > > > >>
> > > > >> Thanks Michael,
> > > > >>
> > > > >> I was mostly concerned about use cases for soft/hard offline of huge pages
> > > > >> larger than PMD_SIZE on powerpc.  I know that powerpc supports PGD_SIZE
> > > > >> huge pages, and soft/hard offline support was specifically added for this.
> > > > >> See, 94310cbcaa3c "mm/madvise: enable (soft|hard) offline of HugeTLB pages
> > > > >> at PGD level"
> > > > >>
> > > > >> This patch will disable that functionality.  So, at a minimum this is a
> > > > >> 'heads up'.  If there are actual use cases that depend on this, then more
> > > > >> work/discussions will need to happen.  From the e-mail thread on PGD_SIZE
> > > > >> support, I can not tell if there is a real use case or this is just a
> > > > >> 'nice to have'.
> > > > >
> > > > > 1GB hugetlbfs pages are used by DPDK and VMs in cloud deployment, we
> > > > > encounter gup_pud_range() panic several times in product environment.
> > > > > Is there any plan to reenable and fix arch codes?
> > > >
> > > > I too am aware of slightly more interest in 1G huge pages.  Suspect that as
> > > > Intel MMU capacity increases to handle more TLB entries there will be more
> > > > and more interest.
> > > >
> > > > Personally, I am not looking at this issue.  Perhaps Naoya will comment as
> > > > he know most about this code.
> > >
> > > Thanks for forwarding this to me, I'm feeling that memory error handling
> > > on 1GB hugepage is demanded as real use case.
> > >
> > > >
> > > > > In addition, https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kvm/mmu.c#n3213
> > > > > The memory in guest can be 1GB/2MB/4K, though the host-backed memory
> > > > > are 1GB hugetlbfs pages, after above PUD panic is fixed,
> > > > > try_to_unmap() which is called in MCA recovery path will mark the PUD
> > > > > hwpoison entry. The guest will vmexit and retry endlessly when
> > > > > accessing any memory in the guest which is backed by this 1GB poisoned
> > > > > hugetlbfs page. We have a plan to split this 1GB hugetblfs page by 2MB
> > > > > hugetlbfs pages/4KB pages, maybe file remap to a virtual address range
> > > > > which is 2MB/4KB page granularity, also split the KVM MMU 1GB SPTE
> > > > > into 2MB/4KB and mark the offensive SPTE w/ a hwpoison flag, a sigbus
> > > > > will be delivered to VM at page fault next time for the offensive
> > > > > SPTE. Is this proposal acceptable?
> > > >
> > > > I am not sure of the error handling design, but this does sound reasonable.
> > >
> > > I agree that that's better.
> > >
> > > > That block of code which potentially dissolves a huge page on memory error
> > > > is hard to understand and I'm not sure if that is even the 'normal'
> > > > functionality.  Certainly, we would hate to waste/poison an entire 1G page
> > > > for an error on a small subsection.
> > >
> > > Yes, that's not practical, so we need at first establish the code base for
> > > 2GB hugetlb splitting and then extending it to 1GB next.
> >
> > I found it is not easy to split. There is a unique hugetlb page size
> > that is associated with a mounted hugetlbfs filesystem, file remap to
> > 2MB/4KB will break this. How about hard offline 1GB hugetlb page as
> > what has already done in soft offline, replace the corrupted 1GB page
> > by new 1GB page through page migration, the offending/corrupted area
> > in the original 1GB page doesn't need to be copied into the new page,
> > the offending/corrupted area in new page can keep full zero just as it
> > is clear during hugetlb page fault, other sub-pages of the original
> > 1GB page can be freed to buddy system. The sigbus signal is sent to
> > userspace w/ offending/corrupted virtual address, and signal code,
> > userspace should take care this.
>
> Splitting hugetlb is simply hard, IMHO. THP splitting is done by years
> of effort by many great kernel develpers, and I don't think doing similar
> development on hugetlb is a good idea.  I thought of converting hugetlb
> into thp, but maybe it's not an easy task either.
> "Hard offlining via soft offlining" approach sounds new and promising to me.
> I guess we don't need a large patchset to do this. So, thanks for the idea!

Good, I will wait a while, and start to cook the patches if there is
no opposite of voice.

Regards,
Wanpeng Li
