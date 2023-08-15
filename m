Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D57B77D198
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239029AbjHOSP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239081AbjHOSPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:15:43 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8EC10DA
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:15:42 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26b29b33f0cso5051067a91.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692123342; x=1692728142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EJsuwMvz8tgFu/vr35YnapFf5dZJSFYIKICrN3nw/n8=;
        b=cNQtPSQYPMlVtSmlxRBBrdbZKdGV3QCN5MPNVLLytTc4i6lhIhkU3+zTG3p0LOpq3w
         Ad+nNIq23UcD9G8s/2QI95v8KAXcL90DuRg4aNI8B/iFGzDXnVNFfShVflhe4BFC8wG3
         n6VEDJyALBz6NWGJtkLc1m9AkOSwMxAHhOoz2+T+a2X9L5fglRUt8seK13QNGxiEerRI
         hE6qId5u5WU6CsECglBzHTJ5/JzUD3KOu/CRX2y0nXmyeQRCgihB2IKhbvSfpS3GEe1L
         i0ahJkqzwvyusAABsc4TcTDzRsx1rrzeo1z7iCOU9Puac2wTpXAMEx1CCz1wr7BHOglS
         bQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692123342; x=1692728142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EJsuwMvz8tgFu/vr35YnapFf5dZJSFYIKICrN3nw/n8=;
        b=DAIxSWoDRTylUHFB5EcCUwTcw0mTrvbQ7jEaDST5HPl+mn8tHIt/E1Pa+DFmSJ3F0x
         fIXRZpX5GJTK+Oqmw7JzL4VCpPBMd9l9Ckylgz415kvekjP5sp42hmNa0UGOSMxMzwo/
         QbVVs4dFIMsYqWyYfqOR41luaXIeI1pDXO9+NL0Rpo2WCCwqkbvNk07HM30p/sTjNz6p
         SDa60X9yG8seSiLLoaxhMss6kPjQNXPo9syXhJYkDki8y9Yze2X08Q7lmcGeIwHAUUF1
         1Fu9YbHfS2qHqbD9qNmnwFfeieCWkMn+7JV7MUtAr/ACKOPgxyyjYV/lY0LDzvlfw3qX
         mGfQ==
X-Gm-Message-State: AOJu0Yzd5HIdbo20Eegd31uxStnueeacn2H/CvJbjhjQbA1NrjXx3/Wr
        H5juBrFkThxGzE6A2jsZqZk9zdkOZdM=
X-Google-Smtp-Source: AGHT+IH3HCGMRCVdd/3tcRJ6UZDXELDTPSjO3Vi2xs3dSzBeA6L1nV+25XznSpVwF5E8lRv5JRosfokREg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:35ca:b0:268:9cfa:171c with SMTP id
 nb10-20020a17090b35ca00b002689cfa171cmr702962pjb.4.1692123341715; Tue, 15 Aug
 2023 11:15:41 -0700 (PDT)
Date:   Tue, 15 Aug 2023 11:15:39 -0700
In-Reply-To: <428bed16-f407-4e90-9bbe-e3eaa8b5fdec@rbox.co>
Mime-Version: 1.0
References: <20230728001606.2275586-1-mhal@rbox.co> <169100872740.1737125.14417847751002571677.b4-ty@google.com>
 <ZNrLYOiQuImD1g8A@google.com> <2c823911-4712-4d06-bfb5-e6ee3f7023a7@rbox.co>
 <ZNucb6NQ6ozi1vqz@google.com> <428bed16-f407-4e90-9bbe-e3eaa8b5fdec@rbox.co>
Message-ID: <ZNvAy4lsMsSeuvgq@google.com>
Subject: Re: [PATCH 0/2] sync_regs() TOCTOU issues
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023, Michal Luczaj wrote:
> On 8/15/23 17:40, Sean Christopherson wrote:
> > On Tue, Aug 15, 2023, Michal Luczaj wrote:
> >>> @@ -115,6 +116,7 @@ static void *race_events_exc(void *arg)
> >>>  	for (;;) {
> >>>  		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
> >>>  		WRITE_ONCE(events->flags, 0);
> >>> +		WRITE_ONCE(events->exception.nr, GP_VECTOR);
> >>>  		WRITE_ONCE(events->exception.pending, 1);
> >>>  		WRITE_ONCE(events->exception.nr, 255);
> >>
> >> Here you're setting events->exception.nr twice. Is it deliberate?
> > 
> > Heh, yes and no.  It's partly leftover from a brief attempt to gracefully eat the
> > fault in the guest.
> > 
> > However, unless there's magic I'm missing, race_events_exc() needs to set a "good"
> > vector in every iteration, otherwise only the first iteration will be able to hit
> > the "check good, consume bad" scenario.
> 
> I think I understand what you mean. I see things slightly different: because
> 
> 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
> 		...
> 	} else {
> 		events->exception.pending = 0;
> 		events->exception_has_payload = 0;
> 	}
> 
> zeroes exception.pending on every iteration, even though exception.nr may
> already be > 31, KVM does not necessary return -EINVAL at
> 
> 	if ((events->exception.injected || events->exception.pending) &&
> 	    (events->exception.nr > 31 || events->exception.nr == NMI_VECTOR))
> 		return -EINVAL;
> 
> It would if the racer set exception.pending before this check, but if it does it
> after the check, then KVM goes
> 
> 	vcpu->arch.exception.pending = events->exception.pending;
> 	vcpu->arch.exception.vector = events->exception.nr;
> 
> which later triggers the WARN. That said, if I you think setting and re-setting
> exception.nr is more efficient (as in: racy), I'm all for it.

My goal isn't to make it easier to hit the *known* TOCTOU, it's to make the test
more valuable after that known bug has been fixed.  I.e. I don't want to rely on
KVM to update kvm_run (which was arguably a bug even if there weren't a TOCTOU
issue).  It's kinda silly, because realistically this test is likely only ever
going to find TOCTOU bugs, but so long as the test can consistently the known bug,
my preference is to make it as "generic" as possible from a coverage perspective.

