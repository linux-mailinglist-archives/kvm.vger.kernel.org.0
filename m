Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DC81E8D1B
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgE3CJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728542AbgE3CJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:09:17 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA85DC03E969
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:09:16 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q8so1376880iow.7
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vlmSewL3rq3vD4y0RTkQmFf9htc9A96X+yTO0F7WLjE=;
        b=isTrnDd6kt7rm5ECL401fWijK/6lx0gVqAFyVUKJo/uV23abX2Z0K1fk/cwDrS3LjU
         RP3GQV6TWoeNcldkpIUpK+Ug2hdZsm1VUCI/SCWqeKISrOiPkp9IPKX4KpBKFnlXtp3u
         eXY9zt2QSE2Ziv2pjSzD1dxELecq4TrFViSEoCbmfaspdO1El5fuOv68gsceWXOwSAqi
         M8fpgEz2qiV0qzyOQERvwj3JxJiB66471yHyV5kDzrz0KLPMXjoGGWhk83OUneXpCrEs
         5oLVrBYi/ykFkHhvsb5tR9SZ42qvBrHDknTr6AMta0COcmzEDzmRVejmOPJGZqtJDLIA
         8y7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vlmSewL3rq3vD4y0RTkQmFf9htc9A96X+yTO0F7WLjE=;
        b=E2k/jE0R7muZpAJlngtFSLJmfWzEhh1ttgDXPnGaKEogpx/D7eES4RDhT1tGynljS7
         1MRMiTV8jZ5Wk8q+nppg2CXz20U4ilXNJW3U6C2ZMYIzEVSN9rCvINpE6MriQ7Rrr7EG
         yCCaxag8f/gRDu16j/5socN3l9jo9Hu+Au0ArvUwGYAP5FBPAY+nSy1Q1kiHslexsX6H
         KKgcs4/zObEtJLrPx4ZEZdSBhaovtIDz7bG5eGm5hlXlQ+0+RxYo6JbdI+ConBTABTYF
         SgCGzB/8akKh7LxgGKNMuGZrss+DR0PcPU7HUR6/R9ZrvuRAy64oZCShEN/4SaDC4+VV
         aF9w==
X-Gm-Message-State: AOAM530UElqv+3kmMWzWfN3XszL4VcJ81mz4/dm2k/KUXOlb0foh4hbP
        OaTDsqL+jIWMrhMWnVt6nkxX4ajzlXKDK954zHNrhg==
X-Google-Smtp-Source: ABdhPJwxyhVZZ6K090XgKszEc+Edh5Q1DVb8WYzIHOnOuxY0ttP1YXWJ03SqjDgHaOqU+6ID5UtSkwJDg/LAkJX9XE0=
X-Received: by 2002:a02:c802:: with SMTP id p2mr10244705jao.111.1590804556143;
 Fri, 29 May 2020 19:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <697cbb9301acf18296b65bb63686b6c0d422e382.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <697cbb9301acf18296b65bb63686b6c0d422e382.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:08:40 -0700
Message-ID: <CABayD+fxrRVR2An2wKA4uf99NtScWvAAvv4UdoE_vsSFpe8KxQ@mail.gmail.com>
Subject: Re: [PATCH v8 17/18] KVM: x86: Add kexec support for SEV Live Migration.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 5, 2020 at 2:21 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Reset the host's page encryption bitmap related to kernel
> specific page encryption status settings before we load a
> new kernel by kexec. We cannot reset the complete
> page encryption bitmap here as we need to retain the
> UEFI/OVMF firmware specific settings.
>
> The host's page encryption bitmap is maintained for the
> guest to keep the encrypted/decrypted state of the guest pages,
> therefore we need to explicitly mark all shared pages as
> encrypted again before rebooting into the new guest kernel.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 4b29815de873..a8bc30d5b15b 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -35,6 +35,7 @@
>  #include <asm/hypervisor.h>
>  #include <asm/tlb.h>
>  #include <asm/cpuidle_haltpoll.h>
> +#include <asm/e820/api.h>
>
>  static int kvmapf = 1;
>
> @@ -358,6 +359,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
>          */
>         if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>                 wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> +       /*
> +        * Reset the host's page encryption bitmap related to kernel
> +        * specific page encryption status settings before we load a
> +        * new kernel by kexec. NOTE: We cannot reset the complete
> +        * page encryption bitmap here as we need to retain the
> +        * UEFI/OVMF firmware specific settings.
> +        */
> +       if (sev_live_migration_enabled() & (smp_processor_id() == 0)) {
> +               int i;
> +               unsigned long nr_pages;
> +
> +               for (i = 0; i < e820_table->nr_entries; i++) {
> +                       struct e820_entry *entry = &e820_table->entries[i];
> +                       unsigned long start_pfn;
> +                       unsigned long end_pfn;
> +
> +                       if (entry->type != E820_TYPE_RAM)
> +                               continue;
What should the behavior be for other memory types that are not
expected to be mucked with by firmware? Should we avoid resetting the
enc status of pmem/pram pages?

My intuition here is that we should only preserve the enc status of
those bits that are set by the firmware.

> +
> +                       start_pfn = entry->addr >> PAGE_SHIFT;
> +                       end_pfn = (entry->addr + entry->size) >> PAGE_SHIFT;
> +                       nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> +
> +                       kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> +                                          entry->addr, nr_pages, 1);
> +               }
> +       }
>         kvm_pv_disable_apf();
>         kvm_disable_steal_time();
>  }
> --
> 2.17.1
>
