Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAB918DCA3
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 01:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgCUAnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 20:43:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:34096 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUAnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 20:43:17 -0400
IronPort-SDR: wPdHwqpfCfpYIn41XMPQKOHaI5ypXsJr/0tr8cdFYYeZXM5AtS13KxuAWTy2bsUBT1+zrbhllx
 BDVbz3l8NhyA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 17:43:17 -0700
IronPort-SDR: 6KNo0lISF8otDX5ZVA0Mi6sEF0fH+6FqBk3CBN1t309CeLPSX20jr6BL7qWiAh+fy4d+JcYDBU
 RS2W/dEXZ8IA==
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="325032086"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 17:43:16 -0700
Date:   Fri, 20 Mar 2020 17:43:15 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v5 2/9] x86/split_lock: Avoid runtime reads of the
 TEST_CTRL MSR
Message-ID: <20200321004315.GB6578@agluck-desk2.amr.corp.intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
 <20200315050517.127446-3-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200315050517.127446-3-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 15, 2020 at 01:05:10PM +0800, Xiaoyao Li wrote:
> In a context switch from a task that is detecting split locks
> to one that is not (or vice versa) we need to update the TEST_CTRL
> MSR. Currently this is done with the common sequence:
> 	read the MSR
> 	flip the bit
> 	write the MSR
> in order to avoid changing the value of any reserved bits in the MSR.
> 
> Cache the value of the TEST_CTRL MSR when we read it during initialization
> so we can avoid an expensive RDMSR instruction during context switch.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Originally-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Is it bad form to Ack/Review patches originally by oneself?

Whatever:

Acked-by: Tony Luck <tony.luck@intel.com>

