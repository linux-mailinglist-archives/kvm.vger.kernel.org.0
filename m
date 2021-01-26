Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5B9303A85
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 11:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404249AbhAZKjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 05:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404186AbhAZKje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 05:39:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A098FC06174A;
        Tue, 26 Jan 2021 02:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Pxo8uZRUhENPW3XIRCXJ8iQA/Z1MSNpaDogrCKSFXlU=; b=nZ8BLIiuTqNMm7dM+EeDAmkWHE
        +llp6DlJXADF0aQXp2gSslLaAHK5VGfegLyT8qy8MjpqkAhUVoLbR3SwxM7rgeGME8CDJ+SBXa8tz
        KkXYO9bjdaHDVUSGBBzWLJAA37eyawbJaToXgRh2TWQx8+LK9qk97afTxANeYU0IPMLxyS3ZdGdin
        EKW+2wQQm38mw+GCh68EvLxIEUauM1wrOQj+vj82zdakEo5sI0KLq+f5j+skM0Op6tGcf+/jdOB5F
        O3OmbicpjZkUB1E6Tr95rA63CFV254b+tDtJ9YsBDDAGVQJrwRBxMPwgkGE05XgTYt/8XeWkqnwcY
        G4ovpHag==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l4Li6-005RqZ-Dm; Tue, 26 Jan 2021 10:36:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 834793059C6;
        Tue, 26 Jan 2021 11:36:33 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7465E20F042C2; Tue, 26 Jan 2021 11:36:33 +0100 (CET)
Date:   Tue, 26 Jan 2021 11:36:33 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Xu, Like" <like.xu@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf/intel: Remove Perfmon-v4 counter_freezing support
Message-ID: <YA/wsQQqbGD1pCDR@hirez.programming.kicks-ass.net>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201110151257.GP2611@hirez.programming.kicks-ass.net>
 <20201110153721.GQ2651@hirez.programming.kicks-ass.net>
 <CABPqkBS+-g0qbsruAMfOJf-Zfac8nz9v2LCWfrrvVd+ptoLxZg@mail.gmail.com>
 <2ce24056-0711-26b3-a62c-3bedc88d7aa7@intel.com>
 <9a85e154-d552-3478-6e99-3f693b3da7ed@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a85e154-d552-3478-6e99-3f693b3da7ed@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021 at 10:51:39AM +0100, Paolo Bonzini wrote:
> What is the state of this work?  I was expecting a new version that doesn't
> use counter_freezing.  However, I see that counter_freezing is still in
> there, so this patch from Peter has never been applied.

Bah, I forgot about it. Lemme go find it.
