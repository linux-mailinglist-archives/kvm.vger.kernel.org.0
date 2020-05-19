Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609561D8FBE
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 08:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgESGGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 02:06:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:19881 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgESGGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 02:06:15 -0400
IronPort-SDR: vgEorDNoi6Nbn44uOkqwltHRrBPOj03/cXoXtY5L7DpbcETJqfu3OI5a6Z/pAXc23QKYuqz8z5
 1l6S9Th36e3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 23:06:15 -0700
IronPort-SDR: RP62tTAecEamVpolBpqzmO51l5w3dtNgXpC9k5/YiqlCJu1w90hrKR+VIZM6kHhE0ChmhGuaSl
 4BrZ6K7wx+gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,409,1583222400"; 
   d="scan'208";a="308313067"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 18 May 2020 23:06:14 -0700
Date:   Mon, 18 May 2020 23:06:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v12 00/10] Introduce support for guest CET feature
Message-ID: <20200519060614.GA5189@linux.intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
 <20200518084232.GA11265@local-michael-cet-test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518084232.GA11265@local-michael-cet-test>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 18, 2020 at 04:42:32PM +0800, Yang Weijiang wrote:
> On Wed, May 06, 2020 at 04:20:59PM +0800, Yang Weijiang wrote:
> > Control-flow Enforcement Technology (CET) provides protection against
> > Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
> > sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> > SHSTK is to prevent ROP programming and IBT is to prevent JOP programming.
> > 
> > Several parts in KVM have been updated to provide VM CET support, including:
> > CPUID/XSAVES config, MSR pass-through, user space MSR access interface, 
> > vmentry/vmexit config, nested VM etc. These patches have dependency on CET
> > kernel patches for xsaves support and CET definitions, e.g., MSR and related
> > feature flags.
> > 
> > CET kernel patches are here:
> > https://lkml.kernel.org/r/20200429220732.31602-1-yu-cheng.yu@intel.com
> > 
> > v12:
> > - Fixed a few issues per Sean and Paolo's review feeback.
> > - Refactored patches to make them properly arranged.
> > - Removed unnecessary hard-coded CET states for host/guest.
> > - Added compile-time assertions for vmcs_field_to_offset_table to detect
> >   mismatch of the field type and field encoding number.
> > - Added a custom MSR MSR_KVM_GUEST_SSP for guest active SSP save/restore.
> > - Rebased patches to 5.7-rc3.
> > 
> ping...
> 
> Sean and Paolo,
> Could you review v12 at your convenience? Thank you!

Through no fault of your own, it'll probably be a few weeks before I get back
to your CET series.  The kernel enabling doesn't seem like it's going to be
merged anytime soon, certainly not for 5.8, so unfortunately your series got
put on the backburner.  Sorry :-(.
