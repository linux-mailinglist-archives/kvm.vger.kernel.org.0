Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C183B34F3
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhFXRqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 13:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFXRqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 13:46:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FA1C061574
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 10:43:42 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m15-20020a17090a5a4fb029016f385ffad0so3977878pji.0
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 10:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AHOtXnlJaynWofohi4Hd8twqyRQ9MIVX08GOYAtj29M=;
        b=EcLmx9XqDsQdtGO1iIQHXMSV0svk57Ndw0xd4/BqZ2NGDlnv8bYvofr+UPNJcXAWBI
         S/pWbdxGUSw3ztipHU+VdlS0oxcxSHdeiwIf3ideGW3GUZjG3R7JcffawQp0baXsaJqz
         v+A30Dzp8BFCPnP70pds+XRaw3+BSqzVMZ0XFHhIWr+9A/iF+m9hhCuYFXaB/JSe/2Ut
         WOJGDxAVAT9tbvyK91xqeUBMAf7qjJkBA6/bvnAdFNCVLNdTgb72ZfAu4lFS06+7DQdh
         QY3v16OZoDT2zpCMZuNUFZVxM0XnP6WkzllXYDsrdZvBxuWKLvGdkmqSUw3mULpl4NrL
         gRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AHOtXnlJaynWofohi4Hd8twqyRQ9MIVX08GOYAtj29M=;
        b=NINNq+QGyFb1WJYisSrCrZMwO5UIyArsXxel0ivx1zMaUU606OFZH0x7Rayq4Vrwf+
         WbgoyAeEvJ7xot8GeSLvz3ubz7xAyBBhhD+bAV3gZKQOapqDM7LtCXJRAs2DZFTIDkP7
         qytpPx71brDDSdZpRCHloUeYJChiAblp2/R57yXSiHV6JDZgQfeNdY3/KRV7RE0jiUun
         CBKF8Mxzu80bETxwqQXAOTjxAunnJFC+H8n0q//xgINCi2hrf3rbW76Wgrxo18IGab2v
         589XOnf9zcNNoy2+s1lcl+kVPxfXEzx6TFl79datafOkzdelOXFhT2HtaJup0GdUZ5p6
         czEw==
X-Gm-Message-State: AOAM533F3jaASnoRvHn8i8+JSmz6sEImZ+qoWfLzgo2CLOHfgyfAnTgT
        HbTI2pIyGEPDeV1dCuwtLX00XREEwmF/9Q==
X-Google-Smtp-Source: ABdhPJwrMjO859XXPlvwfpkngfj5v4b30VIe5jmDdA7XkbwvhWp8AmuC3Kfhx23kIQ5HtePgxnwCow==
X-Received: by 2002:a17:90a:d717:: with SMTP id y23mr6612412pju.0.1624556621369;
        Thu, 24 Jun 2021 10:43:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c5sm8798280pjq.38.2021.06.24.10.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 10:43:40 -0700 (PDT)
Date:   Thu, 24 Jun 2021 17:43:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 05/12] nSVM: Remove NPT reserved bits
 tests (new one on the way)
Message-ID: <YNTESd1rtU6RDDP0@google.com>
References: <20210622210047.3691840-1-seanjc@google.com>
 <20210622210047.3691840-6-seanjc@google.com>
 <2f1c2605-e588-2eea-d2c1-ab2f4fdc531d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f1c2605-e588-2eea-d2c1-ab2f4fdc531d@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021, Paolo Bonzini wrote:
> On 22/06/21 23:00, Sean Christopherson wrote:
> > Remove two of nSVM's NPT reserved bits test, a soon-to-be-added test will
> > provide a superset of their functionality, e.g. the current tests are
> > limited in the sense that they test a single entry and a single bit,
> > e.g. don't test conditionally-reserved bits.
> > 
> > The npt_rsvd test in particular is quite nasty as it subtly relies on
> > EFER.NX=1; dropping the test will allow cleaning up the EFER.NX weirdness
> > (it's forced for_all_  tests, presumably to get the desired PFEC.FETCH=1
> > for this one test).
> > 
> > Signed-off-by: Sean Christopherson<seanjc@google.com>
> > ---
> >   x86/svm_tests.c | 45 ---------------------------------------------
> >   1 file changed, 45 deletions(-)
> 
> This exposes a KVM bug, reproducible with
> 
> 	./x86/run x86/svm.flat -smp 2 -cpu max,+svm -m 4g \
> 		-append 'npt_rw npt_rw_pfwalk'

Any chance you're running against an older KVM version?  The test passes if I
run against a build with my MMU pile on top of kvm/queue, but fails on a random
older KVM.

Side topic, these tests all fail to invalidate TLB entries after modifying PTEs.
I suspect they work in part because KVM flushes and syncs on all nested SVM
transitions...

> While running npt_rw_pfwalk, the #NPF gets an incorrect EXITINFO2
> (address for the NPF location; on my machine it gets 0xbfede6f0 instead of
> 0xbfede000).  The same tests work with QEMU from git.
> 
> I didn't quite finish analyzing it, but my current theory is
> that KVM receives a pagewalk NPF for a *different* page walk that is caused
> by read-only page tables; then it finds that the page walk to 0xbfede6f0
> *does fail* (after all the correct and wrong EXITINFO2 belong to the same pfn)
> and therefore injects it anyway.  This theory is because the 0x6f0 offset in
> the page table corresponds to the 0xde000 part of the faulting address.
> Maxim will look into it while I'm away.
> 
> Paolo
> 
