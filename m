Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11422164BB4
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 18:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgBSRTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 12:19:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33698 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726514AbgBSRTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 12:19:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582132769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dK5oOLaqiDs2fEfuCHWpgQxQmx/QeSFAmRxrjHBhE/s=;
        b=ICiaIWnClh2N8G0yYoOJkglVlg+4RW3sBKcUM9f18QnGDhpZYJXjY07XoxgiUPkPhgd+CP
        hiOTTvs2yAqxBMfPat8VKlH62QVjjE6Q+tWg/hGxH2vPK8aBzMwN8BEE5fLeNvP+Wo9Hb1
        DGK/aI+J+YWLM14bjJkFqPLrw9DBw78=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-BDNuLFR_MO-AhBvo4zLZWQ-1; Wed, 19 Feb 2020 12:19:24 -0500
X-MC-Unique: BDNuLFR_MO-AhBvo4zLZWQ-1
Received: by mail-qv1-f72.google.com with SMTP id dc2so681753qvb.7
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 09:19:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dK5oOLaqiDs2fEfuCHWpgQxQmx/QeSFAmRxrjHBhE/s=;
        b=KhLZjHR8zcNo2BQu/9ZgmdbN5rGTxy+ohEQJjMc7YK4X1qEjTdSqPzFwdLrj6eEIwm
         DlpFIPqt3JxCM2Ss3PI/klWioRX1agWT40yZ3seNMrGU0DpvFOzbY7p7UPpmGqbqByfO
         B8SborpNaZyuQ4YtxQ3wBBAJf7f8CD3WHy49X56LzJCBdhdcxY3dlSKb0d0yZHrLKkXY
         KSqphYM+huf20n/M8gpRQ+OoZEFrU1bewmhRo6fzXXNA0/ZHzn4XIog+JX8e8b6yXqll
         yXG0ndHbypGTHBHlxTvghMA1SxUbi38l+uqImnWuUvEfYNGMq3hdAobIh7aAl8C0otKi
         LaNQ==
X-Gm-Message-State: APjAAAW1MEg17eNmzed18Sm8JbSkrxn6JtxoGZE+wlUKgeRVBS+/50xP
        jl7JmYnt1jFh3TVy8R8S8ZReSvzpSjFSU6nq6RMnN2Z+lC7JaSbCulhB7u0QHobzDtiFr7+sJdN
        skbzrDjDE0IYK
X-Received: by 2002:a05:620a:63b:: with SMTP id 27mr23161554qkv.159.1582132763764;
        Wed, 19 Feb 2020 09:19:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqxjcYtGtErtygtf/94adebcA0XUns/LqaLGr58X6868SWjYDieDU8xN3zP9HIa6rCVTekPAxw==
X-Received: by 2002:a05:620a:63b:: with SMTP id 27mr23161535qkv.159.1582132763441;
        Wed, 19 Feb 2020 09:19:23 -0800 (PST)
Received: from xz-x1 ([104.156.64.75])
        by smtp.gmail.com with ESMTPSA id z21sm131280qka.122.2020.02.19.09.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 09:19:22 -0800 (PST)
Date:   Wed, 19 Feb 2020 12:19:19 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "quintela@redhat.com" <quintela@redhat.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>
Subject: Re: RFC: Split EPT huge pages in advance of dirty logging
Message-ID: <20200219171919.GA34517@xz-x1>
References: <B2D15215269B544CADD246097EACE7474BAF9AB6@DGGEMM528-MBX.china.huawei.com>
 <20200218174311.GE1408806@xz-x1>
 <B2D15215269B544CADD246097EACE7474BAFF835@DGGEMM528-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B2D15215269B544CADD246097EACE7474BAFF835@DGGEMM528-MBX.china.huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 01:19:08PM +0000, Zhoujian (jay) wrote:
