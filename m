Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AA621E60C
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 05:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgGNDAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 23:00:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:53581 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgGNDAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 23:00:49 -0400
IronPort-SDR: 2cBCrFdulCoILb9YKWerCcdFozm0EeVQDGhYINi58ujMk/2vmLdI+kqXdUUolKxa5+FzmNctnq
 uhs5X11Nfu3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="148785154"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="148785154"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 20:00:48 -0700
IronPort-SDR: sqfQGqcJIpZPi2++Jsf4Ce6MY48ACp1NgfVCgb4oQrahAJYA1NQ+ofg2oBcz3TD2FrnLme4VHK
 YFwXrniBF/Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="390357412"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jul 2020 20:00:48 -0700
Date:   Mon, 13 Jul 2020 20:00:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        ricardo.neri-calderon@linux.intel.com, kyung.min.park@intel.com,
        jpoimboe@redhat.com, gregkh@linuxfoundation.org,
        ak@linux.intel.com, dave.hansen@intel.com, tony.luck@intel.com,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH v2 3/4] x86: Expose SERIALIZE for supported cpuid
Message-ID: <20200714030047.GA12592@linux.intel.com>
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
 <1594088183-7187-4-git-send-email-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594088183-7187-4-git-send-email-cathy.zhang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 07, 2020 at 10:16:22AM +0800, Cathy Zhang wrote:
> SERIALIZE instruction is supported by intel processors,
> like Sapphire Rapids. Expose it in KVM supported cpuid.

Providing at least a rough overview of the instruction, e.g. its enumeration,
usage, fault rules, controls, etc... would be nice.  In isolation, the
changelog isn't remotely helpful in understanding the correctness of the
patch.

> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8a294f9..e603aeb 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -341,7 +341,8 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_mask(CPUID_7_EDX,
>  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> -		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
> +		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
> +		F(SERIALIZE)
>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> -- 
> 1.8.3.1
> 
