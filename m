Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC59470FE6
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 02:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243033AbhLKBi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 20:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbhLKBi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 20:38:28 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCCEC061714
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 17:34:52 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id b40so21046092lfv.10
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 17:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TOvVwZI+n7rMSHzNUUeqGf9c0ojUiZDkBSpGrHu+lT8=;
        b=M3V0flEeH+d++9Ibp77c/GPsLlDSDufPl02AeZy+g3YV10EEnHoKePOgf7/Qho9aA9
         8kf6+MgPjv79AjhLDLCnXpoqJ+KLI/DYjo3Ybr4k8u6Yxv4Tno+BltmJHpt/o9Fblhzn
         J8imbFvXlAtXr4iMSh9r4QN9ZRacDxAOPDfP4c/qidYQ+fG02A55841Fw4M41MizkymQ
         yOCtkU0vpDGZajhWvs7F+a2M5Y6aMgawBIbpJ1ndFsv/MpE8//3O/n+OAGyxY4RXCEXh
         AwbP2KkQTNM6Lkva8oh5DKNiVGJNXDujTFihjoSTf6xTs8GHd0VEp2dYDh/ERrYQDDMl
         54ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TOvVwZI+n7rMSHzNUUeqGf9c0ojUiZDkBSpGrHu+lT8=;
        b=ucVIV1hRvY8SXWPZLdjg1j261TM6UOf7yfNm+zQQ4pAXHaSCj6skceD4mQqYN3zDrz
         wNI1l1n2dy6v06IESi6obBaSioDd4hCWvszCm0vjA6zS4dGijZqRSUYCVe9lbeV1rW56
         AFma+XqEZ1i5xWRDpShEWtf1BVJ8eMKSvGC+veizdd3I8KCLj83AnbRrkiX2NJrSqaDG
         g5ZYR5h/pIs47ahyZeNHNNKTzW4SGNAcUA2GWLCxC3+/lRcZnOYiaFTig+u94ixxWkF0
         hbE8+B07NrMjm9nTMePY+lhJqHWnx5s12LG8rBEUHVHi/3WG547Sm5RT0DPtKTY2GQIs
         gLiw==
X-Gm-Message-State: AOAM532C5mivGDMI6AEmuVP40d1CjSK5o4DzAxP4t6Biz1OfJnkFKOlu
        7PI5eGQ+eXvyOjbrl6vR+xIPLFCHVMC+YGhixOwtCTMa5py8Fw==
X-Google-Smtp-Source: ABdhPJyxbYooP59L420/O7vzJbPIQscieY8EbQ78uB2/RoaZhmPTdB7FNwK9gYohTyKajVowuHBkuZqdyC1ITGT6BwY=
X-Received: by 2002:a05:6512:11e5:: with SMTP id p5mr15217400lfs.537.1639186490842;
 Fri, 10 Dec 2021 17:34:50 -0800 (PST)
MIME-Version: 1.0
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com> <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <YaaIRv0n2E8F5YpX@google.com> <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
 <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
In-Reply-To: <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 10 Dec 2021 17:34:23 -0800
Message-ID: <CALzav=fyaXAn4CLRW2qKTrROGUh6+F4bphhfoMZ13Qp5Njx3gw@mail.gmail.com>
Subject: Re: Potential bug in TDP MMU
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 caOn Fri, Dec 10, 2021 at 3:05 PM Ignat Korchagin <ignat@cloudflare.com> wrote:
>
> I've been trying to figure out the difference between "good" runs and
> "bad" runs of gvisor. So, if I've been running the following bpftrace
> onliner:
>
> $ bpftrace -e 'kprobe:kvm_set_pfn_dirty { @[kstack] = count(); }'
>
> while also executing a single:
>
> $ sudo runsc --platform=kvm --network=none do echo ok
>
> So, for "good" runs the stacks are the following:

The stacks help, thanks for including them. It seems like a race
during do_exit teardown. One thing I notice is that
do_exit->mmput->kvm_mmu_zap_all can interleave with
kvm_vcpu_release->kvm_tdp_mmu_put_root (full call chains omitted),
since the former path allows yielding. But I don't yet see that could
lead to any issues, let alone cause us to encounter a PFN in the EPT
with a zero refcount.

I'll take a closer look next week.

