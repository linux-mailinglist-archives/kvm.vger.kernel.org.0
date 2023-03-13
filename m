Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106666B7DBD
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 17:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjCMQf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 12:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjCMQep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 12:34:45 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45325D24C
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 09:34:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54352648c1eso19962317b3.9
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 09:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678725222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1YN/kn5tUIvnKVGCxG4cIG+uXw70HUCMmpKpnoVfrrk=;
        b=NiVxquW03F8qjoBoYXJXLEr8aDfAuK+F2roX+nU1/GU6a+AegRWFTZys3WA/QBcH5F
         XCc+K8pu9+szIP3WW0QDbJhRKpFe+8DP27ZITy8pnlFTsN91OyaQxfQHAqKphUBguaTE
         GP3OJ9szV/3iMb62xy4jqXazvN9Bi+ijCoRmk+iU58NdAnluk77V4fdxcT+0s27zhCJ3
         eW2v8brvHjUIxFDWZvOFvgV6O9UbKFvz//gGUqPQUZryupFiEnpADHWjLCLZLGisLN1J
         dw1JioITvHEaNCRyAuZEgD/TNsOcZwvIkm7uqtC0siMBNBPxR6lxyB3GKR5956CEdYAA
         sSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678725222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1YN/kn5tUIvnKVGCxG4cIG+uXw70HUCMmpKpnoVfrrk=;
        b=eaxSO8DXjxHTl/n6sFeKP0i2PhhFj/uOjq2HtAbMSf3Y2FSAzG/SJWN/Kyi0KJDikk
         IvuJyyFmHXLrUqcNfIQDeEgdtFo7LVjzxoE/BcbOcsbRShJYTJ826PE5l6NQLHm6qc4B
         qF8sHBb3RW8oe9wOHH2f5RtDcO6QBQ2A1BObZLspN8ZOQ7+W6DbrA4IipE1c+dg3AkV2
         xHgTUzjSesGimVc6G7xR3om/TZ5NWnpmISvQOTl1zswkI+OHbc6NyjcJLFD4KtWZ8D7R
         ff3Wty3Px1oDsfeO28D8+NeKZhI2YeVpIvSWRqle68Pdnc9+oUR4qSlJ7OjdJTyjeOLL
         Op/A==
X-Gm-Message-State: AO0yUKXkypuexYRZLJ3rkdA7TM99B6o9/7v+GLnM+sbGi5Z+nRiDMHpY
        UG8Oa3zGbMF4lIGB9Nd3012PAoRlnxQ=
X-Google-Smtp-Source: AK7set90SPeIlKKcOh4MYTWM/4JuNJxzhyaTNiHeprEATkR7bY9LaomAU+gUM9iRrPe/B99cm2gCw7XmD60=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:40e:0:b0:ac2:ffe:9cc9 with SMTP id
 m14-20020a5b040e000000b00ac20ffe9cc9mr21740178ybp.3.1678725222642; Mon, 13
 Mar 2023 09:33:42 -0700 (PDT)
Date:   Mon, 13 Mar 2023 09:33:41 -0700
In-Reply-To: <20230312180048.1778187-1-jason.cj.chen@intel.com>
Mime-Version: 1.0
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
Message-ID: <ZA9QZcADubkx/3Ev@google.com>
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Chen CJ <jason.cj.chen@intel.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023, Jason Chen CJ wrote:
> There are similar use cases on x86 platforms requesting protected
> environment which is isolated from host OS for confidential computing.

What exactly are those use cases?  The more details you can provide, the better.
E.g. restricting the isolated VMs to 64-bit mode a la TDX would likely simplify
the pKVM implementation.

> HW solutions e.g. TDX [5] also exist to support above use cases. But
> they are available only on very new platforms. Hence having a software
> solution on massive existing platforms is also plausible.

TDX is a software solution, not a hardware solution.  TDX relies on hardware features
that are only present in bleeding edge CPUs, e.g. SEAM, but TDX itself is software.

I bring that up because this RFC, especially since it's being posted by folks
from Intel, raises the question: why not utilize SEAM to implement pKVM for x86?
