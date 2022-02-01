Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8234A5D62
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 14:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238553AbiBANZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 08:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238435AbiBANZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 08:25:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FEEC061714;
        Tue,  1 Feb 2022 05:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zhqJ6iF/WSUlmg5JXO4IoUaxqNWDhAoQkXxw+iV/WK4=; b=tpPDO3JA14/yhshzHlabfrlKKW
        36DZLxGfMKpXu9pjQlGQfhp/17nMfDyPsf0BQzCISNsdeA4HTUqbzcACpO6/xK2rEjU0Yx6HFNtjq
        OdKvmIoBbZtmWk0XfQ3G80MEtXMGTCGHgw75MBKlvPjUpl+PRx/f8YxFdkFSSjqkHS76H/rL4Vh9x
        djreILhFj4XdJEie7sau/llBwz0ikkcaHPiQMPnC31x+yLBguLiM1qGt3MNEg+agCk0VhRkRdpfFA
        0QfxrblopvgKM1PMGLeJ2GbKDRrjoRfsn1Wer42tmQQN+EnR1Tp9j7sFmj/J1HpkpJX6Uobwo3n4k
        kw5sQ7ow==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nEt9n-00CHJm-O6; Tue, 01 Feb 2022 13:25:16 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D8FF098623E; Tue,  1 Feb 2022 14:25:14 +0100 (CET)
Date:   Tue, 1 Feb 2022 14:25:14 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH 0/5] perf/core: Address filter fixes / changes
Message-ID: <20220201132514.GX20638@worktop.programming.kicks-ass.net>
References: <20220131072453.2839535-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131072453.2839535-1-adrian.hunter@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 31, 2022 at 09:24:48AM +0200, Adrian Hunter wrote:
> Adrian Hunter (5):
>       perf/x86/intel/pt: Relax address filter validation
>       x86: Share definition of __is_canonical_address()
>       perf/core: Fix address filter parser for multiple filters
>       perf/x86/intel/pt: Fix address filter config for 32-bit kernel
>       perf/core: Allow kernel address filter when not filtering the kernel
> 
>  arch/x86/events/intel/pt.c  | 55 +++++++++++++++++++++++++++++++++------------
>  arch/x86/include/asm/page.h | 10 +++++++++
>  arch/x86/kvm/emulate.c      |  4 ++--
>  arch/x86/kvm/x86.c          |  2 +-
>  arch/x86/kvm/x86.h          |  7 +-----
>  arch/x86/mm/maccess.c       |  7 +-----
>  kernel/events/core.c        |  5 +++--
>  7 files changed, 59 insertions(+), 31 deletions(-)

Thanks! queued then for perf/core, if they're urgent give a shout and
I'll see if I can stick them in perf/urgent instead.
