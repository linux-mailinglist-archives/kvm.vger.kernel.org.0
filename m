Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA336BF1AD
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 20:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjCQTa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 15:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjCQTa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 15:30:26 -0400
Received: from out-34.mta1.migadu.com (out-34.mta1.migadu.com [IPv6:2001:41d0:203:375::22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59004DE20
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 12:30:20 -0700 (PDT)
Date:   Fri, 17 Mar 2023 19:30:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679081418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0jCdRBqGA2tu6XOLfbhVwiAxzNSGs6ak27904LkdISc=;
        b=caTATcZwwRvg6ataeUUzdzgwg+ByMYM+CAsVmV9XfkdXgJOLYmiNOLkHsKsmjWaLmli0Ey
        Y50HTdrVYKEfzJ+axLkuvGxlmnaKQQZXJT3+dvDZQ8rlUVOGXh5Q4TeL/JLvS3PpghHe0V
        gFLBVHuu8kyGWZsQUavy6a2MV53AdkU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>, seanjc@google.com,
        jthoughton@google.com, kvm@vger.kernel.org
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
Message-ID: <ZBS/x/kP4Y+u8AOT@linux.dev>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com>
 <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 11:33:38AM -0700, Anish Moorthy wrote:
> On Thu, Mar 16, 2023 at 5:02 PM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> 
> > > +7.34 KVM_CAP_X86_MEMORY_FAULT_EXIT
> > > +----------------------------------
> > > +
> > > +:Architectures: x86
> >
> > Why x86 specific?
> 
> Sean was the only one to bring this functionality up and originally
> did so in the context of some x86-specific functions, so I assumed
> that x86 was the only ask and that maybe the other architectures had
> alternative solutions. Admittedly I also wanted to avoid wading
> through another big set of -EFAULT references :/

There isn't much :) Sanity checks in mmu.c and some currently unhandled
failures to write guest memory in pvtime.c

> Those are the only reasons though. Marc, Oliver, should I bring this
> capability to Arm as well?

The x86 implementation shouldn't preclude UAPI reuse, but I'm not strongly
motivated in either direction on this. A clear use case where the exit
information is actionable rather than just informational would make the change
more desirable.

-- 
Thanks,
Oliver
