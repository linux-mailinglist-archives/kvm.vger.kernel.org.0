Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1020592C37
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbiHOKOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 06:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242353AbiHOKOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 06:14:12 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DB623172
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:48 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id l64so6178025pge.0
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=NFI4iB+UHezwM44HyP+W9zbdyr5vn5eBh20flsroNPs=;
        b=Y+44aFgNpEEEjaK/CnRTH3/5/Py/HNPRQbOQ18t1h8+GF0YSx7n2dlxJcGrOrH0WWF
         7E4dgBcZTXdEcR4HzpqQXEPJOX2yi5qOORFUDudIg5AWyDsRWn8OXAuUamhHNhyqREMo
         gSgXC0xUI1B7G8dHegmMdbtYRBVbky4z+eHDrSHev0TitMOV8uZigMI+08pEjFhU/pCM
         ZxcEaQNYhpg0hMp9Ev/9vfvdx1TvX5Sa9z3IGiN9hCYcvmgTBePlkoFF0rcR6pr8gRKl
         RZOOUh3yauPMwW14qHN54YBEGv3wEVl6Q9cOsA31yaGTUfQ/wAzSOriBCKu6mL0c4nfZ
         TheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=NFI4iB+UHezwM44HyP+W9zbdyr5vn5eBh20flsroNPs=;
        b=R7Gh0y1xm9aotkdIOC/GtRSm1swp45jiThkVx0whowaUMvDgag0xtxOzlkHFOoxgkU
         oM0g+n5QZjWUmAz5YOimSxXjvgkJysfOG88azLeJ+qDxzBvUxV/OWmUr2fzKkMvEL768
         mYkSm6q+dmEr7bvPGvYUN2LgOEPvrdQLqVU35B/LQAsdj+zxDOxt7Jyyyj7GfgleHw9m
         /udNleR7YjaLtXuPCtjK9+Rc9ZYk+Z2TDyItIy63yDKcrUaogv18Ju5qz/RbGzAnyypz
         nnnmf2SE6HDhkS8JXkYWeWrzU/JAbslhMOCmF4SXZFqu14XWbPXCcD+FbMQ42oe9/3s5
         HqiQ==
X-Gm-Message-State: ACgBeo1VsaCy1MG6MI7TwT5Fq2mVbX67zBhgD8+GqdvyhwVxi3wrISNQ
        IcJbJV5eLAt+N8AF1YEnpxkryw==
X-Google-Smtp-Source: AA6agR6oiXJ7oU1w75pkwZmpTNKAqNtY2PKc06shHaaREiVluuOfI9no4iv7bol0V4Yw/IeXhNrGDQ==
X-Received: by 2002:a05:6a00:21c8:b0:52b:ffc0:15e7 with SMTP id t8-20020a056a0021c800b0052bffc015e7mr15757266pfj.29.1660558427410;
        Mon, 15 Aug 2022 03:13:47 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.84.46])
        by smtp.gmail.com with ESMTPSA id i190-20020a6254c7000000b0052d4f2e2f6asm6267437pfb.119.2022.08.15.03.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 03:13:46 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 3/5] riscv: Add Svpbmt extension support
Date:   Mon, 15 Aug 2022 15:43:23 +0530
Message-Id: <20220815101325.477694-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220815101325.477694-1-apatel@ventanamicro.com>
References: <20220815101325.477694-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Svpbmt extension allows PTE based memory attributes in page tables.
This extension also allows Guest/VM to use PTE based memory attributes
in VS-stage page tables so let us add it Guest/VM ISA string when KVM
RISC-V supports it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 1818cf7..eb7851e 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -17,6 +17,7 @@ struct isa_ext_info {
 };
 
 struct isa_ext_info isa_info_arr[] = {
+	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
-- 
2.34.1

