Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D48166612
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 19:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgBTSRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 13:17:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22249 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726959AbgBTSRV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 13:17:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582222638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7gBF2N544JSN/FzCwCeXpyEHqdoVMntz2vXwRjWtmEI=;
        b=ajwPO9wXl6W8liQ3QrUDNyLCpleLbAoYrrUtGLHsFlbBIwlWUio9CA33z3mOtRNY3ZxJDm
        BM7UC1idawD4NxR5MlS4SAiEV6jQPkqhk1v0f+FhSihaasd0EkTgeKBbm+ZQ7WUBVlT+o1
        hKuSNkqcAGfvE34kIvELpI6rIzTLF4A=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-AXqvG1aPP262NDLXmC2Ing-1; Thu, 20 Feb 2020 13:17:12 -0500
X-MC-Unique: AXqvG1aPP262NDLXmC2Ing-1
Received: by mail-qv1-f70.google.com with SMTP id dr18so3147357qvb.14
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 10:17:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7gBF2N544JSN/FzCwCeXpyEHqdoVMntz2vXwRjWtmEI=;
        b=FF8QkLJj4MOCpzoalyF6w5ThYeyg8Hahtifc3HKhNtQX+MWRb2y9rvFTnP6g2t2zyN
         sBCs0+Lzexfl7Z1LgBLKWabvp53Zk3/cBwEE701UFzsg5pNzGr825+6ikqSK5B0NHkLV
         8mkDYRGE4AbWBYJDokk2noPig0NqXQ9Qs2XuL/tXErA+/cXz8PsMtvTH+YFHmxr+1RMa
         s2SnBNs5/cnkJefDIleH+YP5roSop4kWGgGjBQjuxm6AU2GRYrwz9hXZGZyzkuVeH0FO
         w3hhed1013gZpavJb8YwKli6dpq1hIB9plfv54pIK6ueJ5mnWuGhIZssUThYGmVC7VBL
         PxQA==
X-Gm-Message-State: APjAAAVK/ucBOKxU2w0jtpb0NFNGCTmTknU5f7AfHHVb29WoEnyx8DH1
        ukY/8INy/V9pbQtCzrE85suI7Jm2I0kNH3VggAfnWr++3u04NqC8ZNbuwmJWLpHfZIWXfhc/OS5
        uL3v9WISQxKJc
X-Received: by 2002:ac8:7357:: with SMTP id q23mr27542944qtp.12.1582222631387;
        Thu, 20 Feb 2020 10:17:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqwT0HHbreNyVDlJS26f97XEMXnHSFkHwOsSV8EcdlPgss+q/+5S5IeR5NHI/m4ACr8pZbsqqA==
X-Received: by 2002:ac8:7357:: with SMTP id q23mr27542919qtp.12.1582222631052;
        Thu, 20 Feb 2020 10:17:11 -0800 (PST)
Received: from xz-x1 ([104.156.64.75])
        by smtp.gmail.com with ESMTPSA id b84sm182610qkc.73.2020.02.20.10.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 10:17:09 -0800 (PST)
Date:   Thu, 20 Feb 2020 13:17:08 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>,
        Junaid Shahid <junaids@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "quintela@redhat.com" <quintela@redhat.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>
Subject: Re: RFC: Split EPT huge pages in advance of dirty logging
Message-ID: <20200220181708.GE2905@xz-x1>
References: <B2D15215269B544CADD246097EACE7474BAF9AB6@DGGEMM528-MBX.china.huawei.com>
 <20200218174311.GE1408806@xz-x1>
 <B2D15215269B544CADD246097EACE7474BAFF835@DGGEMM528-MBX.china.huawei.com>
 <20200219171919.GA34517@xz-x1>
 <B2D15215269B544CADD246097EACE7474BB03772@DGGEMM528-MBX.china.huawei.com>
 <CANgfPd-P_=GqcMiwLSSkUhZDt42aMLUsCJt+CPdUN5yR3RLHmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANgfPd-P_=GqcMiwLSSkUhZDt42aMLUsCJt+CPdUN5yR3RLHmQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 09:34:52AM -0800, Ben Gardon wrote:
