Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB4944A4D0
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbhKICmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbhKICmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:00 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7F3C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:15 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id s22-20020a056a0008d600b00480fea2e96cso11983987pfu.7
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0y7vLMxPPl6BScQAMjV8Fjo9DYu63xojaNRWz6NZJZ4=;
        b=DyUrPyS0UzVyIdnSnkJ03UWv3pnOgXolI/cmm/sQiHRzDs6JZCp41VErdDW2z1ZMNn
         Zevovaq4V3Qz6AeSv61OzBja4qAYo979y5f8PFcgtB4oexNXCco4EdEdSgxVSYd6/2af
         lyXWIe/+g2OJ/MPnnRGYliEsWaIuOfP8kznXzW531r3dmZJNs/DGTKMCOi8mQggNpxXC
         xT1CiEqv4VnXyM0AxjdK+kQE+/mBVP1Ocu4ifyfMVvoxFLstR0TGA91fB98+m+g8jxHy
         2YfNaK2gFdNd75nKtNYMcr5o/iuzZ659mIly27tgxWuT7Rs/KEa7/CmPEq45pOdqSiV7
         gXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0y7vLMxPPl6BScQAMjV8Fjo9DYu63xojaNRWz6NZJZ4=;
        b=WU0swJl2V84K3G+qLtZZLoQmKNMM13g+zmtREOi3nHjFg3tRGWKTwoEMeLGNJPrRXm
         kRfQMDvdyVPxWa+CsmO5uIKJ/9WDDIIy/z9/wk3c0D0L7b/ppigdV7G5DQ0La92HHT9a
         z6X+BPFducYbKvV1V3etW30cTJoUjuVuUlm6ASiRDyykjamHimSq2hcF0E8YAn68O/do
         yCRNyJi08juFScEw8EWczCo9HLDCw7Pyg5cfJpWTv605MVAR5NmZJebCNPIsuSbGHGAp
         37HttOVMXsXgqMWtEQvG4JJC3hI0/yDDFPVaDLVfMzfvSvJcv/Pb+iIW42AgXCAm/cvB
         qN2w==
X-Gm-Message-State: AOAM531qSI+SNDR/svuM1aSMnof1CevWn04m5kWsBY+0tFT7MahYMKcp
        JSGF2m0O9Bbi26SS86OMEo3DnJNjvBW0Ca+xHrfS0fFRDEi4qcXMZsZ7+0OVp8Zev0Vm2YvUFeG
        lUvVaE6Z/y+FEveLOWEYupMIfyCofKWrZunWFdesj8IdlnTkAjM5maiFkKshzspk=
X-Google-Smtp-Source: ABdhPJxA15p+zaxKKjY4+9kinUUQXs0xiR2NDdQyVjcdaW+yoPUj15VMTcoiMYFRVxMo0xcpqR82q2PaCEXchg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:b7cb:b0:141:b33a:9589 with SMTP
 id v11-20020a170902b7cb00b00141b33a9589mr3618554plz.9.1636425554628; Mon, 08
 Nov 2021 18:39:14 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:38:50 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 01/17] KVM: selftests: aarch64: move gic_v3.h to shared headers
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move gic_v3.h to the shared headers location. There are some definitions
that will be used in the vgic-irq test.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/{lib => include}/aarch64/gic_v3.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename tools/testing/selftests/kvm/{lib => include}/aarch64/gic_v3.h (100%)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.h b/tools/testing/selftests/kvm/include/aarch64/gic_v3.h
similarity index 100%
rename from tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
rename to tools/testing/selftests/kvm/include/aarch64/gic_v3.h
-- 
2.34.0.rc0.344.g81b53c2807-goog

