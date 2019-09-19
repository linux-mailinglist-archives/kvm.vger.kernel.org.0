Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFBABB839E
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 23:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403910AbfISVom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 17:44:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:64359 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393087AbfISVom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 17:44:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Sep 2019 14:44:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,526,1559545200"; 
   d="scan'208";a="192180625"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 19 Sep 2019 14:44:41 -0700
Date:   Thu, 19 Sep 2019 14:44:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Orr <marcorr@google.com>
Subject: Re: [PATCH] x86: remove memory constraint from "mov" instruction
Message-ID: <20190919214441.GH30495@linux.intel.com>
References: <CAGG=3QXxGVs-s0H2Emw1tYMtcGtQsEHrYnmHztL=vOFanZegMw@mail.gmail.com>
 <20190912205944.120303-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912205944.120303-1-morbo@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+cc Paolo, Radim and Marc (to avoid saying the same thing twice)

I recommend having Paolo and Radim in the To: field when sending patches
for KVM or kvm-unit-tests, simply cc'ing the KVM list may not be enough to
ensure Paolo/Radim sees the patch.

https://lkml.kernel.org/r/0d59375c-9313-d31a-4af9-d68115e05d55@redhat.com

On Thu, Sep 12, 2019 at 01:59:44PM -0700, Bill Wendling wrote:
> Remove a bogus memory constraint as x86 does not have a generic
> memory-to-memory "mov" instruction.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>

For the actual patch:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> ---
>  lib/x86/desc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 5f37cef..451f504 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -263,7 +263,7 @@ unsigned exception_error_code(void)
>  {
>      unsigned short error_code;
>  
> -    asm("mov %%gs:6, %0" : "=rm"(error_code));
> +    asm("mov %%gs:6, %0" : "=r"(error_code));
>      return error_code;
>  }
>  
> -- 
> 2.23.0.237.gc6a4ce50a0-goog
> 
