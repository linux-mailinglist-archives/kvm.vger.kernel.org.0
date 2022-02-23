Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A784C0B0A
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbiBWE1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBWE1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:27:05 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5403012AE6
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:26:37 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id bu29so28967075lfb.0
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yOltLgvWydYJnuxlrjEjGgkNtwI9hxevSNBMbT48H/8=;
        b=SYpmP1ZC2tgC7paSEX2fIpV2BtAUZawz2yf2FAiGukOiiL0SRuFr1l7EvgOzs+n4oR
         BFsMpJuyPQSUHmqN/pCHQ1sVZSGapkaW2maF/cYQ31gfZ+XuD3ktFlbV6mpg6cUYPCQK
         K9khJAsMnJ993egZlUrufCmtvmBs0f8a3oLpZpUJjBRGD1KRQUo1RpYI1GNb/rZmDTmh
         vkm2W34HDVBkhh89Qsw2EKEWN6S0HXYHbbkine7AYP4ivna9EJ/sZjs90ZaVbGkUNr9h
         JUNm3QXSrOz3qb+7o2gZE0PfBfSZz5pbE3Mb/Ii2SlODwS1SPskx9sNYQEi2LDWJoKrM
         cdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yOltLgvWydYJnuxlrjEjGgkNtwI9hxevSNBMbT48H/8=;
        b=6+eoXLHlj83LXSvWYcDaSB8DGmxTumd+3F1yovinBRHUc1rRbD2dhyao+lQ+f39BAI
         0JP++HaO/cG9Rnc3e255GN6MEVJJXg3yvmUzonjsWjyXOXmDoNUziVeEEE63RN8YIptG
         c69iXXYMr825zb+DYDaDyXQMfkIP7ZoTgF42cfHVlqOQfPEYJVsZfkabDeNCka3gq1hG
         0aBHVWAmYHHFr9HziDGsDjywO89+JPsd+CgSz5nEaaHPMrRNp7yKrBq83hiPRD8y2xFw
         XX6e9wERFEcxWKAPyrXy7RlzaYtAoO3k04NgwVKjwlA7yk2OKsZnDt0zyBL8t3fnACMA
         gBLQ==
X-Gm-Message-State: AOAM531B1YqTR1wrJSv1bS2otuVI2YeS+khaWrB61kEfAdnMiCJtIbnZ
        fWGg0e7D8hgRAcaaVby+HjduPEAt3BgIOpTiEjZxQA==
X-Google-Smtp-Source: ABdhPJxf7Q+4gkUMXOvi7QEX+M/rO9KOFlKgosrkBvNqawwd3HKljioKFtSDFciK2PxaAOqFDwN79l/mYSO9uQbssfE=
X-Received: by 2002:a05:6512:3455:b0:443:5dc0:a32d with SMTP id
 j21-20020a056512345500b004435dc0a32dmr18808231lfr.38.1645590395245; Tue, 22
 Feb 2022 20:26:35 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com> <20220223041844.3984439-15-oupton@google.com>
In-Reply-To: <20220223041844.3984439-15-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 22 Feb 2022 20:26:24 -0800
Message-ID: <CAOQ_Qsgw4oHAf84tjwn3aBWgiNGPT_CxE8AxRm4Sf+GTx5uUwQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/19] KVM: arm64: Raise default PSCI version to v1.1
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
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

On Tue, Feb 22, 2022 at 8:19 PM Oliver Upton <oupton@google.com> wrote:
>
> As it turns out, KVM already implements the requirements of PSCI v1.1.
> Raise the default PSCI version to v1.1 to actually advertise as such.
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>

Ah, looks like this is already in /next, courtesy of Will :-)

https://lore.kernel.org/all/20220221153524.15397-2-will@kernel.org/

--
Thanks,
Oliver
