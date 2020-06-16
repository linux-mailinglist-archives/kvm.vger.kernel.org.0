Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D99F1FAAFA
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 10:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgFPIUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 04:20:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:62156 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgFPIUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 04:20:43 -0400
IronPort-SDR: aOUi4FXalfg1kdXsKXuHGsIPSMLsGP4NPZIlsLmyTycRRZxJ/KnmMRkqn5fszi0oTAJRKc1yEy
 wF2Xju97ByBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 01:20:42 -0700
IronPort-SDR: t0bpjd+Q4VKPC+61dXRLYFNPcf5pPWtmPGdNQMvv1hNVMlRocJWKWMn0DWM265is/EYejzUSYU
 SYOn6AFH6J1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,518,1583222400"; 
   d="scan'208";a="262066840"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 16 Jun 2020 01:20:42 -0700
Date:   Tue, 16 Jun 2020 01:20:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Fix MSR range of APIC registers in X2APIC mode
Message-ID: <20200616082042.GE26491@linux.intel.com>
References: <20200616073307.16440-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616073307.16440-1-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 16, 2020 at 03:33:07PM +0800, Xiaoyao Li wrote:
> Only MSR address range 0x800 through 0x8ff is architecturally reserved
> and dedicated for accessing APIC registers in x2APIC mode.
> 
> Fixes: 0105d1a52640 ("KVM: x2apic interface to lapic")
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---

And perhaps more importantly, there are real MSRs that are overlapped,
e.g. MSR_IA32_TME_ACTIVATE.  This probably warrants a Cc to stable; as you
found out the hard way, this breaks ignore_msrs.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
