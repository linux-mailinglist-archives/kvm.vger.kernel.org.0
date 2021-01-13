Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2142F520C
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 19:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbhAMSaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 13:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbhAMSaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 13:30:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D0DC061575;
        Wed, 13 Jan 2021 10:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5HGRAFQITVRUvJXlrDluatF64Db9+nU6uEXhywkvngg=; b=ATqIEHVY+6AGyqtS0NR9HlbQgO
        ZUlGt3koP3YMDLhaxHbiwMsFrkulbdojHRkxzrz8cw9LvD/iPNmwguJuKR4qjXD7j0RdIe7ztya46
        ZU5GH9GhFuTMmnLr9kDqpd5R0X4TwXFapUIsCAuK3+aOL20MNEviSSt3b30TqM5Jn2qzgXPSevasT
        I7B4tUDAxUIyjo30w0ka9k9BKoxNgbSUsYiMtMWC3nNFVSYgtLpNMZOxGnaJD0zuGBNfVaYd9UOe7
        wa1liy0Q1VWI4zZ+JBYizeilP2/lVqTPQftD6sBbs3puwtCF72iHIg2RcIeAtrWsb9xFMomuKYXWL
        CrID3s1g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzks1-006Z9G-Bi; Wed, 13 Jan 2021 18:28:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D1A443060C5;
        Wed, 13 Jan 2021 19:27:48 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BD660211618D3; Wed, 13 Jan 2021 19:27:48 +0100 (CET)
Date:   Wed, 13 Jan 2021 19:27:48 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI
 and inject it to guest
Message-ID: <X/87pChioUE7hsK/@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
 <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021 at 07:22:09PM +0100, Peter Zijlstra wrote:
> Again; for the virt illiterate people here (me); why is it expensive to
> check guest DS?

Remember, you're trying to get someone that thinks virt is the devil's
work (me) to review virt patches. You get to spell things out in detail.

