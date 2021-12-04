Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7922468122
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 01:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383712AbhLDAYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 19:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383687AbhLDAYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 19:24:18 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA0AC061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 16:20:54 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id iq11so3513824pjb.3
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 16:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dJAWGyN2ukKDyc0b6Q6InF5r+fpRoS4WfU0DlLi+X9g=;
        b=dxW+Y28b9awaqqn5iIDBZZbxrk00KGdXgECE7UWSWVREWXo1Wo6+HetRqB5M+HjnQg
         kE8axc+TqbkYfzRZQdWww9AOyKD99J3TTlIkVzEsU5L1TNThRnFUzPp3nHA4ATVDBEdK
         EXaN9gam7rZ4bIXjA3/lhihzMuiJIsdV1QMcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dJAWGyN2ukKDyc0b6Q6InF5r+fpRoS4WfU0DlLi+X9g=;
        b=oCy0Q/CkTHG1qAdcRU9LzDfyun2FS2fDKwSdX7/ANpTTfJhErX/H6LJMpxOafw17PQ
         sl0zavdl6JPND9MUfNKtqu3hg787glP/WfSYA+dXjuuuC8t0qOQAVscbYxhiV0Lg86C6
         dG1uoeVDIjg2QLB1BcWAc8djpv/sKt+WVdNBMvCy0ZvGPQtwfcWNkjkLCyYJgVPR/Ja4
         e74oqA9lX9YMO1TOrkNToXLaJfs5PgCEeekivES47eafzsHSgn9SXpWOd3q4E9MyK2L/
         2cxF3iW476sOHsxz8WV/st+dnHq9+VTyGvbm/A6sLrUndSgtb+C7IHNnroWiKJpcEvaC
         GE3w==
X-Gm-Message-State: AOAM530JzLf2CohQMKnzUqgrQ5+sDJ5pDgZVNmt3MT5s30JOXWvvEAZA
        mCnmBfqKC2h1dVg+A0T3oMYB
X-Google-Smtp-Source: ABdhPJx4oXb7ZqmUdLTVCOjRGup8Ps6bBDW/hMP8BcfERITtOLCXbjbwk6dJ/bmFcfokuhg4ARByAQ==
X-Received: by 2002:a17:90a:d3d2:: with SMTP id d18mr17765302pjw.158.1638577254030;
        Fri, 03 Dec 2021 16:20:54 -0800 (PST)
Received: from fedora.ba.rivosinc.com (99-13-229-45.lightspeed.snjsca.sbcglobal.net. [99.13.229.45])
        by smtp.gmail.com with ESMTPSA id r6sm3272402pjg.21.2021.12.03.16.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:20:53 -0800 (PST)
From:   Atish Patra <atishp@atishpatra.org>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Anup Patel <anup.patel@wdc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Subject: [RFC 2/6] RISC-V: Do not print the SBI version during HSM extension boot print
Date:   Fri,  3 Dec 2021 16:20:34 -0800
Message-Id: <20211204002038.113653-3-atishp@atishpatra.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211204002038.113653-1-atishp@atishpatra.org>
References: <20211204002038.113653-1-atishp@atishpatra.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atishp@rivosinc.com>

The HSM extension information log also prints the SBI version v0.2. This
is misleading as the underlying firmware SBI version may be different
from v0.2.

Remove the unncessary printing of SBI version.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kernel/cpu_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/cpu_ops.c b/arch/riscv/kernel/cpu_ops.c
index 1985884fe829..3f5a38b03044 100644
--- a/arch/riscv/kernel/cpu_ops.c
+++ b/arch/riscv/kernel/cpu_ops.c
@@ -38,7 +38,7 @@ void __init cpu_set_ops(int cpuid)
 #if IS_ENABLED(CONFIG_RISCV_SBI)
 	if (sbi_probe_extension(SBI_EXT_HSM) > 0) {
 		if (!cpuid)
-			pr_info("SBI v0.2 HSM extension detected\n");
+			pr_info("SBI HSM extension detected\n");
 		cpu_ops[cpuid] = &cpu_ops_sbi;
 	} else
 #endif
-- 
2.33.1

