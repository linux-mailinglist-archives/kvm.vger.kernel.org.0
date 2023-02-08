Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C0868E52F
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 01:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjBHA7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 19:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBHA7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 19:59:49 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BEEA27E
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 16:59:47 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id k13so17598732plg.0
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 16:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JnhdNMI7DoG011bkQauIQEYC3l8KjhnC/OjoFeA1Xvg=;
        b=YOyoiUU0YrrGF/IEtdHnhUMOyI75EqNh5w/voCzc85ZIfl6A4PbU22st4SjojhaNv9
         tBaOz/5XgHjdCmWfcJYwbKhNt/9Y8VaBH/0VEBFvVsK+WToVtw7uzD8ioJK1ktaFQm5R
         qw1RD6xm0kbT+/AU7NcDVZ/arPML6wiok55dnaDMZW62ouxZf93sb1PVe74+ZXoKN1sb
         DOwbFOBk3B02cXFHjhFmYNJ+1W/h6/kvFL4jgdRpkWbXmBcodTJgV/HBrx4L5KQ2ANq2
         u60QXwU3tfLzNo4nYbO0iOc9DQ7jbT/DfBrgxX01th0Jb42JuBuf6ri8n1gTPEpCq0w1
         pvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JnhdNMI7DoG011bkQauIQEYC3l8KjhnC/OjoFeA1Xvg=;
        b=wYG5PLtEU4hTMdcMSXCwOorL8gQa5YhDhD8YOU2EKaPNXBfWpKsyMLicdmMIICrV2e
         bsDt+D6Amn4lIZW/4HWxzBC+m8u/F/Y873LhnywzyAZwcCP/z3GdYrR5oE0Ym1JiYHPl
         Bk0U3k612j4EoZyPZ6WF9+txHU9YXVd1MDP3CffWPEpbS/oV1lRRhhwzW/iaiSK4xk1h
         NIXIBm2/NpU8v2K8/dpk6xeOXjrQRLMsDn9ItMR/+WmZ1f1m1PTtApuLjhmqu4xj3Xap
         8NBhFHQcRX4MVbkngP4hzdWY7lbQwcYDCsi3FwHwMK3/q8wYA0tvdwHqsGb9Lz4tI6a+
         Ktuw==
X-Gm-Message-State: AO0yUKWyUADJzAENdrEIGwKBmjjER//nmvjsQvY+NtqlLg//6VY/uhI4
        vSBb6y/n5bjsMSz6g4tYJUCbNA==
X-Google-Smtp-Source: AK7set+jZ9983p8cLaGX7gaekNs6ozyARdvLbR/+f0fXYwtr6UoSi6m3MpZcICm5d8loJxAYrUKJqA==
X-Received: by 2002:a17:902:f544:b0:198:af50:e4eb with SMTP id h4-20020a170902f54400b00198af50e4ebmr85364plf.17.1675817986642;
        Tue, 07 Feb 2023 16:59:46 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x23-20020a1709027c1700b001946a3f4d9csm9532050pll.38.2023.02.07.16.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 16:59:46 -0800 (PST)
Date:   Wed, 8 Feb 2023 00:59:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 4/5] KVM: Allow custom names for stats
Message-ID: <Y+Lz/lNFCu76u8rV@google.com>
References: <20230118175300.790835-1-dmatlack@google.com>
 <20230118175300.790835-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118175300.790835-5-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UPPERCASE_50_75,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023, David Matlack wrote:
