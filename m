Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28893F5902
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 09:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhHXH3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 03:29:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:49845 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbhHXH33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 03:29:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="214130497"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="214130497"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 00:28:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="597490950"
Received: from um.fi.intel.com (HELO um) ([10.237.72.62])
  by fmsmga001.fm.intel.com with ESMTP; 24 Aug 2021 00:28:41 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Artem Kashkanov <artem.kashkanov@intel.com>,
        alexander.shishkin@linux.intel.com
Subject: Re: [PATCH 2/3] KVM: x86: Register Processor Trace interrupt hook
 iff PT enabled in guest
In-Reply-To: <20210823193709.55886-3-seanjc@google.com>
References: <20210823193709.55886-1-seanjc@google.com>
 <20210823193709.55886-3-seanjc@google.com>
Date:   Tue, 24 Aug 2021 10:28:40 +0300
Message-ID: <87v93vi9nb.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 0e4f2b1fa9fb..b06dbbd7eeeb 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -41,6 +41,7 @@ struct kvm_pmu_ops {
>  	void (*reset)(struct kvm_vcpu *vcpu);
>  	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
>  	void (*cleanup)(struct kvm_vcpu *vcpu);
> +	void (*handle_intel_pt_intr)(void);

What's this one for?

Regards,
--
Alex
