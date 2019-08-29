Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC58A28A6
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 23:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfH2VKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 17:10:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:11325 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbfH2VKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 17:10:16 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 14:10:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="332646511"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.137])
  by orsmga004.jf.intel.com with ESMTP; 29 Aug 2019 14:10:15 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 5271730121D; Thu, 29 Aug 2019 14:10:15 -0700 (PDT)
Date:   Thu, 29 Aug 2019 14:10:15 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 1/9] KVM: x86: Add base address parameter for
 get_fixed_pmc function
Message-ID: <20190829211015.GU5447@tassilo.jf.intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
 <1567056849-14608-2-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567056849-14608-2-git-send-email-luwei.kang@intel.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>  /* returns fixed PMC with the specified MSR */
> -static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
> +static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr,
> +								int base)

Better define a __get_fixed_pmc just for this case, with the existing
get_fixed_pmc being a wrapper.

This would avoid changing all the callers below.


-Andi
