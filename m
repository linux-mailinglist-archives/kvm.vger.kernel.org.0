Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64B8172E61
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 02:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgB1Bh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 20:37:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:32960 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730374AbgB1Bh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 20:37:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 17:37:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="227381654"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 27 Feb 2020 17:37:24 -0800
Date:   Thu, 27 Feb 2020 17:37:24 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/61] KVM: x86: Introduce KVM cpu caps
Message-ID: <20200228013724.GD30452@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <87wo8ak84x.fsf@vitty.brq.redhat.com>
 <a52b3d92-5df6-39bd-f3e7-2cdd4f3be6cb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a52b3d92-5df6-39bd-f3e7-2cdd4f3be6cb@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 04:25:34PM +0100, Paolo Bonzini wrote:
> On 25/02/20 16:18, Vitaly Kuznetsov wrote:
> > Would it be better or worse if we eliminate set_supported_cpuid() hook
> > completely by doing an ugly hack like (completely untested):
> 
> Yes, it makes sense.

Works for me, I'll tack it on.  I think my past self kept it because I was
planning on using vmx_set_supported_cpuid() for SGX, which adds multiple
sub-leafs, but I'm pretty sure I can squeeze them into kvm_cpu_caps with
a few extra shenanigans.
