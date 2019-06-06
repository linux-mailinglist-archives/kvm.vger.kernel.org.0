Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E913760F
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 16:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfFFOJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 10:09:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:21430 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfFFOJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 10:09:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 07:09:08 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga002.jf.intel.com with ESMTP; 06 Jun 2019 07:09:07 -0700
Date:   Thu, 6 Jun 2019 07:09:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 2/5] KVM: VMX: Read cached VM-Exit reason to detect
 external interrupt
Message-ID: <20190606140906.GA23169@linux.intel.com>
References: <20190420055059.16816-1-sean.j.christopherson@intel.com>
 <20190420055059.16816-3-sean.j.christopherson@intel.com>
 <77943c3f-405e-9cab-7535-cbe9cb1fc89b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77943c3f-405e-9cab-7535-cbe9cb1fc89b@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 03:02:02PM +0200, Paolo Bonzini wrote:
> On 20/04/19 07:50, Sean Christopherson wrote:
> > Generic x86 code blindly invokes the dedicated external interrupt
> > handler blindly, i.e. vmx_handle_external_intr() is called on all
> > VM-Exits regardless of the actual exit type.
> 
> That's *really* blindly. :)  Rephrased to

Hmm, I must not have seen the first one.

>     Generic x86 code invokes the kvm_x86_ops external interrupt handler
>     on all VM-Exits regardless of the actual exit type.
> 
> -		unsigned long entry;
> -		gate_desc *desc;
> +	unsigned long entry;
> 
> I'd rather keep the desc variable to simplify review (with "diff -b")
> and because the code is more readable that way.  Unless you have a
> strong reason not to do so, I can do the change when applying.

No strong reason, I found the code to be more readable without it :-)
