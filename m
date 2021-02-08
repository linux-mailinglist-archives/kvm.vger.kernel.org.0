Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B55313EE6
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 20:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhBHT1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 14:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbhBHT1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 14:27:01 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E6BC061788
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 11:26:20 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id z6so1224293pfq.0
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 11:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FdP6Qc+UPGLk3XuWMFiPn/oePnvwLyYfc8IpH3UBvCI=;
        b=VYbHidqZwnBU4Y5Tj0h2ukU7fHKK8iI3iDjm+IlsznwU/Q6/R54rbOFkZYGbhBKSTN
         JeJv/F72UfHX41PZTAm0fXj4+pnEnlkHrtHCJcmNEIefCLI+rFbSxnRwT6b+sX/UD4cb
         aLrybOfIErZw+u1voydsfJOuasF6k2CmWyAEbfZuiOW3RJO3VPIEJBWg21jHkoC6afWR
         p7KV5u8YAu1F8SLwyMkyskDJ7xAxjaVjuRilLIzdwNnwj2YQdNWu/t3/1c2xF7epQTJI
         62bEPTtKNzVravZyZ4Za4jUTbcdmbSna9CphYAKyBFr9SWZRb+neOEuVpmNer9KNx4rG
         FZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FdP6Qc+UPGLk3XuWMFiPn/oePnvwLyYfc8IpH3UBvCI=;
        b=ljxuTr5zp6SwDg4aYTuqe7tyfN0/imRitrDmKqbPWArvT3eY62AfEMnZB08KaCtrKE
         sTxvbq+P4dbJOmhl6Qx8F1vTJjOCZdtmj54LnknByoKD6mkQI4hpvrXSEiDB7Pzdo1bw
         2moS9CSiVQqN+YCfXQf22qNQQ8onLg2rYprnLkdxuYk0aksGJyNyYQQuzG/Ncwn6xDfr
         pgl/ivX7RF2cY/srwy8OJCST/VyGa7sZTdc9gmfAYZjYdhNWvokvvXy9iS5eeuwmObr9
         71+mtyUom63nbIj9gfrIFPO+rkfxNyP4pyYlci/04rD5Qj+5wUPhfKvEUcX3USwsL7+s
         +mAw==
X-Gm-Message-State: AOAM531aog6p1M9f47SP4WjFgjSO0OrwQ+o4dO06CoR87M3pzedZTcXt
        ZkYgrbJSWIaT29ghKBNQbngbKQ==
X-Google-Smtp-Source: ABdhPJyOsrsg7A3oXkaPKlSsh0+Zu9q9Jvf5cpxYUkJl/WjuItJf9yRoSOiqqraM3FvYDqt0zZrHTQ==
X-Received: by 2002:a62:8c8d:0:b029:1d8:3458:5f3b with SMTP id m135-20020a628c8d0000b02901d834585f3bmr16471791pfd.27.1612812380128;
        Mon, 08 Feb 2021 11:26:20 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e4db:abc1:a5c0:9dbc])
        by smtp.gmail.com with ESMTPSA id 123sm19892245pfd.91.2021.02.08.11.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 11:26:19 -0800 (PST)
Date:   Mon, 8 Feb 2021 11:26:13 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: compile out TDP MMU on 32-bit systems
Message-ID: <YCGQVdPio+LSNWGi@google.com>
References: <20210206145333.47314-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210206145333.47314-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 06, 2021, Paolo Bonzini wrote:
> The TDP MMU assumes that it can do atomic accesses to 64-bit PTEs.
> Rather than just disabling it, compile it out completely so that it
> is possible to use for example 64-bit xchg.
> 
> To limit the number of stubs, wrap all accesses to tdp_mmu_enabled
> or tdp_mmu_page with a function.  Calls to all other functions in
> tdp_mmu.c are eliminated and do not even reach the linker.

Aha!  I always forget how smart the compiler can (sometimes) be.  I agree this
isn't at all painful.

This can/should also expand the #ifdef to the TDP-only fields in kvm_mmu_page.
I also vote to #ifdef out all of tdp_iter.h, and probably the TDP-only fields in
struct kvm_arch.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e0171f7176c5..84499aad01a4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1033,6 +1033,7 @@ struct kvm_arch {
        struct kvm_pmu_event_filter *pmu_event_filter;
        struct task_struct *nx_lpage_recovery_thread;

+#ifdef CONFIG_X86_64
        /*
         * Whether the TDP MMU is enabled for this VM. This contains a
         * snapshot of the TDP MMU module parameter from when the VM was
@@ -1071,6 +1072,7 @@ struct kvm_arch {
         * the thread holds the MMU lock in write mode.
         */
        spinlock_t tdp_mmu_pages_lock;
+#endif /* CONFIG_X86_64 */
 };

 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 98db78a26957..9e38d3c5daad 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -56,10 +56,12 @@ struct kvm_mmu_page {
        /* Number of writes since the last time traversal visited this page.  */
        atomic_t write_flooding_count;

+#ifdef CONFIG_X86_64
        bool tdp_mmu_page;

        /* Used for freeing the page asyncronously if it is a TDP MMU page. */
        struct rcu_head rcu_head;
+#endif
 };

 extern struct kmem_cache *mmu_page_header_cache;
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 4cc177d75c4a..5f60c1b1a1b4 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -7,6 +7,8 @@

 #include "mmu.h"

+#ifdef CONFIG_X86_64
+
 typedef u64 __rcu *tdp_ptep_t;

 /*
@@ -64,4 +66,6 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 void tdp_iter_next(struct tdp_iter *iter);
 tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter);

+#endif /* CONFIG_X86_64 */
+
 #endif /* __KVM_X86_MMU_TDP_ITER_H */



With the above:

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
