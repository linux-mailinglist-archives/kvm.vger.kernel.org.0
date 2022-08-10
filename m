Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6699B58F489
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 00:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiHJWxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 18:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiHJWxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 18:53:38 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036B35A88E
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 15:53:37 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a9so23218892lfm.12
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 15:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=j6fno2mISmVVseTNiVd5u2bXemkF7mgmiaKZKMr15FM=;
        b=HDMpqlIa35VfOhvDtP6A3gqDhAoyxOeOo6u0e7+xTJmrpq9BjCWOCrFepK6ll3Idds
         QIvwN3vWSBMPVJcwtjrnGPI5Zr8LPCKwtMMuIKLOs5dvOJXcuFwSOuderPgE4ES4x3Lq
         DAfY44Ibnh0YRv/tzN3w7Ssi1FK6JiCLHJccuXyu7hLZmjYIP1ihAXroyTzGo68yFGbd
         xiRvwE+t1yOmwIfzVUI9lCUpNSAyYKOF5m53bCxppuDlJtWm7KG6oBDA1FKe/b392D8X
         d6EocmVT5p2a3Ac33wPpWHCCyG7T4AxHOBSRbE1Hws8Az6Gnn8w9TvmlHracGRnNrEg9
         eIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=j6fno2mISmVVseTNiVd5u2bXemkF7mgmiaKZKMr15FM=;
        b=VL6i6mKLju4XDlU5pNYMthP8Ikwv0B6H4TmJd0MOmKjsI6eyV2uFzYDG5rceF21Lqv
         7LvWlKpRp2WgDYWXizFoce/lY3Rqf8mgyVvcWCOyxMOtcPdbarGEwFXsnhWVWoOxOp/G
         zuWnxyHNSCRWFVgNlxVOO5D9Ag6DTSC5BdmTQ7vneVlfKtG59wVilo5mE+kBVKIMWHGw
         F1FJdz0ltJexSTRI8o7Y/SrESWvEVN6K4BLiM+zIC1e7N0t+guegU15NTfQRWNqjBbPC
         6gP1GDuGIdeEUaM+EdOUMRC1ffEzP6mkpCBxA6s4+NJ7Oz3uG/vrUrUoyn9Bt5PLV8V2
         10DQ==
X-Gm-Message-State: ACgBeo2vab4GMJsD1M7+RwJBwYs3uJyIsUUxKYQb1IT87btl+XO+Ja94
        53lSEKZb2mtOEpYCWVmNV6pEPBr0uBXznsd5qxz7nw==
X-Google-Smtp-Source: AA6agR4o+pAxCynagLEO6JT5nD8KF3ONgIeBDQzL8LHqZDJoPwnV0XhN6/KLOpWZ6HbkKbBIgPUaPltMiWjkEyeKgcM=
X-Received: by 2002:ac2:5190:0:b0:48b:29b2:4755 with SMTP id
 u16-20020ac25190000000b0048b29b24755mr9570834lfi.23.1660172015230; Wed, 10
 Aug 2022 15:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220722234838.2160385-1-dmatlack@google.com>
In-Reply-To: <20220722234838.2160385-1-dmatlack@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 10 Aug 2022 15:53:08 -0700
Message-ID: <CALzav=frNna1fZYTxwz+Lo=1=zsOLAKoAd3pntXfUiDNdJ_PoA@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: selftests: Fix Clang build issues in KVM_ASM_SAFE()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        "open list:CLANG/LLVM BUILD SUPPORT" <llvm@lists.linux.dev>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022 at 4:48 PM David Matlack <dmatlack@google.com> wrote:
>
> The LLVM integrated assembler has some differences from the GNU
> assembler, and recent commit 3b23054cd3f5 ("KVM: selftests: Add x86-64
> support for exception fixup") seems to be tripping over a few of those
> differences.

Paolo, what do you think about these changes? I'm still hitting the
mentioned Clang build issues on kvm/master, commit 93472b797153
("Merge tag 'kvmarm-5.20' of
git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into
HEAD").

>
> David Matlack (2):
>   KVM: selftests: Fix KVM_EXCEPTION_MAGIC build with Clang
>   KVM: selftests: Fix ambiguous mov in KVM_ASM_SAFE()
>
>  tools/testing/selftests/kvm/include/x86_64/processor.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
>
> base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
> --
> 2.37.1.359.gd136c6c3e2-goog
>
