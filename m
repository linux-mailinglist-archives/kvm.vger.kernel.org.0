Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F2630341D
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbhAZFQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbhAYMT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 07:19:29 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B417DC061788;
        Mon, 25 Jan 2021 04:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=W1U508PbLkgwTccNSwME/R6sQRgPyIR7/FJo2A8YTu8=; b=ajM4lt9pcZxmzaCaNYOQ5tgX52
        nUbHhja1AXzBoo5MXH9nHEEE+EG15rpAKQIUw5iYjfCYXN9+fYcI9x41Ak645sUE0npOUrwInm3VM
        /Z047ws1ViAH8/08pF9hTVOOEVztOEGInatExkFLUqfw2iJqoUzriwkQmooewCffLV7rRcLE+b/qn
        1EbKy8ItUKDTMEVqjNNDmU+lvBaQNrUDwpn4TxyKNnoJdthDIdW6O8o3UOkASatebnVxqd5/EdTeW
        OKxVkMzZn8GPn6LXQTXUhD8z3QANFXIUl+ddG5cgN0nKvIFVMTM0e8EV4Qv/DUc8ifcYrUgMzVnPX
        2yJi1z8g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l40oq-0006P0-RS; Mon, 25 Jan 2021 12:18:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 36ABE3010C8;
        Mon, 25 Jan 2021 13:18:04 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1FD962B069EF9; Mon, 25 Jan 2021 13:18:04 +0100 (CET)
Date:   Mon, 25 Jan 2021 13:18:04 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
Message-ID: <YA62/DV7reRvVyYk@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
 <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
 <YAHXlWmeR9p6JZm2@google.com>
 <20210115182700.byczztx3vjhsq3p3@two.firstfloor.org>
 <YAHkOiQsxMfOMYvp@google.com>
 <YAqhPPkexq+dQ5KD@hirez.programming.kicks-ass.net>
 <eb30d86f-6492-d6e3-3a24-f58c724f68fd@linux.intel.com>
 <YA6nxuM5Stlolk5x@hirez.programming.kicks-ass.net>
 <076a5c7b-de2e-daf9-e6c0-5a42fb38aaa3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <076a5c7b-de2e-daf9-e6c0-5a42fb38aaa3@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021 at 08:07:06PM +0800, Xu, Like wrote:

> So under the premise that counter cross-mapping is allowed,
> how can hypercall help fix it ?

Hypercall or otherwise exposing the mapping, will let the guest fix it
up when it already touches the data. Which avoids the host from having
to access the guest memory and is faster, no?
