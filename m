Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4D53C1B24
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 23:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhGHVo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 17:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhGHVoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 17:44:55 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB08EC06175F
        for <kvm@vger.kernel.org>; Thu,  8 Jul 2021 14:42:12 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t9so7790101pgn.4
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 14:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BTssUIU0Hkcht1oMBHXsf5sT4efBSvwi3ZE6IgkkbiU=;
        b=azsapfAH0Vpt5f+X+8DYUN9tza8bhh4IF7FhpKhhxKan2d79Ym6roVjByecfjhrPuJ
         qNCzTW6E5xI96eYGlsEsgWdyvTkkoOA1mpH9E8gQk/z0R0T7RStf/I8F05tog05nY+XR
         kdFXSplw6L7oFuP4m2Zmb0Zx4SIV4YZxEd8ArMShJumBUB0pCPqsLmbufFFZr4aFDZPZ
         sDyQQxkRAGowILarsWQf8yR+Zihnz/Oc1NockBprATRq4mXNrWm0r8wG5jIAndixaLh4
         fxqyyLjpa45pt4OVslmVdppSURqVDyeVaHJqrmNl0ZCP0WZ8GVtrs3wMoCktQgPdRs/u
         yc6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BTssUIU0Hkcht1oMBHXsf5sT4efBSvwi3ZE6IgkkbiU=;
        b=rhsiTplv4whpn9zmNM8tWawdLaW8CXwh8b21xpTc3qB+9dNuCFoHXiNZ6eICFXRLpm
         TbVzVY1ETncE3jmbPJqAzJpi0H29dgirMNJbt2jKKlu+8OR6V/Bl16uPJ8Ix8VCVE1pZ
         PI7tegOTgs/k0W/O8jweQdRcYF2ggJ7L5eMdcJvETDSzsVzs0F/PzUZ6BiXwXApAvfAz
         iQvZ/LpoeGud3bCsFA7qzGHOskt/zKphKes8dw3VbJ09Xkyk2FgztdPgB7uUa1sAVRiL
         6PfSEmYQWfh4EYzoiCg/se4z8RQLtREbZ0JWyyEoYNgX6K7qm301P+/FIPjRTXic31AR
         HybA==
X-Gm-Message-State: AOAM531XOK/2mDm/ip5MY9DTEP0LwmE+pUjbIEGR/OygOeZHNJm9wPnR
        c+bq+2E1BK8jdZP9TDSyKZsIVA==
X-Google-Smtp-Source: ABdhPJzxkkH46u/AR+41eefbjbdjKlXyGPUGcyVQpnRpIUDUUSkDSzMnryyw6YUIu+F1rG/u/pwRtQ==
X-Received: by 2002:a63:655:: with SMTP id 82mr2432038pgg.133.1625780532170;
        Thu, 08 Jul 2021 14:42:12 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id v1sm3773235pfn.40.2021.07.08.14.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 14:42:11 -0700 (PDT)
Date:   Thu, 8 Jul 2021 21:42:07 +0000
From:   David Matlack <dmatlack@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v1 4/4] KVM: stats: Add halt polling related histogram
 stats
Message-ID: <YOdxLwJx00nQIR87@google.com>
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-5-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706180350.2838127-5-jingzhangos@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021 at 06:03:50PM +0000, Jing Zhang wrote:
> Add simple stats halt_wait_ns to record the time a VCPU has spent on
> waiting for all architectures (not just powerpc).
> Add three log histogram stats to record the distribution of time spent
> on successful polling, failed polling and VCPU wait.
> halt_poll_success_hist: Distribution of time spent before a successful
> polling.
> halt_poll_fail_hist: Distribution of time spent before a failed polling.
> halt_wait_hist: Distribution of time a VCPU has spent on waiting.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/powerpc/include/asm/kvm_host.h |  1 -
>  arch/powerpc/kvm/book3s.c           |  1 -
>  arch/powerpc/kvm/book3s_hv.c        | 20 +++++++++++++++++---
>  arch/powerpc/kvm/booke.c            |  1 -
>  include/linux/kvm_host.h            |  9 ++++++++-
>  include/linux/kvm_types.h           |  4 ++++
>  virt/kvm/kvm_main.c                 | 19 +++++++++++++++++++
>  7 files changed, 48 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 9f52f282b1aa..4931d03e5799 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -103,7 +103,6 @@ struct kvm_vcpu_stat {
>  	u64 emulated_inst_exits;
>  	u64 dec_exits;
>  	u64 ext_intr_exits;
> -	u64 halt_wait_ns;

The halt_wait_ns refactor should be a separate patch.

>  	u64 halt_successful_wait;
>  	u64 dbell_exits;
>  	u64 gdbell_exits;
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 5cc6e90095b0..b785f6772391 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -69,7 +69,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	STATS_DESC_COUNTER(VCPU, emulated_inst_exits),
>  	STATS_DESC_COUNTER(VCPU, dec_exits),
>  	STATS_DESC_COUNTER(VCPU, ext_intr_exits),
> -	STATS_DESC_TIME_NSEC(VCPU, halt_wait_ns),
>  	STATS_DESC_COUNTER(VCPU, halt_successful_wait),
>  	STATS_DESC_COUNTER(VCPU, dbell_exits),
>  	STATS_DESC_COUNTER(VCPU, gdbell_exits),
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index cd544a46183e..103f998cee75 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4144,19 +4144,33 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
>  
>  	/* Attribute wait time */
>  	if (do_sleep) {
> -		vc->runner->stat.halt_wait_ns +=
> +		vc->runner->stat.generic.halt_wait_ns +=
>  			ktime_to_ns(cur) - ktime_to_ns(start_wait);
> +		kvm_stats_log_hist_update(
> +				vc->runner->stat.generic.halt_wait_hist,
> +				LOGHIST_SIZE_LARGE,
> +				ktime_to_ns(cur) - ktime_to_ns(start_wait));
>  		/* Attribute failed poll time */
> -		if (vc->halt_poll_ns)
> +		if (vc->halt_poll_ns) {
>  			vc->runner->stat.generic.halt_poll_fail_ns +=
>  				ktime_to_ns(start_wait) -
>  				ktime_to_ns(start_poll);
> +			kvm_stats_log_hist_update(
> +				vc->runner->stat.generic.halt_poll_fail_hist,
> +				LOGHIST_SIZE_LARGE, ktime_to_ns(start_wait) -
> +				ktime_to_ns(start_poll));
> +		}
>  	} else {
>  		/* Attribute successful poll time */
> -		if (vc->halt_poll_ns)
> +		if (vc->halt_poll_ns) {
>  			vc->runner->stat.generic.halt_poll_success_ns +=
>  				ktime_to_ns(cur) -
>  				ktime_to_ns(start_poll);
> +			kvm_stats_log_hist_update(
> +				vc->runner->stat.generic.halt_poll_success_hist,
> +				LOGHIST_SIZE_LARGE,
> +				ktime_to_ns(cur) - ktime_to_ns(start_poll));
> +		}
>  	}
>  
>  	/* Adjust poll time */
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 5ed6c235e059..977801c83aff 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -67,7 +67,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	STATS_DESC_COUNTER(VCPU, emulated_inst_exits),
>  	STATS_DESC_COUNTER(VCPU, dec_exits),
>  	STATS_DESC_COUNTER(VCPU, ext_intr_exits),
> -	STATS_DESC_TIME_NSEC(VCPU, halt_wait_ns),
>  	STATS_DESC_COUNTER(VCPU, halt_successful_wait),
>  	STATS_DESC_COUNTER(VCPU, dbell_exits),
>  	STATS_DESC_COUNTER(VCPU, gdbell_exits),
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 356af173114d..268a0ccc9c5f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1369,7 +1369,14 @@ struct _kvm_stats_desc {
>  	STATS_DESC_COUNTER(VCPU_GENERIC, halt_poll_invalid),		       \
>  	STATS_DESC_COUNTER(VCPU_GENERIC, halt_wakeup),			       \
>  	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_success_ns),	       \
> -	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns)
> +	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns),		       \
> +	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_success_hist,     \
> +			LOGHIST_SIZE_LARGE),				       \

