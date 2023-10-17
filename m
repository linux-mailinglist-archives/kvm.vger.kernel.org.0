Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84F57CCF52
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 23:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbjJQVbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 17:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbjJQVbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 17:31:32 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DC8121
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 14:31:30 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9bc9e6a89so46705505ad.0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 14:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697578290; x=1698183090; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZRorWcdg/9qyDjZ9MPkuveSNwHmSlMZCo3YWPFaI50=;
        b=xfkFTfvBkvvdAY4sLe3kcXtOi7u8THDIvoVF++QsjoHJR3n81XorTj2YQo4k2vOJnZ
         kbLBYz2AnEQyMG6OIL7e4eqOEGZeoAtNqfUXca0+b0glD7aYAdQyCceScnwtaertjrLu
         gtuszsX49hY255ui/8LqZf+lb3p914h1Ifyen2//5Aw7gF8KP2OZNVVD61F8v3xrBR8z
         mmCcJSR/k1BAuVNfdVh8m1P7OxWl2yKZx5ZpkhGrRZoIdhX5cAYKLcfQBUgGlEmCjwVC
         B/eFn1AAKfVkwTXjQi25DL1cDcb51N1oYWKPAPriGJloMnezoE2KiQoO2CYysZ78s3/K
         Eaiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697578290; x=1698183090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZRorWcdg/9qyDjZ9MPkuveSNwHmSlMZCo3YWPFaI50=;
        b=tWxNF/LXMCcaEnOLznHLkbEpvyPtUAIzb/jGGcAesAJ0Z/LDaRUD6BO8/WvRyGFZ7g
         NfMQ0hIFPJmrbD5ntOPDGGlOfV7q1AszgNg+rxeQ4fNaBngdpNHZ4FBIzXErFS7UdGqQ
         iOqgfXrwBMT2e61GiQCQHN5NX8JJsCzizlGTN0sZ0ZfTe/hn4AnaE6nE77uD4snPLkzv
         6jlhjm4jLWpjfG798YR8UPxNfJ/S0GoBQEXkZT/GmrcyAvQr6i0PXR9zHQy18AJmYYQU
         JXLG7pb+hA0RdNMS5GYJ4LgWzWIdhwCT8vrycdIf4shN/Q25fshmUdR1eh/nNTqOt/jm
         HoUg==
X-Gm-Message-State: AOJu0YwfzwEiQufcfteqMbCYvgLKLUGI+0yktSXGgecB+36FETz6pAEV
        TEYxKxeNf/8Zb7Zdrw8X9jwCJS0SHZE=
X-Google-Smtp-Source: AGHT+IFClI8WxCE+QfNCUD2C2ZZEE9fpW16z8j5iL/y0aqZ/mhsWu0VhUltSIuxn/4cOgCUbWVS0CtTJS4w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:706:b0:1c5:7c07:e403 with SMTP id
 kk6-20020a170903070600b001c57c07e403mr64765plb.10.1697578289626; Tue, 17 Oct
 2023 14:31:29 -0700 (PDT)
