Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4B07658EE
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 18:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjG0Qj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 12:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjG0Qj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 12:39:56 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEE32D4F
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 09:39:54 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c7bb27977so994721a12.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 09:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690475994; x=1691080794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=08PPmSmbVOI5lp9VMb7/YRIHpnsubNB5bxPFF/tGfQM=;
        b=O3VZNy1xI6kpXEi28VVpZj98iHJw8jkNqum1WsxYb9mFxYKvkMhyFMvT3sBxtnCPuz
         SDWBqXgWnDc17jVqffzqjHLrZfkoSx9ZmemZszDZHhxDp2c2z/7SG1gnFLmqFKxDp3FH
         3rfP0Ct33uL6CjFYQlSrEvJ9XP5oBf9RYxsmueBUAVTZHhgjtoAxYiprxvzQgtfevo1i
         Ijo6mIUMJuJH3cEYhdauKp5dv1Ybs62fqWL6UmvqRJcPfTMKk+YevVlgVg/BQoI5SdBE
         9AnvZUseK2/UCtOKfh+LOPosSSS9UL5b9EbcntVYG2BrYXznAG9pAjumML+FXVYsFN/X
         PbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690475994; x=1691080794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=08PPmSmbVOI5lp9VMb7/YRIHpnsubNB5bxPFF/tGfQM=;
        b=dxVAB4s7XtYE4QfyGyMEDfxYmNu2J5OwAwdmY/7eJTdMn9OTixrSysWFoQ0ipJut8y
         biIHgLRHcC+bzCgscy0+uGEhfmoUNtJLTBH4Vv17lFzDduDR3yJbEB03W7U8lUShRXAx
         vZC1l42q25VUgCWqSXbfHg6iKGkNCg7y1420tc2dlcU01FlOCPPxB4TZleTVBLq5MmXP
         HqLFQYV7/soQ8zCooo4kwhvZlZUKthBSu1Igo6xI+NaMS+Of7n7+fYz2s3ZdiOQwz9m+
         1pag1NlJARTmDEjca1eZbpkCmI2cbRZ30VA9/fKnnWg9U5+Eos6ta/COjx6bzvf7azrZ
         rdkw==
X-Gm-Message-State: ABy/qLY6Wl0IQEMeNdcN4YNp/BcDh9UQm34qAZLCGNFkFRL6RCviz+XM
        4zePZH+SXNAInKJtwF09qM/ai6HOPXY=
X-Google-Smtp-Source: APBJJlHBNR0jKPx+QW2JInhAKi0CXKbJ2026DppquRyRjvZ/o18U/ifcCZ7KgDESP6rCXBZ5VAjN4P6RPUk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:a746:0:b0:563:4dac:e580 with SMTP id
 w6-20020a63a746000000b005634dace580mr25609pgo.9.1690475994353; Thu, 27 Jul
 2023 09:39:54 -0700 (PDT)
Date:   Thu, 27 Jul 2023 09:39:53 -0700
In-Reply-To: <20230725091611.GA3766257@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com> <20230721201859.2307736-15-seanjc@google.com>
 <20230724212150.GH3745454@hirez.programming.kicks-ass.net>
 <ZL7vs9zMatFRl6IH@google.com> <20230725091611.GA3766257@hirez.programming.kicks-ass.net>
Message-ID: <ZMKd2cT2fw4ZiJQp@google.com>
Subject: Re: [PATCH v4 14/19] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023, Peter Zijlstra wrote:
> On Mon, Jul 24, 2023 at 02:40:03PM -0700, Sean Christopherson wrote:
> > On Mon, Jul 24, 2023, Peter Zijlstra wrote:
> > > On Fri, Jul 21, 2023 at 01:18:54PM -0700, Sean Christopherson wrote:
> > > > Check "this" CPU instead of the boot CPU when querying SVM support so that
> > > > the per-CPU checks done during hardware enabling actually function as
> > > > intended, i.e. will detect issues where SVM isn't support on all CPUs.
> > > 
> > > Is that a realistic concern?
> > 
> > It's not a concern in the sense that it should never happen, but I know of at
> > least one example where VMX on Intel completely disappeared[1].  The "compatibility"
> > checks are really more about the entire VMX/SVM feature set, the base VMX/SVM
> > support check is just an easy and obvious precursor to the full compatibility
> > checks.
> > 
> > Of course, SVM doesn't currently have compatibility checks on the full SVM feature
> > set, but that's more due to lack of a forcing function than a desire to _not_ have
> > them.  Intel CPUs have a pesky habit of bugs, ucode updates, and/or in-field errors
> > resulting in VMX features randomly appearing or disappearing.  E.g. there's an
> > ongoing buzilla (sorry) issue[2] where a user is only able to load KVM *after* a
> > suspend+resume cycle, because TSC scaling only shows up on one socket immediately
> > after boot, which is then somehow resolved by suspend+resume.
> > 
> > [1] 009bce1df0bb ("x86/split_lock: Don't write MSR_TEST_CTRL on CPUs that aren't whitelisted")
> > [2] https://bugzilla.kernel.org/show_bug.cgi?id=217574
> 
> Is that using late loading of ucode?

Not sure, though I don't think that is relevant for this particular bug.

> Anything that changes *any* feature flag must be early ucode load, there is
> no other possible way since einux does feature enumeration early, and
> features are fixed thereafter.
> 
> This is one of the many reasons late loading is a trainwreck.
> 
> Doing suspend/resume probably re-loads the firmware

Ya, it does.

> and re-does the feature enumeration -- I didn't check.

The reported ucode revision is the same before and after resume, and is consistent
across all CPUs.  KVM does the per-CPU feature enumeration (for sanity checks)
everytime userspace attempts to load KVM (the module), so the timing of the ucode
patch load _shouldn't_ matter.

The user is running quite old ucode for their system, so the current theory is that
old buggy ucode is to blame.
