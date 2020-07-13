Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656A421DF6B
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 20:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbgGMSN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 14:13:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:6122 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729687AbgGMSN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 14:13:28 -0400
IronPort-SDR: R2xRdxz1m1sS00SvpfTfPgsuxzKDyrPanOBlewZhF5AzV6gt0wS2ONONbSoRy7XNvGIuIOCJPp
 sJp8wFcv4C3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="148688639"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="148688639"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 11:13:27 -0700
IronPort-SDR: r+qLI/6ZnsIf5qrW4sEmosy4IYMrsya7VCmF8S5EaMHbmJoeturrVrsX4dhHZrMlx6k5JkvWKt
 iBLCuKrflSZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="316134668"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 13 Jul 2020 11:13:26 -0700
Date:   Mon, 13 Jul 2020 11:13:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v13 00/11] Introduce support for guest CET feature
Message-ID: <20200713181326.GC29725@linux.intel.com>
References: <20200701080411.5802-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701080411.5802-1-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 01, 2020 at 04:04:00PM +0800, Yang Weijiang wrote:
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
> v13:
> - Added CET definitions as a separate patch to facilitate KVM test.
> - Disabled CET support in KVM if unrestricted_guest is turned off since
>   in this case CET related instructions/infrastructure cannot be emulated
>   well.

This needs to be rebased, I can't get it to apply on any kvm branch nor on
any 5.8 rc.  And when you send series, especially large series that touch
lots of code, please explicitly state what commit the series is based on to
make it easy for reviewers to apply the patches, even if the series needs a
rebase.
