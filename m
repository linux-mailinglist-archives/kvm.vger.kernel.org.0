Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9485116F0DF
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 22:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgBYVIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 16:08:44 -0500
Received: from mga07.intel.com ([134.134.136.100]:33592 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgBYVIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 16:08:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 13:08:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,485,1574150400"; 
   d="scan'208";a="256082558"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 25 Feb 2020 13:08:43 -0800
Date:   Tue, 25 Feb 2020 13:08:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 48/61] KVM: x86: Do host CPUID at load time to mask KVM
 cpu caps
Message-ID: <20200225210843.GI9245@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-49-sean.j.christopherson@intel.com>
 <fd7c8e54-b5e1-fa0c-02c7-d308ecfbac80@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd7c8e54-b5e1-fa0c-02c7-d308ecfbac80@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 04:18:12PM +0100, Paolo Bonzini wrote:
> On 01/02/20 19:52, Sean Christopherson wrote:
> > +#ifdef CONFIG_KVM_CPUID_AUDIT
> > +	/* Entry needs to be fully populated when auditing is enabled. */
> > +	entry.function = cpuid.function;
> > +	entry.index = cpuid.index;
> > +#endif
> 
> This shows that the audit case is prone to bitrot, which is good reason
> to enable it by default.

I have no argument against that, especially since I missed this case during
development and only caught it when running on a different system that I
had happened to configure with CONFIG_KVM_CPUID_AUDIT=y. :-)
