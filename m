Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 696F21BD66
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 20:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfEMStv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 14:49:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:4236 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbfEMStv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 14:49:51 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 11:49:50 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 13 May 2019 11:49:50 -0700
Date:   Mon, 13 May 2019 11:49:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH 2/8][KVM nVMX]: Enable "load IA32_PERF_GLOBAL_CTRL"
 VM-entry control for nested guests
Message-ID: <20190513184950.GG28561@linux.intel.com>
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-3-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424231724.2014-3-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 24, 2019 at 07:17:18PM -0400, Krish Sadhukhan wrote:
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 42a4deb662c6..83cd887638cb 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5511,7 +5511,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
>  #endif
>  		VM_ENTRY_LOAD_IA32_PAT;
>  	msrs->entry_ctls_high |=
> -		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
> +		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
> +		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);

Same comments as the VM-Exit patch.

>  
>  	/* We support free control of debug control loading. */
>  	msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
> -- 
> 2.17.2
> 
