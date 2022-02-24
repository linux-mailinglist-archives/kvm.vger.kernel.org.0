Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526C54C23F6
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 07:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiBXGO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 01:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiBXGO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 01:14:56 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A70B234022
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 22:14:27 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o26so263302pgb.8
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 22:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AcesQizc+ubZc3BIrOT5zz6JTdW6rEleTjgpKAn42RQ=;
        b=C4xlXdce515O+e+mu5KsDJlkUT0q8i+OwflyqkLbu9OgXXhJPm+IFmxLmq+eF6lX0+
         E60Cgs1wwbm/76XCpMbAGbZEwO/xZd2ib9Wk9MUjC2kH6zKI/NQ1xy4JXt4l7VoIwvwZ
         QyO47cWdfQSgdHu5aM1QTYfl+8k/LbcWbWvOYF9lFVKSzwLxjGkJoMfEvooKS5fZAvSo
         dLYzreUYLEmC1vQwZaFhP6d/6K8HAFC+/L5DoMtXed863g/wxlUqDeFkrCAFaakN+aKI
         tG1T9y8Sg0Bq47XaSx7UPJAGRAFuqoei4ARB7j0jzLjMSzGtOA3Rx74BWQnYkh1pF55q
         GpZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcesQizc+ubZc3BIrOT5zz6JTdW6rEleTjgpKAn42RQ=;
        b=5QuH+OCB24alqEXrE+fZYIYUmcaFaLQNfHKm+xtXkEI8AZKJOPXM8iumPH7nwStomQ
         94+470BTPnvIi+bXitKPFJj1SWaEnO5ttTsCHMasPwwxce2gcNGZOKrZbSErZhxWGJ5V
         ms+cZobzrSQo9QsThWayiL/+mXbYVynxu2wuoLVqTvQfSye/5LOltQXX/b47R+7EMgK0
         EYeKev8bF5m94pTKutpSoh7lfb3Tks0DV2nks/rc1bhuH+Ks4Ztwt5ZAWTAXbKs2AnSK
         8F+cIAOVlndCbjazIEHfWsl13wSl4ugB/Yvx15YGjv+ul8IlgBKyWI16Vh2F3vS/lpDk
         Sdvw==
X-Gm-Message-State: AOAM530PnrG7HSIttNjUgncnfM4tGxpGLtjnD9TILxmoi53WqwegBQfZ
        ZrTaGoLaM3htD5v5MENPdxAlEeJK2uC2RJnwFr3eqg==
X-Google-Smtp-Source: ABdhPJxI2uT3Q1vcNIt/vBqPLHZP7CvTxkIVzKbUC8ZJOcqQjVxntyiAbpTdnGLxdUaIQfKtQMtmwRDM/xvJ2RoY4Xk=
X-Received: by 2002:a05:6a00:194b:b0:4e1:799:7a3 with SMTP id
 s11-20020a056a00194b00b004e1079907a3mr1167891pfk.82.1645683266572; Wed, 23
 Feb 2022 22:14:26 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com> <20220223041844.3984439-2-oupton@google.com>
In-Reply-To: <20220223041844.3984439-2-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 23 Feb 2022 22:14:10 -0800
Message-ID: <CAAeT=FwgekGA-OjqN5hQeWNY8TS=Vf03GKfgW03sFhFahpgTKw@mail.gmail.com>
Subject: Re: [PATCH v3 01/19] KVM: arm64: Drop unused param from kvm_psci_version()
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
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
> kvm_psci_version() consumes a pointer to struct kvm in addition to a
> vcpu pointer. Drop the kvm pointer as it is unused. While the comment
> suggests the explicit kvm pointer was useful for calling from hyp, there
> exist no such callsite in hyp.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
