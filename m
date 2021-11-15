Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765DF4503BB
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 12:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhKOLqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 06:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhKOLqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 06:46:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AD4C061766;
        Mon, 15 Nov 2021 03:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oW6LcrDKI8y4NUK+N5FT4E/9It3R00jJ14PrLqrA138=; b=nHm9RL754aI3J7TW7S0W4nUtzr
        37X1xu6V1voUKR0wClsAPr2JHErwCdA/pDZwAcskp0LAbxHSPknVWJr7pqtC8NMIo1KHq4V+f2OyF
        leufQudZhJh7d9iaFm2T7AIc3XXvrcYvGb2UE4rp4weGB3sq1DCH2uWCltMogQn2+KpSbQUNgL3N/
        OVS1NXsj1YiqouLhGeIZyzRsbsbXmm3V5KG03p2AvnyOqfm1rs1+RWrsBk/pNzbwBtFhB5YCkLnkN
        EqBCwMNMkqH073b/0jkE3j/tkp62zm+agMqitPlc8mcAZl13yIl78m8+9cj7epF+77rDdJlUqXhFK
        tj0oCaTA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmaOG-005erK-Ut; Mon, 15 Nov 2021 11:43:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BCEE0300129;
        Mon, 15 Nov 2021 12:43:12 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 706AC20265B5A; Mon, 15 Nov 2021 12:43:12 +0100 (CET)
Date:   Mon, 15 Nov 2021 12:43:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Vihas Mak <makvihas@gmail.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix cocci warnings
Message-ID: <YZJH0Hd/ETYWJGTX@hirez.programming.kicks-ass.net>
References: <20211114164312.GA28736@makvihas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211114164312.GA28736@makvihas>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 14, 2021 at 10:13:12PM +0530, Vihas Mak wrote:
> change 0 to false and 1 to true to fix following cocci warnings:
> 
>         arch/x86/kvm/mmu/mmu.c:1485:9-10: WARNING: return of 0/1 in function 'kvm_set_pte_rmapp' with return type bool
>         arch/x86/kvm/mmu/mmu.c:1636:10-11: WARNING: return of 0/1 in function 'kvm_test_age_rmapp' with return type bool

That script should be deleted, it's absolute garbage.
