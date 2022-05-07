Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8C751E559
	for <lists+kvm@lfdr.de>; Sat,  7 May 2022 09:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359499AbiEGHzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 03:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358709AbiEGHzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 03:55:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA021FA55;
        Sat,  7 May 2022 00:51:56 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i17so9464072pla.10;
        Sat, 07 May 2022 00:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FKFTVnqj1TSVH5UzHH+NO5fdnNT2aHzWK9Qt0Z+5p7o=;
        b=WrbhvaSR0rfRQ2ictV8jJhBIOD5Vbgm0vojL3lLq/cHeldCdx3DTbT5BZzoMWNuKra
         M9mVSR81V195rBTicolSZH5ZYQLVqJpHTNUrR0r2YIuqogcbHZ6O/8XCSksVHv5xY6DP
         LhmVFiFVQoqnEjHHYddIgnRHs3DFGAiXeYIapd9us7o6fxYn7dk93WfFuOR8FLp2+Eys
         vNazlyjrDi2toas6jLKU+axdRp71QkeBXunUG7ufE5djpFyRzXqDNEluAGugJgVdCO0y
         6SKAG4LBLZ3wVv1DP+mlH3l+hUbNSsBGvD93NdTJvSOwaqCvavnQ2Shgwp+nmLu/GrGC
         XUGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FKFTVnqj1TSVH5UzHH+NO5fdnNT2aHzWK9Qt0Z+5p7o=;
        b=aIxqe+heT6rrkZDmSwKrXzm/tG1KDl3JEb/WSRQ43c0BfS1LlCLKzkYiA0UVCjPCGG
         NpP92xpsc5s4S/t1RGyKXYBRnpiqz8ZqlMD4orQw8ZXEjpV51mcLk83oLljAGyT0cA54
         LRwVl3nIu8Ex/IRfMW7qMQe4GYgCSZKDp+fWFbLMjlqrB4fSMsd0WFFAnrTaeMAwCAGX
         Jjokw9/pXf9C/qfcGmBN4aylwMHVx03JaaOshZObQfHRNDWw2NiveeN+rSFL/fzDZJIP
         Y5IYJfCPOlxBIiQ9m15vODrNzESq1eTgrly4/MRIKg4ZfZ+syoH0PIhUAuFHSAOKL1G3
         EHUQ==
X-Gm-Message-State: AOAM530C7JXZRW9FyJ+lFSJ7nSle0LlKSAW0MN4Xl6J4zE63OfHl09p5
        g4O1EJLQLL+u0F4hrGLQ8pY=
X-Google-Smtp-Source: ABdhPJynlIeNwHKvFkAfj64vRfPLjoPtqup3wVpb8FZ4dGugmE0hMqTJ5mYlYb7kNjW4L1NekC5Exw==
X-Received: by 2002:a17:90b:3646:b0:1d8:15c5:464b with SMTP id nh6-20020a17090b364600b001d815c5464bmr16936437pjb.63.1651909916397;
        Sat, 07 May 2022 00:51:56 -0700 (PDT)
Received: from [30.22.112.212] ([205.204.117.91])
        by smtp.gmail.com with ESMTPSA id f16-20020a170902ab9000b0015e8d4eb2c1sm2976004plr.267.2022.05.07.00.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 00:51:56 -0700 (PDT)
