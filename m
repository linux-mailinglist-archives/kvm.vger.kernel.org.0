Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C349F211D31
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 09:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGBHld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 03:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgGBHlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 03:41:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F09C08C5C1;
        Thu,  2 Jul 2020 00:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XTabvSLO7S5tELpoXrJiNFuMzsHwzZp5WpQClf4PKdk=; b=sFgSl9Gcs3uRIVF548A0umcLQi
        AYzzAb0cgK1h5LwXjvrGL5QlYbYgclSEKGtQ5tkEMf9oqwvekDTGpGihN6spqQLWxbkv/xGizG/Y9
        WWbPTB0Iq57rX8tmEYegHLfU11KypvtrGRBwXATY74N33TY8slcS0ZuB3KmZzMu4Ec9XG7HKckpdu
        rOFuSDmVjg5Xrt7ubIC7FrM3G/SvlhhnOCBwz/THMKv05SdGA07BTmTeMHazs9aLXXO6tNurvl+DJ
        GRdsJmn5y8ZcZwdJsvQNTXJH4R1hW+S8N/7bfXH860MbylzsTrc9vCqhkRsCYb+e5JvsiNKhHQ/jH
        Z+kv+yYA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqtq9-0006AV-NN; Thu, 02 Jul 2020 07:41:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7240E3003D8;
        Thu,  2 Jul 2020 09:40:59 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 366CA23D44E56; Thu,  2 Jul 2020 09:40:59 +0200 (CEST)
Date:   Thu, 2 Jul 2020 09:40:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "Liang, Kan" <kan.liang@intel.com>
Subject: Re: [PATCH v12 00/11] Guest Last Branch Recording Enabling
Message-ID: <20200702074059.GX4781@hirez.programming.kicks-ass.net>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 13, 2020 at 04:09:45PM +0800, Like Xu wrote:
> Like Xu (10):
>   perf/x86/core: Refactor hw->idx checks and cleanup
>   perf/x86/lbr: Add interface to get LBR information
>   perf/x86: Add constraint to create guest LBR event without hw counter
>   perf/x86: Keep LBR records unchanged in host context for guest usage

> Wei Wang (1):
>   perf/x86: Fix variable types for LBR registers

>  arch/x86/events/core.c            |  26 +--
>  arch/x86/events/intel/core.c      | 109 ++++++++-----
>  arch/x86/events/intel/lbr.c       |  51 +++++-
>  arch/x86/events/perf_event.h      |   8 +-
>  arch/x86/include/asm/perf_event.h |  34 +++-

These look good to me; but at the same time Kan is sending me
Architectural LBR patches.

Kan, if I take these perf patches and stick them in a tip/perf/vlbr
topic branch, can you rebase the arch lbr stuff on top, or is there
anything in the arch-lbr series that badly conflicts with this work?

Paolo, would that topic branch work for you too, to then stick these
patches in top?

>   KVM: vmx/pmu: Expose LBR to guest via MSR_IA32_PERF_CAPABILITIES
>   KVM: vmx/pmu: Unmask LBR fields in the MSR_IA32_DEBUGCTLMSR emualtion
>   KVM: vmx/pmu: Pass-through LBR msrs when guest LBR event is scheduled
>   KVM: vmx/pmu: Emulate legacy freezing LBRs on virtual PMI
>   KVM: vmx/pmu: Reduce the overhead of LBR pass-through or cancellation
>   KVM: vmx/pmu: Release guest LBR event via lazy release mechanism

>  arch/x86/kvm/pmu.c                |  12 +-
>  arch/x86/kvm/pmu.h                |   5 +
>  arch/x86/kvm/vmx/capabilities.h   |  23 ++-
>  arch/x86/kvm/vmx/pmu_intel.c      | 253 +++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.c            |  86 +++++++++-
>  arch/x86/kvm/vmx/vmx.h            |  17 ++
>  arch/x86/kvm/x86.c                |  13 --

>  12 files changed, 559 insertions(+), 78 deletions(-)
