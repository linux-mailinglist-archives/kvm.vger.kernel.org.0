Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E743C2B67AE
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 15:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgKQOla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 09:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728383AbgKQOla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 09:41:30 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5649C0613CF;
        Tue, 17 Nov 2020 06:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qXjtO1woaol7iPwADIP46DxZv5Jgw/GuoGZBgKxipSY=; b=bB0fh6w0LIojpefdBm8nT/fKZ4
        PdU5JS6RKYiXV7ndxrqUiRSY6z55d2+9liCi5DgiC6bxryaGvpI8c3IZvAh0gQvM/Tfs9J+I4i60K
        ScdPi1rptONFBjFL3iWIxpXAwHxh+KzHhCvoc3u/AvL1KpHJw8XJFl2LBBl/DhWEkaLetdrF3Xy9P
        tyvExE4SP5TZU6VlX4aTcUtHVYNtXDXfBXpHR4oKjF62kVayyKgwC3hmV2DXvgUd6ZW49pIPmVFsc
        FNgY1F/P+qNHc1YV2jxUn21esttrcw/MM28ahbdIhBksklTSXQjVSHmNZnjIAJKE5Qsiol2rCxPfZ
        NJxOgDdg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kf2AJ-0006Sn-3j; Tue, 17 Nov 2020 14:41:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BB9713077B1;
        Tue, 17 Nov 2020 15:41:00 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9B1FD200E0A35; Tue, 17 Nov 2020 15:41:00 +0100 (CET)
Date:   Tue, 17 Nov 2020 15:41:00 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/17] KVM: x86/pmu: Reprogram guest PEBS event to
 emulate guest PEBS counter
Message-ID: <20201117144100.GK3121406@hirez.programming.kicks-ass.net>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201109021254.79755-6-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109021254.79755-6-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09, 2020 at 10:12:42AM +0800, Like Xu wrote:
> +			/* Indicate PEBS overflow PMI to guest. */
> +			__set_bit(62, (unsigned long *)&pmu->global_status);

GLOBAL_STATUS_BUFFER_OVF_BIT