> Hi Peter,
> 
> > -----Original Message-----
> > From: Peter Xu [mailto:peterx@redhat.com]
> > Sent: Wednesday, February 19, 2020 1:43 AM
> > To: Zhoujian (jay) <jianjay.zhou@huawei.com>
> > Cc: kvm@vger.kernel.org; qemu-devel@nongnu.org; pbonzini@redhat.com;
> > dgilbert@redhat.com; quintela@redhat.com; Liujinsong (Paul)
> > <liu.jinsong@huawei.com>; linfeng (M) <linfeng23@huawei.com>; wangxin (U)
> > <wangxinxin.wang@huawei.com>; Huangweidong (C)
> > <weidong.huang@huawei.com>
> > Subject: Re: RFC: Split EPT huge pages in advance of dirty logging
> > 
> > On Tue, Feb 18, 2020 at 01:13:47PM +0000, Zhoujian (jay) wrote:
> > > Hi all,
> > >
> > > We found that the guest will be soft-lockup occasionally when live
> > > migrating a 60 vCPU, 512GiB huge page and memory sensitive VM. The
> > > reason is clear, almost all of the vCPUs are waiting for the KVM MMU
> > > spin-lock to create 4K SPTEs when the huge pages are write protected. This
> > phenomenon is also described in this patch set:
> > > https://patchwork.kernel.org/cover/11163459/
> > > which aims to handle page faults in parallel more efficiently.
> > >
> > > Our idea is to use the migration thread to touch all of the guest
> > > memory in the granularity of 4K before enabling dirty logging. To be
> > > more specific, we split all the PDPE_LEVEL SPTEs into DIRECTORY_LEVEL
> > > SPTEs as the first step, and then split all the DIRECTORY_LEVEL SPTEs into
> > PAGE_TABLE_LEVEL SPTEs as the following step.
> > 
> > IIUC, QEMU will prefer to use huge pages for all the anonymous ramblocks
> > (please refer to ram_block_add):
> > 
> >         qemu_madvise(new_block->host, new_block->max_length,
> > QEMU_MADV_HUGEPAGE);
> 
> Yes, you're right
> 
> > 
> > Another alternative I can think of is to add an extra parameter to QEMU to
> > explicitly disable huge pages (so that can even be MADV_NOHUGEPAGE
> > instead of MADV_HUGEPAGE).  However that should also drag down the
> > performance for the whole lifecycle of the VM.  
> 
> From the performance point of view, it is better to keep the huge pages
> when the VM is not in the live migration state.
> 
> > A 3rd option is to make a QMP
> > command to dynamically turn huge pages on/off for ramblocks globally.
> 
> We're searching a dynamic method too.
> We plan to add two new flags for each memory slot, say
> KVM_MEM_FORCE_PT_DIRECTORY_PAGES and
> KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES. These flags can be set
> through KVM_SET_USER_MEMORY_REGION ioctl.
> 
> The mapping_level which is called by tdp_page_fault in the kernel side
> will return PT_DIRECTORY_LEVEL if the
> KVM_MEM_FORCE_PT_DIRECTORY_PAGES flag of the memory slot is
> set, and return PT_PAGE_TABLE_LEVEL if the
> KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES flag is set.
>  
> The key steps to split the huge pages in advance of enabling dirty log is
> as follows:
> 1. The migration thread in user space uses
> KVM_SET_USER_MEMORY_REGION ioctl to set the
> KVM_MEM_FORCE_PT_DIRECTORY_PAGES flag for each memory slot.
> 2. The migration thread continues to use the KVM_SPLIT_HUGE_PAGES
> ioctl (which is newly added) to do the splitting of large pages in the
> kernel side.
> 3. A new vCPU is created temporally(do some initialization but will not
> run) to help to do the work, i.e. as the parameter of the tdp_page_fault.
> 4. Collect the GPA ranges of all the memory slots with the
> KVM_MEM_FORCE_PT_DIRECTORY_PAGES flag set.
> 5. Split the 1G huge pages(collected in step 4) into 2M by calling
> tdp_page_fault, since the mapping_level will return
> PT_DIRECTORY_LEVEL. Here is the main difference from the usual
> path which is caused by the Guest side(EPT violation/misconfig etc),
> we call it directly in the hypervisor side.
> 6. Do some cleanups, i.e. free the vCPU related resources
> 7. The KVM_SPLIT_HUGE_PAGES ioctl returned to the user space side.
> 8. Using KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES instread of
> KVM_MEM_FORCE_PT_DIRECTORY_PAGES to repeat step 1 ~ step 7,
> in step 5 the 2M huge pages will be splitted into 4K pages.
> 9. Clear the KVM_MEM_FORCE_PT_DIRECTORY_PAGES and
> KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES flags for each memory slot.
> 10. Then the migration thread calls the log_start ioctl to enable the dirty
> logging, and the remaining thing is the same.

I'm not sure... I think it would be good if there is a way to have
finer granularity control on using huge pages for any process, then
KVM can directly leverage that because KVM page tables should always
respect the mm configurations on these (so e.g. when huge page split,
KVM gets notifications via mmu notifiers).  Have you thought of such a
more general way?

(And I just noticed that MADV_NOHUGEPAGE is only a hint to khugepaged
 and probably won't split any huge page at all after madvise() returns..)

To tell the truth I'm still confused on how split of huge pages helped
in your case...  If I read it right the test reduced some execution
time from 9s to a few ms after your splittion of huge pages.  The
thing is I don't see how split of huge pages could solve the mmu_lock
contention with the huge VM, because IMO even if we split the huge
pages into smaller ones, those pages should still be write-protected
and need merely the same number of page faults to resolve when
accessed/written?  And I thought that should only be fixed with
solutions like what Ben has proposed with the MMU rework. Could you
show me what I've missed?

Thanks,

-- 
Peter Xu

