Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B9627BBC5
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 06:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgI2EGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 00:06:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:18184 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI2EGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 00:06:50 -0400
IronPort-SDR: Iat4eEBwGxRTD9sIZw4VB+KGU9elz3tA8oXuPm69E4BSa5wvhr+x8JM4jbVgzUN+sksjgLFnCl
 9xqlrGFTvW+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149886593"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="149886593"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:06:49 -0700
IronPort-SDR: ApnA/f/CxUxtFfI6AUY6sarLD5E7WfkcMFTN2TthzC6NyteJVKUwWxGCwmaTT87/ZySyecMLCi
 1ayQdCL/bbNg==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="488909363"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:06:49 -0700
Date:   Mon, 28 Sep 2020 21:06:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pbonzini@redhat.com,
        vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: Re: [PATCH 2/6 v3] KVM: SVM: Fill in conforming svm_x86_ops via macro
Message-ID: <20200929040647.GJ31514@linux.intel.com>
References: <1595895050-105504-1-git-send-email-krish.sadhukhan@oracle.com>
 <1595895050-105504-3-git-send-email-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595895050-105504-3-git-send-email-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 12:10:46AM +0000, Krish Sadhukhan wrote:
> The names of some of the svm_x86_ops functions do not have a corresponding
> 'svm_' prefix. Generate the names using a macro so that the names are
> conformant. Fixing the naming will help in better readability and
> maintenance of the code.

I'd probably prefer to split this into two patches, one to rename all the
functions and then the second to introduce the autofill macros.  Ditto for
VMX.

> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

All of the patches with my SOB need

  Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
