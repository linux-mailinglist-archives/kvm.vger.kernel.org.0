Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D645D123ABB
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 00:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfLQXWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 18:22:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:43788 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfLQXWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 18:22:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 15:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; 
   d="scan'208";a="247662748"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 17 Dec 2019 15:22:29 -0800
Date:   Tue, 17 Dec 2019 15:22:29 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: WARN on failure to set IA32_PERF_GLOBAL_CTRL
Message-ID: <20191217232229.GH11771@linux.intel.com>
References: <20191214003358.169496-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191214003358.169496-1-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 13, 2019 at 04:33:58PM -0800, Oliver Upton wrote:
> Writes to MSR_CORE_PERF_GLOBAL_CONTROL should never fail if the VM-exit
> and VM-entry controls are exposed to L1. Promote the checks to perform a
> full WARN if kvm_set_msr() fails and remove the now unused macro
> SET_MSR_OR_WARN().
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
