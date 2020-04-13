Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BCB1A6FE4
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 01:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390215AbgDMXwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 19:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390211AbgDMXwO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Apr 2020 19:52:14 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167C2C0A3BDC
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 16:52:14 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id f19so11336856iog.5
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 16:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0xDrCmTsTZTIlLaVR+QGzK626JvIH4vogYPo8BI/5UA=;
        b=SERN95WAXEBrmyNiHeELexhFAq7x092uLy5ZnEc5cDO/v7LOvmcB5yyIULrYkFlVvu
         MrACALP5CN/o5b8eXCSvG5yJYwH+oGSYFxOR6zk9EkXFaVw6oDVwnUUpboWP/lreaXzT
         uCDWK5a+LTG7mdEOAYQ1S2PMBcY2H0u7VDfjF9+P6ANKrhLa0BnJduo1WifOFwdqkrlQ
         ARePiWDeVcCRGDOLA0UGEXqieb4EavGZnHsyfH9yLKr8MPvNcOW5BlpOkx63Q4Vr2sxb
         MoBLxNR4Q6wwL5SRxAV0VUxBN/OBoUCmPN6K4X3TuB2W/BZPY9qHP1ts5HYGZrHLTlvU
         Uxaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0xDrCmTsTZTIlLaVR+QGzK626JvIH4vogYPo8BI/5UA=;
        b=F4xRhqr1ogFGluLJ0x0wPrInPsU/RlEY6UIIDXcljgZkNIpZ832pVbNbEgc+aNaJpJ
         sa0a8QG/i68xiXO1zGJRUErLlxGpvis/GLgxNJk/UsSTEDcdz+rHqQfZyXV+WYIi9aAY
         2y1bTrDclV5TPzFlr4Kc9fB6PZrmcGdDd5iReWtFbipWTSMvhlso444645xn4pi5Jj27
         vLXsHu8RrTMdYq+JFIh/mAhocni6iRNeNbJ2VMlRV11ygsQrVLCgUJZ5OAIIATc8G1Ck
         dX+s7ZciOwHWeSDCRYmnLS3seL99WJkH/XkpEHNz66Zc1rj8kE8JJazRFFqmP3SW2f8I
         lPLg==
X-Gm-Message-State: AGi0PuaKqTHCmRSPNb7s+zLLHNWi+UdaRx0O+MSXILLVPrID7/7EheMv
        H7Dt/aOdmeEltGX473DFbMERA1cXwHlzD3+THFBVkg==
X-Google-Smtp-Source: APiQypJF7XpPNJGLHihWmUb7/+l/nZz9ZiGx2HMXa6KCKde6qVw96Y7CkGAeBj+TdbJsT4/xIHesKHsyg67hofFfUfs=
X-Received: by 2002:a02:6d02:: with SMTP id m2mr18634592jac.54.1586821933094;
 Mon, 13 Apr 2020 16:52:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200413172432.70180-1-brigidsmith@google.com> <20200413235039.GK21204@linux.intel.com>
In-Reply-To: <20200413235039.GK21204@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 13 Apr 2020 16:52:01 -0700
Message-ID: <CALMp9eTagRsDJbQ00OUfdLGvgbOi-a+fwAsPgKWKDCNSdiQSqg@mail.gmail.com>
Subject: Re: [kvm-unit-tests RESEND PATCH] x86: gtests: add new test for
 vmread/vmwrite flags preservation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Simon Smith <brigidsmith@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 4:50 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> s/gtest/nVMX for the shortlog.  I thought this was somehow related to the
> Google Test framework, especially coming from a @google.com address.
>
> On Mon, Apr 13, 2020 at 10:24:32AM -0700, Simon Smith wrote:
> > This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
> > vmread should not set rflags to specify success in case of #PF")
> >
> > The two new tests force a vmread and a vmwrite on an unmapped
> > address to cause a #PF and verify that the low byte of %rflags is
> > preserved and that %rip is not advanced.  The cherry-pick fixed a
> > bug in vmread, but we include a test for vmwrite as well for
> > completeness.
>
> I think some of Google's process is bleeding into kvm-unit-tests, I'm pretty
> sure the aforementioned commit wasn't cherry-picked into Paolo's tree.  :-D

I see it in Linus' tree.

> > Before the aforementioned commit, the ALU flags would be incorrectly
> > cleared and %rip would be advanced (for vmread).
