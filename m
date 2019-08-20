Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38BEF957CE
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 09:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbfHTHE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 03:04:27 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38429 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbfHTHE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 03:04:27 -0400
Received: by mail-ot1-f67.google.com with SMTP id r20so4100038ota.5;
        Tue, 20 Aug 2019 00:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k3Y+XVnvt7AU2ChE57m9qKA8qYR/u8KnDS7/D3UW/i8=;
        b=MSyMxEDmu1xQEQx3124prJwr4JdGq2H8W7B48jktxsNQnPT6bD8qXsv0Tok2UvLD1W
         Q42m23DCoxd51MypkIBVcTkxPZsW+g9LJpqN8x6rqV0SeAAaH0Jq6WP51nqP6nWb5rWS
         1raP2Rn0zpkErnXrGzOm9WeaLVmPkOKBuw8siG+MOS5yo91EJjSu8U0cStknC+mo2sAO
         rdKPGMqoR/wKV1QIwS/lDh17NZtrf9ZXT2M+HkIKqxZgRwE9DVsrCup+i2X8zXisA3xA
         A51aqdjRhxw7hUL2JTfrl12KF2cqDtfS6abm0uZMIfOSOaxDCagcU7JY1OUIzfzbEPrO
         AaDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k3Y+XVnvt7AU2ChE57m9qKA8qYR/u8KnDS7/D3UW/i8=;
        b=q72knGYQgFSspErPRd1f92EKPpGnGGweZeMLoBVKREkYqXrZdag+aPPNt3EJtsEaQx
         k+ucbwnSheDEoRDqf1acodIjCAFbr1sPALBPIqpXAdqDC08tg8nhD5H825PdjbDy7GYf
         4K/AmMXCjPPM5UsCUTNowDqa4F2m75GOlZFDuiHCHFscCzOJkNPLxfjIrnJOsin2c0Kn
         c55gsS9KyiR10o5W0dW8TARti6Xz5L32ROy36SVFltf62XOobEqtKphfWtncu6Yqjdqg
         41pM3usZqxeaN7pHh1mQxu0971hcTGPZh5t+VNEYq1kztZTyvRhF2xB0TPjt8mwrbZ3E
         +L8A==
X-Gm-Message-State: APjAAAU+ZL933L61rf+6RnwLZSZOBSrfuPMPDJ2w2TDxML8eisHtDBk6
        OY8q2tqXN2lDm7llj2wTDMr7CWhJPF/UrdRgToE=
X-Google-Smtp-Source: APXvYqwh2RLHYfC/r3CQ5ANL6XPMrctZkkd1kU4tgIF2w9uJaOw61hzE0NHEecCsclPkWpxjBr5OeSiWhK0KkpXOZa4=
X-Received: by 2002:a9d:674c:: with SMTP id w12mr17479137otm.118.1566284665544;
 Tue, 20 Aug 2019 00:04:25 -0700 (PDT)
MIME-Version: 1.0
References: <20180130013919.GA19959@hori1.linux.bs1.fc.nec.co.jp>
 <1517284444-18149-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <87inbbjx2w.fsf@e105922-lin.cambridge.arm.com> <20180207011455.GA15214@hori1.linux.bs1.fc.nec.co.jp>
 <87fu6bfytm.fsf@e105922-lin.cambridge.arm.com> <20180208121749.0ac09af2b5a143106f339f55@linux-foundation.org>
 <87wozhvc49.fsf@concordia.ellerman.id.au> <e673f38a-9e5f-21f6-421b-b3cb4ff02e91@oracle.com>
 <CANRm+CxAgWVv5aVzQ0wdP_A7QQgqfy7nN_SxyaactG7Mnqfr2A@mail.gmail.com>
 <f79d828c-b0b4-8a20-c316-a13430cfb13c@oracle.com> <20190610235045.GB30991@hori.linux.bs1.fc.nec.co.jp>
In-Reply-To: <20190610235045.GB30991@hori.linux.bs1.fc.nec.co.jp>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 20 Aug 2019 15:03:55 +0800
Message-ID: <CANRm+CwwPv52k7pWiErYwFHV=_6kCdiyXZkT3QT6ef_UJagt9A@mail.gmail.com>
Subject: Re: [PATCH v2] mm: hwpoison: disable memory error handling on 1GB hugepage
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

