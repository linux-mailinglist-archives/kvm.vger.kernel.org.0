Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3920D51B2C9
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379767AbiEDXAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380040AbiEDW7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:39 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FED5641A
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:46 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id f7-20020a6547c7000000b003c600995546so782699pgs.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xQGuZKK7b+/H3Nkh3wUrCN2rrVMkaOXKv5C35+MWASU=;
        b=Oe9B9UsSVusR3pQ2JrM50arKEFMmB69hMSq6t+7RnyUHVWW0YqwpuG7rwWRDJvb2NO
         UMYj7sAtuO62xK1NlfqFCXsOllJGwtIezvamJC44lLW3IpH/piDm4KFMCK/PlTCe0+MT
         /aQ3yDz4aI/HBEn1bTfsaBqs5zYgWpeHOYoIoo3XChH6zEeDkPpkH++7RCvMFu4YYx+c
         e/Tfr+xgFAwOCeYKdezYmmESkC18i+HwrB0S+ckOhLUCk52c5uT7QBVkqExAXiWYVOXa
         lhlh8xObHiHJ+8Y+SF6X1dWCL8ONS1TNMQRJn0U6Ors9xt4f+GuZCSWmAmqYqEqzIO43
         Ccng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xQGuZKK7b+/H3Nkh3wUrCN2rrVMkaOXKv5C35+MWASU=;
        b=wZWqyQkF9thLNWzXZbddg2fqarz1vDJADKe0LNmd6oU7swzqY3g7uSo1N5aB9Bl2Ui
         rObhq/2pZhc5H78PE7Om7NcIoDUeStcafIEucLXmmZymvm0KiH8LE3dcab4BASsEGBvo
         qsGdBhHmeWkf75+C7IVujULd8ffS4LFj74qQAKUy88SohkizsAHwLCKANzxBu2WZgb17
         wEgiCY2NSVKomUDfWgaH4RH7+QXY+ENySyaV24C7QiOieU2quxtRKc0HG+JYz56RXmMV
         kMG/PFQ0AbY9A6Z2eqnVxVDMmkQ6bz3C4NaYrg9KGX1DFvwTHk9voGDjTdAdt6N/M0Uv
         +YbQ==
X-Gm-Message-State: AOAM531aIuBLHn5koaMrBSwusvnVtUIFlcuEYH442QqFJ6gYbzb5NLud
        zKWOBrVVDk+9u5kohPOq5qVOVy8mOu0=
X-Google-Smtp-Source: ABdhPJzQ5iFt+wDvqEZsICkqePK+g/ZRYK5FOJbSyWq1hVg1sUT+jQQgmddsX7SlvxTE7z7lex0qxelKIVo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1492:b0:50e:11ae:f62f with SMTP id
 v18-20020a056a00149200b0050e11aef62fmr9544148pfu.43.1651704744763; Wed, 04
 May 2022 15:52:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:47 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-102-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 101/128] KVM: selftests: Fix typo in vgic_init test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

When iterating over vCPUs, invoke v3_redist_reg_get() on the "current"
vCPU instead of vCPU0, which is presumably what was intended by iterating
over all vCPUs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 32dac03f5600..f8d41f12bdca 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -418,7 +418,7 @@ static void test_v3_typer_accesses(void)
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
 	for (i = 0; i < NR_VCPUS ; i++) {
-		ret = v3_redist_reg_get(v.gic_fd, 0, GICR_TYPER, &val);
+		ret = v3_redist_reg_get(v.gic_fd, i, GICR_TYPER, &val);
 		TEST_ASSERT(!ret && !val, "read GICR_TYPER before rdist region setting");
 	}
 
-- 
2.36.0.464.gb9c8b46e94-goog

