Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2D9402DBC
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 19:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242414AbhIGRbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 13:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhIGRbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 13:31:12 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F32CC06175F
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 10:30:06 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g184so10750546pgc.6
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 10:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vjTxGNoImuIhDp4ZU4F0M0RmU0pYqlzioHk3BE15X7E=;
        b=VIPyCSzmwYwkIDNutJGP7K+imsB3i7QYdFqn0+uGDBW236ho9XuYGWGiP1RAjoB1lf
         ctXsE1WqK8PrhAiZ3tbDvD8FuAIYJHXtR9FpGrnfKcpRu2lmuyaOS4kR0ZIOE4+kQsPK
         6W2pE/oQ89Cw4XXELHjP+t/oo/AGpw7uDL8I430IUgrBhtdqrxGzjXjFybCUZWLX1pB8
         dz0991PR3zWwyb8kbw0zNnwSVPhZNH0fB7W2lekkaOt8LnlUJVl33Yh96QkR0UpZlwyN
         f8JgryVr371ehPSN01I1yVVU/FDVCOoMLY3svn+fws1L8zqbnE7ovKxbMoq0UIUNHz9m
         CUxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vjTxGNoImuIhDp4ZU4F0M0RmU0pYqlzioHk3BE15X7E=;
        b=YbwI+5ldlmW5VPLQVsxw+oKqls3v9F09iVsXVpfzoLoJD1PTIAQDbWN34gLo9mRVp9
         ZKlZ19t8eSFg3DMXqhJn36OwnSW2hSBPMmMDtQu2PqWjBUUMJfIQd7/nQFmTxlEo/jYP
         Idh2r73LWJ0PJd7JW0OTYqLiwsA8xGSCsLiDc1dhsu6pEDJI4qVsU4Nr4L75bWyTVhiI
         +CeWXmWZ024mayoEjvRCsUgMGwm+QC5Rpqscee3YFsCSVxuYLkQTHYQ1P+e4RmAmTo6/
         K/O19GvJ2x7rL2fIS5vXLP6WLLL9ZfncHyYRsizx0hrVnx6Inht04MRogXK/23G4i4iA
         YClg==
X-Gm-Message-State: AOAM532EMeGbxMovF3ktCxCkgzPc6YB70lZuhYPSq+59Z+fTwbIicdAg
        PE6iL/rgoINHbrGumpFlmuhyEA==
X-Google-Smtp-Source: ABdhPJyKlo8IrLZ+BrqkQVqfx9KP1qFCyHrsUDbyo/Kp7066B3hlJmtNpuKhC34LcIfk6Y+ll01mww==
X-Received: by 2002:a63:4610:: with SMTP id t16mr18030575pga.176.1631035805550;
        Tue, 07 Sep 2021 10:30:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c21sm11503205pfd.200.2021.09.07.10.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 10:30:05 -0700 (PDT)
Date:   Tue, 7 Sep 2021 17:30:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in memslot_rmap_alloc
Message-ID: <YTehmR1+G34uOHh3@google.com>
References: <0000000000006096fa05cb454a9c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000006096fa05cb454a9c@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Linus and Ben

On Sun, Sep 05, 2021, syzbot wrote:
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8419 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
> Modules linked in:
> CPU: 0 PID: 8419 Comm: syz-executor520 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597

...

> Call Trace:
>  kvmalloc include/linux/mm.h:806 [inline]
>  kvmalloc_array include/linux/mm.h:824 [inline]
>  kvcalloc include/linux/mm.h:829 [inline]
>  memslot_rmap_alloc+0xf6/0x310 arch/x86/kvm/x86.c:11320
>  kvm_alloc_memslot_metadata arch/x86/kvm/x86.c:11388 [inline]
>  kvm_arch_prepare_memory_region+0x48d/0x610 arch/x86/kvm/x86.c:11462
>  kvm_set_memslot+0xfe/0x1700 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1505
>  __kvm_set_memory_region+0x761/0x10e0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1668
>  kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1689 [inline]
>  kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1701 [inline]
>  kvm_vm_ioctl+0x4c6/0x2330 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4236

KVM is tripping the WARN_ON_ONCE(size > INT_MAX) added in commit 7661809d493b
("mm: don't allow oversized kvmalloc() calls").  The allocation size is absurd and
doomed to fail in this particular configuration (syzkaller is just throwing garbage
at KVM), but for humongous virtual machines it's feasible that KVM could run afoul
of the sanity check for an otherwise legitimate allocation.

The allocation in question is for KVM's "rmap" to translate a guest pfn to a host
virtual address.  The size of the rmap in question is an unsigned long per 4kb page
in a memslot, i.e. on x86-64, 8 bytes per 4096 bytes of guest memory in a memslot.
With INT_MAX=0x7fffffff, KVM will trip the WARN and fail rmap allocations for
memslots >= 1tb, and Google already has VMs that create 1.5tb memslots (12tb of
total guest memory spread across 8 virtual NUMA nodes).

One caveat is that KVM's newfangled "TDP MMU" was designed specifically to avoid
the rmap allocation (among other things), precisely because of its scalability
issues.  I.e. it's unlikely KVM's so called "legacy MMU" that relies on the rmaps
would be used for such large VMs.  However, KVM's legacy MMU is still the only option
for shadowing nested EPT/NPT, i.e. the rmap allocation would be problematic if/when
nested virtualization is enabled in large VMs.

KVM also has other allocations based on memslot size that are _not_ avoided by KVM's
TDP MMU and may eventually be problematic, though presumably not for quite some time
as it would require petabyte? memslots.  E.g. a different metadata array requires
4 bytes per 2mb of guest memory.

I don't have any clever ideas to handle this from the KVM side, at least not in the
short term.  Long term, I think it would be doable to reduce the rmap size for large
memslots by 512x, but any change of that nature would be very invasive to KVM and
be fairly risky.  It also wouldn't prevent syskaller from triggering this WARN at will.
