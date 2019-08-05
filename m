Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0D881FC0
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 17:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfHEPFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 11:05:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:33229 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727259AbfHEPFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 11:05:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 08:05:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="164676218"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 05 Aug 2019 08:05:51 -0700
Date:   Mon, 5 Aug 2019 08:05:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: remove unnecessary PageReserved check
Message-ID: <20190805150551.GA29275@linux.intel.com>
References: <1564996902-22600-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564996902-22600-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 05, 2019 at 11:21:42AM +0200, Paolo Bonzini wrote:
> The same check is already done in kvm_is_reserved_pfn.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

This patch was effectively submitted in Nov 2018, but was buried at the
end of a DAX series.  https://patchwork.kernel.org/patch/10886265/

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

>  virt/kvm/kvm_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 416969d9fefe..c5f1186f4b60 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1855,8 +1855,7 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn)
>  	if (!kvm_is_reserved_pfn(pfn)) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		if (!PageReserved(page))
> -			SetPageDirty(page);
> +		SetPageDirty(page);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
> -- 
> 1.8.3.1
> 
