Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBDB7495DF
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 08:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbjGFGpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 02:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjGFGpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 02:45:34 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2983123;
        Wed,  5 Jul 2023 23:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1q25TAca/mCg6IosVYovkTmvvDhiJBtJTCHMC9/U4NM=; b=FMTs+5XlzUNkB3zEzSiFhl30k7
        NWnr2W83ziRSqhu4lnANw9FyRTIg2yNLCXiRvz0YYPE2ksfIcv+1Tf/Gv4fohCWT8Tdz/mUAVlzCu
        HBuVhNHGU6q1D9g7NrIaBJkOOQd9mEmfRPdRs//u1+wb/7UT1zTiydkKnKwJAWUb7tDUHbuasUxzH
        YS/LJTsExpEf60O7PHWGLkrqsbZzaxbEqOQER8Sp7ZJGoSxO8fqd6DrRRvkDBuD6C9sQ5X8OjKqcw
        tSkft5tjF6/LEGRBlM8hwpufvK0ocpAZPzlxhJqBLccMEK0BcVgNuTtRGm1j3vKLUO268xnDuzu6Y
        j6pJwZ7Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qHIjv-00DVAo-2u;
        Thu, 06 Jul 2023 06:45:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4848C30012F;
        Thu,  6 Jul 2023 08:45:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3927F200BDD20; Thu,  6 Jul 2023 08:45:19 +0200 (CEST)
Date:   Thu, 6 Jul 2023 08:45:19 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com
Subject: Re: [PATCH] x86/trapnr: Add event type macros to <asm/trapnr.h>
Message-ID: <20230706064519.GC2833176@hirez.programming.kicks-ass.net>
References: <20230706051443.2054-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230706051443.2054-1-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023 at 10:14:43PM -0700, Xin Li wrote:

> +/*
> + * Event type codes used by both Intel VT-x and FRED
> + */
> +/* Maskable external interrupt */
> +#define EVENT_TYPE_HWINT	0
> +#define EVENT_TYPE_RESERVED	1
> +#define EVENT_TYPE_NMI		2
> +/* Hardware exceptions (e.g., page fault) */
> +#define EVENT_TYPE_HWFAULT	3
> +/* Software interrupt (INT n) */
> +#define EVENT_TYPE_SWINT	4
> +/* INT1 (ICEBP) */
> +#define EVENT_TYPE_PRIVSW	5
> +/* Software exception (INT3 or INTO) */
> +#define EVENT_TYPE_SWFAULT	6
> +/* VT-x MTF or FRED SYSCALL/SYSENTER */
> +#define EVENT_TYPE_OTHER	7

So I know tglx hates on tail comments, but I find the below *MUCH* more
readable than the above horror show.

> -#define INTR_TYPE_EXT_INTR              (0 << 8) /* external interrupt */
> -#define INTR_TYPE_RESERVED              (1 << 8) /* reserved */
> -#define INTR_TYPE_NMI_INTR		(2 << 8) /* NMI */
> -#define INTR_TYPE_HARD_EXCEPTION	(3 << 8) /* processor exception */
> -#define INTR_TYPE_SOFT_INTR             (4 << 8) /* software interrupt */
> -#define INTR_TYPE_PRIV_SW_EXCEPTION	(5 << 8) /* ICE breakpoint - undocumented */
> -#define INTR_TYPE_SOFT_EXCEPTION	(6 << 8) /* software exception */
> -#define INTR_TYPE_OTHER_EVENT           (7 << 8) /* other event */
