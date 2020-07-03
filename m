Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34139213C3C
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 17:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgGCPCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 11:02:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:12640 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgGCPCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 11:02:33 -0400
IronPort-SDR: bkPowF2edqM4SNMW+ZXM2oIbmEa75sNMweRolFdj3oAONGjh2Q2gPXedBgy2/KCtLwy/kcAPn1
 gxC3b7jtGChg==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="148677378"
X-IronPort-AV: E=Sophos;i="5.75,308,1589266800"; 
   d="scan'208";a="148677378"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2020 08:02:32 -0700
IronPort-SDR: I2r93TWooS2muxZUQq7lCmTm0YoO6HAnVgSof25s1rySGbz0pCw4BxN7+5+/QCIG7MBWJeHXbu
 yDt5y225by5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,308,1589266800"; 
   d="scan'208";a="455921748"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 03 Jul 2020 08:02:30 -0700
Date:   Fri, 3 Jul 2020 23:02:27 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v13 03/11] KVM: VMX: Set guest CET MSRs per KVM and host
 configuration
Message-ID: <20200703150227.GA3474@local-michael-cet-test>
References: <20200701080411.5802-1-weijiang.yang@intel.com>
 <20200701080411.5802-4-weijiang.yang@intel.com>
 <75f0ef0b-ce95-fd92-00df-4231ffa1fa8e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75f0ef0b-ce95-fd92-00df-4231ffa1fa8e@intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 02, 2020 at 11:13:35PM +0800, Xiaoyao Li wrote:
> On 7/1/2020 4:04 PM, Yang Weijiang wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c5835f9cb9ad..6390b62c12ed 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -186,6 +186,9 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
> >   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> >   				| XFEATURE_MASK_PKRU)
> > +#define KVM_SUPPORTED_XSS       (XFEATURE_MASK_CET_USER | \
> > +				 XFEATURE_MASK_CET_KERNEL)
> > +
> 
> This definition need to be moved to Patch 5?
> 
Good capture, thanks! I'll move it in next series.

> >   u64 __read_mostly host_efer;
> >   EXPORT_SYMBOL_GPL(host_efer);
> > 
