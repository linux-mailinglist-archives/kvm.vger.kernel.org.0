Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2F57D56E6
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 17:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343945AbjJXPta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 11:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbjJXPt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 11:49:28 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637BF10A
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:49:26 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9b774f193so38883685ad.0
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698162566; x=1698767366; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G80d6SYNl+i6LLR4j1qPSwa+o2+/ZMsAHEKXJ7GB4aE=;
        b=b3kjausxWoRgpyBk1nGj26eczvmNxVsJavTGXE5lQezJqNWoQ2BxoNG12rRUB3nTom
         pN1HmxTbWY7RmK3OsJluezg1IlO162t9JmgENIdFSvKxBF3M9J52tZfuBLNIGGef55qK
         qGcKmYq/ZY8+xlnF/J49KxUU6nXE684qB9G6T1wuE2+QQgMENpVxkuD4UeFo5k84NTT8
         o9vJiKborwoR03oYnZPsKKKA9x1oVCNev3Ifs50n5M5I3pyJeXyL9XPTYU7P4+vrhWgh
         nRpqLXk/Q35BryIv8uIPBT3ZLPo1dMkds0y28Wg8RiwyA/40QG7BMLLJE+T1y/2+fVNh
         iUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698162566; x=1698767366;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G80d6SYNl+i6LLR4j1qPSwa+o2+/ZMsAHEKXJ7GB4aE=;
        b=LdlUyBLdbbY2gVud1cqGLFqRq0mxEf3tGCQVVhR1Mkk1bvHeRvpCE3OQvLzr5465xV
         CAlSbArcK97PPvxVu3JcPyo+z4UVg5vcqWh97MDEgAWTDgzdDM+xX2Y4iB6uYW3/mt0V
         U92hQKHWwuUTnFLJ8NrQmfqE3d3lQHfE/ldhihmIRYHlFO2rBpW+DCCoX+2yweMqiGoy
         mEhBPF8bFMMILB6ilOQfE81XW6VKreqerzIzYWOGlZc+RDHYGoCjO4EoADNa473Dbk0J
         H/eZKqm/rtaspgmpEGPeSoFYjtB8kxP0LcbE5sFC8HTJVWyrFTi0QB2L+vbTa62rTylY
         xVFg==
X-Gm-Message-State: AOJu0YzJ15W0XqLlxwbBO31KMFq/xj/Znh7TejJDb0e8gfLSyU+fNciU
        WBP0iX8LP9QHKSHnJHMC/J7rr3V+XmA=
X-Google-Smtp-Source: AGHT+IFrYstubtGogYYYcQdAcTrL20qVe3GVL5ZbVLT3TtIo9yRZ89XR7AFp4qkyCa5YQYIh/rupFNgnsMI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a3cd:b0:1cb:e677:2f08 with SMTP id
 q13-20020a170902a3cd00b001cbe6772f08mr39702plb.10.1698162565810; Tue, 24 Oct
 2023 08:49:25 -0700 (PDT)
Date:   Tue, 24 Oct 2023 08:49:24 -0700
In-Reply-To: <ZTd+i2I5n0NyzuuT@yilunxu-OptiPlex-7050>
Mime-Version: 1.0
References: <20231018204624.1905300-1-seanjc@google.com> <20231018204624.1905300-3-seanjc@google.com>
 <ZTd+i2I5n0NyzuuT@yilunxu-OptiPlex-7050>
Message-ID: <ZTfnhEocglG1AsO8@google.com>
Subject: Re: [PATCH 2/3] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
From:   Sean Christopherson <seanjc@google.com>
To:     Xu Yilun <yilun.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Matlack <dmatlack@google.com>
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

On Tue, Oct 24, 2023, Xu Yilun wrote:
> On Wed, Oct 18, 2023 at 01:46:23PM -0700, Sean Christopherson wrote:
> > @@ -126,7 +124,19 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> >  			list_first_entry(&vcpu->async_pf.done,
> >  					 typeof(*work), link);
> >  		list_del(&work->link);
> > +
> > +		spin_unlock(&vcpu->async_pf.lock);
> > +
> > +		/*
> > +		 * The async #PF is "done", but KVM must wait for the work item
> > +		 * itself, i.e. async_pf_execute(), to run to completion.  If
> > +		 * KVM is a module, KVM must ensure *no* code owned by the KVM
> > +		 * (the module) can be run after the last call to module_put(),
> > +		 * i.e. after the last reference to the last vCPU's file is put.
> > +		 */
> > +		flush_work(&work->work);
> 
> I see the flush_work() is inside the check:
> 
>   while (!list_empty(&vcpu->async_pf.done))
> 
> Is it possible all async_pf are already completed but the work item,
> i.e. async_pf_execute, is not completed before this check? That the
> work is scheduled out after kvm_arch_async_page_present_queued() and
> all APF_READY requests have been handled. In this case the work
> synchronization will be skipped...

Good gravy.  Yes, I assumed KVM wouldn't be so crazy to delete the work before it
completed, but I obviously didn't see this comment in async_pf_execute():

	/*
	 * apf may be freed by kvm_check_async_pf_completion() after
	 * this point
	 */

The most straightforward fix I see is to also flush the work in
kvm_check_async_pf_completion(), and then delete the comment.  The downside is
that there's a small chance a vCPU could be delayed waiting for the work to
complete, but that's a very, very small chance, and likely a very small delay.
kvm_arch_async_page_present_queued() unconditionaly makes a new request, i.e. will
effectively delay entering the guest, so the remaining work is really just:

 	trace_kvm_async_pf_completed(addr, cr2_or_gpa);

	__kvm_vcpu_wake_up(vcpu);

	mmput(mm);

Since mmput() can't drop the last reference to the page tables if the vCPU is
still alive.

I think I'll spin off the async #PF fix to a separate series.  There's are other
tangetially related cleanups that can be done, e.g. there's no reason to pin the
page tables while work is queued, async_pf_execute() can do mmget_not_zero() and
then bail if the process is dying.  Then there's no need to do mmput() when
canceling work.
