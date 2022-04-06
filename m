Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095E44F5B0A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 12:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351461AbiDFKIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 06:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350292AbiDFKHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 06:07:18 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A5B167D7;
        Tue,  5 Apr 2022 23:37:21 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c23so1188606plo.0;
        Tue, 05 Apr 2022 23:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=178v+2eeLy/i2YxxOM2MxsSyPkIs9vt2b2wC28WJpwY=;
        b=plbfLdzwusch23L7GBX2E2N6PFuA10057hu77bmzY+HEVhsGFlVcUgLz5tSG2AiXu0
         VatAecZ5SokNI4zn539AA1zevwnVFWOdRA9zNQe4xpeXBfCOjnTssQ09NptrBAtQoduA
         IMnDyMjGBQe779KoiLOYYW2Qw5R/1SxmlmYlqmCRBSyqWNu+h0VLL/CrXrsU/DuhwerV
         kZDEmMHrPfmKlTcnb6kAHIIvjfmKlDXozTzP3niAyiW+tkHT9OhzzE0e2e+6n7GIEF++
         o9xe+ShEZTszQZKODYVt+p9YnhK5Q1ilMOfxl0X6Qn6w0FAU/3tPxy09OWlM2vt3L61f
         tKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=178v+2eeLy/i2YxxOM2MxsSyPkIs9vt2b2wC28WJpwY=;
        b=QyVgz1hFXlbopoI4AWQt4wdfLxBc9o3iUo5ibdzABudNpDkY/KvlJSe4+8ezsHRFVY
         O2b45l2eLv95r+qfCaMi4KawBZ5/VI1pu9YOhGti0Mc6OE1b9lEnmSZHZNp6dj2ligHZ
         UJ/o55kQqNiMCjdqQJIj3t67cnkvuIBJJkA/6LDr8FHh5QA3ef95u5t/twy5/ujoKDow
         zsxQ6Er+UOfV91lM9AoqE2fefU1VccVAviEcJituPqgtXiy9hAp+O2pbvR7x+hJ1+Q/8
         QIOvVB6mb8dvQJDQbaDnZRjBjN3JYqz8dKvgfzd3UI9a25Blryp3weJwcNRpvJXrRLK5
         bkaQ==
X-Gm-Message-State: AOAM531UB1so8DKyj9uGss9pDoAJ6QyxF/FpQUqerzF+ZeqJ6cAgqBc0
        2PSSHUrL7OK8gbkr/oP4fsw=
X-Google-Smtp-Source: ABdhPJwh35acJi7WAWhrFZwqiZsnx/DJxfGiCWiChMTA3e1zx/fMK0NQ88hSU7GJxm7myeA1TsEI6w==
X-Received: by 2002:a17:90a:4604:b0:1bc:8bdd:4a63 with SMTP id w4-20020a17090a460400b001bc8bdd4a63mr8257189pjg.147.1649227040590;
        Tue, 05 Apr 2022 23:37:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id bt18-20020a056a00439200b004faad3ae59esm17286650pfb.95.2022.04.05.23.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 23:37:20 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] kvm: minor fixes and cleanups
Date:   Wed,  6 Apr 2022 14:37:11 +0800
Message-Id: <20220406063715.55625-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Another new kernel cycle starts ticking and my bot seems to have some
complaints about some new changes. Please check if any of them helps.

Like Xu (4):
  KVM: x86/xen: Remove the redundantly included header file lapic.h
  selftests: kvm: add tsc_scaling_sync to .gitignore
  selftests: kvm/x86/xen: Replace a comma in the xen_shinfo_test with
    semicolon
  Documentation: KVM: Add SPDX-License-Identifier tag

 Documentation/virt/kvm/vcpu-requests.rst             | 2 ++
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 2 ++
 Documentation/virt/kvm/x86/errata.rst                | 2 +-
 Documentation/virt/kvm/x86/running-nested-guests.rst | 2 ++
 arch/x86/kvm/xen.c                                   | 1 -
 tools/testing/selftests/kvm/.gitignore               | 1 +
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 2 +-
 7 files changed, 9 insertions(+), 3 deletions(-)

-- 
2.35.1

