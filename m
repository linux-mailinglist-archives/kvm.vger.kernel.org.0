Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780C87B75AB
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 02:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbjJDAKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 20:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjJDAKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 20:10:32 -0400
Received: from mail-oa1-x49.google.com (mail-oa1-x49.google.com [IPv6:2001:4860:4864:20::49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A94AB4
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 17:10:26 -0700 (PDT)
Received: by mail-oa1-x49.google.com with SMTP id 586e51a60fabf-1e1dc572fbeso2131403fac.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 17:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696378224; x=1696983024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AxAlV3CAuuyZC8A6b6U3UPYaMBOXggU9rKrWo9R2t80=;
        b=dOuaV6NOYFe9DFhhwcwCJnrNqatX/th6EyZ5U7cv+vtHDNB4rOfBh1YFadnYTKnGFG
         qWUfxid36MgMmX/vFfaNPy6ZFEfCmtMVF878iygROZ5g3IcH/cBpcCtsrLfUABz7bYXs
         se3hZtFOuDUXM8gNHl+yGDVNNr6zo/JZrj0DFJIGxpYBgaU+nVz5woul7UqWAdTlKEP7
         psWlTicyyEheUVofrHRwUm4pp+F+2gKMnGrNfUiGrmEpyYDONSikeENaN77Gp17VqQ0b
         GfWMHNJ1vCVK8nW+3PFmNtzR50L4hNVgRgzJKOcJaPwkuunrRIMgaLNVnUhfgXlNr1FU
         CAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378224; x=1696983024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AxAlV3CAuuyZC8A6b6U3UPYaMBOXggU9rKrWo9R2t80=;
        b=RvvwsvB4OU0hU0U5J4tnE1lc4kOtpS5EWME6rsacQAlZFxUplYYYyeqqGuzZ5riihU
         6r7spTO/3BqgySvWTwIvG0vLqev52ubTHxp5rjy8vSs1+dfKFKLHcgYARQQAFgy8G4LP
         HMDaCGdIvkcrJs9KqIXoL7+/ViHDcGFZMKkHA0cEXffiVAWA5mZctTNtdTnGj23W3sj5
         i4F/RxxC8iztlxeD6ZpygN/zVFP6FPSaXu2DG7yWT6IisxOCfJpm+YJktvgDOgML5e1W
         Kp1EqD58lHVcfg0jDI7s4uc3w1yTI8sC5fxovgTNRXZrT59QJ6vy6SjienmenIlP1LSA
         l/SA==
X-Gm-Message-State: AOJu0Yx98io35YXrhmhPzsyDL9XR217lCkDZ3F4d4P7/kTrLd5wU4rXD
        IqPyb+VBPByi/lDmFbWflQGusq8ZkVc=
X-Google-Smtp-Source: AGHT+IGh9NLt6VD+EMJiFG+xJSgFI7vM20co70t1dOvhaBoRgTemKpWp9FjJuKs1SJOMtW9rpViC+Vr9TzY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6870:3a28:b0:1e1:2ebc:b63a with SMTP id
 du40-20020a0568703a2800b001e12ebcb63amr407181oab.2.1696378224685; Tue, 03 Oct
 2023 17:10:24 -0700 (PDT)
Date:   Tue, 3 Oct 2023 17:10:22 -0700
In-Reply-To: <96ceb6a6e9c380d329e8cd556ad13a2fcd554882.camel@infradead.org>
Mime-Version: 1.0
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com> <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com> <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com> <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com> <96ceb6a6e9c380d329e8cd556ad13a2fcd554882.camel@infradead.org>
Message-ID: <ZRytbih4TUVkEhLC@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
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

On Tue, Oct 03, 2023, David Woodhouse wrote:
> On Mon, 2023-10-02 at 17:53 -0700, Sean Christopherson wrote:
> > 
> > This is *very* lightly tested, as in it compiles and doesn't explode, but that's
> > about all I've tested.
> 
> I don't think it's working, if I understand what it's supposed to be
> doing.

...

> When I run xen_shinfo_test, the kvmclock still drifts from the
> "monotonic_raw" I get from kvm_get_time_and_clockread(), even with your
> patch.

It "works", in that it does what I intended it to do.  What I missed, and what's
obvious in hindsight, is that the timekeeping code doesn't *just* update what KVM
uses as the "base" when there "big events" like suspend/resume, the timekeeping
code updates the base clock on every tick.

My hack only smoothed away the delta, it didn't address the time that had gotten
moved into the base.  I though the base would be stable if the host was in a
steady state, but see above...
