Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4281971B4
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 07:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfHUFxs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 21 Aug 2019 01:53:48 -0400
Received: from tyo161.gate.nec.co.jp ([114.179.232.161]:41442 "EHLO
        tyo161.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfHUFxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 01:53:47 -0400
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Aug 2019 01:53:46 EDT
Received: from mailgate01.nec.co.jp ([114.179.233.122])
        by tyo161.gate.nec.co.jp (8.15.1/8.15.1) with ESMTPS id x7L5fP8t013248
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 21 Aug 2019 14:41:25 +0900
Received: from mailsv01.nec.co.jp (mailgate-v.nec.co.jp [10.204.236.94])
        by mailgate01.nec.co.jp (8.15.1/8.15.1) with ESMTP id x7L5fPie027570;
        Wed, 21 Aug 2019 14:41:25 +0900
Received: from mail01b.kamome.nec.co.jp (mail01b.kamome.nec.co.jp [10.25.43.2])
        by mailsv01.nec.co.jp (8.15.1/8.15.1) with ESMTP id x7L5fPMY031987;
        Wed, 21 Aug 2019 14:41:25 +0900
Received: from bpxc99gp.gisp.nec.co.jp ([10.38.151.151] [10.38.151.151]) by mail02.kamome.nec.co.jp with ESMTP id BT-MMP-7746119; Wed, 21 Aug 2019 14:39:05 +0900
Received: from BPXM23GP.gisp.nec.co.jp ([10.38.151.215]) by
 BPXC23GP.gisp.nec.co.jp ([10.38.151.151]) with mapi id 14.03.0439.000; Wed,
 21 Aug 2019 14:39:04 +0900
From:   Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To:     Wanpeng Li <kernellwp@gmail.com>
CC:     Mike Kravetz <mike.kravetz@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Punit Agrawal" <punit.agrawal@arm.com>,
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
Subject: Re: ##freemail## Re: [PATCH v2] mm: hwpoison: disable memory error
 handling on 1GB hugepage
Thread-Topic: ##freemail## Re: [PATCH v2] mm: hwpoison: disable memory error
 handling on 1GB hugepage
Thread-Index: AQHVFnaoUuMkT7+k5kKGu78GtXiXKKaVCtaAgG58OYCAAXqfAA==
Date:   Wed, 21 Aug 2019 05:39:04 +0000
Message-ID: <20190821053904.GA23349@hori.linux.bs1.fc.nec.co.jp>
References: <87inbbjx2w.fsf@e105922-lin.cambridge.arm.com>
 <20180207011455.GA15214@hori1.linux.bs1.fc.nec.co.jp>
 <87fu6bfytm.fsf@e105922-lin.cambridge.arm.com>
 <20180208121749.0ac09af2b5a143106f339f55@linux-foundation.org>
 <87wozhvc49.fsf@concordia.ellerman.id.au>
 <e673f38a-9e5f-21f6-421b-b3cb4ff02e91@oracle.com>
 <CANRm+CxAgWVv5aVzQ0wdP_A7QQgqfy7nN_SxyaactG7Mnqfr2A@mail.gmail.com>
 <f79d828c-b0b4-8a20-c316-a13430cfb13c@oracle.com>
 <20190610235045.GB30991@hori.linux.bs1.fc.nec.co.jp>
 <CANRm+CwwPv52k7pWiErYwFHV=_6kCdiyXZkT3QT6ef_UJagt9A@mail.gmail.com>
In-Reply-To: <CANRm+CwwPv52k7pWiErYwFHV=_6kCdiyXZkT3QT6ef_UJagt9A@mail.gmail.com>
Accept-Language: en-US, ja-JP
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.34.125.150]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <44D254A2BDC35E41B1EA6CD19B17F3BF@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TM-AS-MML: disable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 20, 2019 at 03:03:55PM +0800, Wanpeng Li wrote:
> Cc Mel Gorman, Kirill, Dave Hansen,
> On Tue, 11 Jun 2019 at 07:51, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> >
> > On Wed, May 29, 2019 at 04:31:01PM -0700, Mike Kravetz wrote:
> > > On 5/28/19 2:49 AM, Wanpeng Li wrote:
> > > > Cc Paolo,
> > > > Hi all,
> > > > On Wed, 14 Feb 2018 at 06:34, Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > > >>
> > > >> On 02/12/2018 06:48 PM, Michael Ellerman wrote:
> > > >>> Andrew Morton <akpm@linux-foundation.org> writes:
> > > >>>
> > > >>>> On Thu, 08 Feb 2018 12:30:45 +0000 Punit Agrawal <punit.agrawal@arm.com> wrote:
> > > >>>>
> > > >>>>>>
> > > >>>>>> So I don't think that the above test result means that errors are properly
> > > >>>>>> handled, and the proposed patch should help for arm64.
> > > >>>>>
> > > >>>>> Although, the deviation of pud_huge() avoids a kernel crash the code
> > > >>>>> would be easier to maintain and reason about if arm64 helpers are
> > > >>>>> consistent with expectations by core code.
> > > >>>>>
> > > >>>>> I'll look to update the arm64 helpers once this patch gets merged. But
> > > >>>>> it would be helpful if there was a clear expression of semantics for
> > > >>>>> pud_huge() for various cases. Is there any version that can be used as
> > > >>>>> reference?
> > > >>>>
> > > >>>> Is that an ack or tested-by?
> > > >>>>
> > > >>>> Mike keeps plaintively asking the powerpc developers to take a look,
> > > >>>> but they remain steadfastly in hiding.
> > > >>>
> > > >>> Cc'ing linuxppc-dev is always a good idea :)
> > > >>>
> > > >>
> > > >> Thanks Michael,
> > > >>
> > > >> I was mostly concerned about use cases for soft/hard offline of huge pages
> > > >> larger than PMD_SIZE on powerpc.  I know that powerpc supports PGD_SIZE
> > > >> huge pages, and soft/hard offline support was specifically added for this.
> > > >> See, 94310cbcaa3c "mm/madvise: enable (soft|hard) offline of HugeTLB pages
> > > >> at PGD level"
> > > >>
> > > >> This patch will disable that functionality.  So, at a minimum this is a
> > > >> 'heads up'.  If there are actual use cases that depend on this, then more
> > > >> work/discussions will need to happen.  From the e-mail thread on PGD_SIZE
> > > >> support, I can not tell if there is a real use case or this is just a
> > > >> 'nice to have'.
> > > >
> > > > 1GB hugetlbfs pages are used by DPDK and VMs in cloud deployment, we
> > > > encounter gup_pud_range() panic several times in product environment.
> > > > Is there any plan to reenable and fix arch codes?
> > >
> > > I too am aware of slightly more interest in 1G huge pages.  Suspect that as
> > > Intel MMU capacity increases to handle more TLB entries there will be more
> > > and more interest.
> > >
> > > Personally, I am not looking at this issue.  Perhaps Naoya will comment as
> > > he know most about this code.
> >
> > Thanks for forwarding this to me, I'm feeling that memory error handling
> > on 1GB hugepage is demanded as real use case.
> >
> > >
> > > > In addition, https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kvm/mmu.c#n3213
> > > > The memory in guest can be 1GB/2MB/4K, though the host-backed memory
> > > > are 1GB hugetlbfs pages, after above PUD panic is fixed,
> > > > try_to_unmap() which is called in MCA recovery path will mark the PUD
> > > > hwpoison entry. The guest will vmexit and retry endlessly when
> > > > accessing any memory in the guest which is backed by this 1GB poisoned
> > > > hugetlbfs page. We have a plan to split this 1GB hugetblfs page by 2MB
> > > > hugetlbfs pages/4KB pages, maybe file remap to a virtual address range
> > > > which is 2MB/4KB page granularity, also split the KVM MMU 1GB SPTE
> > > > into 2MB/4KB and mark the offensive SPTE w/ a hwpoison flag, a sigbus
> > > > will be delivered to VM at page fault next time for the offensive
> > > > SPTE. Is this proposal acceptable?
> > >
> > > I am not sure of the error handling design, but this does sound reasonable.
> >
> > I agree that that's better.
> >
> > > That block of code which potentially dissolves a huge page on memory error
> > > is hard to understand and I'm not sure if that is even the 'normal'
> > > functionality.  Certainly, we would hate to waste/poison an entire 1G page
> > > for an error on a small subsection.
> >
> > Yes, that's not practical, so we need at first establish the code base for
> > 2GB hugetlb splitting and then extending it to 1GB next.
> 
> I found it is not easy to split. There is a unique hugetlb page size
> that is associated with a mounted hugetlbfs filesystem, file remap to
> 2MB/4KB will break this. How about hard offline 1GB hugetlb page as
> what has already done in soft offline, replace the corrupted 1GB page
> by new 1GB page through page migration, the offending/corrupted area
> in the original 1GB page doesn't need to be copied into the new page,
> the offending/corrupted area in new page can keep full zero just as it
> is clear during hugetlb page fault, other sub-pages of the original
> 1GB page can be freed to buddy system. The sigbus signal is sent to
> userspace w/ offending/corrupted virtual address, and signal code,
> userspace should take care this.

Splitting hugetlb is simply hard, IMHO. THP splitting is done by years
of effort by many great kernel develpers, and I don't think doing similar
development on hugetlb is a good idea.  I thought of converting hugetlb
into thp, but maybe it's not an easy task either.
"Hard offlining via soft offlining" approach sounds new and promising to me.
I guess we don't need a large patchset to do this. So, thanks for the idea!

- Naoya
