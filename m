Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF8DABACA
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 16:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392989AbfIFOXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 10:23:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:59567 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732899AbfIFOXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 10:23:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 07:23:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,473,1559545200"; 
   d="scan'208";a="383265875"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 06 Sep 2019 07:23:47 -0700
Date:   Fri, 6 Sep 2019 07:23:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v4 4/4] KVM: X86: Tune PLE Window tracepoint
Message-ID: <20190906142347.GB29496@linux.intel.com>
References: <20190906021722.2095-1-peterx@redhat.com>
 <20190906021722.2095-5-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906021722.2095-5-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 06, 2019 at 10:17:22AM +0800, Peter Xu wrote:
> The PLE window tracepoint triggers even if the window is not changed,
> and the wording can be a bit confusing too.  One example line:
> 
>   kvm_ple_window: vcpu 0: ple_window 4096 (shrink 4096)
> 
> It easily let people think of "the window now is 4096 which is
> shrinked", but the truth is the value actually didn't change (4096).
> 
> Let's only dump this message if the value really changed, and we make
> the message even simpler like:
> 
>   kvm_ple_window: vcpu 4 old 4096 new 8192 (growed)
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
