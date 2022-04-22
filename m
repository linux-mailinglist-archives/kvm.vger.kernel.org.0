Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030E750BC6B
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448891AbiDVQD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 12:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449635AbiDVQDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 12:03:45 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178C455236
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 09:00:51 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id be20so2631196edb.12
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 09:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z64NNLHkcUmTZj8rPBl+zXy5wRD3qI9VqCl/OwwNbD8=;
        b=B59WmKOmyKLqObKAYrr0Nd3oMvb1zTXWY8Y55DCWA51Dtj5KPWN31pUm7Q6DECCdEw
         KSBHAQvXsR06UMbAZIJjb6TqDEKsIcKHrJnrAdzGN2mPvXyKv8ml7ZlPDaYMxu6qFgn0
         r7guBuL6nmDnu3nFX9pV0W6PtphTRWDjb3GgBrYKV+TmCx8DCE4cEE87S3p85fu+f3T1
         gFjfRCMjOpVD5ZYAj3a3MkL/glhUssHZyZmJBI+2J3EhuJfHC8S8Xnut8x3y3OfzgHBZ
         sJ9g5lhUeJgpBdgiwgxZmB/w5IOt/tc53uzl7T9nLQTLnGgfK3HVb5t/LejD/QZbZKCN
         YYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z64NNLHkcUmTZj8rPBl+zXy5wRD3qI9VqCl/OwwNbD8=;
        b=XBrxvW9sTL02JHu8UJWgvDuuSq4k2dmvbS0GHMAEdVLAdFLvwz6H3IODG0q+36h8hI
         cQl1yRgViL4OHdugGSM7JQ5Et8J5zrOmQbMj6/czTXTpQWxsHCs/31OrL6d/2wlLa3Ku
         QBRagnBKpCoqyzUog2+VIN3lkMNEflNqRLALgPhCUU6UBOiVlpY71gQdEUgj1q+d6NxX
         3h7EsFwCt9sw4jnTO2aWFGXchHkgQZ9VKFa20kFQWpkqBBYEaVbCTz82C3GmDNl1i9Pa
         Fwo1u21OERB+ZMRPCamhP8FB76DIGd+cdf7+MkZaFbzVl4yb8aJX9Xqvd0GcmIrTa7jP
         83MA==
X-Gm-Message-State: AOAM530bsGAMgYFDGIhvbPXLrQrhjV1ZrL/BCTl8fjjCRrrNdswitJWw
        qJt/OBcEUI9gDd7DP9zFHchQfQ==
X-Google-Smtp-Source: ABdhPJwgTmz6DWsAH0vuu2Cgkvp4em5pC8WwDnJP/+KeAYOH3MbagaEyjkznZqW7nPRo1eklhTXx2w==
X-Received: by 2002:a05:6402:5ca:b0:423:f330:f574 with SMTP id n10-20020a05640205ca00b00423f330f574mr5714790edx.116.1650643249420;
        Fri, 22 Apr 2022 09:00:49 -0700 (PDT)
Received: from google.com (30.171.91.34.bc.googleusercontent.com. [34.91.171.30])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b006d5eca5c9cfsm867968ejo.191.2022.04.22.09.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 09:00:49 -0700 (PDT)
Date:   Fri, 22 Apr 2022 16:00:45 +0000
From:   Quentin Perret <qperret@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YmLRLf2GQSgA97Kr@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
 <YmFactP0GnSp3vEv@google.com>
 <YmGJGIrNVmdqYJj8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmGJGIrNVmdqYJj8@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday 21 Apr 2022 at 16:40:56 (+0000), Oliver Upton wrote:
> The other option would be to not touch the subtree at all until the rcu
> callback, as at that point software will not tweak the tables any more.
> No need for atomics/spinning and can just do a boring traversal.

Right that is sort of what I had in mind. Note that I'm still trying to
make my mind about the overall approach -- I can see how RCU protection
provides a rather elegant solution to this problem, but this makes the
whole thing inaccessible to e.g. pKVM where RCU is a non-starter. A
possible alternative that comes to mind would be to have all walkers
take references on the pages as they walk down, and release them on
their way back, but I'm still not sure how to make this race-safe. I'll
have a think ...
