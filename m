Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35346ABAC2
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 16:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394274AbfIFOWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 10:22:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:10875 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732899AbfIFOWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 10:22:11 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 07:22:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,473,1559545200"; 
   d="scan'208";a="199528473"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 06 Sep 2019 07:22:08 -0700
Date:   Fri, 6 Sep 2019 07:22:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v4 3/4] KVM: VMX: Change ple_window type to unsigned int
Message-ID: <20190906142208.GA29496@linux.intel.com>
References: <20190906021722.2095-1-peterx@redhat.com>
 <20190906021722.2095-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906021722.2095-4-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 06, 2019 at 10:17:21AM +0800, Peter Xu wrote:
> The VMX ple_window is 32 bits wide, so logically it can overflow with
> an int.  The module parameter is declared as unsigned int which is
> good, however the dynamic variable is not.  Switching all the
> ple_window references to use unsigned int.
> 
> The tracepoint changes will also affect SVM, but SVM is using an even
> smaller width (16 bits) so it's always fine.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
