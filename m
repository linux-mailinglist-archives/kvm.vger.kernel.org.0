Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD31618972
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 21:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiKCUNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 16:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiKCUNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 16:13:17 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D85913F5C;
        Thu,  3 Nov 2022 13:13:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g62so2643138pfb.10;
        Thu, 03 Nov 2022 13:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=813fo5BLHWZtv9JdsQwB2RiM02PAw+XVWtcoqdw1Uzg=;
        b=AWuCQtjhZHzbUd/NUMk0RWvmY+AgUJFAoJSaZBRIseOWyRpGiKhor0KwYv16u6trNc
         x3nLYulT0AznQYFghwkD8g5bdHJEQkBARTLewwZNMNKWC6SSsgmhHLEBNRHIyma/szQ2
         1hzGsHpSXP1QUZM+PANJ26jNId6gRRSf5I3iymS28jrxBbP+9sDTebU2qWsF2kKWZarH
         ow6AkTRAq7agLRLh7skjSDTiFubMTCzk+1sMGGDywRwxCqW3lAQJrGK1yUkpE5qeirkr
         +JVWR5NcMLXNMJI447VmnznOykfjEtSrog4Zhzd57qDlh9Ec+OhvuBs9af9XArASc3Ov
         HFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=813fo5BLHWZtv9JdsQwB2RiM02PAw+XVWtcoqdw1Uzg=;
        b=Dj7wE64O/kQbiOCcxAG21ADYHZKdBU+kgtvgDCz4a6bstdjdjQVgED5h0Q6sGXgvEO
         YzPz4mkVM1qVfa6d0rHFNfaZLqvsOF8rB7wNROC54ZGKgsMjoEbpwHrCP+w4e4W/1i6o
         hgNmsPio2l2LK8nA8qIgiC/hKlBgiVFuTPapOWQY3JWLxvXPHTgjSRTjvhA+HY3ZxNpx
         MmwSk8DNGDs39rpi8BjfXM/msd5EWVFCyrUUs5KuFyzdvrCGnnSzt3ggJVCU1YTLlU4s
         1EfO2jSoT3qaObsHHOGhEEQk5Kwbf61Kclxtz1wtDk2mP5kHAiuPNy3lypncmjf1CGU8
         X41Q==
X-Gm-Message-State: ACrzQf1a4NUsl/oX4ggHe9VmlkeoTDYYsB/j0FmKpgRXAujEqf4dfVtb
        fBfomHuBxpCQy1H1y6Yvst8=
X-Google-Smtp-Source: AMsMyM4XWS5X9/l3qSWca7MI+BQRBwNK0WtlMyLmdSS+KVmhaLBP/ZcJd9i8mb4PNLrAqI6Imbp18g==
X-Received: by 2002:a05:6a00:1884:b0:56c:636a:d554 with SMTP id x4-20020a056a00188400b0056c636ad554mr32008521pfh.18.1667506396469;
        Thu, 03 Nov 2022 13:13:16 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id s13-20020a170902ea0d00b00186f3c69ebesm1049813plg.186.2022.11.03.13.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 13:13:15 -0700 (PDT)
Date:   Thu, 3 Nov 2022 13:13:14 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 039/108] KVM: VMX: Introduce test mode related to EPT
 violation VE
Message-ID: <20221103201314.GA1063309@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <8b3101711c5291246653efb50cc2975863d3a8ab.1667110240.git.isaku.yamahata@intel.com>
 <89ee8b63-bdce-0779-3c05-1a0516076156@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <89ee8b63-bdce-0779-3c05-1a0516076156@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022 at 09:41:44PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> On 2022/10/30 14:22, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM programs