>  /* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
> -#define STATS_DESC(SCOPE, _stat, _type, _unit, _base, _exponent, _size,        \
> +#define STATS_DESC(SCOPE, _stat, _name, _type, _unit, _base, _exponent, _size, \
>  		   _bucket_size)					       \
> -	SCOPE##_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,       \
> -			   _bucket_size)
> +	SCOPE##_STATS_DESC(_stat, _type, _name, _unit, _base, _exponent,       \
> +			   _size, _bucket_size)	       \

Bad trailing backslash snuck in.  Probably doesn't cause problems because there's
a blank line after it.

> -#define STATS_DESC_CUMULATIVE(SCOPE, _stat, _unit, _base, exponent)	       \
> -	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_CUMULATIVE,		       \
> +#define STATS_DESC_CUMULATIVE(SCOPE, _stat, _name, _unit, _base, exponent)     \
> +	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_CUMULATIVE,	       \
>  		   _unit, _base, exponent, 1, 0)
> -#define STATS_DESC_INSTANT(SCOPE, _stat, _unit, _base, exponent)	       \
> -	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_INSTANT,		       \
> +#define STATS_DESC_INSTANT(SCOPE, _stat, _name, _unit, _base, exponent)	       \
> +	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_INSTANT,		       \
>  		   _unit, _base, exponent, 1, 0)
> -#define STATS_DESC_PEAK(SCOPE, _stat, _unit, _base, exponent)		       \
> -	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_PEAK,			       \
> +#define STATS_DESC_PEAK(SCOPE, _stat, _name, _unit, _base, exponent)	       \
> +	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_PEAK,		       \
>  		   _unit, _base, exponent, 1, 0)
> -#define STATS_DESC_LINEAR_HIST(SCOPE, _stat, _unit, _base, exponent, _size,    \
> -			       _bucket_size)				       \
> -	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_LINEAR_HIST,		       \
> +#define STATS_DESC_LINEAR_HIST(SCOPE, _stat, _name, _unit, _base, exponent,    \
> +			       _size, _bucket_size)			       \
> +	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_LINEAR_HIST,	       \
>  		   _unit, _base, exponent, _size, _bucket_size)
> -#define STATS_DESC_LOG_HIST(SCOPE, _stat, _unit, _base, exponent, _size)       \
> -	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_LOG_HIST,		       \
> +#define STATS_DESC_LOG_HIST(SCOPE, _stat, _name, _unit, _base, exponent,       \
> +			    _size)					       \
> +	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_LOG_HIST,	       \
>  		   _unit, _base, exponent, _size, 0)
>  
>  /* Cumulative counter, read/write */
> -#define STATS_DESC_COUNTER(SCOPE, _stat)				       \
> -	STATS_DESC_CUMULATIVE(SCOPE, _stat, KVM_STATS_UNIT_NONE,	       \
> +#define __STATS_DESC_COUNTER(SCOPE, _stat, _name)			       \
> +	STATS_DESC_CUMULATIVE(SCOPE, _stat, _name, KVM_STATS_UNIT_NONE,	       \
>  			      KVM_STATS_BASE_POW10, 0)
> +#define STATS_DESC_COUNTER(SCOPE, _stat)				       \
> +	__STATS_DESC_COUNTER(SCOPE, _stat, #_stat)
> +
>  /* Instantaneous counter, read only */
> -#define STATS_DESC_ICOUNTER(SCOPE, _stat)				       \
> -	STATS_DESC_INSTANT(SCOPE, _stat, KVM_STATS_UNIT_NONE,		       \
> +#define __STATS_DESC_ICOUNTER(SCOPE, _stat, _name)			       \
> +	STATS_DESC_INSTANT(SCOPE, _stat, _name, KVM_STATS_UNIT_NONE,	       \
>  			   KVM_STATS_BASE_POW10, 0)
> +#define STATS_DESC_ICOUNTER(SCOPE, _stat)				       \
> +	__STATS_DESC_ICOUNTER(SCOPE, _stat, #_stat)


The amount of copy+paste is gnarly.  Much of that is inherited, but adding the
inner macros definitely exacerbates things.

I also dislike the shorthand that ends up getting using, e.g. until I looked at
this patch, I assumed ICOUNTER meant "integer counter".

There are also several unused macros that presumably got added because of stats
we have internally.

In short, I think adding macros for every flavor was a mistake.

I also vote not to add inner helpers until there's a need, though I suppose I'm
not opposed to adding them if the majority opinion is to be nice to people
carrying out-of-tree stats, i.e. us :-)

If we tweak the names to be shorter so that the TYPE and UNIT can be params, we
only need four (five if we define KVM_HIST to be nice) top-level macros at this
time, e.g.

#define __KVM_STAT(SCOPE, TYPE, UNIT, _stat, _name)				\
	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_##TYPE,			\
		   KVM_STATS_UNIT_##UNIT, KVM_STATS_BASE_POW10, 0, 1, 0)

#define KVM_STAT(SCOPE, TYPE, UNIT, _stat)					\
	__KVM_STAT(SCOPE, TYPE, UNIT, _stat, #_stat)

#define KVM_STAT_NSEC(SCOPE, TYPE, _stat)					\
	STATS_DESC(SCOPE, _stat, #_stat, KVM_STATS_TYPE_##TYPE,			\
		   KVM_STATS_UNIT_SECONDS, KVM_STATS_BASE_POW10, -9, 1, 0)

#define KVM_HIST(SCOPE, TYPE, UNIT, _stat)					\
	STATS_DESC(SCOPE, _stat, #_stat, KVM_STATS_TYPE_##TYPE##_HIST,		\
		   KVM_STATS_UNIT_##UNIT, KVM_STATS_BASE_POW10, 0, _size, _bucket_size)

#define KVM_HIST_NSEC(SCOPE, TYPE, _stat, _size, _bucket_size)			\
	STATS_DESC(SCOPE, _stat, #_stat, KVM_STATS_TYPE_##TYPE##_HIST,		\
		   KVM_STATS_UNIT_SECONDS, KVM_STATS_BASE_POW10, -9, _size, _bucket_size)

yields usage like so

const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
	KVM_GENERIC_VM_STATS(),
	KVM_STAT(VM, CUMULATIVE, NONE, mmu_shadow_zapped),
	KVM_STAT(VM, CUMULATIVE, NONE, mmu_pte_write),
	KVM_STAT(VM, CUMULATIVE, NONE, mmu_pde_zapped),
	KVM_STAT(VM, CUMULATIVE, NONE, mmu_flooded),
	KVM_STAT(VM, CUMULATIVE, NONE, mmu_recycled),
	KVM_STAT(VM, CUMULATIVE, NONE, mmu_cache_miss),
	KVM_STAT(VM, INSTANT,    NONE, mmu_unsync),
	__KVM_STAT(VM, INSTANT,  NONE, pages[PG_LEVEL_4K - 1], "pages_4k"),
	__KVM_STAT(VM, INSTANT,  NONE, pages[PG_LEVEL_2M - 1], "pages_2m"),
	__KVM_STAT(VM, INSTANT,  NONE, pages[PG_LEVEL_1G - 1], "pages_1g"),
	KVM_STAT(VM, INSTANT,    NONE, nx_lpage_splits),
	KVM_STAT(VM, PEAK, NONE, max_mmu_rmap_size),
	KVM_STAT(VM, PEAK, NONE, max_mmu_page_hash_collisions)
};

and the below diff for x86 on top of this series (compile tested only, didn't poke
at other architectures other than to verify that don't do anything fancy).

Very last thought, if people find the "NONE" type weird, we could add an alias,
e.g. INTEGER.

---
 arch/x86/kvm/x86.c       |  94 +++++++++++++++---------------
 include/linux/kvm_host.h | 121 +++++++++++----------------------------
 2 files changed, 79 insertions(+), 136 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a28bb3c977d5..22704b1134d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -231,19 +231,19 @@ EXPORT_SYMBOL_GPL(host_xss);
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
-	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
-	STATS_DESC_COUNTER(VM, mmu_pte_write),
-	STATS_DESC_COUNTER(VM, mmu_pde_zapped),
-	STATS_DESC_COUNTER(VM, mmu_flooded),
-	STATS_DESC_COUNTER(VM, mmu_recycled),
-	STATS_DESC_COUNTER(VM, mmu_cache_miss),
-	STATS_DESC_ICOUNTER(VM, mmu_unsync),
-	__STATS_DESC_ICOUNTER(VM, pages[PG_LEVEL_4K - 1], "pages_4k"),
-	__STATS_DESC_ICOUNTER(VM, pages[PG_LEVEL_2M - 1], "pages_2m"),
-	__STATS_DESC_ICOUNTER(VM, pages[PG_LEVEL_1G - 1], "pages_1g"),
-	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
-	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
-	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
+	KVM_STAT(VM, CUMULATIVE, NONE, mmu_shadow_zapped),
+	KVM_STAT(VM, CUMULATIVE, NONE, mmu_pte_write),
+	KVM_STAT(VM, CUMULATIVE, NONE, mmu_pde_zapped),
+	KVM_STAT(VM, CUMULATIVE, NONE, mmu_flooded),
+	KVM_STAT(VM, CUMULATIVE, NONE, mmu_recycled),
+	KVM_STAT(VM, CUMULATIVE, NONE, mmu_cache_miss),
+	KVM_STAT(VM, INSTANT,    NONE, mmu_unsync),
+	__KVM_STAT(VM, INSTANT,  NONE, pages[PG_LEVEL_4K - 1], "pages_4k"),
+	__KVM_STAT(VM, INSTANT,  NONE, pages[PG_LEVEL_2M - 1], "pages_2m"),
+	__KVM_STAT(VM, INSTANT,  NONE, pages[PG_LEVEL_1G - 1], "pages_1g"),
+	KVM_STAT(VM, INSTANT,    NONE, nx_lpage_splits),
+	KVM_STAT(VM, PEAK, NONE, max_mmu_rmap_size),
+	KVM_STAT(VM, PEAK, NONE, max_mmu_page_hash_collisions)
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
@@ -257,40 +257,40 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
-	STATS_DESC_COUNTER(VCPU, pf_taken),
-	STATS_DESC_COUNTER(VCPU, pf_fixed),
-	STATS_DESC_COUNTER(VCPU, pf_emulate),
-	STATS_DESC_COUNTER(VCPU, pf_spurious),
-	STATS_DESC_COUNTER(VCPU, pf_fast),
-	STATS_DESC_COUNTER(VCPU, pf_mmio_spte_created),
-	STATS_DESC_COUNTER(VCPU, pf_guest),
-	STATS_DESC_COUNTER(VCPU, tlb_flush),
-	STATS_DESC_COUNTER(VCPU, invlpg),
-	STATS_DESC_COUNTER(VCPU, exits),
-	STATS_DESC_COUNTER(VCPU, io_exits),
-	STATS_DESC_COUNTER(VCPU, mmio_exits),
-	STATS_DESC_COUNTER(VCPU, signal_exits),
-	STATS_DESC_COUNTER(VCPU, irq_window_exits),
-	STATS_DESC_COUNTER(VCPU, nmi_window_exits),
-	STATS_DESC_COUNTER(VCPU, l1d_flush),
-	STATS_DESC_COUNTER(VCPU, halt_exits),
-	STATS_DESC_COUNTER(VCPU, request_irq_exits),
-	STATS_DESC_COUNTER(VCPU, irq_exits),
-	STATS_DESC_COUNTER(VCPU, host_state_reload),
-	STATS_DESC_COUNTER(VCPU, fpu_reload),
-	STATS_DESC_COUNTER(VCPU, insn_emulation),
-	STATS_DESC_COUNTER(VCPU, insn_emulation_fail),
-	STATS_DESC_COUNTER(VCPU, hypercalls),
-	STATS_DESC_COUNTER(VCPU, irq_injections),
-	STATS_DESC_COUNTER(VCPU, nmi_injections),
-	STATS_DESC_COUNTER(VCPU, req_event),
-	STATS_DESC_COUNTER(VCPU, nested_run),
-	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
-	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
-	STATS_DESC_COUNTER(VCPU, preemption_reported),
-	STATS_DESC_COUNTER(VCPU, preemption_other),
-	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
-	STATS_DESC_COUNTER(VCPU, notify_window_exits),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, pf_taken),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, pf_fixed),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, pf_emulate),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, pf_spurious),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, pf_fast),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, pf_mmio_spte_created),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, pf_guest),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, tlb_flush),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, invlpg),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, exits),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, io_exits),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, mmio_exits),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, signal_exits),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, irq_window_exits),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, nmi_window_exits),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, l1d_flush),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, halt_exits),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, request_irq_exits),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, irq_exits),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, host_state_reload),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, fpu_reload),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, insn_emulation),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, insn_emulation_fail),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, hypercalls),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, irq_injections),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, nmi_injections),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, req_event),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, nested_run),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, directed_yield_attempted),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, directed_yield_successful),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, preemption_reported),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, preemption_other),
+	KVM_STAT(VCPU, INSTANT, BOOLEAN, guest_mode),
+	KVM_STAT(VCPU, CUMULATIVE, NONE, notify_window_exits),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1ce77c579cdc..b66a1479432e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1803,103 +1803,46 @@ struct _kvm_stats_desc {
 #define STATS_DESC(SCOPE, _stat, _name, _type, _unit, _base, _exponent, _size, \
 		   _bucket_size)					       \
 	SCOPE##_STATS_DESC(_stat, _type, _name, _unit, _base, _exponent,       \