Date:   Tue, 17 Oct 2023 14:31:28 -0700
In-Reply-To: <20231017093335.18216-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20231017093335.18216-1-likexu@tencent.com>
Message-ID: <ZS79MFkVB6A1N9AA@google.com>
Subject: Re: [PATCH] KVM: x86: Clean up included but non-essential header declarations
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> Removing these declarations as part of KVM code refactoring can also (when
> the compiler isn't so smart) reduce compile time, compile warnings, and the

Really, warnings?  On what W= level?  W=1 builds just fine with KVM_WERROR=y.
If any of the "supported" warn levels triggers a warn=>error, then we'll fix it.

> size of compiled artefacts, and more importantly can help developers better
> consider decoupling when adding/refactoring unmerged code, thus relieving
> some of the burden on the code review process.

Can you provide an example?  KVM certainly has its share of potential circular
dependency pitfalls, e.g. it's largely why we have the ugly and seemingly
arbitrary split between x86.h and asm/kvm_host.h.  But outside of legitimate
collisions like that, I can't think of a single instance where superfluous existing
includes caused problems.  On the other hand, I distinctly recall multiple
instances where a header didn't include what it used and broke the build when the
buggy header was included in a new file.

> Specific header declaration is supposed to be retained if it makes more
> sense for reviewers to understand. No functional changes intended.
> 
> [*] https://lore.kernel.org/all/YdIfz+LMewetSaEB@gmail.com/

This patch violates one of the talking points of Ingo's work:

 - "Make headers standalone": over 80 headers don't build standalone and
   depend on various accidental indirect dependencies they gain through
   other headers, especially once headers get their unnecessary dependencies
   removed. So there's over 80 commits changing these headers.

I think it's also worth noting that Ingo boosted build times by eliminating
includes in common "high use" headers, not by playing whack-a-mole with "private"
headers and C files.

> [**] https://include-what-you-use.org/
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/cpuid.c           |  3 ---
>  arch/x86/kvm/cpuid.h           |  1 -
>  arch/x86/kvm/emulate.c         |  2 --
>  arch/x86/kvm/hyperv.c          |  3 ---
>  arch/x86/kvm/i8259.c           |  1 -
>  arch/x86/kvm/ioapic.c          | 10 ----------
>  arch/x86/kvm/irq.c             |  3 ---
>  arch/x86/kvm/irq.h             |  3 ---
>  arch/x86/kvm/irq_comm.c        |  2 --
>  arch/x86/kvm/lapic.c           |  8 --------
>  arch/x86/kvm/mmu.h             |  1 -
>  arch/x86/kvm/mmu/mmu.c         | 11 -----------
>  arch/x86/kvm/mmu/spte.c        |  1 -
>  arch/x86/kvm/mmu/tdp_iter.h    |  1 -
>  arch/x86/kvm/mmu/tdp_mmu.c     |  3 ---
>  arch/x86/kvm/mmu/tdp_mmu.h     |  4 ----
>  arch/x86/kvm/smm.c             |  1 -
>  arch/x86/kvm/smm.h             |  3 ---
>  arch/x86/kvm/svm/avic.c        |  2 --
>  arch/x86/kvm/svm/hyperv.h      |  2 --
>  arch/x86/kvm/svm/nested.c      |  2 --
>  arch/x86/kvm/svm/pmu.c         |  4 ----
>  arch/x86/kvm/svm/sev.c         |  7 -------
>  arch/x86/kvm/svm/svm.c         | 29 -----------------------------
>  arch/x86/kvm/svm/svm.h         |  3 ---
>  arch/x86/kvm/vmx/hyperv.c      |  4 ----
>  arch/x86/kvm/vmx/hyperv.h      |  7 -------
>  arch/x86/kvm/vmx/nested.c      |  2 --
>  arch/x86/kvm/vmx/nested.h      |  1 -
>  arch/x86/kvm/vmx/pmu_intel.c   |  1 -
>  arch/x86/kvm/vmx/posted_intr.c |  1 -
>  arch/x86/kvm/vmx/sgx.h         |  5 -----
>  arch/x86/kvm/vmx/vmx.c         | 11 -----------
>  arch/x86/kvm/x86.c             | 17 -----------------
>  arch/x86/kvm/xen.c             |  1 -
>  virt/kvm/async_pf.c            |  2 --
>  virt/kvm/binary_stats.c        |  1 -
>  virt/kvm/coalesced_mmio.h      |  2 --
>  virt/kvm/eventfd.c             |  2 --
>  virt/kvm/irqchip.c             |  1 -
>  virt/kvm/kvm_main.c            | 13 -------------
>  virt/kvm/pfncache.c            |  1 -
>  virt/kvm/vfio.c                |  2 --
>  43 files changed, 184 deletions(-)

NAK, I am not taking a wholesale purge of includes.  I have no objection to
removing truly unnecessary includes, e.g. there are definitely some includes that
are no longer necessary due to code being moved around.  But changes like the
removal of all includes from tdp_mmu.h and smm.h are completely bogus.  If anything,
smm.h clearly needs more includes, because it is certainly not including everything
it is using.

> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 733a3aef3a96..66afdf3e262a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -3,10 +3,6 @@
>  #ifndef __KVM_X86_MMU_TDP_MMU_H
>  #define __KVM_X86_MMU_TDP_MMU_H
>  
> -#include <linux/kvm_host.h>
> -
> -#include "spte.h"
> -
>  void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);

...

> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> index a1cf2ac5bd78..3e067ce1ea1d 100644
> --- a/arch/x86/kvm/smm.h
> +++ b/arch/x86/kvm/smm.h
> @@ -2,11 +2,8 @@
>  #ifndef ASM_KVM_SMM_H
>  #define ASM_KVM_SMM_H
>  
> -#include <linux/build_bug.h>
> -
>  #ifdef CONFIG_KVM_SMM
>  
> -
>  /*
>   * 32 bit KVM's emulated SMM layout. Based on Intel P6 layout
>   * (https://www.sandpile.org/x86/smm.htm).
