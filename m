Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8AF1B7734
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 15:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgDXNmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 09:42:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:48236 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgDXNmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 09:42:07 -0400
IronPort-SDR: XcNwQyCIiOsSAEukrIvEUZOjK5/VmgEN4juUP5nFbfsN1FsFN2pPaV2zVIMZaWjs0tQH3DG4PY
 YxdF3AN430AA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 06:42:06 -0700
IronPort-SDR: 8USxce6JaaWf19goY9DaQF4NC95AxRX0qFW2EG2S6Bj2Mf9VZvApdNXRxwbY+XB1N2nBBrb0U6
 RbK9j+LAYDPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="280800527"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 24 Apr 2020 06:42:04 -0700
Date:   Fri, 24 Apr 2020 21:44:07 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 1/9] KVM: VMX: Introduce CET VMX fields and flags
Message-ID: <20200424134407.GD24039@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-2-weijiang.yang@intel.com>
 <20200423163948.GA25564@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423163948.GA25564@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 09:39:48AM -0700, Sean Christopherson wrote:
> On Thu, Mar 26, 2020 at 04:18:38PM +0800, Yang Weijiang wrote:
> > If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host CET states are restored
> > from below VMCS fields at VM-Exit:
> >   HOST_S_CET
> >   HOST_SSP
> >   HOST_INTR_SSP_TABLE
> > 
> > If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest CET states are loaded
> > from below VMCS fields at VM-Entry:
> >   GUEST_S_CET
> >   GUEST_SSP
> >   GUEST_INTR_SSP_TABLE
> > 
> > Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> 
> ...
> 
> > diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> > index 5e090d1f03f8..e938bc6c37aa 100644
> > --- a/arch/x86/include/asm/vmx.h
> > +++ b/arch/x86/include/asm/vmx.h
> > @@ -94,6 +94,7 @@
> >  #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
> >  #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
> >  #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
> > +#define VM_EXIT_LOAD_HOST_CET_STATE             0x10000000
> >  
> >  #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
> >  
> > @@ -107,6 +108,7 @@
> >  #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
> >  #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
> >  #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
> > +#define VM_ENTRY_LOAD_GUEST_CET_STATE           0x00100000
> 
> I think it probably make senses to drop HOST/GUEST from the controls,
> i.e. VM_{ENTER,EXIT}_LOAD_CET_STATE.  The SDM doesn't qualify them with
> guest vs. host, nor does KVM qualify any of the other entry/exit controls
> that are effective guest vs. host.
Sure, will fix them, thanks.

