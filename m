Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41AA1CE145
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 19:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbgEKRIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 13:08:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:5185 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729731AbgEKRIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 13:08:25 -0400
IronPort-SDR: uQgXUmqme2/AxKgrrbGSLEkYzfMSSOhWpxkuy/UvQAXZNOo2Q2e+8CIOkXSF4bNOaurI/YZsvM
 QUN7wr51qSOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 10:08:24 -0700
IronPort-SDR: d7h2ysoQZV089QoNfOjaWz0naRqulVdSZtsKSpObhZ/KtQSpTLcFWoxTXUfJ9jDEM64Lgd4ihC
 SOB/8Ui41iDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="286343373"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 11 May 2020 10:08:23 -0700
Date:   Mon, 11 May 2020 10:08:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: Invoke kvm_exit tracepoint on VM-Exit due
 to failed VM-Enter
Message-ID: <20200511170823.GD24052@linux.intel.com>
References: <20200508235348.19427-1-sean.j.christopherson@intel.com>
 <20200508235348.19427-2-sean.j.christopherson@intel.com>
 <551ed3f8-8e6c-adbd-67ff-babd39b7597f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551ed3f8-8e6c-adbd-67ff-babd39b7597f@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 09, 2020 at 02:54:42PM +0200, Paolo Bonzini wrote:
> On 09/05/20 01:53, Sean Christopherson wrote:
> > Restore the pre-fastpath behavior of tracing all VM-Exits, including
> > those due to failed VM-Enter.
> > 
> > Fixes: 032e5dcbcb443 ("KVM: VMX: Introduce generic fastpath handler")
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Squashed, thanks.  Though is it really the right "Fixes"?

Pretty sure, that's the commit that moved trace_kvm_exit() from
vmx_handle_exit() to vmx_vcpu_run().  Prior to that, all fastpaths still
flowed through vmx_handle_exit().
