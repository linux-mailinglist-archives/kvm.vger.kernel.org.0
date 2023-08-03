Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA1976DBEC
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbjHCAEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbjHCAEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:04:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062252D4E
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:04:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d326cb4c97fso347958276.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 17:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691021079; x=1691625879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OEbR2Gine9RxoWQaFdgL3AGFmT7HAVDWo6YuuY1g8l0=;
        b=rqIaQ8aAnL+4iG2p4E/c1wtUqUWkSTtVQoJU7FbVousvqFbdNkdVdXmvZlCpT4lacP
         pT1vB2/Rk86ym2QPcMa2r1kcfofsOaBJTrycoK5S5LBZrEgtqXOapPmJjQ+O+5T9XlEM
         QumDXzr66oTOCvSQFPlglR4yEU983h3+U+kUHwEF6jiRhRxrIp1yukBmZ5kyATN5xDNe
         /+n/ACDHNiPu48XBCLQrwJB0AvwFcAAYp1MQDWycBpwjQgqRIp7fepecuLzMVEGhJEdE
         BcxkiR+2iHtVXiFAm3sB0SD3FuZ+O5seSa/40K1mQxDqzNOmnrDplnzEn06YZBy7wQnT
         LjWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691021079; x=1691625879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OEbR2Gine9RxoWQaFdgL3AGFmT7HAVDWo6YuuY1g8l0=;
        b=PvlKEV37eIIn1vOVqfW2UVnX5+nAq7Xaoavm8cugNndy7Ug3bkSWkC328qnJQ7ebBT
         e0iD/rfsJDpsOtuGEjWccmnMwJyNuHYhn/9y6Vzdsfc6p88yr3RrbyJDpdeP2EqJLFlN
         rE9GULrZhQqTupy7Krqizhj0/HsAcBvbowaRBUDGGXDafWqiYD2BeaWir53GKkyttnOc
         RsaG4+iCFsqTiiw7nDuNGcKc3W4TQPYmk1/SCVLhV7/0X+RvWAxfk8qlRL1WKbFAUHAa
         EUX0cCKPLkbwF6Im4FAhsQ6SlbpjQ+y0fFoW4tVDC7I0x6bmRLWjsaFzB8oc7WNOXjWy
         gRUw==
X-Gm-Message-State: ABy/qLb1BIA9kkp1KkTLpC410/sk5o9y3GQMnY/nZy1PrsvRBFduPNu7
        iB4zaEqSYA1dJuq7G3ofhu5Xh34ZbvE=
X-Google-Smtp-Source: APBJJlEWDm5YrTKl8/Us9wR/MERIy3JICAOxFiKaFOJ2w+3iQ8bfjHBJ2L151i3dY58uxSTZ5wOfIObiPM0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:160e:b0:d09:6ba9:69ec with SMTP id
 bw14-20020a056902160e00b00d096ba969ecmr142632ybb.4.1691021079180; Wed, 02 Aug
 2023 17:04:39 -0700 (PDT)
Date:   Wed,  2 Aug 2023 17:04:16 -0700
In-Reply-To: <20230718101809.1249769-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230718101809.1249769-1-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169101763086.1822199.8861875137836442444.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Remove x86_emulate_ops::guest_has_long_mode
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jul 2023 12:15:44 +0200, Michal Luczaj wrote:
> Remove x86_emulate_ops::guest_has_long_mode along with its implementation,
> emulator_guest_has_long_mode(). It has been unused since commit
> 1d0da94cdafe ("KVM: x86: do not go through ctxt->ops when emulating rsm").
> 
> No functional change intended.
> 
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Remove x86_emulate_ops::guest_has_long_mode
      https://github.com/kvm-x86/linux/commit/7f717f54845c

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
