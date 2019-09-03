Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCA7A719C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 19:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbfICRXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 13:23:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:49669 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfICRXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 13:23:34 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 10:23:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="173283242"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 03 Sep 2019 10:23:32 -0700
Date:   Tue, 3 Sep 2019 10:23:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <namit@vmware.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marc Orr <marcorr@google.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: nVMX: Fix wrong reserved bits of
 error-code
Message-ID: <20190903172332.GI10768@linux.intel.com>
References: <20190830204031.3100-1-namit@vmware.com>
 <20190830204031.3100-3-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830204031.3100-3-namit@vmware.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 01:40:31PM -0700, Nadav Amit wrote:
> The SDM indeed says that "If deliver-error-code is 1, bits 31:15 of the
> VM-entry exception error-code field are 0." However, the SDM is wrong,
> and bits that need to be zeroed are 31:16.
> 
> Our engineers confirmed that the SDM is wrong with Intel. Fix the test.
> 
> Note that KVM should be fixed as well.
> 
> Fixes: 8d2cdb35a07a ("x86: Add test for nested VM entry prereqs")
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
