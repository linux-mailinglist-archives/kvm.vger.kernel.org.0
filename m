Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F517DA1F4
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346491AbjJ0Utk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 16:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjJ0Utj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 16:49:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1737B1AA
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da03390793fso2015797276.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698439776; x=1699044576; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UjOn0SlRJ1+h2a7+Neupvs12FMjbJPWp3o6Nn7p63fU=;
        b=sg2KRGhBCmvE5LhJ3ga6BLUBO7/FMwLPsO6wRq5+ndWFVM0lh47nLrcbYDHeKb5lhU
         ukdB0B7rX2/u9IF3CWryyK9BgMRc2HO06LLPQWROTvWoDScWDHU2LV4u3mAcBTI274Wl
         GcPwM5IR+dtYaCoJG3xPhe8G2BjnM/a7/G/50iV7d9Ohq3NtutDe6MmJ4RF8UkRdxUqI
         MlAYb4YywwsTBBAplsGC88RmX3WtriSlPXIGRgJV104T8qIq4osI/t7Xg4kuPMqntO41
         WSX7lJJS0G6Bd4UP9GDUqZWxuYWyIg/fZSvKcYIj5+lXfbL+BMF/nG+gye2+LHrZQhee
         fYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698439776; x=1699044576;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UjOn0SlRJ1+h2a7+Neupvs12FMjbJPWp3o6Nn7p63fU=;
        b=jBd0otSfxShJV4HyWZQ06CpHdojZsu/vuhdZRPB9EWHJ6fGO9/NC94nOAz7lAI802C
         RHJhP8/V9po4pepxMxZdx95RX6m9ErwTVresLvW9KtG56mR0OsZ29qTXIoDfbCUriPtH
         LIzXaETKoMMYSOkL4W2Nt30ShUOFJQbKtwYh8XNH30VSw54fOWTkOSsQ+0xIM67ho152
         Ygiaik3zHC2q6jqk77cawrYZHaNR8XZ7nfFvbEfmFHzBI/ZaQ3yKZsDklnUmDX4QZtDY
         SEzEYNZND8K17ahe8J/b/XRlpeWMLSt4aiJrlm5awz/sR2B3o+1sPcxh/k7BdCZUM29U
         uLIQ==
X-Gm-Message-State: AOJu0YzUZnRAG4kgsdy9xdxB+KzX6Feq81lnl+uiIIT4Gm1ir/nzLTka
        /L1zufxC3RiOZG6ALOUiHN+KDyUya8c=
X-Google-Smtp-Source: AGHT+IEVeoFXBrcpaY3ZcseA3WG9yNQqaL++XZQeJp4l175vBRKOO59BfjePrH92LVIrOZRZaNaafAqc4Iw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d250:0:b0:d9a:5b63:a682 with SMTP id
 j77-20020a25d250000000b00d9a5b63a682mr70057ybg.13.1698439776363; Fri, 27 Oct
 2023 13:49:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 13:49:24 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027204933.3651381-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 pull requests for 6.7
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I know you said a cover letter isn't necessary, but sending everything all at
once helps me keep track of things, and git send-email replying to whatever
random pull request happens to come first alphabetically bugs me.

  [GIT PULL] KVM: x86: APIC changes for 6.7
  [GIT PULL] KVM: x86: Documentation updates for 6.7
  [GIT PULL] KVM: x86: Misc changes for 6.7
  [GIT PULL] KVM: x86: PMU change for 6.7
  [GIT PULL] KVM: x86: SVM changes for 6.7
  [GIT PULL] KVM: x86: Xen changes for 6.7

Don't get used to the low volume, the next few cycles are likely to be chonkers.
But, I have started using dedicated topic branches for larger series, e.g. for
guest_memfd and LAM support, and I'll send pull requests for such branches much
earlier in the cycle.  So, in theory, the size of the pull requests that come in
just before the merge window will still be relatively small.

Speaking of pull requests coming in just before the merge window, I meant to get
these sent out earlier this week, but guest_memfd happened.  At least it looks
like I'll still beat Oliver, which is all that matters :-)
