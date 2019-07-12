Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E2866BBF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 13:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfGLLpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 07:45:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55464 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfGLLpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 07:45:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7WheT2sFPbpAYUphDY20RcxiluEPP2yGBWlv6nqCcpo=; b=THypPdhej8/b1YWUg1gyexApx
        27rbpPcSBzGOOshG/kAYscKus1Ew/eOU5gf9H9brrUNp/PL/1yAXw/FRqTM9KeGIFKW0sT6VvmMfK
        dxA2HakjTPM7ZH5hjJb9dFsW475nPrHOSuB4zbm2t4DTMfP0ymwVL8uXw/pmmGlO/LSMZiZrYLz+E
        Uhd/JjQBAgym+6ZFFGwIegs47sVyGzYM7riZt8FU2L+e5mHTfJxzE1sYtiCrqPj9r9w/Hg2Z6pbks
        RYpGUb6epfiraNJqrQNpNOUonB1BaYJTo9nW9B3w6Bfs1yQ5z+bsLC0Td5ReYT0TnhNrB6jvGZx3z
        OGOpmAd7Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hltz2-0005PZ-N5; Fri, 12 Jul 2019 11:45:00 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C66F4209772E7; Fri, 12 Jul 2019 13:44:58 +0200 (CEST)
Date:   Fri, 12 Jul 2019 13:44:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
Message-ID: <20190712114458.GU3402@hirez.programming.kicks-ass.net>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 11, 2019 at 04:25:12PM +0200, Alexandre Chartre wrote:
> Kernel Address Space Isolation aims to use address spaces to isolate some
> parts of the kernel (for example KVM) to prevent leaking sensitive data
> between hyper-threads under speculative execution attacks. You can refer
> to the first version of this RFC for more context:
> 
>    https://lkml.org/lkml/2019/5/13/515

No, no, no!

That is the crux of this entire series; you're not punting on explaining
exactly why we want to go dig through 26 patches of gunk.

You get to exactly explain what (your definition of) sensitive data is,
and which speculative scenarios and how this approach mitigates them.

And included in that is a high level overview of the whole thing.

On the one hand you've made this implementation for KVM, while on the
other hand you're saying it is generic but then fail to describe any
!KVM user.

AFAIK all speculative fails this is relevant to are now public, so
excruciating horrible details are fine and required.

AFAIK2 this is all because of MDS but it also helps with v1.

AFAIK3 this wants/needs to be combined with core-scheduling to be
useful, but not a single mention of that is anywhere.
