Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7485D506257
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 04:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345531AbiDSC6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 22:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345501AbiDSC6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 22:58:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2B023BEF
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 19:55:30 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q3so13923850plg.3
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 19:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K5SWmkm3M1KXlKvWMogmnhHOSV5VRfdAKiKhpXad0MM=;
        b=kd1XaSqO+dDGtXb9gAKgf1G6moHxFNoBBGmqnuSt2atFJf60emXVMaEWXNhLzMVjfj
         5e15TxY5kse8eTXM7g0EUUPGuBzP/4iE+ehiOFIJNEWBEzONmgoo/mYhLiNQXVsnbawb
         9jZayC4pRjVJ5Dl4nWt0+D58XHnXhTorpCFbQCeqH2oNF8lgyvG3TOuBIVmJlFxhaFJf
         PGjhSglD7W6tMzfwa25eb3At4j94HbTlP20ihU6qmyfRJwbTQ4nOuNqbxyLK657IBJL6
         OvOBHOSu4sPdXLlnASZrBNUFYk2DwUfCQUwOsisO3M8g5lx/GZuPYqt5ojsShbDxr3uy
         /Iyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K5SWmkm3M1KXlKvWMogmnhHOSV5VRfdAKiKhpXad0MM=;
        b=mg0AKGDE1n92N9Pz3tlzMtpbKgdtg5yspuCOC0J6ormnBUirclCicTRLzedAxQXA/0
         B3g/6uJFazGz+WaDpvE0AXYUbj1gp4+EmuBVeLA+FQ9Sxi2S9kU4597n7CadnkdBhJum
         t7mzDSaUJ4R7vacnwRE/3e562QLeO1sFdOrqW63WwAQAh7jwxVGCuHIeIstGi0Trc5B7
         M1Gytt8utKDQqdacfRsUdD4P5Cd2alNXX7aojDuaYWbVcisWUedacaRjldkR0b15QBsK
         C/jMlpfHPlQFtErhKjLoEEj9FZMdZxBrcGfEIsGCK/dZJojlugS2PQs99NQSXClbruuF
         5mBw==
X-Gm-Message-State: AOAM532o4W/6+ieyoXKvYlI8z8vOmi07fj11mtyHHlA58LvNVqE0i7tl
        T/Yx1VqeAHzVgjOO6OHlw4XNnQ==
X-Google-Smtp-Source: ABdhPJxKlcRJjCzKGyjnWF3bYkZUsv4WUb3ngdGk4aVZN1U0VmPZG+/MVSwH4rG+04OpQL6kxvh7KQ==
X-Received: by 2002:a17:90a:638e:b0:1d2:b6e3:6e9d with SMTP id f14-20020a17090a638e00b001d2b6e36e9dmr4987050pjj.74.1650336929269;
        Mon, 18 Apr 2022 19:55:29 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a001a4a00b004f7c76f29c3sm14255668pfv.24.2022.04.18.19.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 19:55:28 -0700 (PDT)
Date:   Mon, 18 Apr 2022 19:55:24 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 04/17] KVM: arm64: Protect page table traversal with
 RCU
Message-ID: <Yl4knFR8E8XVbgDj@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-5-oupton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 09:58:48PM +0000, Oliver Upton wrote:
> Use RCU to safely traverse the page tables in parallel; the tables
> themselves will only be freed from an RCU synchronized context. Don't
> even bother with adding support to hyp, and instead just assume
> exclusive access of the page tables.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 5b64fbca8a93..d4699f698d6e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -132,9 +132,28 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
>  	return pte;
>  }
>  
> +
> +#if defined(__KVM_NVHE_HYPERVISOR__)
> +static inline void kvm_pgtable_walk_begin(void)
> +{}
> +
> +static inline void kvm_pgtable_walk_end(void)
> +{}
> +
> +#define kvm_dereference_ptep	rcu_dereference_raw
> +#else
> +#define kvm_pgtable_walk_begin	rcu_read_lock
> +
> +#define kvm_pgtable_walk_end	rcu_read_unlock
> +
> +#define kvm_dereference_ptep	rcu_dereference
> +#endif
> +
>  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
>  {
> -	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
> +	kvm_pte_t __rcu *ptep = mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
> +
> +	return kvm_dereference_ptep(ptep);
>  }
>  
>  static void kvm_clear_pte(kvm_pte_t *ptep)
> @@ -288,7 +307,9 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		.walker	= walker,
>  	};
>  
> +	kvm_pgtable_walk_begin();
>  	return _kvm_pgtable_walk(&walk_data);
> +	kvm_pgtable_walk_end();

This might be fixed later in the series, but at this point the
rcu_read_unlock is never called.

>  }
>  
>  struct leaf_walk_data {
> -- 
> 2.36.0.rc0.470.gd361397f0d-goog
> 
