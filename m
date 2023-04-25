Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40A96ED95D
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 02:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjDYAgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 20:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDYAgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 20:36:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0944D59CA
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 17:36:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b9968fb4a8cso3950549276.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 17:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682382999; x=1684974999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yDfW1xE8RFGBMPuNaQCdlILVggtoxz0gIGSj60ufi80=;
        b=kslE2b+/RuZuSIUFH4uaoG95zD95xlG8mUsOMXRywZFAjO21FTjBdHz07KWANIEONJ
         svtl6RvMM2aBu5s2IgV6ZV2c2qI2VICxsQ4SQ+f4TjkdzRkNFHZc8nOiOovBscteyoyY
         StnXGSikDZ+TAlqh8z9Yn3ALl/fwLvETTc55NandNJI6PDEApdPviKPwuM345Dadwo94
         2KNDtV3ydKwqW6Bd41Iv9Lx2qkEkpvBOwmXZ/rq5oRjyKMMbZD0jdXTppRN4YpBu6a5r
         wA5R7LQa3uVf1b9GOEEU9UGm2fYP41TMMxeTbkpHIjD2zjdZpueDU0fnQNm82uX+Ps7A
         KADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682382999; x=1684974999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yDfW1xE8RFGBMPuNaQCdlILVggtoxz0gIGSj60ufi80=;
        b=OisGsT9gNIQ1mb6diPc7/cfjJV3KNI0isLXOqzZ+TloblF7Tr6YCD6JjacYzkwZidU
         vJEs9NkdKGy9UBshwNr+E1t8tsNlNQrXh0u+aYadgpOEhBV/uoFC54hYXXC++Ec8O6FD
         AMaAMgZdnpxWa+UT3zxnh5Z6N+BeiYpsyv/8Umb/Mpic+RMjGLLARf7nebB/xh/GrOM2
         FFcZHvAFGQNfyMpNYap3odj6pWPPh98xPv4mO4HFHzDIHBiuLIaS3lquo3tzKJtGtJdD
         /XpWDfKy5iiPU5R1v6aYVJVaA7rwPwAk9CoQ4ZIr4Q6K/NkNC+ewoodOamkj7blHTlKu
         96vw==
X-Gm-Message-State: AAQBX9ckgByisxui5nT0JqqHBvY98bt5wWVSvoe17b/ea95QNO3/YT0G
        x1WLAbn3J/qfT205ixs4Nbgzs3zWlNg=
X-Google-Smtp-Source: AKy350bfD0Qp39gUDCR0lEO+GnEF2TzgxQfjWRVoao0vVY17ktGpM6vaXigOl6FHDDDTFnVZDJv4Hh3IKKw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d144:0:b0:b95:bdfb:df09 with SMTP id
 i65-20020a25d144000000b00b95bdfbdf09mr5652650ybg.7.1682382999275; Mon, 24 Apr
 2023 17:36:39 -0700 (PDT)
Date:   Mon, 24 Apr 2023 17:36:37 -0700
In-Reply-To: <CALzav=cOB5rdwutrAa3eqFzHbdR-Dct0BAJWbExf1cTjUq2Mjw@mail.gmail.com>
Mime-Version: 1.0
References: <20230421214946.2571580-1-seanjc@google.com> <CALzav=f=TFoqpR5tPDPOujoO6Gix-+zL-sZyyZK27qJvGPP9dg@mail.gmail.com>
 <ZEM+09p7QBJR7DoI@google.com> <CALzav=cOB5rdwutrAa3eqFzHbdR-Dct0BAJWbExf1cTjUq2Mjw@mail.gmail.com>
Message-ID: <ZEcglWoeGS3pc5kK@google.com>
Subject: Re: [PATCH v2] KVM: x86: Preserve TDP MMU roots until they are
 explicitly invalidated
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Ben Gardon <bgardon@google.com>
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

On Mon, Apr 24, 2023, David Matlack wrote:
> It'd be nice to keep around the lockdep assertion though for the other (and
> future) callers. The cleanest options I can think of are:
> 
> 1. Pass in a bool "vm_teardown" kvm_tdp_mmu_invalidate_all_roots() and
> use that to gate the lockdep assertion.
> 2. Take the mmu_lock for read in kvm_mmu_uninit_tdp_mmu() and pass
> down bool shared to kvm_tdp_mmu_invalidate_all_roots().
> 
> Both would satisfy your concern of not blocking teardown on the async
> worker and my concern of keeping the lockdep check. I think I prefer
> (1) since, as you point out, taking the mmu_lock at all is
> unnecessary.

Hmm, another option:

 3. Refactor the code so that kvm_arch_init_vm() doesn't call
    kvm_tdp_mmu_invalidate_all_roots() when VM creation fails, and then lockdep
    can ignore on users_count==0 without hitting the false positive.

I like (2) the least.  Not sure I prefer (1) versus (3).  I dislike passing bools
just to ignore lockdep, but reworking code for a "never hit in practice" edge case
is arguably worse :-/
