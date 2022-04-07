Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F9E4F70BB
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238872AbiDGBVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240437AbiDGBUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:20:00 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6171868BD
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 18:16:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l6-20020a170903120600b0014f43ba55f3so1957292plh.11
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 18:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sXF/n8xvBk0FaoqPxko9Blx99fwDwCfccorRyyHCGmI=;
        b=Ku987wK6rt+m7eJsyZLO6atNDPGpbqe4iAXnvp/z+wT4OAEoeg5o3OAlVCchPx2L90
         102SSaR5cOkN6fP9KK1z++y2/yupbiYjbDvWjD2Qece4MWsVopP3FCXHX4y/zHjbpWC1
         gPOj/Frc3z6/rMyZik2wcjHitIQ4/twgDnejS7ftwlIb7sbfGEUikTJBplt2AK2+GVaZ
         07sKnoPUR6sFzjL+MzpauXdv8UdFJexw9xi8RG6979lRl0UQdLY95bXFxQyCZdMoIbFU
         0VtliYgcNZH8l/+6VtdO2QrethSXUAVc7WRMaO/7ps9olTMrNkeZKKeVqELA9bxuRt6C
         2ERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sXF/n8xvBk0FaoqPxko9Blx99fwDwCfccorRyyHCGmI=;
        b=XCYDzKFynPCdwbTdCMahGJvGYcILNltU3PMUcHjVQkdHw23IFQqXeYBAyDR9uswn2/
         qP2UpmDgGgOGYWB5gDq3Tys0jV8qMwYUJJ79YBayddEDDTz8lW+KJ9DTeOwkCpcdVL5Y
         iu52yjdOPzNaVQbnN9QIlIYNYys2e6EoF5hMhmh/wDg3vl7/RqB6inZCxDvg7Uf/e2QH
         G+xVzDkL/iwOCmW6+0fLWsiBJGLfioF1Yups5uf+k91F4lAg+f4r/pxEjKj9Ozsjmi9c
         XfZZNbx7e3Gfg64N+GiD93Ui5D8iSDJZp5i8ivn2mlMwxLA5S7q7XMV94ksVHrOAXvZZ
         1YVw==
X-Gm-Message-State: AOAM530tgCClsd/HOp4CMXo7mpUiXyBXqm8Mi42q6DttBmNUkbMyDbUW
        VuCOhF8vgvn+JRU0pHPFb/A/GAAM/CtK
X-Google-Smtp-Source: ABdhPJw2dezSQVSintcsyWAePk4VuF7JuHzdsneJX2UxM+MFRSiIefC4mvBoj4uqrdxw8cb/zhGbCkzWilbb
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:440c:b0:4fa:da3f:251c with SMTP
 id br12-20020a056a00440c00b004fada3f251cmr11599625pfb.73.1649294181092; Wed,
 06 Apr 2022 18:16:21 -0700 (PDT)
Date:   Thu,  7 Apr 2022 01:16:00 +0000
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Message-Id: <20220407011605.1966778-6-rananta@google.com>
Mime-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 05/10] Docs: KVM: Rename psci.rst to hypercalls.rst
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the doc also covers general hypercalls' details,
rather than just PSCI, and the fact that the bitmap firmware
registers' details will be added to this doc, rename the file
to a more appropriate name- hypercalls.rst.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm/hypercalls.rst
-- 
2.35.1.1094.g7c7d902a7c-goog