> > to inject #VE conditionally and set #VE suppress bit in EPT entry.  For VMX
> > case, #VE isn't used.  If #VE happens for VMX, it's a bug.  To be
> > defensive (test that VMX case isn't broken), introduce option
> > ept_violation_ve_test and when it's set, set error.
> > 
> > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/include/asm/vmx.h | 12 +++++++
> >   arch/x86/kvm/vmx/vmcs.h    |  5 +++
> >   arch/x86/kvm/vmx/vmx.c     | 69 +++++++++++++++++++++++++++++++++++++-
> >   arch/x86/kvm/vmx/vmx.h     |  6 +++-
> >   4 files changed, 90 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> > index cdbf12c1a83c..752d53652007 100644
> > --- a/arch/x86/include/asm/vmx.h
> > +++ b/arch/x86/include/asm/vmx.h
> > @@ -68,6 +68,7 @@
> >   #define SECONDARY_EXEC_ENCLS_EXITING		VMCS_CONTROL_BIT(ENCLS_EXITING)
> >   #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
> >   #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
> > +#define SECONDARY_EXEC_EPT_VIOLATION_VE		VMCS_CONTROL_BIT(EPT_VIOLATION_VE)
> >   #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
> >   #define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
> >   #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
> > @@ -223,6 +224,8 @@ enum vmcs_field {
> >   	VMREAD_BITMAP_HIGH              = 0x00002027,
> >   	VMWRITE_BITMAP                  = 0x00002028,
> >   	VMWRITE_BITMAP_HIGH             = 0x00002029,
> > +	VE_INFORMATION_ADDRESS		= 0x0000202A,
> > +	VE_INFORMATION_ADDRESS_HIGH	= 0x0000202B,
> >   	XSS_EXIT_BITMAP                 = 0x0000202C,
> >   	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
> >   	ENCLS_EXITING_BITMAP		= 0x0000202E,
> > @@ -628,4 +631,13 @@ enum vmx_l1d_flush_state {
> >   extern enum vmx_l1d_flush_state l1tf_vmx_mitigation;
> > +struct vmx_ve_information {
> > +	u32 exit_reason;
> > +	u32 delivery;
> > +	u64 exit_qualification;
> > +	u64 guest_linear_address;
> > +	u64 guest_physical_address;
> > +	u16 eptp_index;
> > +};
> > +
> >   #endif
> > diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> > index ac290a44a693..9277676057a7 100644
> > --- a/arch/x86/kvm/vmx/vmcs.h
> > +++ b/arch/x86/kvm/vmx/vmcs.h
> > @@ -140,6 +140,11 @@ static inline bool is_nm_fault(u32 intr_info)
> >   	return is_exception_n(intr_info, NM_VECTOR);
> >   }
> > +static inline bool is_ve_fault(u32 intr_info)
> > +{
> > +	return is_exception_n(intr_info, VE_VECTOR);
> > +}
> > +
> >   /* Undocumented: icebp/int1 */
> >   static inline bool is_icebp(u32 intr_info)
> >   {
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index f890191e8580..dd3fde9d3c32 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -126,6 +126,9 @@ module_param(error_on_inconsistent_vmcs_config, bool, 0444);
> >   static bool __read_mostly dump_invalid_vmcs = 0;
> >   module_param(dump_invalid_vmcs, bool, 0644);
> > +static bool __read_mostly ept_violation_ve_test;
> > +module_param(ept_violation_ve_test, bool, 0444);
> > +
> >   #define MSR_BITMAP_MODE_X2APIC		1
> >   #define MSR_BITMAP_MODE_X2APIC_APICV	2
> > @@ -783,6 +786,13 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
> >   	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR) |
> >   	     (1u << DB_VECTOR) | (1u << AC_VECTOR);
> > +	/*
> > +	 * #VE isn't used for VMX, but for TDX.  To test against unexpected
> > +	 * change related to #VE for VMX, intercept unexpected #VE and warn on
> > +	 * it.
> > +	 */
> > +	if (ept_violation_ve_test)
> > +		eb |= 1u << VE_VECTOR;
> >   	/*
> >   	 * Guest access to VMware backdoor ports could legitimately
> >   	 * trigger #GP because of TSS I/O permission bitmap.
> > @@ -2644,6 +2654,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> >   					&_cpu_based_2nd_exec_control))
> >   			return -EIO;
> >   	}
> > +	if (!ept_violation_ve_test)
> > +		_cpu_based_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
> 
> should be _cpu_based_2nd_exec_control

Oops, thanks.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
