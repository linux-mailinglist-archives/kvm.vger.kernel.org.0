Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22096740CE
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjASSWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 13:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjASSWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 13:22:43 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2EB86BE
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:22:38 -0800 (PST)
Date:   Thu, 19 Jan 2023 18:22:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674152556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OzfCV3/9JR3qLlWlWp5bkAeX6UfoakQGqHB6vOzQ/IU=;
        b=f9+CdkZlmSi/jWLM8hevzqjt+sseTFUxwwcvWfIqondY/U/yJWIfcLD//ZVNBvrgnHf6G9
        QjhFOCncRYUZHAH5csXiDMUi1tVLd3rEilZyI4pcWqh34tLjjpGSZvKwMz5h64oBx1GStI
        Eb/tcw0PZzm7tmU/dVCcGgLu3c80W1Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        catalin.marinas@arm.com, will@kernel.org, paul@xen.org
Subject: Re: [PATCH v5] KVM: MMU: Make the definition of 'INVALID_GPA' common
Message-ID: <Y8mKaBgzDmtj2rtK@google.com>
References: <20230105130127.866171-1-yu.c.zhang@linux.intel.com>
 <Y8iUkMbNM8jWE4RR@google.com>
 <20230119072556.ebnddkr54vqbzmjk@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119072556.ebnddkr54vqbzmjk@linux.intel.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 03:25:56PM +0800, Yu Zhang wrote:
> On Thu, Jan 19, 2023 at 12:53:36AM +0000, Sean Christopherson wrote:
> > On Thu, Jan 05, 2023, Yu Zhang wrote:
> > > KVM already has a 'GPA_INVALID' defined as (~(gpa_t)0) in kvm_types.h,
> > > and it is used by ARM code. We do not need another definition of
> > > 'INVALID_GPA' for X86 specifically.
> > > 
> > > Instead of using the common 'GPA_INVALID' for X86, replace it with
> > > 'INVALID_GPA', and change the users of 'GPA_INVALID' so that the diff
> > > can be smaller. Also because the name 'INVALID_GPA' tells the user we
> > > are using an invalid GPA, while the name 'GPA_INVALID' is emphasizing
> > > the GPA is an invalid one.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > > Reviewed-by: Paul Durrant <paul@xen.org>
> > > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > 
> > Marc and/or Oliver,
> > 
> > Do you want to grab this since most of the changes are to arm64?  I'll happily
> > take it through x86, but generating a conflict in arm64 seems infinitely more likely.
> > 
> Thank you, Sean! 
> 
> This patch was based on KVM's next branch - fc471e831016c ("Merge branch 'kvm-late-6.1'
> into HEAD"). Tested by cross-building arm64. 
> 
> Do you know if KVM arm use a seperate branch(or repo)? Thanks!

Yes, you can find us over here:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/

I'll grab this after I wrap up testing what I have so far.

--
Thanks,
Oliver
