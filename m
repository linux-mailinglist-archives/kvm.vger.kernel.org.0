Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A9173136F
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 11:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245520AbjFOJSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 05:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245515AbjFOJSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 05:18:30 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF3D2735
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 02:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686820706; x=1718356706;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Hn7+QMcHpPpGIyaBGXX0Y8gp4EkctH5Xj/t3Ek9ukcE=;
  b=VHwdS/wroMojKZmOxfE2/rC/wkgTA2rz+YicVLsibirAYZ2VnVgtgsTV
   RV5+e2pbdsZ9tbov5rOOQrLIBU0D7Kl9UMYJQL89lzVvHvbzUVPYwlaEn
   E5cqYZrKth5wQuT/F4ZOxRlB5DRpMnW6aOojMVnB1BgaqUH1E1pHK0uW4
   sPE6a6ExhMIptWuAYMxXSSaOUoCWh4vvHPd6gXH17HDHXBrwVivB+h4vN
   6jkFfk7/nWHTPp1RiZd25cZX7aDuQk3lxLF1GGcxQuYWdigvY0WWrBTvi
   K1tU0iytVbVf+XV9BrykIGMkakjeLue1VIni+n13GfFIZM7MwX4iplNx6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="348530193"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="348530193"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 02:18:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="777589079"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="777589079"
Received: from qwang12-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.173.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 02:18:22 -0700
Date:   Thu, 15 Jun 2023 17:18:19 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Jun Miao <jun.miao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Update the version number of SDM in comments
Message-ID: <20230615091819.fzr67tevfxmcbnqo@linux.intel.com>
References: <20230615080624.725551-1-jun.miao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615080624.725551-1-jun.miao@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023 at 04:06:24PM +0800, Jun Miao wrote:
> A little optimized update version number of SDM and corresponding
> public date, making it more accurate to retrieve.
> 
> Signed-off-by: Jun Miao <jun.miao@intel.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d7639d126e6c..4c5493e08d2e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2260,7 +2260,7 @@ static int apic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
>  	/*
>  	 * APIC register must be aligned on 128-bits boundary.
>  	 * 32/64/128 bits registers must be accessed thru 32 bits.
> -	 * Refer SDM 8.4.1

I would suggest just remove this line.
And maybe, add "According to Intel SDM, " at the beginning of the comments.

> +	 * Refer SDM 11.4.1 (March 2023).

Referring a specific section is not encouraged, as the numbers of SDM's
sections always change.

B.R.
Yu
