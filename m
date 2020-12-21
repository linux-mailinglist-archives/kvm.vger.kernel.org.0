Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4FF2E0135
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 20:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgLUTmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 14:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgLUTmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 14:42:32 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DA2C0613D6
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 11:41:51 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id f14so8787pju.4
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 11:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qW/eGOHefr7u3yGewLONpfyTMK6vr0UpqPOgffa2C+8=;
        b=caz4eWoFVIQeRzGTGTzgH0YV5LQ/fypaTTTsSgr6PaXlk6T3QyE+pi2iduz7le2QpV
         C6jhDwnoRLSDbS2f4ZYMb8LioC4AgJJRDx6eHgYPpIVDtBrlUCPcqHnzALtGdc3xgtyy
         l9uFyqxddjWZbu9kVuU9XgxE4VGa93kpnpEuKUuYRko0ecposdfZ6H7pcwdcBUSQtix+
         FOtHqEgVC/4DXdaMoLkt6GlS37855cdJFmDrBDxfcgWxk1imDCivMAZ6dFLRdP1GZ0Df
         Sa8lamvcTWgmYKphgoJ4BuL1/bmpZlORBq1rScX89pEkym7pTpRbAztPfgztGXRHfaCR
         Sb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qW/eGOHefr7u3yGewLONpfyTMK6vr0UpqPOgffa2C+8=;
        b=E79WW9t3i1v2YqbBAvbvNG5yaZBQVrsE9zin7gOVHV/LGQrqMNO0NIkklR87kEzQva
         RrV2zp1/8rAs3w4oQKARVU4e8OW6sCUoEPBCAid/K2K1UQFCUVOL0mMK8ibbwQpuh5E3
         uJimYeQklfx0QlULYZV3Du2txo8h+ysYHGHwZSDUARC7cG+Ko/Z/DseSrt2WHHNUdbSK
         dDZvUjJApSP3V1/z9rUGJM2OxCogWXHvpMy4ZfZXTeIFvOlCsJOiwhVPKX8AgJ3tZoJl
         rYvkHlhikz8tOAP8bHhSkEURttJg9xM4D0akxUKhAHxRHv5cdeG/qM+w5qsIW/gWq/f5
         k1OQ==
X-Gm-Message-State: AOAM5304hJw+T8bv5EXcjlSgP+dgpbrAx15GnI8DnpQcOjny93abVAbR
        hZawqpcIZtzLj0jWg9DATP0Exw==
X-Google-Smtp-Source: ABdhPJyCXE5PAYmV/Pqax5PWeMAY55g83Ee0qTei1C+sDt8AQiPJZ5vQebCA0dDeBdfc9/c2E8yOhA==
X-Received: by 2002:a17:90a:1b29:: with SMTP id q38mr18599692pjq.223.1608579711176;
        Mon, 21 Dec 2020 11:41:51 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 14sm15191115pfi.131.2020.12.21.11.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:41:50 -0800 (PST)
Date:   Mon, 21 Dec 2020 11:41:44 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Bad performance since 5.9-rc1
Message-ID: <X+D6eJn92Vt6v+U1@google.com>
References: <20201119040526.5263f557.zkaspar82@gmail.com>
 <20201201073537.6749e2d7.zkaspar82@gmail.com>
 <20201218203310.5025c17e.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218203310.5025c17e.zkaspar82@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 18, 2020, Zdenek Kaspar wrote:
> > without: kvm: x86/mmu: Fix get_mmio_spte() on CPUs supporting 5-level
> > PT I can run guest again, but with degraded performance as before.
> > 
> > Z.
> 
> With: KVM: x86/mmu: Bug fixes and cleanups in get_mmio_spte() series

Apologies, I completely missed your bug report for the get_mmio_spte() bugs.

> I can run guest again and performance is slightly better:
> 
> v5.8:        0m13.54s real     0m10.51s user     0m10.96s system
> v5.9:        6m20.07s real    11m42.93s user     0m13.57s system
> v5.10+fixes: 5m50.77s real    10m38.29s user     0m15.96s system
> 
> perf top from host when guest (openbsd) is compiling:
>   26.85%  [kernel]                  [k] queued_spin_lock_slowpath
>    8.49%  [kvm]                     [k] mmu_page_zap_pte
>    7.47%  [kvm]                     [k] __kvm_mmu_prepare_zap_page
>    3.61%  [kernel]                  [k] clear_page_rep
>    2.43%  [kernel]                  [k] page_counter_uncharge
>    2.30%  [kvm]                     [k] paging64_page_fault
>    2.03%  [kvm_intel]               [k] vmx_vcpu_run
>    2.02%  [kvm]                     [k] kvm_vcpu_gfn_to_memslot
>    1.95%  [kernel]                  [k] internal_get_user_pages_fast
>    1.64%  [kvm]                     [k] kvm_mmu_get_page
>    1.55%  [kernel]                  [k] page_counter_try_charge
>    1.33%  [kernel]                  [k] propagate_protected_usage
>    1.29%  [kvm]                     [k] kvm_arch_vcpu_ioctl_run
>    1.13%  [kernel]                  [k] get_page_from_freelist
>    1.01%  [kvm]                     [k] paging64_walk_addr_generic
>    0.83%  [kernel]                  [k] ___slab_alloc.constprop.0
>    0.83%  [kernel]                  [k] kmem_cache_free
>    0.82%  [kvm]                     [k] __pte_list_remove
>    0.77%  [kernel]                  [k] try_grab_compound_head
>    0.76%  [kvm_intel]               [k] 0x000000000001cfa0
>    0.74%  [kvm]                     [k] pte_list_add

Can you try running with this debug hack to understand what is causing KVM to
zap shadow pages?  The expected behavior is that you'll get backtraces for the
first five cases where KVM zaps valid shadow pages.  Compile tested only.


diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5dfe0ede0e81..c5da993ac753 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2404,6 +2404,8 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
        }
 }

+static unsigned long zapped_warns;
+
 static unsigned long kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm,
                                                  unsigned long nr_to_zap)
 {
@@ -2435,6 +2437,8 @@ static unsigned long kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm,
                        goto restart;
        }

+       WARN_ON(total_zapped && zapped_warns++ < 5);
+
        kvm_mmu_commit_zap_page(kvm, &invalid_list);

        kvm->stat.mmu_recycled += total_zapped;
