Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7101D94DE
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 13:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgESLDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 07:03:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60884 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgESLDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 07:03:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ej3zoQJl5wKcQRgdxw7ZljDCpE6zMLEMikMDC8zw6yo=; b=eSGZ2VmtCNAkORypwtaQqJNgSj
        X1Ixh55nHJlzPpOdt0JopI6heH5P4k8VwHj/IcYnahHyPxAtDPz1hIxm4AEQexGX1dR9sEyNZzO49
        u0JA/ctFC+4igqXX7ZCPizlsQXu2ZRM7x9uaiNpO+x1AjrnL4Q7qvlSp7o4j/34VRIBGI3P05SXW4
        GDZPNEoazu6zS3l8ptYA6tTye6v8AUSrk9qmO+H3GXHpk/UrVTLXsTD6m/iuq2SOUMHo1bDa36U02
        We8URx1gIcyY4tsP/7xEojDpBRWkS5Pm+S41ymElo/SLYuspYyUdWxBb4VOV2sbbUAT7UuZr9FPGj
        hSak3I8A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jazzf-0005cc-Em; Tue, 19 May 2020 11:01:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0B1AB3008A8;
        Tue, 19 May 2020 13:01:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F16072868A9D5; Tue, 19 May 2020 13:01:04 +0200 (CEST)
Date:   Tue, 19 May 2020 13:01:04 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
Subject: Re: [PATCH v11 08/11] KVM: x86/pmu: Emulate LBR feature via guest
 LBR event
Message-ID: <20200519110104.GH279861@hirez.programming.kicks-ass.net>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-9-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514083054.62538-9-like.xu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 04:30:51PM +0800, Like Xu wrote:

> +	struct perf_event_attr attr = {
> +		.type = PERF_TYPE_RAW,
> +		.size = sizeof(attr),
> +		.pinned = true,
> +		.exclude_host = true,
> +		.config = INTEL_FIXED_VLBR_EVENT,
> +		.sample_type = PERF_SAMPLE_BRANCH_STACK,
> +		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
> +					PERF_SAMPLE_BRANCH_USER,

Maybe order the fields according to how they're declared in the
structure?

> +	};
