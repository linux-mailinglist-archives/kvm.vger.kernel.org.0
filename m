Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA541D731B
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 10:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgERIlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 04:41:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:59436 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbgERIlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 04:41:15 -0400
IronPort-SDR: 45lCtwdkknttbCEbGhuKVhokEPny8GoaN4m3VZ0p8FPH7U6iU/YS0DxVvjs5X8VfR2UElZ3Ucl
 0JkcDy032pIg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 01:41:14 -0700
IronPort-SDR: j0MWgoLCtz6uuAyAgUAAmFGrwHZ5VdZVmXTVkgD0kTeuO69jqkqjF4UwBgQboBVR7NDyfq7VI6
 j7JZDlKHWhVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,406,1583222400"; 
   d="scan'208";a="252824707"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 18 May 2020 01:41:12 -0700
Date:   Mon, 18 May 2020 16:42:32 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: Re: [PATCH v12 00/10] Introduce support for guest CET feature
Message-ID: <20200518084232.GA11265@local-michael-cet-test>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506082110.25441-1-weijiang.yang@intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 04:20:59PM +0800, Yang Weijiang wrote:
> Control-flow Enforcement Technology (CET) provides protection against
> Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
> sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> SHSTK is to prevent ROP programming and IBT is to prevent JOP programming.
> 
> Several parts in KVM have been updated to provide VM CET support, including:
> CPUID/XSAVES config, MSR pass-through, user space MSR access interface, 
> vmentry/vmexit config, nested VM etc. These patches have dependency on CET
> kernel patches for xsaves support and CET definitions, e.g., MSR and related
> feature flags.
> 
> CET kernel patches are here:
> https://lkml.kernel.org/r/20200429220732.31602-1-yu-cheng.yu@intel.com
> 
> v12:
> - Fixed a few issues per Sean and Paolo's review feeback.
> - Refactored patches to make them properly arranged.
> - Removed unnecessary hard-coded CET states for host/guest.
> - Added compile-time assertions for vmcs_field_to_offset_table to detect
>   mismatch of the field type and field encoding number.
> - Added a custom MSR MSR_KVM_GUEST_SSP for guest active SSP save/restore.
> - Rebased patches to 5.7-rc3.
> 
ping...

Sean and Paolo,
Could you review v12 at your convenience? Thank you!

