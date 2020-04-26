Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF961B9102
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 16:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgDZO7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 10:59:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:48182 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgDZO7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 10:59:36 -0400
IronPort-SDR: LR5R21ZKq+B/+KF5wIgYUwzpsufH6rXEothLAi1aCHTIfOmkCadkrEloajInnWqBVxRR/QiIfj
 NQmjJOsKTPCA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2020 07:59:35 -0700
IronPort-SDR: 0VZlp+zIAal2YY0pMZDqdYId5ON4XSw9lKB/dKAZONJgK+YufDbnC2Yk2Yk2YK5oDsJoDGBVpL
 DitxnCQh7Lyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,320,1583222400"; 
   d="scan'208";a="281436273"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 26 Apr 2020 07:59:19 -0700
Date:   Sun, 26 Apr 2020 23:01:17 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 5/9] KVM: X86: Refresh CPUID once guest XSS MSR
 changes
Message-ID: <20200426150117.GA29493@local-michael-cet-test.sh.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-6-weijiang.yang@intel.com>
 <20200423173450.GJ17824@linux.intel.com>
 <6e1076a5-edbf-e8fe-dd99-fbb92f3cc8d0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e1076a5-edbf-e8fe-dd99-fbb92f3cc8d0@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 25, 2020 at 03:19:24PM +0200, Paolo Bonzini wrote:
> On 23/04/20 19:34, Sean Christopherson wrote:
> >>  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> >>  		supported_xss = 0;
> >> +	else
> >> +		supported_xss = host_xss & KVM_SUPPORTED_XSS;
> > Silly nit: I'd prefer to invert the check, e.g.
> > 
> > 	if (kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> > 		supported_xss = host_xss & KVM_SUPPORTED_XSS;
> > 	else
> > 		supported_xss = 0;
> > 
> 
> Also a nit: Linux coding style should be
> 
> 	supported_xss = 0;
> 	if (kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> 		supported_xss = host_xss & KVM_SUPPORTED_XSS;
> 
> Paolo
Ah, I should follow the coding style, thank you Paolo!