-			   _size, _bucket_size)	       \
+			   _size, _bucket_size)
 
-#define STATS_DESC_CUMULATIVE(SCOPE, _stat, _name, _unit, _base, exponent)     \
-	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_CUMULATIVE,	       \
-		   _unit, _base, exponent, 1, 0)
-#define STATS_DESC_INSTANT(SCOPE, _stat, _name, _unit, _base, exponent)	       \
-	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_INSTANT,		       \
-		   _unit, _base, exponent, 1, 0)
-#define STATS_DESC_PEAK(SCOPE, _stat, _name, _unit, _base, exponent)	       \
-	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_PEAK,		       \
-		   _unit, _base, exponent, 1, 0)
-#define STATS_DESC_LINEAR_HIST(SCOPE, _stat, _name, _unit, _base, exponent,    \
-			       _size, _bucket_size)			       \
-	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_LINEAR_HIST,	       \
-		   _unit, _base, exponent, _size, _bucket_size)
-#define STATS_DESC_LOG_HIST(SCOPE, _stat, _name, _unit, _base, exponent,       \
-			    _size)					       \
-	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_LOG_HIST,	       \
-		   _unit, _base, exponent, _size, 0)
+#define __KVM_STAT(SCOPE, TYPE, UNIT, _stat, _name)				\
+	STATS_DESC(SCOPE, _stat, _name, KVM_STATS_TYPE_##TYPE,			\
+		   KVM_STATS_UNIT_##UNIT, KVM_STATS_BASE_POW10, 0, 1, 0)
 
-/* Cumulative counter, read/write */
-#define __STATS_DESC_COUNTER(SCOPE, _stat, _name)			       \
-	STATS_DESC_CUMULATIVE(SCOPE, _stat, _name, KVM_STATS_UNIT_NONE,	       \
-			      KVM_STATS_BASE_POW10, 0)
-#define STATS_DESC_COUNTER(SCOPE, _stat)				       \
-	__STATS_DESC_COUNTER(SCOPE, _stat, #_stat)
+#define KVM_STAT(SCOPE, TYPE, UNIT, _stat)					\
+	__KVM_STAT(SCOPE, TYPE, UNIT, _stat, #_stat)
 
-/* Instantaneous counter, read only */
-#define __STATS_DESC_ICOUNTER(SCOPE, _stat, _name)			       \
-	STATS_DESC_INSTANT(SCOPE, _stat, _name, KVM_STATS_UNIT_NONE,	       \
-			   KVM_STATS_BASE_POW10, 0)
-#define STATS_DESC_ICOUNTER(SCOPE, _stat)				       \
-	__STATS_DESC_ICOUNTER(SCOPE, _stat, #_stat)
+#define KVM_STAT_NSEC(SCOPE, TYPE, _stat)					\
+	STATS_DESC(SCOPE, _stat, #_stat, KVM_STATS_TYPE_##TYPE,			\
+		   KVM_STATS_UNIT_SECONDS, KVM_STATS_BASE_POW10, -9, 1, 0)
 
-/* Peak counter, read/write */
-#define __STATS_DESC_PCOUNTER(SCOPE, _stat, _name)			       \
-	STATS_DESC_PEAK(SCOPE, _stat, _name, KVM_STATS_UNIT_NONE,	       \
-			KVM_STATS_BASE_POW10, 0)
-#define STATS_DESC_PCOUNTER(SCOPE, _stat)				       \
-	__STATS_DESC_PCOUNTER(SCOPE, _stat, #_stat)
+#define KVM_HIST(SCOPE, TYPE, UNIT, _stat)					\
+	STATS_DESC(SCOPE, _stat, #_stat, KVM_STATS_TYPE_##TYPE##_HIST,		\
+		   KVM_STATS_UNIT_##UNIT, KVM_STATS_BASE_POW10, 0, _size, _bucket_size)
 
-/* Instantaneous boolean value, read only */
-#define __STATS_DESC_IBOOLEAN(SCOPE, _stat, _name)			       \
-	STATS_DESC_INSTANT(SCOPE, _stat, _name, KVM_STATS_UNIT_BOOLEAN,	       \
-			   KVM_STATS_BASE_POW10, 0)
-#define STATS_DESC_IBOOLEAN(SCOPE, _stat)				       \
-	__STATS_DESC_IBOOLEAN(SCOPE, _stat, #_stat)
-
-/* Peak (sticky) boolean value, read/write */
-#define __STATS_DESC_PBOOLEAN(SCOPE, _stat, _name)			       \
-	STATS_DESC_PEAK(SCOPE, _stat, _name, KVM_STATS_UNIT_BOOLEAN,	       \
-			KVM_STATS_BASE_POW10, 0)
-#define STATS_DESC_PBOOLEAN(SCOPE, _stat)				       \
-	__STATS_DESC_PBOOLEAN(SOPE, _stat, #_stat)
-
-/* Cumulative time in nanosecond */
-#define __STATS_DESC_TIME_NSEC(SCOPE, _stat, _name)			       \
-	STATS_DESC_CUMULATIVE(SCOPE, _stat, _name, KVM_STATS_UNIT_SECONDS,     \
-			      KVM_STATS_BASE_POW10, -9)
-#define STATS_DESC_TIME_NSEC(SCOPE, _stat)				       \
-	__STATS_DESC_TIME_NSEC(SCOPE, _stat, #_stat)
-
-/* Linear histogram for time in nanosecond */
-#define __STATS_DESC_LINHIST_TIME_NSEC(SCOPE, _stat, _name, _size,             \
-				       _bucket_size)			       \
-	STATS_DESC_LINEAR_HIST(SCOPE, _stat, _name, KVM_STATS_UNIT_SECONDS,    \
-			       KVM_STATS_BASE_POW10, -9, _size, _bucket_size)
-#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, _stat, _size, _bucket_size)	       \
-	__STATS_DESC_LINHIST_TIME_NSEC(SCOPE, _stat, #_stat, _size,	       \
-				       _bucket_size)
-
-/* Logarithmic histogram for time in nanosecond */
-#define __STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, _stat, _name, _size)	       \
-	STATS_DESC_LOG_HIST(SCOPE, _stat, _name, KVM_STATS_UNIT_SECONDS,       \
-			    KVM_STATS_BASE_POW10, -9, _size)
-#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, _stat, _size)		       \
-	__STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, _stat, #_stat, _size)
+#define KVM_HIST_NSEC(SCOPE, TYPE, _stat, _size, _bucket_size)			\
+	STATS_DESC(SCOPE, _stat, #_stat, KVM_STATS_TYPE_##TYPE##_HIST,		\
+		   KVM_STATS_UNIT_SECONDS, KVM_STATS_BASE_POW10, -9, _size, _bucket_size)
 
 #define KVM_GENERIC_VM_STATS()						       \
-	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),		       \
-	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush_requests)
+	KVM_STAT(VM_GENERIC, CUMULATIVE, NONE, remote_tlb_flush),	       \
+	KVM_STAT(VM_GENERIC, CUMULATIVE, NONE, remote_tlb_flush_requests)
 
-#define KVM_GENERIC_VCPU_STATS()					       \
-	STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),		       \
-	STATS_DESC_COUNTER(VCPU_GENERIC, halt_attempted_poll),		       \
-	STATS_DESC_COUNTER(VCPU_GENERIC, halt_poll_invalid),		       \
-	STATS_DESC_COUNTER(VCPU_GENERIC, halt_wakeup),			       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_success_ns),	       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns),		       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns),		       \
-	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_success_hist,     \
-			HALT_POLL_HIST_COUNT),				       \
-	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
-			HALT_POLL_HIST_COUNT),				       \
-	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
-			HALT_POLL_HIST_COUNT),				       \
-	STATS_DESC_IBOOLEAN(VCPU_GENERIC, blocking)
+#define KVM_GENERIC_VCPU_STATS()						\
+	KVM_STAT(VCPU_GENERIC, CUMULATIVE, NONE, halt_successful_poll),		\
+	KVM_STAT(VCPU_GENERIC, CUMULATIVE, NONE, halt_attempted_poll),		\
+	KVM_STAT(VCPU_GENERIC, CUMULATIVE, NONE, halt_poll_invalid),		\
+	KVM_STAT(VCPU_GENERIC, CUMULATIVE, NONE, halt_wakeup),			\
+	KVM_STAT_NSEC(VCPU_GENERIC, CUMULATIVE, halt_poll_success_ns),		\
+	KVM_STAT_NSEC(VCPU_GENERIC, CUMULATIVE, halt_poll_fail_ns),		\
+	KVM_STAT_NSEC(VCPU_GENERIC, CUMULATIVE, halt_wait_ns),			\
+	KVM_HIST_NSEC(VCPU_GENERIC, LINEAR, halt_poll_success_hist,		\
+		      HALT_POLL_HIST_COUNT, 0),					\
+	KVM_HIST_NSEC(VCPU_GENERIC, LINEAR, halt_poll_fail_hist,		\
+		      HALT_POLL_HIST_COUNT, 0),					\
+	KVM_HIST_NSEC(VCPU_GENERIC, LINEAR, halt_wait_hist,			\
+		      HALT_POLL_HIST_COUNT, 0),					\
+	KVM_STAT(VCPU_GENERIC, INSTANT, BOOLEAN, blocking)
 
 extern struct dentry *kvm_debugfs_dir;
 

base-commit: 80e5e70ae8ec0a3317cf9900d98c5540955fd6de
-- 