> On Thu, Feb 20, 2020 at 5:53 AM Zhoujian (jay) <jianjay.zhou@huawei.com> wrote:
> >
> >
> >
> > > -----Original Message-----
> > > From: Peter Xu [mailto:peterx@redhat.com]
> > > Sent: Thursday, February 20, 2020 1:19 AM
> > > To: Zhoujian (jay) <jianjay.zhou@huawei.com>
> > > Cc: kvm@vger.kernel.org; qemu-devel@nongnu.org; pbonzini@redhat.com;
> > > dgilbert@redhat.com; quintela@redhat.com; Liujinsong (Paul)
> > > <liu.jinsong@huawei.com>; linfeng (M) <linfeng23@huawei.com>; wangxin (U)
> > > <wangxinxin.wang@huawei.com>; Huangweidong (C)
> > > <weidong.huang@huawei.com>
> > > Subject: Re: RFC: Split EPT huge pages in advance of dirty logging
> > >
> > > On Wed, Feb 19, 2020 at 01:19:08PM +0000, Zhoujian (jay) wrote:
> > > > Hi Peter,
> > > >
> > > > > -----Original Message-----
> > > > > From: Peter Xu [mailto:peterx@redhat.com]
> > > > > Sent: Wednesday, February 19, 2020 1:43 AM
> > > > > To: Zhoujian (jay) <jianjay.zhou@huawei.com>
> > > > > Cc: kvm@vger.kernel.org; qemu-devel@nongnu.org;
> > > pbonzini@redhat.com;
> > > > > dgilbert@redhat.com; quintela@redhat.com; Liujinsong (Paul)
> > > > > <liu.jinsong@huawei.com>; linfeng (M) <linfeng23@huawei.com>;
> > > > > wangxin (U) <wangxinxin.wang@huawei.com>; Huangweidong (C)
> > > > > <weidong.huang@huawei.com>
> > > > > Subject: Re: RFC: Split EPT huge pages in advance of dirty logging
> > > > >
> > > > > On Tue, Feb 18, 2020 at 01:13:47PM +0000, Zhoujian (jay) wrote:
> > > > > > Hi all,
> > > > > >
> > > > > > We found that the guest will be soft-lockup occasionally when live
> > > > > > migrating a 60 vCPU, 512GiB huge page and memory sensitive VM. The
> > > > > > reason is clear, almost all of the vCPUs are waiting for the KVM
> > > > > > MMU spin-lock to create 4K SPTEs when the huge pages are write
> > > > > > protected. This
> > > > > phenomenon is also described in this patch set:
> > > > > > https://patchwork.kernel.org/cover/11163459/
> > > > > > which aims to handle page faults in parallel more efficiently.
> > > > > >
> > > > > > Our idea is to use the migration thread to touch all of the guest
> > > > > > memory in the granularity of 4K before enabling dirty logging. To
> > > > > > be more specific, we split all the PDPE_LEVEL SPTEs into
> > > > > > DIRECTORY_LEVEL SPTEs as the first step, and then split all the
> > > > > > DIRECTORY_LEVEL SPTEs into
> > > > > PAGE_TABLE_LEVEL SPTEs as the following step.
> > > > >
> > > > > IIUC, QEMU will prefer to use huge pages for all the anonymous
> > > > > ramblocks (please refer to ram_block_add):
> > > > >
> > > > >         qemu_madvise(new_block->host, new_block->max_length,
> > > > > QEMU_MADV_HUGEPAGE);
> > > >
> > > > Yes, you're right
> > > >
> > > > >
> > > > > Another alternative I can think of is to add an extra parameter to
> > > > > QEMU to explicitly disable huge pages (so that can even be
> > > > > MADV_NOHUGEPAGE instead of MADV_HUGEPAGE).  However that
> > > should also
> > > > > drag down the performance for the whole lifecycle of the VM.
> > > >
> > > > From the performance point of view, it is better to keep the huge
> > > > pages when the VM is not in the live migration state.
> > > >
> > > > > A 3rd option is to make a QMP
> > > > > command to dynamically turn huge pages on/off for ramblocks globally.
> > > >
> > > > We're searching a dynamic method too.
> > > > We plan to add two new flags for each memory slot, say
> > > > KVM_MEM_FORCE_PT_DIRECTORY_PAGES and
> > > > KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES. These flags can be set through
> > > > KVM_SET_USER_MEMORY_REGION ioctl.

[1]

> > > >
> > > > The mapping_level which is called by tdp_page_fault in the kernel side
> > > > will return PT_DIRECTORY_LEVEL if the
> > > KVM_MEM_FORCE_PT_DIRECTORY_PAGES
> > > > flag of the memory slot is set, and return PT_PAGE_TABLE_LEVEL if the
> > > > KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES flag is set.
> > > >
> > > > The key steps to split the huge pages in advance of enabling dirty log
> > > > is as follows:
> > > > 1. The migration thread in user space uses
> > > KVM_SET_USER_MEMORY_REGION
> > > > ioctl to set the KVM_MEM_FORCE_PT_DIRECTORY_PAGES flag for each
> > > memory
> > > > slot.
> > > > 2. The migration thread continues to use the KVM_SPLIT_HUGE_PAGES
> > > > ioctl (which is newly added) to do the splitting of large pages in the
> > > > kernel side.
> > > > 3. A new vCPU is created temporally(do some initialization but will
> > > > not
> > > > run) to help to do the work, i.e. as the parameter of the tdp_page_fault.
> > > > 4. Collect the GPA ranges of all the memory slots with the
> > > > KVM_MEM_FORCE_PT_DIRECTORY_PAGES flag set.
> > > > 5. Split the 1G huge pages(collected in step 4) into 2M by calling
> > > > tdp_page_fault, since the mapping_level will return
> > > > PT_DIRECTORY_LEVEL. Here is the main difference from the usual path
> > > > which is caused by the Guest side(EPT violation/misconfig etc), we
> > > > call it directly in the hypervisor side.
> > > > 6. Do some cleanups, i.e. free the vCPU related resources 7. The
> > > > KVM_SPLIT_HUGE_PAGES ioctl returned to the user space side.
> > > > 8. Using KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES instread of
> > > > KVM_MEM_FORCE_PT_DIRECTORY_PAGES to repeat step 1 ~ step 7, in step
> > > 5
> > > > the 2M huge pages will be splitted into 4K pages.
> > > > 9. Clear the KVM_MEM_FORCE_PT_DIRECTORY_PAGES and
> > > > KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES flags for each memory slot.
> > > > 10. Then the migration thread calls the log_start ioctl to enable the
> > > > dirty logging, and the remaining thing is the same.
> > >
> > > I'm not sure... I think it would be good if there is a way to have finer granularity
> > > control on using huge pages for any process, then KVM can directly leverage
> > > that because KVM page tables should always respect the mm configurations on
> > > these (so e.g. when huge page split, KVM gets notifications via mmu notifiers).
> > > Have you thought of such a more general way?
> >
> > I did have thought of this, if we split the huge pages into 4K of a process, I'm
> > afraid it will not be workable for the huge pages sharing scenario, e.g. DPDK,
> > SPDK etc. So, only split the EPT page table and keep the VM process page table
> > (e.g. qemu) untouched is the goal.

