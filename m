Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0272EC68D
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 00:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbhAFXKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 18:10:33 -0500
Received: from mga06.intel.com ([134.134.136.31]:20474 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbhAFXKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 18:10:33 -0500
IronPort-SDR: LrX1lQ/JxqqqaL9KTlUAiEzBdBfo77sLkHd6RPXxK3gBhPjfWqjkpI+aFik2ZGK1TrWXVzRkXW
 1T3Zw+CHGPSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="238895365"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="238895365"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 15:09:51 -0800
IronPort-SDR: g/iUIFhRZwA2XlH5DfbmCA/alqmLF04T0ylsqydpN6XcD5kiO+ys/vflAm1Eai2K4jgpQeh9Q0
 7lHM19g1eW/A==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="462830453"
Received: from vastrong-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.243])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 15:09:48 -0800
Date:   Thu, 7 Jan 2021 12:09:46 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
In-Reply-To: <20210106221527.GB24607@zn.tnic>
References: <cover.1609890536.git.kai.huang@intel.com>
        <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
        <20210106221527.GB24607@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 23:15:27 +0100 Borislav Petkov wrote:
> On Wed, Jan 06, 2021 at 02:55:21PM +1300, Kai Huang wrote:
> > +/* Intel-defined SGX features, CPUID level 0x00000012:0 (EAX), word 19 */
> > +#define X86_FEATURE_SGX1		(19*32+ 0) /* SGX1 leaf functions */
> > +#define X86_FEATURE_SGX2		(19*32+ 1) /* SGX2 leaf functions */
> 
> Is anything else from that leaf going to be added later? Bit 5 is
> "supports ENCLV instruction leaves", 6 is ENCLS insn leaves... are those
> going to be used in the kernel too eventually?

Bit 5 and Bit 6 are related to reclaiming EPC page from SGX guest, and the
mechanism behind the two bits are only supposed to be used by KVM.

There's no urgent request to support them for now (and given basic SGX
virtualization is not in upstream), but I don't know whether they need to be
supported in the future.

> 
> Rest of them is reserved in the SDM which probably means internal only
> for now.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
