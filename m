Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECBA4F8BAA
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiDGXWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 19:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiDGXWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 19:22:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D706397;
        Thu,  7 Apr 2022 16:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649373630; x=1680909630;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/CX7rj6UBdfCBlPFHNrS787+yrDNla9i2UxNT1e7G1I=;
  b=aYC5VEd5wjNguUPOhUjeA3OhMPXKl3G3pl47n2Np1AR7UuJWwgK+001B
   nhKmVsVXvNIpbz0oea66jhzzIPA1ZglxZjnmOSMbdLqaYRb0ag/RV8u9N
   ZOQw8Iba/JQM3Q+6qClHKbjJtFFbhOrFJCagtqrEM/sLrqSbEyU8bINKG
   Nhue/cFi3ziGsyqg+eg6sb6P3chWkUMkNXIDq7pCGJhEZ37eXm7InbKJG
   VlohjBF+PvOFYgV40RuwxFxw5dTDwuElg8c5vWfOxX2kBFmksi2h7YPNa
   uToBje49SRQmjdyuPLKGfzO0pR7LKuREDVNOCbmGBKEP5C4qWmm2x9v9h
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="347902343"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="347902343"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 16:20:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="653024872"
Received: from asaini1-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.28.162])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 16:20:27 -0700
Message-ID: <f77917b478cf531e2cd6106706f606b9a86290b1.camel@intel.com>
Subject: Re: [RFC PATCH v5 089/104] KVM: TDX: Add a placeholder for handler
 of TDX hypercalls (TDG.VP.VMCALL)
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Date:   Fri, 08 Apr 2022 11:20:25 +1200
In-Reply-To: <Yk8pX8jweGu745Uj@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <b84fcd9927e49716de913b0fe910018788aaba46.1646422845.git.isaku.yamahata@intel.com>
         <3042130fce467c30f07e58581da966fc405a4c6c.camel@intel.com>
         <23189be4-4410-d47e-820c-a3645d5b9e6d@redhat.com>
         <Yk73ta7nwuI1NnlC@google.com>
         <6f1169f1-6205-c4d3-1ab0-2e11808f9b10@redhat.com>
         <Yk8pX8jweGu745Uj@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-07 at 18:11 +0000, Sean Christopherson wrote:
> On Thu, Apr 07, 2022, Paolo Bonzini wrote:
> > On 4/7/22 16:39, Sean Christopherson wrote:
> > > On Thu, Apr 07, 2022, Paolo Bonzini wrote:
> > > > On 4/7/22 06:15, Kai Huang wrote:
> > > > > > +static int handle_tdvmcall(struct kvm_vcpu *vcpu)
> > > > > > +{
> > > > > > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > > > > +
> > > > > > +	if (unlikely(tdx->tdvmcall.xmm_mask))
> > > > > > +		goto unsupported;
> > > > > Put a comment explaining this logic?
> > > > > 
> > > > 
> > > > This only seems to be necessary for Hyper-V hypercalls, which however are
> > > > not supported by this series in TDX guests (because the kvm_hv_hypercall
> > > > still calls kvm_*_read, likewise for Xen).
> > > > 
> > > > So for now this conditional can be dropped.
> > > 
> > > I'd prefer to keep the sanity check, it's a cheap and easy way to detect a clear
> > > cut guest bug.
> > 
> > I don't think it's necessarily a guest bug, just silly but valid behavior.
> 
> It's a bug from a security perspective given that letting the host unnecessarily
> manipulate register state is an exploit waiting to happen.

Security perspective from guest's or host's respective?  It's guest's
responsibility to make sure itself doesn't expose unnecessarily security holes.
In this particular case, if guest does, then it's guest's business, but I don't
see how it can compromise host's security, or other VM's security?

As Paolo said it's a valid operation from guest, perhaps an alternative is KVM
can unconditionally clear XMM registers, instead of rejecting this VMCALL.

> 
> Though for KVM to reject the TDVMCALLs, the GHCI should really be updated to state
> that exposing more state than is required _may_ be considered invalid ("may" so
> that KVM isn't required to check the mask on every exit, which IMO is beyond tedious).

Independent from this issue,  I guess it's good for GHCI to have this anyway.