Ah I see your point now.

> >
> > >
> > > (And I just noticed that MADV_NOHUGEPAGE is only a hint to khugepaged
> > > and probably won't split any huge page at all after madvise() returns..)
> > > To tell the truth I'm still confused on how split of huge pages helped in your
> > > case...
> >
> > I'm sorry if the meaning is not expressed clearly, and thanks for your patience.
> >
> > > If I read it right the test reduced some execution time from 9s to a
> > > few ms after your splittion of huge pages.
> >
> > Yes
> >
> > > The thing is I don't see how split of
> > > huge pages could solve the mmu_lock contention with the huge VM, because
> > > IMO even if we split the huge pages into smaller ones, those pages should still
> > > be write-protected and need merely the same number of page faults to resolve
> > > when accessed/written? And I thought that should only be fixed with
> > > solutions like what Ben has proposed with the MMU rework. Could you show
> > > me what I've missed?
> >
> > Let me try to describe the reason of mmu_lock contention more clearly and the
> > effort we tried to do...
> > The huge VM only has EPT >= level 2 sptes, and level 1 sptes don't
> > exist at the beginning. Write protect all the huge pages will trigger EPT
> > violation to create level 1 sptes for all the vCPUs which want to write the
> > content of the memory. Different vCPU write the different areas of
> > the memory, but they need the same kvm->mmu_lock to create the level 1
> > sptes, this situation will be worse if the number of vCPU and the memory of
> > VM is large(in our case 60U512G), meanwhile the VM has
> > memory-write-intensive work to do. In order to reduce the mmu_lock
> > contention, we try to: write protect VM memory gradually in small chunks,
> > such as 1G or 2M. Using a vCPU temporary creately by migration thread to
> > split 1G to 2M as the first step, and to split 2M to 4K as the second step
> > (this is a little hacking...and I do not know any side effect will be triggered
> > indeed).
> > Comparing to write protect all VM memory in one go, the write
> > protected range is limited in this way and only the vCPUs write this limited
> > range will be involved to take the mmu_lock. The contention will be reduced
> > since the memory range is small and the number of vCPU involved is small
> > too.
> >
> > Of course, it will take some extra time to split all the huge pages into 4K
> > page before the real migration started, about 60s for 512G in my experiment.
> >
> > During the memory iterative copy phase, PML will do the dirty logging work
> > (not write protected case for 4K), or IIRC using fast_page_fault to mark page
> > dirty if PML is not supported, which case the mmu_lock does not needed.

Yes I missed both of these.  Thanks for explaining!

Then it makes sense at least to me with your idea. Though instead of
the KVM_MEM_FORCE_PT_* naming [1], we can also embed allowed page
sizes for the memslot into the flags using a few bits, with another
new kvm cap.

> >
> > Regards,
> > Jay Zhou
> 
> (Ah I top-posted I'm sorry. Re-sending at the bottom.)
> 
> FWIW, we currently do this eager splitting at Google for live
> migration. When the log-dirty-memory flag is set on a memslot we
> eagerly split all pages in the slot down to 4k granularity.
> As Jay said, this does not cause crippling lock contention because the
> vCPU page faults generated by write protection / splitting can be
> resolved in the fast page fault path without acquiring the MMU lock.
> I believe +Junaid Shahid tried to upstream this approach at some point
> in the past, but the patch set didn't make it in. (This was before my
> time, so I'm hoping he has a link.)
> I haven't done the analysis to know if eager splitting is more or less
> efficient with parallel slow-path page faults, but it's definitely
> faster under the MMU lock.

Yes, totally agreed.  Though comparing to eager splitting (which might
still need a new capabilility for the changed behavior after all, not
sure...), the per-memslot hint solution looks slightly nicer to me,
imho, because it can offer more mechanism than policy.

Thanks,

-- 
Peter Xu