This should probably be a new macro rather than using LOGHIST_SIZE_LARGE
everywhere.

#define HALT_POLL_HIST_SIZE LOGHIST_SIZE_LARGE

> +	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
> +			LOGHIST_SIZE_LARGE),				       \
> +	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns),		       \
> +	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
> +			LOGHIST_SIZE_LARGE)
>  
>  extern struct dentry *kvm_debugfs_dir;
>  
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index cc88cd676775..7838a42932c8 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -103,6 +103,10 @@ struct kvm_vcpu_stat_generic {
>  	u64 halt_wakeup;
>  	u64 halt_poll_success_ns;
>  	u64 halt_poll_fail_ns;
> +	u64 halt_poll_success_hist[LOGHIST_SIZE_LARGE];
> +	u64 halt_poll_fail_hist[LOGHIST_SIZE_LARGE];
> +	u64 halt_wait_ns;
> +	u64 halt_wait_hist[LOGHIST_SIZE_LARGE];
>  };
>  
>  #define KVM_STATS_NAME_SIZE	48
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3dcc2abbfc60..840b5bece080 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3093,12 +3093,24 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  				++vcpu->stat.generic.halt_successful_poll;
>  				if (!vcpu_valid_wakeup(vcpu))
>  					++vcpu->stat.generic.halt_poll_invalid;
> +
> +				kvm_stats_log_hist_update(
> +				      vcpu->stat.generic.halt_poll_success_hist,
> +				      LOGHIST_SIZE_LARGE,
> +				      ktime_to_ns(ktime_get()) -
> +				      ktime_to_ns(start));
>  				goto out;
>  			}
>  			poll_end = cur = ktime_get();
>  		} while (kvm_vcpu_can_poll(cur, stop));
> +
> +		kvm_stats_log_hist_update(
> +				vcpu->stat.generic.halt_poll_fail_hist,
> +				LOGHIST_SIZE_LARGE,
> +				ktime_to_ns(ktime_get()) - ktime_to_ns(start));

nit: Consider creating a wrapper for kvm_stats_log_hist_update() since
there are so many call sites. You can save a line at every call site by
avoiding passing in the histogram size.

        void halt_poll_hist_update(u64 *histogram, ktime_t time)
        {
                kvm_stats_log_hist_update(histogram, LOGHIST_SIZE_LARGE, time);
        }


>  	}
>  
> +
>  	prepare_to_rcuwait(&vcpu->wait);
>  	for (;;) {
>  		set_current_state(TASK_INTERRUPTIBLE);
> @@ -3111,6 +3123,13 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	}
>  	finish_rcuwait(&vcpu->wait);
>  	cur = ktime_get();
> +	if (waited) {
> +		vcpu->stat.generic.halt_wait_ns +=
> +			ktime_to_ns(cur) - ktime_to_ns(poll_end);
> +		kvm_stats_log_hist_update(vcpu->stat.generic.halt_wait_hist,
> +				LOGHIST_SIZE_LARGE,
> +				ktime_to_ns(cur) - ktime_to_ns(poll_end));
> +	}
>  out:
>  	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
> -- 
> 2.32.0.93.g670b81a890-goog
> 
