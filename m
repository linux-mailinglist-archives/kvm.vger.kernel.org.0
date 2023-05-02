Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4156F4B20
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 22:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjEBUPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 16:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjEBUPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 16:15:42 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476E719B3
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 13:15:19 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-52057b3d776so2202248a12.2
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 13:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683058519; x=1685650519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z9wYmb61AJq/t/dK34/IZzNXoE4VD6rl22PB6n6jMeY=;
        b=gcsGiuf/S6OuDUr8Od48tj8Ivy2DjLGoO0/dyF3QZd7rkh8mhqN/ovUHeDqR4GQn7/
         pnmcaVNjTrz9bMdMxSm1X8STAYooDLQe0RQ6hT5Sm0tjsfp7gEW9xKi5C1FmX8tHhqDQ
         w2Y93qPy9N2eBmcq6BmnnsM0LSKrly3WCYw6ZclzcDQs50WpOfSOPPWsFBxS0aRZSH1B
         d3yfjQ1uE61JIabCTxO4B+0L2FulkACw/0IGcKPK28dMHiX+7EEGscHy2zHkksUxvgNV
         gVmuBZj1N+HMIvlY19PPIdQD1gJEHS7NKf6PSnmAttVM8ACBZw7DNLAGJzVFpKSaHD9q
         OXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683058519; x=1685650519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z9wYmb61AJq/t/dK34/IZzNXoE4VD6rl22PB6n6jMeY=;
        b=MuxOpiWAfPRMrdyDXNbw4niQMeDShycap8lJCUlHjerDqoLuZ9LnphTHgZcvbMduaf
         Nm0wm49W4kLdi8C5JJPGuiQLgRaQHvXcpNWYtQbYCk3QrTr5277rspu1/AeeEw3Q0poS
         a4h3D+1f3ijIxGAO7L5Owu1yAjk0fXETVHWD+8dYfRbQwI9Q1uD5jOAcvIM5Bia0Ximg
         4eqAXm24lVu6MMZkEcQenC3Ax9yDB+LpFt5AULpY3Mgu0LJCXN7utE76yfRfsQDBtBsy
         x+ykRL6nqFyg0TWmn+EOPvPKxE+X7m1pavCwssoCZqSTHBglau9sWyw2684VXQLgn9lR
         kjzQ==
X-Gm-Message-State: AC+VfDwW3Qy7+enwYZpX2g0gWzC9zRXTZyCuMTytwo4nLkm77tf7Xx2y
        CjlEiLQ/lMG59YHC8EmRL7O6KuD+RGQ=
X-Google-Smtp-Source: ACHHUZ5S+IjxqSZd8Ji0qyauzBmf29G1+Ebdz/7FhLvvYLKttlaIV2l27XCCK8KHBed3JoKvAZpUzrWE/B8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:8bc1:0:b0:528:7198:21c7 with SMTP id
 j184-20020a638bc1000000b00528719821c7mr4653168pge.10.1683058518761; Tue, 02
 May 2023 13:15:18 -0700 (PDT)
Date:   Tue, 2 May 2023 13:15:17 -0700
In-Reply-To: <20230419071711.GA493399@google.com>
Mime-Version: 1.0
References: <20220909185557.21255-1-risbhat@amazon.com> <A0B41A72-984A-4984-81F3-B512DFF92F59@amazon.com>
 <YynoDtKjvDx0vlOR@kroah.com> <YyrSKtN2VqnAuevk@kroah.com> <20230419071711.GA493399@google.com>
Message-ID: <ZFFt/ZMqQ1RHnY4e@google.com>
Subject: Re: [PATCH 0/9] KVM backports to 5.10
From:   Sean Christopherson <seanjc@google.com>
To:     Lee Jones <lee@kernel.org>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Mike Bacco <mbacco@amazon.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>, kvm@vger.kernel.org
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

On Wed, Apr 19, 2023, Lee Jones wrote:
> On Wed, 21 Sep 2022, gregkh@linuxfoundation.org wrote:
> 
> > On Tue, Sep 20, 2022 at 06:19:26PM +0200, gregkh@linuxfoundation.org wrote:
> > > On Tue, Sep 20, 2022 at 03:34:04PM +0000, Bhatnagar, Rishabh wrote:
> > > > Gentle reminder to review this patch series.
> > > 
> > > Gentle reminder to never top-post :)
> > > 
> > > Also, it's up to the KVM maintainers if they wish to review this or not.
> > > I can't make them care about old and obsolete kernels like 5.10.y.  Why
> > > not just use 5.15.y or newer?
> > 
> > Given the lack of responses here from the KVM developers, I'll drop this
> > from my mbox and wait for them to be properly reviewed and resend before
> > considering them for a stable release.
> 
> KVM maintainers,
> 
> Would someone be kind enough to take a look at this for Greg please?
> 
> Note that at least one of the patches in this set has been identified as
> a fix for a serious security issue regarding the compromise of guest
> kernels due to the mishandling of flush operations.

A minor note, the security issue is serious _if_ the bug can be exploited, which
as is often the case for KVM, is a fairly big "if".  Jann's PoC relied on collusion
between host userspace and the guest kernel, and as Jann called out, triggering
the bug on a !PREEMPT host kernel would be quite difficult in practice.

I don't want to downplay the seriousness of compromising guest security, but CVSS
scores for KVM CVEs almost always fail to account for the multitude of factors in
play.  E.g. CVE-2023-30456 also had a score of 7.8, and that bug required disabling
EPT, which pretty much no one does when running untrusted guest code.

In other words, take the purported severity with a grain of salt.

> Please could someone confirm or otherwise that this is relevant for
> v5.10.y and older?

Acked-by: Sean Christopherson <seanjc@google.com>