Message-ID: <de48ed40-4e6e-c49d-426e-91aba4ce1337@gmail.com>
Date:   Sat, 7 May 2022 15:51:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v4 20/20] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-21-dmatlack@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
In-Reply-To: <20220422210546.458943-21-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/4/23 05:05, David Matlack wrote:
> Add support for Eager Page Splitting pages that are mapped by nested
> MMUs. Walk through the rmap first splitting all 1GiB pages to 2MiB
> pages, and then splitting all 2MiB pages to 4KiB pages.
>
> Note, Eager Page Splitting is limited to nested MMUs as a policy rather
> than due to any technical reason (the sp->role.guest_mode check could
> just be deleted and Eager Page Splitting would work correctly for all
> shadow MMU pages). There is really no reason to support Eager Page
> Splitting for tdp_mmu=N, since such support will eventually be phased
> out, and there is no current use case supporting Eager Page Splitting on
> hosts where TDP is either disabled or unavailable in hardware.
> Furthermore, future improvements to nested MMU scalability may diverge
> the code from the legacy shadow paging implementation. These
> improvements will be simpler to make if Eager Page Splitting does not
> have to worry about legacy shadow paging.
>
> Splitting huge pages mapped by nested MMUs requires dealing with some
> extra complexity beyond that of the TDP MMU:
>
> (1) The shadow MMU has a limit on the number of shadow pages that are
>      allowed to be allocated. So, as a policy, Eager Page Splitting
>      refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
>      pages available.
>
> (2) Splitting a huge page may end up re-using an existing lower level
>      shadow page tables. This is unlike the TDP MMU which always allocates
>      new shadow page tables when splitting.
>
> (3) When installing the lower level SPTEs, they must be added to the
>      rmap which may require allocating additional pte_list_desc structs.
>
> Case (2) is especially interesting since it may require a TLB flush,
> unlike the TDP MMU which can fully split huge pages without any TLB
> flushes. Specifically, an existing lower level page table may point to
> even lower level page tables that are not fully populated, effectively
> unmapping a portion of the huge page, which requires a flush.
>
> This commit performs such flushes after dropping the huge page and
> before installing the lower level page table. This TLB flush could
> instead be delayed until the MMU lock is about to be dropped, which
> would batch flushes for multiple splits.  However these flushes should
> be rare in practice (a huge page must be aliased in multiple SPTEs and
> have been split for NX Huge Pages in only some of them). Flushing
> immediately is simpler to plumb and also reduces the chances of tripping
> over a CPU bug (e.g. see iTLB multihit).
>
> Suggested-by: Peter Feiner <pfeiner@google.com>
> [ This commit is based off of the original implementation of Eager Page
>    Splitting from Peter in Google's kernel from 2016. ]
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   .../admin-guide/kernel-parameters.txt         |   3 +-
>   arch/x86/include/asm/kvm_host.h               |  20 ++
>   arch/x86/kvm/mmu/mmu.c                        | 276 +++++++++++++++++-
>   arch/x86/kvm/x86.c                            |   6 +
>   4 files changed, 296 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 3f1cc5e317ed..bc3ad3d4df0b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2387,8 +2387,7 @@
>   			the KVM_CLEAR_DIRTY ioctl, and only for the pages being
>   			cleared.
>   
> -			Eager page splitting currently only supports splitting
> -			huge pages mapped by the TDP MMU.
> +			Eager page splitting is only supported when kvm.tdp_mmu=Y.
>   
>   			Default is Y (on).
>   
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 15131aa05701..5df4dff385a1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1240,6 +1240,24 @@ struct kvm_arch {
>   	hpa_t	hv_root_tdp;
>   	spinlock_t hv_root_tdp_lock;
>   #endif
> +
> +	/*
> +	 * Memory caches used to allocate shadow pages when performing eager
> +	 * page splitting. No need for a shadowed_info_cache since eager page
> +	 * splitting only allocates direct shadow pages.
> +	 */
> +	struct kvm_mmu_memory_cache split_shadow_page_cache;
> +	struct kvm_mmu_memory_cache split_page_header_cache;
> +
> +	/*
> +	 * Memory cache used to allocate pte_list_desc structs while splitting
> +	 * huge pages. In the worst case, to split one huge page, 512
> +	 * pte_list_desc structs are needed to add each lower level leaf sptep
> +	 * to the rmap plus 1 to extend the parent_ptes rmap of the lower level
> +	 * page table.
> +	 */
> +#define SPLIT_DESC_CACHE_CAPACITY 513
> +	struct kvm_mmu_memory_cache split_desc_cache;
>   };
>   
>   


I think it needs to document that the topup operations for these caches are

protected by kvm->slots_lock.

