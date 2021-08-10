Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5145C3E5E1A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 16:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240965AbhHJOiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 10:38:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:48120 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239555AbhHJOiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 10:38:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="213059215"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="213059215"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 07:37:25 -0700
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="515865447"
Received: from yilonggu-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.175.101])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 07:37:21 -0700
Date:   Tue, 10 Aug 2021 22:37:16 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP
 level
Message-ID: <20210810143716.daz5p3mf5bbeyp74@linux.intel.com>
References: <20210809035806.5cqdqm5vkexvngda@linux.intel.com>
 <c6324362-1439-ef94-789b-5934c0e1cdb8@amd.com>
 <20210809042703.25gfuuvujicc3vj7@linux.intel.com>
 <73bbaac0-701c-42dd-36da-aae1fed7f1a0@amd.com>
 <20210809064224.ctu3zxknn7s56gk3@linux.intel.com>
 <YRFKABg2MOJxcq+y@google.com>
 <20210810074037.mizpggevgyhed6rm@linux.intel.com>
 <0ac41a07-beeb-161e-9e5d-e45477106c01@redhat.com>
 <20210810110031.h7vaqf3nljwm3wym@linux.intel.com>
 <998dca9a-84b6-20ee-2646-3eb58df0b8a0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <998dca9a-84b6-20ee-2646-3eb58df0b8a0@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 02:47:27PM +0200, Paolo Bonzini wrote:
> On 10/08/21 13:00, Yu Zhang wrote:
> > I guess it's because, unlike EPT which are with either 4 or 5 levels, NPT's
> > level can range from 2 to 5, depending on the host paging mode...
> 
> Yes, on Linux that will be one of 3/4/5 based on host paging mode, and it
> will apply to all N_CR3...
> 
> > But shadow EPT does not have such annoyance. Is above understanding correct?
> 
> ... Right, because shadow EPT cannot have less than 4 levels, and it can
> always use 4 levels if that's what L1 uses.

Interesting. :) Thanks a lot for the explanation!

B.R.
Yu
