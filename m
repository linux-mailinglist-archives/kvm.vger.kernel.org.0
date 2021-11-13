Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8216D44F088
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 02:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbhKMB0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 20:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbhKMBZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 20:25:55 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4CDC061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:23:03 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 184-20020a6217c1000000b0049f9aad0040so6540308pfx.21
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q7GrWuTY0VLlfBXSVo/l1AbRU3c932xDVsXpIdGJOrQ=;
        b=Qmzc0naE2HLfLu5C2KfMiITU+UJiTaXnpCuFgySBcgb58yGhXt/fTDiojjVpCSj2E7
         jIYeXWI43Mlupul7TfFnith9qWXSb/JWu9NvAQq21lHSzusJ1WVCxxpLuI9ftGeD/FLj
         AXxNCkeI8yA+FJ+odDw+8Yx60MOcHICOIGSaETOI2q9GsL++lJUuG9X1BY5TNG/pRWYH
         TzP5x6ZXpeiyibR6glYKFyx+v7Sod8MrhMPNOwyOMc0ccYYcp8tKq8j7516kKiXGo+0e
         z02V/ThWb4O2kALL4Ayv6zetGqgPT1sQQW14SJ4i37TYo0VO6zNOyOnGm28ClqVuX/Nb
         fMFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q7GrWuTY0VLlfBXSVo/l1AbRU3c932xDVsXpIdGJOrQ=;
        b=5lKTMkaHWDdurrUtpo8XZQEEjvfh24/ImNbHlPTjqLiScZ6w/DXzvgP4PIF8B7YJ/v
         abXR9FucWSBIEb0k9MATmZtuw2kOzuCOiGqohUz5XegLgq4xr40MWTFEon8zjwXkvVfp
         OCISsuJsXJtN2WGxTv5JMsvn+AJx7ZZyexTl+jrJEhIHUxxmVk1/mRRc36AfRFMsNIjw
         8mHBzgdb5QQz1HP+E9itc9+9j/zTP7tgFKHXB99BURMjYrcnuBuKqZixdass5Xs0t0Pl
         03bdya6252aGOgVnxgIkEyphVcJYW6V7PWrjLyv0V8TvVPLd8JoVkcKS47Fbq31rb19G
         8CeA==
X-Gm-Message-State: AOAM533P2SfQMvjkcL9EIluQ7X3EoMbiTvbN1T6k6mHfMOgoZnJDNYbo
        cwqZwCMAQxFi+xcKnSP3E3JFyR0BVhWR
X-Google-Smtp-Source: ABdhPJzq7F0HIvX+HNKivSfbV1x5ZTlVJPloR1co4VbUadyRLqRwx5DRYLGw8MvzuMhDYyd7Cv5Zq3lt07td
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:c643:b0:141:cf6b:6999 with SMTP id
 s3-20020a170902c64300b00141cf6b6999mr13246105pls.80.1636766583281; Fri, 12
 Nov 2021 17:23:03 -0800 (PST)
Date:   Sat, 13 Nov 2021 01:22:31 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-9-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 08/11] Docs: KVM: Rename psci.rst to hypercalls.rst
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the doc now covers more of general hypercalls'
details, rather than just PSCI, rename the file to a
more appropriate name- hypercalls.rst.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm/hypercalls.rst
-- 
2.34.0.rc1.387.gb447b232ab-goog

