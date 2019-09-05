Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64A7AAA0D
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 19:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388860AbfIERdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 13:33:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:17592 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbfIERdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 13:33:12 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 10:33:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="scan'208";a="383936241"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 05 Sep 2019 10:33:10 -0700
Date:   Thu, 5 Sep 2019 10:33:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v3] KVM: x86: Disable posted interrupts for odd IRQs
Message-ID: <20190905173310.GA16071@linux.intel.com>
References: <20190905125818.22395-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905125818.22395-1-graf@amazon.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 05, 2019 at 02:58:18PM +0200, Alexander Graf wrote:
> We can easily route hardware interrupts directly into VM context when
> they target the "Fixed" or "LowPriority" delivery modes.
> 
> However, on modes such as "SMI" or "Init", we need to go via KVM code
> to actually put the vCPU into a different mode of operation, so we can
> not post the interrupt
> 
> Add code in the VMX and SVM PI logic to explicitly refuse to establish
> posted mappings for advanced IRQ deliver modes. This reflects the logic
> in __apic_accept_irq() which also only ever passes Fixed and LowPriority
> interrupts as posted interrupts into the guest.
> 
> This fixes a bug I have with code which configures real hardware to
> inject virtual SMIs into my guest.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> 
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
