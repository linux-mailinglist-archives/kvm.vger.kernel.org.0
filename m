Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00C3709BAB
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 17:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjESPvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 11:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjESPvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 11:51:40 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0961B0
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 08:51:39 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2536c976b16so982651a91.2
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 08:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684511499; x=1687103499;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=luy/ROeaC2MRSlhSfPNK7sVWlW/c2u9qvqyGWr87IZ4=;
        b=ItL92bhkooVLP3MZfI7gF3VqnYUMBkCPHpuG3oVKSQ+IgX1z+ZWpJapJxD/7ZKfzf0
         M9Y4TeA0noORuYSe/sNp6t0NDFcOGFU98iDlx+cFAgGn4YPRZ59dVQpE55nQ+CT09Ofj
         nlsMyGK9S+C+XMqIieCCMcnEhf3hsaSSkxr8TPM3UvlNMZ5FGM0a4uv/0EIx2H5zzyGs
         01f6sZUj8lmcknqxRXRss4bzAj3h4nElMKl1J0XnasqwhUE8mhkkK+uevTbSdTaysj8W
         Kcu/lAY5FXg7hoMNdnu6LfFcS56iah/XPDHnJUpwVDVQq4Ke4wGI7aNmbc+vlaUiHt2k
         NEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684511499; x=1687103499;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=luy/ROeaC2MRSlhSfPNK7sVWlW/c2u9qvqyGWr87IZ4=;
        b=U87B2DMCis1BoZlU3nzAVw0V1lqV0yK9bAgVPn8kqfYjwMjHDjTZpg5z7p1P4HSCdk
         TBR4p5f1atHHpUfcRZqvrUCs0uCJeG/1w+UgYOs6mUe7Jmj47CmDHwzDYChEbd7ZK8yM
         mqrTFf63oPq1fEXQT/ezh3UFcXQZQJuIn2UpgOD/YJ1SOkGI/N54XILSe6EYIAAeHzUO
         NxXuJ9az83h/iCSSQHm14q8FWT0HRD5q4adFlcu3fQE6b1pvNkfWe7g/FYCBTD3zYsOp
         8mDKpMlT7c2p3r+KlvSV6URgjHiaog7ZC5l9mRJSgnwagJokuwYZaxfZrpyuyIrVxB69
         6uCg==
X-Gm-Message-State: AC+VfDzsfOMkzbVyCen8rpcxg/2PzrB4mUjSKT5NssS74ycG20lksiRP
        IKBrO0TbXpuXaK3RJ1WEbAWm+SHOm5Q=
X-Google-Smtp-Source: ACHHUZ7h5LNDIAwng4ctWQamXluyonrjElHAQNSTA/bg5wUjtoXWIo4FeITJfYdkYu3fQxZt9xf3x7Ai3os=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:247:b0:24d:fefd:a7fe with SMTP id
 fz7-20020a17090b024700b0024dfefda7femr654962pjb.7.1684511499008; Fri, 19 May
 2023 08:51:39 -0700 (PDT)
Date:   Fri, 19 May 2023 08:51:37 -0700
In-Reply-To: <be4ca192eb0c1e69a210db3009ca984e6a54ae69.1684495380.git.maciej.szmigiero@oracle.com>
Mime-Version: 1.0
References: <be4ca192eb0c1e69a210db3009ca984e6a54ae69.1684495380.git.maciej.szmigiero@oracle.com>
Message-ID: <ZGebCSwAA4W10atN@google.com>
Subject: Re: [PATCH] KVM: SVM: vNMI pending bit is V_NMI_PENDING_MASK not V_NMI_BLOCKING_MASK
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>, vkuznets@redhat.com,
        jmattson@google.com, thomas.lendacky@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, May 19, 2023, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> While testing Hyper-V enabled Windows Server 2019 guests on Zen4 hardware
> I noticed that with vCPU count large enough (> 16) they sometimes froze at
> boot.
> With vCPU count of 64 they never booted successfully - suggesting some kind
> of a race condition.
> 
> Since adding "vnmi=0" module parameter made these guests boot successfully
> it was clear that the problem is most likely (v)NMI-related.
> 
> Running kvm-unit-tests quickly showed failing NMI-related tests cases, like
> "multiple nmi" and "pending nmi" from apic-split, x2apic and xapic tests
> and the NMI parts of eventinj test.
> 
> The issue was that once one NMI was being serviced no other NMI was allowed
> to be set pending (NMI limit = 0), which was traced to
> svm_is_vnmi_pending() wrongly testing for the "NMI blocked" flag rather
> than for the "NMI pending" flag.
> 
> Fix this by testing for the right flag in svm_is_vnmi_pending().
> Once this is done, the NMI-related kvm-unit-tests pass successfully and
> the Windows guest no longer freezes at boot.
> 
> Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>

> ---
> 
> It's a bit sad that no-one apparently tested the vNMI patchset with
> kvm-unit-tests on an actual vNMI-enabled hardware...

That's one way to put it.

Santosh, what happened?  This goof was present in both v3 and v4, i.e. it wasn't
something that we botched when applying/massaging at the last minute.  And the
cover letters for both v3 and v4 state "Series ... tested on AMD EPYC-Genoa".