Cc Mel Gorman, Kirill, Dave Hansen,
On Tue, 11 Jun 2019 at 07:51, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
>
> On Wed, May 29, 2019 at 04:31:01PM -0700, Mike Kravetz wrote:
> > On 5/28/19 2:49 AM, Wanpeng Li wrote:
> > > Cc Paolo,
> > > Hi all,
> > > On Wed, 14 Feb 2018 at 06:34, Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > >>
> > >> On 02/12/2018 06:48 PM, Michael Ellerman wrote:
> > >>> Andrew Morton <akpm@linux-foundation.org> writes:
> > >>>
> > >>>> On Thu, 08 Feb 2018 12:30:45 +0000 Punit Agrawal <punit.agrawal@arm.com> wrote:
> > >>>>
> > >>>>>>
> > >>>>>> So I don't think that the above test result means that errors are properly
> > >>>>>> handled, and the proposed patch should help for arm64.
> > >>>>>
> > >>>>> Although, the deviation of pud_huge() avoids a kernel crash the code
> > >>>>> would be easier to maintain and reason about if arm64 helpers are
> > >>>>> consistent with expectations by core code.
> > >>>>>
> > >>>>> I'll look to update the arm64 helpers once this patch gets merged. But
> > >>>>> it would be helpful if there was a clear expression of semantics for
> > >>>>> pud_huge() for various cases. Is there any version that can be used as
> > >>>>> reference?
> > >>>>
> > >>>> Is that an ack or tested-by?
> > >>>>
> > >>>> Mike keeps plaintively asking the powerpc developers to take a look,
> > >>>> but they remain steadfastly in hiding.
> > >>>
> > >>> Cc'ing linuxppc-dev is always a good idea :)
> > >>>
> > >>
> > >> Thanks Michael,
> > >>
> > >> I was mostly concerned about use cases for soft/hard offline of huge pages
> > >> larger than PMD_SIZE on powerpc.  I know that powerpc supports PGD_SIZE
> > >> huge pages, and soft/hard offline support was specifically added for this.
> > >> See, 94310cbcaa3c "mm/madvise: enable (soft|hard) offline of HugeTLB pages
> > >> at PGD level"
> > >>
> > >> This patch will disable that functionality.  So, at a minimum this is a
> > >> 'heads up'.  If there are actual use cases that depend on this, then more
> > >> work/discussions will need to happen.  From the e-mail thread on PGD_SIZE
> > >> support, I can not tell if there is a real use case or this is just a
> > >> 'nice to have'.
> > >
> > > 1GB hugetlbfs pages are used by DPDK and VMs in cloud deployment, we
> > > encounter gup_pud_range() panic several times in product environment.
> > > Is there any plan to reenable and fix arch codes?
> >
> > I too am aware of slightly more interest in 1G huge pages.  Suspect that as
> > Intel MMU capacity increases to handle more TLB entries there will be more
> > and more interest.
> >
> > Personally, I am not looking at this issue.  Perhaps Naoya will comment as
> > he know most about this code.
>
> Thanks for forwarding this to me, I'm feeling that memory error handling
> on 1GB hugepage is demanded as real use case.
>
> >
> > > In addition, https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kvm/mmu.c#n3213
> > > The memory in guest can be 1GB/2MB/4K, though the host-backed memory
> > > are 1GB hugetlbfs pages, after above PUD panic is fixed,
> > > try_to_unmap() which is called in MCA recovery path will mark the PUD
> > > hwpoison entry. The guest will vmexit and retry endlessly when
> > > accessing any memory in the guest which is backed by this 1GB poisoned
> > > hugetlbfs page. We have a plan to split this 1GB hugetblfs page by 2MB
> > > hugetlbfs pages/4KB pages, maybe file remap to a virtual address range
> > > which is 2MB/4KB page granularity, also split the KVM MMU 1GB SPTE
> > > into 2MB/4KB and mark the offensive SPTE w/ a hwpoison flag, a sigbus
> > > will be delivered to VM at page fault next time for the offensive
> > > SPTE. Is this proposal acceptable?
> >
> > I am not sure of the error handling design, but this does sound reasonable.
>
> I agree that that's better.
>
> > That block of code which potentially dissolves a huge page on memory error
> > is hard to understand and I'm not sure if that is even the 'normal'
> > functionality.  Certainly, we would hate to waste/poison an entire 1G page
> > for an error on a small subsection.
>
> Yes, that's not practical, so we need at first establish the code base for
> 2GB hugetlb splitting and then extending it to 1GB next.

I found it is not easy to split. There is a unique hugetlb page size
that is associated with a mounted hugetlbfs filesystem, file remap to
2MB/4KB will break this. How about hard offline 1GB hugetlb page as
what has already done in soft offline, replace the corrupted 1GB page
by new 1GB page through page migration, the offending/corrupted area
in the original 1GB page doesn't need to be copied into the new page,
the offending/corrupted area in new page can keep full zero just as it
is clear during hugetlb page fault, other sub-pages of the original
1GB page can be freed to buddy system. The sigbus signal is sent to
userspace w/ offending/corrupted virtual address, and signal code,
userspace should take care this.

Regards,
Wanpeng Li
