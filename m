Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60FD383543
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 17:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbfHFP3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 11:29:44 -0400
Received: from mga18.intel.com ([134.134.136.126]:27216 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728259AbfHFP3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 11:29:44 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 08:29:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="192690589"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 06 Aug 2019 08:29:43 -0700
Date:   Tue, 6 Aug 2019 08:29:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/5] x86: KVM: svm: don't pretend to advance RIP in
 case wrmsr_interception() results in #GP
Message-ID: <20190806152943.GC27766@linux.intel.com>
References: <20190806060150.32360-1-vkuznets@redhat.com>
 <20190806060150.32360-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806060150.32360-2-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 06, 2019 at 08:01:46AM +0200, Vitaly Kuznetsov wrote:
> svm->next_rip is only used by skip_emulated_instruction() and in case
> kvm_set_msr() fails we rightfully don't do that. Move svm->next_rip
> advancement to 'else' branch to avoid creating false impression that
> it's always advanced (and make it look like rdmsr_interception()).
> 
> This is a preparatory change to removing hardcoded RIP advancement
> from instruction intercepts, no functional change.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
