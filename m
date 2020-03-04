Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27B71178CAE
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 09:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgCDIkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 03:40:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:6900 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728942AbgCDIkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 03:40:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 00:40:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,513,1574150400"; 
   d="scan'208";a="274585961"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by fmsmga002.fm.intel.com with ESMTP; 04 Mar 2020 00:40:49 -0800
Date:   Wed, 4 Mar 2020 16:44:20 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v9 2/7] KVM: VMX: Define CET VMCS fields and #CP flag
Message-ID: <20200304084419.GA5831@local-michael-cet-test.sh.intel.com>
References: <20191227021133.11993-1-weijiang.yang@intel.com>
 <20191227021133.11993-3-weijiang.yang@intel.com>
 <20200303214254.GZ1439@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303214254.GZ1439@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 01:42:54PM -0800, Sean Christopherson wrote:
> On Fri, Dec 27, 2019 at 10:11:28AM +0800, Yang Weijiang wrote:
> > @@ -298,7 +298,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
> >   * In future, applicable XSS state bits can be added here
> >   * to make them available to KVM and guest.
> >   */
> > -#define KVM_SUPPORTED_XSS	0
> > +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER \
> > +				| XFEATURE_MASK_CET_KERNEL)
> 
> My preference would be to put the operator on the previous line, though I
> realize this diverges from other KVM behavior.  I find it much easier to
> read With the names aligned.
> 
> #define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
> 				 XFEATURE_MASK_CET_KERNEL)

Yep, I also feel it's preferable now :-), thanks!
> >  
> >  extern u64 host_xcr0;
> >  
> > -- 
> > 2.17.2
> > 
