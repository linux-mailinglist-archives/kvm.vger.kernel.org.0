Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593417BEAAD
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 21:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378456AbjJITeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 15:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378450AbjJITd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 15:33:58 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E060894
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 12:33:55 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2775a7f3803so4812238a91.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 12:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696880035; x=1697484835; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tIAr8DPfh+qMIaRmwoAlJ+K4B6ZX16dNQ2a3o/4VJ9I=;
        b=XALda4cKKkaYprWGEkpE21aEPAUwgqx52xipa4+ankXckFsHspZjrMmutDqT6M0s9N
         VDy3C4SXxcDjAZMYmRP3eqCCTn04mj3ceBzf1/6dLKnCdf3wbOQAB5+2z5jxE821+drT
         pqVUltva8tUguLuzEYynhQQleeNwVkxueV6vxD7YErx9almeNHcVBMWkm3hCa8b9uCCD
         E4eDpAU8BcqemnmCEMR6eYYzoGujz5j4R2CWkAM16wLuXFv2fdZX+ddWemJ544pg85C0
         v1RV4iZtcvRItTXVdF9zm3Cx7yfDvaLsBKqZWRmxduHhjJeCxXtY7Q2h6npiSG2QE3vt
         oCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696880035; x=1697484835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tIAr8DPfh+qMIaRmwoAlJ+K4B6ZX16dNQ2a3o/4VJ9I=;
        b=tkKA4CZIT7MxksuJ33M45qIY038LlJAnCyRgAZYvLL2sHm7tpkOeCc5sqb4E5+1uq1
         edyHRPz+Qo+7nqYZyyRo6XU8TKGUvgrjRao+tAqeGAf5ZfIx+DdO4aoKFyCzwoRja2gb
         q08lA35P3eScnuQ88QEqEpfVmq0yhbDLs8m4Pr22LYWk/hym85rUOOjscBLtLNW6+YFa
         hHH4jlVu+O/aVQXmt1d3eMSJ+iWtXE30F53+CpY/ncyW4SuRNZ79oBWI5NMvHl+jpSqX
         gb1VoJS/XMGataMMT9/3/i/ztPOYNNOuYRD/9TP8ebr2xclVYJeg7OlIlHOn1Qreo6VD
         A7Vg==
X-Gm-Message-State: AOJu0Yxl1wNwaBls2XWiH73Br6AxIQTjo7k/Y2UTwvltnUebUWS6Wuql
        3Hifky0pMkbUyISNUa6pYyN8Z+9LkGc=
X-Google-Smtp-Source: AGHT+IE+bCR4ihgMmpiXgbNhSP5Vgu2CEPjeNQ9Yi6y1+8EM0hWz4Lu0bXeDtqwwTuiBXuOI0tlfBWMKDWg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:aa84:b0:279:84c3:4ab4 with SMTP id
 l4-20020a17090aaa8400b0027984c34ab4mr279179pjq.9.1696880035378; Mon, 09 Oct
 2023 12:33:55 -0700 (PDT)
Date:   Mon, 9 Oct 2023 12:33:53 -0700
In-Reply-To: <20231009110613.2405ff47@kernel.org>
Mime-Version: 1.0
References: <20231006205415.3501535-1-kuba@kernel.org> <ZSQ7z8gqIemJQXI6@google.com>
 <20231009110613.2405ff47@kernel.org>
Message-ID: <ZSRVoYbCuDXc7aR7@google.com>
Subject: Re: [PATCH] KVM: deprecate KVM_WERROR in favor of general WERROR
From:   Sean Christopherson <seanjc@google.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     pbonzini@redhat.com, workflows@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023, Jakub Kicinski wrote:
> On Mon, 9 Oct 2023 10:43:43 -0700 Sean Christopherson wrote:
> > On Fri, Oct 06, 2023, Jakub Kicinski wrote:
> > On a related topic, this is comically stale as WERROR is on by default for both
> > allmodconfig and allyesconfig, which work because they trigger 64-bit builds.
> > And KASAN on x86 is 64-bit only.
> > 
> > Rather than yank out KVM_WERROR entirely, what if we make default=n and trim the
> > depends down to "KVM && EXPERT && !KASAN"?  E.g.
> 
> IMO setting WERROR is a bit perverse. The way I see it WERROR is a
> crutch for people who don't have the time / infra to properly build
> test changes they send to Linus. Or wait for build bots to do their job.

KVM_WERROR reduces the probability of issues in patches being sent to *me*.  The
reality is that most contributors do not have the knowledge and/or resources to
"properly" build test changes without specific guidance on what/how to test, or
what configs to prioritize.

Nor is it realistic to expect that build bots will detect every issue in every
possible configuration in every patch that's posted.

Call -Werror a crutch if you will, but for me it's a crutch that I'm more than
willing to lean on in order to increase the overall quality of KVM x86 submissions.

> We do have sympathy for these folks, we are mostly volunteers after
> all. At the same time someone's under-investment should not be causing
> pain to those of us who _do_ build test stuff carefully.

This is a bit over the top.  Yeah, I need to add W=1 to my build scripts, but that's
not a lack of investment, just an oversight.  Though in this case it likely wouldn't
have made any difference since Paolo grabbed the patches directly and might have
even bypassed linux-next.  But again I would argue that's bad process, not a lack
of investment.

> Rather than tweak stuff I'd prefer if we could agree that local -Werror
> is anti-social :(
> 
> The global WERROR seems to be a good compromise.

I disagree.  WERROR simply doesn't provide the same coverage.  E.g. it can't be
enabled for i386 without tuning FRAME_WARN, which (a) won't be at all obvious to
the average contributor and (b) increasing FRAME_WARN effectively reduces the
test coverage of KVM i386.

For KVM x86, I want the rules for contributing to be clearly documented, and as
simple as possible.  I don't see a sane way to achieve that with WERROR=y.