>
> # bpftrace -e 'kprobe:kvm_set_pfn_dirty { @[kstack] = count(); }'
> Attaching 1 probe...
> ^C
>
> @[
>     kvm_set_pfn_dirty+1
>     __handle_changed_spte+2535
>     __tdp_mmu_set_spte+396
>     zap_gfn_range+2229
>     kvm_tdp_mmu_unmap_gfn_range+331
>     kvm_unmap_gfn_range+774
>     kvm_mmu_notifier_invalidate_range_start+743
>     __mmu_notifier_invalidate_range_start+508
>     unmap_vmas+566
>     unmap_region+494
>     __do_munmap+1172
>     __vm_munmap+226
>     __x64_sys_munmap+98
>     do_syscall_64+64
>     entry_SYSCALL_64_after_hwframe+68
> ]: 1
> @[
>     kvm_set_pfn_dirty+1
>     __handle_changed_spte+2535
>     __tdp_mmu_set_spte+396
>     zap_gfn_range+2229
>     kvm_tdp_mmu_unmap_gfn_range+331
>     kvm_unmap_gfn_range+774
>     kvm_mmu_notifier_invalidate_range_start+743
>     __mmu_notifier_invalidate_range_start+508
>     zap_page_range_single+870
>     unmap_mapping_pages+434
>     shmem_fallocate+2518
>     vfs_fallocate+684
>     __x64_sys_fallocate+181
>     do_syscall_64+64
>     entry_SYSCALL_64_after_hwframe+68
> ]: 32
> @[
>     kvm_set_pfn_dirty+1
>     __handle_changed_spte+2535
>     __handle_changed_spte+1746
>     __handle_changed_spte+1746
>     __handle_changed_spte+1746
>     __tdp_mmu_set_spte+396
>     zap_gfn_range+2229
>     __kvm_tdp_mmu_zap_gfn_range+162
>     kvm_tdp_mmu_zap_all+34
>     kvm_mmu_zap_all+518
>     kvm_mmu_notifier_release+83
>     __mmu_notifier_release+420
>     exit_mmap+965
>     mmput+167
>     do_exit+2482
>     do_group_exit+236
>     get_signal+1000
>     arch_do_signal_or_restart+580
>     exit_to_user_mode_prepare+300
>     syscall_exit_to_user_mode+25
>     do_syscall_64+77
>     entry_SYSCALL_64_after_hwframe+68
> ]: 365
>
> For "bad" runs, when I get the warning - I get this:
>
> # bpftrace -e 'kprobe:kvm_set_pfn_dirty { @[kstack] = count(); }'
> Attaching 1 probe...
> ^C
>
> @[
>     kvm_set_pfn_dirty+1
>     __handle_changed_spte+2535
>     __tdp_mmu_set_spte+396
>     zap_gfn_range+2229
>     kvm_tdp_mmu_unmap_gfn_range+331
>     kvm_unmap_gfn_range+774
>     kvm_mmu_notifier_invalidate_range_start+743
>     __mmu_notifier_invalidate_range_start+508
>     unmap_vmas+566
>     unmap_region+494
>     __do_munmap+1172
>     __vm_munmap+226
>     __x64_sys_munmap+98
>     do_syscall_64+64
>     entry_SYSCALL_64_after_hwframe+68
> ]: 1
> @[
>     kvm_set_pfn_dirty+1
>     __handle_changed_spte+2535
>     __handle_changed_spte+1746
>     __handle_changed_spte+1746
>     __handle_changed_spte+1746
>     __tdp_mmu_set_spte+396
>     zap_gfn_range+2229
>     kvm_tdp_mmu_put_root+465
>     mmu_free_root_page+537
>     kvm_mmu_free_roots+629
>     kvm_mmu_unload+28
>     kvm_arch_destroy_vm+510
>     kvm_put_kvm+1017
>     kvm_vcpu_release+78
>     __fput+516
>     task_work_run+206
>     do_exit+2615
>     do_group_exit+236
>     get_signal+1000
>     arch_do_signal_or_restart+580
>     exit_to_user_mode_prepare+300
>     syscall_exit_to_user_mode+25
>     do_syscall_64+77
>     entry_SYSCALL_64_after_hwframe+68
> ]: 2
> @[
>     kvm_set_pfn_dirty+1
>     __handle_changed_spte+2535
>     __tdp_mmu_set_spte+396
>     zap_gfn_range+2229
>     kvm_tdp_mmu_unmap_gfn_range+331
>     kvm_unmap_gfn_range+774
>     kvm_mmu_notifier_invalidate_range_start+743
>     __mmu_notifier_invalidate_range_start+508
>     zap_page_range_single+870
>     unmap_mapping_pages+434
>     shmem_fallocate+2518
>     vfs_fallocate+684
>     __x64_sys_fallocate+181
>     do_syscall_64+64
>     entry_SYSCALL_64_after_hwframe+68
> ]: 32
> @[
>     kvm_set_pfn_dirty+1
>     __handle_changed_spte+2535
>     __handle_changed_spte+1746
>     __handle_changed_spte+1746
>     __handle_changed_spte+1746
>     __tdp_mmu_set_spte+396
>     zap_gfn_range+2229
>     __kvm_tdp_mmu_zap_gfn_range+162
>     kvm_tdp_mmu_zap_all+34
>     kvm_mmu_zap_all+518
>     kvm_mmu_notifier_release+83
>     __mmu_notifier_release+420
>     exit_mmap+965
>     mmput+167
>     do_exit+2482
>     do_group_exit+236
>     get_signal+1000
>     arch_do_signal_or_restart+580
>     exit_to_user_mode_prepare+300
>     syscall_exit_to_user_mode+25
>     do_syscall_64+77
>     entry_SYSCALL_64_after_hwframe+68
> ]: 344
>
> That is, I never get a stack with
> kvm_tdp_mmu_put_root->..->kvm_set_pfn_dirty with a "good" run.
> Perhaps, this may shed some light onto what is going on.
>
> Ignat
