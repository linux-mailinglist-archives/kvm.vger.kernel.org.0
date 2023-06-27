Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0829F7406C0
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 01:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjF0XHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 19:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjF0XHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 19:07:00 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BE22944
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 16:06:58 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-262dc0bab18so1763527a91.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 16:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687907218; x=1690499218;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gL62EeYqdZ3PPyujO7ySVUUWGUsaK4x/yrcgDor1fzE=;
        b=XA0i6NJO6zVaWEAdvQ0RGr3lYDbLStCwBxZEmIzXRY3TZ8UXLILRMKpUywo4CQfxEN
         tWebC5EoS9ylt9sr/cyovWOVr3fgf+HOHFC+NZWJIubjBTbISTmse52BgFHIMzUP/yD7
         kX1PA6VsckP4xAR1CAobEFeZ5AyAum44ZFdABMVatmHUjnRDPLF4AMjUSa8Jr2Q4ydLq
         ENG95eEdMBtLVW3SFdZ1dAFGYHZICz9cp50HeOioOyT6q5S1z2sBhiC/9wEoG8FsABa2
         0YwfGdJBtoomJI+qKMURt0Toszw9RNb4wew49BQyelaX28EXL2BrSyNQB0pG6StV2c3J
         dqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687907218; x=1690499218;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gL62EeYqdZ3PPyujO7ySVUUWGUsaK4x/yrcgDor1fzE=;
        b=EgeNgJMr4JMaWuiNPFY2GSz31Ez57tWOvg51A4+EnPQ+1jHvaow00oZfovHp9k+sHe
         0I5yUmFHRmC9eQqy0mbb8T1BVuKVVGrgBrvobcsPzpp4co3wfOIXcyrv+DySjL9tRUp7
         kCWKQ9n55xC7r331pPUuFvCXzg0F2Z6uUxjF93Z0h6cf4E4L57IzjlNXb7JC2UDCg1wE
         QA6ijZ5JNLhSlzg2GHzhN0AGz9ez1QKO754hQKWzxRu7TsM3C1NTl3dy5XUE2UKWyYqM
         ROstXkP8GdqDvTFP/eeBLarIlcEJ63LsvsIfvFI4Muf356TuuLCG3FnEziZ++zpw+Lzk
         mHbA==
X-Gm-Message-State: AC+VfDxQP8agRFg9VOWe9CavUU5RGd4iZ88UFbaCCiAm2UxCQk5lRBpn
        mtw144OvHpTBo8x6r/s5Dz4ZGhK7j8XYBxRL7tBYXx4w+hwtbAXd/JML5N9AUHT9WwUUlVTRqZe
        iseYkElIPdUJmkGjubADHWV81RhaZPW8DMbD8QUFJ+IgnMDEsQo1/SUnV5w==
X-Google-Smtp-Source: ACHHUZ666Fn22KRYLGf7nDT1NpIRjQNKOeRfl8ZbwKBChIE/imADWetbcLmqcEvBBkb/Gqs7ZqR06jmRGBg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9418:b0:262:e955:3d87 with SMTP id
 r24-20020a17090a941800b00262e9553d87mr1221003pjo.9.1687907217644; Tue, 27 Jun
 2023 16:06:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 27 Jun 2023 16:06:54 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627230654.2934968-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.06.28 - CANCELED
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No topic this week, and I need to reclaim some time this week as I will be OOO
all of next week.

For future topics, a few things on my radar that I am hoping to discuss in the
not-too-distant future, but that need additional work before they're worth
discussing:

 - Coordinating guest_mem() development.  I need to post patches, plan is to do
   that the week after I get back.

 - Overhauling KVM's gfn_to_pfn() APIs.  Need a status update from David S., e.g.
   I don't even know if this being actively worked.

   https://lore.kernel.org/all/ZGvUsf7lMkrNDHuE@google.com

 - KVM + UFFD scalability.  We're not yet at the point where we need a synchronous
   discussion, but I suspect we'll want a live discussion before merging.

   https://lore.kernel.org/all/20230602161921.208564-1-amoorthy@google.com

 - Hiding KVM internals from the kernel at large, e.g. moving kvm_host.h into
   arch/<arch>/kvm and virt/kvm/, and exporting "internal" KVM symbols if and
   only if there are vendor modules.  Needs an RFC from us (Google GCE people).

Future Schedule:
June 28th - Canceled
July 5th  - Canceled (Sean OOO)
July 12th - Available!
July 19th - Available!
