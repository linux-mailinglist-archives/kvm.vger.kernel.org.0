Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C285C742EAB
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 22:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjF2Umz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 16:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjF2Umx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 16:42:53 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1852130F6
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 13:42:48 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f44c2566dso577939a12.2
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 13:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688071367; x=1690663367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BQRaWvbWayXrUaV/AdYM8A6PgwM50YALn2m11rBg8qU=;
        b=ZvuBCPvFjFFfa8d+zeaX46c2x0RijXWR6UrLD+BhybYRnBeiOyYlxDbqGIWXCZioD7
         ZoWlSM3s10b16QVHRvcNSQ2ADgzCmL70OUrYzCYR4OOQf1RKZijla/OQ9FBA9/lkvON6
         fphvlcXOJMhvX9CGodVsEzRcGS5MuxWZdhjdqH62iLroGXy5WRhF0Qe5LFdjlgkYAOsl
         GXWbKs/cG6e3gqM7iMUXW45g4SBZKhdPOo9QQ1emhpLiPch1aJIJo/fee0+KFFC7NKMo
         jKPIt5+Oa2r4lcoc5b+2hLIHg+GDaYRzlZBqQ8fquyFgs6FakYi2EhfTvXVKkV+dqZoV
         y2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688071367; x=1690663367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BQRaWvbWayXrUaV/AdYM8A6PgwM50YALn2m11rBg8qU=;
        b=MEYz42tWwXZGEdPje9zqA9aoHjZ+QLBdTSSnqAuOyBjF6sYo4qwlsbX7iXoomTp497
         S5QWcfYaGbhAqpu79mIVsHZVZbgm5/rKKME6BK3ZMl/MKAgd3xfJVRv9Lm21S5op4owt
         iDs7KIO/DEFhKO8y/XIrtQz7WifX8f44AigE2JOeLRRrKIWYHoZzWi/jtUBaNSHCDRJo
         VDVRQ8UtzBdifHMLKxGHFPlRORdb64mqmF1pxaLN+0U6WW4dkpE1EqLa9TNqbV6u065P
         RIYKZno75m75Nc8TazTqDFdgbR9H7zfCCV4PaHF07YWvjfze8dL/UdpY01PKuSiyL6OH
         1P6w==
X-Gm-Message-State: ABy/qLaYery03BunXENegygmfct5KPtmP7O3D4cm/kA6GxAmTitE9E2s
        TnhVmCAsYciYeRbwD1drNkDmqSpAZao=
X-Google-Smtp-Source: APBJJlHgevTQgY2MJg54ip7lP9/UCiNLV/mV8dCTaL4KyHYq1c01ivdPXnryEBWLTlP3BFj3MZA2IesL2GU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:67cd:0:b0:55b:583d:3fd9 with SMTP id
 b13-20020a6567cd000000b0055b583d3fd9mr6024pgs.6.1688071367584; Thu, 29 Jun
 2023 13:42:47 -0700 (PDT)
Date:   Thu, 29 Jun 2023 13:42:46 -0700
In-Reply-To: <ZJzWZEsRWOUrF7TG@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230616023101.7019-1-yan.y.zhao@intel.com> <20230616023858.7503-1-yan.y.zhao@intel.com>
 <ZJy6xcIsOknHPQ9w@google.com> <ZJzWZEsRWOUrF7TG@yzhao56-desk.sh.intel.com>
Message-ID: <ZJ3sxm6CngYC7pno@google.com>
Subject: Re: [PATCH v3 08/11] KVM: x86: move vmx code to get EPT memtype when
 CR0.CD=1 to x86 common code
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023, Yan Zhao wrote:
> On Wed, Jun 28, 2023 at 03:57:09PM -0700, Sean Christopherson wrote:
> > On Fri, Jun 16, 2023, Yan Zhao wrote:
> > > Move code in vmx.c to get cache disabled memtype when non-coherent DMA
> > > present to x86 common code.
> > > 
> > > This is the preparation patch for later implementation of fine-grained gfn
> > > zap for CR0.CD toggles when guest MTRRs are honored.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >  arch/x86/kvm/mtrr.c    | 19 +++++++++++++++++++
> > >  arch/x86/kvm/vmx/vmx.c | 10 +++++-----
> > >  arch/x86/kvm/x86.h     |  1 +
> > >  3 files changed, 25 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> > > index 3ce58734ad22..b35dd0bc9cad 100644
> > > --- a/arch/x86/kvm/mtrr.c
> > > +++ b/arch/x86/kvm/mtrr.c
> > > @@ -721,3 +721,22 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
> > >  
> > >  	return type == mtrr_default_type(mtrr_state);
> > >  }
> > > +
> > > +void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat)
> > 
> > Hmm, I'm not convinced that this logic is subtle enough to warrant a common
> I added this patch because the memtype to use under CR0.CD=1 is determined by
> vmx specific code (i.e. vmx.c), while mtrr.c is a common code for x86.
> 
> I don't know if it's good to assume what vmx.c will return as in below open code. 
> (e.g. if someone added IPAT bit for CR0.CD=1 under the quirk, and forgot
> to update the code here, we actually need to zap everything rather than
> zap only non-WB ranges).
> 
> That's why I want to introduce a helper and let vmx.c call into it.
> (sorry, I didn't write a good commit message to explain the real intent).

No need to apologize, I fully understood the intent.  I'm just not convinced that
the risk of us screwing up this particular case is worth the extra layers of crud
that are necessary to let VMX and MTRRs share the core logic.

Absent emulating CR0.CD=1 with UC, setting IPAT is complete nonsense when KVM is
honoring the guest memtype.

I 100% agree that splitting the logic is less than ideal, but providing a common
helper feels forced and IMO yields significantly less readable code.  And exporting
kvm_mtrr_get_cd_memory_type() only adds to the confusion because calling it on
SVM, which can't fully ignore gPAT, is also nonsensical.
