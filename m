Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923564644C
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 18:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfFNQer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 12:34:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:24843 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfFNQer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 12:34:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 09:34:46 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 14 Jun 2019 09:34:46 -0700
Date:   Fri, 14 Jun 2019 09:34:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH 43/43] KVM: nVMX: shadow pin based execution controls
Message-ID: <20190614163446.GI12191@linux.intel.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
 <1560445409-17363-44-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560445409-17363-44-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 07:03:29PM +0200, Paolo Bonzini wrote:
> The VMX_PREEMPTION_TIMER flag may be toggled frequently, though not
> *very* frequently.  Since it does not affect KVM's dirty logic, e.g.
> the preemption timer value is loaded from vmcs12 even if vmcs12 is
> "clean", there is no need to mark vmcs12 dirty when L1 writes pin
> controls, and shadowing the field achieves that.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

>  arch/x86/kvm/vmx/vmcs_shadow_fields.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
> index 4cea018ba285..eb1ecd16fd22 100644
> --- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
> +++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
> @@ -47,6 +47,7 @@
>  SHADOW_FIELD_RO(GUEST_CS_AR_BYTES, guest_cs_ar_bytes)
>  SHADOW_FIELD_RO(GUEST_SS_AR_BYTES, guest_ss_ar_bytes)
>  SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control)
> +SHADOW_FIELD_RW(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control)
>  SHADOW_FIELD_RW(EXCEPTION_BITMAP, exception_bitmap)
>  SHADOW_FIELD_RW(VM_ENTRY_EXCEPTION_ERROR_CODE, vm_entry_exception_error_code)
>  SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field)
> -- 
> 1.8.3.1
> 
