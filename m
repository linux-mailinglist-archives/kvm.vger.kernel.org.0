Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC1E76DA75
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 00:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbjHBWNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 18:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjHBWN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 18:13:27 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B94126AF
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 15:13:27 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c79a5565aso383625a12.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 15:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691014407; x=1691619207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oNrunTw9g/scAXlACL1Yy6BuHYu8UXiywBffDHO0ySM=;
        b=oRnUg49TyqQtCpG9mB1+Zt8T8V0fo6eI5r3czuLbiC4L4rdWaAvVrHBVtqTeJ90E9Y
         B5mZ5FxEswdpGVKmbD8pwI9bFz4V/mbheFZjzkgcOl/c5u2L4vsnneSqeIgWAP8/lQI3
         K34qOuv/PzRLXUwq2elOGYB7F92GhrDe+DtfEWHBkMakUjcspHZ8f6JEMNK1zQ9wuHBz
         e1B2WnP1p9aoj/wxzD9TsVHQB621qb0zo19xWV98Sv2YUL8E4eyA30M5eo4U916dAc/p
         X3aJpDamXtAC63JzSAXYnBsVQdUH92Yy4Se4/Lf7hhcWQoOgRWe+WrTk8vAfPtRpUjwE
         +ONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691014407; x=1691619207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oNrunTw9g/scAXlACL1Yy6BuHYu8UXiywBffDHO0ySM=;
        b=TQDcdq3xnnL1iWsZsW3+Jrg7GxzhfKJib+WvJTP006xqjqSkQxGCsqvoaTTeuSIenD
         tisHdMUx8a32merqfxnktOIROyU8ZhPR4bxwEEp2yRhbtu4wE9JmzhRuqh91Z6pd1QC8
         ZI3/9DfW7a/GnDlRsAuBwpe+tupoFazD9J+i4GI7g+3gqsI3lQm3u2+EnsHs4goW4IEa
         oWJBhZkYG6hP2hQirKC9JcQhQiGsjZr6u1j9CAmNCYp/HGR+r3STlhIDcbCCGJRk4U+q
         pd9KkUB5qLNa27vvP3g5u0KmYPwMcjckBkuNlHLubfLJhrKnvbguxwKaFvES7umRTdkt
         TCzA==
X-Gm-Message-State: ABy/qLY1gZa8gZ8uqklvk9JnWN52K4QPROST2LDG1p+Wmb1Z2vLeHfL9
        xTOo1Br0eHcPHsmNpACv6WRDWv64dy4=
X-Google-Smtp-Source: APBJJlHYYJG7D9hZiA9amsdCWObbBIYwdulg2VqDtGhU7hg3L7bAfjSx7kf9waosJHPo/esHNLPSDeRdLuI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c1:b0:1b7:edcd:8dcf with SMTP id
 u1-20020a170902e5c100b001b7edcd8dcfmr104418plf.4.1691014406820; Wed, 02 Aug
 2023 15:13:26 -0700 (PDT)
Date:   Wed, 2 Aug 2023 15:13:25 -0700
In-Reply-To: <20230726044652.2169513-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230726044652.2169513-1-jingzhangos@google.com>
Message-ID: <ZMrVBWg+c3PSUilR@google.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Test pointer authentication
 support in KVM guest
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023, Jing Zhang wrote:
> Add a selftest to verify the support for pointer authentication in KVM
> guest.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

...

> +	/* Shouldn't be here unless the pac_corruptor didn't do its work */
> +	GUEST_SYNC(FAIL);

FYI, I'm fast tracking guest printf support along with a pile of GUEST_ASSERT()
changes through kvm-x86/selftests[*].  At a glance, this test can probably use
e.g. GUEST_FAIL() to make things easier to debug.

[*] https://lore.kernel.org/all/20230729003643.1053367-1-seanjc@google.com
