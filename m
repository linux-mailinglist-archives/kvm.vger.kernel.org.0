Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B696F8840
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 19:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjEER4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 13:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjEER4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 13:56:44 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB7F1A600
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 10:56:21 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-330ec047d3bso815795ab.0
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 10:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683309380; x=1685901380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kF9UNnFu7y9/BTQVcYBK8Em5F1RFnUr5Y8snIh0+eYw=;
        b=F6IzXuwiR0NMNMQ6/hzZOz8apiofdW4I2S/7ZOGycDbuqqi8nlcOe6aHwgXO/j/ZCk
         0G73HDNufeNLIn1AlHMHVflghGeqm8mTLxJ35jC0nnaKhbDyYHDSDNcoes8IuIDxU6fK
         FhXGtM5goF6ald2Oyb6LrkWfJVcoIW2u6JEFCilCz5J1OtWCxMFqc7ZzyjdslRtvXG95
         EZ/4nup4K859yTeI19IUNOhPEeYNk0uZ6NkiccmEUvcoi1bb/GtpdS7n8S+348bq/fJd
         6unmThXtVVZdumZzVc0OkZUXdDoGn1RrX/4CkdWBcFzTu6phmzQ/PqAw50fmsUFqsCQ1
         yHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683309380; x=1685901380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kF9UNnFu7y9/BTQVcYBK8Em5F1RFnUr5Y8snIh0+eYw=;
        b=ZfR2HYnWgN+NvAaJ7gYBIWrTtOyNxZZ26nMSTvgXqaIYKSSCZwvRE0bKxU8A7JMEyX
         LjTdBl6rCPK5SSH1evoSPPBxCXj0hyZXuD4gtGRBzIlClBYTSsSsjKOTxeFND1A2GOPr
         E8G7FkuvATdRvgtsiiePODKDDAALNqU0xeNn6jUDcgt7UY7JObfyyOutEAx7LhLlWT3W
         cgyzAxROfZFQJn2aFwTbw2syIxndmivFSmhcNjCwJieOcAQSNgvHpxqnY2fQ7F2/0V7v
         k5dNue4K4zL2ZevMRblvhX80cP0UlGeNpDzCkFJEZTTaqB42g6AUFNZIf4e5HY9qP7S6
         nKhw==
X-Gm-Message-State: AC+VfDxYKtgyWxPakvE6BuYu+cYO8vY4nKaXQhXfncRQCYsAFAEh8Ix7
        yZCIC2Bv+PdI6A/5w1UwU87/3F20ZZxm1yUa/c5oHg==
X-Google-Smtp-Source: ACHHUZ5/oWRRnyHtUTBEz2rVNGS0dMJr3n7jnQmq+RIV0MjDKozWSAU4X1qDxGJyquC2IDpdIMaSFrw+ihZwmg8juLU=
X-Received: by 2002:a05:6e02:1d88:b0:329:333e:4e79 with SMTP id
 h8-20020a056e021d8800b00329333e4e79mr272764ila.1.1683309379776; Fri, 05 May
 2023 10:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com> <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com>
In-Reply-To: <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 5 May 2023 10:56:08 -0700
Message-ID: <CALMp9eT-8xfp=obmZpnj-kXLWtdzBfzzwgzG6EFqrYssJKndBw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not itlb_multihit
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     lirongqing@baidu.com, seanjc@google.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, kvm@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, May 1, 2023 at 7:07=E2=80=AFPM Robert Hoo <robert.hoo.linux@gmail.c=
om> wrote:

> With regards to NX_hugepage, I see people dislike it [1][2][3], but on HW
> with itlb_multihit, they've no choice but to use it to mitigate.

I think it's safe to say that no one likes the NX-hugepage mitigation.
It seems that we've gone to extremes to prevent this one specific DoS
vector. Do we have confidence that we have comparable protection from
*all* DoS vectors? If we let just one slip through, then there isn't
much point in going crazy about others.
