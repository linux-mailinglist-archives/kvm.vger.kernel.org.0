Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369A97D586C
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 18:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343909AbjJXQc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 12:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343881AbjJXQc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 12:32:27 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF631B3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 09:32:25 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9cce40f7eso39199175ad.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 09:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698165144; x=1698769944; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5GzmymUe1pax62z1VC7ZEkV0i3+BeKVhxznyxpe6Bzc=;
        b=ICjE6g+cydha7Wn6DtkNeViEFuDtY8z9DIibvhF5DWf1ht+ZhFaFPzj54lNUJTPP6t
         NlxJAeGvAtPHAcrAgeQvDysSfmMAXi/izvDYadu330sV7BO7b4xRjTUC+944dCbp20Gd
         aiL4E6TQZsebG/VCupYh95QQKum43s+FnGJNmjjtkRnEAWC4iMGE7UHV44VQAEktU6ya
         rwQ/go4kjUkws5z969DI3WIyKwrp/GtqVBLyl1qgd5spIQe2L+tqOIsd6dFUJMXjIyHi
         mEiVuJsWC7hr/iw5qKA3KWCc+Pg9EIODTurZ621o8Amvh6OriIrj8VZb1bzPn9FSYNkb
         Zrwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698165144; x=1698769944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5GzmymUe1pax62z1VC7ZEkV0i3+BeKVhxznyxpe6Bzc=;
        b=t6vOiop5zYVtRDkQCVa+9KnGv/J6rf2KfViPDlRYRK4ZNgcZKW2mBCkmGYqEhfPFbg
         Te+M+r992AWPMHhOt5u1CyTbC+YaRCW8apaHEFVXGOirE5I5465uuKuTYQQFSnyCXap5
         W+qLN4IObiJ01CqPVSeMJVNOqNl01EUxv4O/VzzrVqxodFjOveRd2puM0+BTscVWj7go
         bGcs0o8sw/5EUEDUsPT1HWb09HXVPTg9/V6Q0VBcyQhUvN3VZ50HSY/Q0bE6Ya3dZeAg
         y4jZhbjZjsk7lrnM7/QE3o3JoRS48AHxevdwrxKkuoi0gY0J5kLYkQkPM/tqLFtyCIUZ
         CQuw==
X-Gm-Message-State: AOJu0YzQQK38RQrJx47RCNQ5pjJ8jZZYLKNx4r7zjxst+jsIRGKfLAtC
        tW9lkWIKqJ7YDmZ9jOFrOjygqgYfW+U=
X-Google-Smtp-Source: AGHT+IHUwMUUKgwcg7lcFhCFzNYrNwiZ0J6zbrV6w6arrJF03RiDB9jgs8HGglnlW9P4SA4gsj6eGHjRmrY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d04b:b0:1ca:2285:3757 with SMTP id
 l11-20020a170902d04b00b001ca22853757mr177379pll.2.1698165144606; Tue, 24 Oct
 2023 09:32:24 -0700 (PDT)
Date:   Tue, 24 Oct 2023 09:32:23 -0700
In-Reply-To: <e02b39c1-96aa-faf9-5750-4c53b5a5fb46@intel.com>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-3-weijiang.yang@intel.com> <ZTMdyR8e63sCTKWc@google.com>
 <e02b39c1-96aa-faf9-5750-4c53b5a5fb46@intel.com>
Message-ID: <ZTfxly8573xdnruS@google.com>
Subject: Re: [PATCH v6 02/25] x86/fpu/xstate: Fix guest fpstate allocation
 size calculation
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dave.hansen@intel.com,
        peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023, Weijiang Yang wrote:
> On 10/21/2023 8:39 AM, Sean Christopherson wrote:
> > On Thu, Sep 14, 2023, Yang Weijiang wrote:
> > > Fix guest xsave area allocation size from fpu_user_cfg.default_size to
> > > fpu_kernel_cfg.default_size so that the xsave area size is consistent
> > > with fpstate->size set in __fpstate_reset().
> > > 
> > > With the fix, guest fpstate size is sufficient for KVM supported guest
> > > xfeatures.
> > > 
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > ---
> > >   arch/x86/kernel/fpu/core.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> > > index a86d37052a64..a42d8ad26ce6 100644
> > > --- a/arch/x86/kernel/fpu/core.c
> > > +++ b/arch/x86/kernel/fpu/core.c
> > > @@ -220,7 +220,9 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
> > >   	struct fpstate *fpstate;
> > >   	unsigned int size;
> > > -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
> > > +	size = fpu_kernel_cfg.default_size +
> > > +	       ALIGN(offsetof(struct fpstate, regs), 64);
> > Shouldn't all the other calculations in this function also switch to fpu_kernel_cfg?
> > At the very least, this looks wrong when paired with the above:
> > 
> > 	gfpu->uabi_size		= sizeof(struct kvm_xsave);
> > 	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
> > 		gfpu->uabi_size = fpu_user_cfg.default_size;
> 
> Hi, Sean,
> Not sure what's your concerns.
> From my understanding fpu_kernel_cfg.default_size should include all enabled
> xfeatures in host (XCR0 | XSS), this is also expected for supporting all
> guest enabled xfeatures. gfpu->uabi_size only includes enabled user xfeatures
> which are operated via KVM uABIs(KVM_GET_XSAVE/KVM_SET_XSAVE/KVM_GET_XSAVE2),
> so the two sizes are relatively independent since guest supervisor xfeatures
> are saved/restored via GET/SET_MSRS interfaces.

Ah, right, I keep forgetting that KVM's ABI can't use XRSTOR because it forces
the compacted format.

This part still looks odd to me:

	gfpu->xfeatures		= fpu_user_cfg.default_features;
	gfpu->perm		= fpu_user_cfg.default_features;

but I'm probably just not understanding something in the other patches changes yet.
