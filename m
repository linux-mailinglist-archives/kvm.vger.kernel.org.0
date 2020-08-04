Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAAB23C156
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 23:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgHDVTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 17:19:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:39193 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgHDVTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 17:19:16 -0400
IronPort-SDR: fJ2dnC9qJtfTgkc5zf+bOMSto1CSyleqyZOTsbh0rrWmBu5WQ2cVvv2hgpIFe4eAK7GsWIG/gJ
 j+whvPyEjNCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="237274045"
X-IronPort-AV: E=Sophos;i="5.75,435,1589266800"; 
   d="scan'208";a="237274045"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 14:19:15 -0700
IronPort-SDR: 0JQbKt4B53EkoiuwSnenErikJrReH8WHTuUjyhuDk11eEsp7WHPBlIrOcx0Vejt8ssX8P5a2kU
 wT5bH1vOL6uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,435,1589266800"; 
   d="scan'208";a="315505500"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004.fm.intel.com with ESMTP; 04 Aug 2020 14:19:15 -0700
Date:   Tue, 4 Aug 2020 14:19:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] KVM: LAPIC: Return 0 when getting the tscdeadline
 timer if the lapic is hw disabled
Message-ID: <20200804211914.GB31916@linux.intel.com>
References: <1596521448-4010-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596521448-4010-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 04, 2020 at 02:10:47PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Return 0 when getting the tscdeadline timer if the lapic is hw disabled
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index cfb8504..d89ab48 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2182,7 +2182,7 @@ u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -	if (!lapic_in_kernel(vcpu) ||
> +	if (!kvm_apic_present(vcpu) ||
>  		!apic_lvtt_tscdeadline(apic))

Paolo, want want to fix up the indentation when applying? 

	if (!kvm_apic_present(vcpu) || !apic_lvtt_tscdeadline(apic)


>  		return 0;
>  
> -- 
> 2.7.4
> 
