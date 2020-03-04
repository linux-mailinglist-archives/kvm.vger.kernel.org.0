Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD9417989C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 20:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgCDTHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 14:07:51 -0500
Received: from mga18.intel.com ([134.134.136.126]:4255 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730055AbgCDTHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 14:07:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 11:07:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="scan'208";a="287438301"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Mar 2020 11:07:50 -0800
Date:   Wed, 4 Mar 2020 11:07:50 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix Kconfig menu text for -Werror
Message-ID: <20200304190750.GF21662@linux.intel.com>
References: <20200304104221.2977-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304104221.2977-1-Jason@zx2c4.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 04, 2020 at 06:42:21PM +0800, Jason A. Donenfeld wrote:
> This was evidently copy and pasted from the i915 driver, but the text
> wasn't updated.
> 
> Fixes: 4f337faf1c55 ("KVM: allow disabling -Werror")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/x86/kvm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 1bb4927030af..29bd4dc3363e 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -68,7 +68,7 @@ config KVM_WERROR
>  	depends on (X86_64 && !KASAN) || !COMPILE_TEST
>  	depends on EXPERT
>  	help
> -	  Add -Werror to the build flags for (and only for) i915.ko.
> +	  Add -Werror to the build flags for kvm.ko.

The -Werror flag also gets used when compiling kvm-intel.ko and kvm-amd.ko
as separate modules, as well as when KVM is built into the kernel and there
is no kvm.ko.  Probably easiest to simply say "for KVM".

>  
>  	  If in doubt, say "N".
>  
> -- 
> 2.25.1
> 
