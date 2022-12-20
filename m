Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78915651CB7
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 09:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbiLTI5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 03:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbiLTI5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 03:57:54 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4027641A;
        Tue, 20 Dec 2022 00:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4LLoXs0YmmC+8xuhFiNsmwF2piCN9HbyyxvZrUozHqU=; b=ntsRP6wqOtsEATuXYDnJmRpTkP
        +1jOwQq5A7mcfp7WTt42UW0lYcfKvqSzzq0ZvxUUuIZa9Gy90lvKEZk1jP6IoomaWunqYN42Q/pag
        4/iR+KL8lpRKGy5c0xfUqu/PGp468/21p0X9kP7cPYAb0I+FwPAF7CkmRo8CjeAEfD94UL3YqEPhR
        fR3idqoVzNGYV03bQJsCEqSFR5FFAQUIiYMHuAKl/F6rWe0N7Uzg7cVErAZbN/hjRsLhzbxjmqWTV
        bywPcnSLWGvQ6TThFHw6qCN7ehBvD2vGVm/8WWs0VXIat6J0bKKWAwaYIQmU1xvCfBCWWPNfjluFV
        TAL9ZqBg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p7YQ9-00CwF0-1o;
        Tue, 20 Dec 2022 08:57:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CECCA3000DD;
        Tue, 20 Dec 2022 09:56:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B59582C5F830C; Tue, 20 Dec 2022 09:56:19 +0100 (CET)
Date:   Tue, 20 Dec 2022 09:56:19 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [RFC PATCH 14/32] x86/fred: header file with FRED definitions
Message-ID: <Y6F4s0K2b2G8aMve@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-15-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220063658.19271-15-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> +/*
> + * FRED return instructions
> + *
> + * Replace with "ERETS"/"ERETU" once binutils support FRED return instructions.

binutils version that supports these instructions goes here...

> + */
> +#define ERETS			_ASM_BYTES(0xf2,0x0f,0x01,0xca)
> +#define ERETU			_ASM_BYTES(0xf3,0x0f,0x01,0xca)
> +
> +/*
> + * Event stack level macro for the FRED_STKLVLS MSR.
> + * Usage example: FRED_STKLVL(X86_TRAP_DF, 3)
> + * Multiple values can be ORd together.
> + */
> +#define FRED_STKLVL(v,l)	(_AT(unsigned long, l) << (2*(v)))
> +
> +/* FRED_CONFIG MSR */
> +#define FRED_CONFIG_CSL_MASK		0x3
> +#define FRED_CONFIG_SHADOW_STACK_SPACE	_BITUL(3)
> +#define FRED_CONFIG_REDZONE(b)		__ALIGN_KERNEL_MASK((b), _UL(0x3f))
> +#define FRED_CONFIG_INT_STKLVL(l)	(_AT(unsigned long, l) << 9)
> +#define FRED_CONFIG_ENTRYPOINT(p)	_AT(unsigned long, (p))
> +
> +/* FRED event type and vector bit width and counts */
> +#define FRED_EVENT_TYPE_BITS		3 /* only 3 bits used in FRED 3.0 */
> +#define FRED_EVENT_TYPE_COUNT		_BITUL(FRED_EVENT_TYPE_BITS)
> +#define FRED_EVENT_VECTOR_BITS		8
> +#define FRED_EVENT_VECTOR_COUNT		_BITUL(FRED_EVENT_VECTOR_BITS)
> +
> +/* FRED EVENT_TYPE_OTHER vector numbers */
> +#define FRED_SYSCALL			1
> +#define FRED_SYSENTER			2
> +
> +/* Flags above the CS selector (regs->csl) */
> +#define FRED_CSL_ENABLE_NMI		_BITUL(28)
> +#define FRED_CSL_ALLOW_SINGLE_STEP	_BITUL(25)
> +#define FRED_CSL_INTERRUPT_SHADOW	_BITUL(24)

What's the state of IBT WAIT-FOR-ENDBR vs this? That really should also
get a high CS bit.
